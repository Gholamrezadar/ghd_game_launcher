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

        // Control Bar (Search + Filter)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            z: 100
            color: "transparent"
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: "#000"
                }
                // GradientStop {
                //     position: 0.1
                //     color: "#000"
                // }
                GradientStop {
                    position: 1.0
                    color: Qt.rgba(0, 0, 0, 0)
                } // transparent black
            }

            // Black container around the search bar
            Rectangle {
                color: "#222"
                anchors.centerIn: parent
                width: 600
                height: content.implicitHeight + 8
                radius: 1000

                RowLayout {
                    id: content
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 0

                    TextField {
                        placeholderText: "Search ..."
                        Layout.fillHeight: true
                        Layout.fillWidth: true // fillWidth -> take the remaining space horizontally
                        background: null
                        color: "white"
                        placeholderTextColor: "gray"

                        onTextChanged: gameManager.setFilterText(text)
                    }

                    // Add Button
                    ToolButton {
                        // Layout.fillHeight: true // no fillWidth -> width: implicitWidth
                        checked: true
                        icon.name: "list"
                        icon.source: "qrc:/icons/icon_add.svg"
                        icon.color: "#888"
                        background: null
                        display: AbstractButton.IconOnly
                        checkable: true
                        icon.height:18
                        icon.width:18

                        onCheckedChanged: {
                            var component = Qt.createComponent("AddNewWindow.qml");
                            if (component.status === Component.Ready) {
                                var win = component.createObject(null, {
                                    "visible": true
                                });
                                win.show();
                            }
                        }

                        HoverHandler {
                            id: addHoverHandlerId
                            cursorShape: "PointingHandCursor"
                        }

                        TapHandler {
                            id: addTapHandlerId
                        }

                        // Circle around the button
                        Rectangle {
                            id: addRectId
                            color: "transparent"
                            anchors.fill: parent
                            anchors.margins: 1
                            radius: 1000

                            states: [
                                State {
                                    name: "pressed"
                                    when: addTapHandlerId.pressed
                                    PropertyChanges {
                                        target: addRectId
                                        color: "#272727"
                                    }
                                },
                                State {
                                    name: "hovered"
                                    when: addHoverHandlerId.hovered && !addTapHandlerId.pressed
                                    PropertyChanges {
                                        target: addRectId
                                        color: "#333"
                                    }
                                }
                            ]
                        }
                    }

                    // Sort Button
                    ToolButton {
                        // Layout.fillHeight: true // no fillWidth -> width: implicitWidth
                        checked: true
                        icon.name: "list"
                        icon.source: "qrc:/icons/icon_sort.svg"
                        icon.color: "#888"
                        background: null
                        display: AbstractButton.IconOnly
                        checkable: true
                        icon.height:18
                        icon.width:18

                        onCheckedChanged: gameManager.setAscending(checked)

                        HoverHandler {
                            id: sortHoverHandlerId
                            cursorShape: "PointingHandCursor"
                        }

                        TapHandler {
                            id: sortTapHandlerId
                        }

                        Rectangle {
                            id: sortRectId
                            color: "transparent"
                            anchors.fill: parent
                            anchors.margins: 1
                            radius: 1000

                            states: [
                                State {
                                    name: "pressed"
                                    when: sortTapHandlerId.pressed
                                    PropertyChanges {
                                        target: sortRectId
                                        color: "#272727"
                                    }
                                },
                                State {
                                    name: "hovered"
                                    when: sortHoverHandlerId.hovered && !sortTapHandlerId.pressed
                                    PropertyChanges {
                                        target: sortRectId
                                        color: "#333"
                                    }
                                }
                            ]
                        }
                    }

                    // Grid/List View Button
                    ToolButton {
                        // Layout.fillHeight: true // no fillWidth -> width: implicitWidth
                        icon.name: "list"
                        icon.source: viewLoader.sourceComponent === gridViewComponent ? "qrc:/icons/icon_list_view.svg" : "qrc:/icons/icon_grid_view_outline.svg"
                        icon.color: "#888"
                        background: null
                        display: AbstractButton.IconOnly
                        icon.height:18
                        icon.width:18

                        onClicked: {
                            viewLoader.sourceComponent = (viewLoader.sourceComponent === gridViewComponent) ? listViewComponent : gridViewComponent;
                        }

                        HoverHandler {
                            id: viewHoverHandlerId
                            cursorShape: "PointingHandCursor"
                        }

                        TapHandler {
                            id: viewTapHandlerId
                        }

                        Rectangle {
                            id: viewRectId
                            color: "transparent"
                            anchors.fill: parent
                            anchors.margins: 1
                            radius: 1000

                            states: [
                                State {
                                    name: "pressed"
                                    when: viewTapHandlerId.pressed
                                    PropertyChanges {
                                        target: viewRectId
                                        color: "#272727"
                                    }
                                },
                                State {
                                    name: "hovered"
                                    when: viewHoverHandlerId.hovered && !viewTapHandlerId.pressed
                                    PropertyChanges {
                                        target: viewRectId
                                        color: "#333"
                                    }
                                }
                            ]
                        }
                    }
                }
            }
        }

        // Card Grid/List wrapper
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 1
            color: "transparent"

            // Switch between Grid View and List View
            Loader {
                id: viewLoader
                sourceComponent: gridViewComponent
                anchors.fill: parent
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Grid View Component
            Component {
                id: gridViewComponent

                // Card Grid
                GridView {
                    id: gridId
                    boundsBehavior: Flickable.StopAtBounds
                    cellWidth: 200
                    cellHeight: 300
                    displayMarginBeginning: 500  // Paint delegates before visible area
                    displayMarginEnd: 100  // Paint delegates after visible area

                    // clip: true

                    model: gameManager.displayGames

                    // center children horizontally
                    property int columns: Math.floor(width / cellWidth)
                    property real rowWidth: columns * cellWidth
                    property real horizontalPadding: Math.max(0, (width - rowWidth) / 2)
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

            // List View Component (not loaded by default)
            Component {
                id: listViewComponent

                // Card List
                ListView {
                    boundsBehavior: Flickable.StopAtBounds
                    model: gameManager.displayGames
                    clip: true

                    // List View Delegate
                    delegate: ListViewCard {}
                }
            }

            // This item preloads the ListViewComponent for faster first time switch
            // Note: Slower Load time and more memory usage
            // Item {
            //     id: listViewComponentPreload
            //     visible: false
            //     property Item preloadedListViewComponent: listViewComponent.createObject(listViewComponentPreload)
            // }
        }
    }
}
