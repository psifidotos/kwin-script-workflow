// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../models"
import org.kde.plasma.core 0.1 as PlasmaCore

ListView{
    model: TasksList{}

    function printModel(){
        console.debug("---- Tasks Model -----");
        for(var i=0; i<model.count; i++){
            var obj = model.get(i);
            console.debug(obj.code + " - " + obj.name + " - " +obj.Icon + " - " +obj.desktop + " - " +obj.activities);
        }
        console.debug("----  -----");
    }

    function setTaskState(cod, val){
        var ind = getIndexFor(cod);
        if(ind>-1){
            var obj = model.get(ind);

            var fActivity;

            if ((obj.activities === undefined)||
                    (obj.activities === ""))
                fActivity = mainView.currentActivity;
            else
                fActivity = obj.activities;

            console.debug("setTaskState:"+cod+"-"+val);
            if (val === "oneDesktop"){
                if ((obj.desktop === undefined) ||
                        (obj.desktop < 1))
                    setTaskDesktop(cod,mainView.currentDesktop)

                model.setProperty(ind,"onAllDesktops",false);
                model.setProperty(ind,"onAllActivities",false);

                taskManager.setOnlyOnActivity(obj.code,fActivity);
                taskManager.setOnAllDesktops(obj.code,false);
            }
            else if (val === "allDesktops"){
                model.setProperty(ind,"onAllDesktops",true);
                model.setProperty(ind,"onAllActivities",false);

                taskManager.setOnAllDesktops(obj.code,true);
                taskManager.setOnlyOnActivity(obj.code,fActivity);
            }
            else if (val === "allActivities"){
                model.setProperty(ind,"onAllDesktops",true);
                model.setProperty(ind,"onAllActivities",true);

                taskManager.setOnAllActivities(obj.code);
                taskManager.setOnAllDesktops(obj.code,true);
            }

            allActT.changedChildState();
        }
    }

    function setTaskActivity(cod, val){
        var ind = getIndexFor(cod);
        model.setProperty(ind,"activities",val);
        taskManager.setOnlyOnActivity(cod,val);
    }


    function setTaskDesktop(cod, val){
        var ind = getIndexFor(cod);
        var obj = model.get(ind);
        model.setProperty(ind,"desktop",val);

        taskManager.setOnDesktop(obj.code,val);
    }

    function setTaskInDragging(cod, val){
        var ind = getIndexFor(cod);
        model.setProperty(ind,"inDragging",val);
    }


    function getIndexFor(cod){
        for(var i=0; i<model.count; i++){
            var obj = model.get(i);
            if (obj.code === cod)
                return i;
        }
        return -1;
    }


    function taskAddedIn(source,onalld,onalla,classc,nam, icn, indrag, desk, activit)
    {
        var fact;
        if (activit === undefined)
            fact=mainView.currentActivity;
        else
            fact=activit[0];

        model.append( {  "code": source,
                         "onAllDesktops":onalld,
                         "onAllActivities":onalla,
                         "classClass":classc,
                         "name":nam,
                         "Icon":icn,
                         "inDragging":indrag,
                         "desktop":desk,
                         "activities":fact} );

        allActT.changedChildState();
    }

    function taskRemovedIn(cod){
        var ind = getIndexFor(cod);
        if (ind>-1){
            //    printModel();
            model.remove(ind);  //Be Careful there is a bug when removing the first element (0), it crashed KDE
        }
    }

    function taskUpdatedIn(source,onalld,onalla,classc,nam, icn, desk, activit,mtype)
    {
        var fact;
        if (activit === undefined)
            fact="";
        else
            fact=activit[0];

        var ind = getIndexFor(source);
        if (ind>-1){
            if (mtype==="everything"){
                model.setProperty(ind,"onAllDesktops",onalld);
                model.setProperty(ind,"onAllActivities",onalla);
                model.setProperty(ind,"classClass",classc);
                model.setProperty(ind,"name",nam);
                model.setProperty(ind,"Icon",icn);
                model.setProperty(ind,"desktop",desk);
                model.setProperty(ind,"activities",fact);
            }
            else if(mtype ==="desktop" ){
                model.setProperty(ind,"onAllDesktops",onalld);
                model.setProperty(ind,"desktop",desk);
            }
            else if(mtype ==="activities" ){
                model.setProperty(ind,"onAllActivities",onalla);
                model.setProperty(ind,"activities",fact);
            }
            else if(mtype ==="name" ){
                model.setProperty(ind,"name",nam);
            }
            else if(mtype ==="icon" ){
                model.setProperty(ind,"Icon",icn);
            }

        }

        allActT.changedChildState();
    }


    function removeTask(cod){
        taskRemovedIn(cod);
        taskManager.closeTask(cod);
    }

    function setCurrentDesktop(desk){
        taskManager.setCurrentDesktop(desk);
        // mainView.currentDesktop = desk;
    }

    function currentDesktopChanged(v){
        mainView.currentDesktop = v;
    }

    function setMaxDesktops(v){
        mainView.maxDesktops = v;
    }

    function setCurrentTask(cod){
        taskManager.activateTask(cod);
        workflowManager.hidePopupDialog();
    }

    //in order to change to right workarea when a window is inAllDesktops
    function setCurrentTaskInWorkarea(activ,desk,cod)
    {
        instanceOfActivitiesList.setCurrentActivityAndDesktop(activ,desk);
        setCurrentTask(cod);
    }

}
