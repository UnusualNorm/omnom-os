import QtQuick
import Quickshell.Io

BarSection {
    id: section
    property date date
    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            section.date = new Date();
            if (section.date.getMinutes() % 10 === 0 && section.date.getSeconds() === 0)
                section.sectionOverrideFor(10000);
        }
    }

    property string weather: "..."
    Process {
        id: weatherProcess
        command: ["curl", "-s", "https://wttr.in/?format=%c+%t"]
        stdout: StdioCollector {
            onStreamFinished: section.weather = text.trim()
        }
    }

    Timer {
        interval: 15 * 60 * 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: weatherProcess.running = true
    }

    function season(date) {
        const month = date.getMonth();
        if (month >= 2 && month <= 4)
            return "Spring";
        if (month >= 5 && month <= 7)
            return "Summer";
        if (month >= 8 && month <= 10)
            return "Fall";
        return "Winter";
    }

    Column {
        Text {
            color: "white"
            text: Qt.formatTime(section.date, "h:mm AP (HH:mm:ss)")
        }
        Text {
            color: "white"
            text: Qt.formatDate(section.date, "MM/dd/yyyy")
        }
        Text {
            color: "white"
            text: `${Qt.formatDate(section.date, "dddd, MMMM")}`
        }
        Text {
            color: "white"
            text: `${section.season(section.date)} ${section.weather}`
        }
    }
}
