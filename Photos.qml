import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.0
import QtPositioning 5.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import QtSensors 5.3

import IO 1.0

import QtQuick.LocalStorage 2.0 as Sql

import "openseed.js" as OpenSeed

Flipable {
    id:flipable


    property double possibleWidth: 0
    property double possibleHeight: 0

    property string thedate:""
    property string theowner:""
    property string theimage:""
    property string thecomment:""
    property int commentnumber: 0
    property string theindex:""
    property int therotation:0
    property int effect:0
     property int privacy: 0
    property int rating: 0
    property string flattraccount: ""
    property string patreonaccount: ""
    property int listindex: 0
    property int liked: 0
    property int likes: 0
    property int thelikes: 0
    property string pintest: ""
    property string toserver : ""

    property string pinfo: "Loading"

     property bool flipped: false
       // width:frontimage.width
       // height:frontimage.height

        width:possibleWidth
        height:possibleHeight
        //clip:true

        onTheindexChanged:if(theindex != 0) {OpenSeed.load_comments(listindex,theindex);} else {

                                                                                         /*   fileio.store ="library,"+theimage+","+id;
                                                                                            toserver = fileio.store.split(":;:");
                                                                                            console.log(toserver);
                                                                                            OpenSeed.sendimage(id,toserver[1]+":;:"+toserver[2],"0:;:0",thecomment," ",privacy+":;:"+rating);*/
                                                                                            }



    front: Item {
        clip:true
        id:thefront
        width:possibleWidth * 0.94
        height:possibleHeight * 0.94
            //anchors.horizontalCenter:parent.horizontalCenter
            anchors.centerIn: parent
            Rectangle {
                id:imagebacking
                //color:"#4e4e4e"
                color:"white"
               // width:frontimage.width
                //height:frontimage.height
                anchors.fill: parent
                //border.color:"gray"
                //border.width:width * 0.015

    }


        Image { id:frontimage
        source:if(therating > rate ) { if (pintest != pin) {"graphics/lock.png"} else {theimage}
               } else {theimage}
        anchors.top: parent.top
        anchors.topMargin:parent.height * 0.01
        anchors.horizontalCenter: parent.horizontalCenter
        sourceSize.width:possibleHeight * 0.5
            sourceSize.height:possibleHeight * 0.5
            rotation:therotation
            width:if(therotation == 90 || therotation == 270) {parent.width * 0.95} else {parent.width * 0.95}
            height:if(therotation == 90 || therotation == 270) {parent.width * 0.95} else {parent.width * 0.95}
            fillMode:Image.PreserveAspectCrop

            //visible:if(effect == 0 || effect == 3) {true} else {false}

        }



        Rectangle {

            anchors.top:frontimage.bottom
            anchors.topMargin: parent.height * 0.01
            anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width
            height:parent.height * 0.03
            color:"black"
        }

       MouseArea {
            anchors.fill:frontimage
            onClicked: {

                if(thecomment.search("#soundcloud") != -1) {
                      viewpic.theurl = "http://www.soundcloud.com/"+thecomment.split("#soundcloud")[1].split("#")[1].split(" ")[0];
                }
                if(thecomment.search("#youtube") != -1) {
                      viewpic.theurl = "https://www.youtube.com/user/"+thecomment.split("#youtube")[1].split("#")[1].split(" ")[0];
                }

                if(therating > rate ) { if (pintest == pin) {
                        viewpic.thePicOwner = theowner;
                        viewpic.special =specialborder.source;
                        viewpic.effect = effect;
                        viewpic.newrotation = therotation;
                        viewpic.theimage = theimage;
                        viewpic.state = "Show";
                } else {

                } } else {
                    viewpic.thePicOwner = theowner;
                    viewpic.special =specialborder.source;
                    viewpic.effect = effect;
                    viewpic.newrotation = therotation;
                    viewpic.theimage = theimage;
                    viewpic.state = "Show";
                }
            }
            onPressAndHold:gallery.positionViewAtIndex(listindex,GridView.Center),socialopts.imageindex = theindex,socialopts.picowner = theowner,socialopts.state = "Show"
        }

        Rectangle {
            //anchors.centerIn: picture_options
            anchors.horizontalCenter: picture_options.horizontalCenter
            anchors.verticalCenter: picture_options.verticalCenter
            anchors.verticalCenterOffset: picture_options.height * 0.04
            width:picture_options.width
            height:picture_options.height * 1.2
            color:"black"
            opacity:0.8
            radius:8
            visible:if(privacy == -1) {false} else {true}
        }

        Image {
            id:specialborder
            source:if(thecomment.search("#teaminstinct") != -1) {
                       "graphics/instinct.png"
                   } else if(thecomment.search("#teamvalor") != -1) {
                       "graphics/valor.png"
                   } else if(thecomment.search("#teammystic") != -1) {
                       "graphics/mystics.png"
                   } else if(thecomment.search("#soundcloud") != -1) {
                        "graphics/soundcloud.png"
                   } else if(thecomment.search("#jamendo") != -1) {
                       "graphics/jamendo.png"
                   } else if(thecomment.search("#youtube") != -1) {
                       "graphics/youtube.png"

                   } else {"graphics/blank.png"}

            //anchors.centerIn: frontimage

            height:frontimage.height * 0.2
            width:frontimage.height * 0.2
            anchors.bottom:frontimage.bottom
            anchors.right: frontimage.right
            fillMode:Image.PreserveAspectFit

        }


        Column {
            id:picture_options
            visible:if(privacy == -1) {false} else {true}
            anchors.bottom:imgborder.bottom
            anchors.right:parent.right
            anchors.bottomMargin:imgborder.height * 0.03

            height:parent.height * 0.2
            width:parent.width * 0.1
            spacing:frontimage.paintedHeight * 0.05

            Image {
                source:if(privacy == 0) {"graphics/stock_website.svg"} else {"graphics/lock.svg"}
                fillMode:Image.PreserveAspectFit
                width:parent.width * 0.8
                height:parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: { if(privacy == 0) {privacy = 1;} else {privacy = 0;}
                                OpenSeed.privacy_update(theindex,privacy+":;:"+rating," ");
                    }
                }

            }

            Image {
                source:"graphics/edit-delete.svg"
                fillMode:Image.PreserveAspectFit
                width:parent.width * 0.8
                height:parent.width * 0.8
                anchors.horizontalCenter: parent.horizontalCenter


                MouseArea {
                    anchors.fill: parent
                    onClicked: { privacy = 2;
                                OpenSeed.privacy_update(theindex,privacy," ");
                                postslist.remove(listindex);
                    }
                }
            }

        }

        Image {
            id:imgborder
            source:if(thelikes < 1) {
                       "graphics/imageborder.png"
                   } else if (thelikes < 25) {
                       "graphics/imageborder-10.png"
                   } else {
                       "graphics/imageborder-25.png"
                   }


            height: frontimage.height * 1.04
            width: flipable.width * 0.94
            anchors.centerIn: frontimage
         }

        Rectangle {
            id:pinentry
            anchors.centerIn: frontimage
            width:parent.width * 0.9
            height:parent.height * 0.1
            color:"#202020"
            visible: if(therating > rate ) { if (pintest != pin) {true} else {false} } else {false}
            radius:5

            TextField {
                anchors.centerIn: parent
                placeholderText: "Insert Override PIN"
                maximumLength: 6
                width:parent.width * 0.8
                //height:parent.height * 0.9
                onTextChanged: pintest = text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter


            }

        }



        Column {
            id:shareopts
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:frontimage.bottom
            anchors.topMargin: parent.height * 0.06
            anchors.bottom:parent.bottom
            width:parent.width * 0.98
            spacing:parent.height * 0.01


            Row {
                //anchors.horizontalCenter: parent.horizontalCenter
                x:parent.width * 0.01
                width:parent.width * 0.99
                height:thefront.height * 0.09
                spacing: parent.width * 0.05
                clip:true

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                height:parent.height * 0.8
                width:parent.height * 0.8
                border.color: "gray"
                radius:5

                Image {
                    anchors.centerIn: parent
                    width:parent.width
                    height:parent.height
                    source:if(liked == 0) {"graphics/like.png"} else {"graphics/liked.png"}
                }

                MouseArea {
                    anchors.fill:parent
                    onClicked:if(liked == 0) {liked = 1; OpenSeed.likes(theindex,liked,likes);} else {console.log("Already Liked")}
                }
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                height:parent.height * 0.9
                width:parent.height * 0.9
                border.color: "gray"
                radius:5

                Image {
                    anchors.centerIn: parent
                    width:parent.width
                    height:parent.height
                    source:"graphics/share.png"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked:if(whichview != 5) {sharing.imageindex = theindex,sharing.picowner = theowner,sharing.state = "Show"}
                }
            }

        Text {
            id:name
            width:parent.width - (parent.height * 5)
            //height:parent.height
            horizontalAlignment: Text.AlignHCenter

            //verticalAlignment: Text.AlignVCenter
            //anchors.horizontalCenter: parent.horizontalCenter
            text:theowner
            wrapMode:Text.WordWrap
            color:"blue"

            font.pixelSize:(thefront.height * 0.05) - theowner.length
            //clip:true
            Text {
                id:publishDate
                width:parent.width
                horizontalAlignment: Text.AlignHCenter
                anchors.top:parent.bottom
                font.pixelSize: thefront.height * 0.03
                text:thedate
            }
            MouseArea {
                anchors.fill:parent
                onClicked: progress.visible = true, info= theowner,searchstring = theowner,get_stream.running = true,stream_reload.running = true
            }
        }



        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            height:parent.height * 0.9
            width:parent.height * 0.9
            border.color: "gray"
            radius:5

            Image {
                anchors.centerIn: parent
                width:parent.width
                height:parent.height
                source:"graphics/patreon.png"
                opacity:if (patreonaccount.length >1) {1} else {0.3}

            }
            MouseArea {
                enabled: if (patreonaccount.length >1) {true} else {false}
                anchors.fill:parent
                onClicked:Qt.openUrlExternally("https://www.patreon.com/"+patreonaccount)
            }
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            height:parent.height * 0.8
            width:parent.height * 0.8
            border.color: "gray"
            radius:5

            Image {
                anchors.centerIn: parent
                width:parent.width
                height:parent.height
                source:"graphics/flattr.png"
                opacity:if (flattraccount.length >1) {1} else {0.3}

            }

            MouseArea {
                enabled: if (flattraccount.length >1) {true} else {false}
                anchors.fill:parent
                onClicked:Qt.openUrlExternally("https://flattr.com/profile/"+flattraccount)
            }
        }

            }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width * 0.98
            height:thefront.height * 0.003
            color:"gray"


        }

        Text {
            id:title
            anchors.horizontalCenter: parent.horizontalCenter
            width:parent.width * 0.9

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            //anchors.horizontalCenter: parent.horizontalCenter
            text:if(therating > rate ) { if (pintest == pin) { if(comment == "null") {" "} else {comment.replace(/&#x27;/g, "'")} }
                   else {" "} } else { if(comment == "null") {" "} else {comment.replace(/&#x27;/g, "'")} }
            wrapMode:Text.WordWrap

            font.pixelSize: (thefront.height - text.length) * 0.03
        }


        }

        Image {
            source: "graphics/comments.png"
            anchors.bottom:parent.bottom
            anchors.left:parent.left
            anchors.margins: parent.height * 0.01

            width:parent.height * 0.07
            height:parent.height * 0.06
            fillMode: Image.PreserveAspectFit

           Text {
                anchors.left:parent.right
                anchors.verticalCenter: parent.verticalCenter

                text:commentnumber
                font.pointSize: if(parent.height * 0.80 > 0) {parent.height * 0.40} else {8}

            }

            MouseArea {
                anchors.top:parent.top
                anchors.bottom:parent.bottom
                width:parent.width * 7
                height:parent.height * 4
                onClicked: gallery.positionViewAtIndex(listindex,GridView.Center),flipable.flipped = !flipable.flipped
            }
        }


        Image {
            source: "graphics/infoborder.png"


            height:shareopts.height * 1.1
            width:shareopts.width * 1.04
            anchors.centerIn: shareopts
            anchors.verticalCenterOffset: -shareopts.height * 0.04
         }

       /* Text {
            id:pictureindex
            anchors.right:parent.right
            anchors.bottom:parent.bottom
            text:theindex
            anchors.margins: parent.height * 0.015
        } */

    }


       back:Item {
           //clip:true
           width:possibleWidth * 0.94
           height:possibleHeight * 0.94
           //anchors.horizontalCenter:parent.horizontalCenter
           anchors.centerIn: parent

               //anchors.centerIn: parent

           MouseArea {
               anchors.fill: parent
               onClicked:console.log("caught");
           }

               Rectangle {

                   color:"#4e4e4e"
                   //width:frontimage.width
                   //height:frontimage.height
                   anchors.fill: parent
                   border.color:"gray"


       }
           Image { id:backimage; source: "graphics/back.png"; anchors.centerIn: parent
           width:parent.width
           height:parent.height

           Text {
               anchors.centerIn: parent
               color:"white"
               text:pinfo
               font.pointSize: if(parent.height > 0) {parent.height * 0.05} else {8}
           }


       }

           ListView {
               enabled: if(flipped == 1) {true} else {false}
               //onEnabledChanged: if(enabled == true) {OpenSeed.load_comments(theindex)}
               width:parent.width * 0.98
               //height:parent.height * 0.90
               anchors.bottom:addbutton.top
               anchors.top:parent.top
               spacing:3
               visible: if(flipped == 1) {true} else {false}
                clip:true
               model:ListModel {
                   id:comments
               }

               delegate: Comments {
                        width:backimage.width * 0.98
                        //height:(backimage.height * 0.98) /7
                        thename:name
                        thecomment:comment
                        thedate:date
                        theavatar:avatar
               }

           }

           Rectangle {
               id:addbutton
               anchors.bottom:flipback.top
               anchors.bottomMargin: parent.height * 0.02
              // anchors.right: parent.right
               anchors.horizontalCenter: parent.horizontalCenter
               width:parent.width * 0.98
               height:parent.height * 0.08
               color:"#4e4e4e"
               border.color:"gray"
               radius:8

               Text {
                   anchors.centerIn: parent
                   color:"white"
                   text:qsTr("Add +")
                   font.pointSize:if(parent.height > 0) {parent.height /2} else {8}

               }

               MouseArea {
                    enabled: if(flipped == 1) {true} else {false}
                   anchors.fill: parent
                   onClicked:{addcommentview.theindex = theindex,addcommentview.state = "Show"
                   }
              }
           }

           Image {
                   id:flipback
               source: "graphics/backC.png"
               anchors.bottom:parent.bottom
               anchors.left:parent.left
               anchors.margins: parent.height * 0.02
               width:parent.height * 0.06
               height:parent.height * 0.06

               /* Text {
                   anchors.left:parent.right
                   anchors.verticalCenter: parent.verticalCenter
                   text:qsTr("Image")
                   color:"white"
                   font.pointSize: if(parent.height > 0) {parent.height} else {8}
               } */

               MouseArea {
                   anchors.top:parent.top
                   anchors.bottom:parent.bottom
                   width:parent.width * 5
                   height:parent.height * 2
                   onClicked: flipable.flipped = !flipable.flipped
               }
           }

       }

       transform: Rotation {
           id: rotation
           origin.x: flipable.width/2
           origin.y: flipable.height/2
           axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
           angle: 0    // the default angle
       }

       states: State {
           name: "back"
           PropertyChanges { target: rotation; angle: 180 }
           when: flipable.flipped
       }

       transitions: Transition {
           NumberAnimation { target: rotation; property: "angle"; duration: 500 }
       }


LongPress {
    id:socialopts
    anchors.centerIn: parent
    width:parent.width * 0.9
    height:parent.height * 0.7
    state:"Hide"
}

Share {
    id:sharing
    anchors.centerIn: parent
    width:parent.width * 0.9
    height:parent.height * 0.7
    state:"Hide"

}

   }

