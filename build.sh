#!/bin/bash

xcodebuild -project Spotify\ Bluetooth\ Headset\ Listener.xcodeproj

mkdir dist

cd build/Release

zip -r Spotify\ Bluetooth\ Headset\ Listener.zip Spotify\ Bluetooth\ Headset\ Listener.app

mv Spotify\ Bluetooth\ Headset\ Listener.zip ../../dist