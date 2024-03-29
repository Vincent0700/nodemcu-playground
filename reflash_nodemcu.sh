#!/bin/bash

# --------------------------------
# - VARIABLES
# --------------------------------

SERIAL_PORT=0
BASE_DIR=$(cd `dirname $0`; pwd)

# --------------------------------
# - FUNCTIONS
# --------------------------------

function repaint () {
    clear
    echo -e "
                       __ _           _
 _ __ ___   ___ _   _ / _| | __ _ ___| |__   ___ _ __
| '_ ' _ \ / __| | | | |_| |/ _' / __| '_ \ / _ \ '__|
| | | | | | (__| |_| |  _| | (_| \__ \ | | |  __/ |
|_| |_| |_|\___|\__,_|_| |_|\__,_|___/_| |_|\___|_|  by: vincent
    "
    echo -e ""
    echo -e "\033[35mWelcome to use mcuflasher.\033[0m"
    echo -e ""
}

# --------------------------------
# - 1. Find Device
# --------------------------------

repaint
echo -e "\033[33m[-]\033[0m Finding Device ..."
sleep 1

for file in /dev/*
do
    if [[ $file =~ cu.wchusb(.*) ]]; then
        SERIAL_PORT="/dev/${BASH_REMATCH[0]}"
        break
    fi
done

if [ $SERIAL_PORT = 0 ]; then
    repaint
    echo -e "\033[31m[X]\033[0m Cannot find device /dev/cu.wchusb*"
    echo -e ""
    echo -e "Macksure you have installed driver CH340 at './driver/ch34xInstaller.pkg'"
    exit
fi

repaint
echo -e "\033[32m[√]\033[0m Found device '$SERIAL_PORT' successfully"

# --------------------------------
# 2. Erasing Flash
# --------------------------------

echo -e "\033[33m[-]\033[0m Erasing previous firmware ..."
echo -e ""

esptool.py --port /dev/cu.wchusbserial14320 erase_flash > reflash.log

repaint
echo -e "\033[32m[√]\033[0m Found device '$SERIAL_PORT' successfully"
echo -e "\033[32m[√]\033[0m Erased previous firmware successfully"

# --------------------------------
# 3. Write Flash
# --------------------------------

echo -e "\033[33m[-]\033[0m Writing nodemcu firmware ..."

nodemcu_dir="$BASE_DIR/firmware/nodemcu_v2.0"

esptool.py --port /dev/cu.wchusbserial14320 write_flash -fm qio -fs 4MB 0x00000 "$nodemcu_dir/0x00000.bin" 0x10000 "$nodemcu_dir/0x10000.bin" > reflash.log

repaint
echo -e "\033[32m[√]\033[0m Found device '$SERIAL_PORT' successfully"
echo -e "\033[32m[√]\033[0m Erased previous firmware successfully"
echo -e "\033[32m[√]\033[0m Wrote nodemcu firmware successfully"