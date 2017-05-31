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
import "./components/setting.js" as Mysettings
import "components/tables.js" as Mytables

Page {
    id: page

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Delete a note")
                //enabled: !addMode
                onClicked: {
                    remorse.execute(qsTr("Deleting"), console.log("remorse") , 3000 )
                }
                RemorsePopup { id: remorse
                    onTriggered: {
                        Mytables.deleteNote(currentIndex)
                        pageStack.pop()
                    }
                }
            }
            MenuItem {
                text: qsTr("Add a note")
                enabled: !tiitle.errorHighlight && !note.errorHighlight && !layer.errorHighlight && !latti.errorHighlight && !longi.errorHighlight && !fonnt.errorHighlight && !opasiit.errorHighlight
                onClicked: {
                    latti.reNu = latti.text;
                    longi.reNu = longi.text;
                    layer.reNu = layer.text;
                    fonnt.reNu = fonnt.text;
                    noteFontSize = fonnt.reNu;
                    opasiit.reNu = opasiit.text;
                    notesInfo.append({"title":tiitle.text, "noteTitle":noteTitle.text, "note":note.text, "latti":latti.reNu, "longi":longi.reNu, "stackheight":layer.reNu, "fonnt":fonnt.reNu, "opacit":opasiit.reNu})
                    Mytables.addEditNote(currentIndex);
                    Mysettings.saveSettings();
                }
            }
            MenuItem {
                text: qsTr("Show/hide help texts")
                onClicked: {
                    showHelptxt = !showHelptxt;
                    Mysettings.saveSettings();
                }
            }
        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingMedium
            PageHeader {
                title: qsTr("Add or edit a note")
            }

            Text {
                text: qsTr("Layer, latitude and longitude combination has to be unique. If the same combination is added the old info is substituted.")
                width: page.width*0.9
                wrapMode: Text.WordWrap
                visible: showHelptxt
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
                    text: currentIndex > notesInfo.count-1 ? "" : notesInfo.get(currentIndex).title
                    validator: RegExpValidator { regExp: /^\S*$/}
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        if (currentIndex < notesInfo.count) { // If editing note, the changes are saved immediately
                            notesInfo.setProperty(currentIndex,"title",text)
                            Mytables.addEditNote(currentIndex)
                        }
                    }
                }
            }

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingMedium
                Text {
                    text: qsTr("Note title")
                    color: Theme.secondaryHighlightColor
                    x: Theme.paddingLarge
                    width:page.width/3
                    wrapMode: Text.WordWrap
                }
                TextField {
                    id: noteTitle
                    width: page.width/2
                    text: currentIndex > notesInfo.count-1 ? "" : notesInfo.get(currentIndex).noteTitle
                    validator: RegExpValidator { regExp: /^\S*$/}
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        if (currentIndex < notesInfo.count) { // If editing note, the changes are saved immediately
                            notesInfo.setProperty(currentIndex,"noteTitle",text)
                            Mytables.addEditNote(currentIndex)
                        }
                    }
                }
            }

            Text {
                    text: qsTr("Note")
                    color: Theme.secondaryHighlightColor
                    x: Theme.paddingLarge
                    width:page.width/3
                    wrapMode: Text.WordWrap
                }

                TextArea {
                    id: note
                    placeholderText: qsTr("My note")
                    text: currentIndex > notesInfo.count-1 ? "" : notesInfo.get(currentIndex).note
                    width: page.width
                    wrapMode:Text.WordWrap
                    //validator: RegExpValidator { regExp: /^[^*&%\s]+$/}
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        if (currentIndex < notesInfo.count) {
                            notesInfo.setProperty(currentIndex,"note",text)
                            Mytables.addEditNote(currentIndex)
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
                    text: currentIndex > notesInfo.count-1 ? 100 : notesInfo.get(currentIndex).stackheight
                    width: page.width/2
                    validator: RegExpValidator { regExp: /^\d{1,100}$/ }
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        reNu = text
                        if (currentIndex < notesInfo.count) {
                            notesInfo.setProperty(currentIndex,"stackheight",reNu)
                            Mytables.addEditNote(currentIndex)
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
                    text: currentIndex > notesInfo.count-1 ? currentLat : notesInfo.get(currentIndex).latti
                    //text: currentIndex > notesInfo.count-1 ? "" : notesInfo.get(currentIndex).latti
                    width: page.width/2
                    validator: RegExpValidator { regExp: /^\-?\d?\d\.\d*$/ }
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        reNu = text;
                        if (currentIndex < notesInfo.count) {
                            notesInfo.setProperty(currentIndex,"latti",reNu)
                            Mytables.addEditNote(currentIndex)
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
                    //text: currentIndex > notesInfo.count-1 ? "" : notesInfo.get(currentIndex).longi
                    text: currentIndex > notesInfo.count-1 ? currentLong : notesInfo.get(currentIndex).longi
                    width: page.width/2
                    validator: RegExpValidator { regExp: /^\-?\d?\d?\d\.\d*$/ }
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        reNu = text;
                        if (currentIndex < notesInfo.count) {
                            notesInfo.setProperty(currentIndex,"longi",reNu)
                            Mytables.addEditNote(currentIndex)
                        }
                    }
                }
            }

            Button {
                text: qsTr("Current location")
                anchors.horizontalCenter: parent.horizontalCenter
                enabled:useLocation
                onClicked: {
                    latti.text = gpsLat;
                    latti.reNu = latti.text;
                    longi.text = gpsLong;
                    longi.reNu = longi.text;
                    if (currentIndex < notesInfo.count) {
                        notesInfo.setProperty(currentIndex,"latti",latti.reNu);
                        notesInfo.setProperty(currentIndex,"longi",longi.reNu)
                        Mytables.addEditNote(currentIndex)
                    }
                }
            }

            Row {
                x: Theme.paddingLarge
                spacing: Theme.paddingMedium
                Text {
                    text: qsTr("Font size")
                    color: Theme.secondaryHighlightColor
                    x: Theme.paddingLarge
                    width: page.width/3
                }

                TextField {
                    property real reNu
                    id: fonnt
                    placeholderText: "24"
                    text: currentIndex > notesInfo.count-1 ? noteFontSize : notesInfo.get(currentIndex).fonnt
                    width: page.width/2
                    validator: RegExpValidator { regExp: /^[1-9]\d?\d?\d?$/ }
                    color: errorHighlight? "red" : Theme.primaryColor
                    inputMethodHints: Qt.ImhNoPredictiveText
                    EnterKey.enabled: !errorHighlight
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: {
                        focus = false
                        reNu = text;
                        if (currentIndex < notesInfo.count) {
                            notesInfo.setProperty(currentIndex,"fonnt",reNu)
                            Mytables.addEditNote(currentIndex)
                            Mysettings.saveSettings();
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
                    text: currentIndex > notesInfo.count-1 ? 1 : notesInfo.get(currentIndex).opacit
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
                        if (currentIndex < notesInfo.count) {
                            notesInfo.setProperty(currentIndex,"opacit",reNu)
                            Mytables.addEditNote(currentIndex)
                        }
                    }
                }
            }



            Component.onCompleted: {

            }


        }
    }
}


