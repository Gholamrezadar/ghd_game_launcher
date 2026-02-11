import QtQuick 2.15
import QtQuick.Controls.Universal
import QtQuick.Layouts 1.15
import QtQuick.Effects
import "../components"

ApplicationWindow {
    width: 1000
    height: 700
    minimumWidth: 620 + 16
    visible: true
    title: "GHD Launcher"

    // color: "#444"
    Universal.theme: Universal.Dark

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Full width top container containing the search bar and other stuff in the header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            z: 100
            color: "transparent"
            // black to transparent gradient
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: "#000"
                }
                GradientStop {
                    position: 1.0
                    color: Qt.rgba(0, 0, 0, 0)
                }
            }

            // Black container around the search bar
            Rectangle {
                id: searchBarId
                color: "#222"
                anchors.centerIn: parent
                width: 600
                height: content.implicitHeight + 16
                radius: 1000
                border.color: searchTextFieldId.focus? "#333" : "#222"
                border.width: 1.5

                Keys.onEscapePressed: {
                    searchTextFieldId.focus = false
                }

                Behavior on border.color {
                    ColorAnimation {
                        duration: 200
                        easing.type: Easing.OutQuad
                    }
                }

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 2
                    shadowBlur: 1.4
                    shadowColor: "black"
                }

                // Container containing the search bar and tool buttons (add, sort, list/grid view)
                RowLayout {
                    id: content
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 0

                    TextField {
                        id: searchTextFieldId
                        placeholderText: "Search ..."
                        Layout.fillHeight: true
                        Layout.fillWidth: true // fillWidth -> take the remaining space horizontally
                        background: null
                        color: "white"
                        placeholderTextColor: "gray"

                        onTextChanged: gameManager.setFilterText(text)
                    }

                    // Add Button
                    GHDToolButton {
                        iconName: "add"
                        iconSource: "qrc:/icons/icon_add.svg"
                        iconColor: "#888"
                        iconColorPressed: "#272727"
                        iconColorHovered: "#333"
                        onClicked: {
                            var component = Qt.createComponent(
                                        "AddGameWindow.qml")
                            if (component.status === Component.Ready) {
                                var win = component.createObject(null, {
                                                                     "visible": true
                                                                 })
                                win.show()
                            }
                        }
                    }

                    // Sort Button
                    GHDToolButton {
                        iconName: "sort"
                        iconSource: "qrc:/icons/icon_sort.svg"
                        iconColor: "#888"
                        iconColorPressed: "#272727"
                        iconColorHovered: "#333"
                        checkable: true
                        checked: true // true because our cpp code is set to ascending by default
                        onCheckedChanged: {
                            gameManager.setAscending(checked)
                        }
                    }

                    // Grid/List View Button
                    GHDToolButton {
                        iconName: "list"
                        iconSource: viewLoader.sourceComponent === gridViewComponent ? "qrc:/icons/icon_list_view.svg" : "qrc:/icons/icon_grid_view_outline.svg"
                        iconColor: "#888"
                        iconColorPressed: "#272727"
                        iconColorHovered: "#333"

                        onClicked: {
                            viewLoader.sourceComponent = (viewLoader.sourceComponent === gridViewComponent) ? listViewComponent : gridViewComponent
                        }
                    }
                }
            }
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
