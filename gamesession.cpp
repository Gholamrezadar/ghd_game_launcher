#include "gamesession.h"

#include <QDebug>

GameSession::GameSession(int gameId,
                         const QString &gameName,
                         const QString &executablePath,
                         QObject *parent)
    : QObject(parent),
    m_gameId(gameId),
    m_gameName(gameName),
    m_executablePath(executablePath)
{
}

void GameSession::start()
{
    m_process = new QProcess(this);

    // connect to started signal of Qprocess
    connect(m_process, &QProcess::started, this, [this]() {
        m_startTime = QDateTime::currentDateTime();
        qDebug() << "Session started:" << m_gameName
                 << m_startTime.toString(Qt::ISODate);
    });

    // connect to finished signal of Qprocess
    connect(
        m_process,
        QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
        this,
        [this](int, QProcess::ExitStatus) {
            m_endTime = QDateTime::currentDateTime();
            qDebug() << "Session ended:" << m_gameName
                     << m_endTime.toString(Qt::ISODate);

            emit sessionEnded(this);
        });

    // connect to errorOccurred signal of Qprocess
    connect(m_process, &QProcess::errorOccurred, this, [this](QProcess::ProcessError error) {
        qDebug() << "Failed to start " << m_gameName
                 << error;
    });

    m_process->start(m_executablePath);
}

QString GameSession::gameName() const
{
    return m_gameName;
}

int GameSession::gameId() const
{
    return m_gameId;
}

qint64 GameSession::durationSeconds() const
{
    if (!m_startTime.isValid() || !m_endTime.isValid())
        return 0;

    return m_startTime.secsTo(m_endTime);
}
