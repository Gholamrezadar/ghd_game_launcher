#pragma once

#include <QObject>
#include <QVector>
#include <QStringList>
#include <QSortFilterProxyModel>

#include "game.h"
#include "gamesession.h"
#include "gamerepository.h"

/*
    GameManager owns:
    - the game library
    - active sessions
    - session → game stat updates
*/
class GameManager : public QObject
{
    Q_OBJECT

    // Properties
    Q_PROPERTY(QVariantList games READ games NOTIFY gamesChanged)
    Q_PROPERTY(QVariantList displayGames READ displayGames NOTIFY displayGamesChanged)
    Q_PROPERTY(int sortMode READ sortMode WRITE setSortMode NOTIFY sortModeChanged)

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

    Q_INVOKABLE int getGameSessionCount(const QString &name) const;
    Q_INVOKABLE qint64 getGameMaxSessionDuration(const QString &name) const;

    //TODO: remove these
    Q_INVOKABLE QVariantList getPast30DaysPlaytime(const QString &name) const;
    Q_INVOKABLE QVariantList getFakePast30DaysPlaytime(const QString &name) const;

    Q_INVOKABLE QVariantList getPlaytimeChartData(const QString &name, int numberOfDays = 30) const;


    // Getters for properties
    QVariantList games() const;
    QVariantList displayGames() const;
    int sortMode() const;

signals:
    void gamesChanged();
    void displayGamesChanged();

    void sortModeChanged();
    void ascendingChanged();
    void filterTextChanged();

private:
    QVector<Game> m_games;
    QVector<Game> m_displayGames; // A proxy model for m_games that is filtered and sorted for the ui to display

    int m_sortIndex = 1;
    bool m_isAscending = true;
    QString m_filterText = "";

    QVector<GameSession*> m_activeSessions;
    GameRepository *m_repository;

    void onSessionEnded(GameSession *session);

    void rebuildDisplayGames(); // Filter and Sort
};
