import json
import uiautomator2 as u2

device = u2.connect("RZCW316V69W")

ui_hierarchy = device.dump_hierarchy()

with open("ui_hierarchy.xml", "w") as outfile:
    outfile.write(ui_hierarchy)

print("UI hierarchy has been saved to ui_hierarchy.xml")
