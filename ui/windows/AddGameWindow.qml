import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../components"

ApplicationWindow {
    id: window
    width: 400
    height: 200
    visible: true
    title: "Add New"

    // Bg
    Rectangle {
        color: "#444"
        anchors.fill: parent

        // Form Layout
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 10
            width: parent.width * 0.8

            // Name Field
            RowLayout {
                spacing: 10
                Label {
                    text: "Name:"
                    Layout.alignment: Qt.AlignVCenter
                }
                TextField {
                    id: nameInput
                    Layout.fillWidth: true
                    placeholderText: "Enter your name"
                }
            }

            // File Picker Field
            RowLayout {
                spacing: 10
                Label {
                    text: "File:    "
                    Layout.alignment: Qt.AlignVCenter
                }
                TextField {
                    id: fileInput
                    Layout.fillWidth: true
                    placeholderText: "Select a file"
                    readOnly: true
                }
                Button {
                    text: "Browse"
                    onClicked: fileDialog.open()
                }
            }

            // Submit Button
            GHDButton {
                backgroundColor: "#3498db"
                backgroundColorHovered: "#2980b9"
                backgroundColorPressed: "#21618c"
                textColor: "#ffffff"
                text: "Submit"
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    console.log("Name:", nameInput.text)
                    console.log("File:", fileInput.text)
                }
            }
        }

        // File Dialog
        FileDialog {
            id: fileDialog
            title: "Select a file"
            // selectExisting: true
            onAccepted: {
                fileInput.text = fileDialog.selectedFile
            }
        }
    }
}
