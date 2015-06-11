project(kiwi)
cmake_minimum_required (VERSION 2.8.3)

# Set up the compiler
#
if(MSVC)
    add_definitions(/D_WIN32_WINNT=0x0501 /D_CRT_SECURE_NO_WARNINGS /DSFML_STATIC)
    set(CMAKE_CXX_FLAGS         "${CMAKE_CXX_FLAGS} /MP /EHsc /wd4244 /wd4996 ")
    set(CMAKE_CXX_FLAGS_DEBUG   "${CMAKE_CXX_FLAGS_DEBUG} /MTd")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /DNDEBUG /MT /MP /GS- /Ox /Ob2 /Oi /Oy /arch:SSE /fp:fast /Zi")
    set(CMAKE_LIB_LINKER_FLAGS  "${CMAKE_LIB_LINKER_FLAGS} /OPT:REF /SUBSYSTEM:WINDOWS")

else() # Most likely gcc or clang
    if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
    elseif ("${CMAKE_CXX_COMPILER_VERSION}" VERSION_LESS "4.7")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
    else()
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
    endif()

    if (BUILD_COVERAGE AND "${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fprofile-arcs -ftest-coverage")
    endif()

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pedantic -Wall -Wno-strict-aliasing -fdump-tree-vect-details")
    set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")
    set(CMAKE_CXX_FLAGS_DEBUG   "-g -DDEBUG")

    if(ANDROID)
	#set(ANDROID_STL "gnustl_static")
	set(ANDROID_STL "system")
	set(CMAKE_SHARED_LIBRARY_SONAME_CXX_FLAG "")
    endif()
	set(ANDROID_STL "stlport_static")
endif()


FIND_PACKAGE(SWIG REQUIRED)
INCLUDE(${SWIG_USE_FILE})

set(KIWIDIR ${CMAKE_CURRENT_SOURCE_DIR}/../kiwi)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

file(GLOB HEADER_FILES ${KIWIDIR}/*.h)

SET(CMAKE_SWIG_FLAGS " -namespace kiwi ")
SEPARATE_ARGUMENTS(CMAKE_SWIG_FLAGS)

SET_SOURCE_FILES_PROPERTIES(kiwi.i PROPERTIES CPLUSPLUS ON)
#SET_SOURCE_FILES_PROPERTIES(kiwi.i PROPERTIES SWIG_FLAGS "-includeall")
SWIG_ADD_MODULE(kiwi csharp kiwi.i ${SOURCE_FILES})
#SWIG_LINK_LIBRARIES(kiwi)

FILE(TO_NATIVE_PATH "${CMAKE_CURRENT_BINARY_DIR}" DOS_STYLE_BINARY_DIR)
CONFIGURE_FILE(kiwi.net.droid.csproj.template kiwi.net.droid.csproj)
