import QtQuick 2.0

//import HelioGraph 1.0

import QtQuick.LocalStorage 2.0 as Sql

import "main.js" as Scripts
import "openseed.js" as OpenSeed

Item {
    id:popup

    property int newStream: 0
    property int newLibrary: 0
    property int newFollowing: 0
    property int newShared: 0
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


   // onStateChanged: OpenSeed.menu_notifications()

    Rectangle {
       anchors.fill: parent
       color:"#4e4e4e"
       border.color:Qt.rgba(0.1,0.1,0.1,0.7)
       border.width:8
    }

    ListView {
        anchors.left:parent.left
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.03
        anchors.leftMargin:parent.height * 0.01
        anchors.bottom:parent.bottom
        width:parent.width * 0.98
        spacing:parent.height * 0.01


        clip:true

        model: ListModel {
            id:menulist

            ListElement {
                type:"button"
                menuItem:1
                menuText:""

            }

            ListElement {
                type:"button"
                menuItem:4
                menuText:""

            }

            ListElement {
                type:"button"
                menuItem:6
                menuText:"Liked"

            }

            ListElement {
                type:"break"
                menuItem:0
                menuText:""

            }

            ListElement {
                type:"button"
                menuItem:2
                menuText:""

            }

            ListElement {
                type:"button"
                menuItem:5
                menuText:"Shared"

            }

            ListElement {
                type:"break"
                menuItem:0
                menuText:""

            }

            ListElement {
                type:"button"
                menuItem:3
                menuText:""

            }


        }

        delegate: Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:popup.width * 0.90
                    height:popup.height * 0.1

                    Rectangle {
                        visible:if(type == "button") {true} else {false}
                        anchors.fill:parent
                        radius:8
                        border.color:"black"
                        color:"#202020"

                        Text {
                            anchors.centerIn: parent
                            text:switch(menuItem) {
                                  case 1:qsTr("Stream");break;
                                  case 2:qsTr("My Pictures");break;
                                  case 3:qsTr("Settings");break;
                                  case 4:qsTr("Groups");break;
                                  case 5:qsTr("Inbox");break;
                                  case 6:qsTr("Liked");break;
                                 }

                            font.pointSize: if(parent.height > 0) {parent.height /3} else {8}
                            color:"white"

                        }
                        Image {
                            visible: switch(menuItem) {
                                     case 1:if(newStream > 0) {true} else {false};break;
                                     case 2:if(newLibrary > 0) {true} else {false};break;
                                     case 4:if(newFollowing > 0) {true} else {false};break;
                                     case 5:if(newShared > 0) {true} else {false};break;
                                     default:false;break;
                                     }


                            anchors.top:parent.top
                            anchors.right:parent.right
                            anchors.margins: parent.height * 0.05
                            source:"graphics/liked.png"
                            width:parent.height * 0.4
                            height:parent.height * 0.4
                        }
                    }

                    Rectangle {
                        visible:if(type == "break") {true} else {false}
                        anchors.centerIn:parent
                        width:parent.width
                        height:parent.height * 0.05
                        //radius:8
                        border.color:"black"
                        color:"#202020"

                    }


                    MouseArea {
                        anchors.fill:parent
                        onClicked:  {switch(menuItem) {

                                   case 4:follow_screen.state = "Show";break;
                                   case 5:whichview = 5;share_screen.state = "Show";OpenSeed.gatherShares();break;
                                   case 1:searchstring = " ";postslist.clear();whichview = 1; stream_reload.running = true; get_stream.running = true;break;
                                   case 2:searchstring = " ";postslist.clear(); reload.running = true;whichview = 0;break;
                                   case 3: thefooter.state = "Hide",whichview =4;settings.visible = true;break;
                                   case 6: postslist.clear();whichview = 1;Scripts.load_likes(" "," "," ");break;
                                    default: break;
                                   }
                            if(mainView.width < mainView.height) {
                                popup.state ="Hide";
                            }
                        }
                    }
        }

    }

}

