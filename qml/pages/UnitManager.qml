import QtQuick 2.0
import Sailfish.Silica 1.0
import "storage.js" as Storage


Page {

	id: page

	function populateQuantityList(source, target) {
		target.clear()
		for (var i = 0; i < source.rows.length; i++) {
			target.append({"name": source.rows.item(i).quantity})
		}
	}

	SilicaFlickable{

		anchors.fill: parent
		contentHeight: column.height

		Column {
			id: column
			width: page.width
			//spacing: Theme.paddingLarge

			PageHeader { title: "Manage" }


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
			}

			Separator{
				id: separator
				anchors.top: quantitySelector.bottom
			}

			SilicaListView {
				anchors.top: separator.bottom
				height: column.height
				//spacing: Theme.paddingLarge
				model: ListModel {
					ListElement { fruit: "jackfruit" }
					ListElement { fruit: "orange" }
					ListElement { fruit: "lemon" }
					ListElement { fruit: "lychee" }
					ListElement { fruit: "apricots" }
				}
				delegate: ListItem {
					width: ListView.view.width
					height: Theme.ItemSizeSmall

					Label {
						text: fruit
						x: Theme.paddingLarge
						anchors.verticalCenter: parent.verticalCenter
					}
				}
			}

		}
	}
}
