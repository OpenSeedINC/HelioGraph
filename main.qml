import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import QtSensors 5.3

import IO 1.0

import QtQuick.LocalStorage 2.0 as Sql

import "main.js" as Scripts
import "openseed.js" as OpenSeed


Window {
    visible: true
    //width: Screen.height /2
    width: Screen.width
    height: Screen.height
    id:mainView
    //color:"#363636"
    color:"black"


    property string id: ""
    property string username: "" //this might need to have a secondary variable for those that RP
    property string useremail:""
    property string devId: "Vag-01001011" //given by the OpenSeed server when registered
    property string appId: "vagHeG-0630" //given by the OpenSeed server when registered

    property string pin:"no"
    property string userpin: "no"


    property string heart: ""
    property string paths:""

    property int selectedAsspect: 90

    property int fetched:0

    property var db: Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo");

    property int newimages : 0
    property int fetchedimage: 0
    property string imagequeue:""
    property int inqueue:0
    property string info: " "
    property int syncing: 0

    property int rate: 0
    property string patreon:""
    property string flattr:""
    property int whichview: 1

    property string searchstring:" "
    property string newcomment:""



    Timer {
        id:firstrun
        interval:10
        running:true
        repeat:false
       onTriggered:Scripts.firstload()

    }

    Timer {
        id:heartbeats
        interval: 2000
        running:false
        repeat:true
        onTriggered:OpenSeed.heartbeat()
    }


    Timer {
        id:sync
        interval: 120000
        running:true
        repeat:true
        onTriggered:if(whichview == 1 && syncing == 0) {if(searchstring == " ") {get_stream.running = true}}
    }

    Timer {
        id:friendsync
        interval:10
        running:false
        repeat:false
        onTriggered:OpenSeed.get_friend("All")
    }

    Timer {
        id:reload
        interval: 150
        running:false
        repeat:false
        onTriggered:Scripts.load_library(2,searchstring)
    }

    Timer {
        id:stream_reload
        interval:150
        running: false
        repeat:false
        onTriggered:Scripts.load_stream("any",rate,searchstring)
    }

    Timer {
        id:get_stream
        interval:50
        running:false
        repeat:true
        onTriggered: {

                if(heart == "Online") {progress.visible =false,OpenSeed.social_stream(" ",rate,searchstring),get_stream.running = false
                    } else {/*info = "Connecting",progress.visible =true*/}
        }
    }

    Timer {
        id:get_library
        interval:50
        running:false
        repeat:true
        onTriggered: {

                   if(heart == "Online") { OpenSeed.sync_library(),get_library.running = false
                         } else {/*info = "Connecting",progress.visible = true*/}
                         }

    }

    Timer {
        id:beep
        interval:1000
        running:false
        repeat:true
        onTriggered: {
                      if(fetchedimage < imagequeue.split(",").length ) {
                        if(fetchedimage == inqueue) {
                                OpenSeed.retrievedata("IMAGE",imagequeue.split(",")[inqueue]),inqueue = inqueue + 1 }
                    } else {inqueue =0,running = false}
    }
    }

    Timer {
        id:boop
        interval:1000
        running:false
        repeat:true
        onTriggered: {
                        if(fetchedimage < imagequeue.split(",").length ) {
                        if(fetchedimage == inqueue) {
                                OpenSeed.retrievedata("STREAM",imagequeue.split(",")[inqueue]),inqueue = inqueue + 1 }
                    } else {inqueue =0,running = false}
    }
    }

    OrientationSensor {
         active:true
          onReadingChanged: {
              switch(reading.orientation) {
              case OrientationReading.LeftUp:selectedAsspect = 180;break;
              case OrientationReading.RightUp:selectedAsspect = 0; break;
              case OrientationReading.TopUp:selectedAsspect = 90; break;
              case OrientationReading.BottomUp:selectedAsspect = 270; break;
              case OrientationReading.Undefined:selectedAsspect = 0; break;

              }

          }
      }



    Image {
        anchors.centerIn: parent
        source:"graphics/icon.png"
        fillMode:Image.PreserveAspectFit
        width:parent.height * 0.5
        height:parent.height * 0.5
        opacity:0.1
    }

    HGHeader {
        id:theheader
        anchors.top:parent.top
        width:parent.width
        height:parent.height * 0.05
    }

    MyIOout {
        id:fileio

            Component.onCompleted: {
             fileio.create = "makestuff"

                paths = fileio.create

            }

    }



    GridView {
        id:gallery
        //anchors.horizontalCenter: parent.horizontalCenter
        //anchors.bottom:thefooter.top
        height:if(parent.width > parent.height) {parent.height - theheader.height} else {thefooter.y}
        anchors.margins: parent.height * 0.001
        anchors.top:theheader.bottom
        width:if(parent.width > parent.height) {parent.width - themenu.width * 0.85 } else {parent.width * 0.98}
        x:if(parent.width > parent.height){themenu.width * 0.95} else {0}
        clip:true
        cellHeight: if(parent.width < parent.height) {parent.height * 0.80} else {parent.height * 0.6 }
        cellWidth: if(parent.width < parent.height) {parent.width * 0.98} else {parent.width * 0.2}

          model:ListModel {
              id:postslist
          }

        delegate:Photos {

            possibleWidth: gallery.cellWidth
             possibleHeight:gallery.cellHeight
             thedate:date
             theimage:image
             effect:theeffect.split(":;:")[0]
             thecomment:comment
             therotation: theeffect.split(":;:")[1]
             theowner:owner
             privacy:isprivate
             theindex:pic_index


            }

        add: Transition {
                //NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
                NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 200 }
            }

    }


    HGMenu {
        id:themenu
        anchors.left:parent.left
        anchors.bottom:thefooter.top
        anchors.margins: -parent.height * 0.01
        width:parent.height * 0.4
        height:if(parent.width < parent.height) {parent.height * 0.6} else {parent.height * 0.91 - theheader.height}

        state: if(parent.width > parent.height) {"Show"}

    }

    HGFooter {
        id:thefooter
        //anchors.bottom:parent.bottom
        width:if(parent.width > parent.height) {parent.height * 0.39} else {parent.width}
        height:parent.height * 0.1
        state:"Hide"
    }

    GetPic {
        id:viewfinder
        //anchors.centerIn: parent
        width:parent.width
        height:parent.height
        state:"Hide"
    }

   /* Anouncements {
        id:anounce
        width:parent.width * 0.9
        height:parent.height * 0.7
        anchors.centerIn: parent
    } */


    Auth {
        id:os_connect

        width:parent.width * 0.9
        height:parent.height * 0.7
        anchors.centerIn: parent

    }

    Anouncements {
        id:agreement
        width:parent.width * 0.9
        height:parent.height * 0.7
        anchors.centerIn: parent
        type: 0
        state:"Hide"
    }

View {
    id:viewpic
    width:parent.width
    height:parent.height
}

Settings {
    id:settings
    width:parent.width
    height:parent.height
    visible:false
}

Welcome {
    id:welcome
    width:parent.width
    height:parent.height
    visible:false
}

Item {
    id:progress

    //visible:if(newimages < fetchedimage) {true} else {false}
    visible:false
    width:parent.width * 0.9
    height:parent.height * 0.15
    anchors.centerIn: parent

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
            anchors.centerIn: parent
            color:"white"
            text:info
            font.pointSize: parent.height * 0.4 - info.length
        }

        Rectangle {
            anchors.bottom:parent.bottom
            height:parent.height * 0.04
            width: parent.width
            color:"gray"
        }
    }
}

}

