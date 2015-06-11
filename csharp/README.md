## [SWIG](http://www.swig.org/) based C# wrappers for kiwi. ## 

This directory contains the SWIG interface definition file as well as cmake based build instructions for the necessare wrapper library.
While the C# wrappers work on all platforms where .NET / Mono runs we concentrate on MonoDroid for the time being. Build instructions where tested using MacOSX Yosemite.

Prerequisites:
* cmake
* Swig - Version used for these wrappers was 3.0.5 
* Android NDK - Version used for these wrappers was android-ndk-r10e
* [android-cmake](https://github.com/taka-no-me/android-cmake)
* Xamarin with MonoDroid subscription
 

#### Build instructions for Android NDK ##

For Android we need to supply multiple native libraries for the different platforms. 
The script `android-build.sh` is supplied to automate the build for the platforms x86, armeabi and armeabi-v7a with NEON.

Some variables have to be adjusted on the top of the file:

	# Path to android-cmake
	CMAKE_TOOLCHAIN_FILE=/Users/jack/Projects/android-cmake/android.toolchain.cmake

	# Path to the Android NDK
	ANDROID_NDK=/Users/jack/android-ndk-r10e

	# Path to SWIG executable and directory.
	# These are the standard paths from the Swig brew package on MacOSX
	SWIG_EXECUTABLE=/usr/local/bin/swig
	SWIG_DIR=/usr/local/share/swig


It's conceived to run out-of-source builds, that is you can invoke it from any directory where you want
the build artefacts to reside in.