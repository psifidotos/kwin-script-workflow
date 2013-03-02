// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.workflow.components 0.1 as WorkFlowComponents
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1
import org.kde.kwin 0.1;

import "delegates"
import "delegates/ui-elements"
import "helptour"
import "connections"
import "components"
import "interfaces"

import "ui"

import "DynamicAnimations.js" as DynamAnim

import "../code/settings.js" as Settings

Item {
    id:mainView
    objectName: "instMainView"

    property int screenWidth: 0
    property int screenHeight: 0
    property int screenX: 0
    property int screenY: 0

    width: screenWidth-paddingWidth
    height: screenHeight

    property int paddingWidth: 0

    Settings {
        id: settings
        setAsGlobal: true
    }

    anchors.fill: parent

    property int scaleMeter: zoomSlider.value
    property real zoomingHeightFactor: ((zoomSlider.value-zoomSlider.minimumValue)/(zoomSlider.maximumValue-zoomSlider.minimumValue))*0.6
    property int workareaWidth: 70+(2.8*mainView.scaleMeter) + (mainView.scaleMeter-5)/3;
    property int workareaHeight:(3.6 - zoomingHeightFactor)*scaleMeter
    property int workareaY:2*scaleMeter

    //Applications properties/////
    property bool disablePreviewsWasForcedInDesktopDialog:false //as a reference to DesktopDialog because it is dynamic from now one

    property QtObject mainClient

    WorkFlowComponents.SessionParameters {
        id: sessionParameters
        objectName:"sessionParameters"
    }

    WorkFlowComponents.WorkflowManager {
        id: workflowManager
    }

    WorkFlowComponents.TaskManager {
        id: taskManager
    }

    WorkFlowComponents.PreviewsManager {
        id: previewManager
    }

    QMLPluginsConnections{}

    //This a temporary solution to fix the issue with filtering windows
    //in empty fitter text in many cases windows are not shown correctly
    //so i reset the filter text to something not found and then again
    //to show all windows
    Connections{
        target:filterWindows
        onTextChanged:{
            //console.log(filterWindows.text);
            if(filterWindows.text === ""){
                filteredTasksModel.fixBugString = "'''";
                timerBug.start();
            }
        }
    }

    Timer {
        id:timerBug
        interval: 50; running: false; repeat: false
        onTriggered: filteredTasksModel.fixBugString = "";
    }

    ///end fix of bug

    PlasmaCore.SortFilterModel {
        id:filteredTasksModel
        filterRole: "name"
        filterRegExp:".*" + mergedString + ".*"
        sourceModel: taskManager.model()

        //for fix of bug
        property string mergedString: filterWindows.text.toLowerCase() + fixBugString
        property string fixBugString: ""
        //end of fix
    }

    PlasmaCore.SortFilterModel {
        id:stoppedActivitiesModel
        filterRole: "CState"
        filterRegExp: "Stopped"
        sourceModel: workflowManager.model()
    }

    PlasmaCore.SortFilterModel {
        id:runningActivitiesModel
        filterRole: "CState"
        filterRegExp: "Running"
        sourceModel: workflowManager.model()
    }

    /*Main Interface */
    Item{
        id:mainDialogItem
        width: mainView.width
        height: mainView.height
        state: "hidden"
        opacity: 0
     //   opacity: 1

     //   property alias opacityG: mainDialogItem.opacity


   /*     onOpacityGChanged: {
            //mainDialogItem.opacity = opacityG;
           // if(opacityG>0)
           //     workspace.slotToggleShowDesktop();
        }*/

        states:[
            State {
                name:"hidden"
            },
            State {
                name:"shown"
            }
        ]

        transitions: [
            Transition {
                from:"hidden"; to:"shown"
                reversible: false
                SequentialAnimation{
                    PropertyAnimation { target: dialog; property: "visible"; duration:0; from:0; to:1}
                    NumberAnimation {
                        target: mainDialogItem
                        property:"opacity"
                        duration: Settings.global.animationStep;
                        easing.type: Easing.InOutQuad;
                        from:0;
                        to:1;
                    }
                }
            },
            Transition {
                from:"shown"; to:"hidden"
                reversible: false
                SequentialAnimation{
                    NumberAnimation {
                        target: mainDialogItem
                        property:"opacity"
                        duration: Settings.global.animationStep;
                        easing.type: Easing.InOutQuad;
                        from:1;
                        to:0;
                    }
                    PropertyAnimation { target: dialog; property: "visible"; duration:0; from:1; to:0}
                }
            }
        ]

        Item{
            id:centralArea
            anchors.fill: parent

            property string typeId: "centralArea"

            WorkAreasAllLists{
                id: allWorkareas

                y:oxygenT.height
                width:(mAddActivityBtn.showRedCross) ? mainDialogItem.width-mAddActivityBtn.width : mainDialogItem.width
                height:mainView.height - y
                verticalScrollBarLocation: stoppedPanel.x
                clip:true

                workareaWidth: mainView.workareaWidth
                workareaHeight: mainView.workareaHeight
                scale: mainView.scaleMeter
                animationsStep: Settings.global.animationStep
                /*  Rectangle{ //Debug Rectangle
                    opacity:0.3
                    color:"blue"
                    z:100
                    anchors.fill: parent
                }*/
            }

            StoppedActivitiesPanel{
                id:stoppedPanel
            }

            MainAddActivityButton{
                id: mAddActivityBtn
            }

            AllActivitiesTasks{
                id:allActT
            }

            ZoomSliderItem{
                id:zoomSlider
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 7
                anchors.right: parent.right
                anchors.rightMargin: 7

                onValueChanged: Settings.global.scale = value;

                Component.onCompleted: value = Settings.global.scale;
            }

            TitleMainView{
                id:oxygenT
            }
        }

        FilterWindows{
            id:filterWindows
            width:Math.max(0.3*parent.width,250)
        }

        DraggingInterfaceTasks{
            id:mDragInt
        }

        DraggingInterfaceActivities{
            id:draggingActivities
        }

        KeyNavigation{
            id:keyNavigation
        }

        UIConnections{
            id:uiConnect
        }

        MouseEventListener {
            id:zoomAreaListener
            anchors.fill:parent
            z:keyNavigation.ctrlActive ? 40 : -1
            //enabled: keyNavigation.ctrlActive
            visible: keyNavigation.ctrlActive

            onWheelMoved:{
                if(wheel.delta < 0)
                    zoomSlider.value=zoomSlider.value-2;
                else
                    zoomSlider.value=zoomSlider.value+2;
            }
        }
    }

    Keys.forwardTo: [keyNavigation]

    /*End of Main Interface */
    PlasmaCore.Dialog {
        id: dialog
        visible: false
        windowFlags: Qt.Popup | Qt.X11BypassWindowManagerHint

        x: screenX + 1
        y: screenY
        mainItem: mainDialogItem

        onVisibleChanged: {
         //   if (visible)
                workspace.slotToggleShowDesktop();
        }
    }

    // toggle complete dashboard
    function toggleBoth() {
        //if(dialog.visible === true) {
        if(mainDialogItem.state === "shown" ){
            mainDialogItem.state = "hidden";
           // dialog.visible = false;
        } else {
            var screen = workspace.clientArea(KWin.ScreenArea, workspace.activeScreen, workspace.currentDesktop);
            mainView.screenWidth = screen.width;
            mainView.screenHeight = screen.height;
            mainView.screenX = screen.x;
            mainView.screenY = screen.y;

            //      dialog.x = screenX+1;
            //     dialog.y = screenY+1;

            // Activate Window and text field
            dialog.activateWindow();
            mainView.forceActiveFocus();
           // dialog.visible = true;
            mainDialogItem.state = "shown";
        }

    }

    Component.onCompleted:{
        DynamAnim.createComponents();

        if(Settings.global.firstRunLiveTour === false)
            getDynLib().showFirstHelpTourDialog();

        var screen = workspace.clientArea(KWin.ScreenArea, workspace.activeScreen, workspace.currentDesktop);
        mainView.screenWidth = screen.width;
        mainView.screenHeight = screen.height;
        mainView.screenX = screen.x;
        mainView.screenY = screen.y;

        /*Set client for the dialog*/
        mainClient = workspace.getClient(dialog.windowId);
        /*****************/


        registerScreenEdge(KWin.ElectricTopLeft, function () {
            toggleBoth();
        });

        // register dashboard shortcut
        registerShortcut("WorkFlow: KWin Script", "", "Meta+Ctrl+Z", function() {
            toggleBoth();
        });
    }


    function getDynLib(){
        return DynamAnim;
    }

    /*---------- Central Controllers For Signals **********/

    Item{
        id:workareasSignals
        signal enteredWorkArea(string a1,int d1);

        property string act1: ""
        property string desk1: ""

        function calledWorkArea(a1, d1){
            if ((act1 !== a1) || (d1 !== desk1)){
                act1 = a1;
                desk1 = d1;
                enteredWorkArea(a1, d1);
            }
        }
    }

    Item{
        id:activitiesSignals
        signal showButtons
        signal hideButtons

        Timer{
            id:activitiesTimer
            interval:200+Settings.global.animationStep
            repeat:false
            onTriggered: {
                activitiesSignals.hideButtons();
            }
        }

        function showActivitiesButtons(){
            showButtons();
            activitiesTimer.start();
        }
    }

    // CalibrationDialogTmpl{}
    //      TourDialog{
    //  }

    Connections {
        target: options
        onConfigChanged: Settings.global.configChanged();
    }


}

