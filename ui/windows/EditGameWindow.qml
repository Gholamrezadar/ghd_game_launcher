import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Effects
import "../components"

ApplicationWindow {
    id: window
    width: 600
    height: 400
    minimumWidth: 480
    minimumHeight: 240
    visible: true
    title: "Edit Game"

    // Set this property before showing the window, e.g.:
    //   var win = editComp.createObject(root, { game: { name: "...", exePath: "...", posterUrl: "..." } })
    property var game: ({ name: "", exePath: "", posterUrl: "", totalPlaytimeSec: 0 })

    // Tracks the original name so updateGame() can find the right record
    // even if the user renames it
    readonly property string originalName: game.name

    // Populate fields once the game property is set
    Component.onCompleted: {
        nameInput.text  = game.name     ?? ""
        exeInput.text   = game.exePath  ?? ""
        coverInput.text = game.posterUrl ?? ""
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.backgroundColor

        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width * 0.88
            spacing: 14

            // ── Name ──────────────────────────────────────────────────────────────
            RowLayout {
                spacing: 10
                Label {
                    text: "Name:"
                    color: "#cccccc"
                    Layout.preferredWidth: 90
                    horizontalAlignment: Text.AlignRight
                    Layout.alignment: Qt.AlignVCenter
                }
                GHDTextField {
                    id: nameInput
                    Layout.fillWidth: true
                    placeholderText: "Game name"
                    backgroundColor:        "#2c2c2c"
                    backgroundColorFocused: "#333333"
                    textColor:              "#ffffff"
                    placeholderColor:       "#888888"
                    borderColor:            "#444444"
                    borderColorFocused:     "#3498db"
                    radius: 6
                }
            }

            // ── Executable ────────────────────────────────────────────────────────
            RowLayout {
                spacing: 10
                Label {
                    text: "Executable:"
                    color: "#cccccc"
                    Layout.preferredWidth: 90
                    horizontalAlignment: Text.AlignRight
                    Layout.alignment: Qt.AlignVCenter
                }
                GHDTextField {
                    id: exeInput
                    Layout.fillWidth: true
                    placeholderText: "Select a file…"
                    readOnly: true
                    backgroundColor:        "#2c2c2c"
                    backgroundColorFocused: "#333333"
                    textColor:              "#ffffff"
                    placeholderColor:       "#888888"
                    borderColor:            "#444444"
                    borderColorFocused:     "#3498db"
                    radius: 6
                }
                GHDButton {
                    text: "Browse"
                    Layout.preferredWidth: 80
                    backgroundColor:        '#2c2c2c'
                    backgroundColorHovered: '#636363'
                    backgroundColorPressed: '#2e2e2e'
                    textColor: "#ffffff"
                    onClicked: exeDialog.open()
                }
            }

            // ── Cover / Poster ────────────────────────────────────────────────────
            RowLayout {
                spacing: 10
                Label {
                    text: "Cover:"
                    color: "#cccccc"
                    Layout.preferredWidth: 90
                    horizontalAlignment: Text.AlignRight
                    Layout.alignment: Qt.AlignVCenter
                }
                GHDTextField {
                    id: coverInput
                    Layout.fillWidth: true
                    placeholderText: "Select a file…"
                    readOnly: true
                    backgroundColor:        "#2c2c2c"
                    backgroundColorFocused: "#333333"
                    textColor:              "#ffffff"
                    placeholderColor:       "#888888"
                    borderColor:            "#444444"
                    borderColorFocused:     "#3498db"
                    radius: 6
                }
                GHDButton {
                    text: "Browse"
                    Layout.preferredWidth: 80
                    backgroundColor:        '#2c2c2c'
                    backgroundColorHovered: '#636363'
                    backgroundColorPressed: '#2e2e2e'
                    textColor: "#ffffff"
                    onClicked: coverDialog.open()
                }
            }

            // ── Total Playtime ────────────────────────────────────────────────────
            RowLayout {
                spacing: 10
                Label {
                    text: "Playtime (sec):"
                    color: "#cccccc"
                    Layout.preferredWidth: 90
                    horizontalAlignment: Text.AlignRight
                    Layout.alignment: Qt.AlignVCenter
                }
                GHDTextField {
                    id: playtimeInput
                    Layout.fillWidth: true
                    placeholderText: "0"
                    text: game.totalPlaytimeSec ?? "0"
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator { bottom: 0 }
                    backgroundColor:        "#2c2c2c"
                    backgroundColorFocused: "#333333"
                    textColor:              "#ffffff"
                    placeholderColor:       "#888888"
                    borderColor:            "#444444"
                    borderColorFocused:     "#3498db"
                    radius: 6
                }
            }

            // ── Error label ───────────────────────────────────────────────────────
            Label {
                id: errorLabel
                visible: text !== ""
                color: "#e74c3c"
                font.pixelSize: 12
                Layout.alignment: Qt.AlignHCenter
            }

            // ── Actions ───────────────────────────────────────────────────────────
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 4
                spacing: 12

            // ── Hold-to-delete button ─────────────────────────────────────────
            DelayButton {
                id: deleteButton
                text: "Hold to Delete"
                delay: 1500
                Layout.preferredWidth: 120
                padding: 12
                leftPadding: 20
                rightPadding: 20

                HoverHandler { id: delHover; cursorShape: "PointingHandCursor" }
                TapHandler  { id: delTap }

                contentItem: Text {
                    text: deleteButton.text
                    font: deleteButton.font
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    id: deleteBg
                    radius: 4
                    // Fill the progress arc using a clip rectangle on top
                    color: delTap.pressed ? "#7b241c"
                         : delHover.hovered ? "#a93226" : "#c0392b"

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowHorizontalOffset: 0
                        shadowVerticalOffset: 2
                        shadowBlur: 0.3
                        shadowColor: "#30000000"
                    }

                    // Progress fill overlay
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width * deleteButton.progress
                        color: "#ff6b6b"
                        opacity: 0.5
                        radius: 4
                    }
                }

                onActivated: {
                    gameManager?.removeGame(originalName)
                    window.close()
                }
            }

            // ── Save ──────────────────────────────────────────────────────────────
            GHDButton {
                text: "Save"
                Layout.preferredWidth: 130
                backgroundColor:        "#3498db"
                backgroundColorHovered: "#2980b9"
                backgroundColorPressed: "#21618c"
                textColor: "#ffffff"
                onClicked: {
                    if (nameInput.text.trim() === "") {
                        errorLabel.text = "Name cannot be empty."
                        return
                    }
                    if (exeInput.text.trim() === "") {
                        errorLabel.text = "Please select an executable."
                        return
                    }
                    errorLabel.text = ""

                    // Build a fields map with only the values that changed
                    const fields = {}
                    const newName = nameInput.text.trim()
                    const newExe  = exeInput.text.trim()
                    const newCover = coverInput.text.trim()

                    if (newName  !== originalName) fields["name"] = newName
                    if (newExe   !== game.exePath) fields["executablePath"] = newExe
                    if (newCover !== game.posterUrl) fields["posterUrl"] = newCover
                    const newPlaytime = parseInt(playtimeInput.text) || 0
                    if (newPlaytime !== (game.totalPlaytimeSec ?? 0)) fields["totalPlaytimeSec"] = newPlaytime

                    if (Object.keys(fields).length > 0)
                        gameManager?.updateGame(originalName, fields)

                    window.close()
                }
            }
            } // RowLayout actions
        }

        FileDialog {
            id: exeDialog
            title: "Select an Executable"
            onAccepted: exeInput.text = exeDialog.selectedFile
        }

        FileDialog {
            id: coverDialog
            title: "Select a Cover Image"
            onAccepted: coverInput.text = coverDialog.selectedFile
        }
    }
}