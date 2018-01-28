import QtQuick 2.2
import QtQuick.Controls 2.2


import "main.js" as Scripts
import "openseed.js" as OpenSeed
import "slides.js" as Slides

import QtQuick.LocalStorage 2.0 as Sql



Rectangle {

    id:popup
    color:"white"
    border.color:"gray"
    border.width:10
    radius:8

    property string number: "0"
    property string list:""
    property string maintitle:""
    property string picowner:" "

    clip: true


    states: [
        State {
            name: "Show"
            PropertyChanges {
                target:popup
                visible:true
            }
        },
        State {
            name: "Hide"
            PropertyChanges {
                    target:popup
                    visible:false
            }
        }


    ]
    state:"Hide"

    onStateChanged: if(popup.state == "Show") {followlist.clear(),Scripts.load_shares()}


    Rectangle {
       anchors.fill: parent
       color:"#4e4e4e"
       border.color:Qt.rgba(0.1,0.1,0.1,0.7)
       border.width:2
    }

    Text {
        id:title
        anchors.top:parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            text:qsTr("Inbox")
            width:parent.width * 0.98
            wrapMode:Text.WordWrap
            color:"white"
            font.pointSize:if(parent.height > 0) {parent.height * 0.06} else {8}


    }
    Rectangle {
        anchors.top:title.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width:popup.width * 0.9
        height:title.height * 0.05
        color:"#202020"
    }

    ListView {
        anchors.left:parent.left
        anchors.top: title.bottom
        anchors.topMargin: parent.height * 0.03
        anchors.leftMargin:parent.height * 0.01
        anchors.bottom:parent.bottom
        width:parent.width * 0.98
        spacing:parent.height * 0.02


        clip:true

        model: ListModel {
            id:followlist

        }

        delegate: Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:popup.width * 0.90
                    height:popup.height * 0.14

                    Rectangle {
                        visible:if(type == "button") {true} else {false}
                        anchors.fill:parent
                        radius:8
                        border.color:"black"
                        color:buttonColor

                        Text {
                            anchors.centerIn: parent
                            text:menuText
                            font.pointSize: if(parent.height > 0) {parent.height /3} else {8}
                            color:"white"

                        }
                    }

                    Rectangle {
                        visible:if(type == "break") {true} else {false}
                        anchors.centerIn:parent
                        width:parent.width
                        height:parent.height * 0.05
                        //radius:8
                        border.color:"black"
                        color:if(buttonclicker.pressed == true) {"#8e4e4e"} else {buttonColor}

                    }


                    MouseArea {
                        id:buttonclicker
                        anchors.fill:parent
                        onClicked:postslist.clear(),Scripts.load_inbox(" ",menuText," "),popup.state = "Hide";

                    }
        }

    }

    Rectangle {
        id:addbutton
        anchors.bottom:popup.bottom
        anchors.bottomMargin: parent.height * 0.02
       // anchors.right: parent.right
        anchors.horizontalCenter: parent.horizontalCenter
        width:parent.width * 0.98
        height:parent.height * 0.08
        color:"#4e4e4e"
        border.color:"gray"
        radius:8

        Text {
            anchors.centerIn: parent
            color:"white"
            text:qsTr("Cancel")
            font.pointSize:if(parent.height > 0) {parent.height /2} else {8}

        }

        MouseArea {

            anchors.fill: parent
            onClicked:{popup.state = "Hide"
            }
       }
    }

    Image {
        anchors.centerIn: parent
        width:parent.width * 1.01
        height:parent.height * 1.01
        source:"graphics/infoborder.png"
    }


}
