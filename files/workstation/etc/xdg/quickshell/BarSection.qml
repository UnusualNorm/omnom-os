import Quickshell
import QtQuick

Item {
    id: section
    width: contentItem.childrenRect.width + section.sectionPadding * 2
    height: bar.exclusiveZone + contentWrapper.expandedHeight

    readonly property bool sectionExpanded: hoverHandler.hovered || section.sectionOverride
    readonly property alias sectionArea: hoverArea

    default property alias sectionContent: contentItem.data
    property bool sectionOverride: false
    property color sectionColor: "black"
    property real sectionTransparency: 0.75
    property real sectionPadding: 8
    property real sectionRadius: 8

    function sectionOverrideFor(duration) {
        sectionOverride = true;
        overrideTimer.interval = duration;
        overrideTimer.restart();
    }

    Timer {
        id: overrideTimer
        onTriggered: section.sectionOverride = false
    }

    Rectangle {
        anchors {
            top: section.top
            left: section.left
            right: section.right
        }

        height: bar.exclusiveZone
        color: section.sectionColor
    }

    Item {
        id: contentWrapper
        readonly property real expandedHeight: contentItem.childrenRect.height + section.sectionPadding * 2
        y: bar.exclusiveZone
        width: section.width
        height: section.sectionExpanded ? expandedHeight : 0
        clip: true
        Behavior on height {
            NumberAnimation {
                duration: 100
                easing.type: Easing.InCubic
            }
        }

        Rectangle {
            radius: section.sectionRadius
            y: -radius
            width: parent.width
            height: contentWrapper.expandedHeight + radius
            color: Qt.rgba(section.sectionColor.r, section.sectionColor.g, section.sectionColor.b, section.sectionTransparency)
        }

        Item {
            id: contentItem
            x: section.sectionPadding
            y: section.sectionPadding
        }
    }

    Item {
        id: hoverArea
        width: section.width
        height: bar.exclusiveZone + contentWrapper.height
        HoverHandler {
            id: hoverHandler
            onHoveredChanged: if (!hovered)
                section.sectionOverride = false
        }
    }
}
