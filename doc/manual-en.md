Astronomical Image Reduction and Comet Photometry with AIRTOOLS (v3.1)
======================================================================

-   [Introduction](#introduction)
-   [Installation](#installation)
    -   [Installing Oracle VirtualBox](#installing-oracle-virtualbox)
    -   [Setup of a Virtual Machine for Linux OS](#setup-of-a-virtual-machine-for-linux-os)
    -   [Booting Install Medium of the Xubuntu Linux distribution](#booting-install-medium-of-the-xubuntu-linux-distribution)
    -   [Installing Xubuntu Linux](#installing-xubuntu-linux)
    -   [Xubuntu Desktop Basics](#xubuntu-desktop-basics)
    -   [Installing VirtualBox Guest Additions](#installing-virtualbox-guest-additions)
    -   [Installing the AIRTOOLS software](#installing-the-airtools-software)
    -   [Updating the AIRTOOLS software](#updating-the-airtools-software)
-   [The AIRTOOLS Graphical User Interface](#the-airtools-graphical-user-interface)
-   [The first AIRTOOLS Project](#the-first-airtools-project)
    -   [What is a Project?](#what-is-a-project)
    -   [Setting up the first Project](#setting-up-the-first-project)
    -   [Parameter Files](#parameter-files)
    -   [Raw Images and Image Set Definition](#raw-images-and-image-set-definition)
-   [Image Reduction](#image-reduction)
    -   [Master Darks and Flats](#master-darks-and-flats)
    -   [Image Calibration](#image-calibration)
    -   [Stacking and Astrometry](#stacking-and-astrometry)
-   [Large Aperture Comet Photometry](#large-aperture-comet-photometry)
    -   [Comet Observation](#comet-observation)
    -   [PSF Extraction and Star Removal](#psf-extraction-and-star-removal)
    -   [Measuring the Comet](#measuring-the-comet)
    -   [Photometric Calibration](#photometric-calibration)

Introduction
============

The AIRTOOLS software - or **A**stronomical **I**mage **R**eduction **TOOLS**et - has been developed for the purpose of calibrating and analyzing images of astronomical objects captured by CCD or DSLR cameras. The software provides a large number of functions for basic image calibration (e.g. bias-, dark-, flatfield calibration, raw development of bayered images), for automated object recognition, registration and stacking as well as automated astrometric and photometric calibration routines.

Moreover specialized tools have been developed to process comet observations with the goal of obtaining total coma brightness estimates matching closely those of visual observers. The invention of “Large Aperture Photometry” should allow to complement visual observations, extending to fainter magnitude limits (due to deep exposures) with the benefit of added reproducibility.

Recently a graphical user interface has been added to make the software more user friendly. It tries to derive suitable parameters for the underlying functions and programs to hide as much complexity as possible from the average user. Internally a large number of open source software programs for image analysis and visualization is used, e.g. *ImageMagick*, *GraphicsMagick*, *Netpbm* und *Gnuplot*. Powerful and extremely versatile tools well known in the professional area of astronomical image reduction are used as well, e.g.

-   [SAOImage DS9](http://ds9.si.edu/site/Home.html): Image viewer with extensible tools for analysis and catalog access
-   [Astromatic Software](http://www.astromatic.net) by E. Bertin: Most notably *sextractor* (Object recognitionand extraction), *scamp* (astrometry), *swarp* (image transformation and stacking), *skymaker* (modelling objects)
-   [Stilts](http://www.starlink.ac.uk/stilts/) by M. Taylor: Analysis, filtering and transforming tabular data (e.g. FITS tables)
-   [WCSTools](http://tdc-www.harvard.edu/software/wcstools/) by J. Mink: Tools to create and manipulate coordinate system information

The AIRTOOLS software is freely available. The project - including source code - is hosted at <https://github.com/ewelot/airtools>. Pre-compiled binary packages are provided for several Linux distributions.

The AIRTOOLS software has been developed in the hope to proove useful. Its development relies on your feedback, so please do not hesitate to ask any question at <t_lehmann@freenet.de>. Any suggestion or comment or call for help is welcome.

 

Good luck and clear skies!

Thomas Lehmann, Weimar (Germany)

Installation
============

The AIRTOOLS software must be installed on a Linux operating system, which is not commonly used in the amateur astronomy community. There exist several approaches on how to fullfill this requirement:

-   use a dedicated Linux computer or
-   configure your computer for dual booting of either Windows (or OS/X) or Linux or
-   set up a virtualization software which runs the entire Linux OS in an encapsulated application on your Windows (or OS/X) computer

We will focus on the third approach as it is probably the most convenient way of running Linux on Windows or OS/X hosts. Once the Linux OS is up and running the AIRTOOLS software itself must be installed. The overall installation process therefore can be outlined by the following steps which are described in depth later on:

-   install the virtualization software
-   setup a virtual machine for the Linux OS
-   install the Linux OS on the virtual machine
-   install AIRTOOLS on the (virtual) Linux system

The full installation will take about half an hour to complete.

Installing Oracle VirtualBox
----------------------------

VirtualBox (<http://www.virtualbox.org>) is a free and powerful virtualization software for enterprise and home users. Get the latest software package (version 6.0.10 at the time of writing) for your host operating system from the [Downloads](https://www.virtualbox.org/wiki/Downloads) page and install it.

Subsequently you should install the “Oracle VM VirtualBox Extension Pack” for improved performance and additional virtual hardware features. After downloading the extension pack file from the same download site you must start the Oracle VirtualBox Manager using the VirtualBox desktop icon, go to the menu item File/Preferences/Extensions and click on the icon on the right side. Select the downloaded file and click the “Install” button.

Setup of a Virtual Machine for Linux OS
---------------------------------------

Start the Oracle VirtualBox Manager, if not running already. Click on the “New” button and fill in the name of the new VM, e.g. xubuntu. Depending on the name you have choosen you might have to select Type=“Linux” and Version=“Ubuntu (64-bit)”. Continue by pressing “Next”.

Set the memory size to &gt;=2 GB (recommended 4 GB or up to 75% of physical RAM) and press “Next”.

Choose the defaults to create a virtual hard disk of type VDI, dynamically allocated, using the proposed file name. The file size (size of the virtual hard disk) should be &gt;=50 GB. This is sufficient for roughly 10-30 comet observations, based on 10-20 individual exposures each. If you intent to use the AIRTOOLS software regularly to analyze all your comet observations then you should create a much larger virtual hard disk, e.g. of size 500 GB. After pressing the “Create” button the virtual machine is created.

Recommended additional settings (click “Settings” button):

-   Tab System/Processor: increase number of CPU to &gt;=2 (up to number of physical cores minus one)
-   Tab Display/Screen: increase Memory to 64 MB
-   Tab USB: choose USB 3.0 Controller

Booting Install Medium of the Xubuntu Linux distribution
--------------------------------------------------------

Download the ISO image file of the latest 64-bit Xubuntu LTS release from <http://xubuntu.org/>. Please note the LTS version label, which indicates a “Long Term Support” release. This Linux OS version is one of the well supported ones by the AIRTOOLS software. From the choosen mirror site you should download the ISO file with highest revision number. At the time of this writing it is named `xubuntu-18.04.2-desktop-i386.iso`.

The ISO file is used in place of a install medium for the virtual machine. To do so you have to start the VirtualBox software (if not running already) and press the “Settings” button of the selected virtual machine.

Select the “Storage” tab. Within “Storage Devices” click on the CD symbol (labeled “Empty”) and from “Attributes” click the CD symbol near the right border of the window and select the ISO image file. Pressing “OK” will save your modified settings and you are ready to start the virtual machine by pressing the green “Start” button.

The following boot process is very similar to a regular boot process of a install CD/DVD on a real computer. In addition, the current virtual machine can be used to start a fully functional Linux live session to evaluate or experiment with the Xubuntu Linux OS (but this is not our goal).

Installing Xubuntu Linux
------------------------

Now, the Linux OS has to be installed into the presently empty virtual hard disk of the running virtual machine. Please make sure your host computer has a working internet connection.

From the initial “Welcome” screen you choose your prefered language and click the “Install Xubuntu” button to start the setup program of the installer. You can accept default settings on all the following screens (“Keyboard layout”, “Updates and other software”, “Installation type”). Please note that the Linux OS is installed on the virtual hard disk only, it does in no way erase data from your host computer’s file system. Finally click “Install now” and confirm writing the changes to the (virtual) disk by the “Continue” button.

While the installation process has already started in the background you are asked to provide a few additional informations:

-   “Where are you”: Select your time zone by clicking close to your geographic location
-   “Who are you”: Fill in your (full) name, a computer name, username and user password. Note that choosing “xubuntu” for the name of the virtual computer is allowed, despite the given warning message

You might find it convenient to be logged in automatically after booting the Linux virtual machine.

Continue the installation process which will take a few minutes to complete. Finally you are asked to restart the (virtual) computer. Pressing the “Enter” key does automatically remove the installation medium for you, reboots the virtual machine (in virtualbox jargon the “guest” system) until you are finally logged in to the (initially small) Xubuntu Linux desktop. Please note the different sections of the VirtualBox guest application window: the virtual machine’s menu bar at the top, a status bar at the bottom and the virtual screen of the Linux Desktop in between.

If your host computer is using a network proxy which requires user authentication to access the internet then you might be faced by a message window stating “Incomplete Language Support”. It is save to skip the update until later as it is not required by the AIRTOOLS software.

At any time the “Software Updater” might pop up with the information about available updates of currently installed packages. Again, those updates are not required right now

Xubuntu Desktop Basics
----------------------

On the top of the desktop screen there is a (dark) desktop panel. If you click on the small icon on the left of this panel (it uses the Xubuntu logo which mimics the head of a mouse) the main application menu pops up. From there you can start programs, tweak several desktop settings, log out and shutdown the virtual Linux system. Note the lovation of the “Log out” icon at bottom-right of the menu, which is also used to shutdown or restart the Linux OS. Get familiar with how to start the web browser and the file manager and how to shutdown the Linux OS.

For additional information please consult the official [Xubuntu Documentation](https://docs.xubuntu.org/1804/) or other tutorials on the web. Please keep in mind that you do not have to worry about any hardware specific setups in your Linux system (or for example network connection) because all communication to the real devices of the host computer is transparently handled by the VirtualBox drivers.

Installing VirtualBox Guest Additions
-------------------------------------

The Guest Additions are designed to be installed inside a virtual machine after the guest operating system has been installed. They consist of device drivers and system applications provided by Oracle VirtualBox that optimize the guest operating system for better performance and usability.

For installation you must

-   Boot the guest OS.
-   Go to the virtual machine’s menu “Devices” and press “Install Guest Additions CD Image”. A new CD icon appears on the Linux desktop and a few seconds later the Linux file manager is showing the contents of the Guest Additions virtual CD.
-   Open a terminal window using “File” menu of the file manager and select “Open Terminal Here”.
-   From the command line of the terminal run the following command (you will be asked to provide your password): `sudo apt-get install build-essential`
-   Start installation by entering the command: `sudo sh VBoxLinuxAdditions.run`
-   If installation has finished close the terminal window and eject the virtual CD by using the eject button next to the CD symbol in the file manager.
-   Finally you must reboot the Linux guest.

After a restart of the Linux virtual machine you may adjust the guest window size and effectively the screen size of the Linux desktop as needed.

Installing the AIRTOOLS software
--------------------------------

The AIRTOOLS project is hosted at <https://github.com/ewelot/airtools> where you can find the latest source code and documentation. Pre-compiled binary packages are build for several Debian based Linux distributions (e.g. Xubuntu) and can easily be installed by the following steps:

-   Download the [install script](https://github.com/ewelot/airtools/raw/master/install_deb.sh) by pressing the right mouse button on this link and selecting “Save Link As”.
-   Open the file manager (e.g. double-click the “Home” icon on the desktop).
-   Open the “Downloads” folder which should contain the previously downloaded file `install_deb.sh`.
-   Open the “File” menu of the file manager and choose “Open Terminal Here”. A new terminal window will pop up, ready to enter commands to be executed.
-   Enter the following command to start the install script (you will be prompted for your password first): `sudo bash install_deb.sh`

Upon first installation of the AIRTOOLS software the script will download many other required software packages from the official Xubuntu repository. This might take a few minutes depending on the bandwidth of your internet connection. At the end of the installation you will receive some log messages about success (or failure) in the terminal window. A log file is created for later reference and a new icon is showing up on your Linux desktop.

Updating the AIRTOOLS software
------------------------------

An update of the AIRTOOLS software is issued the same way as the initial installation but should complete much faster (due to much smaller amount of downloads).

The AIRTOOLS Graphical User Interface
=====================================

TODO

The first AIRTOOLS Project
==========================

What is a Project?
------------------

When observing during a clear night, many different exposures are taken, usually of different targets. It is common practice that an observation of a single target consists of multiple bracketed exposures. Serious observers are capturing calibration frames (darks, flats) as well. It is possible that different instruments (telescopes, filters, cameras) are used. All these images of a single night will be analyzed in a single AIRTOOLS project. Consequently, the project directory itself (and related ones) must have the date of observation used as part of its name. It is good practice to use the date at the beginning of the night.

The following directories are related to a project:

Project directory:  
It stores all config files of this project, results from image reduction and analysis (images, plots, data tables) and log files. After finishing a project this directory should be saved, e.g. to an external disk drive.

Raw directory:  
Used for all the individual raw images as created by your image asquisition system, both light frames and calibration images related to the project.

Temporary directory:  
Used to store individual calibrated images of the project which are used by several different AIRTOOLS analysis tasks as well as temporary files created during those tasks. This directory may be savely deleted when the project is finished.

Setting up the first Project
----------------------------

Upon first start of the AIRTOOLS software the base directories for the the three above mentioned storage places must be defined. Each new project will later create a new subdirectory below these places.

Next, the setup for the first project must be configured. Select the date of observation. This will be used to make initial suggestions for names of the project directory, raw directory and temporary directory. It is allowed to modify those names, e.g. append a letter. E.g. you might want to repeat the image reduction of a given night using other parameters without interferring the original analysis. In that case you could use the same raw directory name but different names for the project and temporary directories.

Further settings are:

Parameter files:  
Every project will use parameter files for certain configurations. Some of these files are rarely modified and therefore can be copied over from the last project. Modifying this default behaviour is almost never required.

Site:  
Enter the name of your observatory site as it is used in the parameter file `sites.dat` later on (see below).

TZoff:  
Enter the time zone offset with respect to UT in hours. Use the value which corresponds to the time of observation written to the header of your raw images. If your data acquisition system stores UT then you need to enter 0 here.

Parameter Files
---------------

The different image acquisition systems used by amateurs do normally write some meta data about telescope, camera etc. to image headers. Those data is required by any image reduction and analysis software. Unfortunately, keyword names and the format of their values is not standardized in any way.

We therefore decided to supply most redundant data by means of parameter files - simple text files, structured in a tabular way. The first line in the file is used to define the columns (name of parameters). Anything that appears after the `#` sign in any other line is considered a comment and will be ignored. Each line describes a separate entry and each parameter value is made by a single word. In some places you are allowed to use the character `-` to indicate an unknown value.

At first the information about your observatory site must be added to the corresponding parameter file `sites.dat`. From the AIRTOOLS application’s “Edit” menu select “Edit Site Parameters”. This will start a simple text editor (called *mousepad*). The parameter file should have a few entries already, which can be used as reference when adding a new line for your site. The column description is as follows:

ID:  
This is a unique short identifier for your site (three letters)

location:  
A unique single word for the name of your observatory location. The previously used entry of the observatory site during project setup must match one of these.

long:  
Geographic longitude in degrees, negative for a location east of Greenwich meridian.

lat:  
Geographic latitude in degrees, negative for a locations south of the equator.

alt:  
Altitude of your observatory in meters.

Save your edits and close the text editor.

The next information you have to provide is those of the instrumentation you have used. Open the parameter file `camera.dat` by selecting “Edit” and “Edit Camera Parameters”. Each combination of telescope and camera must have a dedicated entry. Use the existing sample entries as a reference for your newly added lines. The columns used are:

tel:  
Unique identifier for the telescope and camera, using 3-6 alphanumeric characters.

flen:  
Folal length of the telescope or camera lens in mm.

aperture:  
Open aperture of the telescope or camera lens in mm.

fratio:  
F-ration of the telescope or camera, that is `flen/aperture`.

camera:  
Camera model, used for your convenience only

camchip:  
Camera and sensor keys used in final ICQ records of a comet measurement. Refer to the lists of [camera keys](https://cobs.si/help?page=ccd_type) and [sensor keys](https://cobs.si/help?page=ccd_chip). Both values have to be provided in a single word, using the character `/` as a delimiter. If you for example have used a Canon 6D DSLR for imaging then the correct entry would be `CDS/CFC`.

flip:  
Indicate if the image data is flipped top-down (1) or not (0). Essentially this describes the order and interpretation of FITS data: If the FITS file is organized in such a way that the data of the bottom image row comes first and that of the top-most row latest then it is considered unflipped and the other way it is flipped. It seems that MaximDL stores data in a flipped manner.

rot:  
If the camera is rotated with respect to the sky coordinate system then you should provide a value different from 0. If true north is left on your image then use a value of 90. A rough approximation is sufficient.

rawbits:  
Original bitdepth or number of bits per pixel in a single color channel. Note that at start of the image reduction the counts (ADU, intensities) are scaled up to the 16-bit range where needed.

satur:  
Saturation value. Strictly speeking the upper counts (ADU) for which the camera response is linear (proportional to the illumination intensity) must be provided. We need the value after scaling up to the 16-bit range, e.g. if you are using a consumer DSLR where response is linear up to 2/3 of its dynamic range then you should enter a value of 40000 approximately.

gain:  
Anzahl der Elektronen je ADU. Wenn nicht bekannt, dann kann als Schätzwert 1 eingesetzt werden.

pixscale:  
Größe des Bildpunktes am Himmel in Bogensekunden.

magzero:  
Schätzwert für Helligkeitsnullpunkt, d.h. die Sternhelligkeit, die bei 1 Sekunde Belichtungszeit eine Intensität von 1 Count (ADU) erzeugen würde.

ttype:  
Auswahl des Teleskop-Typs: Reflector, Refractor, Photo Lens

ctype:  
Auswahl des Kameratyps: CCD, DSLR

Save your edits and close the text editor. Remember that for any subsequent new project you will be able to copy over those parameter files. You only need to add a new observatory site or instrument it is is not previously used and defined.

Raw Images and Image Set Definition
-----------------------------------

Now it is time to copy your raw images to the project’s raw directory within the Linux file system. There are different solutions to handle the file transfer between the host operating system and a VirtualBox guest. We suggest using an external USB pen drive or USB disk for this purpose.

Use the file manager of your host OS to copy the raw image files to the USB disk. Wait until all data have been completely written to disk. From the running Linux virtual machine locate the “Devices” menu entry on the VirtualBox VM menu at the top of the window. Select “USB” and you will see a list of USB devices from which you need to identify and select the USB disk. After a few seconds a new USB disk icon will apear on the virtual Linux desktop and little after the file manager window pops up. Use the common copy-and-paste feature to copy your raw images from the USB disk to the appropriate raw directory of the current project. Finally push the eject button on the USB device entry of the file manager and close it.

You are now going to start the first AIRTOOLS task. By pressing the “Extract basic image info” the program reads meta data of all raw image files. At the end an editor window pops up which shows an overview of relevant data for each image. Please note the first column which consists of a 4-digit image number associated with each single raw image. Images are referenced by this number throughout the reduction process.

Now it is time to group the individual images to form “image sets”. An image set is a number of images of the same type and target, e.g. a sequence of dark exposures with a given exposure time or a bracketed series of exposures of a comet. All image sets of the project are described in a parameter file called `set.dat` which must be created by yourself. From the AIRTOOLS application’s main menu select “Edit” and “Edit Image Set Definitions”. Enter lines similar to the following example:

        # 190329
        # Newton 400 mm f=1040 mm
        # Canon 5D MkII (CDS), ISO 800, MaximDL

        # UT
        # h:m set  target type texp n1 n2   nref dark flat tel
        20:30 dk01 bias     d   1 0001 0010 -    -    -    N16C
        00:03 dk02 dark     d 300 0011 0016 -    -    -    N16C
        07:49 sk01 flat     f   1 0017 0022 -    dk01 -    N16C
        00:14 co01 2017K2   o 300 0023 0026 0024 dk02 sk01 N16C

The syntax is as follows: everything after the character `#` is considered a comment. Each line (uncommented and non-empty) defines an image set using at least 11 fields (words separated by spaces) which are:

h:m:  
The local time at start of observation (approximation only, not used by the program)

set:  
The name given to the image set. We do recommend the following scheme: Use the first two letters to denote the image type, where “dk” is for darks (and bias exposures) and “sk” for sky flats, “co” might be used for a comet observation. Any other deep sky target could use two (or three) letters from the constellation it belongs to. After the letters use a two-digit running number, so the image set of the first comet target would be named `co01`, the second `co02` and so on. The set name is used in many places later on, e.g. in the file names of computed stacks and other result files.

target:  
Short name of the target observed (up to 8 characters).

type:  
Type of images (1 character): d=dark/bias, f=flat, o=lights, a=addition (continuation) of a previously defined image set. If you for some reason would like to exclude a series of images from the analysis (e.g. a focus sequence) but keep the information about those files for your record then use the character `-` in place of the image type.

texp:  
Exposure time of a single exposure in seconds.

n1:  
Number of the first image of the set.

n2:  
Number of the last image of the set.

nref:  
Number of the image which is used as a reference image for stacking, typically it should be close to the middle of the bracketed sequence. Not used for darks and flats.

dark:  
Name of the master dark (image set name) used for calibration.

flat:  
Name of the master flat used for calibration.

tel:  
Identifier of the instrument (telescope/camera) used. This must match a valid entry in `camera.dat`.

A note about master calibration images. It is not required and not convenient to capture darks and flats in every night. After you have collected some calibration sets and build some master files by AIRTOOLS it is common practice to reuse them later on. This can be done by simply copying them over from older project directories to the current one using the file manager.

Image Reduction
===============

Master Darks and Flats
----------------------

Image Calibration
-----------------

Stacking and Astrometry
-----------------------

Large Aperture Comet Photometry
===============================

Comet Observation
-----------------

PSF Extraction and Star Removal
-------------------------------

Measuring the Comet
-------------------

Photometric Calibration
-----------------------