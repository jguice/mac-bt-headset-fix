#!/bin/bash

xcodebuild -project bubo.xcodeproj

mkdir dist

cd build/Release

zip -r bubo.zip bubo.app

mv bubo.zip ../../dist
