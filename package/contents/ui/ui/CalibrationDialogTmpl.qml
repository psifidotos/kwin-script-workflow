// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import ".."
import "../components"
import "../delegates"
import "../../code/settings.js" as Settings

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

DialogTemplate2{
    id:calibDialog

 //   anchors.centerIn: mainView

    insideWidth: 0.7*mainView.width
    insideHeight: 0.6*mainView.height

    isModal: true
    forceModality: false
    showButtons:true
    yesNoButtons:false

    dialogTitle: i18n("Previews Calibration Dialog")


    property int fontsSize: (0.084)*insideHeight

    property string dialogType:"CalibrationDialog"

    Item{
        id:leftColumn
        width:0.4*calibDialog.insideWidth
        height:calibDialog.insideHeight
        x:calibDialog.insideX
        y:calibDialog.insideY

        Text{
            anchors.top : parent.top
            anchors.left: parent.left
            anchors.leftMargin: 10

            font.family: theme.defaultFont.family
            font.bold: true
            font.italic: true

            color:defColor
            width:parent.width - 10

            wrapMode:Text.Wrap
            text:i18n("Step 1: Choose a Window from the following list to show its preview on the side Rectangle...")

        }

        Flickable{
            id: calibrView
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom

            width:0.8*leftColumn.width
            height:0.8*leftColumn.height

            contentWidth: calibsTasksList.width+2
            contentHeight: calibsTasksList.height

            boundsBehavior: Flickable.StopAtBounds
            clip:true


            GridView{
                id:calibsTasksList
                model: taskManager.model()

                x:3
                width: calibrView.width-14
                height: model.count*cellHeight

                cellWidth:width
                cellHeight:0.12*leftColumn.height

                interactive:false

                property int delegHeight:150
                property bool onlyState1: true

                property string prevWin: ""
                property string selectedWin:""

                onSelectedWinChanged: {
                    if (calibsTasksList.prevWin !== "")
                        previewManager.removeWindowPreview(calibsTasksList.prevWin);

                    calibDialog.updatePreview();

                    calibsTasksList.prevWin = calibsTasksList.selectedWin;
                }

                delegate: BasicTaskDeleg{
                    width: calibsTasksList.cellWidth
                    height: calibsTasksList.cellHeight

                    taskTitleTextDef: defColor
                    taskTitleTextHov: defColor
                    taskTitleTextSel: "#afc6ff"

                    selectedWin: calibsTasksList.selectedWin;

                    onTaskClicked:{
                        calibsTasksList.selectedWin = win;
                    }
                }

                Component.onCompleted: {
                    calibsTasksList.selectedWin = model.get(0).code;
                }


            }

            states: State {
                name: "ShowBars"
                when: calibrView.contentHeight > calibrView.height
                PropertyChanges { target: calibsVerticalScrollBar; opacity: 0.8 }
            }

            transitions: Transition {
                NumberAnimation { properties: "opacity"; duration: 2*Settings.global.animationStep }
            }

        }


        Rectangle{
            width:calibrView.width
            height:calibrView.height
            x:calibrView.x
            y:calibrView.y

            border.width: 1
            border.color: "#22f4f4f4"

            color:"#00000000"
        }

/*
        ScrollBar {
            id: calibsVerticalScrollBar
            width: 8; height: calibrView.height
            anchors.top: calibrView.top
            anchors.left: calibrView.right
            opacity: 0
            orientation: Qt.Vertical
            position: calibrView.visibleArea.yPosition
            pageSize: calibrView.visibleArea.heightRatio
        }
*/

        PlasmaComponents.ScrollBar {
            id: calibsVerticalScrollBar
            width: 12
            //height: calibrView.insideHeight
         //   anchors.right: calibrView.right
            opacity: 0
            orientation: Qt.Vertical
            flickableItem: calibrView
        }

        Rectangle{
            width:1
            height:leftColumn.height
            anchors.right: leftColumn.right

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#00f1f1f1" }
                GradientStop { position: 0.2; color: "#aaf1f1f1" }
                GradientStop { position: 0.8; color: "#aaf1f1f1" }
                GradientStop { position: 1.0; color: "#00f1f1f1" }
            }
        }



    }



    Item{
        id:rightColumn
        width:0.6*calibDialog.insideWidth
        height:leftColumn.height
        anchors.top: leftColumn.top
        anchors.left: leftColumn.right

        Item{
            id:rightFArea
            width:parent.width
            height:0.5*parent.height

            Rectangle{
                id:tasksPreviewRect
                width: height
                height: 0.9 * parent.height

                anchors.centerIn: parent

                border.width: 1
                //border.color: "#f5f5f5"
                border.color: defColor
                color:"#33000000"

                Rectangle{
                    width:1
                    height:parent.height
                    anchors.centerIn: parent
                    border.width:parent.border.width
                    border.color: parent.border.color
                }

                Rectangle{
                    height:1
                    width:parent.width
                    anchors.centerIn: parent
                }

                Item{
                    id:hiddenRectangle //for Dragging
                    width:parent.width
                    height:parent.height
                }
                DraggingMouseArea{
                    id:dragArea
                    anchors.fill:parent

                    property int firstX:0
                    property int firstY:0

                    onDraggingStarted:{
                        firstX = mouse.x;
                        firstY = mouse.y;
                    }

                    onDraggingMovement: {
                        //Return Coordinates to local
                        var fixCoord = dragArea.mapToItem(tasksPreviewRect, mouse.x, mouse.y);
                        xOffsetSlider.value =fixCoord.x - firstX;
                        yOffsetSlider.value = fixCoord.y - firstY;
                    }

                    onDraggingEnded: {
                        firstX = 0;
                        firstY = 0;
                        hiddenRectangle.x = 0;
                        hiddenRectangle.y = 0;
                    }

                }
            }
        }

        Item{
            width:parent.width
            height:0.5*parent.height
            anchors.top:rightFArea.bottom

            Text{
                anchors.top : parent.top
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10

                font.family: theme.defaultFont.family
                font.bold: true
                font.italic: true

                color:defColor

                width:parent.width-10

                wrapMode:Text.Wrap
                text:i18n("Step 2: Use the sliders below to move the Preview Window into the center of the above Rectangle...")

            }

            Text{
                id:xValueText

                property int val:0

                text:"X:" +val

                onValChanged:{
                    calibDialog.updatePreview();
                }

                y:fRightRow.y-10

                anchors.horizontalCenter: parent.horizontalCenter

                font.family: theme.defaultFont.family
                font.bold: true
                font.italic: true
                //color: "#f4f4f4"
                color:defColor

            }

            Row{
                id:fRightRow
                anchors.horizontalCenter: parent.horizontalCenter
                y:0.3*parent.height

                spacing:5

                QIconItem{

                    icon: "media-seek-backward"
                    width:xOffsetSlider.height
                    height:width
                    opacity: xValueText.val > xOffsetSlider.minimumValue ? 1 : 0.5

                    MouseArea{
                        id:xMinMouseArea
                        anchors.fill: parent

                        onClicked:{
                            xValueText.val--;
                        }
                    }
                }

                PlasmaCore.ToolTip{
                    mainText: i18n("Reduce X")
                    subText: i18n("Reduce X offset for the window previews.")
                    target: xMinMouseArea
                    image: "media-seek-backward"
                }

                PlasmaComponents.Slider {
                    id:xOffsetSlider

                    maximumValue: 100
                    minimumValue: 0
                    value:0

                    width:0.4*rightColumn.width

                    onValueChanged:{
                        xValueText.val = value;
                    }

                    //For hiding the Warnings in KDe4.8
                    property bool updateValueWhileDragging:true
                    property bool animated:true

                }
                QIconItem{
                    icon: "media-seek-forward"
                    width:xOffsetSlider.height
                    height:width
                    opacity: xValueText.val < xOffsetSlider.maximumValue ? 1 : 0.5

                    MouseArea{
                        id:xAddMouseArea
                        anchors.fill: parent

                        onClicked:{
                            xValueText.val++;
                        }
                    }

                }

                PlasmaCore.ToolTip{
                    mainText: i18n("Increase X")
                    subText: i18n("Increase X offset for the window previews.")
                    target: xAddMouseArea
                    image: "media-seek-forward"
                }

            }

            Text{
                id:yValueText

                property int val:0

                text:"Y:" +val

                onValChanged:{
                    calibDialog.updatePreview();
                }

                y:sRightRow.y-10
                anchors.horizontalCenter: parent.horizontalCenter

                font.bold: true
                font.italic: true
                color:defColor
            }

            Row{
                id:sRightRow
                anchors.horizontalCenter: parent.horizontalCenter
                y:0.5*parent.height

                spacing:5

                QIconItem{
                    icon: "media-seek-backward"
                    width:yOffsetSlider.height
                    height:width

                    opacity: yValueText.val > yOffsetSlider.minimumValue ? 1 : 0.5

                    MouseArea{
                        id:yMinMouseArea
                        anchors.fill: parent

                        onClicked:{
                            yValueText.val--;
                        }
                    }

                }

                PlasmaCore.ToolTip{
                    mainText: i18n("Reduce Y")
                    subText: i18n("Reduce Y offset for the window previews.")
                    target: yMinMouseArea
                    image: "media-seek-backward"
                }

                PlasmaComponents.Slider {
                    id:yOffsetSlider

                    maximumValue: 100
                    minimumValue: 0
                    value:0

                    width:0.4*rightColumn.width

                    onValueChanged:{
                        yValueText.val = value;
                    }

                    //For hiding the Warnings in KDe4.8
                    property bool updateValueWhileDragging:true
                    property bool animated:true

                }

                QIconItem{
                    icon: "media-seek-forward"
                    width:yOffsetSlider.height
                    height:width

                    opacity: yValueText.val < yOffsetSlider.maximumValue ? 1 : 0.5

                    MouseArea{
                        id:yAddMouseArea
                        anchors.fill: parent

                        onClicked:{
                            yValueText.val++;
                        }
                    }
                }

                PlasmaCore.ToolTip{
                    mainText: i18n("Increase Y")
                    subText: i18n("Increase Y offset for the window previews.")
                    target: yAddMouseArea
                    image: "media-seek-forward"
                }

            }

            Text{
                anchors.top : sRightRow.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10

                font.family: theme.defaultFont.family
                font.bold: true
                font.italic: true

                color:defColor

                width:parent.width-10

                wrapMode:Text.Wrap
                text:i18n("Step 3: Press Ok for confirmation...")

            }

        }
    }

    PlasmaComponents.Button{
        id:nextWIdButton
        anchors.right: rightColumn.right
        anchors.top: rightColumn.top
        anchors.topMargin:5
        anchors.rightMargin: 5
        iconSource: "view-refresh"
        visible:plasmoidWrapper.isInPanel
        onClicked:{
            previewManager.removeWindowPreview(calibsTasksList.selectedWin);
            plasmoidWrapper.nextWId();
            updatePreview();
            widPosition.text = plasmoidWrapper.currentWIdPosition();
        }
    }

    PlasmaCore.ToolTip{
        mainText: i18n("Refresh Window Previews")
        subText: i18n("Refresh Window Previews until you see one.")
        target: nextWIdButton
        image: "view-refresh"
    }

    PlasmaComponents.Label{
        id: widPosition
        anchors.right: nextWIdButton.left
        anchors.rightMargin:5
        anchors.top: nextWIdButton.top
        opacity:0.5
        visible:plasmoidWrapper.isInPanel
    }

    function getTasksList(){
        return calibsTasksList
    }


    function setSelectedWindow(wid){
        calibsTasksList.selectedWin = wid;
    }

    function openD(){
        calibrationDialog.open();

        xOffsetSlider.value = Settings.global.windowPreviewsOffsetX;
        yOffsetSlider.value = Settings.global.windowPreviewsOffsetY;

        allWorkareas.flickableV = false;
        allActT.forceState1();

        if (calibsTasksList.model.count>0){
            var obj = calibsTasksList.model.get(0);
            setSelectedWindow(obj.code);
        }

        widPosition.text = plasmoidWrapper.currentWIdPosition();
    }

    function updatePreview(){
        if (calibsTasksList.selectedWin !== ""){

            var x1 = 0;
            var y1 = 0;
            var obj = tasksPreviewRect.mapToItem(mainView,x1,y1);

            previewManager.setWindowPreview(calibsTasksList.selectedWin,
                                         obj.x+xValueText.val,
                                         obj.y+yValueText.val,
                                         tasksPreviewRect.width-(2*tasksPreviewRect.border.width),
                                         tasksPreviewRect.height-(2*tasksPreviewRect.border.width));
        }
    }

    Connections {
        target: calibDialog
        onClickedOk:{
            Settings.global.windowPreviewsOffsetX = xValueText.val;
            Settings.global.windowPreviewsOffsetY = yValueText.val
            calibDialog.clickedCancel();

            completed();
        }

        onClickedCancel:{

            calibsTasksList.selectedWin = "";
            allWorkareas.flickableV = true;
            allActT.unForceState1();

            completed();
        }
    }

}
