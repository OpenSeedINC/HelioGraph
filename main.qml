import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import QtPositioning 5.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import QtSensors 5.3

import IO 1.0

import QtQuick.LocalStorage 2.0 as Sql

import "main.js" as Scripts
import "openseed.js" as OpenSeed


Item {

    id:mainView
    //color:"#363636"
    //color:"black"

    visible: true
    //width: Screen.height /2
    width: 720
    height: 1280


    property string id: ""
    property string username: "" //this might need to have a secondary variable for those that RP
    property string publicname: " "
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

    property int stream_newimages : 0
       property int stream_fetchedimage: 0
       property string stream_imagequeue:""
       property int stream_inqueue:0
       property int stream_syncing: 0

       property int library_newimages : 0
       property int library_fetchedimage: 0
       property string library_imagequeue:""
       property int library_inqueue:0
       property int library_syncing: 0



       property string info: " "
       property int rate: 0
       property string patreon:""
       property string flattr:""
       property int privsetting: 0
       property int uploadoriginal:0
       property int fastcapture:0

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
           id:splashing
           interval:400
           repeat:false
           running:true
           onTriggered: splashscreen.visible = false
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
           interval: 30000
           running:true
           repeat:true
           onTriggered:OpenSeed.menu_notifications()
           //onTriggered:if(whichview == 1 && syncing == 0) {if(searchstring == " ") {get_stream.running = true}}
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

                    if(heart == "Online" && whichview != 3) {progress.visible =false,OpenSeed.social_stream(" ",rate,searchstring),get_stream.running = false
                        } else {/*info = "Connecting",progress.visible =true*/}
            }
        }

        Timer {
            id:get_library
            interval:50
            running:false
            repeat:true
            onTriggered: {

                       if(heart == "Online" && whichview != 3) { OpenSeed.sync_library(),get_library.running = false
                             } else {/*info = "Connecting",progress.visible = true*/}
                             }

        }

        Timer {
                id:beep
                interval:2000
                running:false
                repeat:true
                onTriggered: {
                              if(library_fetchedimage < library_imagequeue.split(",").length ) {
                                if(library_fetchedimage == library_inqueue) {
                                        //console.log(imagequeue.split(",")[inqueue]);
                                        OpenSeed.retrievedata("IMAGE",library_imagequeue.split(",")[library_inqueue]),library_inqueue = library_inqueue + 1 }
                            } else {library_inqueue =0,running = false}
            }
            }

            Timer {
                id:boop
                interval:2000
                running:false
                repeat:true
                onTriggered: {
                                if(stream_fetchedimage < stream_imagequeue.split(",").length ) {
                                if(stream_fetchedimage == stream_inqueue) {

                                        OpenSeed.retrievedata("STREAM",stream_imagequeue.split(",")[stream_inqueue]),stream_inqueue = stream_inqueue + 1 }
                            } else {stream_inqueue =0,running = false}
            }
            }

    OrientationSensor {
         active:true
          onReadingChanged: {
              switch(reading.orientation) {
                           case OrientationReading.LeftUp:/*splashscreen.visible = true;*/selectedAsspect = 180;themenu.state = "Show";break;
                           case OrientationReading.RightUp:/*splashscreen.visible = true;*/selectedAsspect = 0;themenu.state = "Show";break;
                           case OrientationReading.TopUp:/*splashscreen.visible = true;*/selectedAsspect = 90;themenu.state = "Hide"; break;
                           case OrientationReading.BottomUp:/*splashscreen.visible = true;*/selectedAsspect = 270;themenu.state = "Hide"; break;
                           case OrientationReading.Undefined:/*splashscreen.visible = true;*/selectedAsspect = 0;themenu.state = "Hide"; break;

                           }

          }
      }

Rectangle {
 anchors.fill: parent
 color:"black"

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

        width:if(parent.width > parent.height) {parent.width * 0.4} else {parent.width * 0.9}

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

Search {
    id:search
    width:parent.width * 0.9
    height:parent.height * 0.35
    anchors.centerIn: parent
    visible:false
}


NewMessage {
    id:addcommentview
    width:parent.width * 0.98
    height:parent.height * 0.1
    //anchors.centerIn: parent
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    anchors.verticalCenterOffset: -parent.height * 0.01
    state:"Hide"
}

Following {
    id:follow_screen
    width:parent.width
    height:parent.height
    anchors.centerIn: parent
    state:"Hide"
}

Inbox {
    id:share_screen
    width:parent.width * 0.9
    height:parent.height * 0.8
    anchors.centerIn: parent
    state:"Hide"
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
    //width:parent.width * 0.9
    //height:parent.height * 0.15
    //anchors.centerIn: parent
    state:"minimal"
    states: [
        State {
            name:"midscreen"
            PropertyChanges {
                target:progress
                y:parent.height / 2 - height / 2
                x:parent.width * 0.05
                width:parent.width * 0.9
                height:parent.height * 0.15
            }


        },

        State {
            name:"minimal"
            PropertyChanges {
                target:progress
                y:if(viewfinder.state == "Show") {parent.height - height} else {if(parent.width < parent.height)
                                                                 {thefooter.y - height} else {parent.height - height} }
                x:if(viewfinder.state == "Show") {parent.width * 0.3} else {parent.width * 0.6}
                width:parent.width * 0.4
                height:parent.height * 0.05

            }


        }

    ]

    transitions: [
        Transition {
            from: "midscreen"
            to: "minimal"
            reversible: true


            NumberAnimation {
                target: progress
                property: "xy"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }


    ]

    Rectangle {
        color:"#4e4e4e"
        anchors.fill: parent
        clip:true
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
            font.pointSize: if(parent.height > 0) {parent.height * 0.4 - info.length} else {4}
        }

        Rectangle {
            anchors.bottom:parent.bottom
            height:parent.height * 0.04
            width: parent.width
            color:"gray"
        }
    }
}

Splash {
        id:splashscreen
        width:parent.width
        height:parent.height
        visible:true
        onVisibleChanged: if(visible == true) {splashing.running = true}
    }

}

