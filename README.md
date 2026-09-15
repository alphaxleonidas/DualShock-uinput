# Disclaimer

The original repo was made by ChatGPT but this fork has been modified using Copilot. Sorry if it's messy. 

This fork has been modified for multicontroller support and hotplugging. 

# Description

I wanted a tool that works systemwide for any game so I don't always have to rely on SteamInput/Bottles/Lutris. Works wired and via Bluetooth. Works for PS4 and PS5 controller.

It in general reads the raw input from the PS controllers and sends it as a virtual controller in uinput (xinput), which I needed especially in older games which don't support DirectInput at all.

~~**It only works for one active controller!**~~

**It works with multiple active controllers. Tested on two.**



## Requirements
### packages
- python3
- python3-dev
- python3-venv
- python3-pyudev (for hotplug support)
### pip
- python_uinput
- evdev
### system
- bluetoothctl
  - for disconnecting the controller via (PS + Start) combination
### dependency installation
<details> <summary> Debian </summary>
  
```
sudo apt update
sudo apt install python3-dev python3-venv python3-pyudev
```

</details>

<details> <summary> Fedora</summary>

```
sudo dnf upgrade --refresh
sudo dnf install python3 python3-pip python3-pyudev sbctl zstd
```

</details>

<details><summary> Arch </summary> 

```
sudo pacman -S python python-pip python-pyudev
```
  
</details>

# Installation 

<details> <summary>Regular distros </summary>  

  
  Clone repo
```
cd ~
git clone https://github.com/alphaxleonidas/DualShock-uinput.git
```

Create a python virtual environment
```
python3 -m venv ~/.venv
```
Update pip
```
~/.venv/bin/pip install --upgrade pip setuptools wheel
```
Install the dependencies manually or with the `requirements.txt` file
```
~/.venv/bin/pip install -r ~/DualShock-uinput/requirements.txt
```
Create udev rules file
```
sudo nano /etc/udev/rules.d/99-psinput.rules
```
and add
```
KERNEL=="uinput", MODE="0660", GROUP="input"
```
Add user to input group
```
sudo usermod -aG input $USER
```
Load uinput module
```
sudo modprobe uinput
```
Reload udev rules
```
sudo udevadm control --reload-rules
sudo udevadm trigger
```
</details>


<details> <summary>For NixOS</summary>
  ---------------------------
  
Add this to your `configuration.nix` 
  
```
{ ... }: {

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input"
  '';

# Add "input" to extraGroups of your user: 
  
  users.users.<username> = {
  
    extraGroups  = [
      "input"  
    ];
  }
}
```
Replace `<username>` with our username.


Rebuild


Go to `requirements.txt` and comment the line `evdev==1.9.2`. It is being declared in `shell.nix`.


**Commands to Run:** 
```
cd ~/DualShock-uinput
nix-shell
python ds4-uinput.py
```
**For desktop entry:** 
```
mkdir -p ~/.local/share/applications
nano ~/.local/share/applications/ds4-uinput.desktop
```
Add this:
```
[Desktop Entry]
Type=Application
Name=DualShock Multiplayer
Comment=Run DualShock uinput multiplayer script
Exec=nix-shell --run "python ds4-uinput.py"
Path=/home/<username>/DualShock-uinput
Terminal=false
Categories=Game;Utility;
```
Replace `<username>` with your username
```
chmod +x ~/.local/share/applications/ds4-multiplayer.desktop
```
To make it an executable. Run from the AppMenu

---------------------------




</details>   

# Usage

**Steps:**
- **Connect you PS4/PS5 controller first via USB or Bluetooth**, then run the script
```
~/.venv/bin/python ~/DualShock-uinput/ds4-uinput.py
```
~~as the script looks for the controller directly on start else the script will just stop with an error.~~ Now supports hot plugging.


# Disconnect
To disconnect from bluetooth, use (PS + Start) 


# Creating an App Entry
<details> <summary>Steps:</summary>

Instead of running the command, you can create a launch script which will appear in the App Menu.
```
nano ~/.local/share/applications/ds4-uinput.desktop
```
Add this to the file: 
```
[Desktop Entry]
Version=1.0
Name=DualShock Multiplayer uinput
Comment=Run DualShock DS4 input script with Hot plugging support
Exec=/home/YOURUSERNAME/.venv/bin/python /home/YOURUSERNAME/DualShock-uinput/ds4-uinput.py
Type=Application
Icon=input-gaming
Terminal=false
Categories=Utility;Game;
Keywords=ds4;dualshock4;controller;dualsense;sense;
```
Replace ```YOURUSERNAME``` in the Exec line with your username, so both the paths becomes correct.


Now make this desktop entry an executeable:
```
chmod +x ~/.local/share/applications/ds4-uinput.desktop
```
Now logout and relogin into a new session. You will see ```DualShock Multiplayer uinput``` in the appmenu.
Now connect your DualShock or DualSense and run the ```DualShock Multiplayer uinput``` from the appmenu.

# Autostart on login

```
cp ~/.local/share/applications/ds4-uinput.desktop ~/.config/autostart/
```

</details>


# Additional Infos
- No vibration / force feedback
- The PS button is a separate button that you can map, for example in AntiMicroX
- In the config.py file you can change the deadzone of each stick, the name of the controller and if you want to be able to use the (PS + Start) combo to disconnect the controller.
- ```ds4-uinput.py``` is for hotplugging support.

#  Issues
- After first connecting, the system automatically registers up+forward input from the controller. Which resolves after moving the Left and Right Analogue Sticks. 
- The kernel module needs to be signed each time you update your kernel. Only for secure boot

# Signing the Module: [Guide](https://github.com/alphaxleonidas/DualShock-uinput/tree/main/Signing)
