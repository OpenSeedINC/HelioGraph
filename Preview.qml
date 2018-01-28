import QtQuick 2.0

import QtGraphicalEffects 1.0

Item {
    id:window_container
    property int effect:0
    property int overlay:0
    property int therotation:0
    property double thebrightness:0.0
    property double thecontrast:0.0
    property double theHue:0.0
    property double theSat:0.0
    property double xoffset:0.0
    property double yoffset:0.0

clip:true

   Rectangle {

        anchors.fill:parent
        clip:true
        color:"black"
        //color:"#9d9d9d"
}


   Image {
       id:starter
       anchors.centerIn: baseImage
       width:baseImage.width
       height:baseImage.height
       source:thesource
       fillMode:Image.PreserveAspectCrop
       rotation:therotation
      // x:xoffset
      // y:yoffset
   }

        Image {
            id:baseImage
            //anchors.fill:parent
           // anchors.centerIn: parent
            anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width * 1.01
            height:parent.height * 1.01

           // source:thefile
            source:thesource
            fillMode:Image.PreserveAspectCrop
            //mirror: if(window_container.rotation == -90) {true} else {false}
            rotation:therotation
           // x:xoffset
           // y:yoffset

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
            anchors.centerIn: parent
            width:parent.width * 1.01
            height:parent.height * 1.01
            source:switch(overlay) {

                   case 2:"graphics/overlay1.png";break;
                   case 3:"graphics/overlay2.png";break;
                   case 4:"graphics/overlay3.png";break;
                   default:"graphics/blank.png";break;
                   }

            fillMode:Image.Tile

        }

           RadialGradient {
                id:radialWashout
                anchors.fill: brightCon
                visible:if(effect == 4) {true} else {false}

                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(0,0,0,0) }
                    GradientStop { position: 0.7; color: Qt.rgba(0.9,0.9,0.9,0.8) }
                }
           }


        MouseArea {
            anchors.fill: parent
           // onMouseXChanged: xoffset = mouseX
           // onMouseYChanged: yoffset = mouseY


                    drag.target: baseImage
                        drag.axis: Drag.YAxis
                        //drag.active: true
                       // drag.minimumX: -baseImage.width
                       // drag.maximumX: baseImage.width
                        drag.minimumY: -baseImage.height + window_container.height
                        drag.maximumY: 0
        }



  /*  Image {
        anchors.centerIn:parent
        width:parent.width * 1
        height:parent.height * 1
        source:switch(overlay) {

               case 1:"graphics/imageborder.png";break;
               default:"graphics/blank.png";break;
           }
    } */

    onEffectChanged: switch(effect) {
                     case 2:effect1();break;
                     case 3:effect2();break;
                     case 4:effect3();break;
                     case 5:effect4();break;
                     case 6:effect5();break;

                     default:effect0();break;

                     }

    function effect0() {
        theSat = 0;
        theHue = 0;
        thecontrast = 0;
        thebrightness = 0;
    }

    function effect1() {
        theSat = 0;
        theHue = 1;
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
        thecontrast = 0.80;
        theHue = 1;
        theSat = 0;


    }
    function effect5() {
        theSat = 0;
        theHue = 1;

        thebrightness = -0.1;
        thecontrast = 0.80;



    }

    function clear() {
        effect =0;
        overlay=0;
        //therotation=0;
        thebrightness=0.0;
        thecontrast=0.0;
        theHue=0.0;
        theSat=0.0;
        //starter.source = "graphics/icon.png"
        //baseImage.source = "graphics/icon.png"
    }

}
