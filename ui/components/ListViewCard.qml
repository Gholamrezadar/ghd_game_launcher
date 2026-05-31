import QtQuick
import QtQuick.Layouts 1.15
import QtQuick.Effects
import "../components"
// import QtGraphs

Rectangle {
    width: ListView.view.width
    height: Theme.listViewCardHeight + Theme.listViewCardBottomMargin + Theme.listViewCardTopMargin - 6
    color: "transparent"
    property bool showFullHistory: true

    Rectangle {
        id: card
        anchors.fill: parent
        anchors.leftMargin: Theme.listViewCardHorizontalMargin
        anchors.rightMargin: Theme.listViewCardHorizontalMargin
        anchors.bottomMargin: Theme.listViewCardBottomMargin
        anchors.topMargin: Theme.listViewCardTopMargin
        // color: isHovered? Theme.listViewCardColorHover : Theme.listViewCardColor
        color: "transparent"
        radius: Theme.listViewCardRadius
        border.color: Theme.searchBarBorderColorFocused
        border.width: Theme.searchBarBorderWidth
        state: "default"

        // property bool isHovered: cardMouseArea.containsMouse || editButton.hovered || coverImageMouseArea.containsMouse
        property bool isHovered: coverImageMouseArea.containsMouse

        Row {
            anchors.fill: parent

            // Game poster
            Rectangle {
                id: coverImage
                width: 200
                height: 300 - 6
                color: "transparent"

                RoundedImage {
                    anchors.fill: parent
                    source: modelData.posterUrl.startsWith("file:///")
                            ? modelData.posterUrl
                            : "file:///" + modelData.posterUrl
                    fillMode: Image.PreserveAspectCrop
                    visible: modelData.posterUrl !== ""
                    radius: Theme.listViewCardRadius
                }

                MouseArea {
                    id: coverImageMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    propagateComposedEvents: true
                    z: 55

                    onEntered: card.state = "hovered"
                    onExited: card.state = "default"
                    cursorShape: "PointingHandCursor"

                    onClicked: {
                        console.log("Clicked row:", modelData.name);
                        gameManager.launchGame(modelData.name);
                    }
                }

                // BG Bar 1
                // This bar is a hacky solution to make the right of the image and left of the info box not round!
                // I'm doing this because per corner radius is not supported in QML
                Rectangle {
                    width: Theme.listViewCardRadius
                    height: parent.height
                    color: card.isHovered ? Theme.listViewCardColorHover : Theme.listViewCardColor
                    anchors.right: parent.right
                }
            }

            // Game info box
            Rectangle {
                id: infobox
                width: parent.width - coverImage.width //  + Theme.listViewCardRadius
                height: parent.height
                color: card.isHovered ? Theme.listViewCardColorHover : Theme.listViewCardColor
                radius: Theme.listViewCardRadius

                // BG Bar 2
                // This bar is a hacky solution to make the right of the image and left of the info box not round!
                // I'm doing this because per corner radius is not supported in QML
                Rectangle {
                    width: Theme.listViewCardRadius
                    height: parent.height
                    color: card.isHovered ? Theme.listViewCardColorHover : Theme.listViewCardColor
                    anchors.left: parent.left
                }

                // Edit Button
                GHDToolButton {
                    id: editButton
                    toolTipText: "Edit information"
                    iconSource: "qrc:/icons/icon_edit_2.svg"
                    z: 10000
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.topMargin: Theme.listViewInfoboxPadding
                    anchors.rightMargin: Theme.listViewInfoboxPadding + Theme.listViewCardRadius
                    iconColor: Theme.toolButtonIconColor
                    iconColorPressed: Theme.toolButtonPressedColor
                    iconColorHovered: Theme.toolButtonHoveredColor

                    onClicked: {
                        var component = Qt.createComponent("../windows/EditGameWindow.qml")
                        if (component.status === Component.Ready) {
                            var win = component.createObject(null, {
                                visible: true,
                                game: {
                                    name:             modelData.name,
                                    exePath:          modelData.executablePath,
                                    posterUrl:        modelData.posterUrl,
                                    totalPlaytimeSec: modelData.totalPlaytimeSec
                                }
                            })
                            win.show()
                        }
                    }
                }

                // Sessions Button
                GHDToolButton {
                    id: sessionsButton
                    toolTipText: "View sessions"
                    iconSource: "qrc:/icons/icon_calendar_2.svg"
                    z: 10000
                    anchors.top: parent.top
                    anchors.right: editButton.right
                    anchors.topMargin: Theme.listViewInfoboxPadding
                    anchors.rightMargin: Theme.listViewInfoboxPadding + Theme.listViewCardRadius + 8
                    iconColor: Theme.toolButtonIconColor
                    iconColorPressed: Theme.toolButtonPressedColor
                    iconColorHovered: Theme.toolButtonHoveredColor

                    onClicked: {
                        gameManager.setCurrentGame(modelData.name)
                        var component = Qt.createComponent("../windows/SessionsListWindow.qml")
                        if (component.status === Component.Ready) {
                            var win = component.createObject(null, { visible: true })
                            win.show()
                        }
                    }
                }

                // Game Title and subtitle
                Column {
                    z: 10000
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.topMargin: Theme.listViewInfoboxPadding
                    anchors.leftMargin: Theme.listViewInfoboxPadding
                    Text {
                        text: modelData.name
                        font.pixelSize: Theme.listViewCardTitleSize
                        font.bold: false
                        color: Theme.listViewCardTitleColor
                        elide: Text.ElideRight
                        maximumLineCount: 2
                        wrapMode: Text.Wrap
                    }
                    Text {
                        text: Utils.formatPlaytime(modelData.totalPlaytimeSec)
                        font.pixelSize: Theme.listViewCardSubtitleSize
                        color: Theme.listViewCardSubtitleColor
                        elide: Text.ElideRight
                    }
                }

                // Extra Game info at the bottom left
                Text {
                    z: 10000
                    text: gameManager?.getGameSessionCount(modelData.name) + " Sessions " + " | " + Utils.formatLastPlayed(modelData.lastPlayed) //+ " | " + Utils.formatDateAdded(modelData.dateAdded)
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.bottomMargin: Theme.listViewInfoboxPadding
                    anchors.leftMargin: Theme.listViewInfoboxPadding
                    color: Theme.listViewCardExtraInfoColor
                    font.pixelSize: 12
                }

                // Extra Game info at the bottom right
                Text {
                    z: 10000
                    text: Utils.formatDateAdded(modelData.dateAdded)
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: Theme.listViewInfoboxPadding
                    anchors.rightMargin: Theme.listViewInfoboxPadding + Theme.listViewCardRadius
                    color: Theme.listViewCardExtraInfoColor
                    font.pixelSize: 12
                }

                // Card hover detection
                MouseArea {
                    id: cardMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    propagateComposedEvents: true
                    z: 55
                }

                // Fake data
                function generateData(days, maxVal) {
                    var now   = new Date()
                    var arr   = []
                    var value = maxVal * 0.4

                    for (var i = days; i > 0; --i) {
                        var d = new Date(now)
                        d.setDate(d.getDate() - i)
                        d.setHours(0, 0, 0, 0)

                        // random walk
                        value += (Math.random() - 0.48) * maxVal * 0.15
                        value  = Math.max(0, Math.min(maxVal, value))

                        arr.push({ timestamp: d, value: parseFloat(value.toFixed(2)) })
                    }
                    return arr
                }

                GHDChart {
                    id: chart
                    z: 7642384632

                    anchors.centerIn: parent
                    anchors.fill: parent
                    anchors.leftMargin: 32
                    anchors.rightMargin: 32
                    anchors.topMargin: 48
                    anchors.bottomMargin: 8

                    // Switch dataset based on mode
                    model: showFullHistory
                        ? gameManager?.getPlaytimeChartDataFullHistory(modelData.name)
                        : gameManager?.getPlaytimeChartData(modelData.name, 14)

                    plotMode: GHDChart.PlotMode.Bar

                    title:    ""
                    yUnit:    "h"
                    xUnit:    "days ago"

                    yMin:       0
                    yMax:       showFullHistory ? 0 : 0
                    yTickStep:  0
                    yDecimals:  1

                    // In full history mode, show a date per month-ish; in short mode, every 2nd of 11
                    xTickCount:     showFullHistory ? 0  : 14
                    xTicksInterval: showFullHistory ? 6  : 2
                    xLabelFormat:   showFullHistory ? "date" : "days"
                    tickRotation:   showFullHistory ? 45 : 30

                    lineWidth:    3
                    dotRadius:    4
                    barFillRatio: 0.55
                    barMaxWidth: 10   // cap in pixels; 0 = no cap

                    seriesColor:      "#3B82F6"
                    seriesHoverColor: "#60A5FA"

                    Component.onCompleted: function(){
                        // console.log(gameManager?.getPlaytimeChartDataFullHistory(modelData.name));
                    }
                }
            }
        }
    }
}
