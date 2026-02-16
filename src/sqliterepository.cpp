#include "sqliterepository.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QVariant>
#include <QDebug>

SQLiteRepository::SQLiteRepository(const QString &dbPath)
{
    // Open the database connection
    m_db = QSqlDatabase::addDatabase("QSQLITE");
    m_db.setDatabaseName(dbPath);

    if (!m_db.open()) {
        qCritical() << "Failed to open SQLite DB:" << m_db.lastError().text();
        return;
    }

    // Ensure tables exist
    initDatabase();

    // Populate default games if DB is empty
    addDefaultGamesIfEmpty();
}

SQLiteRepository::~SQLiteRepository()
{
    if (m_db.isOpen()) {
        m_db.close();
    }
}

void SQLiteRepository::initDatabase()
{
    QSqlQuery query;

    // Table for games
    if (!query.exec(
            R"(CREATE TABLE IF NOT EXISTS games (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE NOT NULL,
            executable_path TEXT NOT NULL,
            poster_url TEXT,
            date_added INTEGER,
            total_playtime_sec INTEGER DEFAULT 0,
            last_played INTEGER
        ))"
            )) {
        qCritical() << "Failed to create games table:" << query.lastError().text();
    }

    // Table for sessions (optional, can extend later)
    if (!query.exec(
            R"(CREATE TABLE IF NOT EXISTS sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            game_id INTEGER NOT NULL,
            start_time INTEGER NOT NULL,
            end_time INTEGER,
            duration_sec INTEGER,
            FOREIGN KEY(game_id) REFERENCES games(id)
        ))"
            )) {
        qCritical() << "Failed to create sessions table:" << query.lastError().text();
    }
}

void SQLiteRepository::addDefaultGamesIfEmpty()
{
// moved to main.cpp
}

// Load all games from the database
QVector<Game> SQLiteRepository::loadGames()
{
    QVector<Game> games;
    QSqlQuery query("SELECT name, executable_path, poster_url, date_added, total_playtime_sec, last_played FROM games");

    while (query.next()) {
        Game g;
        g.name = query.value(0).toString();
        g.executablePath = query.value(1).toString();
        g.posterUrl = query.value(2).toString();
        g.dateAdded = QDateTime::fromSecsSinceEpoch(query.value(3).toLongLong());
        g.totalPlaytimeSec = query.value(4).toLongLong();
        g.lastPlayed = QDateTime::fromSecsSinceEpoch(query.value(5).toLongLong());

        games.append(g);
    }

    return games;
}

// Add a new game to the database
void SQLiteRepository::addGame(const Game &game)
{
    QSqlQuery query;
    query.prepare(R"(
        INSERT OR IGNORE INTO games (name, executable_path, poster_url, date_added, total_playtime_sec, last_played)
        VALUES (?, ?, ?, ?, ?, ?)
    )");
    query.addBindValue(game.name);
    query.addBindValue(game.executablePath);
    query.addBindValue(game.posterUrl);
    query.addBindValue(game.dateAdded.toSecsSinceEpoch());
    query.addBindValue(game.totalPlaytimeSec);
    query.addBindValue(game.lastPlayed.isValid() ? game.lastPlayed.toSecsSinceEpoch() : QVariant(QVariant::LongLong));

    if (!query.exec()) {
        qCritical() << "Failed to insert game:" << query.lastError().text();
    }
}

// Remove a game from the database
void SQLiteRepository::removeGame(const QString &gameName) {
    QSqlQuery query;
    query.prepare("DELETE FROM games WHERE name = ?");
    query.addBindValue(gameName);
    
    if (!query.exec()) {
        qCritical() << "Failed to remove game:" << query.lastError().text();
    }
}

