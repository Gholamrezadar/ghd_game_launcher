#pragma once

#include <QObject>
#include <QProcess>
#include <QDateTime>

/*
    GameSession represents a single running instance of a game process.
    
    Responsibilities:
    - Track the lifecycle of a specific game launch (start to end)
    - Monitor the process to detect if it has terminated
    - Calculate the duration of the session in seconds
*/

class GameSession : public QObject
{
    Q_OBJECT

public:
    explicit GameSession(int gameId,
                         const QString &gameName,
                         const QString &executablePath,
                         QObject *parent = nullptr);

    void start();

    QString gameName() const;
    int gameId() const;
    qint64 durationSeconds() const;

signals:
    // GameManager listens to this to update stats.
    void sessionEnded(GameSession *session);

private:
    int m_gameId;
    QString m_gameName;
    QString m_executablePath;

    QProcess *m_process = nullptr;
    QDateTime m_startTime;
    QDateTime m_endTime;
};
