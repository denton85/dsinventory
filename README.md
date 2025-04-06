This is DSInventory - Deadslap's Inventory

Shoutout to Nujank for the inspiration and teaching me how to do stuff.

This is an extremely simple Inventory System for Godot (works in 4.4, not sure about earlier versions). Does not yet support Item Stacks (quantities of items in the same slot), for now it just holds one item 
per slot. Quantities will come at a later time.

Currently, the system should work if you follow these steps (also let me know if it doesn't work):

1. Pull the DSInventory folder into your own addons folder. It does not need to be activated. Set the DSGlobal script to an autoload in your editor: Project>Project Settings>Globals.
This will probably change since this Global script is only used once, but whatever.

2. In your main root scene (preferably the one that acts as the 3D world in your game, or current level) set DSGlobal.main to self in the _ready() function like this:
```
func _ready() -> void:
	  DsGlobal.main = self
```
This will need to be on all current "levels" or 3D worlds.

3. In your Player scene, add the two new custom nodes: ItemDetect and Inventory. ItemDetect will be an Area3D, so it will need a collision shape. In the example project, I added it as a child to the camera,
so the collision shape points where you are looking. It will detect items and handle pickups. It can technically go anywhere on the Player, but it depends on how you want to do it. The Inventory node, however,
should be a direct child of the Player.

4. Set the ItemDetect exported variable "Inventory" to be your Inventory node. Set your "Inventory Size" variable in the Inventory node to be the amount of slots you want. It defaults to 12.
   
5. Add the InventoryUI scene (located in DSInventory/Inventory folder) as a direct child to your Player. Add a new Node3D (call it drop location or something) to your Player. It can be anywhere, but I placed
it under the camera so it rotates to always be in front of the Player. This will be where items spawn when you drop them from the inventory. In the InventoryUI node, select that drop location Node3D for the
"Drop Location" exported variable.

6. Add a few ItemScenes (found in DSInventory/Inventory folder, called item_scene.tscn) to your main scene. The test item resources (found in the DSInventory/Items folder, called pistol.tres and rifle.tres) can be dragged into the "Item" exported variable, and will
update in real time in the editor. You should see the mesh appear.

7. Add these input actions to your Project Settings>Input Map. "right_click" - set to right click of course. "toggle_inventory", "pickup", "drop_item" can all be set to whatever you want. "drop_item" is just a
hotkey for when you hover over an item and want to drop it, "right_click" is for opening the UI to drop an item by clicking a button. You can expand this UI if you are more functionality to the menu. 

In general, the UI is just a mockup, mess around with it. Quantities are not added yet (the variables are there, but no logic to handle them yet).
