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
    property string imageindex: " "

    property string number: "0"
    property string list:""
    property string maintitle:""
    property string picowner:" "
    property int follow: 0
    property int silenced: 0

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


onStateChanged: if(popup.state == "Show") {Scripts.checkstuff(picowner)}

    Rectangle {
       anchors.fill: parent
       color:"#4e4e4e"
       border.color:Qt.rgba(0.1,0.1,0.1,0.7)
       border.width:2
    }
 Item {
     id:notYouImage
     height:parent.height
     width:parent.width
     visible: if(privacy == -1) {true} else {false}

    Text {
        id:title
        anchors.top:parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            text:picowner
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
        anchors.bottomMargin: parent.height * 0.03
        width:parent.width * 0.98
        spacing:parent.height * 0.02


        clip:true

        model: ListModel {
            id:menulist

            ListElement {
                type:"button"
                menuItem:1
                menuText:""
                 buttonColor:"#202020"
            }

            ListElement {
                type:"button"
                menuItem:2
                menuText:" "
                 buttonColor:"#202020"


            }
            ListElement {
                type:"break"
                menuItem:0
                menuText:" "
                buttonColor:"black"
            }

            ListElement {
                type:"button"
                menuItem:5
                menuText:""
                buttonColor:"#5e2e2e"
                    //"#202020"
            }

            ListElement {
                type:"button"
                menuItem:6
                menuText:" "
                 buttonColor:"#2e2e2e"
            }

            ListElement {
                type:"break"
                menuItem:0
                menuText:" "
                buttonColor:"#202020"

            }

           /* ListElement {
                type:"button"
                menuItem:3
                menuText:qsTr("Share Private")
                 buttonColor:"#202020"
            } */


            ListElement {
                type:"button"
                menuItem:4
                menuText:""
                buttonColor:"#202020"

            }
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
                            text:switch(menuItem) {
                                 case 1:qsTr("Pictures");break;
                                 case 2:if(follow == 0){qsTr("Follow")} else {qsTr("Unfollow")};break;
                                 case 6:if(silenced == 0){qsTr("Silence")} else {qsTr("Unsilence")};break;
                                 case 4:qsTr("Cancel");break;
                                 case 5:qsTr("Report");break;
                                 default:menuText;break;
                                 }
                            font.pointSize:if(parent.height > 0) { parent.height /3 } else {8}
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
                        onClicked: switch(menuItem) {

                                   case 6:OpenSeed.silence(picowner),popup.state = "Hide";break;
                                   case 5:reports.state = "Show";break;
                                   case 4:popup.state = "Hide";break;
                                   case 1:searchstring = picowner,stream_reload.running = true,get_stream.running = true;popup.state = "Hide";break;
                                   case 2:OpenSeed.follow(picowner),popup.state = "Hide";break;
                                   case 3:popup.state ="Hide";break;
                                    default: break;
                                   }
                    }
        }

    }

    Item {
        id:reports
        width:parent.width
        height:parent.height

        states: [
            State {
                name:"Hide"
                PropertyChanges {
                    target: reports
                    x:parent.width

                }
            },
            State {
                name:"Show"
                PropertyChanges {
                    target:reports
                    x:0

                }
            }

        ]

        Rectangle {

            width:parent.width
            height:parent.height
            color:"#4e4e4e"
            //"#8e4e4e"
        }

        transitions: [
            Transition {
                from: "Hide"
                to: "Show"
                reversible: true

                NumberAnimation {
                    target:reports
                    property: "x"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }

            }

        ]

        state:"Hide"


        Text {
            id:reportTitle
            text:qsTr("Report")
            width:parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pointSize:if(parent.height > 0) { parent.height * 0.08 } else {8}
            color:"white"
        }

        Rectangle {
            anchors.top:reportTitle.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width:popup.width * 0.9
            height:title.height * 0.05
            color:"#202020"
        }

        ListView {
            anchors.left:parent.left
            anchors.top: reportTitle.bottom
            anchors.topMargin: parent.height * 0.03
            anchors.leftMargin:parent.height * 0.01
            anchors.bottom:parent.bottom
            width:parent.width * 0.98
            spacing:parent.height * 0.01


            clip:true

            model: ListModel {
                id:reportlist

                ListElement {
                    type:"button"
                    menuItem:1
                    menuText:""
                     buttonColor:"#202020"
                }

                ListElement {
                    type:"button"
                    menuItem:2
                    menuText:""
                     buttonColor:"#202020"

                }

                ListElement {
                    type:"button"
                    menuItem:3
                    menuText:""
                    buttonColor:"#202020"
                }

                ListElement {
                    type:"break"
                    menuItem:0
                    menuText:" "
                    buttonColor:"#202020"

                }

                ListElement {
                    type:"button"
                    menuItem:4
                    menuText:""
                    buttonColor:"#202020"

                }
            }

            delegate: Item {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width:popup.width * 0.90
                        height:popup.height * 0.13

                        Rectangle {
                            visible:if(type == "button") {true} else {false}
                            anchors.fill:parent
                            radius:8
                            border.color:"black"
                            color:buttonColor

                            Text {
                                anchors.centerIn: parent
                                text:switch(menuItem) {
                                     case 1:qsTr("Improper Rating");break;
                                     case 2:qsTr("Illegal");break;
                                     case 3:qsTr("Copy Righted");break;
                                     case 4:qsTr("Cancel");break;
                                     default:" ";break;
                                     }

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
                            color:if(reportclicker.pressed == true) {"#8e4e4e"} else {buttonColor}

                        }


                        MouseArea {
                            id:reportclicker
                            anchors.fill:parent
                            onClicked: switch(menuItem) {



                                       case 4:reports.state = "Hide";break;
                                       case 1:OpenSeed.report(picowner,imageindex,1),reports.state = "Hide";break;
                                       case 2:OpenSeed.report(picowner,imageindex,2),reports.state = "Hide";break;
                                       case 3:OpenSeed.report(picowner,imageindex,3),reports.state = "Hide";break;
                                        default:reports.state ="Hide"; break;
                                       }
                        }
            }

        }

    }

 }

 Item {
     id:youImage
     height:parent.height
     width:parent.width
     visible: if(privacy != -1) {true} else {false}

    Text {
        id:edittitle
        anchors.top:parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            text:qsTr("Edit")
            width:parent.width * 0.98
            wrapMode:Text.WordWrap
            color:"white"
            font.pointSize:if(parent.height > 0) {parent.height * 0.06} else {8}


    }
    Rectangle {
        anchors.top:edittitle.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width:popup.width * 0.9
        height:title.height * 0.05
        color:"#202020"
    }

    ListView {
        anchors.left:parent.left
        anchors.top: edittitle.bottom
        anchors.topMargin: parent.height * 0.03
        anchors.leftMargin:parent.height * 0.01
        anchors.bottom:parent.bottom
        anchors.bottomMargin: parent.height * 0.03
        width:parent.width * 0.98
        spacing:parent.height * 0.02


        clip:true

        model: ListModel {
            id:editMenulist

            ListElement {
                type:"button"
                menuItem:1
                menuText:""
                 buttonColor:"#202020"
            }

            ListElement {
                type:"button"
                menuItem:2
                menuText:" "
                 buttonColor:"#202020"


            }
            ListElement {
                type:"break"
                menuItem:0
                menuText:" "
                buttonColor:"black"
            }

            ListElement {
                type:"button"
                menuItem:5
                menuText:""
                buttonColor:"#5e2e2e"
                    //"#202020"
            }

          /* ListElement {
                type:"button"
                menuItem:6
                menuText:" "
                 buttonColor:"#2e2e2e"
            } */

            ListElement {
                type:"break"
                menuItem:0
                menuText:" "
                buttonColor:"#202020"

            }

            ListElement {
                type:"button"
                menuItem:3
                menuText:" "
                 buttonColor:"#202020"
            }


            ListElement {
                type:"button"
                menuItem:4
                menuText:""
                buttonColor:"#202020"

            }
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
                            text:switch(menuItem) {
                                 case 1:qsTr("Edit and Replace");break;
                                 case 2:qsTr("Remix");break;
                                 case 3:if(privacy == 0){qsTr("Make Private")} else {qsTr("Make Public")};break;
                                 case 4:qsTr("Cancel");break;
                                 case 5:qsTr("Change Rating");break;
                                 default:menuText;break;
                                 }
                            font.pointSize:if(parent.height > 0) { parent.height /3 } else {8}
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
                        color:if(editclicker.pressed == true) {"#8e4e4e"} else {buttonColor}

                    }


                    MouseArea {
                        id:editclicker
                        anchors.fill:parent
                        onClicked: switch(menuItem) {

                                   case 1:viewfinder.thesource=theimage.split("_stream")[0]+".jpg",viewfinder.thefile=theimage.split("_")[0]+".jpg",viewfinder.state = "Show",popup.state = "Hide";break;
                                   case 2:viewfinder.thesource=theimage,viewfinder.thefile=theimage,viewfinder.state = "Show",popup.state = "Hide";break;
                                   case 3:popup.state = "Hide";break;
                                   case 4:popup.state = "Hide";break;
                                   case 5:popup.state = "Hide";break;
                                   //case 6:popup.state = "Hide";break;

                                    default: break;
                                   }
                    }
        }

    }

    Item {
        id:rates
        width:parent.width
        height:parent.height

        states: [
            State {
                name:"Hide"
                PropertyChanges {
                    target: rates
                    x:parent.width

                }
            },
            State {
                name:"Show"
                PropertyChanges {
                    target:rates
                    x:0

                }
            }

        ]

        Rectangle {

            width:parent.width
            height:parent.height
            color:"#4e4e4e"
            //"#8e4e4e"
        }

        transitions: [
            Transition {
                from: "Hide"
                to: "Show"
                reversible: true

                NumberAnimation {
                    target:rates
                    property: "x"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }

            }

        ]

        state:"Hide"


        Text {
            id:ratesTitle
            text:qsTr("Change Rating")
            width:parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pointSize:if(parent.height > 0) { parent.height * 0.08 } else {8}
            color:"white"
        }

        Rectangle {
            anchors.top:ratesTitle.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width:popup.width * 0.9
            height:title.height * 0.05
            color:"#202020"
        }

        ListView {
            anchors.left:parent.left
            anchors.top: ratesTitle.bottom
            anchors.topMargin: parent.height * 0.03
            anchors.leftMargin:parent.height * 0.01
            anchors.bottom:parent.bottom
            width:parent.width * 0.98
            spacing:parent.height * 0.01


            clip:true

            model: ListModel {
                id:rateslist

                ListElement {
                    type:"button"
                    menuItem:1
                    menuText:""
                     buttonColor:"#202020"
                }

                ListElement {
                    type:"button"
                    menuItem:2
                    menuText:""
                     buttonColor:"#202020"

                }

                ListElement {
                    type:"button"
                    menuItem:3
                    menuText:""
                    buttonColor:"#202020"
                }

                ListElement {
                    type:"break"
                    menuItem:0
                    menuText:" "
                    buttonColor:"#202020"

                }

                ListElement {
                    type:"button"
                    menuItem:4
                    menuText:""
                    buttonColor:"#202020"

                }
            }

            delegate: Item {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width:popup.width * 0.90
                        height:popup.height * 0.13

                        Rectangle {
                            visible:if(type == "button") {true} else {false}
                            anchors.fill:parent
                            radius:8
                            border.color:"black"
                            color:buttonColor

                            Text {
                                anchors.centerIn: parent
                                text:switch(menuItem) {
                                     case 1:qsTr("Improper Rating");break;
                                     case 2:qsTr("Illegal");break;
                                     case 3:qsTr("Copy Righted");break;
                                     case 4:qsTr("Cancel");break;
                                     default:" ";break;
                                     }

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
                            color:if(ratesclicker.pressed == true) {"#8e4e4e"} else {buttonColor}

                        }


                        MouseArea {
                            id:ratesclicker
                            anchors.fill:parent
                            onClicked: switch(menuItem) {



                                       case 4:rates.state = "Hide";break;
                                       case 1:OpenSeed.report(picowner,imageindex,1),rates.state = "Hide";break;
                                       case 2:OpenSeed.report(picowner,imageindex,2),rates.state = "Hide";break;
                                       case 3:OpenSeed.report(picowner,imageindex,3),rates.state = "Hide";break;
                                        default:rates.state ="Hide"; break;
                                       }
                        }
            }

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
