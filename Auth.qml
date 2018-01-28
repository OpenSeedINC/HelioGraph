import QtQuick 2.2
import QtQuick.Controls 2.2
import "main.js" as Scripts
import "openseed.js" as OpenSeed

import QtQuick.LocalStorage 2.0 as Sql



Rectangle {

    id:popup
    color:"white"
    border.color:"gray"
    border.width:10
    radius:8

    property int uniquename: 8
    property int uniqueid: 8
    property string passphrase: ""


    states: [
        State {
            name: "Show"
            PropertyChanges {
                target:popup
                visible:true
                enabled:true
            }
        },
        State {
            name: "Hide"
            PropertyChanges {
                    target:popup
                    visible:false
                    enabled:false
            }
        }


    ]
    state:"Hide"



    Timer {
        id:checkname
        running:false
        repeat:false
        interval: 1000
        onTriggered: OpenSeed.checkcreds("username",osUsername.trim());

    }

    Timer {
        id:checkemail
        running:false
        repeat:false
        interval: 1000
        onTriggered: OpenSeed.checkcreds("email",osEmail.trim());


    }

    Timer {
        id:checkpassword
        running:false
        repeat:false
        interval: 1000
        onTriggered: OpenSeed.checkcreds("passphrase",osUsername+","+osEmail+","+osPassphrase);

    }

    Timer {
        id:checkexists
        running:false
        repeat:false
        interval: 1000
        onTriggered: if(osUsername.length > 1 && osEmail.length > 1) {OpenSeed.checkcreds("account",osUsername+","+osEmail);}
    }




    Image {
        anchors.fill:parent
        source:"graphics/OpenSeed.png"
        opacity:0.08
        fillMode:Image.PreserveAspectFit
    }



    Column {
        anchors.top: parent.top
        anchors.topMargin:parent.height * 0.04
        width:parent.width

        spacing:parent.height * 0.05

        Text {
            text:qsTr("OpenSeed Connect")
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: parent.width * 0.07
        }

        Rectangle {
            width:parent.width * 0.90
            height:parent.height * 0.01
            color:"lightgray"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text:qsTr("Create an account on our servers to use the service.")
            width:parent.width * 0.90
            wrapMode: Text.WordWrap
            x:parent.width * 0.05
            //font.pixelSize: parent.width * 0.05
        }

        Rectangle {
            width:parent.width * 0.90
            height:parent.height * 0.01
            color:"lightgray"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text:switch(uniquename) {
                 case 0:qsTr("In Use");break;
                 case 1:qsTr("Available");break;
                 case 2:if(username.length > 2) {qsTr("Welcome Back")} else {qsTr("No User Name")};break;
                 default:qsTr("No User Name");break;
                 }
            color:switch(uniquename) {
                  case 0:"Red";break;
                  case 1:"Black";break;
                  case 2:"Black";break;
                  default:break;
                  }

            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: parent.width * 0.06

        }

        TextField {
            anchors.horizontalCenter: parent.horizontalCenter
            id:usernametext
            width:parent.width * 0.80
            placeholderText:qsTr("User Name")
            text:username
            onTextChanged:username = text,OpenSeed.checkcreds(username,useremail);

        }



        TextField {
            anchors.horizontalCenter: parent.horizontalCenter
            id:emailnametext
            width:parent.width * 0.80
            placeholderText: qsTr("Email")
            text:useremail
            onTextChanged: useremail = text,OpenSeed.checkcreds(username,useremail);
        }

        TextField {
            anchors.horizontalCenter: parent.horizontalCenter
            id:passphrasetext
            width:parent.width * 0.80
            placeholderText: qsTr("Passphrase")
            text:passphrase
            echoMode: TextInput.Password
            onTextChanged: passphrase = text,OpenSeed.checkcreds(username,useremail);
        }

    }

    Rectangle {
        id:okay
        anchors.right:parent.right
        anchors.bottom:parent.bottom
        anchors.margins: 20
        width:parent.width * 0.20
        height:parent.height * 0.10
        border.color:"lightgray"
        radius:8

        Text {
            id:okaytext
            text:if(uniquename == 2 && username.length > 2) {qsTr("Login");} else {qsTr("Okay");}
            font.pixelSize: parent.height / 2
            anchors.centerIn: parent
        }
        MouseArea {
            anchors.fill:parent
            hoverEnabled: true
            onEntered: okay.color = "gray",okaytext.color = "white"
            onExited: okay.color = "white",okaytext.color = "black"
            onClicked: if(username.length > 2 && useremail.length > 2) {OpenSeed.oseed_auth(username,useremail,passphrase),popup.state = "Hide"} else {
                           usernametext.focus = true
                       }
        }
    }

    Rectangle {
        id:cancel
        anchors.left:parent.left
        anchors.bottom:parent.bottom
        anchors.margins: 20
        width:canceltext.width
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
            onClicked: popup.state = "Hide",Qt.quit()
        }
    }

    Image {
        anchors.centerIn: parent
        source:"graphics/infoborder.png"
        width:parent.width
        height:parent.height
    }
}
