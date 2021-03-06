// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "delegates"

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

import "../code/settings.js" as Settings

Item{
    id: allwlists
    property int scale: 50
    property alias actImagHeight: actImag1.height
    property color actImagBordColor: "#77ffffff"
    property alias activitiesShown:activitiesList.shownActivities
    property alias flickableV:view.interactive
    property string typeId : "WorkareasMainView"
    property int workareaWidth: 0
    property int workareaHeight: 0
    property int animationsStep: 0
    property int verticalScrollBarLocation: view.width

    Behavior on width{
        NumberAnimation {
            duration: 2*Settings.global.animationStep2;
            easing.type: Easing.InOutQuad;
        }
    }

    Flickable{
        id: view

        anchors.fill: parent
        contentWidth: allareas.width
        contentHeight: allareas.height

        boundsBehavior: Flickable.StopAtBounds

        property string typeId : "WorkareasMainViewFlickable"

        Image{
            width:mainView.width<allareas.width ? allareas.width : mainView.width
            height:mainView.height<allareas.height ? allareas.height : mainView.height
            source:"Images/greyBackground.png"
            visible: !Settings.global.disableBackground
            fillMode: Image.Tile
            property string typeId : "workareasFlickImage1"
        }

        ListView{
            id:allareas

            y: 2.2 * allwlists.scale
            //+1, for not creating a visual issue...
            width: (activitiesList.shownActivities+1) * allwlists.workareaWidth
            height: maxWorkAreasHeight + actImag1.height + actImag1Shad.height

            orientation: ListView.Horizontal

            anchors.left: parent.left
            interactive:false
            property string typeId : "WorkareasColumnAppearance"

           // property int maxWorkAreasHeight: (workflowManager.workareaManager().maxWorkareas *
            property int maxWorkAreasHeight:0

            model:runningActivitiesModel

            delegate: WorkAreaListDeleg{}

            function changedChildHeight(){
                var max=0;

                for (var i=0; i<allareas.children[0].children.length; ++i)
                {
                    var childList = allareas.children[0].children[i];

                    if (childList.state === "show"){
                        var tempH = childList.height +  childList.addedHeight;
                        //console.debug(tempL);
                        if (tempH>max)
                            max = tempH;
                    }
                }
                allareas.maxWorkAreasHeight = max;
            }
        }

        //Top Activities Banner
        Rectangle{
            id:actImag1Shad
            anchors.top: actImag1.bottom

            width: allwlists.width < allareas.width ? allareas.width : allwlists.width
            height: allwlists.scale / 3
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#aa0f0f0f" }
                GradientStop { position: 1.0; color: "#00797979" }
            }
        }

        Rectangle {
            id: actImag1
            width: allwlists.width < allareas.width ? allareas.width : allwlists.width

            height: 1.6 * allwlists.scale
            color: "#646464"
            border.color: allwlists.actImagBordColor
            border.width:1
            property string typeId : "RunningActivitiesFrame"

            ListView {
                id: activitiesList

                orientation: ListView.Horizontal
                height:parent.height
                width: allareas.width
                interactive:false
                model: runningActivitiesModel

                //property int shownActivities: 0
                property int shownActivities: model.count
                property string typeId : "RunningActivitiesList"

                delegate: ActivityDeleg{
                    id: activityInstance

                    MouseArea{
                        id:draggingReceiver

                        property string typeId: "activityReceiver"

                        width: activityInstance.width-5
                        height: 0.8 * mainView.height
                        visible: ((draggingActivities.activityId !== "") &&
                                  (draggingActivities.activityStatus === "Running"))

                        property string activityCode : ccode
                        property string activityName : Name


                        hoverEnabled: true
                        property int oldX
                        property int oldY

                        onVisibleChanged:{
                            if(visible){
                                oldX = x;
                                oldY = y;
                                var coord = mapToItem(draggingActivities, x, y);
                                parent = draggingActivities;
                                x = coord.x;
                                y = coord.y;
                            }
                            else{
                                parent = activityInstance;
                                x = oldX;
                                y = oldY;
                            }
                        }

            //     //       Rectangle{
                   //         anchors.fill: parent
                  //          color:"#0000e3"
                    //    }

                    }
                }

            }
        }
    }//Flickable scrolling

    //Scrollbars
    // Attach scrollbars to the right and bottom edges of the view.
    ScrollBar {
        id: verticalScrollBar
        width: 11;
        anchors.top: view.top
        anchors.bottom: view.bottom
        x: allwlists.verticalScrollBarLocation - width
        opacity: 0
        orientation: Qt.Vertical
        position: view.visibleArea.yPosition
        pageSize: view.visibleArea.heightRatio

        states: State {
            name: "moving"
            when: view.movingVertically && view.height <= view.contentHeight
            PropertyChanges { target: verticalScrollBar; opacity: 1 }
        }
        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 2 * allwlists.animationsStep }
        }
    }

    ScrollBar {
        id: horizontalScrollBar
        height: 11
        anchors.left: view.left
        width: allwlists.verticalScrollBarLocation
        anchors.bottom: view.bottom
        opacity: 0
        orientation: Qt.Horizontal
        position: view.visibleArea.xPosition
        pageSize: view.visibleArea.widthRatio
        states: State {
            name: "moving"
            when: view.movingHorizontally && view.width <= view.contentWidth
            PropertyChanges { target: horizontalScrollBar; opacity: 1 }
        }
        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 2 * allwlists.animationsStep }
        }
    }

    //return activities listview
    function getList(){
        return activitiesList;
    }


    function getActivityColumn(cd){
        for (var i=0; i<allareas.children[0].children.length; ++i)
        {
            var elem = allareas.children[0].children[i];
            if (elem.ccode === cd)
                return elem;
        }
    }
}
