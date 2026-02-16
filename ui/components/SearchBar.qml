import QtQuick 2.15
import QtQuick.Controls.Universal
import QtQuick.Layouts 1.15
import QtQuick.Effects
import "../theme"

// Full width top container containing the search bar and other stuff in the header
Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: Theme.searchBarBackHeight
    z: 100
    color: "transparent"
    // black to transparent gradient
    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: Theme.searchBarBackGradientStartColor
        }
        GradientStop {
            position: 1.0
            color: Theme.searchBarBackGradientStopColor
        }
    }

    // Black container around the search bar
    Rectangle {
        id: searchBarId
        color: Theme.searchBarColor
        // anchors.centerIn: parent
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Theme.searchBarTopMargin
        width: Theme.searchBarWidth
        height: content.implicitHeight + Theme.searchBarVerticalPadding
        radius: Theme.searchBarRadius
        border.color: searchTextFieldId.focus ? Theme.searchBarBorderColorFocused : Theme.searchBarBorderColor
        border.width: Theme.searchBarBorderWidth

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
            shadowVerticalOffset: Theme.searchBarShadowOffset
            shadowBlur: Theme.searchBarShadowBlur
            shadowColor: Theme.searchBarShadowColor
        }

        // Container containing the search bar and tool buttons (add, sort, list/grid view)
        RowLayout {
            id: content
            anchors.fill: parent
            anchors.leftMargin: Theme.searchBarHorizontalPadding
            anchors.rightMargin: Theme.searchBarHorizontalPadding 
            spacing: 0

            TextField {
                id: searchTextFieldId
                placeholderText: "Search ..."
                Layout.fillHeight: true
                Layout.fillWidth: true // fillWidth -> take the remaining space horizontally
                background: null
                color: Theme.searchBarTextColor
                placeholderTextColor: Theme.searchBarPlaceholderColor

                onTextChanged: gameManager?.setFilterText(text)
            }



            // Sort Button 1
            GHDToolButton {
                toolTipText: "Sort by Time Played"
                iconName: "sort"
                iconSource: "qrc:/icons/icon_stopwatch.svg"
                iconColor: gameManager?.sortMode != 0 ? Theme.toolButtonIconColorMute : checked ? Theme.toolButtonIconColorAsc : Theme.toolButtonIconColorDesc
                iconColorPressed: Theme.toolButtonPressedColor
                iconColorHovered: Theme.toolButtonHoveredColor
                checkable: true
                checked: true // true because our cpp code is set to ascending by default
                onCheckedChanged: {
                    //TODO: set sort mode
                    if(gameManager?.sortMode != 0) {
                        checked = true; // only change asc/desc when you are already on the same sorting mode otherwise default to asc
                    }
                    gameManager?.setSortMode(0)
                    gameManager?.setAscending(checked)
                }
            }

            // Sort Button 2
            GHDToolButton {
                toolTipText: "Sort by Last Played"
                iconName: "sort"
                iconSource: "qrc:/icons/icon_calendar_1.svg"
                iconColor: gameManager?.sortMode != 1 ? Theme.toolButtonIconColorMute : checked ? Theme.toolButtonIconColorAsc : Theme.toolButtonIconColorDesc
                iconColorPressed: Theme.toolButtonPressedColor
                iconColorHovered: Theme.toolButtonHoveredColor
                checkable: true
                checked: true // true because our cpp code is set to ascending by default
                onCheckedChanged: {
                    //TODO: set sort mode
                    if(gameManager?.sortMode != 1) {
                        checked = true; // only change asc/desc when you are already on the same sorting mode otherwise default to asc
                    gameManager?.setSortMode(1)
                    }
                    gameManager?.setAscending(checked)
                }
            }

            // Sort Button 3
            GHDToolButton {
                toolTipText: "Sort by Date Added"
                iconName: "sort"
                iconSource: "qrc:/icons/icon_install_date.svg"
                iconColor: gameManager?.sortMode != 2 ? Theme.toolButtonIconColorMute : checked ? Theme.toolButtonIconColorAsc : Theme.toolButtonIconColorDesc
                iconColorPressed: Theme.toolButtonPressedColor
                iconColorHovered: Theme.toolButtonHoveredColor
                checkable: true
                checked: true // true because our cpp code is set to ascending by default
                onCheckedChanged: {
                    //TODO: set sort mode
                    if(gameManager?.sortMode != 2) {
                        checked = true; // only change asc/desc when you are already on the same sorting mode otherwise default to asc
                    }
                    gameManager.setSortMode(2)
                    gameManager.setAscending(checked)
                }
                
            }

            // Spacer
            Item {
                width: 10
            }

            // Grid/List View Button
            GHDToolButton {
                toolTipText: viewLoader.sourceComponent === gridViewComponent ? "List View" : "Grid View"
                iconName: "list"
                iconSource: viewLoader.sourceComponent === gridViewComponent ? "qrc:/icons/icon_list_view.svg" : "qrc:/icons/icon_grid_view_outline.svg"
                iconColor: Theme.toolButtonIconColor
                iconColorPressed: Theme.toolButtonPressedColor
                iconColorHovered: Theme.toolButtonHoveredColor

                onClicked: {
                    viewLoader.sourceComponent
                            = (viewLoader.sourceComponent
                               === gridViewComponent) ? listViewComponent : gridViewComponent
                }
            }

            // Add Button
            GHDToolButton {
                toolTipText: "Add Game"
                iconName: "addl"
                iconSource: "qrc:/icons/icon_add.svg"
                iconColor: Theme.toolButtonIconColor
                iconColorPressed: Theme.toolButtonPressedColor
                iconColorHovered: Theme.toolButtonHoveredColor
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
        }
    }
}
