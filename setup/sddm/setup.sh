#!/bin/bash

SCRIPT_DIR=$(dirname "$0")

cat $SCRIPT_DIR/sddm.conf > /etc/sddm.conf

cp -r $SCRIPT_DIR/catppuccin-macchiato-mauve /usr/share/sddm/themes/ 
