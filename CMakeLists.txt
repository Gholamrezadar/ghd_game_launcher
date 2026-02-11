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

# Include dirs
target_include_directories(GHD_Launcher
    PRIVATE
    src/include
)

# Main Qml Module (add cpp sources and qml files and qrc files)
qt_add_qml_module(GHD_Launcher
    # Module URI
    URI ghd_game_launcher

    # .CPP
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

    # .QML
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

    # .QRC
    QML_FILES
        resources.qrc

)

# Win32 application (GUI) instead of a console app
set_target_properties(GHD_Launcher PROPERTIES
    WIN32_EXECUTABLE TRUE
)

# Link against dependencies
target_link_libraries(GHD_Launcher
    PRIVATE Qt6::Quick Qt6::Sql Qt6::Core
)

# Define default install dir for bin and lib files (cross-platform)
include(GNUInstallDirs)
install(TARGETS GHD_Launcher
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
