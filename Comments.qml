import QtQuick 2.0

Item {
    property string thedate:""
    property string thecomment:""
    property string thename:""
    property string theavatar:""
    height:commentblock.height * 4.1



    Rectangle {
        //anchors.fill:parent
        anchors.centerIn: parent
        width:parent.width * 0.98
        height:parent.height * 1
        radius:8
        border.color:"black"
        color:"white"



        Text {
            id:commentor
            anchors.top:parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins:parent.height * 0.02
            text:thename+":"
            font.pointSize: if(mainView.height > 0) {mainView.height * 0.025} else {8}
        }

        Text {
            id:commentblock
            anchors.top:commentor.bottom
            anchors.topMargin:mainView.height * 0.008
            //anchors.bottom:parent.bottom
            anchors.right:parent.right
            width:parent.width - avatarback.width
            //height:parent.height *0.80
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode:Text.WordWrap
            text:thecomment
            font.pointSize: if(mainView.height > 0) {mainView.height * 0.015} else {8}

        }

        Text {
            anchors.top:parent.top
            anchors.right:parent.right
            anchors.margins:parent.height * 0.05
            text:thedate
        }

    }

    Rectangle {
        id:avatarback
        anchors.left:parent.left
        anchors.top:parent.top
        width:mainView.height * 0.1
        height:mainView.height * 0.1
        border.color:"black"
        color:"#4e4e4e"


        Image {
            anchors.centerIn: parent
            width:mainView.height * 0.1
            height:mainView.height * 0.1
            source:theavatar
        }

    }

    MouseArea {
        anchors.fill:parent
        onClicked:searchstring = thename,stream_reload.running = true,get_stream.running = true
    }

}
