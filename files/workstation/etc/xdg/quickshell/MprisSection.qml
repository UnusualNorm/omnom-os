import QtQuick
import QtQuick.Controls
import Quickshell
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Widgets

BarSection {
    id: section
    property int index: 0
    property var player: Mpris.players.values[index]

    Timer {
        interval: 1000
        repeat: true
        running: section.player?.isPlaying ?? false
        onTriggered: section.player?.positionChanged()
    }

    ColumnLayout {
        RowLayout {
            spacing: 8
            Image {
                Layout.preferredHeight: 96
                Layout.preferredWidth: implicitWidth / implicitHeight * Layout.preferredHeight
                source: section.player?.trackArtUrl ?? ""
            }
            ColumnLayout {
                RowLayout {
                    Text {
                        color: "white"
                        text: section.player ? section.player.identity : ""
                        font.pixelSize: 20
                        font.bold: true
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    Button {
                        background: null
                        contentItem: IconImage {
                            implicitSize: 32
                            source: Quickshell.iconPath("media-playlist-repeat")
                        }
                        onClicked: section.index = (section.index + 1) % Mpris.players.values.length
                    }
                }
                Text {
                    color: "white"
                    text: section.player ? section.player.trackTitle : ""
                    font.pixelSize: 16
                }
                Text {
                    color: "white"
                    text: section.player ? section.player.trackArtist : ""
                }
                Item {
                    Layout.fillHeight: true
                }
            }
        }
        RowLayout {
            Button {
                background: null
                contentItem: IconImage {
                    implicitSize: 24
                    source: Quickshell.iconPath("media-seek-backward")
                }
                enabled: section.player?.canGoPrevious ?? false
                onClicked: section.player.previous()
            }
            Button {
                background: null
                contentItem: IconImage {
                    implicitSize: 24
                    source: section.player?.isPlaying ? Quickshell.iconPath("media-pause") : Quickshell.iconPath("media-play")
                }
                enabled: section.player?.canTogglePlaying ?? false
                onClicked: section.player.togglePlaying()
            }
            Button {
                background: null
                contentItem: IconImage {
                    implicitSize: 24
                    source: Quickshell.iconPath("media-seek-forward")
                }
                enabled: section.player?.canGoNext ?? false
                onClicked: section.player.next()
            }
            Slider {
                from: 0
                Layout.fillWidth: true
                to: section.player?.length ?? 0
                value: section.player?.position ?? 0
                enabled: section.player?.canSeek ?? false
                onMoved: section.player.position = value
            }
        }
    }
}
