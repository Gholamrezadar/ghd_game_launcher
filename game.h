#pragma once

#include <QString>
#include <QDateTime>

/*
    Represents a game entry in the launcher.

    This maps almost 1:1 to a future SQLite table.
*/
struct Game
{
    QString name;
    QString executablePath;

    // Metadata (not all shown yet)
    QString posterUrl;          // future UI use
    QDateTime dateAdded;

    // Stats
    qint64 totalPlaytimeSec = 0;
    QDateTime lastPlayed;
};
