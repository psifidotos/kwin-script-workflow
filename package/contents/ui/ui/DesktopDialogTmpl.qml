// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import ".."
import "../delegates"
import "../../code/settings.js" as Settings

import org.kde.workflow.components 0.1 as WorkFlowComponents
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

DialogTemplate2{
    id:deskDialog

    property string dialogType:"DesktopDialog"

    property string activityCode:""
    property int desktop:-1

    insideWidth: columns*cWidth
    insideHeight: (shownRows)*cHeight

    isModal: true
    forceModality: false
    showButtons:false

    property int shownRows:0
    property int realRows:0
    property int columns:0

    property int cWidth: 0
    property int cHeight: 0

    //This is used to track user preference on show/hide previews in the dialog
    property bool disablePreviewsWasForced:false
    property bool disablePreviews :false


    Connections{
        target: taskModel
        onCountChanged: deskDialog.initInterface();
    }


    Image{
        id:disablePreviewsBtn
        smooth:true
        source:"../Images/buttons/tools_wizard.png"
        width:15
        height:width
        x:deskDialog.spaceX + 15
        y:deskDialog.spaceY - 22

        opacity:disablePreviews === true ? 0.65 : 1

        visible: Settings.global.windowPreviews

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                hoveredIcon.opacity = 1;
            }

            onExited: {
                hoveredIcon.opacity = 0;
            }
            onClicked: {
                deskDialog.disablePreviewsWasForced = !deskDialog.disablePreviewsWasForced
                deskDialog.disablePreviews = !deskDialog.disablePreviews

                if (deskDialog.disablePreviews===true)
                    desktopView.forceState1();
                else
                    desktopView.unForceState1();

                initInterface();
            }
        }
    }

    Rectangle{
        id:hoveredIcon
        opacity:0

        y:disablePreviewsBtn.y+disablePreviewsBtn.height+1
        x:disablePreviewsBtn.x - height/4

        width:2
        height:2*disablePreviewsBtn.width

        rotation: -90
        transformOrigin: Item.TopLeft

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#00f1f1f1" }
            GradientStop { position: 0.2; color: "#aaf1f1f1" }
            GradientStop { position: 0.8; color: "#aaf1f1f1" }
            GradientStop { position: 1.0; color: "#00f1f1f1" }

        }
    }

    Flickable{
        id: desktopView

        x:deskDialog.insideX
        y:deskDialog.insideY

        width:insideWidth
        height:(shownRows)*cHeight+10

        contentWidth: desksTasksList.width-40
        contentHeight: desksTasksList.height

        boundsBehavior: Flickable.StopAtBounds
        //fixes appearance for just one window
        clip:(desksTasksList.model.count > 1)

        Row{
            //width:parent.width
            //height:parent.height
            Repeater{
                model:deskDialog.columns-1
                delegate:Item{
                    width:deskDialog.cWidth-7
                    height:deskDialog.shownRows*deskDialog.cHeight
                    Rectangle{
                        width:1
                        height:parent.height
                        anchors.right: parent.right

                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#00f1f1f1" }
                            GradientStop { position: 0.2; color: "#aaf1f1f1" }
                            GradientStop { position: 0.8; color: "#aaf1f1f1" }
                            GradientStop { position: 1.0; color: "#00f1f1f1" }

                        }
                    }
                }
            }
        }

        WorkFlowComponents.FilterTaskModel{
            id:taskModel
            sourceMainModel: filteredTasksModel
            activity:activityCode
            desktop:deskDialog.desktop
            everywhereState: Settings.global.disableEverywherePanel
            clear:false
        }

        GridView{
            id:desksTasksList

            model:taskModel

            width: columns*cellWidth
            height: realRows*cellHeight

            cellWidth:deskDialog.cWidth
            cellHeight:deskDialog.cHeight

            interactive:false

            property int delegHeight:150


            //property bool onlyState1: false
            property bool onlyState1: deskDialog.disablePreviews
            property string selectedWin:""

            property alias desktopInd: deskDialog.desktop

            delegate: ScrolledTaskPreviewDeleg{
                showOnlyAllActivities: false

                rWidth: desksTasksList.cellWidth-9
                rHeight: desksTasksList.cellHeight

                defWidth: 0.7*mainView.scaleMeter

                defPreviewWidth: 0.7*desksTasksList.cellHeight
                defHovPreviewWidth: 1.3*defPreviewWidth

                taskTitleTextDef: defColor
                taskTitleTextHov: defColor

                dialogActivity: deskDialog.activityCode
                dialogDesktop: deskDialog.desktop

                scrollingView: desktopView
                centralListView: desksTasksList
            }
        }

        function forceState1(){
            if(deskDialog.disablePreviews === false){
                deskDialog.disablePreviews = true;
           //     deskDialog.disablePreviewsWasForced = true;
            }
            else{
                deskDialog.disablePreviewsWasForced = false;
            }
        }

        function unForceState1(){
            if(deskDialog.disablePreviewsWasForced === true){
                deskDialog.disablePreviews = false;
            }
        }

        states: State {
            name: "ShowBars"
            when: desktopView.contentHeight > desktopView.height
            PropertyChanges { target: desktopVerticalScrollBar; opacity: 0.7 }
        }

        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 2*Settings.global.animationStep }
        }
    }
