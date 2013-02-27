import QtQuick 1.1

import ".."

MouseArea {
    id:container
//    anchors.fill: parent
    hoverEnabled: true

    property Item draggingInterface

    property int px1:0
    property int py1:0
    property bool tempPressed:false
    property int draggingSpace:2

    property bool isPressed:false
    property bool inDragging:isPressed

    signal draggingStarted(variant mouse);
    signal draggingMovement(variant mouse);
    signal draggingEnded(variant mouse);
    signal clickedOverrideSignal(variant mouse);

    property Item previousParent

    onClicked: {
        tempPressed = false;
    }

    onPressed:{
        px1 = mouse.x;
        py1 = mouse.y;

        tempPressed = true;
    }

    onPositionChanged: {
        if(isPressed){
            draggingMovementActions(mouse);
        }

        if(outOfInnerLimits(mouse)&&(tempPressed)){
            previousParent = parent;
            parent = mainDialogItem;
            draggingStarted(mouse);
            tempPressed = false;
            isPressed = true;
        }
    }

    onReleased:{
        if(isPressed){
            draggingEndedActions(mouse);
            isPressed = false;
        }
        else{
            clickedOverrideSignal(mouse);
        }
    }

    function outOfInnerLimits(ms){
        if((ms.x<(px1-draggingSpace))||(ms.x>(px1+draggingSpace))||
                (ms.y<(py1-draggingSpace))||(ms.y>(py1+draggingSpace)))
            return true;
        else
            return false;
    }

    function draggingMovementActions(mouse){
        draggingMovement(mouse)
        if( draggingInterface !== null){
            var nCor = mapToItem(mainDialogItem,mouse.x,mouse.y);
            draggingInterface.onPstChanged(nCor);
        }
    }

    function draggingEndedActions(mouse){
        draggingEnded(mouse);
        parent = previousParent;
        if( draggingInterface !== null ){
            //var nCor = container.mapToItem(mainView,mouse.x,mouse.y);
            draggingInterface.onMReleased(mouse);
        }
    }

}

