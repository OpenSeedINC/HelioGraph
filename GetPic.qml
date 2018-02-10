import QtQuick 2.9
import QtMultimedia 5.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtSensors 5.9
//import QtQuick.Controls 1.3

//import Ubuntu.Components 1.3

//import Ubuntu.Content 1.1

import QtQuick.LocalStorage 2.0 as Sql


import "main.js" as Scripts
import "openseed.js" as OpenSeed


Item {
    id:window_container

    property string thesource:""
    property string thefile:""
    property int selectedEffect:0
    property int selectedOverlay:0
    property int isPrivate: privsetting
    property int capturedAsspect:0
    property int setFlash:0
    property int setExpos:0
    property int setFocus:0
    property int privacy:privsetting
    property int rating:0
    property int fromhub:0

    property int rotate:0

    property string theComment:""


   /* property list<ContentItem> importItems
      property var activeTransfer

      ContentPeer {
          id: picSourceSingle
          contentType: ContentType.Pictures
          handler: ContentHandler.Source
          selectionType: ContentTransfer.Single

      } */

    MouseArea {anchors.fill:parent

    }


   states: [

       State {
           name: "Show"

           PropertyChanges {
               target:window_container
               y:0

           }

       },

       State {
           name: "Hide"

           PropertyChanges {
               target:window_container
               y:parent.height


           }


       }

   ]

   transitions: [
       Transition {
           from: "Hide"
           to: "Show"
           reversible: true


           NumberAnimation {
               target: window_container
               property: "y"
               duration: 200
               easing.type: Easing.InOutQuad
           }
       }
   ]

   state:"Hide"


   onStateChanged: if(window_container.state == "Show") {camera.start();
                        comment.text ="";
                        //camera.position = 0;
                        setFocus = 0;
                       whichview = 3;
                       privacy =privsetting;
                       savedclicked.enabled = true;

                   } else {camera.start();
                       //camera.stop();

                            setFocus = 0;
                       setFlash =0
                       setExpos =0
                       setFocus= 0
                       privacy =privsetting
                       rating =0
                       fromhub =0
                       thesource = "";
                       thefile = "";

                       //check.clear();


                      if(whichview == 3) {searchstring = " ";reload.running = true;}
                       }



clip:true





    Rectangle {
        anchors.fill:parent
        //color:"#9d9d9d"
        color:"black"
        //color:"#4e4e4e"
        //color:"#202020"
    }

    Camera {
            id:camera

           // position: Camera.BackFace

            imageProcessing {

                whiteBalanceMode: CameraImageProcessing.WhiteBalanceAuto
            }

            exposure {
                exposureCompensation: -1.0
                exposureMode: switch(setExpos) {
                              case 0:Camera.ExposureAuto;break;
                              case 1:Camera.ExposureLandscape;break;
                              case 2:Camera.ExposureNight;break;
                              case 3:Camera.ExposureSports;break;
                              default:Camera.ExposureAuto;break;

                              }

            }

            focus {
                        focusMode: switch(setFocus) {

                                   case 0:Camera.FocusAuto;break;
                                   case 1:Camera.FocusContinuous;break;
                                   case 2:Camera.FocusHyperfocal;break;
                                   case 3:Camera.FocusInfinity;break;
                                   case 4:Camera.FocusMacro;break;
                                   default:Camera.FocusContinuous;break;

                                   }
                        focusPointMode: Camera.FocusPointAuto
                    }



            flash.mode: switch(setFlash) {
                        case 0: Camera.FlashAuto;break;
                        case 1: Camera.FlashOff;break;
                        case 2: Camera.FlashSlowSyncFrontCurtain;break;
                        default:Camera.FlashRedEyeReduction;break;
                        }

            imageCapture {

                onImageCaptured: {
                    thesource = preview  // Show the preview in an Image

                    //check.visible = true;

                }
                onImageSaved: {
                   thefile = path
                }
            }



        }
    Rectangle {
        color:"#9d9d9d"
        anchors.centerIn:border
        width:viewport.width * 1.01
        height:viewport.height * 1.01

    }


    VideoOutput {
            id:viewport
            source: camera
            //anchors.fill: parent
            //anchors.centerIn: parent
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.horizontalCenterOffset: if(parent.width > parent.height) {-parent.width * 0.1} else {0}
            anchors.top:parent.top
            anchors.topMargin: parent.height * 0.00
            //width:parent.width * 0.8
            //height:parent.height * 0.8
            width:if(parent.width > parent.height) {parent.width * 0.80} else {parent.width}
            height:if(parent.width > parent.height) {parent.height} else {parent.width * 0.99}

           // rotation:if(parent.width > parent.height) {0} else {90}

            fillMode: Image.PreserveAspectCrop
            focus : visible // to receive focus and capture key events when visible
            visible:if(thesource == "") {true} else {false}
            autoOrientation : true



      /*  MouseArea {
            anchors.fill: parent
            onClicked: {

                            switch(rotate){
                            case 0: rotate = 90;parent.rotation = rotate;console.log(rotate);break;
                            case 90: rotate = 180;parent.rotation = rotate;console.log(rotate);break;
                            case 180: rotate = 270;parent.rotation = rotate;console.log(rotate);break;
                            case 270: rotate = 360;parent.rotation = rotate;console.log(rotate);break;
                            default: rotate = 0;parent.rotation = rotate;console.log(rotate);break;
                           }
                       }
        } */
        }

    Rectangle {
        anchors.top:viewport.top
        anchors.right:viewport.right
        anchors.margins: parent.height * 0.01
        width:viewport.height * 0.08
        height: viewport.height * 0.08
        color:"#4e4e4e"
        radius: 8
        border.color:"gray"
        border.width:2


        Image {
            source:"graphics/backbutton.png"
            anchors.centerIn: parent
            width:parent.width * 0.7
            height:parent.height * 0.7
            mirror:true
        }

        MouseArea {
            anchors.fill: parent
            onClicked:window_container.state = "Hide"
        }


    }

   /* Image {
        id:border
        source:"graphics/cameraborder.png"
        anchors.centerIn: viewport
        width:viewport.width
        height:viewport.height
        visible:if(thesource == "") {true} else {false}

    } */





    Item {
        //anchors.top: if(parent.width > parent.height) {parent.top} else {border.bottom}
        //anchors.left:if(parent.width > parent.height) {check.right} else {parent.left}
        anchors.top:parent.top
        anchors.left:parent.left
        anchors.right:parent.right
        anchors.bottom:parent.bottom
        visible:if(thesource == "") {false} else {true}

        Preview {
            id:check

            anchors.top:parent.top
            anchors.left:parent.left
            width:if(parent.width < parent.height) {viewport.width} else {viewport.width /* * 0.8*/ }
            height:if(parent.width < parent.height) {viewport.height} else {viewport.height /* * 0.7 */}
            visible:if(thesource == "") {false} else {true}
            effect:selectedEffect
            overlay:selectedOverlay
            therotation:if(camera.position == 1) {capturedAsspect} else {-90}

        }




        Rectangle {
            anchors.centerIn: priv_img
            width:priv_img.width * 1.1
            height:priv_img.height * 1.1
            radius:10
            color:"black"
            opacity:0.5
            visible:if(thesource == "") {false} else {true}
        }

        Image {
            id:priv_img
            source:if(privacy == 0) {"graphics/stock_website.svg"} else {"graphics/lock.svg"}
            fillMode:Image.PreserveAspectFit
            width:rating_img.width
            height:rating_img.width
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom:check.bottom
            anchors.right:check.right
            anchors.margins: check.height * 0.02
            visible:if(thesource == "") {false} else {true}


            MouseArea {
                anchors.fill: parent
                onClicked: { if(privacy == 0) {privacy = 1;} else {privacy = 0;}

                }
            }

        }

        Rectangle {
            anchors.centerIn: rotate_img
            width:rotate_img.width * 1.1
            height:rotate_img.height * 1.1
            radius:10
            color:"black"
            opacity:0.5
            visible:if(thesource == "") {false} else {true}
        }

        Image {
            id:rotate_img
            source:"graphics/rotate-right.svg"
            fillMode:Image.PreserveAspectFit
            width:rating_img.width
            height:rating_img.width
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom:check.bottom
            anchors.left:check.left
            anchors.margins: check.height * 0.02
            visible:if(thesource == "") {false} else {true}


            MouseArea {
                anchors.fill: parent
                onClicked: {check.therotation = check.therotation + 90;capturedAsspect = capturedAsspect + 90}
            }

        }




        Rectangle {
            anchors.centerIn: rating_img
            width:rating_img.width * 1.1
            height:rating_img.height * 1.1
            radius:10
            color:"black"
            opacity:0.5
            visible:if(thesource == "") {false} else {true}

        }


        Image {
            id:rating_img
            source:switch(rating) {
                   case 0:"graphics/E_ESRB.png";break;
                   case 1:"graphics/e10_ESRB.png";break;
                   case 2: "graphics/T_ESRB.png";break;
                   case 3: "graphics/M_ESRB.png";break;
                   case 4: "graphics/aO_ESRB.png";break;
                   default: "graphics/E_ESRB.png";break;
                   }
            fillMode:Image.PreserveAspectFit
            width:check.height * 0.15
            height:check.height * 0.15
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:parent.top
            anchors.left:parent.left
            anchors.margins: parent.height * 0.02
            //rotation:-90
            visible:if(thesource == "") {false} else {true}

            MouseArea {
                anchors.fill: parent
                onClicked: {rating_picking.visible = true,parent.visible = false}

                }

            }

        Rectangle {
            visible:rating_picking.visible
            //anchors.centerIn: rating_picking
            anchors.top:rating_picking.top
            anchors.horizontalCenter: rating_picking.horizontalCenter
            width:rating_picking.width * 1.1
            height:rating_picking.height * 1.05
            radius:10
            color:"black"
            opacity:0.5
            //rotation: -90
        }

        Column {
            id:rating_picking
            visible:false
            //x:rating_img.width
           // y:rating_img.height
           anchors.left:rating_img.left
           anchors.top:rating_img.top
           clip:true

            //anchors.bottom:parent.bottom
            width:rating_img.width
            height:if(parent.width > parent.height) {parent.height * 0.8} else {parent.height * 0.6 }
            spacing:parent.height * 0.01
            //rotation:-90

             Image {
                        width:rating_img.width
                        height:rating_img.height
                source:"graphics/E_ESRB.png"

                fillMode:Image.PreserveAspectFit

                MouseArea {
                    anchors.fill:parent
                    onClicked:rating = 0,rating_img.visible = true,rating_picking.visible = false
                }
            }

             Image {
                        width:rating_img.width
                        height:rating_img.height
                source:"graphics/e10_ESRB.png"

                fillMode:Image.PreserveAspectFit

                MouseArea {
                    anchors.fill:parent
                    onClicked:rating = 1,rating_img.visible = true,rating_picking.visible = false
                }
            }
             Image {
                        width:rating_img.width
                        height:rating_img.height
                source:"graphics/T_ESRB.png"

                fillMode:Image.PreserveAspectFit

                MouseArea {
                    anchors.fill:parent
                    onClicked:rating = 2,rating_img.visible = true,rating_picking.visible = false
                }
            }
             Image {
                        width:rating_img.width
                        height:rating_img.height
                source:"graphics/M_ESRB.png"

                fillMode:Image.PreserveAspectFit

                MouseArea {
                    anchors.fill:parent
                    onClicked:rating = 3,rating_img.visible = true,rating_picking.visible = false
                }
            }
             Image {
                        width:rating_img.width
                        height:rating_img.height
                source:"graphics/aO_ESRB.png"

                fillMode:Image.PreserveAspectFit

                MouseArea {
                    anchors.fill:parent
                    onClicked:rating = 4,rating_img.visible = true,rating_picking.visible = false
                }
            }


        }






    Rectangle {
        anchors.centerIn: effectsRow
        width:effectsRow.width * 1.10
        height:effectsRow.height * 1.01
        color:"#4e4e4e"
        radius:8
        border.color:"gray"
        border.width:2
    }



    Grid {
        id:effectsRow
        anchors.top: if(parent.width > parent.height) {parent.top} else {check.bottom}
        anchors.topMargin:if(parent.width > parent.height) {0} else {parent.height * 0.01}
        anchors.left:if(parent.width > parent.height) {check.right} else {parent.left}
        anchors.leftMargin: if(parent.width > parent.height) {parent.height * 0.02} else {parent.height * 0.02}
        //anchors.right:if(parent.width > parent.height) {parent.right} else {parent.right}
        anchors.right:parent.right
        anchors.rightMargin:if(parent.width > parent.height) {5} else {0}
        //width:parent.width - check.width
        height:if(parent.width > parent.height) {parent.height * 0.30} else {parent.height * 0.14}
        spacing: if(parent.width > parent.height) {parent.width * 0.02} else {parent.width * 0.04}
        clip:true
        columns: if(parent.width > parent.height) {2} else {4}


        Rectangle {
            id:brightcontrast
            width:window_container.height * 0.13
            height:width
           // anchors.verticalCenter: parent.verticalCenter
            radius:8
            color:"#202020"

            Image {
                width:parent.width * 0.8
                height:parent.height * 0.8
                anchors.centerIn: parent
                source:"graphics/BaC.png"
                fillMode:Image.PreserveAspectFit
            }

            MouseArea {
                anchors.fill:parent
                onClicked:hideall(),briandCon.state = "Show"
            }

        }

        Rectangle {
            id:colorandsaturation
            width:window_container.height * 0.13
            height:width
            //anchors.verticalCenter: parent.verticalCenter
            radius:8
            color:"#202020"
            Image {
                width:parent.width * 0.8
                height:parent.height * 0.8
                anchors.centerIn: parent
                source:"graphics/CaS.png"
                fillMode:Image.PreserveAspectFit
            }

            MouseArea {
                anchors.fill:parent
                onClicked:hideall(),colandSat.state = "Show"
            }

        }

        Rectangle {
            id:overlay
            width:window_container.height * 0.13
            height:width
           // anchors.verticalCenter: parent.verticalCenter
            radius:8
            color:"#202020"
            Image {
                width:parent.width * 0.8
                height:parent.height * 0.8
                anchors.centerIn: parent
                source:"graphics/Overlay.png"
                fillMode:Image.PreserveAspectFit
            }

            MouseArea {
                anchors.fill:parent
                onClicked:hideall(),theoverlay.state = "Show"
            }

        }

        Rectangle {
            id:onetouch
            width:window_container.height * 0.13
            height:width
          //  anchors.verticalCenter: parent.verticalCenter
            radius:8
            color:"#202020"
            Image {
                width:parent.width * 0.8
                height:parent.height * 0.8
                anchors.centerIn: parent
                source:"graphics/Wizard.png"
                fillMode:Image.PreserveAspectFit
            }

            MouseArea {
                anchors.fill:parent
                onClicked:hideall(),thewizard.state = "Show"
            }
        }
    }


    Rectangle {
        anchors.centerIn: commonTags
        width:commonTags.width * 1.02
        height:commonTags.height * 1.08
        color:"#4e4e4e"
        radius:8
        border.color:"gray"
        border.width:2
    }

    Flow {
        id:commonTags
        anchors.top:if(parent.width > parent.height) {effectsRow.bottom} else {effectsRow.bottom}
        anchors.left:if(parent.width > parent.height) {check.right} else {parent.left}
        anchors.leftMargin: if(parent.width > parent.height) {parent.height * 0.02} else {0}
        anchors.right:parent.right
        anchors.topMargin:if(parent.width > parent.height) {0} else {parent.height * 0.01}
        //width:parent.width * 0.99
        height:parent.height * 0.03
        //anchors.horizontalCenter: parent.horizontalCenter


    }

    Rectangle {
        anchors.centerIn: comment
        width:comment.width * 1.02
        height:comment.height * 1.02
        color:"white"
        radius:8
        border.color:"gray"
        border.width:10
    }

    TextField {
            visible:if(thesource == "") {false} else {true}
            id:comment
            anchors.top:if(Qt.inputMethod.visible == true) {check.top} else {commonTags.bottom}
            anchors.topMargin: if(Qt.inputMethod.visible == true) {parent.height * 0.008} else {parent.height * 0.01 }
            //anchors.bottom:if(Qt.inputMethod.visible == true) {check.bottom} else {parent.bottom}
            anchors.bottom:footerSaveOpts.top
            anchors.bottomMargin: if(Qt.inputMethod.visible == true) {if(parent.width > parent.height) {parent.height * 0.5} else {parent.height * 0.35} } else {parent.height * 0.01 }
            anchors.right:parent.right
            anchors.left:if(Qt.inputMethod.visible == true) {parent.left} else {if(parent.width > parent.height) {check.right} else {parent.left}}
            anchors.leftMargin: if(parent.width > parent.height) {parent.height * 0.02} else {0}
           // anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            maximumLength: 144
            //height:if(Qt.inputMethod.visible == true) {parent.height * 0.5 } else {parent.height * 0.16}
            //width:parent.width * 0.99
            placeholderText: qsTr("Add # to create new hashtags.")
            onTextChanged: theComment = comment.text


    }



    Rectangle {

        id:footerSaveOpts
        visible:if(thesource != "") {true} else {false}

        //anchors.top:comment.bottom
        anchors.right:parent.right
        anchors.left:if(parent.width > parent.height){check.right} else {parent.left}
        anchors.leftMargin: if(parent.width > parent.height) {parent.height * 0.02} else {0}
        anchors.bottom:parent.bottom
        height:parent.height * 0.1
        color:"#4e4e4e"

        Rectangle {
            anchors.top:parent.top
            width:parent.width
            height:parent.height * 0.06
            color:"gray"

        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:parent.right
            anchors.rightMargin: parent.height *0.05
            width:(parent.height * 1.5) + okaytext.text.length
            height:parent.height * 0.8
            radius:8
            color:if(savedclicked.pressed == true) {"#5F4F4F"} else {"#9d9d9d"}

            Text {
                id:okaytext
                anchors.centerIn: parent
                font.pixelSize: parent.height * 0.5
                text:qsTr("Okay")
            }

            MouseArea {
                id:savedclicked
                anchors.fill:parent
                onClicked:{


                            progress.visible = true;
                            progress.state = "minimal"
                            info = "Saving Picture";
                           // if(camera.position == 2) {
                             //   capturedAsspect = -90;
                            //}
                                //capturedAsspect = 0;
                                //selectedEffect = 0;


                            if(thefile.search("file://") == -1) {
                                thefile = thefile;


                            } else {
                                thefile = thefile.split("file://")[1];

                            }
                            var saver = "";

                            if(fromhub == 1) {
                                saver = paths.split(",")[2].trim()+thefile.split(".jpg")[0].split("/")[thefile.split("/").length -1];
                               // console.log(saver);
                                fromhub = 0;
                            } else {
                                saver = thefile.split(".jpg")[0];
                               // console.log(saver);
                            }

                            check.grabToImage(function(result) {
                               // console.log(thefile.split(".jpg")[0]+"_stream.jpg");
                                result.saveToFile(saver+"_stream.jpg");



                            //fileio.store ="library,"+thefile+","+id


                            fileio.store ="library,"+saver+"_stream.jpg,"+id
                            //window_container.state = "Hide"

                            //selectedEffect+":;:"+capturedAsspect

                            Scripts.store_img("Library",fileio.store,"0:;:0",privacy+":;:"+rating,theComment)


                            //reload.running = true
                            var toserver = fileio.store.split(":;:");
                            if(heart == "Online") {OpenSeed.sendimage(id,toserver[1]+":;:"+toserver[2],"0:;:0",theComment," ",privacy+":;:"+rating);progress.visible = true; info = "Sending Image";} else {progress.visible = false; info = " ";}
                                //selectedEffect+":;:"+capturedAsspect
                            thesource = ""
                            comment.text = ""

                            });


                }

            }
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left:parent.left
            anchors.rightMargin: parent.left *0.05
            width:(parent.height * 1.5) + canceltext.text.length
            height:parent.height * 0.8
            radius:8
            color:"#9d9d9d"

            Text {
                id:canceltext
                anchors.centerIn: parent
                font.pixelSize: parent.height * 0.5
                text:qsTr("Cancel")
            }

            MouseArea {
                anchors.fill:parent
                onClicked:check.clear(),thesource = "",comment.text = ""
            }
        }

    }


    }







        Item {
            id:footer
            //anchors.bottom:parent.bottom
            y:if(parent.width > parent.height) {
                  if(thesource == "") {0}
                              else {parent.height - parent.height * 0.08}
              } else {
                if(thesource == "") {viewport.y + viewport.height}
                            else {parent.height - parent.height * 0.1}
              }
            x:if(parent.width > parent.height) {if(thesource == "") {viewport.width} else {0} } else {0}
            width:if(parent.width > parent.height) {if(thesource == "") {parent.width - viewport.width} else {parent.width}} else {parent.width}
            height:if(thesource == "") {parent.height - y} else {parent.height * 0.1}


        Rectangle {
            visible:if(thesource == "") {true} else {false}
            id:footerStandard
            width:parent.width
            height:parent.height
            color:"#4e4e4e"
           // opacity:0.05

            Rectangle {
                anchors.top:parent.top
                width:parent.width
                height:parent.height * 0.04
                color:"#9d9d9d"
                visible:if(mainView.width > mainView.height) {false} else {true}

            }

            Rectangle {
                width:parent.width * 0.05
                height:parent.height
                color:"#9d9d9d"
                radius:10
                x:parent.x - width / 2
                visible:if(mainView.width > mainView.height) {true} else {false}
            }

            Image {
                visible:if(mainView.width > mainView.height) {true} else {false}
                anchors.horizontalCenter: parent.horizontalCenter
                width:parent.width * 0.9
                height:parent.width
                anchors.top:parent.top
                source:"graphics/title.png"
                fillMode:Image.PreserveAspectFit
            }


        Rectangle {
            id:camerabutton
            //anchors.bottom:parent.bottom
            //anchors.bottomMargin: parent.height * 0.01
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width:if(mainView.width > mainView.height) {parent.width * 0.8}else {parent.height * 0.5}
            height:if(mainView.width > mainView.height){parent.width * 0.8} else {parent.height * 0.5}
            color:"#202020"
            radius:8
            border.color:"black"

            Image {
                anchors.centerIn: parent
                source:"graphics/camera.png"
                width:parent.width * 0.8
                height:parent.height * 0.8
                fillMode:Image.PreserveAspectFit
            }

            MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                                capturedAsspect = selectedAsspect;
                            camera.imageCapture.captureToLocation(paths.split(",")[2].trim());
                            //camera.imageCapture.capture();
                        }
                    }
        }


        Rectangle {
            id:importbutton
            anchors.bottom:if(mainView.width > mainView.height) {parent.top} else {parent.bottom}
            anchors.bottomMargin:if(mainView.width > mainView.height) {-height * 1.03 } else {parent.height * 0.03}
            anchors.margins:parent.height * 0.03
            anchors.left:parent.left
            width:if(mainView.width > mainView.height) {parent.height * 0.1} else {parent.height * 0.2}
            height:if(mainView.width > mainView.height) {parent.height * 0.1} else {parent.height * 0.2}
            color:"#202020"
            radius:8
            border.color:"black"

            Image {
                anchors.centerIn: parent
                source:"graphics/file.png"
                width:parent.width * 0.81
                height:parent.height * 0.8
                fillMode:Image.PreserveAspectFit
            }

            MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                                activeTransfer = picSourceSingle.request();

                        }
                    }
        }




        Column {
            anchors.left:camerabutton.right
            anchors.leftMargin:if(mainView.width > mainView.height){-camerabutton.width / 2.5 } else {parent.height * 0.02}
            width:camerabutton.height * 0.4
            height: parent.height - camerabutton.y
            y:if(mainView.width > mainView.height){camerabutton.height * 1.1 + camerabutton.y } else {camerabutton.y - width * 0.5}

            spacing:parent.height * 0.02


        Rectangle {
            id:switchcamera
            //anchors.bottom:parent.bottom
            //anchors.bottomMargin: parent.height * 0.01
            width:parent.width
            height:parent.width

            color:"#202020"
            radius:8
            border.color:"black"

            Image {
                id:cameratype
                anchors.centerIn: parent
                source:"graphics/backC.png"
                width:parent.width * 0.8
                height:parent.height * 0.8
                fillMode:Image.PreserveAspectFit
            }

            MouseArea {
                        anchors.fill: parent;
                        onClicked:if(camera.position == 1) {camera.position = 2;cameratype.source ="graphics/frontC.png"}
                                  else {camera.position = 1;cameratype.source ="graphics/backC.png"}
        }
        }

        Rectangle {
            //id:switchcamera
            //anchors.bottom:parent.bottom
            //anchors.bottomMargin: parent.height * 0.01
            width:parent.width
            height:parent.width

            color:"#202020"
            radius:8
            border.color:"black"

            Image {
                id:flashtype
                anchors.centerIn: parent
                source:"graphics/FA.png"
                width:parent.width * 0.8
                height:parent.height * 0.8
                fillMode:Image.PreserveAspectFit
            }

            MouseArea {
                        anchors.fill: parent;
                        onClicked:switch(setFlash) {
                                  case 0: setFlash =1;flashtype.source = "graphics/FO.png";break;
                                  case 1: setFlash = 2;flashtype.source = "graphics/FS.png";break;
                                  case 2: setFlash = 0;flashtype.source = "graphics/FA.png";break;
                                  }
        }
        }

        }

        Column  {

            anchors.right:camerabutton.left
            anchors.rightMargin:if(mainView.width > mainView.height){-camerabutton.width / 2.5 } else {parent.height * 0.02}
            width:camerabutton.height * 0.4
            height: parent.height - camerabutton.y
            y:if(mainView.width > mainView.height){camerabutton.height * 1.1 + camerabutton.y } else {camerabutton.y - width * 0.5}
            spacing:parent.height * 0.02

        Rectangle {
            //id:switchasspect
            //anchors.bottom:parent.bottom
            //anchors.bottomMargin: parent.height * 0.01

            width:parent.width
            height:parent.width

            color:"#202020"
            radius:8
            border.color:"black"

            Image {
                id:focustype
                anchors.centerIn: parent
                source:"graphics/Fauto.png"
                width:parent.width * 0.8
                height:parent.height * 0.8
                fillMode:Image.PreserveAspectFit
            }

            MouseArea {
                        anchors.fill: parent;
                        onClicked: switch(setFocus) {
                                   case 0: setFocus =1;focustype.source = "graphics/Fcount.png";break;
                                   case 1: setFocus = 2;focustype.source = "graphics/Fhyper.png";break;
                                   case 2: setFocus = 3;focustype.source = "graphics/Finf.png";break;
                                   case 3: setFocus = 4;focustype.source = "graphics/Fmacro.png";break;
                                   case 4: setFocus = 0;focustype.source = "graphics/Fauto.png";break;
                                   }
                    }
        }


        Rectangle {
            //id:switchcamera
            //anchors.bottom:parent.bottom
            //anchors.bottomMargin: parent.height * 0.01
            width:parent.width
            height:parent.width

            color:"#202020"
            radius:8
            border.color:"black"


            Text {
                id:expostype
                anchors.centerIn: parent
                width:parent.width * 0.7
                height:parent.height * 0.7
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color:"#9d9d9d"
                text:"Au"
                font.pixelSize: height - text.length
            }

            MouseArea {
                        anchors.fill: parent;
                        onClicked:switch(setExpos) {
                                  case 0: setExpos =1;expostype.text = "LS";break;
                                  case 1: setExpos = 2;expostype.text = "Nt";break;
                                  case 2: setExpos = 3;expostype.text = "Sp";break;
                                  case 3: setExpos = 0;expostype.text = "Au";break;
                                  }
        }
        }

        }


}



        }




      /*  Connections {
                     target: window_container.activeTransfer
                     onStateChanged: {
                         if (window_container.activeTransfer.state === ContentTransfer.Charged) {
                               capturedAsspect = 0;
                             //importItems = window_container.activeTransfer.items;
                             thesource = window_container.activeTransfer.items[0].url;
                             thefile = window_container.activeTransfer.items[0].url;
                             //console.log("From Transfer: "+thefile);
                             fromhub = 1;

                         }

                     }
                 } */



        Item {
            id:thewizard

            states: [
                    State {
                        name:"Show"
                        PropertyChanges {
                            target:thewizard
                            y:window_container.height * 0.03
                        }


                },
                State {
                    name:"Hide"
                    PropertyChanges {
                        target:thewizard
                        y:window_container.height
                    }
                }
            ]

            state:"Hide"

            width:if(parent.width > parent.height) {parent.width * 0.6} else {parent.width * 0.9}
            height:window_container.height * 0.8
            anchors.horizontalCenter: window_container.horizontalCenter
            clip:true

            Rectangle {
                anchors.fill: parent
                radius:8
                color:"#202020"
            }

            Text {
                id:wizardtitle
                anchors.top:parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                text:"Wizard"
                color:"white"
                font.pointSize: if(parent.height > 0 ) {parent.height * 0.05} else {8}

            }

            Rectangle {
                anchors.top:wizardtitle.bottom
                width:parent.width
                height:parent.height * 0.01

                color:"#7e4e4e"
            }

            GridView {
                    id:effectsGrid
                    anchors.top:wizardtitle.bottom
                    anchors.topMargin:parent.height * 0.02
                    anchors.horizontalCenter: parent.horizontalCenter

                    width:parent.width * 0.9
                    height:parent.height * 0.9
                    snapMode: GridView.SnapOneRow

                    clip:true
                    cellHeight:height * 0.9
                    cellWidth:width

                    model:ListModel {
                        id:effectslist

                        ListElement {
                            theeffect:1
                            title:"No Effect"
                            artist:"The Nihilist"
                        }
                        ListElement {
                            theeffect:2
                            title:"Black and White"
                            artist:"Vague Entertainment"
                        }
                        ListElement {
                            theeffect:3
                            title:"Sepia"
                            artist:"Vague Entertainment"
                        }
                        ListElement {
                            theeffect:4
                            title:"Sepia Old"
                            artist:"Vague Entertainment"
                        }
                        ListElement {
                            theeffect:5
                            title:"High Contrast B/W"
                            artist:"Vague Entertainment"
                        }
                       /* ListElement {
                            theeffect:6
                        } */
                    }

                   delegate: Item {
                       height:effectsGrid.cellHeight
                       width:effectsGrid.cellWidth
                                    Effects {
                        effect:theeffect
                        type:0
                        anchors.centerIn: parent
                        thetitle:title
                        theartist:artist

                        height:parent.height * 0.98
                        width:parent.width * 0.98
                        therotation:if(camera.position == 2) {-90} else {capturedAsspect}

                        theHue:check.theHue
                        theSat:check.theSat
                        thebrightness:check.thebrightness
                        thecontrast: check.thecontrast


                        MouseArea {
                            anchors.fill:parent
                            onClicked: {
                                        thewizard.state = "Hide"
                                        selectedEffect = theeffect

                            }
                        }
                    }
                   }



                    add: Transition {
                            //NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
                            NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 200 }
                        }

                }



        }

        Item {
            id:theoverlay


            states: [
                    State {
                        name:"Show"
                        PropertyChanges {
                            target:theoverlay
                            y:window_container.height * 0.03
                        }


                },
                State {
                    name:"Hide"
                    PropertyChanges {
                        target:theoverlay
                        y:window_container.height
                    }
                }
            ]

            state:"Hide"

            width:if(parent.width > parent.height) {parent.width * 0.6} else {parent.width * 0.9}
            height:if(parent.width > parent.height) {window_container.height * 0.95} else {window_container.height * 0.8}
             clip:true
            anchors.horizontalCenter: window_container.horizontalCenter

            Rectangle {
                anchors.fill: parent
                radius:8
                color:"#202020"
            }

            Text {
                id:overlaytitle
                anchors.top:parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                text:"OverLays"
                color:"white"
                font.pointSize: if(parent.height > 0 ) {parent.height * 0.05} else {8}

            }

            Rectangle {
                anchors.top:overlaytitle.bottom
                width:parent.width
                height:parent.height * 0.01

                color:"#4e4e4e"
            }

            GridView {
                    id:overlayGrid
                    anchors.top:overlaytitle.bottom
                    anchors.topMargin:parent.height * 0.02
                    anchors.horizontalCenter: parent.horizontalCenter

                    width:parent.width * 0.9
                    height:parent.height * 0.9
                    snapMode: GridView.SnapOneRow

                    clip:true
                    cellHeight:height * 0.9
                    cellWidth:width

                    model:ListModel {
                        id:overlaylist

                        ListElement {
                            theeffect:1
                            title:"No Overlay"
                            artist:"The Nihilist"

                        }
                        ListElement {
                            theeffect:2
                            title:"Caged"
                            artist:"Vague Entertainment"
                        }
                        ListElement {
                            theeffect:3
                            title:"Tattered"
                            artist:"Vague Entertainment"
                        }
                        ListElement {
                            theeffect:4
                            title:"SoundWAV"
                            artist:"Vague Entertainment"
                        }

                       /* ListElement {
                            theeffect:5
                        }
                        ListElement {
                            theeffect:6
                        } */

                    }

                    delegate:
                                 Item {
                                      height:effectsGrid.cellHeight
                                      width:effectsGrid.cellWidth
                                      clip:true
                                                            Effects {
                                                                type:1
                                               overlay:theeffect
                                                anchors.centerIn: parent

                                                thetitle:title
                                                theartist:artist

                                                height:parent.height * 0.98
                                                 width:parent.width * 0.98
                                                 therotation:if(camera.position == 2) {-90} else {capturedAsspect}
                                                 theHue:check.theHue
                                                 theSat:check.theSat
                                                 thebrightness:check.thebrightness
                                                 thecontrast: check.thecontrast


                                      MouseArea {
                                            anchors.fill:parent
                                       onClicked: {
                                              theoverlay.state = "Hide"
                                              selectedOverlay = theeffect


                                        }
                                 }
                    }
                    }



                    add: Transition {
                            //NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
                            NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 200 }
                        }

                }




        }

        Item {
            id:colandSat
            clip:true

            MouseArea {
                anchors.fill: parent
                onClicked:console.log("caught")
            }


            states: [
                    State {
                        name:"Show"
                        PropertyChanges {
                            target:colandSat
                            y:effectsRow.height+effectsRow.y
                        }


                },
                State {
                    name:"Hide"
                    PropertyChanges {
                        target:colandSat
                        y:window_container.height
                    }
                }
            ]

            state:"Hide"

            width:parent.width
            height:window_container.height - (effectsRow.y + effectsRow.height)

            Rectangle {
                anchors.fill:parent
                color:"#202020"
            }

            Column {
                anchors.top:parent.top
                anchors.topMargin: parent.height * 0.1
                width:parent.width
                height:parent.height * 0.8
                spacing: parent.height * 0.1

                Image {

                width:colandSat.height *0.2
                height:colandSat.height * 0.2
                source:"graphics/Hue.png"
                fillMode: Image.PreserveAspectFit

                Slider {
                    id:col
                    to: 100
                    from: 0

                    width:(window_container.width - parent.width) * 0.9
                    anchors.left:parent.right
                    anchors.leftMargin:parent.height * 0.1
                    anchors.verticalCenter: parent.verticalCenter
                    height:colandSat.hieght * 0.5
                    stepSize: 1

                    value: 0
                    onValueChanged: check.theHue = (value * 0.01)

                }

                }

                Image {

                width:colandSat.height *0.2
                height:colandSat.height * 0.2
                source:"graphics/sat.png"
                fillMode: Image.PreserveAspectFit

                Slider {
                    id:sat
                   to: 100
                   from: 0
                    width:(window_container.width - parent.width) * 0.9
                    anchors.left:parent.right
                    anchors.leftMargin:parent.height * 0.1
                    anchors.verticalCenter: parent.verticalCenter
                    height:colandSat.hieght * 0.5
                    stepSize: 1

                    value: 0
                    onValueChanged: check.theSat = (value * 0.01)

                }

                }
            }


            Rectangle {
                id:colandSatReset
                anchors.right:parent.right
                anchors.bottom:parent.bottom
                anchors.margins: 20
                width:parent.width * 0.30
                height:parent.height * 0.20
                border.color:"lightgray"
                color:"gray"
                radius:8

                Text {
                    id:colandSatResettext
                    text:qsTr("Reset")
                    font.pixelSize: parent.height / 2
                    anchors.centerIn: parent
                    color:"white"
                }
                MouseArea {
                    anchors.fill:parent
                    hoverEnabled: true

                    onClicked:sat.value = 0.0, col.value = 0.0, hideall()
                }
            }


            Rectangle {
                id:colandSatCancel
                anchors.left:parent.left
                anchors.bottom:parent.bottom
                anchors.margins: 20
                width:parent.width * 0.30
                height:parent.height * 0.20
                border.color:"lightgray"
                color:"gray"
                radius:8

                Text {
                    id:colandSatCanceltext
                    text:qsTr("Close")
                    font.pixelSize: parent.height / 2
                    anchors.centerIn: parent
                    color:"white"
                }
                MouseArea {
                    anchors.fill:parent
                    hoverEnabled: true

                    onClicked: hideall()
                }
            }



        }
        Item {
            id:briandCon
            clip:true

            MouseArea {
                anchors.fill: parent
                onClicked:console.log("caught")
            }

            states: [
                    State {
                        name:"Show"
                        PropertyChanges {
                            target:briandCon
                            y:effectsRow.height+effectsRow.y
                        }


                },
                State {
                    name:"Hide"
                    PropertyChanges {
                        target:briandCon
                        y:window_container.height
                    }
                }
            ]

            state:"Hide"

            width:parent.width
            height:window_container.height - (effectsRow.y + effectsRow.height)

            Rectangle {
                anchors.fill:parent
                color:"#202020"
            }

            Column {
                anchors.top:parent.top
                anchors.topMargin: parent.height * 0.1
                width:parent.width
                height:parent.height * 0.8
                spacing: parent.height * 0.1

                Image {

                width:briandCon.height *0.2
                height:briandCon.height * 0.2
                source:"graphics/brightness.png"
                fillMode: Image.PreserveAspectFit

                Slider {
                    id:bri
                    to: 100
                    from: -100
                    width:(window_container.width - parent.width) * 0.9
                    anchors.left:parent.right
                    anchors.leftMargin:parent.height * 0.1
                    anchors.verticalCenter: parent.verticalCenter
                    height:briandCon.hieght * 0.5
                    stepSize: 1

                    value: 0
                    onValueChanged: check.thebrightness = (value * 0.01)
                }

                }

                Image {

                width:briandCon.height *0.2
                height:briandCon.height * 0.2
                source:"graphics/contrast.png"
                fillMode: Image.PreserveAspectFit

                Slider {
                    id:con
                    to: 100
                    from: -100
                    width:(window_container.width - parent.width) * 0.9
                    anchors.left:parent.right
                    anchors.leftMargin:parent.height * 0.1
                    anchors.verticalCenter: parent.verticalCenter
                    height:briandCon.hieght * 0.5
                    stepSize: 1

                    value: 0
                    onValueChanged: check.thecontrast = (value * 0.01)

                }

                }
            }



            Rectangle {
                id:briConReset
                anchors.right:parent.right
                anchors.bottom:parent.bottom
                anchors.margins: 20
                width:parent.width * 0.30
                height:parent.height * 0.20
                border.color:"lightgray"
                color:"gray"
                radius:8

                Text {
                    id:briConResettext
                    text:qsTr("Reset")
                    font.pixelSize: parent.height / 2
                    anchors.centerIn: parent
                    color:"white"
                }
                MouseArea {
                    anchors.fill:parent
                    hoverEnabled: true

                    onClicked:con.value = 0.0, bri.value = 0.0, hideall()
                }
            }

            Rectangle {
                id:briConCancel
                anchors.left:parent.left
                anchors.bottom:parent.bottom
                anchors.margins: 20
                width:parent.width * 0.30
                height:parent.height * 0.20
                border.color:"lightgray"
                color:"gray"
                radius:8

                Text {
                    id:briConResetCancel
                    text:qsTr("Close")
                    font.pixelSize: parent.height / 2
                    anchors.centerIn: parent
                    color:"white"
                }
                MouseArea {
                    anchors.fill:parent
                    hoverEnabled: true

                    onClicked:hideall()
                }
            }



        }

        function hideall() {

            briandCon.state = "Hide"
            colandSat.state = "Hide"
            thewizard.state = "Hide"
            theoverlay.state = "Hide"

        }


}

