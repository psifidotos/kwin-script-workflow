// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../../code/settings.js" as Settings

Item{
    id: container

    property alias dialogType: task.dialogType
    property alias showOnlyAllActivities: task.showOnlyAllActivities

    property alias rWidth: task.rWidth
    property alias rHeight: task.rHeight
    property alias defWidth: task.defWidth

    property alias defPreviewWidth : task.defPreviewWidth
    property alias defHovPreviewWidth : task.defHovPreviewWidth

    property alias taskTitleTextDef: task.taskTitleTextDef
    property alias taskTitleTextHov: task.taskTitleTextHov

    property alias scrollingView: task.scrollingView
    property alias centralListView: task.centralListView

    width: task.width
    height: task.height

    Rectangle{
        id:taskHoverRectFrame
        width:task.width-2*border.width
        height:task.height
        radius:5
        color:"#30ffffff"
        border.width: 1
        border.color: "#aaffffff"

    }

    TaskPreviewDeleg{
        id:task

        ccode: code
        cActCode: ((activities === undefined) || (activities[0] === undefined) ) ?
                        sessionParameters.currentActivity : activities[0]
        cDesktop:desktop === undefined ? sessionParameters.currentDesktop : desktop

        state1: "listnohovered1"
        state2: "listnohovered2"
        stateHov1: "listhovered1"

        taskHoverRect: taskHoverRectFrame

        states:[
            State {
                name: "listnohovered1"
                PropertyChanges{
                    target:task.previewRectAlias
                    opacity:0
                    width:5
                    height:5
                    x:task.width/2
                    y:task.height/2
                }
                PropertyChanges{
                    target:task.imageTask2Alias
                    width: task.defWidth
                    x:10
                    y:(task.height - height) / 2
                    opacity:1
                }
                PropertyChanges{
                    target:task.taskTitleRecAlias
                    y: (((task.height - task.imageTask2Alias.height) / 2)+task.imageTask2Alias.height-height)
                    x: (task.imageTask2Alias.x+task.imageTask2Alias.width)
                    width: task.width - task.imageTask2Alias.width - 10
                    opacity:task.isSelected === false ? 0.7 : 1
                }
                PropertyChanges{
                    target:task.taskTitle2Alias
                    color:task.taskTitleTextDef
                    font.pixelSize: Math.max((0.28+mainView.defFontRelStep)*task.height,15)
                }
                PropertyChanges{
                    target:taskHoverRectFrame
                    opacity:0
                }
                PropertyChanges{
                    target:task.allTasksBtnsAlias
                    x:taskHoverRectFrame.width - width-5
                    y:0
                    buttonsSize:0.5*task.height
                }
            },
            State {
                name: "listnohovered2"
                PropertyChanges{
                    target:task.previewRectAlias

                    opacity:0.6

                    width:task.defPreviewWidth
                    height:task.defPreviewWidth

                    y:0
                    x:(task.width - task.defPreviewWidth)/2

                    color:"#00000000"
                    border.color:"#00000000"

                }
                PropertyChanges{
                    target:task.imageTask2Alias
                    width: 1.4*task.taskTitleRecAlias.height
                    x:0
                    y:task.taskTitleRecAlias.y-height
                    opacity:1
                }
                PropertyChanges{
                    target:task.taskTitleRecAlias
                    y: task.previewRectAlias.y+task.previewRectAlias.height
                    opacity:0.7
                    width:task.width
                }
                PropertyChanges{
                    target:task.taskTitle2Alias
                    color:task.taskTitleTextDef
                    font.pixelSize: Math.max((0.09+mainView.defFontRelStep)*task.height,15)
                }
                PropertyChanges{
                    target:taskHoverRectFrame
                    opacity:0
                }
                PropertyChanges{
                    target:task.allTasksBtnsAlias
                    x:task.previewRectAlias.x + task.previewRectAlias.width - (offsetx*task.previewRectAlias.width)
                    y:task.previewRectAlias.y - 0.5*buttonsSize + (offsety*task.previewRectAlias.height)
                    buttonsSize:0.2*task.defPreviewWidth
                }

            },
            State {
                name: "listhovered1"
                PropertyChanges{
                    target:task.previewRectAlias

                    width:task.showPreviewsFound===false ? 5 : task.defHovPreviewWidth
                    height:task.showPreviewsFound===false ? 5 : task.defHovPreviewWidth

                    y:task.showPreviewsFound===false ? height/2:(task.height-height)/2
                    x:task.showPreviewsFound===false ? width/2:(task.width-width)/2

                    color: task.showPreviewsFound===false ? lightColor : "#00000000"
                    border.color: task.showPreviewsFound===false ? lightBorder : "#00000000"

                    opacity:task.showPreviewsFound===false ? 0 : 0.6
                }
                PropertyChanges{
                    target:task.imageTask2Alias
                    width: task.showPreviewsFound===false ? 1.4*task.defWidth : 1.4*task.taskTitleRecAlias.height
                    x:task.showPreviewsFound===false ? 10 : 0
                    y:task.showPreviewsFound===false ? (task.height - height) / 2 : task.taskTitleRecAlias.y-height
                    opacity: 1
                }

                PropertyChanges{
                    target:task.taskTitleRecAlias
                    y: task.showPreviewsFound===false ? (((task.height - task.imageTask2Alias.height) / 2)+task.imageTask2Alias.height-height)
                                                 : task.previewRectAlias.y+task.previewRectAlias.height
                    x: task.showPreviewsFound===false ? (task.imageTask2Alias.x+task.imageTask2Alias.width) : 0
                    width: task.showPreviewsFound===false ? task.width - task.imageTask2Alias.width - 10 : task.width
                    opacity: task.showPreviewsFound===false ? 1 : 1
                }
                PropertyChanges{
                    target:task.taskTitle2Alias
                    color:task.taskTitleTextHov
                    font.pixelSize: Math.max(task.showPreviewsFound===false ? (0.28+mainView.defFontRelStep)*task.height : (0.09+mainView.defFontRelStep)*task.height,15)
                }
                PropertyChanges{
                    target:taskHoverRectFrame
                    opacity:task.showPreviewsFound===false ? 1 : 0.001
                }
                PropertyChanges{
                    target:task.allTasksBtnsAlias
                    x:task.showPreviewsFound===false ? taskHoverRectFrame.width - width-5 : task.previewRectAlias.x + task.previewRectAlias.width - (offsetx*task.previewRectAlias.width)

                    buttonsSize: task.showPreviewsFound===false ? 0.5*task.height:0.2*task.defHovPreviewWidth
                    y:task.showPreviewsFound===false ? 0 : task.previewRectAlias.y -buttonsSize + task.previewRectAlias.height/2
                }
            }

        ]
    }



}

