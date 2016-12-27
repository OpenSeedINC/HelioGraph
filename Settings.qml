import QtQuick 2.3
import Ubuntu.Components 1.3
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtSensors 5.3

import IO 1.0

import QtQuick.LocalStorage 2.0 as Sql

import "main.js" as Scripts
import "openseed.js" as OpenSeed


Item {
    id:window_container

    Rectangle {
        anchors.fill:parent
         color:"#4e4e4e"

    }



    Text {
        id:title
        anchors.top:parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        text:"Settings"
        color:"white"
        font.pointSize: parent.height * 0.08

    }

    Rectangle {
        id:titleborder
        anchors.top:title.bottom
        width:parent.width * 0.98
        height:parent.height * 0.01
        color:"gray"
    }

    Flickable {
        width:parent.width
        height:parent.height
        anchors.top:titleborder.bottom
        contentHeight: settingscolumn.height * 1.5
        contentWidth: width
        clip:true

        Column {
            id:settingscolumn
            width:parent.width
            height:bottom.y
            spacing: window_container.height * 0.03
           // clip:true

            Text {
                text:"User Name"
                font.pointSize: window_container.height * 0.05
                color:"white"
            }

            TextField {
               width:parent.width * 0.98
               anchors.horizontalCenter: parent.horizontalCenter
               placeholderText: "Change your Screen Name"
               id:newname
               text:username
               onTextChanged: username = text
            }


            Rectangle {
                //id:bottom
               // anchors.top:title.bottom
                width:parent.width * 0.98
                height:window_container.height * 0.01
                color:"gray"
            }

            Text {
                text:"Maxium Rating"
                font.pointSize: window_container.height * 0.05
                color:"white"
            }

            Row {
                width:parent.width * 0.95
                height:window_container.height * 0.1
                spacing:window_container.height * 0.01
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    width:height
                    height:parent.height
                    source:"graphics/E_ESRB.png"
                    fillMode:Image.PreserveAspectFit

                    Rectangle {
                        z:-1
                        width:parent.width * 1.01
                        height:parent.height * 1.01
                        color:"gold"
                        anchors.centerIn: parent
                        visible:if(rate == 0) {true} else {false}
                    }

                    MouseArea {
                        anchors.fill:parent
                        onClicked:rate = 0;
                    }


                }

                Image {
                    width:height
                    height:parent.height
                    source:"graphics/e10_ESRB.png"
                    fillMode:Image.PreserveAspectFit

                    Rectangle {
                        z:-1
                        width:parent.width * 1.01
                        height:parent.height * 1.01
                        color:"gold"
                        anchors.centerIn: parent
                        visible:if(rate == 1) {true} else {false}
                    }

                    MouseArea {
                        anchors.fill:parent
                        onClicked:rate = 1;
                    }
                }

                Image {
                    width:height
                    height:parent.height
                    source:"graphics/T_ESRB.png"
                    fillMode:Image.PreserveAspectFit

                    Rectangle {
                        z:-1
                        width:parent.width * 1.01
                        height:parent.height * 1.01
                        color:"gold"
                        anchors.centerIn: parent
                        visible:if(rate == 2) {true} else {false}
                    }

                    MouseArea {
                        anchors.fill:parent
                        onClicked:rate = 2;
                    }
                }

                Image {
                    width:height
                    height:parent.height
                    source:"graphics/M_ESRB.png"
                    fillMode:Image.PreserveAspectFit

                    Rectangle {
                        z:-1
                        width:parent.width * 1.01
                        height:parent.height * 1.01
                        color:"gold"
                        anchors.centerIn: parent
                        visible:if(rate == 3) {true} else {false}
                    }

                    MouseArea {
                        anchors.fill:parent
                        onClicked:rate = 3;
                    }
                }

                Image {
                    width:height
                    height:parent.height
                    source:"graphics/aO_ESRB.png"
                    fillMode:Image.PreserveAspectFit

                    Rectangle {
                        z:-1
                        width:parent.width * 1.01
                        height:parent.height * 1.01
                        color:"gold"
                        anchors.centerIn: parent
                        visible:if(rate == 4) {true} else {false}
                    }

                    MouseArea {
                        anchors.fill:parent
                        onClicked:rate = 4;
                    }
                }
            }

            Rectangle {
                //id:bottom
              //  anchors.top:title.bottom
                width:parent.width * 0.98
                height:window_container.height * 0.01
                color:"gray"
            }



            Text {
                text:"Flattr Account"
                font.pointSize: window_container.height * 0.05
                color:"white"
            }

            TextField {
               width:parent.width * 0.98
               anchors.horizontalCenter: parent.horizontalCenter
               placeholderText: "Just the profile name"
               id:flattrtext
               text:flattr
               onTextChanged: flattr = text
            }


            Rectangle {
                //id:bottom
               // anchors.top:title.bottom
                width:parent.width * 0.98
                height:window_container.height * 0.01
                color:"gray"
            }


            Text {
                text:"Patreon Account"
                font.pointSize: window_container.height * 0.05
                color:"white"
            }

            TextField {
               width:parent.width * 0.98
               anchors.horizontalCenter: parent.horizontalCenter
               placeholderText: "Just the username"
               id:patreontext
               text:patreon
               onTextChanged: patreon = text
            }


            Rectangle {
                //id:bottom
               // anchors.top:title.bottom
                width:parent.width * 0.98
                height:window_container.height * 0.01
                color:"gray"
            }


            Item {
                width:parent.width
                height:window_container.height * 0.08

                Rectangle {
                    id:okay
                    anchors.right:parent.right

                    anchors.margins: 20
                    width:canceltext.width * 1.2
                    height:parent.height
                    border.color:"lightgray"
                    radius:8

                    Text {
                        id:okaytext
                        text:"Okay"
                        font.pixelSize: parent.height / 2
                        anchors.centerIn: parent
                    }
                    MouseArea {
                        anchors.fill:parent
                        hoverEnabled: true
                        onEntered: okay.color = "gray",okaytext.color = "white"
                        onExited: okay.color = "white",okaytext.color = "black"
                        onClicked:{thefooter.state ="Show",window_container.visible = false,
                                  Scripts.store_setting(username,rate,patreon,flattr)
                                    }
                    }
                }

                Rectangle {
                    id:cancel
                    anchors.left:parent.left

                    anchors.margins: 20
                    width:canceltext.width * 1.2
                    height:parent.height
                    border.color:"lightgray"
                    radius:8

                    Text {
                        id:canceltext
                        text:"Cancel"
                        font.pixelSize: parent.height / 2
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill:parent
                        hoverEnabled: true
                        onEntered: cancel.color = "gray",canceltext.color = "white"
                        onExited: cancel.color = "white",canceltext.color = "black"
                        onClicked: thefooter.state ="Show",window_container.visible = false,postslist.clear(),stream_reload.running = true,get_stream.running = true
                    }
                }
            }

            Rectangle {
                id:bottom
                //anchors.top:title.bottom
                width:parent.width * 0.98
                height:window_container.height * 0.01
                color:"gray"
            }
        }


    }

}
