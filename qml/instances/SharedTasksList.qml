// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../models"
import org.kde.plasma.core 0.1 as PlasmaCore

ListView{
    model: TasksList{}
/*
    PlasmaCore.DataSource {
        id: tasksSource
        engine: "tasks"
        interval: 1000

        onSourceAdded: {
            //if (source != "Status") {
                connectSource(source)
           // }
        }

        Component.onCompleted: {
            connectedSources = sources.filter(function(val) {
                return true;
            })

            allActT.changedChildState();

        }
    }*/


/*
    model: PlasmaCore.DataModel {
      dataSource: tasksSource
    //  keyRoleFilter: ".*"
    }*/

    WorkerScript{
        id:setCurrentDesktopWorker
        property string desktop
        onMessage: taskManager.setCurrentDesktop(desktop);
    }

    WorkerScript{
        id:setCurrentTaskWorker
        property string code
        onMessage: taskManager.activateTask(code);
    }

    function setTaskState(cod, val){
        var ind = getIndexFor(cod);
        var obj = model.get(ind);

        if (val === "oneDesktop"){
            taskManager.setOnAllDesktops(obj.DataEngineSource,false);

            //model.setProperty(ind,"onAllDesktops",false);
           // model.setProperty(ind,"onAllActivities",false);
        }
        else if (val === "allDesktops"){
            taskManager.setOnAllDesktops(obj.DataEngineSource,true);
            //model.setProperty(ind,"onAllDesktops",true);
            //model.setProperty(ind,"onAllActivities",false);
        }
        else if (val === "allActivities"){
            taskManager.setOnAllDesktops(obj.DataEngineSource,true);
            //model.setProperty(ind,"onAllDesktops",true);
            //model.setProperty(ind,"onAllActivities",true);
        }

        allActT.changedChildState();
    }

    function setTaskActivity(cod, val){
        var ind = getIndexFor(cod);
       // model.setProperty(ind,"activities",val);
    }


    function setTaskDesktop(cod, val){
        var ind = getIndexFor(cod);
   //     model.setProperty(ind,"desktop",val);
        var obj = model.get(ind);
        taskManager.setOnDesktop(obj.DataEngineSource,val);
    }

    function setTaskShaded(cod, val){
        var ind = getIndexFor(cod);
     //   model.setProperty(ind,"shaded",val);
    }



    function getIndexFor(cod){

        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            if (obj.code === cod)
               return i;
        }

        return -1;
    }



    function removeTask(cod){
        var ind = getIndexFor(cod);
   //     model.setProperty(ind,"desktop",val);
        var obj = model.get(ind);
        taskManager.closeTask(obj.DataEngineSource);
    }

    function setCurrentDesktop(desk){
        taskManager.setCurrentDesktop(desk);
    }

    function setCurrentTask(cod){
        taskManager.activateTask(cod);
    }

}