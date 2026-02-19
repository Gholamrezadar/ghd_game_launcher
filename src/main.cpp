#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSurfaceFormat>

#include "gamemanager.h"
#include "sqliterepository.h"

int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Register GameManager as a QML type
    qmlRegisterType<GameManager>("ghd_game_launcher", 1, 0, "GameManager");
    qmlRegisterType<Game>("ghd_game_launcher", 1, 0, "Game");

    // Create the GameRepository (Sqlite Implementation)
    SQLiteRepository repo("games.db");

    // Create the backend and expose it to QML
    GameManager gameManager(&repo);
    engine.rootContext()->setContextProperty("gameManager", &gameManager);

    // Add some default games
    gameManager.addGame("Hades", "D:\\Games\\Hades I\\x64\\Hades.exe", "C:\\Users\\EXO\\Pictures\\poster_hades.png");
    gameManager.addGame("Hollow Knight: Silksong", "D:\\Games\\Hades I\\x64\\Hades.exe", "C:\\Users\\EXO\\Pictures\\poster_silksong.png");
    gameManager.addGame("Hollow Knight", "D:\\Games\\Hades I\\x64\\Hades.exe", "C:\\Users\\EXO\\Pictures\\poster_hk.png");
    gameManager.addGame("Hades 2", "D:\\Games\\Hades I\\x64\\Hades.exe", "C:\\Users\\EXO\\Pictures\\poster_hades.png");
    gameManager.addGame("Hollow Knight: Silksong 2", "D:\\Games\\Hades I\\x64\\Hades.exe", "C:\\Users\\EXO\\Pictures\\poster_silksong.png");
    gameManager.addGame("Hades 3", "D:\\Games\\Hades I\\x64\\Hades.exe", "C:\\Users\\EXO\\Pictures\\poster_hades.png");
    gameManager.addGame("Hollow Knight2", "D:\\Games\\Hades I\\x64\\Hades.exe", "C:\\Users\\EXO\\Pictures\\poster_hk.png");
    gameManager.addGame("Hollow Knight 3", "D:\\Games\\Hades I\\x64\\Hades.exe", "C:\\Users\\EXO\\Pictures\\poster_hk.png");
    gameManager.addGame("Hades 4", "D:\\Games\\Hades I\\x64\\Hades.exe", "C:\\Users\\EXO\\Pictures\\poster_hades.png");
    gameManager.addGame("Hollow Knight: Silksong 3", "D:\\Games\\Hades I\\x64\\Hades.exe", "C:\\Users\\EXO\\Pictures\\poster_silksong.png");
    gameManager.addGame("Hollow Knight 4", "D:\\Games\\Hades I\\x64\\Hades.exe", "C:\\Users\\EXO\\Pictures\\poster_hk.png");
    gameManager.addGame("Hollow Knight: Silksong 4", "D:\\Games\\Hades I\\x64\\Hades.exe", "C:\\Users\\EXO\\Pictures\\poster_silksong.png");

    engine.loadFromModule("ghd_game_launcher", "Main");
    // engine.loadFromModule("ghd_game_launcher", "Testing");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
