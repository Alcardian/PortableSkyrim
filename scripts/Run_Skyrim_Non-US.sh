#!/bin/bash

# Store the current keyboard layout
CURRENT_LAYOUT=$(setxkbmap -query | grep layout | awk '{print $2}')

# Switch to US keyboard layout
setxkbmap us

# Set Wine prefix and run Mod Organizer 2 for Skyrim
WINEPREFIX="$HOME/Games/Skyrim_Portable/WinePrefix" wine "$HOME/Games/Skyrim_Portable/MO2/ModOrganizer.exe"

# Restore the original keyboard layout
setxkbmap "$CURRENT_LAYOUT"
