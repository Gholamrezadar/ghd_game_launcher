#pragma once

#include <QString>
#include <QDateTime>

/*
    Game represents a single entry in the library.
    
    Responsibilities:
    - Store core metadata (name, executable path, poster URL)
    - Track aggregate statistics (total playtime, last played timestamp)
    - Act as the data model passed between the Repository and the Manager
*/
struct Game
{
    QString name;
    QString executablePath;
    QString posterUrl;
    QDateTime dateAdded;

    // Stats
    qint64 totalPlaytimeSec = 0;
    QDateTime lastPlayed;
};
