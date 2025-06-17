### Flash Termux
Advanced ROM flashing tool for Termux.

> [!warning]
> This is still under development

#### Requirements
- Android device with **Termux installed**
- (Optional) **Root** or **ADB** access: if you dont have root and haven't connected termux to ADB? click [here](https://gist.github.com/kairusds/1d4e32d3cf0d6ca44dc126c1a383a48d) for instructions

#### Installation
```shell
apt update -y && apt upgrade -y
apt install wget -y
wget https://github.com/adivenxnataly/flash-termux/releases/download/1.0.0/flash-termux_1.0.0-74769c6.deb
apt install ~/flash-termux_1.0.0-74769c6.deb
```

#### Usage
```yaml
flash - Copyright (C) 2025 Adinata

 Usage:
   flash all              : flash with data wipe
   flash keep_data        : flash with keeping userdata
   flash extract <file>   : extract the rom to current directory
   flash help             : show this message

 Advanced Options:
   --slot=<a|b>           : Specify slot for A/B devices
   --force                : Skip confirmation prompts
   --disable-verity       : Disable dm-verity and verification
   -v, --version          : Show flash-termux version

 Example:
   flash extract ROM.zip
   flash all --slot=a --disable-verity
   flash keep_data --slot=b --force

```
#### Option Usage
##### extract ROM
Because ROMs are often compressed in .zip, .tgz, .rar formats, so I added options for these extracts, including for those commonly used in super.img, namely .zst so that during extraction the files will be extracted to the directory that is being used in-Termux, you can see by typing `ls` and remember this process will take a very long time.
```bash
flash extract /path/to/rom.zip
```
or if you want to extract in the same directory as the rom location, you have to go to the rom location using `cd /path/to/rom.zip` and then run the command:
```bash
flash extract rom.zip
```

##### flashing
first of all you have to make sure that you are in the location/directory where the .img is located (you have to [extract](https://github.com/adivenxnataly/flash-termux/tree/main#extract-rom) the ROM as discussed previously), after you do the extraction go to the folder location where the .img is stored, for example "images", "imgs" or even a custom name if it is a custom ROM, for example if the directory location:
`/sdcard/Download/ROM/ROM_A14/imgs`

just go to that location with:
```
cd /sdcard/Download/ROM/ROM_A14/imgs
```

and type `ls`
> This will display the contents of the directory, make sure it contains files with the extension .img

if this is the right location, then run the command:

```bash
flash all
```
it will run `erase` commands including:
- userdata
- metadata
- cache
- cust
- md_udc
- frp

```bash
flash keep_data
```
it will pass through the `erase` function to keep the data mentioned in "flash all".

If the ROM requires a slot for installation then you can run the command:
```bash
flash all --slot=a
```
and you can add `--force` to skip all required input confirmations (not recommended)

##### flash done
after the flashing is complete it will automatically run `fastboot reboot recovery` this is used **if the ROM you flash requires a data wipe again on recovery**, otherwise just reboot by selecting the `Reboot` option if it's Xiaomi, or pressing the power button.

#### Credit
[adivenxnataly](https://github.com/adivenxnataly) - this is my own project.
