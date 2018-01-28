import QtQuick 2.0

import QtGraphicalEffects 1.0

Item {
    property int type:0
    property int effect:0
    property int overlay:0
    property int therotation:0
    property double thebrightness:0.0
    property double thecontrast:0.0
    property double theHue:0.0
    property double theSat:0.0
    property string thetitle:""
    property string theartist:""

    Rectangle {
        anchors.centerIn: backing
        width:if(selectedEffect == effect) {parent.width} else {parent.width}
        height:if(selectedEffect == effect) {parent.height} else {parent.height}
        color:"#4e4e4e"
        border.color:if(type == 0) {if(selectedEffect == effect) {"#7e4e4e"} else {"white"} } else if(type == 1) {if(selectedOverlay == overlay) {"#7e4e4e"} else {"white"} }
        border.width:4
        radius:8
    }

    Rectangle {
        id:backing
        anchors.horizontalCenter: parent.horizontalCenter
        width:parent.width * 0.98
        height:parent.height * 0.98
        clip:true
        color:"#202020"


        Image {
            id:baseImage
            anchors.top:parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width * 0.9
            height:parent.width * 0.9
            source:thesource
            fillMode:Image.PreserveAspectCrop
            rotation:therotation

        }


        Image {
            id:starter
            anchors.centerIn: baseImage
            width:baseImage.width
            height:baseImage.height
            source:thesource
            fillMode:Image.PreserveAspectCrop
            rotation:therotation
        }



             Colorize {
                      id:colorized
                     anchors.fill: baseImage
                     source: baseImage
                     hue: theHue
                     saturation: theSat
                     lightness: 0.0
                     rotation:therotation
                     visible:if(theSat != 0.0 || theHue != 0.0) {true} else {false}

                 }


             BrightnessContrast {
                      id:brightCon
                    anchors.fill: baseImage
                    source: if(colorized.visible == true) {colorized} else {baseImage}
                   // source:colorized
                    brightness: thebrightness
                    contrast: thecontrast
                    rotation:therotation
                    visible:if(thebrightness != 0.0 || thecontrast != 0.0) {true} else {false}
                }

             Image {
                 id:overlayers
                 anchors.fill: baseImage
                 source:switch(overlay) {

                        case 2: "graphics/overlay1.png";break;
                        case 3: "graphics/overlay2.png";break;
                        case 4: "graphics/overlay3.png";break;
                        default: "graphics/blank.png";break;
                        }
                 fillMode:Image.PreserveAspectFit

             }

           RadialGradient {
                id:radialWashout
                anchors.fill: baseImage
                visible:if(effect == 4) {true} else {false}

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(0,0,0,0) }
                    GradientStop { position: 0.7; color: Qt.rgba(0.9,0.9,0.9,0.8) }
                }
           }


        /*Image {
            anchors.fill:parent
            source:"graphics/imageborder.png"
        } */


           Text {
               id:title
               text:thetitle
               anchors.horizontalCenter: parent.horizontalCenter
               anchors.top:baseImage.bottom
               anchors.topMargin:parent.height * 0.01
               font.pointSize: if(parent.height > 0 ) {parent.height * 0.03 } else {8}
               color:"white"
           }
           Text {
               id:artist
               text:theartist
               anchors.horizontalCenter: parent.horizontalCenter
               anchors.top:title.bottom
               anchors.topMargin:parent.height * 0.01
               font.pointSize: if(parent.height > 0 ) {parent.height * 0.03 } else {8}
               color:"white"
           }
    }


    onEffectChanged: switch(effect) {
                     case 2:effect1();break;
                     case 3:effect2();break;
                     case 4:effect3();break;
                     case 5:effect5();break;

                     default:effect0();break;

                     }

    function effect0() {
        theSat = 0;
        theHue = 0;
        thecontrast = 0;
        thebrightness = 0;
    }

    function effect1() {
        theHue = 1;
        theSat = 0;
        thecontrast = 0;
        thebrightness = 0;

    }

    function effect2() {
        theSat = 0.30;
        theHue = 0.10;
        thecontrast = 0;
        thebrightness = 0;

    }

    function effect3() {

        theSat = 0.30;
        theHue = 0.10;
        thecontrast = 0;
        thebrightness = 0;

    }

    function effect4() {
        thebrightness = -0.1;
        thecontrast = 0.70;
        theHue = 1;
        theSat = 0.0;


    }
    function effect5() {
        theSat = 0.0;
        theHue = 1.0;
        thebrightness = -0.1;
        thecontrast = 0.60;

    }


}

