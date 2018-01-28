import QtQuick 2.2
import QtQuick.Controls 2.2

import QtGraphicalEffects 1.0


import "openseed.js" as OpenSeed
import "main.js" as Scripts

Item {
    id:popup

    //visible:if(newimages < fetchedimage) {true} else {false}
    //visible:false


    Rectangle {
        color:"#4e4e4e"
        anchors.fill: parent

        Rectangle {
            anchors.top:parent.top
            height:parent.height * 0.04
            width: parent.width
            color:"gray"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:parent.top
            anchors.topMargin:parent.height * 0.1
            color:"white"
            text:qsTr("Search")
            font.pointSize: if(parent.height > 0) {parent.height * 0.1 - text.length} else {8}
        }

        TextField {
            id:searchtext
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width * 0.90
        }


        Rectangle {
            id:okay
            anchors.right:parent.right
            anchors.bottom:parent.bottom
            anchors.margins: 20
            width:canceltext.width * 1.6
            height:parent.height * 0.20
            border.color:"lightgray"
            radius:8

            Text {
                id:okaytext
                text:qsTr("Okay")
                font.pixelSize: parent.height / 2
                anchors.centerIn: parent
            }
            MouseArea {
                anchors.fill:parent
                hoverEnabled: true
                onEntered: okay.color = "gray",okaytext.color = "white"
                onExited: okay.color = "white",okaytext.color = "black"
                onClicked:{
                            if(searchtext.text != "") {
                                progress.visible = true;
                                progress.state = "midscreen";
                                info = qsTr("Searching...");
                            searchstring = searchtext.text, popup.visible = false
                                //Scripts.load_stream("any","any",searchstring)
                            } else {
                                searchstring = " ", popup.visible = false

                            }
                            postslist.clear();

                    if(whichview == 1) {

                              Scripts.load_stream(" ",rate,searchstring);
                              OpenSeed.social_stream(" ",rate,searchstring);
                          }

                    if(whichview == 0) {

                        Scripts.load_library(2,searchstring);
                        OpenSeed.sync_library();
                    }

                    }
            }
        }

        Rectangle {
            id:cancel
            anchors.left:parent.left
            anchors.bottom:parent.bottom
            anchors.margins: 20
            width:canceltext.width * 1.6
            height:parent.height * 0.20
            border.color:"lightgray"
            radius:8

            Text {
                id:canceltext
                text:qsTr("Cancel")
                font.pixelSize: parent.height / 2
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill:parent
                hoverEnabled: true
                onEntered: cancel.color = "gray",canceltext.color = "white"
                onExited: cancel.color = "white",canceltext.color = "black"
                onClicked: popup.visible = false
            }
        }




        Rectangle {
            anchors.bottom:parent.bottom
            height:parent.height * 0.04
            width: parent.width
            color:"gray"
        }
    }
}
