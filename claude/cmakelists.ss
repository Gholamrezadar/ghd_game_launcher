cmake_minimum_required(VERSION 3.16)

project(ghd_game_launcher VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Core)
find_package(Qt6 REQUIRED COMPONENTS Sql)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appghd_game_launcher
    main.cpp
)

qt_add_qml_module(appghd_game_launcher
    URI ghd_game_launcher
    QML_FILES
        Main.qml
        components/IconToolButton.qml
        components/SearchBar.qml
        components/GameCardDelegate.qml
        components/GameListDelegate.qml
        AddNewWindow.qml
    SOURCES 
        gamemanager.h 
        gamemanager.cpp
        game.h
        gamesession.h 
        gamesession.cpp
        sqliterepository.h 
        sqliterepository.cpp
        gamerepository.h
    RESOURCES 
        resources.qrc
)

# Add Theme singleton module separately
qt_add_qml_module(theme_module
    URI theme
    QML_FILES
        theme/Theme.qml
    NO_PLUGIN
    OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/theme
)

# Link the theme module to the main executable
target_link_libraries(appghd_game_launcher PRIVATE theme_moduleplugin)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appghd_game_launcher PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appghd_game_launcher
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appghd_game_launcher
    PRIVATE 
        Qt6::Quick 
        Qt6::Sql
        Qt6::Core
)

include(GNUInstallDirs)
install(TARGETS appghd_game_launcher
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)