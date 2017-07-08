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
import "./components/setting.js" as Mysettings
import "components/tables.js" as Mytables


Page {
    id: page
    onStatusChanged: {
        Mysettings.loadSettings()
        gpsUpdateIdleLeft = gpsUpdateIdle
        //console.log("status", gpsUpdateIdle, gpsUpdateIdleLeft)
        Mytables.loadImages();
        Mytables.loadNotes();
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
                        id:patchedImage
                        source:folder + sourceim
                        opacity:opacit
                        rotation:rotat
                        MouseArea {
                            anchors.fill: parent
                            enabled: editIcon.editPossible
                            onClicked: {
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
                    Component.onCompleted: {
                        patchedImage.width = patchedImage.width*widthscale
                        patchedImage.height= patchedImage.height*heightscale

                    }
                }
            }

            /*MapCircle {
                //id: lamDirOne
                color: "red"
                border.color: Qt.darker(color);
                border.width: 3
                radius:20.0
                opacity: 1.0
                z:40
                center: QtPositioning.coordinate(gpsLat,gpsLong)
            }*/

            MapQuickItem {
                //id: marker
                anchorPoint.x: image.width/2
                anchorPoint.y: image.height/2
                coordinate: QtPositioning.coordinate(gpsLat,gpsLong)

                sourceItem: Image {
                    id: image
                    height: Screen.width/22
                    width: Screen.width/22
                    source: "./components/red.png"
                }
            }


            MapPolyline {
                id:trackLine
                line.width: 5
                line.color: 'red'
                z:60
                path: []
            }

            /// Notes section

            MapItemView {
                id:notes
                model:notesInfo
                delegate: notesComponent
            }

            Component {
                id: notesComponent

                MapQuickItem {
                    //id:notesTex
                    sourceItem: Text{
                        text: noteTitle
                        color:"black"
                        font.bold: true
                        //font.pixelSize: Theme.fontSizeLarge
                        font.pixelSize: fonnt
                        MouseArea {
                            anchors.fill: parent
                            //enabled: editIcon.editPossible
                            onClicked: {
                                currentIndex = index
                                //addMode = false
                                currentLat = map.center.latitude
                                currentLong = map.center.longitude
                                pageStack.push(Qt.resolvedUrl("AddNote.qml"))
                            }
                        }

                    }
                    zoomLevel: 13.0
                    z:80
                    coordinate: QtPositioning.coordinate(latti,longi)
                    //anchorPoint: Qt.point(velTex.sourceItem.width * 0.5,velTex.sourceItem.height * 0.5)
                }
            }


            PositionSource {
                id:possut
                active:useLocation && (Qt.application.active || gpsUpdateIdleLeft > 0)
                updateInterval:gpsUpdateRate
                onPositionChanged: {
                    gpsLat = possut.position.coordinate.latitude
                    gpsLong = possut.position.coordinate.longitude
                    trackLine.addCoordinate(QtPositioning.coordinate(gpsLat, gpsLong))
                    Qt.application.active ? gpsUpdateIdleLeft = gpsUpdateIdle : ""
                }
            }
        }


    }





    Timer
    {
        running: gpsUpdateIdleLeft > 0
        repeat:true
        interval: 60000
        onTriggered: {
            gpsUpdateIdleLeft = gpsUpdateIdleLeft - 1
        }
    }


    Text{
        font.pixelSize: Theme.fontSizeSmall
        text: qsTr("Map data") + " © " + "<a href=\'http://www.openstreetmap.org/copyright\'>OpenStreetMap</a> " + qsTr("contributors")
        anchors.bottom : page.bottom
        onLinkActivated: Qt.openUrlExternally(link)
    }



    Image {
        anchors.verticalCenter: rect.verticalCenter
        anchors.horizontalCenter: rect.horizontalCenter
        height: Screen.width/20
        width: Screen.width/20
        source: "./components/center.png"
    }





    ////////////////////////////
    /// Icons Section
    ///////////////////////////////


    IconButton {
        id: listIcon
        anchors.bottom: page.bottom
        anchors.right: page.right
        icon.source: "image://theme/icon-m-menu?" + "black"
        onClicked: {
            iconsVisible = !iconsVisible
            Mysettings.saveSettings()
        }
    }

    IconButton {
        id:gpsIcon
        anchors.bottom: listIcon.top
        anchors.right: page.right
        icon.source: "image://theme/icon-m-gps?" + (useLocation ? "black" : "red")
        onClicked: {
            if (useLocation) {
                map.center.latitude = gpsLat
                map.center.longitude = gpsLong
            }
            else {}
        }
    }

    IconButton {
        id:addNote
        anchors.bottom: gpsIcon.top
        anchors.right: page.right
        icon.source: "image://theme/icon-m-note?" + "black"
        onClicked: {
            currentIndex = notesInfo.count;
            currentLat = map.center.latitude
            currentLong = map.center.longitude
            pageStack.push(Qt.resolvedUrl("AddNote.qml"))

        }
    }

    IconButton {
        id: settingsIcon
        visible: iconsVisible
        anchors.bottom: addNote.top
        anchors.right: page.right
        icon.source: "image://theme/icon-m-developer-mode?" + "black"
        onClicked: {
            pageStack.push(Qt.resolvedUrl("Settings.qml"))
        }
    }

    IconButton {
        id: deleteTrackIcon
        visible: iconsVisible
        anchors.bottom: settingsIcon.top
        anchors.right: page.right
        icon.source: "image://theme/icon-m-delete?" + "black"
        onClicked: {
            trackLine.path = []
        }
    }

    IconButton {
        id: imageIcon
        visible: iconsVisible
        anchors.bottom: deleteTrackIcon.top
        anchors.right: page.right
        icon.source: "image://theme/icon-m-image?" + "black"
        onClicked: {
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
        visible: iconsVisible
        anchors.bottom: imageIcon.top
        anchors.right: page.right
        icon.source: editPossible ? "image://theme/icon-m-edit-selected?" + "black"
                                  : "image://theme/icon-m-edit?" + "black"
        onClicked: {
            editPossible = !editPossible
        }
    }

    IconButton {
        id: helpIcon
        visible: iconsVisible
        anchors.bottom: editIcon.top
        anchors.right: page.right
        icon.source: "image://theme/icon-m-question?" + "black"
        onClicked: {
            pageStack.push(Qt.resolvedUrl("Help.qml"))
        }
    }

    IconButton {
        id: aboutIcon
        visible: iconsVisible
        anchors.bottom: helpIcon.top
        anchors.right: page.right
        icon.source: "image://theme/icon-m-about?" + "black"
        onClicked: {
            pageStack.push(Qt.resolvedUrl("About.qml"))
        }
    }

    Component.onCompleted: {
        map.center = QtPositioning.coordinate(62.3695273+0.01,25.70485293+0.01)
        map.center = QtPositioning.coordinate(62.3695273,25.70485293)
    }
}


