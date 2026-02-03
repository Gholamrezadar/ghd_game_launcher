#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "gamemanager.h"
#include "sqliterepository.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Create the GameRepository (Sqlite Implementation)
    SQLiteRepository repo("games.db");

    // Create the backend and expose it to QML
    GameManager gameManager(&repo);
    engine.rootContext()->setContextProperty("gameManager", &gameManager);

    // Add some default games
    gameManager.addGame("Hades", "D:\\Games\\Hades I\\x64\\Hades.exe", "C:\\Users\\EXO\\Pictures\\poster_hades.png");
    gameManager.addGame("Hollow Knight: Silksong", "D:\\Games\\Hades I\\x64\\Hades.exe", "C:\\Users\\EXO\\Pictures\\poster_silksong.png");
    gameManager.addGame("Hollow Knight", "D:\\Games\\Hades I\\x64\\Hades.exe", "C:\\Users\\EXO\\Pictures\\poster_hk.png");
    // TODO: need removeGame and updateGame


    engine.loadFromModule("ghd_game_launcher", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