// Update an existing game (stats like playtime / lastPlayed)
void SQLiteRepository::updateGame(const Game &game)
{
    QSqlQuery query;
    query.prepare(R"(
        UPDATE games
        SET poster_url = ?, total_playtime_sec = ?, last_played = ?
        WHERE name = ?
    )");
    query.addBindValue(game.posterUrl);
    query.addBindValue(game.totalPlaytimeSec);
    query.addBindValue(game.lastPlayed.isValid() ? game.lastPlayed.toSecsSinceEpoch() : QVariant(QVariant::LongLong));
    query.addBindValue(game.name);

    if (!query.exec()) {
        qCritical() << "Failed to update game:" << query.lastError().text();
    }
}

// Record session start (optional: insert into sessions table)
void SQLiteRepository::recordSessionStart(const QString &gameName)
{
    // Look up game_id
    QSqlQuery query;
    query.prepare("SELECT id FROM games WHERE name = ?");
    query.addBindValue(gameName);
    if (!query.exec() || !query.next()) {
        qCritical() << "Failed to find game for session start:" << gameName;
        return;
    }
    int gameId = query.value(0).toInt();

    qint64 startTime = QDateTime::currentSecsSinceEpoch();
    query.prepare(R"(INSERT INTO sessions (game_id, start_time) VALUES (?, ?))");
    query.addBindValue(gameId);
    query.addBindValue(startTime);

    if (!query.exec()) {
        qCritical() << "Failed to record session start:" << query.lastError().text();
    }
}

// Record session end (update last_played, total_playtime_sec, and sessions table)
void SQLiteRepository::recordSessionEnd(const QString &gameName, qint64 durationSec)
{
    QSqlQuery query;

    // Step 1: Update the games table (total playtime and last played)
    qint64 now = QDateTime::currentSecsSinceEpoch();

    query.prepare(R"(UPDATE games
                     SET last_played = ?, total_playtime_sec = total_playtime_sec + ?
                     WHERE name = ?)");
    query.addBindValue(now);
    query.addBindValue(durationSec);
    query.addBindValue(gameName);

    if (!query.exec()) {
        qCritical() << "Failed to update game stats:" << query.lastError().text();
    }

    // Step 2: Find the last session for this game
    query.prepare(R"(SELECT id FROM sessions
                     WHERE game_id = (SELECT id FROM games WHERE name = ?)
                     ORDER BY start_time DESC
                     LIMIT 1)");
    query.addBindValue(gameName);

    if (!query.exec()) {
        qCritical() << "Failed to find last session for game:" << gameName
                    << query.lastError().text();
        return;
    }

    if (!query.next()) {
        qCritical() << "No session found to update for game:" << gameName;
        return;
    }

    int sessionId = query.value(0).toInt(); // The last session ID

    // Step 3: Update the session with end_time and duration
    query.prepare("UPDATE sessions SET end_time = ?, duration_sec = ? WHERE id = ?");
    query.addBindValue(now);
    query.addBindValue(durationSec);
    query.addBindValue(sessionId);

    if (!query.exec()) {
        qCritical() << "Failed to update session record:" << query.lastError().text();
    }
    else {
        qDebug() << "Session updated successfully for game:" << gameName;
    }
}

int SQLiteRepository::getGameSessionCount(const QString &gameName) const
{
    QSqlQuery query;
    query.prepare(R"(
        SELECT COUNT(*) 
        FROM sessions s
        JOIN games g ON s.game_id = g.id
        WHERE g.name = :name
    )");
    query.bindValue(":name", gameName);

    if (query.exec() && query.next()) {
        return query.value(0).toInt();
    }

    qWarning() << "Failed to get session count:" << query.lastError().text();
    return 0;
}

qint64 SQLiteRepository::getGameMaxSessionDuration(const QString &gameName) const
{
    QSqlQuery query;
    query.prepare(R"(
        SELECT MAX(duration_sec) 
        FROM sessions s
        JOIN games g ON s.game_id = g.id
        WHERE g.name = :name
    )");
    query.bindValue(":name", gameName);

    if (query.exec() && query.next()) {
        return query.value(0).toLongLong();
    }

    qWarning() << "Failed to get max session duration:" << query.lastError().text();
    return 0;
}
