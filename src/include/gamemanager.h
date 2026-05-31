#pragma once

#include <QObject>
#include <QVector>
#include <QStringList>
#include <QSortFilterProxyModel>

#include "game.h"
#include "gamesession.h"
#include "gamerepository.h"

/*
    GameManager acts as the central controller for the application logic.
    
    Responsibilities:
    - Maintain the in-memory list of all games and their current state
    - Filter and sort the game list for efficient UI rendering
    - Delegate persistence operations to GameRepository
    - Manage active game sessions and trigger UI updates via signals
    - Provide Q_INVOKABLE methods for direct integration with QML

    Architecture Note:
    This class bridges the gap between the raw data model (Game) and the UI,
    ensuring that sorting, filtering, and session tracking happen at the logic
    layer rather than the view layer.
*/
class GameManager : public QObject
{
    Q_OBJECT

    // Properties
    Q_PROPERTY(QVariantList games READ games NOTIFY gamesChanged)
    Q_PROPERTY(QVariantList displayGames READ displayGames NOTIFY displayGamesChanged)
    Q_PROPERTY(int sortMode READ sortMode WRITE setSortMode NOTIFY sortModeChanged)
    Q_PROPERTY(QString currentGame READ currentGame WRITE setCurrentGame NOTIFY currentGameChanged)
    Q_PROPERTY(QVariantList currentGameSessions READ currentGameSessions NOTIFY currentGameSessionsChanged)

public:
    explicit GameManager(GameRepository *repository, QObject *parent = nullptr);

    // UI accessible methods
    Q_INVOKABLE void launchGame(const QString &name);
    Q_INVOKABLE void addGame(const QString &name, const QString &exePath, const QString &posterUrl);
    Q_INVOKABLE void removeGame(const QString &name);
    Q_INVOKABLE void updateGame(const QString &name, const QVariantMap& fields);

    Q_INVOKABLE void setSortMode(int sortIndex);
    Q_INVOKABLE void setAscending(bool isAscending);
    Q_INVOKABLE void setFilterText(const QString &filterText);

    Q_INVOKABLE QVariantList getPlaytimeChartData(const QString &name, int numberOfDays = 30) const;
    Q_INVOKABLE QVariantList getPlaytimeChartDataFullHistory(const QString &name) const;

    Q_INVOKABLE int getGameSessionCount(const QString &name) const;
    Q_INVOKABLE qint64 getGameMaxSessionDuration(const QString &name) const;
    Q_INVOKABLE QVariantList getGameSessions(const QString &name) const;

    Q_INVOKABLE void setCurrentGame(const QString &name);

    // Getters for properties
    QVariantList games() const;
    QVariantList displayGames() const;
    QString currentGame() const;
    QVariantList currentGameSessions() const;
    int sortMode() const;

signals:
    void gamesChanged();
    void displayGamesChanged();

    void sortModeChanged();
    void ascendingChanged();
    void filterTextChanged();

    void currentGameChanged();
    void currentGameSessionsChanged();

private:
    QVector<Game> m_games;
    QVector<Game> m_displayGames; // A proxy model for m_games that is filtered and sorted for the ui to display
    QString m_currentGame;
    QVariantList m_currentGameSessions;

    int m_sortIndex = 1;
    bool m_isAscending = true;
    QString m_filterText = "";

    QVector<GameSession*> m_activeSessions;
    GameRepository *m_repository;

    void onSessionEnded(GameSession *session);

    void rebuildDisplayGames(); // Filter and Sort
};