/*
    ScrollBar {
        id: desktopVerticalScrollBar
        width: 9; height: desktopView.height
        anchors.top: desktopView.top
        anchors.left: desktopView.right
        opacity: 0
        orientation: Qt.Vertical
        position: desktopView.visibleArea.yPosition
        pageSize: desktopView.visibleArea.heightRatio
    }*/

    PlasmaComponents.ScrollBar {
        id: desktopVerticalScrollBar
        width: 12;
      //  height: desktopView.insideHeight
        anchors.right: desktopView.right
        opacity: 0
        orientation: Qt.Vertical
        flickableItem: desktopView
    }

    function initInterface(){
        var counter = desksTasksList.model.count
        var w=mainView.width
        var h=mainView.height

        if (counter === 0){
            deskDialog.close();
        }
        else{
            //Count the rows and columns//
            //Count the cellWidth and cellHeight//
            if ( (Settings.global.windowPreviews === false) ||
                    (deskDialog.disablePreviews===true) ){
                if (counter<=5){
                    deskDialog.shownRows=counter;
                    deskDialog.realRows=counter;
                    deskDialog.columns=1;
                }
                else{
                    deskDialog.realRows=Math.floor( (counter+1)/2 );
                    deskDialog.shownRows=Math.min(deskDialog.realRows,5);
                    deskDialog.columns = 2;
                }

                if (deskDialog.columns === 1){
                    deskDialog.cWidth = 0.6 * w;
                    deskDialog.cHeight = 0.08 * h;
                }
                else{
                    deskDialog.cWidth = 0.33 * w;
                    deskDialog.cHeight = 0.08 * h;
                }

            }
            else{
                deskDialog.columns = Math.min(Math.floor( (counter+1)/2 ), 3);
                if (deskDialog.columns > 1)
                    deskDialog.shownRows = Math.min(Math.floor( (counter+1)/deskDialog.columns),3);
                else
                    deskDialog.shownRows = Math.min(counter,3);

                if (counter === 7)
                    deskDialog.shownRows = 3

                if (counter>9)
                    deskDialog.realRows = Math.floor( (counter+2)/3 );
                else
                    deskDialog.realRows = deskDialog.shownRows


                if(deskDialog.columns === 1){
                    if(counter !== 1)
                        deskDialog.cWidth = 0.5 * w;
                    else//fixes appearance with just one window
                        deskDialog.cWidth = Math.min(0.7 * w, 0.6 * h);

                }
                else if(deskDialog.columns === 2){
                    deskDialog.cWidth = 0.4 * w;
                }
                else if(deskDialog.columns === 3){
                    deskDialog.cWidth = 0.3 * w;
                }

                if(deskDialog.shownRows === 1){
                    //deskDialog.cHeight = 4*mainView.scaleMeter
                    deskDialog.cHeight = 0.45*h;
                }
                else if(deskDialog.shownRows === 2){
                    deskDialog.cHeight = 0.27*h;
                }
                else if(deskDialog.shownRows === 3){
                    deskDialog.cHeight = 0.27*h;
                }
            }
        }

    }

    function closeD(){
        taskModel.clear = true;
        allWorkareas.flickableV = true;
        emptyDialog();
        allActT.unForceState1();
        deskDialog.close();
    }

    function emptyDialog(){

        disablePreviews = true;

        activityCode = "";
        desktop = -1;
    }

    function openD(act,desk){
        taskModel.clear = false;
        activityCode = act;
        desktop = desk;

        deskDialog.dialogTitle = workflowManager.activityManager().name(act) + " - "+
                workflowManager.workareaManager().name(act,desk);

        initInterface();
/*
        if (deskDialog.disablePreviews===true)
            desktopView.forceState1();
        else
            desktopView.unForceState1();*/

        deskDialog.open();
        allWorkareas.flickableV = false;

        allActT.forceState1();

    }


    function getDeskView(){
        return desktopView;
    }

    function getTasksList(){
        return desksTasksList;
    }

   /* function clearList(){
        activityCode = "";
        desktop = -1;
    }*/

    Connections {
        target: deskDialog
        onClickedOk:{
            completed();
        }

        onClickedCancel:{
            deskDialog.emptyDialog();
            deskDialog.closeD();
            completed();
        }
    }
}
