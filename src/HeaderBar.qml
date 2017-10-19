/*
 * Copyright 2016 Matthieu Gallien <matthieu_gallien@yahoo.fr>
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
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.2
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

FocusScope {
    id: headerBar

    property string title
    property string artist
    property string album
    property string image
    property string newImage
    property string oldImage
    property string tracksCount
    property int trackRating
    property bool ratingVisible
    property alias playerControl: playControlItem

    onImageChanged:
    {
        if (changeBackgroundTransition.running) {
            changeBackgroundTransition.complete()
        }

        newImage = image
        changeBackgroundTransition.start()
    }

    Item {
        id: background
        anchors.fill: parent

        Image {
            id: oldBackground

            source: (oldImage ? oldImage : Qt.resolvedUrl('background.jpg'))

            asynchronous: true

            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop

            sourceSize.width: parent.width

            opacity: 1

            layer.enabled: true
            layer.effect: Desaturate {
                cached: true

                desaturation: -0.2

                layer.enabled: true
                layer.effect: BrightnessContrast {
                    cached: true

                    brightness: -0.2
                    contrast: -0.1

                    layer.enabled: true
                    layer.effect: GaussianBlur {
                        cached: true

                        radius: 32
                        deviation: 12
                        samples: 65

                        transparentBorder: false
                    }
                }
            }
        }

        Image {
            id: newBackground

            source: (newImage ? newImage : Qt.resolvedUrl('background.jpg'))

            asynchronous: true

            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop

            sourceSize.width: parent.width

            visible: false
            opacity: 0

            layer.enabled: true
            layer.effect: Desaturate {
                cached: true

                desaturation: -0.2

                layer.enabled: true
                layer.effect: BrightnessContrast {
                    cached: true

                    brightness: -0.2
                    contrast: -0.1

                    layer.enabled: true
                    layer.effect: GaussianBlur {
                        cached: true

                        radius: 32
                        deviation: 12
                        samples: 65

                        transparentBorder: false
                    }
                }
            }
        }
    }

    MediaPlayerControl {
        id: playControlItem

        focus: true

        anchors.left: background.left
        anchors.right: background.right
        anchors.bottom: background.bottom

        height: elisaTheme.mediaPlayerControlHeight
    }

    LabelWithToolTip {
        id: backgroundCopyright
        anchors.bottom: playControlItem.top
        anchors.right: parent.right
        anchors.bottomMargin: elisaTheme.layoutVerticalMargin
        anchors.rightMargin: elisaTheme.layoutVerticalMargin

        text: i18nc("Copyright text shown for an image", "by Edward Betts (Own work) [CC BY-SA 3.0]")
        color: myPalette.highlightedText
        opacity: 0.4

        visible: !image
    }

    ColumnLayout {
        id: contentZone

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: playControlItem.top

        spacing: 0

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        RowLayout {
            spacing: 0

            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true

            Item {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                Layout.preferredHeight: contentZone.height * 0.9
                Layout.minimumHeight: contentZone.height * 0.9
                Layout.maximumHeight: contentZone.height * 0.9
                Layout.preferredWidth: contentZone.height * 0.9
                Layout.minimumWidth: contentZone.height * 0.9
                Layout.maximumWidth: contentZone.height * 0.9
                Layout.leftMargin: !LayoutMirroring.enabled ? contentZone.width * 0.15 : 0
                Layout.rightMargin: LayoutMirroring.enabled ? contentZone.width * 0.15 : 0

                Image {
                    id: oldMainIcon

                    anchors.fill: parent

                    asynchronous: true

                    source: (oldImage ? oldImage : Qt.resolvedUrl(elisaTheme.albumCover))

                    sourceSize {
                        width: contentZone.height * 0.9
                        height: contentZone.height * 0.9
                    }

                    fillMode: Image.PreserveAspectFit

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: elisaTheme.shadowOffset
                        verticalOffset: elisaTheme.shadowOffset

                        radius: 5.0
                        samples: 11

                        color: myPalette.shadow
                    }
                }

                Image {
                    id: newMainIcon

                    anchors.fill: parent

                    asynchronous: true

                    source: (newImage ? newImage : Qt.resolvedUrl(elisaTheme.albumCover))

                    visible: false
                    opacity: 0

                    sourceSize {
                        width: contentZone.height * 0.9
                        height: contentZone.height * 0.9
                    }

                    fillMode: Image.PreserveAspectFit

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: elisaTheme.shadowOffset
                        verticalOffset: elisaTheme.shadowOffset

                        radius: 5.0
                        samples: 11

                        color: myPalette.shadow
                    }
                }
            }

            ColumnLayout {
                spacing: 0

                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                Layout.leftMargin: !LayoutMirroring.enabled ? elisaTheme.layoutHorizontalMargin : 0
                Layout.rightMargin: LayoutMirroring.enabled ? elisaTheme.layoutHorizontalMargin : 0
                Layout.fillWidth: true
                Layout.fillHeight: true

                TextMetrics {
                    id: titleFontInfo
                    font
                    {
                        bold: albumLabel.font.bold
                        pixelSize: albumLabel.font.pixelSize
                    }
                    text: albumLabel.text
                }

                LabelWithToolTip {
                    id: mainLabel
                    text: title
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                    elide: Text.ElideRight
                    color: myPalette.highlightedText
                    font.pixelSize: elisaTheme.defaultFontPixelSize * 2
                    font.bold: true

                    layer.effect: Glow {
                        cached: true

                        color: myPalette.shadow

                        radius: 4.0
                        samples: 9
                    }

                    Layout.bottomMargin: titleFontInfo.height
                }

                LabelWithToolTip {
                    id: authorLabel
                    text: artist
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                    elide: Text.ElideRight
                    color: myPalette.highlightedText
                    font.pixelSize: elisaTheme.defaultFontPixelSize * 1.5

                    layer.effect: Glow {
                        cached: true

                        color: myPalette.shadow

                        radius: 4.0
                        samples: 9
                    }

                    Layout.bottomMargin: titleFontInfo.height
                }

                LabelWithToolTip {
                    id: albumLabel
                    text: album
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft
                    elide: Text.ElideRight
                    color: myPalette.highlightedText
                    font.weight: Font.Light

                    layer.effect: Glow {
                        cached: true

                        color: myPalette.shadow

                        radius: 4.0
                        samples: 9
                    }

                    Layout.bottomMargin: titleFontInfo.height
                }

                RatingStar {
                    id: mainRating
                    visible: ratingVisible
                    starSize: elisaTheme.ratingStarSize
                    starRating: trackRating
                    Layout.alignment: Qt.AlignLeft
                }
            }

            LabelWithToolTip {
                id: remainingTracksLabel
                text: i18np("1 track remaining", "%1 tracks remaining", tracksCount)
                Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                Layout.bottomMargin: (backgroundCopyright.visible ? elisaTheme.layoutVerticalMargin + backgroundCopyright.height : elisaTheme.layoutVerticalMargin)
                Layout.leftMargin: elisaTheme.layoutHorizontalMargin
                Layout.rightMargin: elisaTheme.layoutHorizontalMargin
                elide: Text.ElideRight
                visible: tracksCount > 0
                color: myPalette.highlightedText
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

    SequentialAnimation {
        id: changeBackgroundTransition

        PropertyAction {
            targets: [newBackground, newMainIcon]
            property: 'opacity'
            value: 0
        }

        PropertyAction {
            targets: [newBackground, newMainIcon]
            property: 'visible'
            value: true
        }

        PropertyAction {
            target: newBackground
            property: "source"
            value: (newImage ? newImage : Qt.resolvedUrl('background.jpg'))
        }

        PropertyAction {
            target: newMainIcon
            property: "source"
            value: (newImage ? newImage : Qt.resolvedUrl(elisaTheme.albumCover))
        }

        ParallelAnimation {
            NumberAnimation {
                targets: [newBackground, newMainIcon]
                property: 'opacity'
                from: 0
                to: 1
                duration: 250
                easing.type: Easing.Linear
            }

            NumberAnimation {
                targets: [oldBackground, oldMainIcon]
                property: 'opacity'
                from: 1
                to: 0
                duration: 250
                easing.type: Easing.Linear
            }
        }

        PropertyAction {
            target: headerBar
            property: "oldImage"
            value: image
        }

        PropertyAction {
            target: oldBackground
            property: 'source'
            value: (headerBar.oldImage ? headerBar.oldImage : Qt.resolvedUrl('background.jpg'))
        }

        PropertyAction {
            target: oldMainIcon
            property: 'source'
            value: (headerBar.oldImage ? headerBar.oldImage : Qt.resolvedUrl(elisaTheme.albumCover))
        }

        PropertyAction {
            targets: [oldBackground, oldMainIcon]
            property: 'opacity'
            value: 1
        }

        PropertyAction {
            targets: [newBackground, newMainIcon]
            property: 'visible'
            value: false
        }

        onStopped:
        {
            oldImage = newImage
        }
    }
}
