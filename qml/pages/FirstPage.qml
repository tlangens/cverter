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


Page {
    id: page

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
/*          PullDownMenu {
            MenuItem {
                text: "Choose"
                onClicked: {
                    var dialog = pageStack.push(quantitySelector)
                    //dialog.accepted.connect(function() {
                    //colorIndicator.color = dialog.color
                    //})
                }
            }
        }
*/



        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge



            PageHeader {
                title: "Storhet"
            }
            ValueButton {
                id: quantitySelector
                property string quantity: "Length"
                label: quantity
                onClicked: quantity = pageStack.push(quantityDialog)

            }


            // hit input stufa.
            Row {
                TextField {
                    id: input1
                    width: page.width - 200
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    validator: DoubleValidator {notation: "StandardNotation"}
                    onTextChanged: input2.text = text
                }

                ComboBox {
                    width: 200
                    menu: ContextMenu {
                        MenuItem { text: "option a" }
                        MenuItem { text: "option b" }
                        MenuItem { text: "option c" }
                        MenuItem { text: "option d" }
                        MenuItem { text: "option e" }
                        MenuItem { text: "option f" }
                        MenuItem { text: "option g" }
                        MenuItem { text: "option h" }
                    }
                }
            }

            Row {
                TextField {
                    id: input2
                    width: page.width - 200
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    validator: DoubleValidator {notation: "StandardNotation"}
                    onTextChanged: input1.text = text

                }

                ComboBox {
                    width: 200
                    menu: ContextMenu {
                        MenuItem { text: "option a" }
                        MenuItem { text: "option b" }
                        MenuItem { text: "option c" }
                        MenuItem { text: "option d" }
                        MenuItem { text: "option e" }
                        MenuItem { text: "option f" }
                        MenuItem { text: "option g" }
                        MenuItem { text: "option h" }
                    }
                }
            }

        }

        Dialog {
            id: quantityDialog
            DialogHeader { acceptText: selector.value }
            SilicaListView {
                id: selector
                width: parent.width
                height: parent.height
                property string value
                model: ListModel {
                    ListElement { quantity: "Length" }
                    ListElement { quantity: "Volume" }
                    ListElement { quantity: "Weight" }
                    ListElement { quantity: "Speed" }
                    ListElement { quantity: "Currency" }
                }
                delegate: ListItem {
                    width: ListView.view.width
                    height: Theme.itemSizeSmall
                    onClicked: selector.value = name
                    property string name: quantity
                    Label { text: name }

                }

            }
            onAccepted: quantitySelector.quantity = selector.value

        }
    }
}

