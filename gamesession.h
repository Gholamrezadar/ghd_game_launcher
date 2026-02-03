#pragma once

#include <QObject>
#include <QProcess>
#include <QDateTime>

/*
    GameSession represents ONE running process.
    Multiple sessions can exist at the same time.
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
    /*
        Emitted when the session ends.
        GameManager listens to this to update stats.
    */
    void sessionEnded(GameSession *session);

private:
    int m_gameId;
    QString m_gameName;
    QString m_executablePath;

    QProcess *m_process = nullptr;
    QDateTime m_startTime;
    QDateTime m_endTime;
};
