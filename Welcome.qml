import QtQuick 2.4
import Ubuntu.Components 1.3
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

    property string number: "0"
    property string list:""
    property string maintitle:""

    clip: true

    onStateChanged: if(popup.state == "Show") {Slides.aboutslides(i18n);} else {slidelist.clear();}



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
        color:"white"
        anchors.fill: parent
        border.color:"black"
    }


    GridView {
    id:ftext

    property string list:""
    //property string pindex:pageindex
    anchors.centerIn: parent

    z:0
    width: parent.width * 0.98 //- units.gu(.4)
    height: parent.height * 0.70 //- units.gu(4.8)
    snapMode: GridView.SnapOneRow
    //flow: GridView.FlowLeftToRight
    flow:GridView.FlowTopToBottom
    boundsBehavior: Flickable.DragAndOvershootBounds
    flickableDirection: Flickable.VerticalFlick
    //highlightFollowsCurrentItem: true
    visible: true
    //cellHeight: units.gu(26)
    clip:true
    //enabled:false
    //enabled:if(selection == 2) {true} else {false}

    cellHeight:parent.height
    cellWidth: popup.width

    delegate: Item {

            //anchors.fill:parent
               width:ftext.cellWidth
               height:ftext.cellWidth
               clip:true
            Column {
                    id:slidescolumn
                    width:parent.width
                    height:parent.height
                    spacing:8
                    Text {
                            id:title
                            text:ftitle
                            font.pixelSize: parent.height * 0.075
                            anchors.horizontalCenter: parent.horizontalCenter
                            width:parent.width
                            wrapMode:Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                            //anchors.verticalCenter: parent.verticalCenter
                            //anchors.horizontalCenterOffset: parent.width * (0.01*fHoffset)
                           // anchors.verticalCenterOffset: parent.height * (0.01*fVoffset)

                style: Text.Outline; styleColor: "#FFFFFF"


            }

                    Image {
                        id:picture
                        source:pic
                        fillMode:Image.PreserveAspectFit
                        anchors.horizontalCenter: parent.horizontalCenter
                        width:popup.width * 0.8
                        height:popup.height * 0.4


                    }

                    Text {
                            id:discript
                            text:disc
                            font.pixelSize: parent.height * 0.038
                            anchors.leftMargin:10
                            anchors.left:parent.left
                            wrapMode:Text.WordWrap
                            width:parent.width * 0.98

                style: Text.Outline; styleColor: "#FFFFFF"


            }



            Text {
                    id:slidenum
                    text:i18n.tr("Page:")+slidnum +"/"+ftext.count
                    font.pixelSize: parent.height * 0.025
                    width:parent.width
                    horizontalAlignment: Text.AlignHCenter

        style: Text.Outline; styleColor: "#FFFFFF"

            }
    }


        }

    model:
        ListModel {
          id:slidelist
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
            text:"<-- Welcome -->"
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
        //anchors.right:parent.right
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom:parent.bottom
        anchors.bottomMargin: parent.height * 0.02
        width:parent.width * 0.40
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
            onClicked: {popup.state = "Hide"
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
