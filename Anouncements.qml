import QtQuick 2.0

import "openseed.js" as OpenSeed

Item {


    id:popup

    property int type: 0
    property string message: "Loading"

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

    onStateChanged:if(popup.state == "Show") {if(type == 0) {OpenSeed.get_eula()
                                                } else {OpenSeed.get_news(log)}
                                             }

    Rectangle {
        color:"white"
        anchors.fill: parent
        border.color:"black"
    }

    Flickable {
        width:parent.width * 0.9
        height:parent.height * 0.75
        clip:true
        contentHeight: themessage.height * 1.2
        contentWidth:parent.width * 0.9
        anchors.centerIn: parent
    Text {
         id:themessage
        //anchors.top:parent.top
        //anchors.left: parent.left
        //anchors.centerIn: parent
        anchors.margins: parent.height * 0.01
        text:message
        wrapMode:Text.WordWrap
        width:parent.width * 0.9
        ///height:parent.height * 0.9

    }

    }

    Rectangle {
        color:"#4e4e4e"
        border.color: "lightgray"
        anchors.bottom:parent.bottom
        height:parent.height * 0.12
        width:parent.width

        Rectangle {
            anchors.top:parent.top
            height:parent.height * 0.04
            width: parent.width
            color:"gray"
        }
    }

    Rectangle {
        color:"#4e4e4e"
        border.color: "lightgray"
        anchors.top:parent.top
        height:parent.height * 0.12
        width:parent.width

        Text {
            anchors.centerIn: parent
            text:"Announcement"
            font.pointSize: parent.height * 0.3
            color:"white"
        }

        Rectangle {
            anchors.bottom:parent.bottom
            height:parent.height * 0.04
            width: parent.width
            color:"gray"
        }
    }

    Rectangle {
        id:okay
        anchors.right:parent.right
        anchors.bottom:parent.bottom
        anchors.margins: 10
        width:parent.width * 0.20
        height:parent.height * 0.08
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
            onClicked: OpenSeed.announcement_seen(type), popup.state = "Hide",get_stream.running = true
        }
    }

    Rectangle {
        id:cancel
        anchors.left:parent.left
        anchors.bottom:parent.bottom
        anchors.margins: 10
        width:canceltext.width * 1.05
        height:parent.height * 0.08
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
            onClicked: {popup.state = "Hide"
                        if(type == 0) {Qt.quit()} }
        }
    }

    Image {
        anchors.centerIn: parent
        width:parent.width * 1.01
        height:parent.height * 1.01
        source:"graphics/infoborder.png"
    }


}

