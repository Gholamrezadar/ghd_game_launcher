import QtQuick 6.5
import QtQuick.Controls.Universal
import QtGraphs

ApplicationWindow {
    width: 1000
    height: 700
    minimumWidth: 620 + 16
    visible: true
    title: "Filter + Sort Grid"
    color: Theme.backgroundColor

    // Row {
    //     spacing: 16
    //     padding: 16
    //     RoundedImage {
    //         width: 300
    //         height: 600
    //         radius: 8
    //         source: "file:\\\C:\Users\\EXO\\Pictures\\poster_hades.png"
    //         fillMode: Image.PreserveAspectCrop
    //     }
    //     RoundedImage {
    //         width: 300
    //         height: 300
    //         radius: 10000
    //         source: "file:\\\C:\Users\\EXO\\Pictures\\poster_hades.png"
    //         fillMode: Image.PreserveAspectCrop
    //     }
    // }
    GraphsView {
        anchors.fill: parent
        axisX: ValueAxis {
            max: 3
        }
        axisY: ValueAxis {
            max: 3
        }

        LineSeries {
            color: "#00ff00"
            XYPoint {
                x: 0.5
                y: 0.5
            }
            XYPoint {
                x: 1
                y: 1
            }
            XYPoint {
                x: 2
                y: 2
            }
            XYPoint {
                x: 2.5
                y: 1.5
            }
        }
    }
}
