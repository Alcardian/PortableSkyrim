# PortableSkyrim
## Goal
The goal of this document is to create a guide for a modded Skyrim installation running on Linux that can easily be copied or moved to another PC.  
Tested on Arch Linux for the latest version of Skyrim (as of 2025-07-04).

## Assumptions
1. You are running on Arch Linux, or Arch-based distro.
2. You want to use Mod Organizer 2.

## Prerequisites
1. **Wine**: Install Wine and related tools.
   ```
   sudo pacman -S wine winetricks
   ```
2. **Skyrim**: Owning Skyrim through GOG. Can be brought from [GOG](https://www.gog.com/en/game/the_elder_scrolls_v_skyrim_anniversary_edition)
3. **Vulkan Support**: You have Vulkan support if the command below gives back a version.
   ```
    vulkaninfo | grep "Vulkan Instance Version"
   ```

## **1. Create a Portable Directory Structure**
To keep everything portable and organized, create a single folder for your *Skyrim* setup:
```bash
    mkdir -p ~/Games/Skyrim_Portable/{WinePrefix,MO2}
```
- `WinePrefix`: Will hold the virtual C: drive. This guide will install Skyrim in here at `C:\GOGO Games\Skyrim Anniversary Edition\`, not a hard requirement but you'll have to adapt commands from the guide to match your selected location.
- `MO2`: Will hold Mod Organizer 2.

## **2. Set Up a Separate Wine Prefix**
A Wine prefix is like a sandboxed Windows environment. We’ll create one specifically for Skyrim and MO2:
1. Run the following command to create and configure a new Wine prefix:
   ```bash
   WINEPREFIX=~/Games/Skyrim_Portable/WinePrefix winecfg
   ```
    - This opens a Wine configuration window. Ignore not finding wire-mono warning, Cancel.
    - Set the **Windows version** to **Windows 10** (click the dropdown, select “Windows 10,” then click “Apply” and “OK”).
    - This creates a virtual C: drive at `~/Games/Skyrim_Portable/WinePrefix/drive_c/`.
2. Install Dependencies with Winetricks into the prefix (Can download `wine-mono` through pacman instead, but it will be less portable, `sudo pacman -S wine-mono`).
   ```bash
   WINEPREFIX=~/Games/Skyrim_Portable/WinePrefix winetricks -q dotnet48 corefonts
   ```
   - This installs .NET Framework 4.8 and core fonts
   - This will take a while.


## **3. Installing Skyrim**
Installing Skyrim from GOG makes it more portable as it's not reliant on Steam DRM to run, and the game won't accidentally be updated if Bethesda releases another "update" to the game.  
**NOTE:** Copying the game from a previous installation without running the installer in the intended Wine prefix will result in menus like "Options" from "SkyrimSELauncher.exe", or sub-menus in mods once ingame from being displayed or interactable. **Run the installers instead and save yourself a headache, I learnt the hard way.**
1. On GOG's webpage, go to `Games`, and locate Skyrim.
2. Download all parts of the installer under `Download Offline Backup Game Installers`.
    - Do not use the `Download And Install Now` button, it uses the GOG Galaxy app which we don't want for a portable installation.
    - Save all parts under `~/Downloads`, or adapt the following instructions based on your choosen location.
3. Run the 3 exe-files in the following order (note that version number in name might differ) and let them install to default location(`C:\GOGO Games\Skyrim Anniversary Edition\`);
    - setup_the_elder_scrolls_v_skyrim_special_edition (Base game), `WINEPREFIX="$HOME/Games/Skyrim_Portable/WinePrefix" wine "$HOME/Downloads/setup_the_elder_scrolls_v_skyrim_special_edition_0.1.3905696_(64bit)_(70738).exe"`
    - patch_the_elder_scrolls_v_skyrim_special_edition (Game patches), `WINEPREFIX="$HOME/Games/Skyrim_Portable/WinePrefix" wine "$HOME/Downloads/patch_the_elder_scrolls_v_skyrim_special_edition_0.0.3895161_(70492)_to_0.1.3905696_(70738).exe"`
        - If the installer says "Update already applied", skip to next step.
    - setup_the_elder_scrolls_v_skyrim_anniversary_upgrade (Anniversary content), `WINEPREFIX="$HOME/Games/Skyrim_Portable/WinePrefix" wine "$HOME/Downloads/setup_the_elder_scrolls_v_skyrim_anniversary_upgrade_0.1.3905696_(64bit)_(70738).exe"`
4. Verify installation, run `WINEPREFIX="$HOME/Games/Skyrim_Portable/WinePrefix" wine "$HOME/Games/Skyrim_Portable/WinePrefix/drive_c/GOG Games/Skyrim Anniversary Edition/SkyrimSELauncher.exe"`
    - The command should launch Skyrim launcher, displaying; "PLAY", "OPTIONS", "SUPPORT" & "EXIT". Verify that all 4 of them are there.
    - If any of them are missing, like "OPTIONS", you've most likely not installed the game into the prefix or are running in a different prefix (should not happen if copying commands).
    - "EXIT" once, you've verified that they are all there.

## **4. Install SKSE64**
SKSE64, or Skyrim Script Extender 64(bit), is used by many mods.
1. Download SKSE64 from [skse.silverlock.org](https://skse.silverlock.org/)
    - Make sure to download "GOG Anniversary Edition build"
2. Extract the archive to a temporary folder.
3. Copy all files except the `src` folder, and the two txt documents to your Skyrim directory
    - Skyrim at `~/Games/Skyrim_Portable/WinePrefix/drive_c/GOG Games/Skyrim Anniversary Edition/`
4. Cleanup, delete the archive and temporary folder.


## **5. Install Mod Organizer 2**
1. Download the latest stable version of Mod Organizer 2 from [GitHub](https://github.com/ModOrganizer2/modorganizer/releases) or [Nexus Mods](https://www.nexusmods.com/skyrimspecialedition/mods/6194)
    - I picked `Mod.Organizer-2.5.2.7z` from GitHub to not have to run more exe-files than neccessary.
2. If you downloaded the archive, Extract the files directly into `~/Games/Skyrim_Portable/MO2/`, so `ModOrganizer.exe` is directly in that folder.
    - If you went with the exe instead, install it to `~/Games/Skyrim_Portable/MO2/`.
3. Launch MO2 using the custom Wine prefix:
   ```bash
   WINEPREFIX=~/Games/Skyrim_Portable/WinePrefix wine ~/Games/Skyrim_Portable/MO2/ModOrganizer.exe
   ```
4. MO2 will prompt you to configure it:
    - Choose **Portable** mode.
    - Set the **Game Path** to `C:\GOGO Games\Skyrim Anniversary Edition\` if MO2 didn't locate it on its own.
    - Select **Game Edition**, pick `GOG`
    - Set were the **Data** should be stored, `~/Games/Skyrim_Portable/MO2`.
    - MO2 will prompt you to login to your Nexus account.
        - Easiest way is to press the buttom to open a browser window.
        - Alternatively, you can get an Nexus API key for your account from [Nexus Mods API-keys](https://next.nexusmods.com/settings/api-keys).

## **6. Configure MO2 to Use SKSE64**
1. In MO2, click the **Executables** dropdown (top-left, looks like a gear or puzzle piece).
    - If you need to start it again, run `WINEPREFIX=~/Games/Skyrim_Portable/WinePrefix wine ~/Games/Skyrim_Portable/MO2/ModOrganizer.exe`
    - If SKSE is already in the dropdown, you can skip the remainng steps for SKSE64.
2. Click **Add** or the plus icon to add a new executable.
3. Set:
    - **Title**: “SKSE”
    - **Binary**: `C:\GOG Games\Skyrim Anniversary Edition\skse64_loader.exe`
    - **Start in**: `C:\GOG Games\Skyrim Anniversary Edition`
4. Click **OK** and set **SKSE** as the default in the dropdown.
5. Start the game through SKSE in MO2, if the game starts, exit, and close MO2.

## **7. Set Up Launch Script**
Set up a launch script for MO2 so you don't need to type the command manually each time.
1. Create a new script at `~/Games/Skyrim_Portable/` with name `Run_Skyrim.sh`.
2. Set its content to;
```bash
#!/bin/bash

# Set Wine prefix and run Mod Organizer 2 for Skyrim
WINEPREFIX="$HOME/Games/Skyrim_Portable/WinePrefix" wine "$HOME/Games/Skyrim_Portable/MO2/ModOrganizer.exe"

```
3. Verify that MO2 launches from the script.

## **8. Install DXVK In Your Wine Prefix**
Have MO2 closed (not running) before contuing.
1. **DXVK**: Install DXVK to translate DirectX calls to Vulkan.
   ```bash
   yay -S dxvk-bin
   ```
   Alternatively, you can download the latest DXVK release from [GitHub](https://github.com/doitsujin/dxvk/releases) and extract it manually.
2. **Install DXVK in Your Wine Prefix**
    - Run the following command to install DXVK into your custom Wine prefix:
      ```bash
      WINEPREFIX=~/Games/Skyrim_Portable/WinePrefix winetricks dxvk
      ```
        - This installs the necessary DXVK DLLs (`d3d9.dll`, `d3d10core.dll`, `d3d11.dll`) into your Wine prefix and configures the registry to use them.
        - If you manually downloaded DXVK, copy the DLLs (`d3d9.dll`, `d3d10core.dll`, `d3d11.dll`) to `~/Games/Skyrim_Portable/WinePrefix/drive_c/windows/system32/` and run:
          ```bash
          WINEPREFIX=~/Games/Skyrim_Portable/WinePrefix wine regsvr32 d3d9.dll
          WINEPREFIX=~/Games/Skyrim_Portable/WinePrefix wine regsvr32 d3d10core.dll
          WINEPREFIX=~/Games/Skyrim_Portable/WinePrefix wine regsvr32 d3d11.dll
          ```
3. **Verify DXVK Installation**
    - Launch Skyrim via MO2 (using SKSE64) to ensure DXVK is active:
      ```bash
      WINEPREFIX=~/Games/Skyrim_Portable/WinePrefix wine ~/Games/Skyrim_Portable/MO2/ModOrganizer.exe
      ```
    - Check for a DXVK HUD or logs to confirm Vulkan is in use:
        - Enable the DXVK HUD by setting an environment variable before launching MO2:
          ```bash
          WINEPREFIX=~/Games/Skyrim_Portable/WinePrefix DXVK_HUD=1 wine ~/Games/Skyrim_Portable/MO2/ModOrganizer.exe
          ```
          This displays FPS and Vulkan info in-game (launch Skyrim through SKSE).
        - Alternatively, check `~/.cache/dxvk` or `~/Games/Skyrim_Portable/WinePrefix` for DXVK logs (e.g., `dxvk.log`).

## **9. Install Mods**
1. Download mods from Nexus Mods or other sources as `.zip` or `.7z` files.
2. In MO2, click the **Install a new mod from an archive** button (folder icon with an arrow).
3. Select your mod file and follow the installer prompts (if any).
4. Enable the mod by checking its box in MO2’s left pane.
5. (Optional) Install LOOT via MO2 to sort your mod load order:
    - Download LOOT, extract it to `~/Games/Skyrim_Portable/MO2/tools/LOOT`.
    - Add `LOOT.exe` as an executable in MO2 and run it to sort mods.

### **Installing Pandora Behaviour Engine Plus (Optional)**
Pandora Behaviour Engine Plus requires .NET runtime version 9.0.6 (version can change), and that is lower than what we've installed already, or currently not included in `wine-mono`. We'll have to install it on our own for it to work.
1. Download `Pandora Behaviour Engine Plus` from [Nexus Mods](https://www.nexusmods.com/skyrimspecialedition/mods/133232) or [GitHub](https://github.com/Monitor221hz/Pandora-Behaviour-Engine-Plus)
2. Install and enable it like any mod.
3. On the right pane in MO2, click `Data`
    - Locate `Pandora Behaviour Engine+.exe`
    - Right-click, Add as Executable
    - `Pandora Behaviour Engine+` should now be available from the same dropdown as SKSE.
4. Try running `Pandora Behaviour Engine+`, and you'll be meet with an error message, telling you that you must install .NET Destop Runtime to run this application.
    - Click Yes to download the installer, `windowsdesktop-runtime-9.0.6-win-x64.exe`
        - Name/number might be different at the time of your installation.
    - Close MO2.
5. **Close MO2** if you haven't already.
6. Run `WINEPREFIX=~/Games/Skyrim_Portable/WinePrefix wine ~/Downloads/windowsdesktop-runtime-9.0.6-win-x64.exe`
    - Installer pops up, install.
7. Once installation of `windowsdesktop-runtime-9.0.6-win-x64.exe` is complete, launch MO2 again.
    - Verify that `Pandora Behaviour Engine+` now launches through MO2.
    - Note that `Pandora Behaviour Engine+` seem to register the mouse slightly lower than its posision on screen, easy to work around when you know.

### **Set Up Separate Mod as Output (Optional)**
For `Pandora Behaviour Engine Plus`
1. Click anywhere in the mod list in the left pane.
    - Select "All Mods" > "Create empty mod above"
    - Name it `Pandora Output`
    - Make sure **Pandora Behaviour Engine Plus** comes **first**, then **Pandora Output** **after** all animaltion mods.
        - Pandora Behaviour Engine Plus > animation mods > Pandora Output
2. Select `<Edit>` (where you see the executables in the dropdown, like SKSE, and Pandora Behaviour Engine Plus)
    - Select `Pandora Behaviour Engine Plus`.
    - Enable `Create file in mod instead of overwrite`
    - Select `Pandora Output`
