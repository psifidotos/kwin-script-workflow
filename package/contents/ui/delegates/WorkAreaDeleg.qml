import QtQuick 1.0

import "ui-elements"
import "../components"
import "../../code/settings.js" as Settings

import org.kde.workflow.components 0.1 as WorkFlowComponents
import org.kde.plasma.core 0.1 as PlasmaCore
//Component{

Item{
    id: mainWorkArea

    property alias workAreaName_visible: workAreaName.visible
    property alias areaButtons_visible: workAreaButtons.visible

    property int classicW:mainView.workareaWidth - 0.2*mainView.scaleMeter
    property int classicH:workList.workAreaImageHeight+workList.realWorkAreaNameHeight+0.7*workalist.addedHeightForCurrent

    width: isCurrentW === true?classicW+0.2*mainView.scaleMeter:classicW
    height: classicH

    x:isCurrentW !== true ? 0.1*mainView.scaleMeter:0

    property string typeId : "WorkareaDelegate"

    property string actCode: workList.ccode
    //property int desktop: gridRow
    property int desktop: index+1

    property int imagex:15
    property int imagey:15

    property int imagewidth:width - 2*imagex
    property int imageheight:height - 2*imagey

    property bool isCurrentW:((mainWorkArea.actCode === sessionParameters.currentActivity) &&
                              (mainWorkArea.desktop === sessionParameters.currentDesktop))

    property bool current: isCurrentW

    //In order to fix the height because of increasing size for current workarea
    onIsCurrentWChanged:{
        if(isCurrentW)
            y=y-workalist.addedHeightForCurrent/2
        else
            y=y+workalist.addedHeightForCurrent/2
    }

    property bool isSelected: ( (keyNavigation.isActive) &&
                               (keyNavigation.selectedActivity === actCode) &&
                               (keyNavigation.selectedWorkarea === desktop) )


    SelectedArea{
        x: normalWorkArea.x - marginLeft
        y: normalWorkArea.y - marginTop - 3
        width: normalWorkArea.width + marginWidth - 3
        height: normalWorkArea.height + marginHeight + 7
        opacity:isSelected

        Behavior on opacity{
            NumberAnimation {
                duration: 2*Settings.global.animationStep
                easing.type: Easing.InOutQuad;
            }
        }
    }

    Item{
        id:normalWorkArea

        width: mainWorkArea.width
        height: isCurrentW ? workList.workAreaImageHeight+workalist.addedHeightForCurrent:workList.workAreaImageHeight

        WorkAreaImage{
            id:borderRectangle
            width:parent.width
            height:parent.height

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    mainWorkArea.showButtons();
                }

                onExited: {
                    mainWorkArea.hideButtons();
                }

                onClicked: {
                    mainWorkArea.clickedWorkarea();
                }

            }//image mousearea

        }

        /////Testing if this can be used in Workareas
        /////problem is that may things are not updated correctly
        ////Leave it for the future
        /*WorkFlowComponents.FilterTaskModel{
            id:taskModel
            sourceMainModel: taskManager.model()
            activity: workList.ccode
            desktop: mainWorkArea.desktop
            everywhereState: Settings.global.disableEverywherePanel
        }*/

        ListView{

            id:tasksSList

            x:mainWorkArea.imagex+1
            y:mainWorkArea.imagey
            width:mainWorkArea.imagewidth-1
            height:Settings.global.showWindows ? workList.workAreaImageHeight-2*mainWorkArea.imagey : 0
            opacity:Settings.global.showWindows ? 1 : 0

            clip:true
            spacing:0
            interactive:false

            property bool hasChildren:childrenRect.height > 1
            property bool isClipped:childrenRect.height > height

            model: taskManager.model()

            property int shownTasks:0
            //property int shownTasks:taskModel.count

            delegate:WorkAreaTaskDeleg{
                rHeight:Math.max(tasksSList.height/6,18)

                onShownChanged:tasksSList.countTasks(ccode, inDragging);
            }


            Behavior on opacity{
                NumberAnimation {
                    duration: 3*Settings.global.animationStep
                    easing.type: Easing.InOutQuad;
                }
            }

            Behavior on height{
                NumberAnimation {
                    duration: 3*Settings.global.animationStep
                    easing.type: Easing.InOutQuad;
                }
            }

            Connections{
                target:tasksSList.model
                onCountChanged: tasksSList.countTasks("", false);
            }

            function countTasks(wId, dragged){
                var counter;

                if(dragged){
                    counter = taskManager.tasksNumber(mainWorkArea.actCode,
                                                      mainWorkArea.desktop,
                                                      Settings.global.disableEverywherePanel,
                                                      wId);
                }
                else{
                    counter = taskManager.tasksNumber(mainWorkArea.actCode,
                                                      mainWorkArea.desktop,
                                                      Settings.global.disableEverywherePanel);
                }

                shownTasks = counter;
            }

        }

        Image{
            id:cornerImage
            source:"../Images/buttons/brownCorner.png"

            height:0.28*borderRectangle.height
            width:height

            property int offset: mainView.scaleMeter<65 ? 1 : 0
            y:borderRectangle.height-height-2-offset
            x:3+offset

            opacity: ((tasksSList.shownTasks>0)&&(Settings.global.showWindows === true)) ?
                         1 : 0

            property color defTextColor:"#d9FFF0B6"
            property color hovTextColor:"#f8f8f8f8"

            MouseArea {
                id:cornerImageMouseArea
                width:0.8*parent.width
                height:0.8*parent.height
                //anchors.fill: parent
                anchors.left: parent.left
                anchors.bottom: parent.bottom

                hoverEnabled: true

                onEntered: {
                    cornerImage.source = "../Images/buttons/blueCorner.png";
                    shownTasksText.color = cornerImage.hovTextColor;
                }

                onExited: {
                    cornerImage.source = "../Images/buttons/brownCorner.png";
                    shownTasksText.color = cornerImage.defTextColor;
                }

                onClicked: {
                    //desktopDialog.openD(actCode,desktop);
                    mainView.getDynLib().showDesktopDialog(actCode,desktop);
                }
            }

            PlasmaCore.ToolTip{
                target:cornerImageMouseArea
                mainText: i18n("Show Windows")
                subText: i18n("You can see the windows from that spesific Workarea if you want. The counter shows their number.")
                //icon:instanceOfThemeList.icons.RunActivity
            }

            Text{
                id:shownTasksText

                text:tasksSList.shownTasks

                width:0.38*parent.height
                height:width

                color: cornerImage.defTextColor

                font.pixelSize: 0.4*cornerImage.width
                font.italic:true
                font.family: mainView.defaultFont.family


                horizontalAlignment:Text.AlignHCenter

                anchors.left: parent.left
                anchors.leftMargin: 0.07 * parent.width
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0.12 * parent.height


                Behavior on color{
                    ColorAnimation {
                        duration: 2*Settings.global.animationStep;
                        easing.type: Easing.InOutQuad;
                    }
                }
            }
        }

        WorkAreaBtns{
            id:workAreaButtons

            x:borderRectangle.x + borderRectangle.width-7 - 0.5*width//7 is the half of border
            y:5-0.5*height //5 is the half of border
            opacity: mainWorkArea.ListView.view.model.count>1 ? 1 : 0
        }

        DTextLine{
            id:workAreaName

            y: borderRectangle.height-5
            width: mainWorkArea.width
            height: workList.workAreaNameHeight
            text: title

            onTextAcceptedSignal: {
                workflowManager.workareaManager().renameWorkarea(mainWorkArea.actCode,mainWorkArea.desktop, finalText);
            }
        }

        PlasmaCore.ToolTip{
            mainText: i18n("Edit WorkArea")
            subText: i18n("You can edit the Workarea name in order to personalize more your work.")
            //This is a workaround because if workAreaName was used the containsMouse does not work
            //at all inside DTextLine
            image: "im-status-message-edit"
            target: workAreaName.tooltipItem
        }

    } //normalWorkArea Item

    ListView.onAdd: ParallelAnimation {
        PropertyAction { target: mainWorkArea; property: "height"; value: 0 }
        PropertyAction { target: mainWorkArea; property: "opacity"; value: 0 }

        NumberAnimation { target: mainWorkArea; property: "height"; to: classicH; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
        NumberAnimation { target: mainWorkArea; property: "opacity"; to: 1; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
    }

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: mainWorkArea; property: "ListView.delayRemove"; value: true }
        PropertyAction { target: workAreaButtons; property: "visible"; value: false }
        // PropertyAction { target: workAreaMoreBtn; property: "visible"; value: false }
        PropertyAction { target: tasksSList; property: "visible"; value: false }

        ParallelAnimation{
            NumberAnimation { target: mainWorkArea; property: "height"; to: 0; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
            NumberAnimation { target: borderRectangle; property: "height"; to: 0; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
            NumberAnimation { target: borderRectangle; property: "opacity"; to: 0; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
            //NumberAnimation { target: workAreaButtons; property: "opacity"; to: 0; duration: 0; easing.type: Easing.InOutQuad }
            //NumberAnimation { target: workAreaMoreBtn; property: "opacity"; to: 0; duration: 0; easing.type: Easing.InOutQuad }
            NumberAnimation { target: workAreaName; property: "opacity"; to: 0; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
            //NumberAnimation { target: tasksSList; property: "height"; to: 0; duration: 0; easing.type: Easing.InOutQuad }
            //NumberAnimation { target: tasksSList; property: "opacity"; to: 0; duration: 0; easing.type: Easing.InOutQuad }
        }


        // Make sure delayRemove is set back to false so that the item can be destroyed
        PropertyAction { target: mainWorkArea; property: "ListView.delayRemove"; value: false }
    }

    Connections{
        target:keyNavigation
        onActionActivated:{
            if(isSelected){
                if(key==="Pause")
                    workflowManager.activityManager().stop(actCode);
                else
                    clickedWorkarea();
            }
        }
    }

    function getTasksList(){
        return tasksSList;
    }

    function clickedWorkarea(){
        workflowManager.activityManager().setCurrentActivityAndDesktop(mainWorkArea.actCode,mainWorkArea.desktop);
        plasmoidWrapper.workareaWasClicked();
    }

    function getBorderRectangle(){
        return borderRectangle;
    }

    function getWorkAreaName(){
        return workAreaName;
    }

    function showButtons(){
        workAreaButtons.state="show";
        //      workAreaMoreBtn.opacity = 1;
        workareasSignals.calledWorkArea(actCode,desktop);
    }

    function hideButtons(){
        workAreaButtons.state="hide";
        //    workAreaMoreBtn.opacity = 0;
    }

    Connections{
        target:workareasSignals;
        onEnteredWorkArea:{
            if(workList.tCState === workList.neededState){
                if ((actCode !== a1)&&(desktop!== d1))
                    hideButtons();
            }
        }
    }


}//Item

//}//Component




