// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import ".."
import "../delegates"

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

DialogTemplate{
    id:calibDialog

    anchors.centerIn: mainView

    insideWidth: 0.7*mainView.width
    insideHeight: 0.6*mainView.height

    isModal: true
    showButtons:true

    dialogTitle: i18n("Previews Calibration Dialog")

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

            font.family: mainView.defaultFont.family
            font.bold: true
            font.italic: true
            color: "#f4f4f4"
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
                model:instanceOfTasksList.model

                x:3
                width: calibrView.width-2
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
                        taskManager.removeWindowPreview(calibsTasksList.prevWin);

                    calibDialog.updatePreview();

                    calibsTasksList.prevWin = calibsTasksList.selectedWin;
                }

                delegate: TaskPreviewDeleg{
                    showAllActivities: false

                    rWidth: calibsTasksList.cellWidth
                    rHeight: calibsTasksList.cellHeight

                    defWidth: 0.7*mainView.scaleMeter

                    defPreviewWidth: 0.8*calibsTasksList.cellHeight
                    defHovPreviewWidth: 1.4*defPreviewWidth

                    taskTitleTextDef: "#ffffff"
                    taskTitleTextHov: "#ffffff"

                    scrollingView: calibrView
                    centralListView: calibsTasksList
                }


            }

            states: State {
                name: "ShowBars"
                when: calibrView.contentHeight > calibrView.height
                PropertyChanges { target: calibsVerticalScrollBar; opacity: 1 }
            }
            /*
            transitions: Transition {
                NumberAnimation { properties: "opacity"; duration: 2*mainView.animationsStep }
            }*/

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


        PlasmaComponents.ScrollBar {
            id: calibsVerticalScrollBar
            width: 8
            //height: calibrView.insideHeight
            anchors.right: calibrView.right
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
                width:0.5 * parent.width
                height: width

                anchors.centerIn: parent

                border.width: 1
                border.color: "#f5f5f5"
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

                font.family: mainView.defaultFont.family
                font.bold: true
                font.italic: true
                color: "#f4f4f4"

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

                anchors.bottom: fRightRow.top
                anchors.horizontalCenter: parent.horizontalCenter

                font.family: mainView.defaultFont.family
                font.bold: true
                font.italic: true
                color: "#f4f4f4"

            }

            Row{
                id:fRightRow
                anchors.horizontalCenter: parent.horizontalCenter
                y:0.3*parent.height

                spacing:5

                QIconItem{

                    icon:"zoom-out"
                    width:xOffsetSlider.height
                    height:width
                    opacity: xValueText.val > xOffsetSlider.minimumValue ? 1 : 0.5

                    MouseArea{
                        anchors.fill: parent

                        onClicked:{
                            xValueText.val--;
                        }
                    }
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
                    icon:"zoom-in"
                    width:xOffsetSlider.height
                    height:width
                    opacity: xValueText.val < xOffsetSlider.maximumValue ? 1 : 0.5

                    MouseArea{
                        anchors.fill: parent

                        onClicked:{
                            xValueText.val++;
                        }
                    }

                }

            }

            Text{
                id:yValueText

                property int val:0

                text:"Y:" +val

                onValChanged:{
                    calibDialog.updatePreview();
                }

                anchors.bottom: sRightRow.top
                anchors.horizontalCenter: parent.horizontalCenter

                font.bold: true
                font.italic: true
                font.family: mainView.defaultFont.family
                color: "#f4f4f4"

            }

            Row{
                id:sRightRow
                anchors.horizontalCenter: parent.horizontalCenter
                y:0.5*parent.height

                spacing:5

                QIconItem{
                    icon:"zoom-out"
                    width:yOffsetSlider.height
                    height:width

                    opacity: yValueText.val > yOffsetSlider.minimumValue ? 1 : 0.5

                    MouseArea{
                        anchors.fill: parent

                        onClicked:{
                            yValueText.val--;
                        }
                    }

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
                    icon:"zoom-in"
                    width:yOffsetSlider.height
                    height:width

                    opacity: yValueText.val < yOffsetSlider.maximumValue ? 1 : 0.5

                    MouseArea{
                        anchors.fill: parent

                        onClicked:{
                            yValueText.val++;
                        }
                    }
                }

            }

            Text{
                anchors.top : sRightRow.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10

                font.family: mainView.defaultFont.family
                font.bold: true
                font.italic: true
                color: "#f4f4f4"

                width:parent.width-10

                wrapMode:Text.Wrap
                text:i18n("Step 3: Press Ok for confirmation...")

            }

        }
    }

    function getTasksList(){
        return calibsTasksList
    }


    function setSelectedWindow(wid){
        calibsTasksList.selectedWin = wid;
    }

    function openD(){
        calibrationDialog.open();

        xOffsetSlider.value = mainView.previewsOffsetX;
        yOffsetSlider.value = mainView.previewsOffsetY;

        allWorkareas.flickableV = false;
        allActT.forceState1();

        if (calibsTasksList.model.count>0){
            var obj = calibsTasksList.model.get(0);
            calibsTasksList.selectedWin = obj.code;
        }
    }

    function updatePreview(){
        if (calibsTasksList.selectedWin !== ""){
            var x1 = 0;
            var y1 = 0;
            var obj = tasksPreviewRect.mapToItem(mainView,x1,y1);

            taskManager.setWindowPreview(calibsTasksList.selectedWin,
                                         obj.x+xValueText.val,
                                         obj.y+yValueText.val,
                                         tasksPreviewRect.width-(2*tasksPreviewRect.border.width),
                                         tasksPreviewRect.height-(2*tasksPreviewRect.border.width));
        }
    }

    Connections {
        target: calibDialog
        onClickedOk:{
            mainView.previewsOffsetX = xOffsetSlider.value;
            mainView.previewsOffsetY = yOffsetSlider.value;
            calibDialog.clickedCancel();
        }

        onClickedCancel:{

            calibsTasksList.selectedWin = "";
            allWorkareas.flickableV = true;
            allActT.unForceState1();

            //instanceOfTasksDesktopList.emptyList();
            //allActT.unForceState1();
            ///
        }
    }

}
