/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "pages"
import "pages/components/setting.js" as Mysettings

ApplicationWindow
{
    initialPage: Component { MapPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    property real currentLat // To record currentLat: of the mapcenter
    property real currentLong // To record currentLong: of the map center
    property real gpsLat // Current position, latitude
    property real gpsLong // Current position, longitude
    property int gpsUpdateRate : 3000
    property bool useLocation : true // When starting, GPS is used
    property bool gpsUpdateIdle : false // As default GPS is not updated when the app is idle
    property string folder : "$HOME/Pictures/" //Folder for layer images.
    property int currentIndex : -1 //Index telling the image to be edited
    property bool addMode : true
    property int dbVersion:2 //
    property bool showHelptxt : true //

    ListModel {
        id: imageInfo
        ListElement {
            title: "Test 2017"
            sourceim:"grid.png"
            latti:62.3695273
            longi:25.70485293
            stackheight: 10
            zlevel: 16.5
            rotat:45.0
            opacit:1.0
            widthscale:1.0
            heightscale:1.0
        }
        ListElement {
            title: "Test 2018"
            sourceim:"img_01_lay01.png"
            latti:62.7572
            longi:25.7628
            stackheight: 20
            zlevel:16.055
            rotat:-1.0
            opacit:0.6
            widthscale:1.0
            heightscale:1.0
        }
        ListElement {
            title: "Test 2018"
            sourceim:"img_01_lay01.svg"
            latti:62.7572
            longi:25.7628
            stackheight: 30
            zlevel:15.999
            rotat:-1.2
            opacit:0.8
            widthscale:1.0
            heightscale:1.0
        }
    }



    Component.onCompleted: {
        //Mysettings.loadSettings()
    }

}

