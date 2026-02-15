import QtQuick 2.15
import QtQuick.Controls.Universal
import QtQuick.Layouts 1.15
import QtQuick.Effects
import "../components"
import "../theme"

ApplicationWindow {
    title: "GHD Launcher"
    visible: true
    width: 1050
    height: 700
    minimumWidth: 620 + 16
    Universal.theme: Universal.Dark
    color: Theme.backgroundColor

    Component.onCompleted: {
        print("Games:")
        for(let i = 0; i < 100; i++) {
            print("Name:", gameManager.displayGames[i].name)
            print("Poster:", gameManager.displayGames[i].posterUrl)
            print("totalPlaytimeSec:", gameManager.displayGames[i].totalPlaytimeSec)
            print("playtimeMin:", gameManager.displayGames[i].playtimeMin)
            print("lastPlayed:", gameManager.displayGames[i].lastPlayed)
            print("dateAdded:", gameManager.displayGames[i].dateAdded)
            print()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        SearchBar {
            id: searchBarId
        }

        // Wrapper around GridView/ListView Loader
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 1
            color: "transparent"

            // Switch between GridView and ListView
            Loader {
                id: viewLoader
                sourceComponent: gridViewComponent // GridView by default
                anchors.fill: parent
                anchors.horizontalCenter: parent.horizontalCenter
                // anchors.leftMargin: Theme.gridViewPadding
                // anchors.rightMargin: Theme.gridViewPadding
            }

            // 1. Grid View Component
            Component {
                id: gridViewComponent

                // Card Grid
                GridView {
                    id: gridId
                    boundsBehavior: Flickable.StopAtBounds
                    cellWidth: Theme.gridViewCardWidth
                    cellHeight: Theme.gridViewCardHeight 
                    displayMarginBeginning: 500 // Paint delegates before visible area
                    displayMarginEnd: 100 // Paint delegates after visible area
                    anchors.fill: parent
                    // anchors.margins: 100

                    clip: true
                    model: gameManager.displayGames

                    // center children horizontally
                    property int columns: Math.floor(width / cellWidth)
                    property real rowWidth: columns * cellWidth
                    property real horizontalPadding: Math.max(0, (width - rowWidth) / 2)
                    contentX: horizontalPadding
                    Binding {
                        target: gridId
                        property: "contentX"
                        value: -gridId.horizontalPadding
                        when: true
                    }
                    Component.onCompleted: {
                        gridId.contentX = -gridId.horizontalPadding
                        // print(gridId.horizontalPadding)
                    }
                    Connections {
                        target: gameManager
                        function onDisplayGamesChanged() {
                            Qt.callLater(() => {
                                gridId.forceLayout()
                                gridId.contentX = -gridId.horizontalPadding
                            })
                        }
                    }

                    

                    // Grid Cell
                    delegate: GridViewCard {}
                }
            }

            // 2. List View Component
            Component {
                id: listViewComponent

                // Card List
                ListView {
                    boundsBehavior: Flickable.StopAtBounds
                    model: gameManager.displayGames
                    clip: true
                    displayMarginBeginning: 500 // Paint delegates before visible area
                    displayMarginEnd: 100 // Paint delegates after visible area
                    // anchors.leftMargin: 30



                    // List View Delegate
                    delegate: ListViewCard {}
                }
            }

            // This item preloads the ListViewComponent for faster first time switch
            // Note: Slower Load time and more memory usage but snappier first time switch to ListView
            // Item {
            //     id: listViewComponentPreload
            //     visible: false
            //     property Item preloadedListViewComponent: listViewComponent.createObject(listViewComponentPreload)
            // }
        }
    }
}
