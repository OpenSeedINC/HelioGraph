import QtQuick 2.2
import QtQuick.Controls 2.2
import "main.js" as Scripts
import "openseed.js" as OpenSeed
//import "slides.js" as Slides

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
    property string sharetouser: ""

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


onStateChanged: if(popup.state == "Show") {}

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

           /* ListElement {
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
                type:"button"
                menuItem:5
                menuText:""
                buttonColor:"#5e2e2e"
                    //"#202020"
            }

            ListElement {
                type:"break"
                menuItem:0
                menuText:" "
                buttonColor:"black"
            }

            ListElement {
                type:"button"
                menuItem:6
                menuText:" "
                 buttonColor:"#2e2e2e"
            } */


            ListElement {
                type:"button"
                menuItem:3
                menuText:"Share"
                 buttonColor:"#202020"
            }

           /* ListElement {
                type:"button"
                menuItem:7
                menuText:"Share Private"
                 buttonColor:"#202020"
            } */

            ListElement {
                type:"break"
                menuItem:0
                menuText:" "
                buttonColor:"#202020"

            }

            ListElement {
                type:"button"
                menuItem:8
                menuText:"Web Link"
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
                                 case 1:qsTr("FaceBook");break;
                                 case 2:qsTr("Twitter");break;
                                 case 5:qsTr("G+");break;
                                 case 6:qsTr("Email");break;
                                 case 4:qsTr("Cancel");break;
                                 case 8:qsTr("Web Link");break;
                                 case 3:qsTr("Share");break;
                                 case 7:qsTr("Share Private");break;


                                 default:menuText;break;
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
                        color:if(buttonclicker.pressed == true) {"#8e4e4e"} else {buttonColor}

                    }


                    MouseArea {
                        id:buttonclicker
                        anchors.fill:parent
                        onClicked: switch(menuItem) {

                                   case 6:popup.state = "Hide";break;
                                   case 5:popup.state = "Hide";break;
                                   case 4:popup.state = "Hide";break;
                                   case 1:popup.state = "Hide";break;
                                   case 2:popup.state = "Hide";break;
                                   case 3:sharewith.state = "Show";break;
                                   case 7:sharewith.state = "Show";break;
                                   case 8:shareweb.state = "Show";break;
                                    default: break;
                                   }
                    }
        }

    }

    Item {
        id:sharewith
        width:parent.width
        height:parent.height

        states: [
            State {
                name:"Hide"
                PropertyChanges {
                    target: sharewith
                    x:parent.width

                }
            },
            State {
                name:"Show"
                PropertyChanges {
                    target:sharewith
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
                    target:sharewith
                    property: "x"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }

            }

        ]

        state:"Hide"


        Text {
            id:reportTitle
            text:qsTr("Share With")
            width:parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pointSize:if(parent.height > 0) { parent.height * 0.08} else {8}
            color:"white"
        }

        Rectangle {
            id:breaker
            anchors.top:reportTitle.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width:popup.width * 0.9
            height:title.height * 0.05
            color:"#202020"
        }

        Column {
            anchors.top:breaker.bottom
            anchors.topMargin:parent.height * 0.05
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom:okay.top
            width:parent.width * 0.9
            spacing:parent.height * 0.04


        Text {
            id:explain

            text:qsTr("Share image / images with another HelioGraph user including pictures marked private")
            width:parent.width * 0.9
            wrapMode:Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: if(parent.height > 0) {popup.height * 0.03} else {8}
            color:"white"
        }

        TextField {
            id:shareuser

            anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width * 0.98
            placeholderText: qsTr("HelioGraph User Name")
            text:sharetouser
            onTextChanged:sharetouser = text

        }

       /* CheckBox {
            id:library
            anchors.left:parent.left

            Text {
                text:qsTr("Share whole library")
                color:"white"
                anchors.left:parent.right
                anchors.leftMargin: parent.height * 0.03
                anchors.verticalCenter: parent.verticalCenter
            }
        } */

        }

        Rectangle {
            id:okay
            anchors.right:parent.right
            anchors.bottom:parent.bottom
            anchors.margins: 20
            width:canceltext.width * 1.2
            height:parent.height * 0.10
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
                //onClicked: OpenSeed.privacy_update(theindex,privacy+":;:"+rating,sharetouser),sharewith.state = "Hide",popup.state = "Hide"
                onClicked: OpenSeed.sendtouser(theindex,privacy+":;:"+rating,sharetouser),sharewith.state = "Hide",popup.state = "Hide"
            }
        }

        Rectangle {
            id:cancel
            anchors.left:parent.left
            anchors.bottom:parent.bottom
            anchors.margins: 20
            width:canceltext.width * 1.2
            height:parent.height * 0.10
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
                onClicked: sharewith.state = "Hide"
            }
        }

    }




    Item {
        id:shareweb
        width:parent.width
        height:parent.height

        states: [
            State {
                name:"Hide"
                PropertyChanges {
                    target: shareweb
                    x:parent.width

                }
            },
            State {
                name:"Show"
                PropertyChanges {
                    target:shareweb
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
                    target:shareweb
                    property: "x"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }

            }

        ]

        state:"Hide"


        Text {
            id:webTitle
            text:qsTr("Share to Web")
            width:parent.width
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: if(parent.height > 0) {parent.height * 0.08} else {8}
            color:"white"
        }

        Rectangle {
            id:breakerweb
            anchors.top:webTitle.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width:popup.width * 0.9
            height:title.height * 0.05
            color:"#202020"
        }

        Column {
            anchors.top:breakerweb.bottom
            anchors.topMargin:parent.height * 0.05
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom:okayweb.top
            width:parent.width * 0.9
            spacing:parent.height * 0.04


        Text {
            id:explainweb

            text:qsTr("Share image / images Exernally (Only public Images can be shared.)")
            width:parent.width * 0.9
            wrapMode:Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: if(parent.height > 0) {popup.height * 0.03} else {8}
            color:"white"
        }

        Text {

            text:qsTr("Tap to copy URL,then paste it where ever you like)")
            width:parent.width * 0.9
            wrapMode:Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: if(parent.height > 0) {popup.height * 0.03} else {8}
            color:"white"
        }

        TextField {
            id:weblink

            anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width * 0.98
            text:"https://www.vagueentertainment.com/HG/Share.php?username="+picowner+"&image="+imageindex
           // readOnly:true
            MouseArea {
                anchors.fill:parent
                onClicked:weblink.selectAll(),weblink.copy(),OpenSeed.touchpic("https://www.vagueentertainment.com/HG/Share.php?username="+picowner+"&image="+imageindex)
            }

        }

        CheckBox {
            id:libraryweb
            anchors.left:parent.left
            onCheckedChanged: if(checked == 1) {weblink.text = "https://www.vagueentertainment.com/HG/Share.php?username="+picowner+"&image=all"}
                              else {weblink.text = "https://www.vagueentertainment.com/HG/Share.php?username="+picowner+"&image="+imageindex}

            Text {
                text:qsTr("Share whole library")
                color:"white"
                anchors.left:parent.right
                anchors.leftMargin: parent.height * 0.03
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        }

        Rectangle {
            id:okayweb
            anchors.right:parent.right
            anchors.bottom:parent.bottom
            anchors.margins: 20
            width:cancelwebtext.width * 1.2
            height:parent.height * 0.10
            border.color:"lightgray"
            radius:8

            Text {
                id:okaywebtext
                text:qsTr("Okay")
                font.pixelSize: parent.height / 2
                anchors.centerIn: parent
            }
            MouseArea {
                anchors.fill:parent
                hoverEnabled: true
                onEntered: okay.color = "gray",okaytext.color = "white"
                onExited: okay.color = "white",okaytext.color = "black"
                onClicked: shareweb.state = "Hide",popup.state = "Hide"
            }
        }

        Rectangle {
            id:cancelweb
            anchors.left:parent.left
            anchors.bottom:parent.bottom
            anchors.margins: 20
            width:cancelwebtext.width * 1.2
            height:parent.height * 0.10
            border.color:"lightgray"
            radius:8

            Text {
                id:cancelwebtext
                text:qsTr("Cancel")
                font.pixelSize: parent.height / 2
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill:parent
                hoverEnabled: true
                onEntered: cancel.color = "gray",canceltext.color = "white"
                onExited: cancel.color = "white",canceltext.color = "black"
                onClicked: shareweb.state = "Hide"
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
