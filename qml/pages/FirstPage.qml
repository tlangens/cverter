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
import "storage.js" as Storage


Page {
	id: page

	function addUnit(title, value) {
		Storage.setUnit(title, value)
	}

	function getUnit(title) {
		Storage.getValue(title)
	}

	function populateQuantityList(source, target) {
		target.clear()
		for (var i = 0; i < source.rows.length; i++) {
			target.append({"name": source.rows.item(i).quantity})
		}
	}

	function populateUnitList(source, target) {
		target.clear()
		for (var i = 0; i < source.rows.length; i++) {
			target.append({"name": source.rows.item(i).name})
		}
	}

	function convert(target) {
		switch (target) {
			case 1:
				input1.text = (input2.text / input2.ratio) * input1.ratio
				break
			case 2:
				input2.text = (input1.text / input1.ratio) * input2.ratio
				break
			default:
				break
		}
	}

	Component.onCompleted: {
		Storage.initialize();
/*        fillModel1("Meters", 1.0);
		fillModel1("Feet", 3.28084);
		fillModel1("Inches", 39.3701);

		fillModel2("Meters", 1.0);
		fillModel2("Feet", 3.28084);
		fillModel2("Inches", 39.3701);

*/

		Storage.setUnit("Meters", "Length", 1.0);
		Storage.setUnit("Feet", "Length", 3.28084);
		Storage.setUnit("Inches","Length", 39.3701);
		Storage.setUnit("Kilograms", "Weight", 1.0)
		Storage.setUnit("Pounds", "Weight", 2.20462)
		Storage.setUnit("Bar", "Pressure", 1.0)
		Storage.setUnit("PSI", "Pressure", 14.5037738)
		Storage.setUnit("Nautical Miles", "Length", 1.0/1852.0)
		//populateUnitList(listModel1)
		//populateUnitList(listModel2)
		//Storage.dropTable()

		//input1.text = 1
		//convert(2)
	}

	// To enable PullDownMenu, place our content in a SilicaFlickable
	SilicaFlickable {
		anchors.fill: parent

		// PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
		  PullDownMenu {
			MenuItem {
				text: "Manage Units and Quantities"
				onClicked: {
					pageStack.push("UnitManager.qml")
					//dialog.accepted.connect(function() {
					//colorIndicator.color = dialog.color
					//})
				}
			}
		}


		// Tell SilicaFlickable the height of its content.
		contentHeight: column.height


		// Place our content in a Column.  The PageHeader is always placed at the top
		// of the page, followed by our content.
		Column {

			id: column
			width: page.width
			spacing: Theme.paddingLarge

			PageHeader { title: "Unit Converter" }

			ComboBox {
				id: quantitySelector
				menu: ContextMenu {
					Repeater {
						model: ListModel {
							id: quantityListModel
							Component.onCompleted: populateQuantityList(Storage.getQuantities(), quantityListModel)
						}
						MenuItem {
							text: model.name
						}
					}
				}
				onValueChanged: {
					populateUnitList(Storage.getUnits(value), listModel1)
					populateUnitList(Storage.getUnits(value), listModel2)
				}
			}


			// hit input stufa.
			Row {
				id: input1
				property double ratio
				property alias text: textfield1.text
				TextField {
					id: textfield1
					width: page.width - 200
					inputMethodHints: Qt.ImhFormattedNumbersOnly
					validator: DoubleValidator {notation: "StandardNotation"}
					onTextChanged: if(focus) { convert(2) }
					onFocusChanged: if(focus) {selectAll()}
				}

				ComboBox {
					id: combo1
					width: 200
					menu: ContextMenu {
						Repeater {
							model: ListModel { id: listModel1 }
							MenuItem { text: model.name }
						}
					}
					onValueChanged: {
						input1.ratio = Storage.getValue(value)
						convert(1)
					}
				}
			}

			Row {
				id: input2
				property double ratio
				property alias text: textfield2.text
				TextField {
					id: textfield2
					width: page.width - 200
					inputMethodHints: Qt.ImhFormattedNumbersOnly
					validator: DoubleValidator {notation: "StandardNotation"}
					onTextChanged: if(focus) { convert(1) }
					onFocusChanged: if(focus) {selectAll()}
				}

				ComboBox {
					id: combo2
					width: 200
					menu: ContextMenu {
						Repeater {
							model: ListModel { id: listModel2 }
							MenuItem { text: model.name }
						}
					}
					onValueChanged: {
						input2.ratio = Storage.getValue(value)
						convert(2)
					}
				}
			}
		}
	}
}


