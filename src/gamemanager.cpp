#include "gamemanager.h"

#include <QDebug>
#include <QVariantMap>

GameManager::GameManager(GameRepository *repository, QObject *parent)
    : QObject(parent),
    m_repository(repository)
{
    // Make the connections
    connect(this, &GameManager::gamesChanged,
            this, &GameManager::rebuildDisplayGames);

    connect(this, &GameManager::sortModeChanged,
            this, &GameManager::rebuildDisplayGames);

    connect(this, &GameManager::ascendingChanged,
            this, &GameManager::rebuildDisplayGames);

    connect(this, &GameManager::filterTextChanged,
            this, &GameManager::rebuildDisplayGames);

    // Load games from the repository (SQLite or any other backend)
    m_games = m_repository->loadGames();

    // Notify the ui that games are available
    emit gamesChanged();
}

/*
    Expose structured info about games to QML.
    QVariantMap maps cleanly to JS objects.
*/
QVariantList GameManager::games() const
{
    // qDebug() << "-- GameManager::games() called";
    QVariantList list;

    for (const auto &g : m_games)
    {
        QVariantMap m;
        m["name"] = g.name;
        m["posterUrl"] = g.posterUrl;
        m["dateAdded"] = g.dateAdded;
        m["executablePath"] = g.executablePath;
        m["dateAdded"] = g.dateAdded.toString("yyyy-MM-dd HH:mm");
        m["lastPlayed"] = g.lastPlayed.isValid()
                              ? g.lastPlayed.toString("yyyy-MM-dd HH:mm")
                              : "Never";
        m["playtimeMin"] = g.totalPlaytimeSec / 60;
        m["totalPlaytimeSec"] = g.totalPlaytimeSec;
        list << m;
    }

    return list;
}

QVariantList GameManager::displayGames() const
{
    QVariantList list;

    for (const auto &g : m_displayGames)
    {
        QVariantMap m;
        m["name"] = g.name;
        m["posterUrl"] = g.posterUrl;
        m["dateAdded"] = g.dateAdded;
        m["executablePath"] = g.executablePath;
        m["dateAdded"] = g.dateAdded.toString("yyyy-MM-dd HH:mm");
        m["lastPlayed"] = g.lastPlayed.isValid()
                              ? g.lastPlayed.toString("yyyy-MM-dd HH:mm")
                              : "Never";
        m["playtimeMin"] = g.totalPlaytimeSec / 60;
        m["totalPlaytimeSec"] = g.totalPlaytimeSec;
        list << m;
    }

    return list;

}

int GameManager::sortMode() const {
    return m_sortIndex;
}

// Launch a game given index
void GameManager::launchGame(const QString &name)
{
    int index = -1;
    for(int i=0; i<m_games.length(); i++)
    {
        if(m_games[i].name == name) {
            index = i;
            break;
        }
    }

    if (index == -1) {
        qWarning() << "Game " << name << "Doesn't Exist!";

    }

    Game &game = m_games[index];

    auto *session = new GameSession(
        index,
        game.name,
        game.executablePath,
        this);

    // Record session start in DB immediately
    m_repository->recordSessionStart(game.name);

    connect(session, &GameSession::sessionEnded,
            this, &GameManager::onSessionEnded);

    m_activeSessions.append(session);
    game.lastPlayed = QDateTime::currentDateTime();

    session->start();

    // Notify the ui about the `lastPlayed` change
    emit gamesChanged();
}

// Record a session on game closed
// see GameManager::launchGame for connection to the GameSession::sessionEnded signal
void GameManager::onSessionEnded(GameSession *session)
{
    Game game = m_games[session->gameId()];

    // Update in-memory stats for UI only
    game.totalPlaytimeSec += session->durationSeconds();
    game.lastPlayed = QDateTime::currentDateTime();

    // Persist session in DB (handles total playtime + lastPlayed)
    m_repository->recordSessionEnd(game.name, session->durationSeconds());

    // Remove the session from active sessions
    m_activeSessions.removeOne(session);
    session->deleteLater();

    // Notify the ui about the `totalPlaytime` and `lastPlayed` changes
    emit gamesChanged();
}

