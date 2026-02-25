import QtQuick 2.15
import QtQuick.Controls.Universal
import QtQuick.Layouts 1.15
import QtQuick.Effects
import "../components"
import "../theme"

ApplicationWindow {
    id: window
    title: "GHD Launcher"
    visible: true
    width: 1120
    height: 700
    minimumWidth: 620 + 16
    Universal.theme: Universal.Dark
    color: Theme.backgroundColor

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

                // This wrapper around the gridview is key!
                // the loader automatically overwrites its components width/height to its own size!
                // so with a wrapper, the wrapper gets the loaders size not the gridview
                // otherwise we could not center the gridview (set its width)
                Rectangle {
                    color: "transparent"

                // Card Grid
                GridView {
                    id: gridId
                    boundsBehavior: Flickable.StopAtBounds
                    cellWidth: Theme.gridViewCardWidth
                    cellHeight: Theme.gridViewCardHeight
                    clip: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    model: gameManager?.displayGames
                    // displayMarginBeginning: 500 // Paint delegates before visible area
                    // displayMarginEnd: 100 // Paint delegates after visible area

                    // Centering logic
                    property int columns: Math.max(1, Math.floor(parent.width / cellWidth))
                    width: columns * cellWidth
                    height: parent.height

                    // Grid Cell
                    delegate: GridViewCard {}
                }
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
                    // displayMarginBeginning: 500 // Paint delegates before visible area
                    // displayMarginEnd: 100 // Paint delegates after visible area
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
