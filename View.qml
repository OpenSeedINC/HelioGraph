import QtQuick 2.0

import QtGraphicalEffects 1.0


Item {

    id:window_container

    property string theimage:"graphics/blankimage.png"
    property int effect:0
    property int newrotation:0

    states: [
        State {
            name: "Show"
            PropertyChanges {
                target:window_container
                visible:true
                x:0
            }
        },
        State {
            name: "Hide"
            PropertyChanges {
                    target:window_container
                    visible:false
                    x:parent.width
            }
        }


    ]

    transitions: [
        Transition {
            from: "Hide"
            to: "Show"
            reversible: true


            NumberAnimation {
                target: window_container
                property: "x"
                duration: 200
                easing.type: Easing.InOutQuad
            }

        }

    ]

    state:"Hide"

    Rectangle {
        anchors.fill: parent
        color:"black"
    }

    Item {
        anchors.centerIn: parent
        width:if(parent.height > parent.width) {if(baseImage.implicitWidth > parent.width) {parent.height} else {parent.width} }else {parent.width }
        height:if(parent.height > parent.width) {if(baseImage.implicitWidth > parent.width) {parent.width} else {parent.height} }else {parent.height }
        //rotation:if(parent.height > parent.width) {if(baseImage.implicitWidth > parent.width) {90} else {0} } else {0}
        //anchors.fill: parent
        rotation:newrotation
    Image {
        id:baseImage
        anchors.centerIn: parent
        width:parent.width
        height:parent.height
        source:theimage
        fillMode:Image.PreserveAspectFit
        cache:false

        visible:if(effect == 0 || effect == 3) {true} else {false}


    }

    Colorize {
           visible:if(effect == 1) {true} else {false}
           anchors.fill: baseImage
           source: baseImage
           hue: 0.0
           saturation: 0.0
           lightness: -0.1
       }

    Colorize {
           visible:if(effect == 2) {true} else {false}
           anchors.fill: baseImage
           source: baseImage
           hue: 0.15
           saturation: 0.7
           lightness: -0.4
       }


    Colorize {
           visible:if(effect == 3) {true} else {false}
           anchors.fill: baseImage
           source: baseImage
           hue: 0.15
           saturation: 0.7
           lightness: -0.4
       }

       RadialGradient {
            id:radialWashout
            anchors.centerIn:baseImage
            width:baseImage.paintedWidth
            height:baseImage.paintedHeight
            visible:if(effect == 3) {true} else {false}

            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0,0,0,0) }
                GradientStop { position: 0.7; color: Qt.rgba(0.9,0.9,0.9,0.8) }
            }
       }

       Desaturate {
                visible:if(effect == 4) {true} else {false}
              anchors.fill: baseImage
              source:baseImage
              desaturation: 0.7
          }








    Image {
        anchors.centerIn: baseImage
        width:baseImage.paintedWidth * 1.01
        height:baseImage.paintedHeight
        source:"graphics/imageborder.png"
    }



    }

    MouseArea {
        anchors.fill:parent
        onClicked:window_container.state = "Hide"
    }

}

