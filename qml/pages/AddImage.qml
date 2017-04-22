/*Copyright (c) 2017, Riku Lahtinen
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
import QtQuick.LocalStorage 2.0
import "components/tables.js" as Mytables

Page {
    id: page

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Delete image")
                enabled: !addMode
                onClicked: {
                    remorse.execute(qsTr("Deleting"), console.log("remorse") , 3000 )
                }
                RemorsePopup { id: remorse
                onTriggered: {
                    Mytables.deleteImage(currentIndex)
                    pageStack.pop()
                }
                }
            }
            MenuItem {
                text: qsTr("Add image")
                enabled: !tiitle.errorHighlight && !neimi.errorHighlight && !layer.errorHighlight && !latti.errorHighlight && !longi.errorHighlight && !zoomi.errorHighlight && !rotatio.errorHighlight && !opasiit.errorHighlight
                onClicked: {
                    latti.reNu = latti.text;
                    longi.reNu = longi.text;
                    layer.reNu = layer.text;
                    zoomi.reNu = zoomi.text;
                    rotatio.reNu = rotatio.text;
                    opasiit.reNu = opasiit.text;
                    imageInfo.append({"title":tiitle.text, "sourceim":neimi.text, "latti":latti.reNu, "longi":longi.reNu, "stackheight":layer.reNu, "zlevel":zoomi.reNu, "rotat":rotatio.reNu, "opacit":opasiit.reNu})
                    Mytables.addEditImage(currentIndex)
                }
            }
            MenuItem {
                text: qsTr("Show/hide help texts")
                onClicked: {
                    column.showHelptxt = !column.showHelptxt
                }
           }
        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingMedium
            PageHeader {
                title: qsTr("Add or edit image")
            }

            property bool showHelptxt : true

            /*BackgroundItem {
                SectionHeader {
                    text: qsTr("Image title")
                }
                onClicked: {}
            }*/

            Text {
                    text: qsTr("Project name is used to be able to manage multiple images related to same topic. A combination of project name and file name has to be unique. When editing values enter key has to be pressed to make confirm the changes")
                    width: page.width
                    wrapMode: Text.WordWrap
                    visible: column.showHelptxt
                    color: Theme.secondaryHighlightColor
                    x: Theme.paddingLarge
                }

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingMedium
                Text {
                    text: qsTr("Project")
                    color: Theme.secondaryHighlightColor
                    x: Theme.paddingLarge
                    width:page.width/3
                    wrapMode: Text.WordWrap
                }
            TextField {
                id: tiitle
                width: page.width/2
                text: currentIndex > imageInfo.count-1 ? "" : imageInfo.get(currentIndex).title
                validator: RegExpValidator { regExp: /^\S*$/}
                color: errorHighlight? "red" : Theme.primaryColor
                inputMethodHints: Qt.ImhNoPredictiveText
                EnterKey.enabled: !errorHighlight
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: {
                    //console.log(currentIndex)
                    focus = false
                    if (!addMode) {
                        imageInfo.setProperty(currentIndex,"title",text)
                        Mytables.addEditImage(currentIndex)
                    }
                }
            }
}
            /*BackgroundItem {
                SectionHeader {
                    text: qsTr("Image file info")
                }
                onClicked: {}
            }*/

            /*Text {
                    text: qsTr("File name is used as an index. ")
                    width: page.width
                    wrapMode: Text.WordWrap
                    visible: column.showHelptxt
                    color: Theme.secondaryHighlightColor
                    x: Theme.paddingLarge
                }*/

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingMedium

                Text {
                    text: qsTr("File name")
                    color: Theme.secondaryHighlightColor
                    x: Theme.paddingLarge
                    width:page.width/3
                    wrapMode: Text.WordWrap
                }

                TextField {
                    id: neimi
                    placeholderText: "img.svg"
                    text: currentIndex > imageInfo.count-1 ? "" : imageInfo.get(currentIndex).sourceim
                    width: page.width/2
                    //wrapMode:Text.WordWrap
                    validator: RegExpValidator { regExp: /^[^*&%\s]+$/}
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        if (!addMode) {
                            imageInfo.setProperty(currentIndex,"sourceim",text)
                            Mytables.addEditImage(currentIndex)
                        }
                    }
                }
            }

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingMedium

                Text {
                    text: qsTr("Layer")
                    color: Theme.secondaryHighlightColor
                    x: Theme.paddingLarge
                    width:page.width/3
                    wrapMode: Text.WordWrap
                }
                TextField {
                    //property real reNu
                    property int reNu
                    id: layer
                    placeholderText: "1"
                    text: currentIndex > imageInfo.count-1 ? "" : imageInfo.get(currentIndex).stackheight
                    width: page.width/2
                    validator: RegExpValidator { regExp: /^\d{1,100}$/ }
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        reNu = text
                        if (!addMode) {
                            imageInfo.setProperty(currentIndex,"stackheight",reNu)
                            Mytables.addEditImage(currentIndex)
                        }
                    }
                }
            }

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingMedium
                Text {
                    text: qsTr("Latitude")
                    color: Theme.secondaryHighlightColor
                    x: Theme.paddingLarge
                    width:page.width/3
                    wrapMode: Text.WordWrap
                }
                TextField {
                    property real reNu
                    id: latti
                    placeholderText: "63.1"
                    text: currentIndex > imageInfo.count-1 ? currentLat : imageInfo.get(currentIndex).latti
                    //text: currentIndex > imageInfo.count-1 ? "" : imageInfo.get(currentIndex).latti
                    width: page.width/2
                    validator: RegExpValidator { regExp: /^\-?\d?\d\.\d*$/ }
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        reNu = text;
                        if (!addMode) {
                            imageInfo.setProperty(currentIndex,"latti",reNu)
                            Mytables.addEditImage(currentIndex)
                        }
                    }
                }
            }

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingMedium
                Text {
                        text: qsTr("Longitude")
                        color: Theme.secondaryHighlightColor
                        x: Theme.paddingLarge
                        width: page.width/3
                    }

                TextField {
                    property real reNu
                    id: longi
                    placeholderText: "27.9"
                    //text: currentIndex > imageInfo.count-1 ? "" : imageInfo.get(currentIndex).longi
                    text: currentIndex > imageInfo.count-1 ? currentLong : imageInfo.get(currentIndex).longi
                    width: page.width/2
                    validator: RegExpValidator { regExp: /^\-?\d?\d?\d\.\d*$/ }
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        reNu = text;
                        if (!addMode) {
                            imageInfo.setProperty(currentIndex,"longi",reNu)
                            Mytables.addEditImage(currentIndex)
                        }
                    }
                }
            }

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingMedium
                Text {
                        text: qsTr("Zoom level")
                        color: Theme.secondaryHighlightColor
                        x: Theme.paddingLarge
                        width: page.width/3
                    }

                TextField {
                    property real reNu
                    id: zoomi
                    placeholderText: "16.0"
                    text: currentIndex > imageInfo.count-1 ? "" : imageInfo.get(currentIndex).zlevel
                    width: page.width/2
                    validator: RegExpValidator { regExp: /^\-?\d?\d?\d\.\d*$/ }
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        reNu = text;
                        if (!addMode) {
                            imageInfo.setProperty(currentIndex,"zlevel",reNu)
                            Mytables.addEditImage(currentIndex)
                        }
                    }
                }
            }

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingMedium
                Text {
                        text: qsTr("Rotation")
                        color: Theme.secondaryHighlightColor
                        x: Theme.paddingLarge
                        width: page.width/3
                    }

                TextField {
                    property real reNu
                    id: rotatio
                    placeholderText: "2.0"
                    text: currentIndex > imageInfo.count-1 ? "" : imageInfo.get(currentIndex).rotat
                    width: page.width/2
                    validator: RegExpValidator { regExp: /^(\-?\d?\d?\d\.\d*)|(\-?\d*)$/ }
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        reNu = text;
                        //console.log("addMode", addMode, currentIndex)
                        if (!addMode) {
                            imageInfo.setProperty(currentIndex,"rotat",reNu)
                            Mytables.addEditImage(currentIndex)
                        }

                    }
                }
            }

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingMedium
                Text {
                        text: qsTr("Opacity") + " [0-1]"
                        color: Theme.secondaryHighlightColor
                        x: Theme.paddingLarge
                        width: page.width/3
                    }

                TextField {
                    property real reNu
                    id: opasiit
                    placeholderText: "1.0"
                    text: currentIndex > imageInfo.count-1 ? "" : imageInfo.get(currentIndex).opacit
                    width: page.width/2
                    //validator: RegExpValidator { regExp: /^(\d\.\d*)|(1)|(0)$/ }
                    validator: RegExpValidator { regExp: /^(0)(\.\d*)|(1)|(0)$/ }
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        reNu = text;
                        if (!addMode) {
                            imageInfo.setProperty(currentIndex,"opacit",reNu)
                            Mytables.addEditImage(currentIndex)
                        }
                    }
                }
            }

            Component.onCompleted: {

            }


        }
    }
}


