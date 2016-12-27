import QtQuick 2.0

import QtGraphicalEffects 1.0

Item {
    anchors.verticalCenter: parent.verticalCenter
    property int effect:0

    Rectangle {
        anchors.centerIn: backing
        width:if(selectedEffect == effect) {backing.width * 1.05} else {backing.width}
        height:if(selectedEffect == effect) {backing.height * 1.05} else {backing.height}
        color:"#9d9d9d"
        border.color:if(selectedEffect == effect) {"gold"} else {"black"}
        radius:8
    }

    Rectangle {
        id:backing
        anchors.fill:parent
        clip:true
        color:"#9d9d9d"


        Image {
            id:baseImage
            anchors.fill:parent
            source:thesource
            fillMode:Image.PreserveAspectCrop

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
                anchors.fill: baseImage
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
            anchors.fill:parent
            source:"graphics/imageborder.png"
        }
    }



}

