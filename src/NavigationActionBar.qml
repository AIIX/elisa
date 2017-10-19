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

import QtQml 2.2
import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4 as Controls1
import QtQuick.Window 2.0

Item {
    id: navigationBar

    property var parentStackView
    property var playList
    property var playerControl
    property string artist
    property string album
    property string image
    property string tracksCount
    property var enqueueAction
    property var clearAndEnqueueAction

    Controls1.Action {
        id: goPreviousAction
        text: i18nc("navigate back in the views stack", "Back")
        iconName: (Qt.application.layoutDirection == Qt.RightToLeft) ? "go-next" : "go-previous"
        onTriggered:
        {
            parentStackView.pop(1)
        }
    }

    RowLayout {
        anchors.fill: parent

        spacing: 0

        ToolButton {
            text: goPreviousAction.text
            //iconName: goPreviousAction.iconName
            enabled: goPreviousAction.enabled

            onClicked: goPreviousAction.trigger(this)

            Layout.leftMargin: !LayoutMirroring.enabled ? elisaTheme.layoutHorizontalMargin : 0
            Layout.rightMargin: LayoutMirroring.enabled ? elisaTheme.layoutHorizontalMargin : 0
        }

        Image {
            id: mainIcon
            source: image

            asynchronous: true

            sourceSize.height: elisaTheme.coverImageSize / 2
            sourceSize.width: elisaTheme.coverImageSize / 2

            fillMode: Image.PreserveAspectFit

            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

            Layout.preferredHeight: elisaTheme.coverImageSize / 2
            Layout.minimumHeight: elisaTheme.coverImageSize / 2
            Layout.maximumHeight: elisaTheme.coverImageSize / 2
            Layout.preferredWidth: elisaTheme.coverImageSize / 2
            Layout.minimumWidth: elisaTheme.coverImageSize / 2
            Layout.maximumWidth: elisaTheme.coverImageSize / 2
            Layout.leftMargin: !LayoutMirroring.enabled ? elisaTheme.layoutHorizontalMargin : 0
            Layout.rightMargin: LayoutMirroring.enabled ? elisaTheme.layoutHorizontalMargin : 0
        }

        ColumnLayout {
            Layout.fillHeight: true

            spacing: 0

            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.leftMargin: !LayoutMirroring.enabled ? elisaTheme.layoutHorizontalMargin : 0
            Layout.rightMargin: LayoutMirroring.enabled ? elisaTheme.layoutHorizontalMargin : 0

            TextMetrics {
                id: albumTextSize
                text: albumLabel.text
                font.pixelSize: albumLabel.font.pixelSize
                font.bold: albumLabel.font.bold
            }

            LabelWithToolTip {
                id: albumLabel

                text: album

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin: albumTextSize.height
                Layout.bottomMargin: albumTextSize.height - authorTextSize.height

                elide: Text.ElideRight

                color: myPalette.text

                font {
                    pixelSize: elisaTheme.defaultFontPixelSize * 1.5
                }

                visible: album !== ""
            }

            TextMetrics {
                id: authorTextSize
                text: authorLabel.text
                font.pixelSize: authorLabel.font.pixelSize
                font.bold: authorLabel.font.bold
            }

            LabelWithToolTip {
                id: authorLabel

                text: artist

                color: myPalette.text

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin: authorTextSize.height

                font {
                    pixelSize: (album !== "" ? elisaTheme.defaultFontPixelSize : elisaTheme.defaultFontPixelSize * 1.5)
                }

                elide: Text.ElideRight
            }
        }

        Button {
            text: enqueueAction.text
            //iconName: enqueueAction.iconName
            enabled: enqueueAction.enabled

            onClicked: enqueueAction.trigger(this)

            Layout.leftMargin: !LayoutMirroring.enabled ? elisaTheme.layoutHorizontalMargin : 0
            Layout.rightMargin: LayoutMirroring.enabled ? elisaTheme.layoutHorizontalMargin : 0
        }

        Button {
            text: clearAndEnqueueAction.text
            //iconName: clearAndEnqueueAction.iconName
            enabled: clearAndEnqueueAction.enabled

            onClicked: clearAndEnqueueAction.trigger(this)

            Layout.leftMargin: elisaTheme.layoutHorizontalMargin
            Layout.rightMargin: elisaTheme.layoutHorizontalMargin
        }
    }
}
