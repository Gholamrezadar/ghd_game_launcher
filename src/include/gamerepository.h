#pragma once

#include <QVector>
#include "game.h"

struct DailyPlaytime {
        QString date;      // YYYY-MM-DD format
        qint64 seconds;    // Total seconds played that day
};

/*
    GameRepository defines HOW GameManager talks to persistence.

    IMPORTANT:
    - No Qt SQL headers here
    - No implementation
    - This is a pure abstraction
*/
class GameRepository
{
public:
    virtual ~GameRepository() = default;

    // Load full game library (on startup)
    virtual QVector<Game> loadGames() = 0;

    // Persist changes
    virtual void addGame(const Game &game) = 0;
    virtual void removeGame(const QString &gameName) = 0;
    virtual void updateGame(const Game &game) = 0;

    // Session-related persistence (later expanded)
    virtual void recordSessionStart(const QString &gameName) = 0;
    virtual void recordSessionEnd(const QString &gameName, qint64 durationSec) = 0;

    // Get stats
    virtual int getGameSessionCount(const QString &gameName) const = 0;
    virtual qint64 getGameMaxSessionDuration(const QString &gameName) const = 0;

    //TODO: Remove this function
    virtual QVector<DailyPlaytime> getPast30DaysPlaytime(const QString &gameName) const = 0;
    
    // Game Playtime Chart
    virtual QVariantList getPlaytimeChartData(const QString &gameName, int numberOfDays = 30) const = 0;
};
