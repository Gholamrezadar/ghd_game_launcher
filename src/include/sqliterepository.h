#pragma once

#include <QSqlDatabase>
#include "gamerepository.h"

/*
    SQLiteRepository provides the concrete implementation of GameRepository using SQLite.
    
    Responsibilities:
    - Initialize and manage the connection to the local SQLite database file
    - Automatically create necessary schema tables if they do not exist
    - Implement the full CRUD (Create, Read, Update, Delete) cycle for Game objects
    - Execute SQL queries to aggregate session data and generate playtime charts
    
    This class is the only component responsible for direct SQL execution,
    ensuring that the rest of the application deals only with high-level C++/Qt objects.
*/
class SQLiteRepository : public GameRepository
{
public:
    explicit SQLiteRepository(const QString &dbPath);
    ~SQLiteRepository();

    // Load all games from DB
    QVector<Game> loadGames() override;

    // Add or update games
    void addGame(const Game &game) override;
    void removeGame(const QString &gameName) override;
    void updateGame(const Game &game) override;

    // Record session start and end
    void recordSessionStart(const QString &gameName) override;
    void recordSessionEnd(const QString &gameName, qint64 durationSec) override;

    // Get stats
    int getGameSessionCount(const QString &gameName) const override;
    qint64 getGameMaxSessionDuration(const QString &gameName) const override;

    // Get sessions
    QVariantList getSessions(const QString &gameName) const override;

    // Game Playtime Chart
    QVariantList getPlaytimeChartData(const QString &gameName, int numberOfDays = 30) const override;

private:
    QSqlDatabase m_db;

    void initDatabase(); // Create tables if missing
    void addDefaultGamesIfEmpty(); // add hardcoded games
};
