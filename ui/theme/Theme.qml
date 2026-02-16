pragma Singleton
import QtQuick 2.15

// Black Theme
QtObject {
    // Main Window
    readonly property color backgroundColor: Qt.rgba(0.125, 0.125, 0.125, 1)
    readonly property color primaryColor: Qt.rgba(0.425, 0.125, 0.125, 1)

    // SearchBar
    readonly property color searchBarColor: Qt.rgba(0.086, 0.086, 0.086, 1)
    readonly property color searchBarBorderColor:  "transparent"
    readonly property color searchBarBorderColorFocused: "transparent"
    readonly property real  searchBarBorderWidth: 1.5
    readonly property color searchBarTextColor: Qt.rgba(1, 1, 1, 0.6)
    readonly property color searchBarPlaceholderColor: Qt.rgba(1, 1, 1, 0.3)
    readonly property int   searchBarRadius: 1000
    readonly property int   searchBarWidth: 600
    readonly property int   searchBarVerticalPadding: 16
    readonly property int   searchBarHorizontalPadding: 16
    readonly property int   searchBarTopMargin: 10
    readonly property real  searchBarShadowBlur: 4.0
    readonly property int   searchBarShadowOffset: 0
    readonly property color searchBarShadowColor: Qt.rgba(0.086, 0.086, 0.086, 1)

    // SearchBar Background
    readonly property color searchBarBackGradientStartColor: "transparent"
    readonly property color searchBarBackGradientStopColor: Qt.rgba(0, 0, 0, 0)
    readonly property int   searchBarBackHeight: 80

    // ToolButton
    readonly property color toolButtonIconColor: Qt.rgba(1, 1, 1, 0.6)
    readonly property color toolButtonIconColorMute: Qt.rgba(1, 1, 1, 0.15)
    readonly property color toolButtonIconColorAsc: Qt.rgba(0.56, 0.71, 0.93, 0.45)
    readonly property color toolButtonIconColorDesc: Qt.rgba(0.93, 0.56, 0.58, 0.45)
    readonly property color toolButtonPressedColor: Qt.rgba(1, 1, 1, 0.05)
    readonly property color toolButtonHoveredColor: Qt.rgba(1, 1, 1, 0.08)

    // GridView
    readonly property real  gridViewPadding: 20
    readonly property int   gridViewCardRadius: 8
    readonly property int   gridViewCardWidth: 200
    readonly property int   gridViewCardHeight: 300
    readonly property color gridViewCardColor: '#333'
    readonly property int   gridViewCardMargin: 4
    readonly property int   gridViewCardTitleSize: 16
    readonly property int   gridViewCardSubtitleSize: 11
    readonly property color gridViewCardTitleColor: '#ffffff'
    readonly property color gridViewCardSubtitleColor: '#ccc'
    readonly property color gridViewCardHoverBackgroundColor: 'black'

    // ListView
    readonly property int   listViewCardHeight: 300
    readonly property int   listViewCardTopMargin: 4
    readonly property int   listViewCardBottomMargin: 16
    readonly property int   listViewCardHorizontalMargin: 64
    readonly property int   listViewInfoboxPadding: 12
    readonly property color listViewCardColor: searchBarColor
    readonly property color listViewCardColorHover: Qt.rgba(0.2,0.2,0.2,1)
    readonly property int   listViewCardRadius: 8
    readonly property color listViewCardPlaytimeColor: '#888'
    readonly property color listViewCardLastPlayedColor: '#aaa'
    readonly property color listViewCardDateAddedColor: '#aaa'
    readonly property int   listViewCardTitleSize: 18
    readonly property int   listViewCardSubtitleSize: 18
    readonly property color listViewCardTitleColor: Qt.rgba(1,1,1,0.95)
    readonly property color listViewCardSubtitleColor: Qt.rgba(1,1,1,0.65)
    readonly property color listViewCardExtraInfoColor: Qt.rgba(1,1,1,0.35)

}

// Blue Theme
// QtObject {
//     // Main Window
//     readonly property color backgroundColor: '#21293a'

//     // SearchBar
//     readonly property color searchBarColor: Qt.rgba(0.101, 0.125, 0.176, 1)
//     readonly property color searchBarBorderColor: Qt.lighter(Qt.rgba(0.101, 0.125, 0.176, 1), 1.4)
//     readonly property color searchBarBorderColorFocused: Qt.lighter(Qt.rgba(0.101, 0.125, 0.176, 1), 1.5)
//     readonly property real   searchBarBorderWidth: 1.5
//     readonly property color searchBarTextColor: Qt.rgba(1, 1, 1, 0.6)
//     readonly property color searchBarPlaceholderColor: Qt.rgba(1, 1, 1, 0.3)
//     readonly property int   searchBarRadius: 1000
//     readonly property int   searchBarWidth: 600
//     readonly property int   searchBarVerticalPadding: 16
//     readonly property int   searchBarHorizontalPadding: 16
//     readonly property real searchBarShadowBlur: 1.0
//     readonly property int   searchBarShadowOffset: 0
//     readonly property color searchBarShadowColor: Qt.rgba(0.101, 0.125, 0.176, 1)

//     // SearchBar Background
//     readonly property color searchBarBackGradientStartColor: backgroundColor
//     readonly property color searchBarBackGradientStopColor: Qt.rgba(0, 0, 0, 0)
//     readonly property int   searchBarBackHeight: 120

//     // ToolButton
//     readonly property color toolButtonIconColor: Qt.rgba(1, 1, 1, 0.6)
//     readonly property color toolButtonPressedColor: Qt.rgba(1, 1, 1, 0.05)
//     readonly property color toolButtonHoveredColor: Qt.rgba(1, 1, 1, 0.08)

//     // GridView
//     readonly property real  gridViewPadding: 20
//     readonly property int   gridViewCardRadius: 8
//     readonly property int   gridViewCardWidth: 200
//     readonly property int   gridViewCardHeight: 300
//     readonly property color gridViewCardColor: '#333'
//     readonly property int   gridViewCardMargin: 4
//     readonly property int   gridViewCardTitleSize: 16
//     readonly property int   gridViewCardSubtitleSize: 11
//     readonly property color gridViewCardTitleColor: '#ffffff'
//     readonly property color gridViewCardSubtitleColor: '#ccc'
//     readonly property color gridViewCardHoverBackgroundColor: 'black'

//     // ListView
//     readonly property int   listViewCardHeight: 328
//     readonly property int   listViewCardVerticalMargin: 8
//     readonly property int   listViewCardHorizontalMargin: 16
//     readonly property color listViewCardColor: Qt.rgba(0.101, 0.125, 0.176, 0.9)
//     readonly property int   listViewCardRadius: 8
//     readonly property color listViewCardHoverBackgroundColor: '#4bffffff'
//     readonly property color listViewCardTitleColor: '#ffffff'
//     readonly property color listViewCardSubtitleColor: '#aaa'
//     readonly property color listViewCardPlaytimeColor: '#888'
//     readonly property color listViewCardLastPlayedColor: '#aaa'
//     readonly property color listViewCardDateAddedColor: '#aaa'
//     readonly property color listViewCardLaunchButtonColor: '#3d8aed'
//     readonly property color listViewCardLaunchButtonHoverColor: '#4a9eff'
//     readonly property color listViewCardLaunchButtonPressedColor: '#2d6abd'
//     readonly property real  listViewCardLaunchButtonScale: 0.96
//     readonly property real  listViewCardLaunchButtonWidth: 120
//     readonly property real  listViewCardLaunchButtonHeight: 40
//     readonly property real  listViewCardLaunchButtonRadius: 6

// }
