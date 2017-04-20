/*Copyright (c) 2016-2017, Riku Lahtinen, rikul.lajolla@kiu.as
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtPositioning 5.2
//import QtQuick.XmlListModel 2.0
import QtLocation 5.0
import QtQuick.LocalStorage 2.0
import "components/tables.js" as Mytables


Page {
    id: page
    onStatusChanged: {
        /*if (searchDone) {
            map.center = QtPositioning.coordinate(searchLatti+0.01, searchLongi+0.01)
            map.center = QtPositioning.coordinate(searchLatti, searchLongi)
            map.zoomLevel = 14.5
            searchDone = false*/
        //}

        //map.center = QtPositioning.coordinate(62.3695273+0.01,25.70485293+0.01)
        //map.center = QtPositioning.coordinate(62.3695273,25.70485293)
        //console.log("load images")
        Mytables.loadImages()
    }

    Location {
        id: currentPosition
        coordinate: QtPositioning.coordinate(-27.5, 153.1) }

    Label {
        id: lblPosition
        text: "current position: " + currentPosition.coordinate
        font.pixelSize: Theme.fontSizeSmall
    }

    Rectangle {
        id:rect
        anchors.top: lblPosition.bottom
        anchors.fill: parent

        Map {
            id: map
            anchors.fill: parent
            zoomLevel: (maximumZoomLevel - minimumZoomLevel)/2 + 4.5
            plugin : Plugin {
                name: "osm"
                PluginParameter { name: "osm.mapping.copyright"; value: "© <a href=\"http://www.openstreetmap.org/copyright\">OpenStreetMap</a> contributors" }
            }
            center: QtPositioning.coordinate(62.3695273,25.70485293)
            gesture.enabled: true

            MapItemView {
                id:imageLayer
                model:imageInfo
                delegate: mapComponent
            }

            Component {
                id: mapComponent

                MapQuickItem {
                    id:velTex
                    sourceItem:
                        Image{
                        source:folder + sourceim
                        opacity:opacit
                        rotation:rotat
                       MouseArea {
                           anchors.fill: parent
                           enabled: editIcon.editPossible
                           onClicked: {
                               //console.log("index", index)
                               currentIndex = index
                               addMode = false
                               pageStack.push(Qt.resolvedUrl("AddImage.qml"))
                           }
                       }
                    }
                    zoomLevel: zlevel
                    z:stackheight
                    coordinate: QtPositioning.coordinate(latti,longi)
                    //anchorPoint: Qt.point(velTex.sourceItem.width * 0.5,velTex.sourceItem.height * 0.5)
                    //anchorPoint: Qt.point(0.0,0.0)
                }
            }

            MapPolyline {
                id:trackLine
                line.width: 5
                line.color: 'red'
                z:60
                path: []
                /*path: [
                    { latitude: 62.38, longitude: 25.3 },
                    { latitude: 62.38, longitude: 25.5 },
                    { latitude: 62.34, longitude: 25.7 },
                    { latitude: 62.34, longitude: 25.9 }
                ]*/
            }

            PositionSource {
                id:possut
                active:useLocation && (Qt.application.active || gpsUpdateIdle)
                updateInterval:gpsUpdateRate
                onPositionChanged: {
                    gpsLat = possut.position.coordinate.latitude
                    gpsLong = possut.position.coordinate.longitude
                    //currentLat = map.center.latitude
                    //currentLong = map.center.longitude
                    trackLine.addCoordinate(QtPositioning.coordinate(gpsLat, gpsLong))
                    //console.log(trackLine.path)
                }
            }


        }

    }


    Text{
            font.pixelSize: Theme.fontSizeSmall
            text: qsTr("Map data") + " © " + "<a href=\'http://www.openstreetmap.org/copyright\'>OpenStreetMap</a> " + qsTr("contributors")
            anchors.bottom : page.bottom
            onLinkActivated: Qt.openUrlExternally(link)
        }

    ////////////////////////////
    /// Icons Section
    ///////////////////////////////


    IconButton {
        id:gpsIcon
        anchors.bottom: page.bottom
        anchors.right: page.right
        icon.source: "image://theme/icon-m-gps?" + (useLocation ? (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.secondaryHighlightColor): "red")
        onClicked: {
            if (useLocation) {
            map.center.latitude = gpsLat
            map.center.longitude = gpsLong
            }
            else {}
            }
    }

    IconButton {
        id: settingsIcon
        anchors.bottom: gpsIcon.top
        anchors.right: page.right
        icon.source: "image://theme/icon-m-developer-mode?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.secondaryHighlightColor)
        onClicked: {
            pageStack.push(Qt.resolvedUrl("Settings.qml"))

        }
    }

    IconButton {
        id: deleteTrackIcon
        anchors.bottom: settingsIcon.top
        anchors.right: page.right
        icon.source: "image://theme/icon-m-delete?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.secondaryHighlightColor)
        onClicked: {
            //console.log("delete track", trackLine.path)
            trackLine.path = []
        }
    }

    IconButton {
        id: imageIcon
        anchors.bottom: deleteTrackIcon.top
        anchors.right: page.right
        icon.source: "image://theme/icon-m-image?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.secondaryHighlightColor)
        onClicked: {
            //console.log("test")
            //pageStack.push(Qt.resolvedUrl("AddImage.qml"),{ "coordinate": map.center})
            addMode = true
            currentIndex = imageInfo.count;
            currentLat = map.center.latitude
            currentLong = map.center.longitude
            pageStack.push(Qt.resolvedUrl("AddImage.qml"))
        }
    }

    IconButton {
        id: editIcon
        property bool editPossible: false
        anchors.bottom: imageIcon.top
        anchors.right: page.right
        icon.source: "image://theme/icon-m-edit?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.secondaryHighlightColor)
        onClicked: {
            editPossible = !editPossible
        }
    }

    IconButton {
        id: helpIcon
        anchors.bottom: editIcon.top
        anchors.right: page.right
        icon.source: "image://theme/icon-m-question?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.secondaryHighlightColor)
        onClicked: {
            pageStack.push(Qt.resolvedUrl("Help.qml"))
        }
    }

    IconButton {
        id: aboutIcon
        anchors.bottom: helpIcon.top
        anchors.right: page.right
        icon.source: "image://theme/icon-m-about?" + (pressed
                                                    ? Theme.highlightColor
                                                    : Theme.secondaryHighlightColor)
        onClicked: {
            pageStack.push(Qt.resolvedUrl("About.qml"))
        }
    }

    Component.onCompleted: {
        map.center = QtPositioning.coordinate(62.3695273+0.01,25.70485293+0.01)
        map.center = QtPositioning.coordinate(62.3695273,25.70485293)
        //currentLat = map.center.latitude
        //currentLong = map.center.longitude
    }
}


