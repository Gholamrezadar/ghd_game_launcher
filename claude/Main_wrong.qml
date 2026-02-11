import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "ui/components"
import "ui/theme"

ApplicationWindow {
    id: mainWindow
    
    // Window properties
    width: Theme.windowWidth
    height: Theme.windowHeight
    minimumWidth: Theme.windowMinWidth
    visible: true
    title: "Filter + Sort Grid"
    color: Theme.backgroundColor
    
    // Application state
    property bool isGridView: true
    property string filterText: ""
    property bool sortAscending: true
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Control Bar (Search + Filter)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.controlBarHeight
            z: 100
            color: Theme.backgroundColor
            
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Theme.backgroundColor
                }
                GradientStop {
                    position: 0.7
                    color: Theme.backgroundColor
                }
                GradientStop {
                    position: 1.0
                    color: Qt.rgba(0, 0, 0, 0)
                }
            }
            
            // Search Bar Component
            SearchBar {
                id: searchBar
                anchors.centerIn: parent
                
                onMySearchTextChanged: function(text) {
                    mainWindow.filterText = text
                    nameProxyModel.filterText = text
                }
                
                onAddClicked: {
                    var component = Qt.createComponent("AddNewWindow.qml")
                    if (component.status === Component.Ready) {
                        var win = component.createObject(null, {
                            "visible": true
                        })
                        win.show()
                    }
                }
                
                onSortToggled: function(ascending) {
                    mainWindow.sortAscending = ascending
                    gameManager.setAscending(ascending)
                }
                
                onViewToggled: function(isGrid) {
                    mainWindow.isGridView = isGrid
                }
            }
        }
        
        // Game Grid/List Container
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 1
            color: "transparent"
            
            // Grid View
            GridView {
                id: gridView
                anchors.fill: parent
                visible: mainWindow.isGridView
                boundsBehavior: Flickable.StopAtBounds
                
                cellWidth: Theme.gridCellWidth
                cellHeight: Theme.gridCellHeight
                
                model: gameManager.displayGames
                
                // Center children horizontally
                property int columns: Math.floor(width / cellWidth)
                property real rowWidth: columns * cellWidth
                property real horizontalPadding: Math.max(0, (width - rowWidth) / 2)
                contentX: -horizontalPadding
                
                delegate: GameCardDelegate {
                    width: gridView.cellWidth
                    height: gridView.cellHeight
                    modelData: model.modelData
                    
                    onCardClicked: function(game) {
                        console.log("Grid card clicked:", game.name)
                        // Handle game selection/launch
                    }
                }
            }
            
            // List View
            ListView {
                id: listView
                anchors.fill: parent
                visible: !mainWindow.isGridView
                boundsBehavior: Flickable.StopAtBounds
                
                model: gameManager.displayGames
                
                delegate: GameListDelegate {
                    modelData: model.modelData
                    
                    onLaunchClicked: function(game) {
                        console.log("Launch game:", game.name)
                        // Handle game launch
                    }
                    
                    onRowClicked: function(game) {
                        console.log("List row clicked:", game.name)
                        // Handle row selection
                    }
                }
            }
        }
    }
}
