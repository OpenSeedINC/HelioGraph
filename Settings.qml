import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtSensors 5.3
//import QtQuick.Controls 1.2

import IO 1.0

import QtQuick.LocalStorage 2.0 as Sql

import "main.js" as Scripts
import "openseed.js" as OpenSeed


Item {
    id:window_container

    onVisibleChanged: if(visible == true) {Scripts.groups_list(); if(privsetting == 0) {pubcheck.checked = true,privcheck.checked =false} else {pubcheck.checked = false,privcheck.checked =true}}

    property int puborpriv: privsetting
    property int uporigin:0
    property int fastcapt:0



    Rectangle {
        anchors.fill:parent
         color:"#4e4e4e"

    }



    Text {
        id:title
        anchors.top:parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        text:qsTr("Settings")
        color:"white"
        font.pixelSize: parent.width * 0.07

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
        anchors.topMargin: window_container.height * 0.02
        contentHeight: settingscolumn.height + cancel.height * 1.4
        contentWidth: width
        clip:true

        Column {
            id:settingscolumn
            width:parent.width
            height:bottom.y
            spacing: window_container.height * 0.03
           // clip:true

            Item {
                width:parent.width
                height:window_container.height * 0.1

                Image {
                    id:avatar
                    anchors.left:parent.left
                    width:parent.height
                    height:parent.height
                    source:"graphics/avatar.png"
                }

            Text {
                id:screenname
                width:parent.width * 0.8
                anchors.left:avatar.right
                anchors.top:avatar.top
                anchors.right:screennameedit.left
                //text:qsTr("Screen Name")
                text:if(publicname == " ") {qsTr("Screen Name")} else {publicname}
                font.pixelSize: parent.width * 0.07

                color:"white"
            }

            Rectangle {
                id:screennameedit
                width:screenname.height * 0.9
                height:screenname.height * 0.9
                anchors.right:parent.right
                anchors.rightMargin: parent.height * 0.1
                anchors.verticalCenter: screenname.verticalCenter
                radius: 4

                Image {
                    anchors.centerIn: parent
                    source: if(newname.visible == false) {"graphics/edit.svg"} else {"graphics/save.svg"}
                    width:parent.width * 0.8
                    height:parent.height * 0.8

                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: if(newname.visible == false) {newname.visible = true} else {newname.visible = false}
                }
            }

            TextField {
               //width:screenname.width
               height:screenname.height
               anchors.left: screenname.left
               anchors.right:screennameedit.left
               anchors.rightMargin:parent.height * 0.04
               placeholderText: qsTr("Change your Screen Name")
               id:newname
               text:if(publicname == " ") {username} else {publicname}
               onTextChanged: publicname = text
               visible: false
            }

           /* Text {
                text:qsTr("To share private images or libraries please use your OpenSeed Account shown below")
                width:parent.width
                wrapMode:Text.WordWrap
                font.pointSize: if(parent.height > 0) {window_container.height * 0.02} else {8}
                color:"white"
            } */

            Text {
                anchors.bottom:avatar.bottom
                anchors.left:avatar.right
               width:parent.width * 0.98

               wrapMode:Text.WordWrap
               font.pixelSize: parent.width * 0.07

               text: qsTr("OpenSeed Account: ")+username
               id:lib
               color:"white"

            }

            }


            Rectangle {
                //id:bottom
               // anchors.top:title.bottom
                width:parent.width * 0.98
                height:window_container.height * 0.01
                color:"gray"
            }



            Text {
                text:qsTr("Capture Settings")
                font.pixelSize: parent.width * 0.07

                color:"white"
            }

            Rectangle {
                //id:bottom
               // anchors.top:title.bottom
                width:parent.width * 0.98
                height:window_container.height * 0.005
                color:"gray"
            }

            Text {
                text:qsTr("Default Publication")
                font.pixelSize: parent.width * 0.07

                color:"white"
            }

            Row {
                width:parent.width
                height:window_container.height * 0.05
                spacing:window_container.height * 0.05

                Text {
                    text:"Public: "
                    font.pixelSize: parent.width * 0.07

                    color:"white"

            CheckBox {
                id:pubcheck
                anchors.left:parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: parent.height
                //text:"Public"
                checked:if(puborpriv == 0) {true} else {false}
                onCheckedChanged: if(checked == true) {puborpriv = 0;checked = true;privcheck.checked = false}
            }
                }

                Text {
                    text:"Private: "
                    font.pixelSize: parent.width * 0.07

                    color:"white"

            CheckBox {
                id:privcheck
                anchors.left:parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: parent.height
                //text:"Private"
                checked:if(puborpriv == 1) {true} else {false}
                onCheckedChanged:if(checked == true) {puborpriv = 1;checked = true;pubcheck.checked = false}

            }

                }

            }

          /*  Text {
                text:qsTr("Upload Original: ")
                font.pointSize: if(parent.height > 0) {window_container.height * 0.025} else {5}
                color:"white"

                CheckBox {
                    anchors.left:parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: parent.height
                    //text:"Private"
                    checked:false
                    onCheckedChanged: if(checked == true) {uporigin = 1} else {uporigin = 0}

                }
            } */

            Text {
                text:qsTr("Fast Capture: ")
                font.pixelSize: parent.width * 0.07

                color:"white"

                CheckBox {
                    anchors.left:parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: parent.height
                    //text:"Private"
                    checked:false
                    onCheckedChanged: if(checked == true) {fastcapt = 1} else {fastcapt = 0}

                }
            }
            Text {
                wrapMode: Text.WordWrap
                width:parent.width
                text:qsTr("Fast Capture: The camera is set to a fixed focual mode (infinity) and skips the effects and comments dialog. The images are set as private for you to apply modifications at a later date.")
                font.pixelSize: parent.width * 0.07

                color:"white"
        }


            Rectangle {
                //id:bottom
               // anchors.top:title.bottom
                width:parent.width * 0.98
                height:window_container.height * 0.01
                color:"gray"
            }



            Text {
                text:qsTr("View Settings")
                font.pixelSize: parent.width * 0.07

                color:"white"
            }

            Rectangle {
                //id:bottom
               // anchors.top:title.bottom
                width:parent.width * 0.98
                height:window_container.height * 0.005
                color:"gray"
            }


            Text {
                text:qsTr("Maxium Rating")
                font.pixelSize: parent.width * 0.07

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

            Text {
                text:qsTr("Override Pin")
                font.pixelSize: parent.width * 0.07

                color:"white"
            }

            TextField {
               width:parent.width * 0.75
               //anchors.horizontalCenter: parent.horizontalCenter
               placeholderText: qsTr("Add to unlock images over your prefered rating")
               id:userpin
               text:pin
               onTextChanged: pin = text
               echoMode: TextInput.Password
               maximumLength: 6
            }

            Rectangle {
                //id:bottom
              //  anchors.top:title.bottom
                width:parent.width * 0.98
                height:window_container.height * 0.01
                color:"gray"
            }

            Text {
                id:grouptitle
                text:qsTr("Groups:")
                width:parent.width * 0.89
                font.pixelSize: parent.width * 0.07

                color:"white"

            Rectangle {
                anchors.verticalCenter: grouptitle.verticalCenter
                anchors.left:parent.right
                radius:width /2
                width:grouptitle.height
                height:grouptitle.height

                Image {
                    anchors.centerIn: parent
                    source:"graphics/add.svg"
                    height:parent.height * 0.8
                    width:parent.width * 0.8
                }
                MouseArea {
                anchors.fill: parent
                onClicked: groupedit.editrating = 0,groupedit.groupname = "New Group",groupedit.visible = true

                }

            }
            }

            Rectangle {
                //id:bottom
              //  anchors.top:title.bottom
                width:parent.width * 0.98
                height:window_container.height * 0.005
                color:"gray"
            }

            ListView {
                spacing:window_container.height * 0.01
                width:parent.width
                height:contentHeight
                clip:true

                model: groups

                delegate: Item {
                    width:parent.width
                    height:mainView.height * 0.1

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width:parent.width * 0.98
                        height:parent.height
                        color:"#404040"

                        Text {
                            id:groupname
                            anchors.left:parent.left
                            anchors.leftMargin:parent.height * 0.1
                            text:name
                            width:parent.width * 0.1
                            font.pixelSize: parent.width * 0.07

                            color:"white"

                        }

                        Row {
                            anchors.right:parent.right
                            //width:parent.width * 0.5
                            height:parent.height * 0.5
                            spacing:window_container.height * 0.01
                            anchors.verticalCenter: parent.verticalCenter

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
                                    visible:if(grouprating == 0) {true} else {false}
                                }

                                MouseArea {
                                    anchors.fill:parent
                                    onClicked:grouprating = 0
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
                                    visible:if(grouprating == 1) {true} else {false}
                                }

                                MouseArea {
                                    anchors.fill:parent
                                    onClicked:grouprating = 1;
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
                                    visible:if(grouprating == 2) {true} else {false}
                                }

                                MouseArea {
                                    anchors.fill:parent
                                    onClicked:grouprating = 2;
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
                                    visible:if(grouprating == 3) {true} else {false}
                                }

                                MouseArea {
                                    anchors.fill:parent
                                    onClicked:grouprating = 3;
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
                                    visible:if(grouprating == 4) {true} else {false}
                                }

                                MouseArea {
                                    anchors.fill:parent
                                    onClicked:grouprating = 4;
                                }
                            }
                        }

                    Text {
                        anchors.bottom:parent.bottom
                        anchors.left:parent.left
                        color:"white"
                        text:"Share Private: "
                        anchors.margins:parent.height * 0.01

                        CheckBox {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left:parent.right
                            checked:if(seeprivate == 1) {true} else {false}
                           // enabled: if(seeprivate == 3) {false} else {true}
                            enabled: true
                        }
                    }

                    }

                    MouseArea {
                        anchors.fill:parent
                        onClicked:groupedit.editrating = grouprating,groupedit.groupname = name,groupedit.visible = true
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
                text:qsTr("External Accounts")
                font.pixelSize: parent.width * 0.07

                color:"white"
            }

            Rectangle {
                //id:bottom
              //  anchors.top:title.bottom
                width:parent.width * 0.98
                height:window_container.height * 0.005
                color:"gray"
            }



            Item {
                width:parent.width
                height:window_container.height * 0.05

            Text {
                id:accountname1
                text:qsTr("Flattr: ")
                font.pixelSize: parent.width * 0.07

                color:"white"
            }

            Text {
                anchors.left:accountname1.right
                anchors.verticalCenter: accountname1.verticalCenter
                anchors.right:accountname1edit.left
                text:if(flattr == "" || flattr == " ") {"No account"} else {flattr}
                font.pixelSize: parent.width * 0.07

                color:"white"
                id:account1
            }

            TextField {
               anchors.left:account1.left
               anchors.right:account1.right
               anchors.verticalCenter: account1.verticalCenter
               height:account1.height
               placeholderText: qsTr("Just the profile name")
               id:flattrtext
               text:flattr
               onTextChanged: flattr = text
               visible:false
            }

            Rectangle {
                id:accountname1edit
                width:accountname1.height * 0.9
                height:accountname1.height * 0.9
                anchors.right:parent.right
                anchors.rightMargin: parent.height * 0.1
                anchors.verticalCenter: accountname1.verticalCenter
                radius: 4

                Image {
                    anchors.centerIn: parent
                    source: if(flattrtext.visible == false) {"graphics/edit.svg"} else {"graphics/save.svg"}
                    width:parent.width * 0.8
                    height:parent.height * 0.8

                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: if(flattrtext.visible == false) {flattrtext.visible = true} else {flattrtext.visible = false}
                }
            }

            }


            Item {
                width:parent.width
                height:window_container.height * 0.05

            Text {
                id:accountname2
                text:qsTr("Patreon: ")
                font.pixelSize: parent.width * 0.07

                color:"white"
            }

            Text {
                anchors.left:accountname2.right
                anchors.verticalCenter: accountname2.verticalCenter
                anchors.right:accountname2edit.left
                text:if(patreon == "" || patreon == " ") {"No account"} else {patreon}
                font.pixelSize: parent.width * 0.07

                color:"white"
                id:account2
            }

            TextField {
               anchors.left:account2.left
               anchors.right:account2.right
               anchors.verticalCenter: account2.verticalCenter
               height:account2.height
               placeholderText: qsTr("Just the profile name")
               id:patreontext
               text:patreon
               onTextChanged: patreon = text
               visible:false
            }

            Rectangle {
                id:accountname2edit
                width:accountname2.height * 0.9
                height:accountname2.height * 0.9
                anchors.right:parent.right
                anchors.rightMargin: parent.height * 0.1
                anchors.verticalCenter: accountname2.verticalCenter
                radius: 4

                Image {
                    anchors.centerIn: parent
                    source: if(patreontext.visible == false) {"graphics/edit.svg"} else {"graphics/save.svg"}
                    width:parent.width * 0.8
                    height:parent.height * 0.8

                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: if(patreontext.visible == false) {patreontext.visible = true} else {patreontext.visible = false}
                }
            }

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
                        text:qsTr("Okay")
                        font.pixelSize: parent.height / 2
                        anchors.centerIn: parent
                    }
                    MouseArea {
                        anchors.fill:parent
                        hoverEnabled: true
                        onEntered: okay.color = "gray",okaytext.color = "white"
                        onExited: okay.color = "white",okaytext.color = "black"
                        onClicked:{thefooter.state ="Show",window_container.visible = false,
                                  Scripts.store_setting(publicname,rate,patreon,flattr,pin,puborpriv,uporigin,fastcapt)
                                    privsetting = puborpriv
                                    uploadoriginal = uporigin
                                    fastcapture = fastcapt
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
                        text:qsTr("Cancel")
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



    Item {
        id:groupedit

        visible: false
        width:parent.width * 0.9
        height:parent.height * 0.45

        property string groupname:""
        property int editrating:0
        property int showprivate: 0;


        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        onVisibleChanged: console.log(editrating);

        Rectangle {
            radius:5
            anchors.fill: parent
            color:"#202020"
        }

        Column {
            anchors.centerIn: parent
            width:parent.width * 0.98
            height:parent.height * 0.95
            clip:true
            spacing:parent.height * 0.04


            Text {
                text: if(groupedit.groupname == "New Group") {"Group Add"} else {"Group Edit"}
                anchors.horizontalCenter: parent.horizontalCenter
                color:"white"
                font.pixelSize: groupedit.height * 0.1

            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                //anchors.top:title.bottom
                width:parent.width * 0.98
                height:window_container.height * 0.005
                color:"gray"
            }

            Text {
                text:"Name: "
                color:"white"
                font.pixelSize: groupedit.height * 0.1

                TextField {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left:parent.right
                    width:groupedit.width * 0.98 - parent.width
                    height:parent.height
                    text:groupedit.groupname
                    onTextChanged: groupedit.groupname = text
                   // readOnly:if(groupedit.groupname == "Public" || groupedit.groupname == "Followers") {true} else {false}
                }
            }

            Text {
                text:"Maxium Rating:"
                color:"white"
                font.pixelSize: groupedit.height * 0.08
            }

        Row {
           // anchors.verticalCenter: parent.verticalCenter
            //width:parent.width * 0.5
            //anchors.left:parent.left
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.leftMargin: parent.height * 0.3
            height:parent.height * 0.2
            spacing:parent.height * 0.04


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
                    visible:if(groupedit.editrating == 0) {true} else {false}
                }

                MouseArea {
                    anchors.fill:parent
                    onClicked:groupedit.editrating = 0
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
                    visible:if(groupedit.editrating == 1) {true} else {false}
                }

                MouseArea {
                    anchors.fill:parent
                    onClicked:groupedit.editrating = 1;
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
                    visible:if(groupedit.editrating == 2) {true} else {false}
                }

                MouseArea {
                    anchors.fill:parent
                    onClicked:groupedit.editrating = 2;
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
                    visible:if(groupedit.editrating == 3) {true} else {false}
                }

                MouseArea {
                    anchors.fill:parent
                    onClicked:groupedit.editrating = 3;
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
                    visible:if(groupedit.editrating == 4) {true} else {false}
                }

                MouseArea {
                    anchors.fill:parent
                    onClicked:groupedit.editrating = 4;
                }
            }
        }



        Text {
           // anchors.bottom:parent.bottom
            anchors.left:parent.left
            anchors.leftMargin: parent.height * 0.01
            anchors.rightMargin: parent.height * 0.02
            text:"Share Private Images: "
            color:"white"
            font.pixelSize: groupedit.height * 0.05

            CheckBox {

                anchors.verticalCenter: parent.verticalCenter
                anchors.left:parent.right
                onCheckedChanged:if(checked == true) {groupedit.showprivate = 1} else {groupedit.showprivate = 0}

            }
        }

        }

        Rectangle {
            id:gecancel
            anchors.bottom:parent.bottom
            anchors.right:geokay.left
            anchors.rightMargin:parent.height* 0.05

            anchors.margins: 5
            width:gecanceltext.width * 1.2
            height:parent.height * 0.1
            border.color:"lightgray"
            radius:8

            Text {
                id:gecanceltext
                text:qsTr("Cancel")
                font.pixelSize: parent.height / 2
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill:parent
                hoverEnabled: true
                onEntered: gecancel.color = "gray",gecanceltext.color = "white"
                onExited: gecancel.color = "white",gecanceltext.color = "black"
                onClicked: groupedit.visible = false
            }
        }

        Rectangle {
            id:geokay
            anchors.bottom:parent.bottom
            anchors.right:parent.right

            anchors.margins: 5
            width:gecanceltext.width * 1.2
            height:parent.height  * 0.1
            border.color:"lightgray"
            radius:8

            Text {
                id:geokaytext
                text:qsTr("Okay")
                font.pixelSize: parent.height / 2
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill:parent
                hoverEnabled: true
                onEntered: geokay.color = "gray",geokaytext.color = "white"
                onExited: geokay.color = "white",geokaytext.color = "black"
                onClicked: Scripts.groups_update(groupedit.groupname,groupedit.showprivate,groupedit.editrating),groupedit.visible = false
            }
        }

    }

    ListModel {
        id:groups


    }

}
