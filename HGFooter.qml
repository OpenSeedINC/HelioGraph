import QtQuick 2.0

Item {
    id:window_container

    MouseArea {
        anchors.fill:parent
        onClicked: console.log("")
    }

    states: [

        State {
            name:"Show"

            PropertyChanges {
                target:window_container
                y:mainView.height - window_container.height
            }
        },

        State {
            name:"Hide"

            PropertyChanges {
                target:window_container
                y:mainView.height + window_container.height
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

    Rectangle {
        anchors.fill: parent
        //color:"lightgray"
        color:"#4e4e4e"

        Rectangle {
            anchors.top:parent.top
            height:parent.height * 0.04
            width: parent.width
            color:"gray"
        }

        Rectangle {
            anchors.bottom:parent.bottom
            anchors.bottomMargin:parent.height * 0.1
            anchors.left:parent.left
            anchors.leftMargin: parent.height * 0.1
            width:parent.height * 0.8
            height:parent.height * 0.8
            radius:8
            border.color:"black"
            color:if(themenu.state == "Hide") {"#202020"} else {"#5F4F4F"}

            Image {
                anchors.centerIn: parent
                source:"graphics/menu.png"
                width:parent.width * 0.9
                height:parent.height * 0.9
                fillMode: Image.PreserveAspectFit

            }

            MouseArea {
                anchors.fill:parent
                onClicked:if(mainView.width > mainView.height){} else {if(themenu.state == "Hide") {themenu.state = "Show"} else {themenu.state = "Hide"} }
            }
        }

    Rectangle {
        //anchors.verticalCenter: parent.verticalCenter
        anchors.bottom:parent.bottom
        anchors.bottomMargin:parent.height * 0.1
        anchors.horizontalCenter: parent.horizontalCenter
        width:parent.height * 1.01
        height:parent.height * 1.01
        radius:8
        border.color:"black"
        color:"#202020"

        Image {
            anchors.centerIn: parent
            source:"graphics/cameraback.png"
            width:parent.width * 0.8
            height:parent.height * 0.8
            fillMode: Image.PreserveAspectFit

        }

        MouseArea {
            anchors.fill:parent
            onClicked: viewfinder.state = "Show"
        }


    }
    Rectangle {
        anchors.bottom:parent.bottom
        anchors.bottomMargin:parent.height * 0.1
        anchors.right:parent.right
        anchors.rightMargin: parent.height * 0.1
        width:parent.height * 0.8
        height:parent.height * 0.8
        radius:8
        color:if(search.visible == false) {"#202020"} else {"#5F4F4F"}

        border.color:"black"


        Image {
            anchors.centerIn: parent
            source:"graphics/search.png"
            width:parent.width * 0.9
            height:parent.height * 0.9
            fillMode: Image.PreserveAspectFit

        }

        MouseArea {
            anchors.fill:parent
            onClicked:if(search.visible == false) {search.visible = true} else {search.visible = false}
        }

    }



    }

}

