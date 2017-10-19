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

import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4 as Controls1
import QtQuick.Controls 2.2
import QtQml.Models 2.2
import Qt.labs.platform 1.0 as PlatformIntegration
import QtQuick.Layouts 1.2

import org.mgallien.QmlExtension 1.0

FocusScope {
    id: topListing

    property StackView stackView
    property MediaPlayList playListModel
    property var musicListener
    property var playerControl
    property var albumName
    property var artistName
    property var tracksCount
    property var albumArtUrl
    property bool isSingleDiscAlbum
    property var albumData
    property var albumId

    width: stackView.width
    height: stackView.height

    SystemPalette {
        id: myPalette
        colorGroup: SystemPalette.Active
    }

    Theme {
        id: elisaTheme
    }

    AlbumModel {
        id: contentModel

        albumData: topListing.albumData
    }

    Connections {
        target: musicListener

        onAlbumRemoved:
        {
            if (albumId === removedAlbumId) {
                contentModel.albumRemoved(removedAlbum)
            }
        }
    }

    Connections {
        target: musicListener

        onAlbumModified:
        {
            if (albumId === modifiedAlbumId) {
                albumData = modifiedAlbum
                contentModel.albumModified(modifiedAlbum)
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        NavigationActionBar {
            id: navBar

            height: elisaTheme.navigationBarHeight

            Layout.preferredHeight: height
            Layout.minimumHeight: height
            Layout.maximumHeight: height
            Layout.fillWidth: true

            parentStackView: topListing.stackView
            playList: topListing.playListModel
            playerControl: topListing.playerControl
            artist: topListing.artistName
            album: topListing.albumName
            image: (topListing.albumArtUrl ? topListing.albumArtUrl : elisaTheme.albumCover)
            tracksCount: topListing.tracksCount

            enqueueAction: Controls1.Action {
                text: i18nc("Add whole album to play list", "Enqueue")
                iconName: "media-track-add-amarok"
                onTriggered: topListing.playListModel.enqueue(topListing.albumData)
            }

            clearAndEnqueueAction: Controls1.Action {
                text: i18nc("Clear play list and add whole album to play list", "Play Now and Replace Play List")
                iconName: "media-playback-start"
                onTriggered: {
                    topListing.playListModel.clearAndEnqueue(topListing.albumData)
                    topListing.playerControl.ensurePlay()
                }
            }
        }

        Rectangle {
            border.width: 1
            border.color: myPalette.mid
            color: myPalette.mid

            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

            Layout.fillWidth: parent

            Layout.leftMargin: elisaTheme.layoutHorizontalMargin
            Layout.rightMargin: elisaTheme.layoutHorizontalMargin

            Layout.preferredHeight: 1
            Layout.minimumHeight: 1
            Layout.maximumHeight: 1
        }

        ScrollView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true

            focus: true

            ListView {
                id: contentDirectoryView

                focus: true

                model: DelegateModel {
                    model: contentModel

                    groups: [
                        DelegateModelGroup { name: "selected" }
                    ]

                    delegate: AudioTrackDelegate {
                        id: entry

                        focus: true

                        isAlternateColor: DelegateModel.itemsIndex % 2
                        height: ((model.isFirstTrackOfDisc && !isSingleDiscAlbum) ? elisaTheme.delegateWithHeaderHeight : elisaTheme.delegateHeight)
                        width: contentDirectoryView.width

                        databaseId: model.databaseId
                        playList: topListing.playListModel
                        playerControl: topListing.playerControl

                        title: if (model != undefined && model.title !== undefined)
                                   model.title
                               else
                                   ''

                        artist: if (model != undefined && model.artist !== undefined)
                                    model.artist
                                else
                                    ''

                        albumArtist: topListing.artistName

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

                        rating: if (model != undefined && model.rating !== undefined)
                                    model.rating
                                else
                                    0

                        trackData: if (model != undefined && model.trackData !== undefined)
                                       model.trackData
                                   else
                                       ''

                        isFirstTrackOfDisc: model.isFirstTrackOfDisc
                        isSingleDiscAlbum: topListing.isSingleDiscAlbum

                        contextMenu: PlatformIntegration.Menu {
                            PlatformIntegration.MenuItem {
                                iconName: entry.clearAndEnqueueAction.iconName
                                text: entry.clearAndEnqueueAction.text
                                enabled: entry.clearAndEnqueueAction.enabled

                                onTriggered: entry.clearAndEnqueueAction.trigger(this)
                            }
                            PlatformIntegration.MenuItem {
                                iconName: entry.enqueueAction.iconName
                                text: entry.enqueueAction.text
                                enabled: entry.enqueueAction.enabled

                                onTriggered: entry.enqueueAction.trigger(this)
                            }
                        }

                        onClicked: contentDirectoryView.currentIndex = index

                        onRightClicked: contextMenu.popup()
                    }
                }
            }
        }
    }
}
