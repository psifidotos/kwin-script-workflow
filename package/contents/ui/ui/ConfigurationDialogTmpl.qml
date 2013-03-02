import QtQuick 1.1

import "../../code/settings.js" as Settings

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

DialogTemplate2{
    id:configDialog

    property string dialogType:"ConfigurationDialog"
    dialogTitle:"Configuration"

    insideWidth: 0.45*parent.width
    insideHeight: 1.1*genColumn.height
    isModal: true
    forceModality: false
    showButtons:false

    Column{
        id:genColumn
        spacing:5

        width: totalRowWidth
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        property int columnSpacer:20
        property int leftColumnWidth:0.16*configDialog.width
        property int rightColumnWidth:0.65*configDialog.width
        property int totalRowWidth: columnSpacer + leftColumnWidth + rightColumnWidth

        property int heightSize: heightLabel.height
        property int rowHeight: 1.1 * heightSize

        Item{
            height: genColumn.heightSize
            width: genColumn.totalRowWidth

            Item{
                width: genColumn.leftColumnWidth
                PlasmaComponents.Label{
                    id:heightLabel
                    text:i18n("Animation Level")
                    anchors.right: parent.right
                    font.bold: true
                    font.italic: true
                }

                PlasmaComponents.Slider {
                    minimumValue: 0
                    maximumValue: 2
                    width: genColumn.rightColumnWidth
                    anchors.left: parent.right
                    anchors.leftMargin: genColumn.columnSpacer

                    Component.onCompleted: value=Settings.global.animations;
                    onValueChanged: Settings.global.animations=value;
                }
            }
        }


        Item{
            height: genColumn.heightSize
            width: genColumn.totalRowWidth

            Item{
                width: genColumn.leftColumnWidth
                Item {
                    width: genColumn.rightColumnWidth
                    anchors.left: parent.right
                    anchors.leftMargin: genColumn.columnSpacer
                    PlasmaComponents.Label{
                        text:i18n("None")
                        anchors.horizontalCenter:parent.left
                    }
                    PlasmaComponents.Label{
                        text:i18n("Basic")
                        anchors.horizontalCenter:parent.horizontalCenter
                    }
                    PlasmaComponents.Label{
                        text:i18n("Full")
                        anchors.horizontalCenter:parent.right
                    }
                }
            }
        }


        Item{
            height: genColumn.heightSize
            width: genColumn.totalRowWidth

            Item{
                width: genColumn.leftColumnWidth

                PlasmaComponents.Label{
                    text:i18n("Appearance")
                    anchors.right: parent.right
                    font.bold: true
                    font.italic: true
                }

                Item {
                    width: genColumn.rightColumnWidth
                    anchors.left: parent.right
                    anchors.leftMargin: genColumn.columnSpacer
                    PlasmaComponents.Switch{
                        text:i18n("Hide background and use Plasma Theme")
                        Component.onCompleted: checked=Settings.global.disableBackground;
                        onCheckedChanged: Settings.global.disableBackground=checked;
                    }
                }

            }
        }

        Item{
            height: genColumn.heightSize
            width: genColumn.totalRowWidth

            Item{
                width: genColumn.leftColumnWidth

                PlasmaComponents.Label{
                    text:i18n("Behavior")
                    anchors.right: parent.right
                    font.bold: true
                    font.italic: true
                }

                Item {
                    width: genColumn.rightColumnWidth
                    anchors.left: parent.right
                    anchors.leftMargin: genColumn.columnSpacer
                    PlasmaComponents.Switch{
                        text:i18n("Disable \"Everywhere\" windows panel")
                        Component.onCompleted: checked=Settings.global.disableEverywherePanel;
                        onCheckedChanged: Settings.global.disableEverywherePanel=checked;
                    }
                }

            }
        }

    }

    function closeD(){
        configDialog.close();
    }

    function openD(){
        configDialog.open();
    }


}
