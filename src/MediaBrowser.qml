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
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import org.mgallien.QmlExtension 1.0

FocusScope {
    property MediaPlayList playListModel
    property var firstPage
    property alias stackView: listingView

    id: contentDirectoryRoot

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        StackView {
            id: listingView

            Layout.fillHeight: true
            Layout.fillWidth: true

            focus: true

            pushEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 300
                }
            }

            pushExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 300
                }
            }

            popEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 300
                }
            }

            popExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 300
                }
            }

            initialItem: firstPage

            // Implements back key navigation
            Keys.onReleased: if (event.key === Qt.Key_Back && listingView.depth > 1) {
                                 listingView.pop();
                                 event.accepted = true;
                             }
        }
    }
}
