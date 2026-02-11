import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme"

Rectangle {
    id: root
    
    // Public properties
    property alias searchText: searchField.text
    property string placeholderText: "Search ..."
    
    // Signals
    signal mySearchTextChanged(string text)
    signal addClicked()
    signal sortToggled(bool ascending)
    signal viewToggled(bool isGridView)
    
    // Internal state
    property bool isGridView: true
    property bool sortAscending: true
    
    // Styling
    color: Theme.cardBackgroundDark
    width: Theme.searchBarWidth
    height: implicitHeight
    radius: Theme.radiusLarge
    
    implicitHeight: contentRow.implicitHeight + Theme.paddingSmall
    
    RowLayout {
        id: contentRow
        anchors.fill: parent
        anchors.leftMargin: Theme.paddingLarge
        anchors.rightMargin: Theme.paddingLarge
        spacing: 0
        
        // Search TextField
        TextField {
            id: searchField
            placeholderText: root.placeholderText
            Layout.fillHeight: true
            Layout.fillWidth: true
            background: null
            color: Theme.textPrimary
            placeholderTextColor: Theme.textMuted
            
            onTextChanged: root.mySearchTextChanged(text)
        }
        
        // Add Button
        IconToolButton {
            iconSource: "qrc:/icons/icon_add.svg"
            isCheckable: true
            
            onButtonClicked: {
                root.addClicked()
            }
        }
        
        // Sort Button
        IconToolButton {
            iconSource: "qrc:/icons/icon_sort.svg"
            isCheckable: true
            isChecked: root.sortAscending
            
            onMyCheckedChanged: {
                root.sortAscending = checked
                root.sortToggled(checked)
            }
        }
        
        // View Toggle Button
        IconToolButton {
            iconSource: root.isGridView 
                       ? "qrc:/icons/icon_list_view.svg" 
                       : "qrc:/icons/icon_grid_view_outline.svg"
            
            onButtonClicked: {
                root.isGridView = !root.isGridView
                root.viewToggled(root.isGridView)
            }
        }
    }
}
