import QtQuick 2.0
//import QtWebView 1.1
//import Ubuntu.Web 0.2
import QtGraphicalEffects 1.0

import "main.js" as Scripts


Item {

    id:window_container

    property string theimage:"graphics/blankimage.png"
    property int effect:0
    property int newrotation:0
    property string special: " "
    property string theurl: "empty.html"
    property string thePicOwner:""

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

    onStateChanged: if(window_container.state == "Hide") {theurl = "empty.html",theimage ="graphics/blankimage.png"}

    Rectangle {
        anchors.fill: parent
        color:"black"
    }

    Text {
        anchors.bottom:parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        color:"white"
        font.pointSize: if(parent.height > 0) {parent.height * 0.03} else {8}
        wrapMode:Text.WordWrap
        width:parent.width
        text: qsTr("Double tap to close")

    }


    Item {
        id:contentFlick
        width:parent.width
        height:parent.height
        //contentWidth:parent.width
        //contentHeight: socialView.y + socialView.height

        MouseArea {
            anchors.fill:parent
            onDoubleClicked:progress.state = "Hide",window_container.state = "Hide"

        }

    Item {
        //anchors.centerIn: parent
        id:subject
        anchors.top:parent.top
        anchors.topMargin:0
        anchors.horizontalCenter: parent.horizontalCenter
       // width:if(parent.height > parent.width) {if(baseImage.implicitWidth > parent.width) {parent.height} else {parent.width} }else {parent.width }
       // height:if(parent.height > parent.width) {if(baseImage.implicitWidth > parent.width) {parent.width} else {parent.height} }else {parent.height }
        //rotation:if(parent.height > parent.width) {if(baseImage.implicitWidth > parent.width) {90} else {0} } else {0}
        //anchors.fill: parent
        width:parent.width * 0.95
        height:parent.width * 0.95
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
           id:specialborder
           /*source:switch(special) {
                     case "#teaminstinct": "graphics/instinct.png";break;
                     case "#teamvalor":"graphics/valor.png";break;
                      case "#teammystic":"graphics/mystic.png";break;
                      case "#soundcloud": "graphics/soundcloud.png";break;
                      case "#jamendo": "graphics/jamendo.png";break;
                      case "#youtube": "graphics/youtube.png";break;
                      default:"graphics/blank.png";break;
                  } */
           source:special

           //anchors.centerIn: baseImage
           height:baseImage.height * 0.2
           width:baseImage.height * 0.2
           anchors.bottom:baseImage.bottom
           anchors.right: baseImage.right
           anchors.margins: baseImage.height * 0.02
           fillMode: Image.PreserveAspectFit
           rotation:-1 * newrotation
       }





    Image {
        anchors.centerIn: baseImage
        width:baseImage.paintedWidth * 1.01
        height:baseImage.paintedHeight
        source:"graphics/imageborder.png"
    }

    MouseArea {
        anchors.fill:parent
       /* onClicked:{
            if(subject.anchors.topMargin == 0) {socialView.visible = false, preview_grid.visible = false,subject.anchors.topMargin = parent.height - subject.height /1.5}
                    else {if(theurl != "empty.html") {socialView.visible = true} else {preview_grid.visible = true} subject.anchors.topMargin =0}

        } */
        onDoubleClicked:subject.anchors.topMargin == 0,progress.state = "Hide",window_container.state = "Hide";
    }


    }

    Rectangle {
        color:"#202020"
        anchors.centerIn: preview_grid
        width:window_container.width * 0.95
        height:preview_grid.height * 1.05
        radius:10

    }

   /* WebView {
        id:socialView
        anchors.top:subject.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: parent.height * 0.02
        visible:if(theurl != "empty.html") {true} else {false}

        width:parent.width * 0.92
        height:window_container.height

        url:theurl


        Text {
            anchors.centerIn: parent
            text:qsTr("Press and Hold")
            color:"white"
            font.pointSize: if(parent.height > 0) {parent.height * 0.03} else {8}

            Rectangle {
                anchors.centerIn: parent
                width:parent.width * 1.2
                height:parent.height * 1.1
                color:"black"
                opacity: 0.6
                radius:8
                z:-1
            }
        }

       MouseArea {
            anchors.fill: parent
            onPressAndHold:Qt.openUrlExternally(socialView.url)
            propagateComposedEvents: true

        }

    } */

    GridView {
        id:preview_grid
        anchors.top:subject.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: parent.height * 0.02
        clip:true
        //enabled:false

        anchors.bottom: parent.bottom

        visible:if(theurl != "empty.html") {false} else {true}
        width:parent.width * 0.92
        //height:window_container.height
        cellWidth: width * 0.5
        cellHeight:width * 0.5
         onVisibleChanged: if(visible == true) {Scripts.viewOthers(thePicOwner)}


        model:ListModel {
            id:imagelist

            ListElement {
                img:"graphics/blankimage.png"
            }
        }

        delegate: Item {
            width:preview_grid.cellWidth
            height:preview_grid.cellHeight
            Image {

                width:parent.width * 0.9
                height:parent.height * 0.9
                anchors.centerIn: parent

                sourceSize.width: preview_grid.cellWidth * 0.9
                sourceSize.height: preview_grid.cellHeight * 0.9
                source:img
                fillMode:Image.PreserveAspectCrop
            }
            MouseArea {
                anchors.fill: parent
                onClicked:console.log("clicked on the image"),theimage = img
            }
        }


        add: Transition {
                //NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
                NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 200 }
            }



    }


    }



}