// Add a new game to the library
void GameManager::addGame(const QString &name, const QString &exePath, const QString &posterUrl)
{
    Game game;
    game.name = name;
    game.executablePath = exePath;
    game.posterUrl = posterUrl;
    game.dateAdded = QDateTime::currentDateTime();

    // Add the game if it's not already in the db
    for(auto& g : m_games) {
        if(g.name == game.name) {
            qWarning() << "Game " << game.name << "already exists";
            return;
        }
    }

    // Add to in-memory m_games list
    m_games.append(game);

    // Persist to DB
    m_repository->addGame(game);

    // Notify the ui about the new game in `m_games`
    emit gamesChanged();
}

// Remove a game from the library
void GameManager::removeGame(const QString &name)
{
    // Find and remove from in-memory list
    for(int i = 0; i < m_games.size(); ++i) {
        if(m_games[i].name == name) {
            qInfo() << "Removing game:" << name;
            m_games.removeAt(i);
            // Remove from database
            m_repository->removeGame(name);
            // Notify the UI
            emit gamesChanged();
            return;
        }
    }
    qWarning() << "Game" << name << "not found, cannot remove";
}

// Update info about a game
// From QML, pass a js object with fields defined in the Game class
void GameManager::updateGame(const QString &name, const QVariantMap& fields)
{
    for(auto& g : m_games) {
        if(g.name == name) {
            qInfo() << "Updating " << g.name;

            // Update the in-memory copy of the game
            if (fields.contains("name"))
            {
                g.name = fields["name"].toString();
                qInfo() << "  Updated name:" << g.name;
            }

            if (fields.contains("executablePath")){
                g.executablePath = fields["executablePath"].toString();
                qInfo() << "  Updated executablePath:" << g.executablePath;
            }

            if (fields.contains("posterUrl")) {
                g.posterUrl = fields["posterUrl"].toString();
                qInfo() << "  Updated posterUrl:" << g.posterUrl;
            }

            if (fields.contains("totalPlaytimeSec")) {
                g.totalPlaytimeSec = fields["totalPlaytimeSec"].toLongLong();
                qInfo() << "  Updated totalPlaytimeSec:" << g.totalPlaytimeSec;
            }

            if (fields.contains("lastPlayed")) {
                g.lastPlayed = fields["lastPlayed"].toDateTime();
                qInfo() << "  Updated lastPlayed:" << g.lastPlayed;
            }

            // Persist changes to this game in the db
            m_repository->updateGame(g);

            break;
        }
    }

    // Notify the ui about the updated fields
    emit gamesChanged();
}

// Sort Mode 0: playtime
// Sort Mode 1: last played date
// Sort Mode 2: added
void GameManager::setSortMode(int sortIndex) {
    if (m_sortIndex == sortIndex)
        return;

    m_sortIndex = sortIndex;
    emit sortModeChanged();
}

void GameManager::setAscending(bool isAscending)
{
    if (m_isAscending == isAscending)
        return;

    m_isAscending = isAscending;
    emit ascendingChanged();
}

void GameManager::setFilterText(const QString &filterText)
{
    if (m_filterText == filterText)
        return;

    m_filterText = filterText;
    emit filterTextChanged();
}

// Filter and Sort the displayGames list when necessary
void GameManager::rebuildDisplayGames()
{
    m_displayGames.clear();

    // 1. filter
    for (const Game &g : m_games) {
        if (m_filterText.isEmpty() ||
            g.name.contains(m_filterText, Qt::CaseInsensitive)) {
            m_displayGames.push_back(g);
        }
    }

    // 2. sort
    std::sort(m_displayGames.begin(), m_displayGames.end(),
              [&](const Game &a, const Game &b) {
                  bool less = false;
                  switch (m_sortIndex) {
                      //TODO: implement actual sort strategies
                  case 0:
                      less = a.totalPlaytimeSec < b.totalPlaytimeSec;
                      break;
                  case 1:
                      less = a.lastPlayed < b.lastPlayed;
                      break;
                  case 2:
                      less = a.dateAdded < b.dateAdded;
                      break;
                  case 3:
                      less = a.name < b.name;
                      break;
                  }
                  return m_isAscending ? less : !less;
              });

    emit displayGamesChanged();
}
