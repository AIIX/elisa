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
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4 as Controls1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import QtQml.Models 2.1
import Qt.labs.platform 1.0 as PlatformIntegration

import org.mgallien.QmlExtension 1.0

FocusScope {
    property StackView parentStackView
    property MediaPlayList playListModel
    property var playListControler

    property alias randomPlayChecked: shuffleOption.checked
    property alias repeatPlayChecked: repeatOption.checked

    property int placeholderHeight: elisaTheme.dragDropPlaceholderHeight

    signal startPlayback()

    id: topItem

    Controls1.Action {
        id: clearPlayList
        text: i18nc("Remove all tracks from play list", "Clear Play List")
        iconName: "list-remove"
        enabled: playListModelDelegate.items.count > 0
        onTriggered: {
            var selectedItems = []
            var myGroup = playListModelDelegate.items
            for (var i = 0; i < myGroup.count; ++i) {
                var myItem = myGroup.get(i)
                selectedItems.push(myItem.itemsIndex)
            }

            playListModel.removeSelection(selectedItems)
        }
    }

    Controls1.Action {
        id: showCurrentTrack
        text: i18nc("Show currently played track inside playlist", "Show Current Track")
        iconName: 'media-show-active-track-amarok'
        enabled: playListModelDelegate.items.count > 0
        onTriggered: playListView.positionViewAtIndex(playListControler.currentTrackRow, ListView.Contain)
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TextMetrics {
            id: titleHeight
            text: viewTitleHeight.text
            font
            {
                pixelSize: viewTitleHeight.font.pixelSize
                bold: viewTitleHeight.font.bold
            }
        }

        LabelWithToolTip {
            id: viewTitleHeight
            text: i18nc("Title of the view of the playlist", "Now Playing")

            color: myPalette.text
            font.pixelSize: elisaTheme.defaultFontPixelSize * 2

            Layout.topMargin: elisaTheme.layoutVerticalMargin
            Layout.leftMargin: elisaTheme.layoutHorizontalMargin
            Layout.rightMargin: elisaTheme.layoutHorizontalMargin
            Layout.bottomMargin: titleHeight.height + elisaTheme.layoutVerticalMargin
        }

        RowLayout {
            Layout.alignment: Qt.AlignVCenter

            Layout.fillWidth: true

            Layout.leftMargin: elisaTheme.layoutHorizontalMargin
            Layout.rightMargin: elisaTheme.layoutHorizontalMargin
            Layout.bottomMargin: titleHeight.height + elisaTheme.layoutVerticalMargin

            CheckBox {
                id: shuffleOption

                text: i18n("Shuffle")

                Layout.alignment: Qt.AlignVCenter
            }

            CheckBox {
                id: repeatOption

                text: i18n("Repeat")

                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: !LayoutMirroring.enabled ? elisaTheme.layoutHorizontalMargin : 0
                Layout.rightMargin: LayoutMirroring.enabled ? elisaTheme.layoutHorizontalMargin : 0
            }

            Item {
                Layout.fillWidth: true
            }

            LabelWithToolTip {
                id: playListInfo

                text: i18np("1 track", "%1 tracks", playListModel.tracksCount)

                color: myPalette.text

                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            }
        }

        Rectangle {
            border.width: 1
            border.color: myPalette.mid
            color: myPalette.mid

            Layout.fillWidth: true
            Layout.preferredHeight: 1
            Layout.minimumHeight: 1
            Layout.maximumHeight: 1

            Layout.topMargin: elisaTheme.layoutVerticalMargin
            Layout.bottomMargin: elisaTheme.layoutVerticalMargin
            Layout.leftMargin: elisaTheme.layoutHorizontalMargin
            Layout.rightMargin: elisaTheme.layoutHorizontalMargin
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            focus: true

            ListView {
                id: playListView

                focus: true

                TextEdit {
                    readOnly: true
                    visible: playListModelDelegate.count === 0
                    wrapMode: TextEdit.Wrap
                    renderType: TextEdit.NativeRendering

                    color: myPalette.text

                    font.weight: Font.ExtraLight
                    font.pointSize: 12

                    text: i18nc("Text shown when play list is empty", "Your play list is empty.\nIn order to start, you can explore your music library with the views on the left.\nUse the available buttons to add your selection.")
                    anchors.fill: parent
                    anchors.margins: elisaTheme.layoutHorizontalMargin
                }

                model: DelegateModel {
                    id: playListModelDelegate
                    model: playListModel

                    groups: [
                        DelegateModelGroup { name: "selected" }
                    ]

                    delegate: DraggableItem {
                        id: item

                        placeholderHeight: topItem.placeholderHeight

                        focus: true

                        PlayListEntry {
                            id: entry

                            focus: true

                            width: playListView.width
                            index: model.index
                            isAlternateColor: item.DelegateModel.itemsIndex % 2
                            hasAlbumHeader: if (model != undefined && model.hasAlbumHeader !== undefined)
                                                model.hasAlbumHeader
                                            else
                                                true
                            title: if (model != undefined && model.title !== undefined)
                                       model.title
                                   else
                                       ''
                            artist: if (model != undefined && model.artist !== undefined)
                                        model.artist
                                    else
                                        ''
                            albumArtist: if (model != undefined && model.albumArtist !== undefined)
                                        model.albumArtist
                                    else
                                        ''
                            itemDecoration: if (model != undefined && model.image !== undefined)
                                                model.image
                                            else
                                                ''
                            duration: if (model != undefined && model.duration !== undefined)
                                          model.duration
                                      else
                                          ''
                            trackNumber: if (model != undefined && model.trackNumber !== undefined)
                                             model.trackNumber
                                         else
                                             ''
                            discNumber: if (model != undefined && model.discNumber !== undefined)
                                            model.discNumber
                                        else
                                            ''
                            isSingleDiscAlbum: if (model != undefined && model.isSingleDiscAlbum !== undefined)
                                                   model.isSingleDiscAlbum
                                               else
                                                   false
                            album: if (model != undefined && model.album !== undefined)
                                       model.album
                                   else
                                       ''
                            rating: if (model != undefined && model.rating !== undefined)
                                        model.rating
                                    else
                                        0
                            isValid: model.isValid
                            isPlaying: model.isPlaying
                            isSelected: item.DelegateModel.inSelected
                            containsMouse: item.containsMouse

                            playListModel: topItem.playListModel
                            playListControler: topItem.playListControler

                            contextMenu: PlatformIntegration.Menu {
                                PlatformIntegration.MenuItem {
                                    text: entry.clearPlayListAction.text
                                    shortcut: entry.clearPlayListAction.shortcut
                                    iconName: entry.clearPlayListAction.iconName
                                    onTriggered: entry.clearPlayListAction.trigger()
                                    visible: entry.clearPlayListAction.text !== ""
                                }
                                PlatformIntegration.MenuItem {
                                    text: entry.playNowAction.text
                                    shortcut: entry.playNowAction.shortcut
                                    iconName: entry.playNowAction.iconName
                                    onTriggered: entry.playNowAction.trigger()
                                    visible: entry.playNowAction.text !== ""
                                }
                            }

                            onStartPlayback: {
                                topItem.startPlayback()
                            }
                        }

                        draggedItemParent: topItem

                        onClicked:
                        {
                            playListView.currentIndex = index
                        }

                        onRightClicked: contentItem.contextMenu.popup()

                        onMoveItemRequested: {
                            playListModel.move(from, to, 1);
                        }
                    }
                }
            }
        }

        Rectangle {
            id: actionBar

            Layout.fillWidth: true
            Layout.topMargin: elisaTheme.layoutVerticalMargin
            Layout.preferredHeight: elisaTheme.delegateToolButtonSize

            color: myPalette.mid

            RowLayout {
                id: actionBarLayout

                anchors.fill: parent

                ToolButton {
                    text: clearPlayList.text
                    //iconName: clearPlayList.iconName
                    enabled: clearPlayList.enabled

                    onClicked: clearPlayList.trigger(this)

                    Layout.bottomMargin: elisaTheme.layoutVerticalMargin
                }
                ToolButton {
                    text: showCurrentTrack.text
                    //iconName: showCurrentTrack.iconName
                    enabled: showCurrentTrack.enabled

                    onClicked: showCurrentTrack.trigger(this)

                    Layout.bottomMargin: elisaTheme.layoutVerticalMargin
                }
                Item {
                    Layout.fillWidth: true
                }
            }
        }
    }
}

