import QtQuick 2.0

Item {

    Rectangle {
        anchors.fill: parent
        //color:"lightgray"
        color:"#4e4e4e"
   /* Text {
        anchors.centerIn: parent
        text:"HelioGraph"
        color:"white"
        font.pixelSize: parent.height /2

    } */

    Image {
        anchors.centerIn: parent
        source:"graphics/title.png"
        height:parent.height * 0.8
        fillMode:Image.PreserveAspectFit
    }

    Rectangle {
        anchors.bottom:parent.bottom
        height:parent.height * 0.04
        width: parent.width
        color:"gray"
    }

    }

}

