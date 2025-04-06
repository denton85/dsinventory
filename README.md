**This is DSInventory - Deadslap's Inventory**

Shoutout to **Nujank** for the inspiration and teaching me how to do stuff.

This is an extremely simple Inventory System for Godot (works in 4.4, not sure about earlier versions). Does not yet support Item Stacks (quantities of items in the same slot), for now it just holds one item 
per slot. Quantities will come at a later time.

Currently, the system should work if you follow these steps (also let me know if it doesn't work):

1. Pull the **DSInventory** folder into your own addons folder. It will need to be activated, and you may need to reload the project. 

2. In your main root scene (preferably the one that acts as the 3D world in your game, or current level) set DSGlobal.main to self in the _ready() function like this:
```
func _ready() -> void:
	DsGlobal.main = self
```
This will need to be on all current "levels" or 3D worlds.

3. In your Player scene, instantiate the **ItemDetect** node (control + shift + a, enable addons to see the ItemDetect node). 

ItemDetect will be an Area3D, so it will have a collision shape. In the example project, I added it as a child to the camera,
so the collision shape points where you are looking. It will detect items and handle pickups. The collision layer and mask for item detection is layer 8, but that should already be there since it is an instantiated scene. It can technically go anywhere on the Player, but it depends on how you want to do it. 

![instantiate](https://github.com/user-attachments/assets/7027c78f-503a-4c8e-8ccb-28dbff0e4c99)


4. Also add the **Inventory node** as direct child of the player node (doesn't need to be instantiated, just hit the plus symbol and search for Inventory).

The Inventory node should be a **direct** child of the Player.

5. Set the **ItemDetect** exported variable **"Inventory"** to be your **Inventory node**.

![itemdetectsnip](https://github.com/user-attachments/assets/b5f51db8-8265-4c9a-b905-1c947f7f9e58)

6. Set your **"Inventory Size"** variable in the **Inventory node** to be the amount of slots you want. It defaults to 12.

![inventorysize](https://github.com/user-attachments/assets/f029c7b4-4313-4278-9075-6fab3246e174)

   
7. **Instantiate the InventoryUI node as a direct child to your Player** (control + shift + a, **enable addons** to see the InventoryUI node). Add a new Node3D (call it DropLocation or something) to your Player. It can be anywhere, but I placed
it under the camera so it rotates to always be in front of the Player. This will be where items spawn when you drop them from the inventory. In the **InventoryUI** node, select that **drop location Node3D** for the
"Drop Location" exported variable.

![uisnip](https://github.com/user-attachments/assets/e93f8c31-ec95-45c6-a27c-0d19ca5f8ba1)


Your Player Tree should look something like this:

![playertree](https://github.com/user-attachments/assets/1543666e-7011-4a6f-ae70-7db96f99526e)


8. **Instantiate** a few **ItemScene nodes** in your Main scene (control + shift + a, with addons enabled still). The test item resources (found in the DSInventory/Items folder, called pistol.tres and rifle.tres) can be dragged into the "Item" exported variable, and will
update in real time in the editor. You should see the mesh appear.

9. **Add these input actions to your Project Settings>Input Map**. **"right_click"** and **"left_click"** set to the mouse buttons of course. **"toggle_inventory"**, **"pickup"**, **"drop_item"** can all be set to whatever you want. "drop_item" is just a
hotkey for when you hover over an item and want to drop it, "right_click" is for opening the UI to drop an item by clicking a button. You can expand this UI if you are more functionality to the menu. 

Your main scene tree might look like this:
![maintree](https://github.com/user-attachments/assets/42e7f566-3d54-46a9-991d-a99336c9f93a)


In general, the UI is just a mockup, mess around with it. Quantities are not added yet (the variables are there, but no logic to handle them yet).

TODO: 
	1. Add Quantities/Stack Sizes to items
	2. Make initial setup/updating easier
	3. Custom Item Types?
