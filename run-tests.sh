#!/bin/bash

#cd /root/www/test_reg
source ~/.bash_profile

appium > appium.log 2>&1 &
sleep 10

emulator -avd test -no-boot-anim -noaudio -verbose -qemu > emulator.log 2>&1 &
sleep 10
adb wait-for-device
sleep 10

source ~/.bash_profile && TEST_ENV=production rspec spec/ui/android_spec.rb:11
