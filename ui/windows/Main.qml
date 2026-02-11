import QtQuick 2.15
import QtQuick.Controls.Universal
import QtQuick.Layouts 1.15
import QtQuick.Effects
import "../components"

ApplicationWindow {
    title: "GHD Launcher"
    visible: true
    width: 1000
    height: 700
    minimumWidth: 620 + 16
    Universal.theme: Universal.Dark

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
            }

            // 1. Grid View Component
            Component {
                id: gridViewComponent

                // Card Grid
                GridView {
                    id: gridId
                    boundsBehavior: Flickable.StopAtBounds
                    cellWidth: 200
                    cellHeight: 300
                    displayMarginBeginning: 500 // Paint delegates before visible area
                    displayMarginEnd: 100 // Paint delegates after visible area

                    // clip: true
                    model: gameManager.displayGames

                    // center children horizontally
                    property int columns: Math.floor(width / cellWidth)
                    property real rowWidth: columns * cellWidth
                    property real horizontalPadding: Math.max(
                                                         0,
                                                         (width - rowWidth) / 2)
                    Binding {
                        target: gridId
                        property: "contentX"
                        value: -gridId.horizontalPadding
                        when: gridId.horizontalPadding !== undefined
                    }
                    Component.onCompleted: {
                        gridId.contentX = -gridId.horizontalPadding
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
                    // clip: true
                    displayMarginBeginning: 500 // Paint delegates before visible area
                    displayMarginEnd: 100 // Paint delegates after visible area


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
