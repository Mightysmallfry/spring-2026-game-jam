extends Control

@onready var interactPopup = $InteractPopup
@onready var interactLabel = $InteractPopup/MarginContainer/InteractLabel

func building_popup(building : BaseBuilding, action : String):
	# Set text
	interactLabel.text = action
	# Set offset, should be vertically above building
	
	# Show popup
	interactPopup.popup()

func hide_popup() -> void:
	interactPopup.hide()
