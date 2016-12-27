import QtQuick 2.0

import IO 1.0

import QtQuick.LocalStorage 2.0 as Sql

import "main.js" as Scripts
import "openseed.js" as OpenSeed

Item {
    id:popup
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
                menuText:"Stream"
            }

            ListElement {
                type:"button"
                menuItem:2
                menuText:"My Pictures"

            }

            ListElement {
                type:"break"
                menuItem:0
                menuText:""
            }

            ListElement {
                type:"button"
                menuItem:3
                menuText:"Settings"
            }

            /*ListElement {
                type:"button"
                menuItem:4
                menuText:"Sync Now"

            } */
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
                            text:menuText
                            font.pointSize: parent.height /3
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
                        color:"#202020"

                    }


                    MouseArea {
                        anchors.fill:parent
                        onClicked: switch(menuItem) {

                                   case 4:searchstring = " ";postslist.clear(); reload.running = true;get_library.running = true;break;
                                   case 1:searchstring = " ";postslist.clear(); stream_reload.running = true; get_stream.running = true;break;
                                   case 2:searchstring = " ";postslist.clear(); reload.running = true;break;
                                   case 3: thefooter.state = "Hide",settings.visible = true;break;
                                    default: break;
                                   }
                    }
        }

    }

}

