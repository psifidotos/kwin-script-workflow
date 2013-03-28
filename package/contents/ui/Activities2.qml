// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.workflow.components 0.1 as WorkFlowComponents
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras
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

    property string version: "0.4.1"

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

    WorkFlowComponents.SessionParameters {
        id: sessionParameters
        objectName:"sessionParameters"
    }

    WorkFlowComponents.PlasmoidWrapper {
        id: plasmoidWrapper

        onIsInPanelChanged:{
            if (!isInPanel && mainLoader.status == Loader.Null)
                mainLoader.source = "views/View1.qml";
        }
    }

    WorkFlowComponents.TaskManager {
        id: taskManager
    }

    WorkFlowComponents.PreviewsManager {
        id: previewManager
    }

    QMLPluginsConnections{}

    //KWin Connections
    KWinConnections{
        id:kwinConnections
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



        Loader{
            id:mainLoader
            anchors.fill:parent
        }

        ZoomSliderItem{
            id:zoomSlider
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            z:10

            onValueChanged: Settings.global.scale = value;

            Component.onCompleted: value = Settings.global.scale;
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
        //windowFlags: Qt.Popup | Qt.X11BypassWindowManagerHint
        windowFlags: Qt.Popup

        //   x: screenX + 1
        //   y: screenY
        x:0
        y:0
        mainItem: mainDialogItem

        //when hidden from lostFocus must update the item state
        onVisibleChanged:{
            if( (!visible) && (mainDialogItem.state !== "hidden") ){
                mainDialogItem.state = "hidden";
            }
            else if ( (visible)&&(!Settings.global.disableEverywherePanel) ){
                //fixes bug not showing some previews when first showing from Everywhere windows
                Settings.global.disableEverywherePanel = true;
                Settings.global.disableEverywherePanel = false;
            }

            if((visible)&&(mainLoader.status == Loader.Null))
                mainLoader.source = "views/View1.qml";
        }
    }

    // toggle complete dashboard
    function toggleBoth() {
        if(mainDialogItem.state === "shown" ){
            //BE CAREFUL, do not change this order because it creates a crash
            //from asynchronous calling two times slotToggleShowDesktops()
            //the second time is onVisibleChange in the dialog
            mainDialogItem.state = "hidden";
            //Disable         workspace.slotToggleShowDesktop();
        } else {
            //Disable         workspace.slotToggleShowDesktop();

            var screen = workspace.clientArea(KWin.ScreenArea, workspace.activeScreen, workspace.currentDesktop);
            mainView.screenWidth = screen.width;
            mainView.screenHeight = screen.height;
            mainView.screenX = screen.x;
            mainView.screenY = screen.y;

            //      dialog.x = screenX+1;
            //     dialog.y = screenY+1;

            // Activate Window and text field
            // it doesnt need to be added
            // dialog.activateWindow();
            // mainView.forceActiveFocus();

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

        /*   registerScreenEdge(KWin.ElectricTopLeft, function () {
            toggleBoth();
        });*/

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

