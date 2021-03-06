// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

import "ui-elements"
import "../components"
import "../../code/settings.js" as Settings

Item{
    id: stpActivity
    property string typeId : "StoppedActivityDelegate"

    property string neededState: "Stopped"
    property string ccode: code
    property string cState: CState

    property bool shown: CState === neededState

    //  opacity: shown ? 1 : 0.001
    width: stoppedActivitiesList.width
    height: basicHeight
    opacity: 1

    // height: shown ? basicHeight : 0

    property real basicHeight:0.62*mainView.workareaHeight
    property int buttonsSize:0.5 * mainView.scaleMeter

    property real opacityDisBackground: Settings.global.disableBackground ? 0.85 : 0.6

    property real defOpacity: activityDragged ? 0.001 : opacityDisBackground

    property bool containsMouse:( ((deleteActivityBtn.containsMouse) ||
                                   (mouseArea.containsMouse))&&
                                 (!activityDragged))

    property bool activityDragged: (draggingActivities.activityId === code) &&
                                   (draggingActivities.activityStatus === "Stopped")

    property bool isSelected: ( (keyNavigation.isActive) &&
                               (keyNavigation.selectedActivity === ccode) )


    Rectangle{
        id:draggingRectangle
        anchors.centerIn: parent
        width:parent.width - 8
        height: parent.height - 8
        radius:10
        color: "#aaaaaa"
        border.width: 1
        border.color: "#111111"
        opacity:(activityDragged || isSelected) ? 0.30 : 0
    }
    /*
        onCStateChanged:{
            //stoppedPanel.changedChildState();
        }*/

    /*
    Behavior on opacity{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on y{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on width{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }*/



    //Item{
    ///Ghost Element in order for the activityIcon to be the
    ///second children
    // }


    Item{
        id:activityIconContainer

        x:stpActivity.width/2
        width:5+0.9*mainView.scaleMeter
        height:width
        anchors.top:parent.top
        anchors.topMargin:10
        anchors.right: parent.right
        anchors.rightMargin: 10


        //for the animation to be precise
        property int toRX:stopActBack.shownActivities > 0 ? x - width:x - width- stopActBack.width
        property int toRY:stopActBack.shownActivities > 0 ? y : -height

        opacity: !activityDragged

        QIconItem{
            id:activityIconEnabled
            opacity:stpActivity.containsMouse ? 1 : 0
            smooth:true
            rotation:-20

            icon: Icon == "" ? QIcon("plasma") : QIcon(Icon)
            enabled:true

            anchors.fill: parent

            Behavior on rotation{
                NumberAnimation {
                    duration: 2*Settings.global.animationStep;
                    easing.type: Easing.InOutQuad;
                }
            }

            Behavior on opacity{
                NumberAnimation {
                    duration: 2*Settings.global.animationStep;
                    easing.type: Easing.InOutQuad;
                }
            }
        }

        QIconItem{
            id:activityIconDisabled
            rotation:-20
            opacity:stpActivity.containsMouse ? 0 : stpActivity.defOpacity
            smooth:true

            icon: Icon == "" ? QIcon("plasma") : QIcon(Icon)
            enabled:false

            anchors.fill: parent

            Behavior on rotation{
                NumberAnimation {
                    duration: 2*Settings.global.animationStep;
                    easing.type: Easing.InOutQuad;
                }
            }

            Behavior on opacity{
                NumberAnimation {
                    duration: 2*Settings.global.animationStep;
                    easing.type: Easing.InOutQuad;
                }
            }
        }
    }

    Text{
        id:stpActivityName
        text:Name

        width:0.99*stoppedActivitiesList.width-5
        wrapMode: TextEdit.Wrap

        font.family: theme.defaultFont.family
        font.bold: true
        font.italic: true

        font.pixelSize: 0.13 * parent.height

        property real defOpacityDisBackground : Settings.global.disableBackground ? 0.35 : stpActivity.defOpacity
        opacity: stpActivity.containsMouse ? 1 : defOpacityDisBackground

        color: Settings.global.disableBackground ? theme.textColor : "#4d4b4b"

        anchors.top: activityIconContainer.bottom
        anchors.topMargin: activityIconContainer.height/8
        anchors.right: parent.right
        anchors.rightMargin: 5

        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignBottom
        maximumLineCount:2
        elide: Text.ElideRight

        Behavior on opacity{
            NumberAnimation {
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }
    }

    Rectangle{
        id:stpActivitySeparator

        anchors.horizontalCenter: stpActivity.horizontalCenter

        y:parent.basicHeight-height

        width:0.8 * stopActBack.width
        height:2

        opacity: Settings.global.disableBackground ? 0.20 : 1
        color: Settings.global.disableBackground ? theme.textColor :"#d7d7d7"
    }


    QIconItem{
        id:playActivity
        opacity:stpActivity.containsMouse ? 1 : 0
        icon: QIcon("media-playback-start")

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: stpActivityName.top
        //anchors.verticalCenter: parent.verticalCenter

        width: 0.45 * stpActivity.width
        height: width

        Behavior on opacity{
            NumberAnimation {
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }
    }

    DraggingMouseArea{
        id: mouseArea
        anchors.fill: parent
        draggingInterface: draggingActivities

        onClickedOverrideSignal: {
            activateActivity();
        }

        onDraggingStarted: {
            if(!Settings.global.lockActivities){
                var coords = mapToItem(mainView, mouse.x, mouse.y);
                draggingActivities.enableDragging(mouse, coords, code, "Stopped", Icon);
            }
        }

    }

    IconButton {
        id:deleteActivityBtn
        icon: "edit-delete"
        anchors.right:parent.right
        anchors.top:parent.top
        width: buttonsSize
        height: buttonsSize
        opacity: (stpActivity.containsMouse && !Settings.global.lockActivities) ? 1 : 0
        onClicked: {
            mainView.getDynLib().showRemoveDialog(ccode,workflowManager.activityManager().name(ccode));
        }

        tooltipTitle: i18n("Delete Activity")
        tooltipText: i18n("Delete Activity. Be careful, this action can not be undone.")

        Behavior on opacity{
            NumberAnimation {
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }
    }

    Rectangle{
        anchors.centerIn: parent
        id:draggingSelection
        width:parent.width - 8
        height:parent.height - 8
        radius:10
        color:"#C8D3FF"
        border.width:1
        border.color:"#6B86A7"
        opacity: 0.6

        visible: draggingActivities.currentActivity === ccode
    }

    PlasmaCore.ToolTip {
        target: mouseArea
        mainText: i18n("Restore Activity")
        subText: i18n("Restore Activity to continue your work from where you had stopped.")
        image: "media-playback-start"
    }

    ListView.onAdd: SequentialAnimation{
        PropertyAction { target: stpActivity; property: "width"; value: 1 }
        PropertyAction { target: stpActivity; property: "opacity"; value: 0.1 }
        PropertyAction { target: stpActivity; property: "height"; value: 0.62*mainView.workareaHeight }
        PropertyAction { target: stpActivity; property: "visible"; value: true }

        ParallelAnimation{
            NumberAnimation { target: stpActivity; property: "width"; to: stoppedActivitiesList.width; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
            NumberAnimation { target: stpActivity; property: "opacity"; to: 1; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
        }
    }

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: stpActivity; property: "ListView.delayRemove"; value: true }

        ParallelAnimation{
            NumberAnimation { target: stpActivity; property: "width"; to: 0; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
            NumberAnimation { target: stpActivity; property: "opacity"; to: 0; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
        }
        // Make sure delayRemove is set back to false so that the item can be destroyed
        PropertyAction { target: stpActivity; property: "ListView.delayRemove"; value: false }
    }

    Connections{
        target:keyNavigation
        onActionActivated:{
            if(isSelected)
                activateActivity();
        }
    }

    function activateActivity(){
        workflowManager.activityManager().start(ccode);

        if(Settings.global.animationStep2!==0){
            var x1 = activityIconDisabled.x;
            var y1 = activityIconDisabled.y;

            //activityAnimate.animateStoppedToActive(ccode,activityIcon.mapToItem(mainView,x1, y1));
            mainView.getDynLib().animateStoppedToActive(ccode,activityIconDisabled.mapToItem(mainDialogItem,x1, y1));
        }
    }

    function getIcon(){
        return activityIconDisabled;
    }

}

