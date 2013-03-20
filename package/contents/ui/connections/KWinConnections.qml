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
            console.log(client.windowId);
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
        }
    }
}
