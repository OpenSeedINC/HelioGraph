import QtQuick 2.0
import QtGraphicalEffects 1.0

import "openseed.js" as OpenSeed

Flipable {
    id:flipable


    property double possibleWidth: 0
    property double possibleHeight: 0

    property string thedate:""
    property string theowner:""
    property string theimage:""
    property string thecomment:""
    property string theindex:""
    property int therotation:0
    property int effect:0
    property int privacy: 0

     property bool flipped: false
       // width:frontimage.width
       // height:frontimage.height

        width:possibleWidth
        height:possibleHeight

        //clip:true


    front: Item {
        clip:true
        id:thefront
        width:possibleWidth * 0.94
        height:possibleHeight * 0.94
            //anchors.horizontalCenter:parent.horizontalCenter
            anchors.centerIn: parent
            Rectangle {
                id:imagebacking
                //color:"#4e4e4e"
                color:"white"
               // width:frontimage.width
                //height:frontimage.height
                anchors.fill: parent
                //border.color:"gray"
                //border.width:width * 0.015

    }


        Image { id:frontimage
        source:theimage
        anchors.top: parent.top
        anchors.topMargin:parent.height * 0.01
        anchors.horizontalCenter: parent.horizontalCenter
        sourceSize.width:possibleHeight * 0.7
            sourceSize.height:possibleHeight * 0.7
            rotation:therotation
            width:if(therotation == 90 || therotation == 270) {parent.width * 0.9} else {parent.width * 0.9}
            height:if(therotation == 90 || therotation == 270) {parent.width * 0.9} else {parent.width * 0.9}
            fillMode:Image.PreserveAspectCrop


        }


        Colorize {
               visible:if(effect == 1) {true} else {false}
               anchors.fill: frontimage
               source: frontimage
               rotation:therotation
               hue: 0.0
               saturation: 0.0
               lightness: -0.1
           }

        Colorize {
               visible:if(effect == 2) {true} else {false}
               anchors.fill: frontimage
               source: frontimage
               rotation:therotation
               hue: 0.15
               saturation: 0.7
               lightness: -0.4
           }


        Colorize {
               visible:if(effect == 3) {true} else {false}
               anchors.fill: frontimage
               source: frontimage
               rotation:therotation
               hue: 0.15
               saturation: 0.7
               lightness: -0.4
           }

           RadialGradient {
                id:radialWashout
                anchors.fill: frontimage
                visible:if(effect == 3) {true} else {false}
                rotation:therotation
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(0,0,0,0) }
                    GradientStop { position: 0.7; color: Qt.rgba(0.9,0.9,0.9,0.8) }
                }
           }

           Desaturate {
                    visible:if(effect == 4) {true} else {false}
                  anchors.fill: frontimage
                  source:frontimage
                  desaturation: 0.7
                  rotation:therotation
              }


        Rectangle {
            anchors.top:frontimage.bottom
            anchors.topMargin: parent.height * 0.01
            anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width
            height:parent.height * 0.03
            color:"black"
        }

        Rectangle {
            //anchors.centerIn: picture_options
            anchors.horizontalCenter: picture_options.horizontalCenter
            anchors.verticalCenter: picture_options.verticalCenter
            anchors.verticalCenterOffset: picture_options.height * 0.04
            width:picture_options.width
            height:picture_options.height * 1.2
            color:"black"
            opacity:0.8
            radius:8
            visible:if(privacy == -1) {false} else {true}
        }

        MouseArea {
            anchors.fill:frontimage
            onClicked: viewpic.effect = effect,viewpic.theimage = theimage,viewpic.state = "Show"
        }

        Column {
            id:picture_options
            visible:if(privacy == -1) {false} else {true}
            anchors.bottom:imgborder.bottom
            anchors.right:parent.right
            anchors.bottomMargin:imgborder.height * 0.03

            height:parent.height * 0.2
            width:parent.width * 0.1
            spacing:frontimage.paintedHeight * 0.05

            Image {
                source:if(privacy == 0) {"graphics/stock_website.svg"} else {"graphics/lock.svg"}
                fillMode:Image.PreserveAspectFit
                width:parent.width * 0.8
                height:parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: { if(privacy == 0) {privacy = 1;} else {privacy = 0;}
                                OpenSeed.privacy_update(theindex,privacy);
                    }
                }

            }

            Image {
                source:"graphics/edit-delete.svg"
                fillMode:Image.PreserveAspectFit
                width:parent.width * 0.8
                height:parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
            }


        }


        Image {
            id:imgborder
            source: "graphics/imageborder.png"

            height: frontimage.height * 1.05
            width: frontimage.width * 1.12
            anchors.centerIn: frontimage
         }



        Column {
            id:shareopts
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:frontimage.bottom
            anchors.topMargin: parent.height * 0.06
            anchors.bottom:parent.bottom
            width:parent.width * 0.98
            spacing:parent.height * 0.02


            Row {
                //anchors.horizontalCenter: parent.horizontalCenter
                x:parent.width * 0.01
                width:parent.width * 0.99
                height:thefront.height * 0.06
                spacing: parent.width * 0.04

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                height:parent.height * 0.9
                width:parent.height * 0.9
                border.color: "gray"
                radius:5

                Image {
                    anchors.centerIn: parent
                    width:parent.width
                    height:parent.height
                    source:"graphics/like.png"
                }
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                height:parent.height * 0.9
                width:parent.height * 0.9
                border.color: "gray"
                radius:5

                Image {
                    anchors.centerIn: parent
                    width:parent.width
                    height:parent.height
                    source:"graphics/share.png"
                }
            }

        Text {
            id:publishDate
            width:parent.width - (parent.height * 5.5)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            //anchors.horizontalCenter: parent.horizontalCenter
            text:thedate
            wrapMode:Text.WordWrap

            font.pixelSize: thefront.height * 0.04

            Text {
                id:username
                width:parent.width
                horizontalAlignment: Text.AlignHCenter
                anchors.top:parent.bottom
                font.pixelSize: thefront.height * 0.03
                text:theowner
            }
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            height:parent.height * 0.9
            width:parent.height * 0.9
            border.color: "gray"
            radius:5

            Image {
                anchors.centerIn: parent
                width:parent.width
                height:parent.height
                source:"graphics/patreon.png"
            }
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            height:parent.height * 0.9
            width:parent.height * 0.9
            border.color: "gray"
            radius:5

            Image {
                anchors.centerIn: parent
                width:parent.width
                height:parent.height
                source:"graphics/flattr.png"
            }
        }

            }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width * 0.98
            height:thefront.height * 0.003
            color:"gray"


        }

        Text {
            id:title
            anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width * 0.9

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            //anchors.horizontalCenter: parent.horizontalCenter
            text:comment.replace(/&#x27;/g, "'");
            wrapMode:Text.WordWrap

            font.pixelSize: (thefront.height - text.length) * 0.03
        }


        }

        Image {
            source: "graphics/backbutton.png"
            anchors.bottom:parent.bottom
            anchors.left:parent.left
            anchors.leftMargin: parent.height * 0.005
            width:parent.height * 0.03
            height:parent.height * 0.03

            Text {
                anchors.left:parent.right
                anchors.verticalCenter: parent.verticalCenter
                text:"Comments"
            }

            MouseArea {
                anchors.top:parent.top
                anchors.bottom:parent.bottom
                width:parent.width * 5
                height:parent.height * 2
                onClicked: flipable.flipped = !flipable.flipped
            }
        }

        Image {
            source: "graphics/infoborder.png"

            height:shareopts.height * 1.1
            width:shareopts.width * 1.04
            anchors.centerIn: shareopts
            anchors.verticalCenterOffset: -shareopts.height * 0.04
         }

    }


       back:Item {
           //clip:true
           width:possibleWidth * 0.94
           height:possibleHeight * 0.94
           //anchors.horizontalCenter:parent.horizontalCenter
           anchors.centerIn: parent

               //anchors.centerIn: parent

               Rectangle {

                   color:"#4e4e4e"
                   //width:frontimage.width
                   //height:frontimage.height
                   anchors.fill: parent
                   border.color:"gray"


       }
           Image { id:backimage; source: "graphics/back.png"; anchors.centerIn: parent
           width:parent.width
           height:parent.height


       }

           ListView {
               enabled: if(flipped == 1) {true} else {false}
               width:parent.width * 0.98
               height:parent.height * 0.98
               anchors.centerIn: parent
               spacing:3

               model:ListModel {
                   id:comments

                   ListElement {
                       name:"tim"
                       comment:"Wow AWESOME!!"
                       date:"7-11-2016"
                       avatar:"graphics/avatar.png"

                   }
               }

               delegate: Comments {
                        width:backimage.width * 0.98
                        height:(backimage.height * 0.98) /7
                        thename:name
                        thecomment:comment
                        thedate:date
                        theavatar:avatar
               }

           }

           Image {
               source: "graphics/backbutton.png"
               anchors.bottom:parent.bottom
               anchors.left:parent.left
               anchors.leftMargin: parent.height * 0.005
               width:parent.height * 0.03
               height:parent.height * 0.03

               Text {
                   anchors.left:parent.right
                   anchors.verticalCenter: parent.verticalCenter
                   text:"Image"
               }

               MouseArea {
                   anchors.top:parent.top
                   anchors.bottom:parent.bottom
                   width:parent.width * 5
                   height:parent.height * 2
                   onClicked: flipable.flipped = !flipable.flipped
               }
           }

       }

       transform: Rotation {
           id: rotation
           origin.x: flipable.width/2
           origin.y: flipable.height/2
           axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
           angle: 0    // the default angle
       }

       states: State {
           name: "back"
           PropertyChanges { target: rotation; angle: 180 }
           when: flipable.flipped
       }

       transitions: Transition {
           NumberAnimation { target: rotation; property: "angle"; duration: 500 }
       }


   }

