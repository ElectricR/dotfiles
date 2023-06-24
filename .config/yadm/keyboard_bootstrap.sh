sudo pacman -Suy qmk python-pillow python-pyserial
mkdir -p ~/projects && qmk setup ElectricR/vial-qmk -b vial -H ~/projects/qmk_firmware -y
