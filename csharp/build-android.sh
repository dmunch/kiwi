#!/bin/bash

# Path to android-cmake
CMAKE_TOOLCHAIN_FILE=/Users/jack/Projects/android-cmake/android.toolchain.cmake

# Path to the Android NDK
ANDROID_NDK=/Users/jack/android-ndk-r10e

# Path to SWIG executable and directory.
# These are the standard paths from the Swig brew package on MacOSX
SWIG_EXECUTABLE=/usr/local/bin/swig
SWIG_DIR=/usr/local/share/swig


# try to get source path from location of script file
pushd `dirname $0` > /dev/null
cd .. 
SRC_DIR_ABSOLUTE=`pwd`
popd > /dev/null

echo "Source Path: $SRC_DIR_ABSOLUTE"

function f_cmake {
	mkdir -p $1 && cd $1 
	cmake $SRC_DIR_ABSOLUTE/csharp -DCMAKE_TOOLCHAIN_FILE=$CMAKE_TOOLCHAIN_FILE  -DCMAKE_BUILD_TYPE=Release -DANDROID_ABI="$2" -DANDROID_NDK=$ANDROID_NDK -DANDROID_STL=stlport_static -DSWIG_DIR=$SWIG_DIR -DSWIG_EXECUTABLE=$SWIG_EXECUTABLE
	make
	cd ..	
}

f_cmake "x86" "x86"
f_cmake "armeabi" "armeabi"
f_cmake "armeabi-v7a" "armeabi-v7a with NEON"

# Run xbuild to build the MonoDroid assembly.
# Run it against one of the generated csproj files, they're all the same.

xbuild /p:Configuration=Release x86/kiwi.net.droid.csproj /p:OutputPath=..
