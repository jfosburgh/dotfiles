#!/bin/bash

groupdel uinput 2>/dev/null
groupadd --system uinput
usermod -aG input $1
usermod -aG uinput $1

groups

modprobe uinput

tee /etc/udev/rules.d/99-input.rules > /dev/null <<EOF
KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
EOF

udevadm control --reload-rules && udevadm trigger

ls -l /dev/uinput
