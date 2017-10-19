/*
 * Copyright 2016-2017 Matthieu Gallien <matthieu_gallien@yahoo.fr>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file COPYING.LIB.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4 as Controls1
import QtQuick.Window 2.2
import QtQml.Models 2.2
import QtGraphicalEffects 1.0

import org.mgallien.QmlExtension 1.0

FocusScope {
    property StackView stackView
    property MediaPlayList playListModel
    property var musicListener
    property var playerControl
    property var image
    property alias title: titleLabel.text
    property alias artist: artistLabel.text
    property string trackNumber
    property bool isSingleDiscAlbum
    property var albumData
    property var albumId

    signal albumClicked()

    id: mediaServerEntry

    Controls1.Action {
        id: enqueueAction

        text: i18nc("Add whole album to play list", "Enqueue")
        iconName: 'media-track-add-amarok'
        onTriggered: mediaServerEntry.playListModel.enqueue(mediaServerEntry.albumData)
    }

    Component {
        id: childItem

        MediaAlbumView {
            stackView: mediaServerEntry.stackView
            playListModel: mediaServerEntry.playListModel
            musicListener: mediaServerEntry.musicListener
            playerControl: mediaServerEntry.playerControl
            albumArtUrl: mediaServerEntry.image
            albumName: mediaServerEntry.title
            artistName: mediaServerEntry.artist
            tracksCount: count
            isSingleDiscAlbum: mediaServerEntry.isSingleDiscAlbum
            albumData: mediaServerEntry.albumData
            albumId: mediaServerEntry.albumId
        }
    }

    Controls1.Action {
        id: openAction

        text: i18nc("Open album view", "Open Album")
        iconName: 'document-open-folder'
        onTriggered: {
            stackView.push(childItem)
        }
    }

    Controls1.Action {
        id: enqueueAndPlayAction

        text: i18nc("Clear play list and add whole album to play list", "Play Now and Replace Play List")
        iconName: 'media-playback-start'
        onTriggered: {
            mediaServerEntry.playListModel.clearAndEnqueue(mediaServerEntry.albumData)
            mediaServerEntry.playerControl.ensurePlay()
        }
    }

    ColumnLayout {
        anchors.fill: parent

        spacing: 0

        MouseArea {
            id: hoverHandle

            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            focus: true

            Layout.preferredHeight: mediaServerEntry.width * 0.9 + elisaTheme.layoutVerticalMargin * 0.5 + titleSize.height + artistSize.height
            Layout.fillWidth: true

            onClicked:
            {
                hoverHandle.forceActiveFocus()
                albumClicked()
            }

            TextMetrics {
                id: titleSize
                font: titleLabel.font
                text: titleLabel.text
            }

            TextMetrics {
                id: artistSize
                font: artistLabel.font
                text: artistLabel.text
            }

            Loader {
                id: hoverLoader
                active: false

                z: 2

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: mediaServerEntry.width * 0.9 + elisaTheme.layoutVerticalMargin

                sourceComponent: Item {
                    GaussianBlur {
                        id: hoverLayer

                        radius: 4
                        samples: 16
                        deviation: 5

                        anchors.fill: parent

                        source: ShaderEffectSource {
                            sourceItem: mainData
                            sourceRect: Qt.rect(0, 0, hoverLayer.width, hoverLayer.height)
                        }

                        Rectangle {
                            color: myPalette.light
                            opacity: 0.5
                            anchors.fill: parent
                        }
                    }

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 0

                        ToolButton {
                            id: enqueueButton

                            hoverEnabled: true

                            ToolTip.delay: 1000
                            ToolTip.timeout: 5000
                            ToolTip.visible: hovered
                            ToolTip.text: enqueueAction.text

                            enabled: enqueueAction.enabled

                            onClicked: enqueueAction.trigger(this)

                            contentItem: Image {
                                source: "image://icon/" + enqueueAction.iconName

                                sourceSize.width: elisaTheme.delegateToolButtonSize
                                sourceSize.height: elisaTheme.delegateToolButtonSize

                                fillMode: Image.PreserveAspectFit
                                mirror: LayoutMirroring.enabled

                                anchors.fill: parent
                            }

                            Layout.minimumWidth: elisaTheme.delegateToolButtonSize
                            Layout.minimumHeight: elisaTheme.delegateToolButtonSize
                            Layout.preferredWidth: elisaTheme.delegateToolButtonSize
                            Layout.preferredHeight: elisaTheme.delegateToolButtonSize
                            Layout.maximumWidth: elisaTheme.delegateToolButtonSize
                            Layout.maximumHeight: elisaTheme.delegateToolButtonSize
                        }

                        ToolButton {
                            id: openButton

                            hoverEnabled: true

                            ToolTip.delay: 1000
                            ToolTip.timeout: 5000
                            ToolTip.visible: hovered
                            ToolTip.text: openAction.text

                            enabled: openAction.enabled

                            onClicked: openAction.trigger(this)

                            contentItem: Image {
                                source: "image://icon/" + openAction.iconName

                                sourceSize.width: elisaTheme.delegateToolButtonSize
                                sourceSize.height: elisaTheme.delegateToolButtonSize

                                fillMode: Image.PreserveAspectFit
                                mirror: LayoutMirroring.enabled

                                anchors.fill: parent
                            }

                            Layout.minimumWidth: elisaTheme.delegateToolButtonSize
                            Layout.minimumHeight: elisaTheme.delegateToolButtonSize
                            Layout.preferredWidth: elisaTheme.delegateToolButtonSize
                            Layout.preferredHeight: elisaTheme.delegateToolButtonSize
                            Layout.maximumWidth: elisaTheme.delegateToolButtonSize
                            Layout.maximumHeight: elisaTheme.delegateToolButtonSize
                        }

                        ToolButton {
                            id: enqueueAndPlayButton

                            hoverEnabled: true

                            ToolTip.delay: 1000
                            ToolTip.timeout: 5000
                            ToolTip.visible: hovered
                            ToolTip.text: enqueueAndPlayAction.text

                            enabled: enqueueAndPlayAction.enabled

                            onClicked: enqueueAndPlayAction.trigger(this)

                            contentItem: Image {
                                source: "image://icon/" + enqueueAndPlayAction.iconName

                                sourceSize.width: elisaTheme.delegateToolButtonSize
                                sourceSize.height: elisaTheme.delegateToolButtonSize

                                fillMode: Image.PreserveAspectFit
                                mirror: LayoutMirroring.enabled

                                anchors.fill: parent
                            }

                            Layout.minimumWidth: elisaTheme.delegateToolButtonSize
                            Layout.minimumHeight: elisaTheme.delegateToolButtonSize
                            Layout.preferredWidth: elisaTheme.delegateToolButtonSize
                            Layout.preferredHeight: elisaTheme.delegateToolButtonSize
                            Layout.maximumWidth: elisaTheme.delegateToolButtonSize
                            Layout.maximumHeight: elisaTheme.delegateToolButtonSize
                        }
                    }
                }
            }

            ColumnLayout {
                id: mainData

                spacing: 0
                anchors.fill: parent

                z: 1

                Item {
                    Layout.preferredHeight: mediaServerEntry.width * 0.9
                    Layout.preferredWidth: mediaServerEntry.width * 0.9

                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    focus: true

                    Image {
                        id: coverImage

                        anchors.fill: parent

                        sourceSize.width: mediaServerEntry.width * 0.9
                        sourceSize.height: mediaServerEntry.width * 0.9
                        fillMode: Image.PreserveAspectFit
                        smooth: true

                        source: (mediaServerEntry.image ? mediaServerEntry.image : Qt.resolvedUrl(elisaTheme.albumCover))

                        asynchronous: true

                        layer.enabled: true
                        layer.effect: DropShadow {
                            horizontalOffset: mediaServerEntry.width * 0.02
                            verticalOffset: mediaServerEntry.width * 0.02

                            source: coverImage

                            radius: 5.0
                            samples: 11

                            color: myPalette.shadow
                        }
                    }
                }

                LabelWithToolTip {
                    id: titleLabel

                    font.weight: Font.Bold
                    color: myPalette.text

                    horizontalAlignment: Text.AlignLeft

                    Layout.topMargin: elisaTheme.layoutVerticalMargin * 0.5
                    Layout.preferredWidth: mediaServerEntry.width * 0.9
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

                    elide: Text.ElideRight
                }

                LabelWithToolTip {
                    id: artistLabel

                    font.weight: Font.Normal
                    color: myPalette.text

                    horizontalAlignment: Text.AlignLeft

                    Layout.preferredWidth: mediaServerEntry.width * 0.9
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

                    elide: Text.ElideRight
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }

    states: [
        State {
            name: 'default'

            PropertyChanges {
                target: hoverLoader
                active: false
            }
        },
        State {
            name: 'active'

            when: mediaServerEntry.activeFocus || hoverHandle.containsMouse

            PropertyChanges {
                target: hoverLoader
                active: true
            }
        }

    ]
}
