import QtQuick
import Quickshell.Services.Pipewire

BarSection {
    id: section
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    Column {
        id: column
        Text {
            visible: Pipewire.defaultAudioSink !== null
            color: "white"
            text: `${Math.round(Pipewire.defaultAudioSink?.audio.volume * 100)}% ${Pipewire.defaultAudioSink?.description}`
        }
        Text {
            visible: Pipewire.defaultAudioSource !== null
            color: "white"
            text: `${Math.round(Pipewire.defaultAudioSource?.audio.volume * 100)}% ${Pipewire.defaultAudioSource?.description}`
        }
        WheelHandler {
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            onWheel: event => {
                let delta;
                if (event.pixelDelta.y !== 0)
                    delta = event.pixelDelta.y / 100;
                else
                    delta = event.angleDelta.y / 120;
                event.accepted = true;
                if (Pipewire.defaultAudioSink !== null) {
                    Pipewire.defaultAudioSink.audio.volume = Math.min(Math.max(Pipewire.defaultAudioSink.audio.volume + delta * 0.01, 0), 1);
                }
            }
        }
    }
}
