import QtQuick
import Quickshell.Services.SystemTray
import Quickshell.Widgets

BarSection {
    id: section
    Row {
        spacing: 6
        Repeater {
            model: SystemTray.items
            delegate: IconImage {
                id: iconImage
                width: 20
                height: 20
                source: modelData.icon
                required property var modelData
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton)
                            iconImage.modelData.activate();
                        else if (mouse.button === Qt.MiddleButton)
                            iconImage.modelData.secondaryActivate();
                        else if (mouse.button === Qt.RightButton && iconImage.modelData.hasMenu) {
                            const p = mapToItem(bar.contentItem, mouse.x, mouse.y);
                            iconImage.modelData.display(bar, p.x, p.y);
                        }
                    }
                }
            }
        }
    }
}
