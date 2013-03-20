import QtQuick 1.1

Item{
    Component.onCompleted: {
        // add new clients to model
        var clients = workspace.clientList();

        for (var i = 0; i < clients.length; i++) {
            clientAddedSlot(clients[i]);
        }

    }

    Connections{
        target:workspace
        onClientAdded:{
            clientAddedSlot(client);
        }

        onClientRemoved:{
            taskManager.windowRemovedSlot(client.windowId);
        }
    }

    function clientAddedSlot(client){
        var added = taskManager.windowAddedSlot(client.windowId);

        if(added){
            client.desktopChanged.connect(
                        function(){
                            taskManager.windowChangedSlot(client.windowId);
                        }
                        )
            client.captionChanged.connect(
                        function(){
                            taskManager.windowChangedSlot(client.windowId);
                        }
                        )
        }
    }

    function closeWindow(winId){
        var client = workspace.getClient(winId);

        if(client !== null){
            client.closeWindow();
        }
    }
}
