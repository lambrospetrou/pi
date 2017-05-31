#!/bin/sh

# Check if power save is ON or OFF using
# iw wlan0 get power_save

sudo iw wlan0 set power_save off
