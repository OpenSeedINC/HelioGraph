import QtQuick 2.0
import QtMultimedia 5.3
//import QtQuick.Controls 1.3

import Ubuntu.Components 1.3

import QtQuick.LocalStorage 2.0 as Sql


import "main.js" as Scripts
import "openseed.js" as OpenSeed


Item {

    id:popup
    property int theindex:0

    states: [
        State {

            name: "Show"
            PropertyChanges {
                target:popup
                visible:true
            }
            PropertyChanges {
                target:commenttext
                focus:true
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
        id:addbutton
        anchors.bottom:parent.bottom
        //anchors.bottomMargin: parent.height * 0.02
        anchors.right: parent.right
        width:parent.height * 1.6
        height:parent.height * 0.6
        color:"#4e4e4e"
        border.color:"gray"
        radius:8

        Text {
            anchors.centerIn: parent
            color:"white"
            text:if(commenttext.length < 1){"Cancel"} else {"Okay"}
            font.pointSize:parent.height /2

        }

        MouseArea {

            anchors.fill: parent
            onClicked:{
                        if(commenttext.length < 1) {
                         newcomment = "",
                         popup.state = "Hide",
                         commenttext.text = ""

                         } else {
                        OpenSeed.send_comment(theindex,commenttext.text),
                        popup.state = "Hide",
                       OpenSeed.load_comments(theindex),
                       newcomment = "",
                       commenttext.text = ""

                        }
            }
       }
    }

    TextField {
        id:commenttext
     anchors.verticalCenter: addbutton.verticalCenter
     anchors.right:addbutton.left
     anchors.rightMargin:parent.height * 0.01
     anchors.left:parent.left
     maximumLength: 144
     placeholderText: "Comment on the image"
     text:newcomment
     onTextChanged: newcomment = text
    }

}
