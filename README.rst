
CMLibs-Zinc Super Build
==========================

A set of scripts to setup a developers installation of CMLibs Zinc library.

Usage
-----

::

 git clone https://github.com/cmlibs/SuperBuild.git
 mkdir build-superbuild
 cd build-superbuild
 cmake -DCMLIBS_ROOT=<some-path-where-everything-goes> ../SuperBuild
 cmake --build .

where *<some-path-where-everything-goes>* is an absolute path on your hard drive where all the source, build, and installed files will be placed.
Oh, and this directory *<some-path-where-everything-goes>* must exist **before** you can create the build configuration files.

If you want to use a particular Python say one from a virtual environment.
Use the folowing build configuration command::

 cmake -DCMLIBS_ROOT=<some-path-where-everything-goes> -DCMLIBS_PYTHON_EXECUTABLE=<path-to-python> ../SuperBuild

where *<path-to-python>* is the absolute path to the Python executable to create the Zinc Python bindings for.

To build only the dependencies configure the build with *CMLIBS_SETUP_TYPE* set to *dependencies*::

 cmake -DCMLIBS_SETUP_TYPE=dependencies -DCMLIBS_ROOT=<some-path-where-everything-goes> ../SuperBuild

Notes
-----

These set of scripts are only intended to setup a development installation of CMLIBS Zinc library.
When the installation has completed you can safely remove the *SuperBuild* and *build-superbuild* directories.
