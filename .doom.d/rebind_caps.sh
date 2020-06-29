#!/bin/sh


# Rebind Caps Lock to Esc for easier editing
# Shell script as a workaround because xsession isn't working

xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

