#pragma once

#include <QSqlDatabase>
#include "gamerepository.h"

/*
    SQLite-backed implementation of GameRepository.

    Responsibilities:
    - Open SQLite database
    - Create tables if missing
    - Load/save Game objects
    - Record session start/end and update playtime
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

    // Game Playtime Chart
    QVariantList getPlaytimeChartData(const QString &gameName, int numberOfDays = 30) const override;

private:
    QSqlDatabase m_db;

    void initDatabase(); // Create tables if missing
    void addDefaultGamesIfEmpty(); // add hardcoded games
};
