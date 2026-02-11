import QtQuick 2.15
import QtQuick.Controls.Universal
import QtQuick.Layouts 1.15
import QtQuick.Effects

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
        border.color: searchTextFieldId.focus ? "#333" : "#222"
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
                    var component = Qt.createComponent("../windows/AddGameWindow.qml")
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
                    viewLoader.sourceComponent
                            = (viewLoader.sourceComponent
                               === gridViewComponent) ? listViewComponent : gridViewComponent
                }
            }
        }
    }
}
