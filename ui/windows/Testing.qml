import QtQuick 6.5
import QtQuick.Controls.Universal

ApplicationWindow {
    width: 1000
    height: 700
    minimumWidth: 620 + 16
    visible: true
    title: "Filter + Sort Grid"
    color: "black"
    Row {
        spacing: 16
        padding: 16
        RoundedImage {
            width: 300
            height: 600
            radius: 8
            source: "file:\\\C:\Users\\EXO\\Pictures\\poster_hades.png"
            fillMode: Image.PreserveAspectCrop
        }
        RoundedImage {
            width: 300
            height: 300
            radius: 10000
            source: "file:\\\C:\Users\\EXO\\Pictures\\poster_hades.png"
            fillMode: Image.PreserveAspectCrop
        }
    }
}
