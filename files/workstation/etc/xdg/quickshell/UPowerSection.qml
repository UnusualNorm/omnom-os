import QtQuick
import Quickshell.Services.UPower

BarSection {
    id: section

    function stringifyProfile(profile) {
        switch (profile) {
        case PowerProfile.PowerSaver:
            return "Power Saver";
        case PowerProfile.Performance:
            return "Performance";
        case PowerProfile.Balanced:
            return "Balanced";
        default:
            return "Invalid";
        }
    }

    function stringifyReason(reason) {
        switch (reason) {
        case PerformanceDegradationReason.None:
            return "None";
        case PerformanceDegradationReason.HighTemperature:
            return "High Temperature";
        case PerformanceDegradationReason.LapDetected:
            return "Lap Detected";
        default:
            return "Invalid";
        }
    }

    function stringifyState(state) {
        switch (state) {
        case UPowerDeviceState.FullyCharged:
            return "Fully Charged";
        case UPowerDeviceState.PendingCharge:
            return "Pending Charge";
        case UPowerDeviceState.Discharging:
            return "Discharging";
        case UPowerDeviceState.Unknown:
            return "Unknown";
        case UPowerDeviceState.Charging:
            return "Charging";
        case UPowerDeviceState.PendingDischarge:
            return "Pending Discharge";
        case UPowerDeviceState.Empty:
            return "Empty";
        default:
            return "Invalid";
        }
    }

    function stringifyTime(duration) {
        const totalSeconds = Math.round(duration);
        const hours = Math.floor(totalSeconds / 3600);
        const minutes = Math.floor((totalSeconds % 3600) / 60);
        const seconds = totalSeconds % 60;
        return `${hours}h ${minutes}m ${seconds}s`;
    }

    Column {
        Text {
            color: "white"
            text: section.stringifyProfile(PowerProfiles.profile)
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton
                onClicked: mouse => {
                    switch (PowerProfiles.profile) {
                    case PowerProfile.PowerSaver:
                        PowerProfiles.profile = PowerProfile.Balanced;
                        break;
                    case PowerProfile.Balanced:
                        if (PowerProfiles.hasPerformanceProfile)
                            PowerProfiles.profile = PowerProfile.Performance;
                        else
                            PowerProfiles.profile = PowerProfile.PowerSaver;
                        break;
                    case PowerProfile.Performance:
                        PowerProfiles.profile = PowerProfile.PowerSaver;
                        break;
                    default:
                        PowerProfiles.profile = PowerProfile.Balanced;
                        break;
                    }
                }
            }
        }
        Text {
            visible: PowerProfiles.degradationReason !== PerformanceDegradationReason.None
            color: "white"
            text: section.stringifyReason(PowerProfiles.degradationReason)
        }
        Text {
            visible: UPower.displayDevice.isLaptopBattery
            color: "white"
            text: `${Math.round(UPower.displayDevice.percentage * 100)}%`
        }
        Text {
            visible: UPower.displayDevice.state !== UPowerDeviceState.Unknown
            color: "white"
            text: section.stringifyState(UPower.displayDevice.state)
        }
        Text {
            visible: UPower.displayDevice.state === UPowerDeviceState.Discharging
            color: "white"
            text: section.stringifyTime(UPower.displayDevice.timeToEmpty)
        }
        Text {
            visible: UPower.displayDevice.state === UPowerDeviceState.Charging
            color: "white"
            text: section.stringifyTime(UPower.displayDevice.timeToFull)
        }
    }
}
