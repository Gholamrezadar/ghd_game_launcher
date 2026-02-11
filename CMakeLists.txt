cmake_minimum_required(VERSION 3.16)

project(ghd_game_launcher VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Core)
find_package(Qt6 REQUIRED COMPONENTS Sql)

qt_standard_project_setup(REQUIRES 6.8)

# Icon setup
set(app_icon_resource_windows "${CMAKE_CURRENT_SOURCE_DIR}/icons/favicon.rc")

# Main Executable setup
qt_add_executable(GHD_Launcher
    src/main.cpp
    ${app_icon_resource_windows}
)

target_include_directories(GHD_Launcher
    PRIVATE
    src/include
)

qt_add_qml_module(GHD_Launcher
    URI ghd_game_launcher
    SOURCES
        src/main.cpp
        src/gamemanager.cpp
        src/gamesession.cpp
        src/sqliterepository.cpp

        src/include/game.h
        src/include/gamemanager.h
        src/include/gamerepository.h
        src/include/gamesession.h
        src/include/sqliterepository.h

    QML_FILES
        ui/windows/Main.qml
        ui/windows/Testing.qml
        ui/windows/AddNewWindow.qml

        ui/components/RoundedImage.qml
        # ui/components/GHDToolButton.qml
        # ui/components/GHDButton.qml
        # ui/components/SearchBar.qml
        # ui/components/GridViewCard.qml
        # ui/components/ListViewCard.qml

        # ui/theme/Theme.qml
    QML_FILES
        resources.qrc

)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(GHD_Launcher PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.GHD_Launcher
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(GHD_Launcher
    PRIVATE Qt6::Quick Qt6::Sql
)
target_link_libraries(GHD_Launcher PRIVATE Qt6::Core)

include(GNUInstallDirs)
install(TARGETS GHD_Launcher
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
