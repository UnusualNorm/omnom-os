import Quickshell
import QtQuick

PanelWindow {
    id: bar

    anchors {
        top: true
        left: true
        right: true
    }

    exclusiveZone: 4
    color: "transparent"
    implicitHeight: sections.height

    function sectionColor(i) {
        const hue = i / sections.children.length;
        const saturation = 0.75;
        const lightness = 0.25;
        const color = Qt.hsla(hue, saturation, lightness, 1);
        return color;
    }

    Row {
        id: sections
        layoutDirection: Qt.RightToLeft
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        SystemTraySection {
            id: systemTray
            sectionColor: bar.sectionColor(0)
        }
        DateSection {
            id: date
            sectionColor: bar.sectionColor(1)
        }
        UPowerSection {
            id: uPower
            sectionColor: bar.sectionColor(2)
        }
        MprisSection {
            id: mpris
            sectionColor: bar.sectionColor(3)
        }
        PipewireSection {
            id: pipewire
            sectionColor: bar.sectionColor(4)
        }
    }

    mask: Region {
        Region {
            item: systemTray.sectionArea
        }
        Region {
            item: date.sectionArea
        }
        Region {
            item: uPower.sectionArea
        }
        Region {
            item: mpris.sectionArea
        }
        Region {
            item: pipewire.sectionArea
        }
    }
}
