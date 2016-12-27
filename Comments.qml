import QtQuick 2.0

Item {
    property string thedate:""
    property string thecomment:""
    property string thename:""
    property string theavatar:""



    Rectangle {
        //anchors.fill:parent
        anchors.centerIn: parent
        width:parent.width * 0.98
        height:parent.height * 0.80
        radius:8
        border.color:"black"
        color:"white"



        Text {
            anchors.top:parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins:parent.height * 0.02
            text:thename+":"
            font.pointSize: parent.height / 5
        }

        Text {
            anchors.bottom:parent.bottom
            anchors.left:parent.left
            width:parent.width
            height:parent.height *0.80
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode:Text.WordWrap
            text:thecomment
            font.pointSize: parent.height / 4

        }

        Text {
            anchors.top:parent.top
            anchors.right:parent.right
            anchors.margins:parent.height * 0.05
            text:thedate
        }

    }

    Rectangle {
        anchors.left:parent.left
        anchors.top:parent.top
        width:parent.height / 1.4
        height:parent.height / 1.4
        border.color:"black"
        color:"#4e4e4e"


        Image {
            anchors.centerIn: parent
            width:parent.width * 0.98
            height:parent.height * 0.98
            source:theavatar
        }

    }

    MouseArea {
        anchors.fill:parent
        onClicked:searchstring = thename,stream_reload.running = true,get_stream.running = true
    }

}
