#pragma once

#include <QVector>
#include "game.h"

/*
    GameRepository defines the interface for all database interaction logic.
    
    Responsibilities:
    - Abstract the specific database technology (SQLite, JSON, etc.) from the rest of the app
    - Enforce a consistent API for loading, saving, and updating game data
    - Handle session recording and statistical aggregation
    
    By using this interface, the GameManager remains decoupled from the specific
    storage mechanism, allowing for easy testing and future migration of the database layer.
    
    Derived classes (e.g., SQLiteRepository) will implement these virtual methods
    to provide concrete storage behavior.
*/

class GameRepository
{
public:
    virtual ~GameRepository() = default;

    virtual QVector<Game> loadGames() = 0;

    // Persistence
    virtual void addGame(const Game &game) = 0;
    virtual void removeGame(const QString &gameName) = 0;
    virtual void updateGame(const Game &game) = 0;
    virtual void recordSessionStart(const QString &gameName) = 0;
    virtual void recordSessionEnd(const QString &gameName, qint64 durationSec) = 0;

    // Get stats
    virtual int getGameSessionCount(const QString &gameName) const = 0;
    virtual qint64 getGameMaxSessionDuration(const QString &gameName) const = 0;
    
    // Game Playtime Chart
    virtual QVariantList getPlaytimeChartData(const QString &gameName, int numberOfDays = 30) const = 0;
};
