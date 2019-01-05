
########################################################################
# airfun.sh
#   shell functions aimed towards astronomical image reduction
#
# Copyright: Thomas Lehmann, 2011-2018
# License: GPL v3
#
# note:
# - you must provide a text file (default: set.dat) which describes
#   observations as in the following two example lines:
#     # h:m set  target type texp n1 n2   nref dark flat tel # comments
#     01:03 cy01 cirr     o 120 0131 0139 0135 dk03 sk01 GSO # 3x3 f86 t=15
# - in order to use SAOImage DS9 analysis tasks (via AIexamine) you must
#   have installed files airds9.ana and aircmd.sh
########################################################################
AI_VERSION="4.0a1"
: << '----'
CHANGELOG
    TODO:
    - install feh and use it as default image viewer ?
    - bgmap smoothing box size should depend on image size
    - camera.dat: store bayer filter matrix order for dslr images

    4.0a1 - 17 Dec 2018
        * new requirements: parallel, gnuplot 5
        * AIbgdiff, AIstack: increased bgzero default from 3000 to 10000
        * AIbgdiff bugfix: prefer calibrated ppm image over pgm image
        * AIbgdiff: new option -p to fit plane instead of surface to
            diff image
        * AInoise bugfix: skip lines having type=a in AI_SETS
        * AIstack: do not write info about each input file to header anymore
        * AIphotcal: fit function reversed, resulting in slope=1/old value
            and color transformation coeffizient=-1*old value, the latter is
            now stored in AP_CTRAx (instead of AP_CVALx), changed format of
            residuals data file
        * AIplot: added option -q to suppress output from fit
        * AIpreview: make use of GNU parallel
        * ds9cmd bggradient: added third parameter fittype (plane|surface)

    3.4 - 23 Oct 2018
        * AIccd: return nonzero value if error occurs on any single image set
        * AIimlist: added option -r to check for entry of images in reg.dat
            instead of checking for presence of the image itself
        * AIplot: handle gnuplot terminal type according to file extension
            of the -o <printfile> argument
        * set_header: skip writing to header file if nothing has changed
        * get_param: allow for multiple comment lines before header line
        * ds9cmd aladindss: start locally installed program version if availabe,
            use aladin lite online version as fallback only
        * sites.dat: columns DST and TZ-UT removed (not used anymore)

    3.4a5 - 24 Sep 2018
        * AIpsfextract, AIcomet: saturated stars are not skipped from
            subtraction anymore (allow FLAGS<=7)
        * AIbgmap: amplitude of gradient is now computed from circular area
            instead of a rectangular one to eliminate bias from gradient
            direction
        * AIccd: make use of the flip setting in camera.dat
        * AIraw2gray, AIraw2rgb: added option -f to flip image top-down
            (FITS images only)
        * phot2icq: strip leading and trailing spaces from object and telid
        * cometsmooth: added -b <blurscale> to allow smoother transitions

    3.4a4 - 23 Aug 2018
        * AIphotcal: bugfix for selection of stars within rlim during
            large aperture correction
        * img_info: handle DSLR images in subdirectories
        * new function: cometsmooth

    3.4a3 - 08 Aug 2018
        * AIphotcal: use psf stars (if present) within rlim to determine large
            aperture correction
        * get_mpcephem: added option -a to print aladin sky view commands for
            plotting comet positions
        * get_exclude: bugfix in case of directory name containing multiple
            letters after the day
        
    3.4a2 - 13 Jul 2018
        * new requirement: bayer2rgb
        * camera.dat: added column flip (1=yes) to indicate if images
            are flipped (e.g. FITS images stored by MaximDL)
        * AIraw2rgb: added support for monochrome FITS images containing a Bayer
            filter matrix (DSLR raw image, assuming filter pattern BGGR)
        * AIdark, AIflat, AIccd, AIstat: scale FITS images to full 16bit range
        * AIraw2gray, AIraw2rgb: added option -s <scale> which is applied
            to FITS images only
        * AIcomet: increased smoothing of comet image before creating the
            comet trail
        * comet_lightcurve: bugfix to correctly read ephemeris data file for
            distant comets (r>10AU)
        * map_rawfiles: handle FITS images from sub-directories
        * new function: is_fitsbayer
        
    3.4a1 - 29 Jun 2018
        * AIdark, AIflat, AInoise: reworked handling of AI_CCDREGION
        * AIstack: when applying both -c <centerrefimg> and -f (for full
            image size), the size of the resulting stack is now taken from
            <centerrefimg> which is necessary when stacking on comet
        * AIregister: skip images where header file is present and option
            verbose is not set
        * AIbnorm: added option -s to subtract average (instead of divide)
        * AIbsplit: added options -r|g1|g2|b to limit output to specific color
        * AIcomet: renamed blurred image to reflect set name
        * bgresmodel: added option -b <bgval>
        * get_mpcephem: write errors to stderr
        * new functions: is_gacam_raw, regcopy

    3.3 - 11 Jun 2018
        * camera.dat: added column camchip to hold ICQ format CCD keys
            for camera and sensor
        * phot2icq: added option -c to include extended CCD information in
            ICQ record
        * meftopnm: improve handling of non-standard FITS files when
            extracting header data (convert umlauts to ?)
        * AIimlist: enhanced to support DSLR raw file name prefixes
        * AIbgdiff: crop the (averaged) reference image before computing
            rgb statistics to avoid outliers on edges
        * AIregister:
            - bugfix to correct wrong sign of image rotation with
              respect to reference image (rimg) when stacking on comet
            - avoid unimportant errors related to broken pipes (e.g. sort
              followed by head which finishes before the sort command)
        * AIstack: improved estimation of disk space requirement
        * AIaphot: improved performance by running parallel processes
        * AIval: speed improvement when working with pnm images (~50%)
        * AIstack: added return value
        * AIwcs: save some source detection stats to wcs header file
        * normstat: rewritten to improve performance (~30%)
        * img_info: added option -u to indicate camera time is UT
        * comet_lightcurve: reduce number of fetched ephemerides (interval now
            depends on total time span)
        * new function: AIpeak

    3.2.1 - 17 Apr 2018
        * img_info: bugfix to correctly handle CR2 files
        * ppm2gray: working around bug in sethead when string value has more
            than 18 characters and a comment is provided
        * AIphotcal: repeat measurement of large aperture correction in case
            of changes in rlim or aprad
        * AIstart: allow for multiple uses of option -k <keyword>=<value> in
            single command
        * AIpreview: enhanced to support missing flat or unknown black value
        * bgresmodel: added option -s <scale>
        * AIfocus: improve stability of statistics by ignoring objects
            with a<0.4pixel (likely hot pixel)

    3.2 - 11 Mar 2018
        * ds9cmd psfextract: bugfix: extract sources from original image
            (instead of bg subtracted image) to keep correct saturation value
        * newmag: bugfix: in case of RGB images use all three bg values
            provided instead of using only the first one
        * AIstart: allow user to define keyword JD via -k option
        * AIwcs: added option -m <maskreg> to allow a user defined mask
            to limit input image sources to the given region
        * imbgsub: increase default bg value of result image from 400 to 1000
            to better deal with very noisy images
        * AIcomet, AIpsfextract, AIpsfmask, AIstarcombine, AIskygen: increase
            default bg level of psf images from 400 to 1000
        * AIphotcal: repeat photometry (and matching against catalog) upon
            changes of critical parameters (e.g. aprad, rlim)
        * is_fitscube, meftopnm, imslice, AIexamine: added support for FITS
            RGB cubes which have additional extensions
        * phot2icq: changed method from C to Z
        * new function: imcoord

    3.1.1 - 31 Jan 2018
        * ppm2gray: improved keyword handling when creating FITS output:
            - propagate keyword description to FITS output file
            - added option -w <wcshead> to allow inclusion of wcs keywords

    3.1 - 17 Jan 2018
        * AIbgmap bugfix: take rejected background regions into account
            when computing final statistics
        * ppm2gray:
            - bugfix: prevent failure of sethead program when trying to
              assign multiple keywords of which one or more contain umlauts
            - bugfix: reject BSCALE and BZERO keywords when adding FITS header
        * map_rawfiles: use get_jd to determine JD
        * AIsfit: increase stability of fit for gnuplot version 5 by
            using much larger values for initial guess of parameters
        * AIdark: added option -r which eliminates row pattern by subtracting
            median value from each row
        * AIwcs: posmaxerr reduced from 25% to 10% of image diagonale to
            achieve better stability of astrometric fit
        * AIstart:
            - store AI_SITE to image header file
            - issue warning messages upon unusual data ranges
        * get_mpcephem: store more data into image header file
        * get_jd: increased precision (from 3 to 5 digits)
        * new function: impatsub

    3.1rc1 - 12 Dec 2017
        * get_mpcephem:
          - use new urls (mpc web pages switched from http to https)
          - support query of asteroids (by name or number)
        * get_cobs: rewrite to support new COBS analysis web url and
            query form parameters as of October 2017
        * AIsfit, AIphotcal: handle both gnuplot version 4 and 5 syntax
          on fitting
        * if necessary use aliases for sex and swarp (supporting different
          names of binaries in official Debian/Ubuntu packages)
        * sexselect, regfilter: add support for X_IMAGE,Y_IMAGE coordinates
          (when using isophotes in sextractor)
        * phot2icq: if mlim is missing then insert 4 blanks
        * new functions: mknlist cometcenter photplot AIpreview

    3.0.3 - 05 Nov 2017
        * ds9cmd aladindss: deal with spaces in FITS keywords of coordinates
        * AIsource: bugfix to correctly read parameters from camera.dat
        * AIphotcal: get image size using imsize instead of using NAXIS
            keywords
        * get_mpcephem: improve checks on parameters and keywords
        * datarange: correctly deal with fits cubes
        * map_rawfiles: added option -n <num> to set first image number
        
    3.0.2 - 25 Oct 2017
        * newmag: bugfix when operating on splitted sets (texp fixed)
        * ppm2gray: bugfix: do not propagate NAXIS keywords to FITS file
        * get_jd_dmag: bugfix to correctly deal with sets stacked on other than
            middle exposure
        * get_header, map_rawfiles, get_rawfile, meftopnm, AIstart, AIregister:
            bugfix: deal with file path names containing spaces
        * get_jd: enhanced to deal with FITS header where time of observation
            is stored in TIME-OBS and DATE-OBS provides the day only
        * AIcomet:
            - added check for correct region file format of comet regions
            - added check to ensure that comet region is not used as background
            - use much smaller aperture for measurement of stars which
              are selected for photometric correction and apply a magnitude
              correction term derived from psf profile
        * AIstart: added checks for identical image size and valid data range
            of stacks
        * new functions: imsize, datarange

    3.0.1 - 29 Sep 2017
        * ds9cmd: new tasks imload, expert
        * ds9cmd regphot: allow for simple photometry of any region
        * AIstart: allow user to provide header keywords (via -k key=value)
        * AIexamine: propagate all header keywords when converting pnm images
            to temporary FITS files
        * AIccd: added check to ensure same size of dark and flat images
        * ppm2gray: added option -c <cboxsize> which allows to blank any data
            outside a given center box area
        * mkpgm, mkppm: changed default output file name to "-" which allows
            to pipe it into other commands
        * get_jd_dmag: added option -g to guess time of exposures from mean jd,
            texp and nexp 
        * get_header: enhanced to support gziped FITS images
        * logfile of GUI tasks renamed from ds9cmd.log to airtask.log
        * new functions: is_fitsgz, get_jd, check_url

    3.0   - 13 Sep 2017
        * ds9cmd: new tasks shorthelp, usermanual and project
        * ds9cmd psfextract: handle change of psfsize
        * AIcomet: bugfix: position of initial comet region was off if images
            were not stacked at mid exposure
        * renamed tasks cometphot to cometextract, manualkeys to manualdata

    3.0a2 - 31 Aug 2017
        * new version of airds9.ana is required (version 3.0) due to changes
            in task parameters
        * AIcomet: bugfix to prevent truncation of large comet trails by
            enlarging the region used with mkcotrail
        * ds9cmd photcal: added parameter to select catalog color band and
            index, removed color index from aopts
        * set_header: setting an empty value now removes the keyword
        * AIphotcal: added option -vr to use V-R in color index term
        * AIregister: added option -n <nbright> to optionally increase number
            of brightmost stars to use in cross-matching

    3.0a1 - 20 Aug 2017
        * new version of airds9.ana is required (version 3.0) due to changes
            in task parameters
        * ds9cmd wcscalib: added parameter to adjust north position angle
            if it differs from default (as defined in camera.dat)
        * ds9cmd: new tasks imflip, aladindss
        * AIexamine:
            - added option -r which replaces currently displayed image
              by next loaded image (instead of loading in a new frame)
            - set default north angle in wcscalib by evaluating camera.dat
              and image header keyword PIERSIDE
        * AIstart:
            - rework of check for image center keywords
            - on error return string containing related keyword names
        * AIwcs: increased limits for uncertainty in position and angle

    2.9.2 - 10 Aug 2017
        * is_wcs: bugfix when dealing with CDELT/CROT keywords

    2.9.1 - 03 Aug 2017
        * AIcomet: skip regions having area<3pix from comet and background
        * AIphotcal: compute faint star limit (mlim) if not provided
        * is_wcs: show possible error message only if in debug mode
        * wcscalib: set mag limit on catalog stars only if magzero entry in
            camera.dat is below 19
        * AIfocus: automatically set AI_DCRAWPARAM according to rlim
        * AIsetinfo: added telid to output
        * focas: center coordinates are now in fits coordinate system
        * new function: regskip

    2.9   - 29 Jun 2017
        * AIcomet: sort data in comet/<set>.newphot.dat by star identifier
        * AIregister: propagate FITS header keyword OBJECT
        * ds9cmd regphot: allow multiple regions to be measured at once
        * reg2xy: use sequential number in ids of regions without text
        * new functions: get_rawfile, is_wcs

    2.9a3 - 04 Jun 2017
        * AIsetinfo: support telid from set.dat, support rawfiles.dat
        * AIflat: bugfix to support FITS images
        * get_jd_dmag: add support for rawfiles.dat
        * xy2reg: added option -f to indicate that input data are in FITS
            coordinates
        * AIregister:
            - modified star selection for computing mag difference, it now
              accounts for a given pre-defined upper mag difference (default
              0.1 mag)
            - added option -m <mdiff> to allow changing this mag difference
            - added support for rawfiles.dat
        * AIwcs: issue an error if number of matched stars is very low
        * new function: bgresmodel

    2.9a2 10 May 2017
        * new metadata file rawfiles.dat which contains mapping between
          image number and raw image file names (and additional fields
          like JD)
        * AIimlist: use rawfiles.dat to find raw images if other methods
            have failed to resolve a file name
        * AIstat: enhanced to support set name arguments, added options to
            choose all images of a given type (-d|-f|-o)
        * AImstat: this is now a wrapper for AIstat -m
        * new function: map_rawfiles

    2.9a1 23 Apr 2017
        * regstat, _regstat:
            - bugfix when processing polygon regions which results in much
              improved speed
            - added third parameter to specify optional bad region mask
            - added option -q for quick mode statistics (skips kappa-sigma
              clipping)
        * ds9cmd: explicitely setting region coordinates to physical in
            several places before saving region to file fixes problems on
            some versions of saoimage
        * AIcomet: speedup comet background measurement by using new
            capabilities from regstat; comet trail model now takes background
            measurements into account
        * AIstart: added option -f to flip FITS images top-bottom
        * AIexamine: avoid rare X errors by not setting cmap values
        * new function: AIgradient

    2.8.3 11 Apr 2017
        * AIstart: some improvements on checking of header keywords
        * AIsetinfo: added option -b to show basic information by parsing
            the observations data file (set.dat) only
        * omove2trail: bugfix to make angle the same value as measured in
            saoimage (was off by 180 degrees);
            improved handling of missing cfrac
        * AImask: modified to reflect changes in trail orientation introduced
            by new version of omove2trail
        * ds9cmd psfextract: improved handling of trail parameters;
            detect and handle change of rlim upon repeated invocations
        * AIpsfextract:
            - mask psf by using ds9 polygon region instead of using pbm image
              which now allows for mask editing by the user
            - store parameters rlim and psfsize in header of star stack
        * new function: is_equal

    2.8.2 16 Mar 2017
        * get_mpcephem: bugfix: deal with sexagesimal lat/long in image header
        * is_pnm, is_ppm, is_pgm, is_pbm: bugfix: dereference symbolic links
        * AIpsfextract:
            - bugfix to correctly estimate mcorr in case of multiple
              repeated runs of the program
            - added code for measuring psf image background
        * AIstarcombine: added option -b <imgbg> to provide psf image
            background value and skip internal measurement which might be odd
            in busy starfields and/or when long star trails are present
        * AIaphot, aphot: added option -bg to report star background
            measurements only (star photometry is skipped)
        * AIbsplit: added option -m <matrix> to set Bayer matrix color pattern
            if it is different from BGGR
        * AIphotcal: keywords MAGZERO and AI_FWHM are not required anymore
        * AIregister, AIstack: propagate additional header keywords from
            original FITS image, e.g. FILTER and BINNING
        * AIsfit, AIbgmap: improved error handling
        * get_wcspscale: enhanced to support CDELT[12]
        * omove2trail: complete rewrite
        * new function: AIstart

    2.8.1 20 Jan 2017
        * AIccd: bugfix to correctly handle fits cubes
        * AIskygen: bugfix when dealing with psf image having odd number of
            columns or rows
        * AIcomet: bugfix for large aperture photometry in case of no bgfit10
            image and comult>1
        * AIexamine: do not delete frame in ds9, this prevents an error
            message from new ds9 version 7.5
        * AIimlist, AIsetinfo, AIregister: allow raw image file names to start
            with letters
        * AIdark, AIflat: force local scope of some variables
        * AIwcs, AIstack: account for binning (via keyword BINNING)
        * AIpublish: improved detection of telescope and camera

    2.8   06 Dec 2016
        * new requirement: missfits (ref.: www.astromatic.net)
        * AIpsfextract: handle missing center parameter
        * AIcomet: bugfix: correctly set link of intermediate image headers
            (x.stsub.head and x.resid.head)
        * AIexamine:
            - enhanced to support viewing of fits cubes (RGB) by using
              the green layer only
            - removed some unnecessary parameters from analysis tasks (requires
              airds9.ana version 2.1)
        * meftopnm, imcrop: enhanced to support fits cubes (RGB)
        * AIwcs:
            - added check if given catalog is supported by scamp
            - changed default mag limit from 16 to 99 (to use all available
              stars from reference catalog)
        * AIphotcal: raised number of downloaded tycho2 ref catalog stars
        * get_telescope: make use of telescope identifier provided by set.dat
            (new field at column 11 after flat)
        * comet_lightcurve: improved xtics spacing
        * initial support for Fujifilm digital camera raw files (extension raf)
        * new functions: is_fitscube imslice is_setname AIcheck

    2.8a4 31 Oct 2016
        * AIbgdiff, AIbgmap, imbgsub, meftopnm, ppm2gray, is_mask: transition
            from imagemagick to graphicsmagick
        * ds9cmd wcscalib:
            - bugfix when parsing additional options for scamp
            - using new column in camera.dat to get camera rotation angle
              which replaces hard-coded values
        * is_ahead: bugfix to reject some FITS images
        * AIbgdiff: bugfix to correctly handle set with single image
        * AIplot: add empty border around data points (via offset)
        * mkrefcat: enhanced to support creation of reference catalogs suitable
            as input to scamp
        * phot2icq: removed hard-coded telescope specific code
        * new functions: AIcosmics findgain

    2.8a3 29 Sep 2016
        * new requirements: programs imarith and imlist from wcstools
        * AIpsfmask: do not adjust bg level anymore
        * AIpsfextract:
            - apply intensity scale for psf
            - measure mag correction on psf image and save result
              to header keyword AI_PSFMC (for later use by AIcomet)
        * AIstarcombine: added option to allow intensity scaling
        * new function rade2altaz
        * removed obsolete function imbg

    2.8a2 24 Sep 2016
        * AIcomet: improve measurement of large aperture correction on the
            starpsf image by limiting the large aperture radius to about the
            size of the starmask (improves stability when images are highly
            defocused)
        * AIwcs: replaced parameters fitdegrees and sopts by appropriate
            options
        * AIphot, aphot: added option -p precision to set number of valid
            digits of magnitudes (default: 2 digits after decimal point)
        * AIbsplit, AIbmerge, AImstat, mkkernel, immedian, kmedian: transition
            from imagemagick to graphicsmagick
        * itel2obs: improved handling of non-standard calibration file names
            on iTelescope.net T08

    2.8a1 17 Sep 2016
        * ds9cmd cometphot: bugfix to correctly deal with empty bgfit10
        * imcrop, aphot, AIcomet: replaced croping command, now using
            graphicsmagick instead of imagemagick convert, which is buggy in
            version 8:6.8.9.9-5+deb8u4
        * focas: rewrite to reflect current image header keywords (as of v2.7)

    2.7.4 01 Sep 2016
        * AIexamine: minor bugfix for retrieval of analysis file path
        * AIpublish: added option to allow setting of final jpeg quality
        * AIimlist: new option -x which skips checking for individual images
            of the given set
        * AIcomet: skip bg region if it covers less than 10 pixels
        * AIwcs: prefer keywords RA, DEC if present
        * get_jd_dmag: if individual images of a set are not available then
            try to read start of exposure from exif.dat (assuming UT in the
            column hms)
        * get_param: enhanced to support key column names in addition to key
            column numbers

    2.7.3 02 Aug 2016
        * newmag: bugfix in case of negative counts in aperture
        * AIsetinfo: enhanced evaluation of image center coordinates in
            case of missing wcs calibration
        * AIcomet: using slightly smaller radii for aperture photometry of
            stars selected for photometric correction (*.newphot.dat)
        * ds9cmd: regstat enhanced to support images without keyword AI_IMAGE

    2.7.2 23 Mai 2016
        * AIwcs: added option -p to allow for using alternate plot driver
            when creating checkplots
        * AIexamine: if input image is PNM format then propagate some ASCII
            header keywords to temporary FITS files and store original image
            name in keyword AI_IMAGE
        * ds9cmd: rework parameters on regstat, regphot, bggradient tasks,
            use new keyword AI_COMST to obtain image file name of comet stack
        * meftopnm: added option -a which creates an ASCII header file from
            FITS header keywords (instead of doing the image conversion)
        * get_mpcephem: handle missing m2 (empty value from web query)
        * comet_lightcurve: bugfix to correctly handle size option

    2.7.1 29 Apr 2016
        * AIexamine: keep current pan/zoom when adding images
        * get_mpcephem added option -w to save some data to image header file
            (e.g. comet coordinates)
        * mkcotrail: deal with empty obsdata file

    2.7   17 Apr 2016
        * changed filename from imred_fun.sh to airfun.sh
        * stop writing log entries to $HOME/.imred_version because tracking of
            version info is already done via ds9cmd.log
        * AIcomet, AIphotcal: settled on keyword names
        * AIcomet: improved handling of image sets where individual images are
            not available (e.g. only stacked images exist)
        * replaced dcraw in favour of dcraw-tl

    2.7a3 11 Apr 2016
        * reg2pbm: bugfix when converting to pbm (changed value of threshold
            from absolut intensity value to percent)
        * AIphotcal: additionally skip stars flagged in ds9 by red color circle
            bugfix when disabling flagged stars in <set>.<catalog>.xphot.dat
        * AIcomet: new optional region file <cometdir>/<set>.bad.reg which can
            be used to mask out saturated stars and other defects
        * ds9cmd task psfextract: skip stars flagged in ds9 by red color circle
        * AIflat: droped option -z because in-camera dark subtraction is now
            detected internally
        * AIimlist: removed code redundancy
        * AIwcs, AIpsfextract, AIphotcal: improved error checking
        * AIsetinfo, get_telescope: be aware of AI_TELESCOPE
        * img_info: make fits_extract be aware of AI_TZOFF
        * get_telescope, get_header: speed improvement on FITS images
        * ds9cmd: new tasks regswitch, regstat, manualkeys

    2.7a2 15 Mar 2016
        * AIcomet, AIphotcal: bugfix for RGB images when writing results to
            header keywords
        * AIpsfextract: smaller mask size for heavily defocused stars
        * AIphotcal:
            - smaller aperture for heavily defocused stars (using different
              slopes in aprad=f(fwhm))
            - creating residuals file phot/<set>.<catalog>.resid.dat
        * AIwcs: show some summary output at the end; added option -f to
            suppress output formatting (terminal escape sequences)
        * get_header: enhanced to suppport FITS extension via -e <extname>

    2.7a1 03 Mar 2016
        * AIcomet, AIphotcal: all results are now written to header keywords in
            <set>.head
        * AIbgmap: allow region file to be used as mask where regions indicate
            bad background areas
        * AIexamine: do not keep parameter files because they never get user
            modified variables written back
        * AIsetkeys: rewrite to allow keyword comments, changed keyword
            separator from "," to space
        * sethead: enhanced to deal with keyword comments
        * added parameter skip to interactive psf extraction task to allow for
            stars beeing excluded from psf creation
        * ds9cmd: new tasks wcscalib, bggradient, photcal
        * phot2icq: enhanced to evaluate new header keywords
        * new functions: is_reg sum regstat

    2.6.2 08 Feb 2016
        * reg2pbm: use rsvg-convert instead of convert for increased
            compatibility
        * itel2obs: when linking calibrated images add 9000 to the image number
            to allow working with both uncalibrated and calibrated images in
            parallel
        * AIdss: take image rotation into account
        * AIbgdiff: added option -a to use all images for computing mean image,
            even those having bad regions

    2.6.1 17 Jan 2016
        * get_telescope: bugfix in determination of nref when set is splitted
        * omove2trail: bugfix in determination of jdref
        * AIbgdiff: bugfix to correctly handle an existing <nref>.bad.png
        * AIphotcal:
            - bugfix for residual plot when using R color
            - make radius for comparison star selection depend on field
              size (smaller fraction of image for large field of view)
            - apass: flag multiple matches of the same image object
        * AIdss: added option -e to get data from ESO instead of STScI
        * AIpsfextract: field stars are no longer limited to rlim region, only
            if a region file comet/<set>.sub.reg does exist
        * AIcomet: use smaller kernel for median when creating comet trail
        * AIstack: added keywords NREF and MJD_OBS (mean jd of all stacked
            images) to output header file
        * AIsetinfo, AIpublish, phot2icq, focas: use MJD_OBS instead of MJD_REF
        * regfilter: apply region filter on all extensions having <xcol>, <ycol>
            instead of using a single user provided extension
        * kappasigma: new option -n to append number of valid data points to
            output

    2.6   23 Dec 2015
        * new interactive psf extraction using ds9 analysis scripts (substantial
          changes in functions AIexamine, ds9cmd)
        * AIcomet: make use of AI_COMULT instead of fixed 10x or 1x stretch
        * AIplot: added option -g <gpcmd>
        * AIphotcal: changed check plot to show residuals vs. ref cat mag
        * AIstack: added option -bz bgdiffzero
        * img_info: switched from exiv2 to exiftool
        * reg2pbm: bugfix: svg coordinates had to be shifted left and up by
            0.5 pixel to get a better match of created mask image
        * new function mkcotrail

    2.5.3 02 Dec 2015
        * AIstack: bugfix: background variation between individual images was
            not taken into account when operating on gray (CCD) images
        * ppm2gray: bugfix to not scale intensity on gray input image
        * comet_lightcurce:
            - bugfix when downloading ICQ observations
            - fixed few bugs dealing with comets without observations
            - fixed plotting of coma diameter
        * AIphotcal:
            - added option -d maxdist for matching between catalog and image
            - prefer manually modified refcat phot/$setname.$catalog.xymanu.reg
                e.g. when dealing with poor wcs calibration
        * AIdss: eliminate call of external program dss_search.sh, using wget
            instead
        * AIsource: increased default threshold from 5 to 10

    2.5.2 28 Oct 2015
        * AImstat, AIbsplit, immedian: bugfix for newer versions of imagemagick
            which changed the -sample algorithm (fixed by introducing correct
            sample offset)
        * comet_lightcurce: rework of distance plotting

    2.5.1 20 Oct 2015
        * AIpsfextract: bugfix to skip psf stars close to image border
        * get_header: bugfix to skip unwanted message from listhead, added
            option -q to suppress messages about missing keywords
        * AIphotcal: bugfix correcting mag zero point in case of requesting
            color calibration; added option -z <zangle> to set angle between
            zenith and north (allow to measure differential extinction)
        * img_info: recognice EXPOSURE keyword of FITS files (exposure time)
        * AIsetinfo: recognize JD keyword (if MJD_REF does not exist)
        * AIwcs: recognice OBJCTRA,OBJCTDEC keywords, query <set>.head for
            ra,de first
        * get_mpcephem: recognize JD keyword (if MJD_REF does not exist) and
            SITELONG, SITELAT in <set>.head
        * omove, omove2trail, get_jd_mag: adapted to handle set with single
            image
        * comet_lightcurve: reuse COBS/ICQ data from latest.<comet>.dat if it
            has been modified only recently
        * new function xytrans
        

    2.5   25 Sep 2015
        * AIwcs: bugfix for north angle containing a leading '+' sign
        * AIphotcal, AIphotmatch, rade2xy: added support for APASS catalog
        * AIphotcal
            - replaced extern program vget.sh by function mkrefcat
            - added option -bv to fit color transformation term
        * AIcomet: apply photometric correction to sextractor magnitudes of
            stars to obtain total flux (= large aperture magnitude) as required
            by input catalog for skymaker (AIskygen)
        * AIregister:
            - increased number of stars used in photometric calibration
            - increased anglemaxerr (5 to 10, with -p 15 to 40)
        * get_param: rewrite to read column names of the data file from first
            comment line (starting with single #)
        * comet_lightcurce: added option -v <visdb> to query visual observations
            databases (default: cobs)
        * is_ahead: improved to recognize more ASCII FITS header files
        * new functions: get_telescope get_cobs mkwcs mkrefcat
        * added more columns to camera.dat

    2.5a2 14 Aug 2015
        * pbm2reg disabled (need transition from autotrace to potrace)
        * AIstack, get_jd_mag: bugfix when using omove: if both JD and MJD_OBS
            keywords are missing then use DATE-OBS to compute julian date
        * AIsfit: bugfix to ignore comments in PNM images created by meftopnm
        * meftopnm: bugfix to correctly deal with 32bit FITS images
        * phot2icq: bugfix in computation of position angle
        * img_info: bugfixes:
            - exposure time was rounded to integer in manual mode,
              now it always uses higher precision from Pentax.ExposureTime
              if it exists, increased to show 2 decimals after comma
            - deal with image file path names containing spaces
        * AIregister: improved handling of rotated images
        * AIstack, AIwarp, AIbgmap, AIstarcombine, AIskygen: in conversion from
            FITS to PGM/PPM replace convert command by meftopnm
        * focas: added parameter to provide user defined background value
            TODO: replace evaluation of pdata by examination of keywords
        * new functions: mkregheader imbg addldacwcs
            
    2.5a1 29 Jun 2015
        * normstat: bugfix: output precision must not be truncated
        * newmag: bugfix in computation of mag difference
        * rework of AIcomet for a much faster workflow
        * AIphotcal: enhanced to support photometry data file as input for
            psf stars data (in addition to ds9 region file)
        * renamed AIimgen to AIskygen, AImkpsf to AIstarcombine
        * new functions: AIpsfextract AIpsfmask AIsetkeys
        * new helper functions: is_number is_ahead get_header set_header
            mag2i get_jd_dmag imcount sex2rgbdat omove2trail meftocube
        * removed fixldac because newer versions of stilts (3.0-2, 6 Feb 2015)
          and topcat (4.2-2, 6 Feb 2015) now support reading LDAC FITS tables
          
    2.4   03 Jun 2015
        * AIval: bugfix by declaring some variables to local scope
        * AIimgen: rewrite using skymaker
        * aphot: added option -a to return counts (ADU) instead of mag
        * comet_lightcurve: heavy rework and many extensions added
        * sexselect: added option -x which converts to image coordinates
        * removed obsolete functions: gauss fitsext
        * removed functions AIoverscan AIinspect (not tested since ~140101)
        * new functions: get_exclude focas itel2obs

    2.4a3 19 May 2015
        * AIpublish: bugfix to correctly handle gray input images
        * AIflat: replace bad pixels by interpolation of 4 second-next
            neighbors (only when used with -b option)            
        * AIbgdiff: when creating mean image skip those with bad regions
            (as found in bgvar/*.bad.*)
        * AIphotcal, AIphotmatch, rade2xy: allow reference stars from
            NOMAD catalog
        * AIphotcal:
            - new options -B, -R to use B or R magnitudes instead of V
            - new option -l <mlim> to use magnitude limit in final curve fitting
            - new option -g to skip measuring star mag correction for large
              apertures (gapcorr)
            - deal with unknown reference magnitude in the choosen color band
            - added some checks of intermittent results
        * AIaphot: changed default gap from 3 to 1.5+aprad/2 and bgwidth
            from 3 to 2.3+aprad/4
        * aphot: added option -b <bgval> to set background and ignore data
            from background annulus
        * new function: is_fitsrgb

    2.4a2 28 Apr 2015
        * AIccd:
            - removed option -z, now in-camera dark subtraction is assumed
                if black value in output of AIsetinfo is zero
            - do not apply color matrix (channel multipliers) in dcraw anymore
        * AIraw2rgb: do not apply color matrix (channel multipliers) in dcraw
            by default, use new option -m to activate it
        * AIbgdiff: images which have bad regions are no longer used when
            creating average background image
        * AIregister: improve matching between reference image and current
            image for estimation of mag difference between images
        * AIstack: now any background difference maps (in directory bgvar)
            are applied
        * AIwarp:
            - added option -r <resamptype> to optionally overwrite defaults
            - added option -q to reduce output from swarp
        * AIexamine: added option -p <ds9opts> to pass additional command line
            options to ds9
        * AIfindbad:
            - added option -m <margin> to ignore pixels near image border
            - selection of images is now equally spaced (when nmax<n)
        * new function AIimcompare (replaces AIcompare)

    2.4a1 02 Apr 2015
        * AIbnorm: added option -k to keep mean brightness instead of
            normalization to 10000 ADU
        * AIbgdiff: limit number of images to average for reference frame
            (option -n nmax, default: 11)
        * AIfindbad:
            - limit number of images to use (option -n nmax, default: 11)
            - improved to operate on ppm images as well (by means of AIccd -b)
        * AIcomet:
            - bugfix when determining nlist for comet image creation (part 4)
            - improved quality when creating blurred comet trail
            - added option -c cscale to specify intensity scaling factor of
                previously extracted comet image comet/<set>.comet.<inext>
            - do not check for presence of $tdir/$nref.p?m anymore
        * AIpsfsub:
            - removed option -s
            - added option -m to change swarp combine_type from sum to
                average (useful for motion-blur)
        * phot2icq: bugfix in extraction of telescope id for iTelescope T12
        * get_mpcephem: bugfix when building object name (e.g. for 2013US10)
        * comet_lightcurve:
            - bugfix in naming of a periodic comet in call of get_mpcephem
            - added option -p to plot tail P.A.
            - added option -c to plot coma diameter
        * xyinreg: rewrite to use regfiter resulting in huge speed-up
        * regshift: enhanced to support rotation
        * new functions aphot doubleaphot xy2ahead

    2.3 - 27 Feb 2015
        * AIbgdiff:
            - added check for valid bad area mask (b/w, mostly good pixels)
            - exclude pixels close to border in final statistics on
              bgvar/<num>.bgdiff.<inext>
            - changed default name of output directory from bgcorr to bgvar
        * AIbgmap:
            - enhanced to support subtraction of background model image
              prior to fitting a smoothed surface image
            - optionally create additional diagnostic images
        * AIcomet:
            - removed bg subtraction code
            - add larger bg offset to stsub and stempty images to avoid negative
              values, adjustable via option -s <stsubbg>, default 1000
            - added option -p <psfoff> to set background of input images and
              psf images
            - added option -n <nmax> to set max. number of bg stars to subtract,
              changed default back to 3000
        * AIpsfsub:
            - new option -b <bgoff> to optionally add a bg offset to
              resulting psf subtracted image
            - increased memory for swarp to avoid errors when using many objects
        * AIstack, AIcomet, get_omove: use header keyword DATE-OBS to determine
            jd if not read already from other keywords
        * AIstiff: added option -16 to create 16bit output image instead of 8bit
        * new functions imbgsub regmatch newmag

    2.2.6 - 11 Feb 2015
        * AIcomet:
            - small bugfix: ignore psf objects having radius=0 when
              searching for companions of psf stars
            - changed nmax from 3000 to 2000
        * AIstack: added option -n to stack images without registration (and
            using median instead of average)
        * rade2xy: enhanced to support input coordinates in sexagesimal units
        * gauss: added option -s to output gaussian starlike image (black
            background) instead of creating convolution image
        * phot2icq: improved to get pa in the range 0..360 degrees
        * new functions: kmean is_mask

    2.2.5 - 28 Jan 2015
        * AIwcs: better handling of not yet processed image sets
        * comet_lightcurve: enhancements for larger plot or setting yrange

    2.2.4 - 21 Jan 2015
        * AIpublish: bugfix of web data output in case of exptime <60s
        * AIval: improved handling of option -m (select 0 or maxval only), now
            it works with pgm files as well

    2.2.3 - 06 Jan 2015
        * AIimlist: bugfix when dealing with associated images of darks
        * AIwcs: bugfix when dealing with multiple sets and IMGROLL=Y
        * AIbgdiff: diffs are now computed with respect to mean image, the old
            way of using nref is achieved by using option -r
        * AIimlist, AIraw2gray, AIregister, AImstat, AIexamine, img_info,
            imcrop: enhanced to support zipped fits images
        * new functions: AIbmerge, is_fitzip

    2.2.2 - 21 Dec 2014
        * AIcomet: changed bg value from 200 to 400
        * get_mpcephem: allow running without specifying a set name, in which
            case sites.dat is not queried at all

    2.2.1 - 01 Dec 2014
        * phot2icq, fullicq2web: improved handling of remote observations

    2.2   - 19 Nov 2014
        * AIcomet: bugfix in generating psf: while determining companion stars
            we need to add mirrored trailmask - NEEDS VERIFICATION
        * AIccd, AIraw2gray: code to account for rotated raw FITS images moved
            from AIccd to AIraw2gray, it is now generally applied (option -r
            in AIccd has been removed), output images are always in detector
            orientation (as is bias and dark)
        * AIregister, AIstack: propagate header keyword IMGROLL from raw FITS
            input files
        * AIregister: deal with input images which are rotated with respect to
            the reference image (no match of input FITS header keyword IMGROLL)
        * AIwcs: account for rotated input image (containing IMGROLL=Y)

    2.2a3 - 15 Nov 2014
        * AIphotcal: added regfilter to preselect objects from input source
            catalog; added option -m <magerrlim>
        * regfilter: added support to read fits table from stdin

    2.2a2 - 06 Nov 2014
        * kappasigma: bugfix: do not skip data if stddev=0
        * normstat: improved handling of large and narrow samples
        * get_param, get_mpcephem: improve error handling
        * AIcomet: in part 1 changed convert command to apply 'erode' after
            'resize' resulting in smoother mask border
        * new function comet_lightcurve

    2.2a1 - 25 Oct 2014
        * AIdss: bugfix: a typo was causing crash when operating on gray
            input image
        * AIregister:
            - bugfix: center pixel coordinates in <num>.src.head were off
              by 0.5 pixel
            - lower fixed arbitrary pixscale from 0.001 to 0.0003 deg
        * AIpsfsub: rework to use swarp instead of pnmaffine for stacking of
          subimages (pnmaffine is not required anymore)
        * AIcomet: keep initial cosub image (as cosub0)
        * AIfindbad: changed the way of rms determination (use kappasigma
            instead of AImstat)

    2.1.5 - 17 Oct 2014
        * AIsetinfo: improved handling of splitted image sets when determining
            number of images
        * get_mpcephem: bugfix: start time is now handled at best precision
        * ppm2gray: bugfix: keep intensity of PGM input images
        * AImkpsf: added option to set resampling type in swarp
        * AIcomet: propagate resampling type of star stack to AImkpsf

    2.1.4 - 24 Sep 2014
        * AIsource: bugfix: saturation was not read from header file
        * AIstack:
            - bugfix: saturation value was not set
            - added option to set resampling type in swarp
            - store some comand line options in output header file keywords
        * AIwarp: bugfix: some variables had to be declared local
        * AIfindbad: improved algorithm for better consistency of results
        * ppm2rgb: default ratio of rgb intensities changed
        
    2.1.3 - 19 Sep 2014
        * get_mpcephem: improve the way utday and uttime is determined
        * AIphotcal: make gap in call to AIaphot depend on aprad
        * AIimlist: enhanced to support splitted image sets, where associated
            images are sets of the same name but of type==a in sdat (must 
            match exposure time as well)
        * AIaphot: added parameter -a dr,dg,db to brighten mags by some amount
        * new function AIcompare (initial version)

    2.1.2 - 15 Sep 2014
        * AIfindbad: bugfix in calculation of rms
        * jd2ut: bugfix: prec was not initialized
        * get_param: bugfix: lat/long column numbers were swapped
        * AIccd: added option -a <add> to add an offset to output image (applies
            to gray output images only)
        * AIbgdiff: added option -k to keep bg mesh of diff image before fitting
            a suface

    2.1.1 - 12 Sep 2014
        * AIregister: propagate some FITS keywords to measure/<num>.src.head

    2.1 - 29 Aug 2014
        * AIflat: bugfix: now ccdregion is propagated to dcrawopts
        * AIwcs: bugfix: parameter threshold was not used
        * AIcomet: bugfix in psf extraction routine: deal with 0 companions
        * AIsetinfo: bugfix deal with unknown ts,black in output formatting
        * imcrop: bugfix to keep image format for PPM/PGM/PBM input images
        * AIregister:
            - bugfix: added LANG=C to printf and sort statements to correctly
              deal with float numbers
            - now relies on times in exif.dat in UT, do not use AI_TZOFF anymore
            - now register sets using an arbitrary pixscale (fixed to 0.001 deg)
            - get original image size from LDAC_IMHEAD of the reference
              catalog and release dependency on reference image
            - if measure/<num>.src.head exists skip call to scamp but show
              (most) registration results
        * AIccd: added option -r to deal with IMGROLL keyword if operating on
          FITS images
        * AIstack: added option -bad <badpix> to reject those input pixels
        * AIsource, AIregister, AIstack, AIwcs, AIaphot, AIphotcal, phot2icq:
          replaced get_magzero and get_pixscale by new function get_param
        * AIaphot: enhanced to support ring aperture photometry
        * AIphotcal: improved selection of sources, added parameters for user
          defined object center (-c xc,yc), rlim (-r rlim), nlim (-n nlim)
        * AIval: added option -0|1 to output only pixels of the given intensity
          (applies to b/w bitmap images only and requires option -c)
        * AIstack, AIcomet: recognize object location on extended parameter
          omove and use it in call of new function get_wcsrot
        * AIpublish: added parameters for text scaling and output file name
        * jd2ut: added option -t to print UTC time instead of fraction of day
        * replaced function get_rot by get_wcsrot with added parameters for
          xy-position on image
        * xymatch: added parameters to deal with image rotation
        * added functions: img_info get_param is_pbm mkkernel kmedian
        * added env variable AI_SITE
        * removed functions get_magzero get_pixscale
          
    2.1a3 - 06 Aug 2014
        * AIregister: rework of photometric calibration, which is now based
          on photometry of brightest central sources in sextractor catalogues;
          values of fits header keywords CRPIX1/2 of reference image were
          shifted by 0.5 pixel (now sx/sy of reference image are at 0)

    2.1a2 - 25 Jul 2014
        * meftopnm: bugfix to correctly handle symlink to input image
        * AIbgdiff: bugfix when resizing images using convert, now it uses the
          given dimension exactly
        * AIimlist: added fits to the list of recognized extensions for raw
          images
        * AIraw2gray, AIdark, AIccd: enhanced to support fits images on input
        * AIbgmap, AIsfit, AIbgdiff, AIaphot, AImkpsf, AIpsfsub, AIcomet,
          AIphotcal: enhanced to work with pgm images as input
        * AImkpsf, AIpsfsub: changed default spatial psf scale from 2 to 3
        * AImkpsf: changed resample_type from lanczos3 to lanczos2
        * AIcomet: adjustments for identifying bg image, added parameter
          merrlimpsf
        * AIpublish: adjustments in determining text size
        * AIphotcal:
            - added option -e <yc> to include extinction correction
            - added parameter to define aperture radius
            - radii for large aperture correction are now calculated from aprad
        * AIexamine: added support of png images
        * new function AIskygen AIfindbad

    2.1a1 - 06 Jun 2014
        * AIsource, AIstack, AIwcs: bugfix when dealing with pgm images as input
        * AIbgdiff, AIstack: bugfix: skip set if nref is missing
        * mean: bugfix to handle empty data file
        * AIbgmap: added options -p/-s to optionally smooth result by fitting a
          plane/curved surface
        * AIcomet: removed calls to AIbgmap, but reuse existing bg map if it
          exists (comet/<set>.bgm.ppm)

    2.0.5 - 31 May 2014
        * AIphotcal: bugfix for images from telephoto lens which have no entry
          in comet/aicomet.dat (simply use region around image center)
        * AIcomet: enlarged region when searching for psf companions (trailmask
          region size is now resized to 110% instead of 80%)
        * AInoise: rework to allow operating on bayer images without color
          interpolation (use option -b)
        * AIdark: added check for output file and skip processing if it exists
        * AIflat: deal with darks of larger image size by setting AI_CCDREGION
          variable accordingly, added check for output file and skip processing
          if it exists
        * get_mpcephem: improved to produce lists of any number of data rows

    2.0.4 - 05 May 2014
        * AIcomet: bugfix in parsing output from pgmhist (now return unique
          number of white pixels)
        * AIstack: added option -2 to create separate stacks for first and
          second half of images in a set
        * AIdss: added option -1 to get images from dss1r instead of dss2r,
          added option -o outfile to set outfile name (overwriting default)
        * get_omove: error messages improved
        * new helper functions phot2icq fullicq2web

    2.0.3 - 28 Mar 2014
        * AIbgdiff: small bugfix: bgdiff stats of nref is now written only
          once to stdout 
        * AIcomet: droped option -b, background subtraction is now performed on
          setting bgsize>0; default value of psfoff increased from 100 to 200
        * AIwarp: enhanced to work with pgm images as well
        * AIregister: added fallback if files AI_RAWDIR/<num>.hdr are missing
        * AIsetinfo: added options -q, -l
        * AIdss: enhanced to support more use cases (e.g. by providing center
          position on command line)
        * dec2sexa: added options -h, -m to limit output to hours, minutes
        * jd2ut: complete rewrite
        * regfilter: added support for reading region file from stdin
        * new function: AIpublish
        * new helper functions reg2reg is_ppm

    2.0.2 - 11 Mar 2014
        * AIbgdiff:
            - bugfix to handle the case where only the reference image contains
              bad region mask
            - bugfix for AIbgmap of reference image: changed msize from 3 to 1
            - better support for debugging
        * AIwcs: do not depend on AI_RAWDIR anymore
        * AIsetinfo: improved on getting n,nref
        * AIdss: added parameter for dss image chunksize
        * AIexamine: added option -a <anafile>

    2.0.1 - 21 Feb 2014
        * AIcomet: bugfix in algorithm to determine gapcorr
        * AIsfit: bugfix to return exit code of last processing step
        * AIbgdiff: added parameter bgzero, abort program on AIsfit error
        * AIexamine: added random number to name of temporary fits file

    2.0 - 30 Jan 2014
        * AIraw2rgb:
            - removed '-r 1 1 1 1' from dcraw parameters because AHD
              interpolation requires correct color channel intensity ratios,
              using '-r 1 1 1 1' would produce strange artifacts (blocks)
              most notably in red/blue
            - changed default bayer demosaicing algorithm from VNG to AHD
              and added option -q <quality> to set it differently
            - allow for gray flat image division using modded dcraw
        * AIflat: added option -b to keep bayer matrix and create gray
          output image
        * AIccd:
            - added option -b to keep bayer matrix and create gray output images
            - added option -q <quality> to specify bayer demosaicing algorithm
              (default q=3 is for using AHD interpolation)
            - preferably use gray flat field image (bayer matrix)
        * AIbgdiff: added option -b to operate on gray bayer matrix images
        * AIsource: added option -b to operate on bayer matrix images (using
          g1/g2 pixels only)
        * AIregister: bugfix for working with gray images, bugfix for CRPIX[12]
          keyword values (off by 0.5 pixel in x and y)
        * AIstack:
            - changed default combine_type from weighted to average and
              added option -w to set combine_type to weighted if desired
            - ignore FLXSCALE keyword by default
            - rework to allow grayscale input images
            - added -p sparam
            - added -s xyscale
            - added option -b to create rgb from gray bayer matrix images
            - propagate MJD of nref to output header file
        * AImkpsf: rewrite to use swarp instead of pnmaffine
        * AIpsfsub: changed algorithm to better avoid clipping of intensity
          by sequentially adding psf and subtracting background for each image
        * AIcomet: process manually defined background stars before creating
          the comet trail
        * AIsetinfo: added option -x to deal with missing/empty AI_RAWDIR
        * AIexamine: allow for any number/order of images and region files
        * AIinspect: added option -n <num> to limit number of images,
            replaced montage by pnmcat (to preserve intensities)
        * AIaphot: for stars without photometry in a channel the data from
            other channels are now included in output
        * AIbsplit: bugfix using temporary image filename, changed names of
          output files
        * AIdss: enhanced to allow any image size, download images in chunks
            of 30x30 arcmin, rescale to pixelscale of input image
        * new functions dmag2di demosaic AIbnorm AIphotcal

    2.0a8 - 04 Dec 2013
        * AIstack: bugfix: when stacking with -m dr@pa the rotation of the
          reference image with respect to ref was not accounted for
        * AIexamine:
            - bugfix: add -log for every frame
            - start with increased window size (option -s to reduce it)
        * AIcomet
            - set psfoff to ~5*rms (min=100)
            - improved background subtraction algorithm
        * new function get_mpcephem

    2.0a7 - 21 Nov 2013
        * AIccd: bugfix in handling of ccdregion
        * AIimlist: added option -q to suppress warning messages
        * AIpsfsub: added option -s which triggers intensity scaling on
          shifted psf-subimages to preserve faint signal on overlapping objects
          (which would be truncated due to integer arithmetics otherwise)
        * AIregister:
            - changed the way for setting max errors of position and angle to
              avoid mismatches on certain images (e.g. if num==nref)
            - added parameters magerrlim and scampopts
            - replaced -crossid_radius by -match_resol
            - make S/N threshold for high-S/N sample depend on magerrlim
        * AIwcs: replaced -crossid_radius by -match_resol
        * AIflat: added option -z to allow processing of in-camera dark
          subtracted flat field images
        * AIaphot: get magzero from input image header if it exists
        * AIsource, AIregister, AIwcs, AIstack: if operating on image set
          then try to derive pixscale and magzero from camera.dat (using
          AIsetinfo) before using fallback values AI_PIXSCALE and AI_MAGZERO
        * xy2reg: add magnitude to id string if it exists
        * new functions minmax AIsetinfo get_pixscale get_magzero ut2jd
        * new environment variable AI_TELESCOPE containing diameter/focal_length
          to be used by AIsetinfo if focal length and f-ratio are not provided
          by exif info file for a given reference image of an image set
        * removed function AIskypos

    2.0a6 - 25 Oct 2013
        * AIsource, AIfocus, AIaphot: use normalized AI_MAGZERO (for an
          exposure time of 1 sec) and get image exposure time from $AI_SETS
          or image header <img>.head or exif data
        * AIfocus: small bugfix to support reading single digit focus value
          from header file
        * AImkpsf: bugfix to allow pathname in input image
        * AIbgdiff: bugfix when dealing with bad pixel maps: added
          thresholding to have correct black/white image after scaling
        * AIsfit:
            - bugfix to correctly ignore any zero intensity data points
              (e.g. masked areas)
            - trim pixel intensity values of output image within 0 and maxval
        * sexselect:
            - bugfix in case where no rrange and center were provided on
              command line: the filter has been corrected to honor flagsmax
              instead of hard-coded flags<4
            - bugfix when selecting from catalog containing single source
        * AIpsfsub: added option -a which inverts default behaviour of
          subtracting psfimg from img to adding psfimg to img
        * kappasigma: added option -n to skip any zero value data
        * AIval: added option -a to show data for all pixels
        * is_fits: bugfix to correctly follow symbolic links
        * AIccd: added option -z to allow processing of in-camera dark
          subtracted images
        * AIsource: added option [-o outname] to set output file name in case
          of single input image
        * AIexamine: support pbm and pgm images
        * AIwcs:
            - added option -o <maxoff> (in degrees) to use higher posmaxerr
              (without -o the posmaxerr is set to 20% of image diagonale)
            - enhanced to accept omove in format <dr>@<pa> (asec/hr, deg)
        * i2mag: added texp as second parameter
        * ppm2gray: allow reading image from stdin
        * ds9match: added option -n to reject matched objects
        * rade2xy: changed order of parameters, allow to specify column numbers
          for idcol,racol,decol
        * xy2reg: added parameters to shift coordinates before conversion
        * new function AIcomet (preliminary version)
        * new functions get_pscale, regfilter, pbm2reg, xy2rade, regshift
        * rename function ds92pbm to reg2pbm, ds92xy to reg2xy, xy2ds9 to xy2reg

    2.0a5 - 27 Sep 2013
        * new functions AIsfit (replacing AIplane), ds92pbm, xyinreg, normstat,
          kappasigma
        * AIbgdiff: replaced AIplane by AIsfit, applying quadratic surface fit
          by default (option -p to fit planar surface)
        * AIaphot:
            - bugfix in computing photometry error
            - use kappa-sigma-clipping to gather background stats
            - speed improvement by replacing AIval with direct call to convert
        * AIval: bugfix: now pbm images are handled correctly
        * xy2ds9: added parameter to define object radius
        * imcrop: do modulo operation only if necessary
        * removed function AIplane
        
    2.0a4 - 17 Sep 2013
        * AIsource: bugfix: declare sopts as local variable
        * sexa2dec, dec2sexa: bugfix in handling of DE<0
        * AIregister: the stars sample for determining a,e,fwhm has been further
          limited by reducing the max allowed distance from image center (dlim
          changed from 0.4 to 0.3)
        * AIwcs: added option to be passed to scamp
        * AIphotmatch,rade2xy: for tycho catalog objects the id is now build
          from first 2 columns (TYC1 and TYC2)
        * AIbgdiff: add output for num=nref
        * ds9match: input from stdin is now handled (via -)
        * sexselect: abort if input catalog is missing
        * new function exiv2hdr

    2.0a3 - 02 Sep 2013
        * keep track on program version number used ($HOME/.imred_version)
        * AIregister: bugfix in setting projection constants in fits header
          file, now it handles AI_PIXSCALE correctly
        * AIregister, AIwcs:
            - use subset of refldac, inldac tables with limits on magerr
            - added sn_threshold and crossid_radius (3*AI_PIXSCALE) to
              scamp parameters
            - make position_maxerr depend on $AI_PIXSCALE
        * AIsource: do not overwrite existing source catalogs
        * AIplot: allow sexagesimal data on x
        * AIbgdiff: do not overwrite existing diff images
        * sexselect: allow to read input catalog from stdin, added option -f
          to write output table in FITS_LDAC format (to stdout)
        * sexa2dec: implement precision parameter

    2.0a2 - 08 Aug 2013
        * AIsource: bugfix in handling of color channel to be processed
          (default was to use gray conversion, now it is set to process
          all individual color channels by default)
        * AIregister: new options to select measurements for a specific
          color channel from sextractor source catalog
        * sexselect, sexstat, fixldac: parameter changed
          to handle multiple extension FITS tables
        * fixldac, ahead2ldac: output is now written to stdout
        * new env variable AI_MAGZERO
        * new function fitsext
        * removed functions sex2ds9, sexstat (instead use sexselect with
          options -r or -s)

    2.0a1 - 05 Aug 2013
        * AIraw2rgb, AIsubdark2rgb: switch from AHD interpolation to
          VNG interpolation
        * AIsource: changed default type of output catalog from
          ASCII_HEAD to FITS_LDAC, added option -q to suppress
          sextractor messages, get effective gain from ascii fits header
          file if present, added parameter: threshold
        * AIregister: complete rewrite to use scamp instead of crossmatch
        * AIval, AIstat: enhanced to work correctly with FITS images
        * AIbgmap: added option -q to suppress sextractor messages
        * AIaphot: allow ds9 region file format as object catalog, added
          some error statistics
        * AIexamine: added new option -r to load ds9 region file,
          added new option -w to load wcs information, added new
          option -a to add image into new frame of a running ds9
        * AIfocus: use sexstat to extract object statistics
        * AIphotmatch: bugfix to handle missing B,V mags in vizcat
        * new env variable AI_SATURATION
        * rade2xy: enhanced to use wcs distortion parameters
        * xymatch: added parameters for user defined x/y offsets
        * AIraw2gray, AIraw2rgb: implemented dark reduction and removed
          AIsubdark* functions
        * new functions: AIstack meftopnm fixldac ahead2ldac sexstat
          hdr2ahead get_omove
        * removed functions: AImosaic (replaced by AIstack) AIaffine
          AIcombine crossmatch

    1.2 - 05 Jul 2013
        * AIwcs: reuse ahead file if program call is using option -s,
          new parameter refcat (2nd param), changed default reference
          catalog magnitude limit from 18 to 16
        * AIsource: default gain changed from 0.1 to AI_GAIN or 1 
        * new env variable AI_GAIN
        * AImosaic: enhancements to also operate on image sets

    1.2a3 - 27 Jun 2013
        * new functions AIphotmatch, xymatch, rade2xy, gauss
        * AIccd: creation of gray FITS images not required anymore
        * AIwcs: lowerd high s/n threshold (100->40)
        * AIsource: added FWHM_IMAGE to sextractor output catalog file

    1.2a2 - 14 Jun 2013
        * bugfix in AIval: row and col info was off by 1
        * bugfix in median: explicitely use LANG=C because sorting is
          locale dependant
        * AIsource: added deblending parameters (5,6),
          added ability to work on single image file,
          added columns NUMBER EXT_NUMBER to begin of output catalog file
        * rework of AIstar, AIpsfsub
        * AIexamine: better support for MEF fits files
        * replaced ppmtograyfits by a more general function ppm2gray,
          allow for a user-defined set of color ratios,
          use switch -f to get output in FITS format
        * AIval: cx, cy are not limited to integer values anymore
        * crossmatch: rework to get rid of fixed column order in
          sextractor catalog
        * new function AIaphot
        * new functions is_pnm, sexselect, sex2ds9
        * removed function get_pointsource
        
    1.2a1 - 07 Jun 2013
        * AIwcs: added switch -n to disable creation of checkplots,
          added switch -s to use existing sextractor catalog,
          added switch -r to use existing reference star catalog
        * new helper function is_fits
        
    1.1.5 - 17 Mai 2013
        * AIinspect: create montage from individual images (when using
          default viewer imagej)
        * AIdss: use wcs header to determine width and height of DSS image
          region instead of using fixed values
        * AIwarp: do not save coadded weight fits file if there were no
          weight maps for input images
        * new function AIbgdiff
          
    1.1.4 - 30 Apr 2013
        * bugfix in AIpsfsub: final image was to low by 2x $psfbg
        * bugfix in AIimgen: showhelp was not declared local
        * bugfix in AIflat: i was not local and modified by AImstat
        * AIval: added option -c to add image coordinates in output
        * AIaffine: use bad region masks if present (bgvar/$num.bad.png)
        * AIwarp: rework to allow combining multiple images
        * AIfocus: rework to include more stars, additional parameters
        * new functions AIplane, ds9match
        * added usage help to some functions

    1.1.3 - 14 Apr 2013
        * new env variable AI_PIXSCALE
        * AIsource, AIwcs, AIstar, AImkpsf: new parameter bgsize
        * bugfix in AIccd: was still accepting cr2 raw files only
        * bugfix in AIwcs: parameter 3 was set to both maglim and fitdegrees
        * AIwcs: increase robustness of fit by providing north axis position
          angle in degrees instead of just using 4 fixed orientations 
        * AInoise, AIbg, get_imfilename: add support for more raw image formats
        * AIfocus: use get_imfilename to find image
        * AIpsfsub: improved subtraction algorithm (by using imagemagick
          convert) resulting in a large speed-up
        * new function get_rot

    1.1.2 - 26 Mar 2013
        * AIplot: additional error checkings, allow to set custom title (-t)

    1.1.1 - 21 Mar 2013
        * AIstar: improve matching sextractor catalog by choosing the closest
          object
        * AIflat,AIccd,AIsource,AIregister: support for more raw image types
        * AIimgen: added option -p to produce ppm output file (instead of fits)

    1.1 - 08 Mar 2013
        * initial basic support for several raw image types other than Canon
          cr2 (AIimlist, AIdark)
        * new functions: AIbgmap, AIstar, AIpsf, AIpsfsub
        * new helper functions is_integer, is_pgm, i2mag, di2dmag, jd2ut,
          ds92xy xy2ds9
        * bugfix: do not use printf shell buildin anymore because it interprets
          strings starting with zero as octal numbers
        * always use AIimlist to find images for a given set (instead of
          calling: seq n1 n2)
        * new env variable AI_OVERSCAN, if it contain a valid text file name
          which consists of lines with fields <imnum> <16bit_overscan_value>
          then correct for overscan in all raw image conversion commands
          (AIraw*, AIsubdark*)
        * AIsource: added parameters for better control of results: fwhm
          (changing default from 1.2 to 4), pixscale (from 1 to 1.32),
          gain (from 0 to 0.1) and magzero (keeping default 25.5)
        * AIimlist: less restrictive handling of missing images: return error
          only if there are no images at all in a set,
          added options -f and -n to only show filename or image number,
          handle set where image numbers run over 9999 and continue with 0001,
          if parameter set is used then intype is not evaluated anymore
        * AIaffine: added parameter to set interpolation degree (default value
          is 1=linear), added check for free disk space
        * AImstat: added support for stats on bayer grid cells,
          added support for reading image from stdin (using -)
        * AIoverscan: new default is to measure left side overscan area,
          adopted to use new imcrop syntax
        * AIplot: added several options (-a, -f, -p|b, -s|w), e.g. option -a
          deal with image numbers which run over 9999 and continue at 0001
        * AInoise: if intype is d then use second bayer cell in statistics
          for intensity correction, adopted to use new imcrop syntax
        * AIstiff: added several parameters
        * AIbsplit: make it work for pgm images too
        * imcrop, AIval parameters changed
        * immedian modified to use pgmhist instead of AIval and median
        * get_imfilename: deal with image numbers of less than 4 digits
        * no need for library stat_fun.sh anymore (loading disabled)

    1.0 - 06 Nov 2012
        * AIwcs: added parameter fitdegrees to set degrees of polynomial fit
          to image distortions used by scamp, removed code for image warping
        * new function AIwarp
        * new function AImosaic
        * new function ppmtograyfits
        * new function AIoverscan
        * new function AIraw2fullgray
        * new parameter AI_DEBUG, if it is not the empty string some additional
          information is written to stderr
        * AInoise: added parameter for input image type
        * in all function reading raw images saturation value lowered by 1
          
    0.9.1 - 10 Okt 2012
        * AIccd, AInoise: take account of AI_EXCLUDE
        * AIplot: introduce AI_XSKIP to skip points according to their x
          value
          
    0.9 - 28 Sep 2012
        * introduced option in dcraw calls to disable all flipping (rotation)
          which means you should not set -t option in AI_DCRAWPARAM anymore,
          AIcheck_ok issues now a warning message if AI_DCRAWPARAM or AI_SETS
          is defined
        * imcrop, _imstat, immedian: changed intensity scaling in case of raw
          images, now it calls AIraw2gray (with scaling to 16bit) instead of
          'dcraw -D -4' (without scaling)
        * imcrop: changed output image format from ppm to pnm
        * immedian: add code to support non-raw images
        * AIstat, AImstat: changed default to use full image, to get statistics
          for center region only (old behaviour) you must use option -c,
          functions AIflat, AIccd, AInoise adapted
        * AIfocus: changed default for dlim from 0.3 to 0.4, if image width
          and height are below 1000 set dlim=1, to quickly determine best focus
          you should crop images in dcraw using appropriate parameters, e.g.
            AI_DCRAWPARAM='-R 600 600' AIfocus <first> <last>
        * AIval: replace convert by pnmnoraw to output ascii data
          results in a huge speed-up (however output text format changed)
        * AIplot: reduce gnuplot fit output (remove all but last iteration)
        * AIdark, AIflat: add parameter to optionally process a single set only
        * AInoise: changed the way of bg correction from scaling (multiply)
          to offset (add) per default, added parameter do_bgscale to change
          this back to scaling
        * AInoise: running without setname now processes all sets

    0.8 - 24 Apr 2012
        * all measurements data (AIsource, AIregister, AIbg) are now written
          to directory measure instead of current directory
        * new functions AIdss, AIimgen
        * AIwcs modified to run without arguments (evaluates set.dat and
          header file for reference image)
        * dec2sexa: implemented use of prec
        * rename imstat() to _imstat() to avoid collision with program imstat
          from cfitsio examples
        * added usage info to several functions
        
    0.7 - 14 Oct 2011
        * bugfix in AIccd: changed the way mrgb is obtained to support
            the use of (artificial) gray flatfield image
        * fixed some tempfile issues
        * modified AIsource to use windowed positional parameter
            for measurements (sextractor) instead of isophotes which
            considerably reduces magnitude biased results (e.g. for a),
            increased default threshold in sextractor from 3 to 5
        * support AI_EXCLUDE in AIsource and AIregister
        * changed limits xlim,ylim in crossmatch from 200,100 to 300,200
        * replace (obsolete) pnmaverage by pnmcombine
        * stddev: use mean instead of median
        * crossmatch: additional parameters
        * AIinspect: major rewrite, use imagej as default viewer (to use ds9
            via AIexamine instead you must set parameter no. 8 to 'ds9')
        * AIbg: major rewrite, e.g. new parameters geomlist, useaff
        * new functions: mean, roi2geom, get_pointsources, AIimlist,
            AIplot, AIstiff, AIwcs, AIfocus
        * new functions AIaffine AIcombine to replace AIstack
        * added -h switch for usage info to several functions (must be the
            first parameter)
          
    0.6 - 25 Aug 2011
        * introduced mandatory env variable AI_RAWBITS to specify the
          dynamic range of the CCD in bits
        * introduced optional env variable AI_DCRAWPARAM to specify
          additional options for dcraw (e.g. rotation)
        * AIccd: reuse images already processed
        * AIstack: added support for stacking on moving object
        
    0.5 - 16 May 2011
        * implemented AIstack
        
    0.4 - 13 May 2011
        * implemented AIccd, AIsource, AIregister

    0.3 - 10 May 2011
        * new format of AI_SETS file using the following fields now:
          ltime sname target type texp n1 n2 nref dark flat
        * added support for bad pixel file via AI_BADPIX

    0.2 - 27 Apr 2011
        * finished AIdark and AIflat
        * started AInoise

    0.1 - 20 Apr 2011
        * initial version

----


# notes on image coordinates:
# image size w x h
# coordinates of center of upper-left pixel
#   FITS: (1.0, h)
#   PPM:  (0.5, 0.5)
#   pixel index (e.g. in imagemagick and imagej):  (0,   0)

# note on PBM image masks: white corresponds to value 0


#------------------------
#   program aliases
#------------------------
load_aliases () {
    # define aliases if binary names have changed
    shopt -s expand_aliases
    type -p sextractor > /dev/null 2>&1 &&
        alias sex=sextractor
    type -p SWarp > /dev/null 2>&1 &&
        alias swarp=SWarp
}

load_aliases


#--------------------
#   checkings
#--------------------

# environment variables
AIenv () {
    local verbose
    test "$1" == "-v" && verbose=1 && shift 1
    local var
    
    for var in AI_RAWDIR AI_TMPDIR AI_SITE
    do
        if [ "${!var}" ]
        then
            echo "$var=${!var}"
        else
            echo "$var undefined"
        fi
    done
    
    for var in AI_TELESCOPE AI_EXCLUDE AI_DEBUG \
        AI_RAWBITS AI_PIXSCALE AI_GAIN AI_SATURATION AI_MAGZERO \
        AI_BADPIX AI_OVERSCAN AI_LATITUDE AI_LONGITUDE AI_TZOFF \
        AI_SETS AI_XSKIP AI_DCRAWPARAM
    do
        if [ "${!var}" ]
        then
            echo "$var=${!var}"
        else
            test "$verbose" && echo "$var undefined"
        fi
    done
}

# check for dependencies
AIcheck () {
    AIcheck_ok -r -v 2>&1
}

AIcheck_ok () {
    local retval=0
    local quiet     # if set, warning messages are suppressed
    local do_check_rawdir
    local verbose
    local i
    local str
    for i in 1 2 3
    do
        test "$1" == "-q" && quiet=1 && shift 1
        test "$1" == "-r" && do_check_rawdir=1 && shift 1
        test "$1" == "-v" && verbose=1 && shift 1
    done
    
    load_aliases

    # show info about OS and installed packages
    if [ "$verbose" ]
    then
        echo "# operating system information:"
        uname -a
        lsb_release -a
        echo
        
        str="imagemagick|graphicsmagick|gnuplot|plplot|saods9|xpa-tools|wcstools"
        str="$str|missfits|scamp|sextractor|skymaker|stiff|swarp|cfitsio|stilts|airtools"
        echo "# installed packages:"
        dpkg -l | grep -E "$str" | awk '{printf("%-4s %-32s %s\n", $1, $2, $3)}'
        echo
    fi >&2
    
    # check dependencies
    # libcfitsio/cexamples
    #   imcopy:   meftopnm AIskygen
    #   imarith:  AIstarcombine
    #   fitscopy: regfilter AIregister AIcomet
    #   listhead: many functions
    # wcstools
    #   imhead sethead sky2xy xy2sky newfits delwcs
    for p in dcraw-tl gm convert rsvg-convert potrace exiftool gnuplot curl wget \
             ds9 xpaget xpaset parallel \
             pnmcombine pnmccdred pnmtomef pnmrowsort \
             imcopy imarith imlist imstat fitscopy listhead \
             imhead sethead sky2xy xy2sky newfits delhead delwcs \
             stilts sex scamp swarp stiff sky missfits
    do
        ! type -p $p > /dev/null 2>&1 && retval=255 &&
            echo "ERROR: program $p not in search path" >&2
    done
    test $retval -ne 0 && return $retval
    
    # check for aclient if scamp version < 2.2
    p=aclient
    test "$(scamp -v | cut -d " " -f3 | awk -F "." '{
        if($1<2 || ($1==2 && $2<2)){print "old"}}')" && 
        ! type -p $p > /dev/null 2>&1 && retval=255 &&
            echo "ERROR: program $p not in search path" >&2

    # check if graphicsmagick is compiled with q16
    gm -version | grep -q "\-\-with-quantum-depth=16"
    test $? -ne 0 &&
        echo "ERROR: incompatible version of graphicsmagick." >&2 &&
        retval=255
    # check AI_TMPDIR
    test "$AI_TMPDIR" && test ! -d "$AI_TMPDIR" &&
        echo "ERROR: temp directory $AI_TMPDIR does not exist." >&2 &&
        retval=255
    (test $retval -ne 0 || test "$quiet") && return $retval
    
    # show version information of some programs
    if [ "$verbose" ]
    then
        echo "# version information of programs:"
        echo "# airfun.sh:" $AI_VERSION
        echo "# dcraw-tl: " $(dcraw-tl | grep -i v | head -1)
        echo "# ds9:      " $(ds9 -version | grep ds9)
        echo "# stilts:   " $(stilts -version | grep -i "STILTS.*version")
        echo "# missfits: " $(missfits -v)
        echo "# scamp:    " $(scamp -v)
        echo "# sex:      " $(sex -v)
        echo "# sky:      " $(sky -v)
        echo "# stiff:    " $(stiff -v)
        echo "# swarp:    " $(swarp -v)
        echo
    fi >&2
    
    # issue some warnings if AI_RAWDIR does not exist or AI_SETS are defined
    test "$AI_RAWDIR" && test ! -d "$AI_RAWDIR" &&
		test "$do_check_rawdir" &&
        echo "WARNING: raw file directory $AI_RAWDIR does not exist." >&2
    test "$AI_SETS" && echo "WARNING: AI_SETS=$AI_SETS" >&2
    
    # check for camera and sites data files
    test ! -f camera.dat &&
        echo "WARNING: missing camera database (camera.dat)." >&2
    test ! -f sites.dat &&
        echo "WARNING: missing sites database (sites.dat)." >&2
    test ! -f refcat.dat &&
        echo "WARNING: missing reference catalog database (refcat.dat)." >&2
    return $retval
}




#------------------------
#   low level functions
#------------------------

is_integer () {
    local x=$*
    local err
    err=$(echo $x | awk '{
        if ($0~/^[+-]?[[:digit:]]+$/) {print 0} else {print 255}
    }')
    return $err
}

is_number () {
    local x=$*
    local err
    err=$(echo $x | awk '{
        if ($0~/^[+-]?[[:digit:]\.]+$/) {print 0} else {print 255}
    }')
    return $err
}

is_equal () {
    # compare two numbers
    local x=$1
    local y=$2
    test $# -ne 2 && echo "ERROR: two parameters required" >&2 && return 255
    local err
    err=$(echo $x $y | awk '{
        d=$1-$2; if (d == 0) {print 0} else {print 255}
    }')
    return $err
}

is_setname () {
    local str=$1
    local sdat=${AI_SETS:-"set.dat"}
    local found
    
    found=$(grep -v "^#" $sdat | awk -v s="$str" '{
        if ($1!~/^[0-9][0-9]:[0-9][0-9]/) next
        if ($2!=s) next
        if ($5!~/^[0-9]+$/) next
        if ($6!~/^[0-9]+$/) next
        if ($7!~/^[0-9]+$/) next
        if ($8!~/^[0-9]+$/ && $8!="-") next
        if (NF<10) next
        x=1
        }END{print x}')
    test -z "$found" && return 255
    return 0
}

is_reg () {
    # check if file is a valid ds9 region file
    local f=$1
    file -L "$1" | grep -qiw "text"
    test $? -ne 0 && return 255
    head -1 $1 | grep -q "^# Region file format: DS9 version [4-9]"
    test $? -ne 0 && return 255
    return 0
}

is_ahead () {
    # check if it is an ASCII representation of a FITS header file
    local f=$1
    file -L "$1" | cut -d ":" -f2 | grep -q "empty" && return 0
    file -L "$1" | cut -d ":" -f2 | grep -q "FITS image"
    if [ $? -eq 0 ]
    then
        is_fits "$f" && return 255
    else
        file -L "$f" | cut -d ":" -f2 | grep -qE "ASCII text|ISO-8859 text" ||
            return 255
        test "$(grep -Ev "^COMMENT|^HISTORY|^END" "$f" | head -1)" &&
        test "$(grep -Ev "^COMMENT|^HISTORY|^END" "$f" | cut -c9 | sort -u)" != "=" &&
            return 255
    fi
    test $(cut -c 1 $f | grep -v "[A-Z]" | wc -l) -ne 0 && return 255
    return 0
}

is_wcs () {
    # check whether the given image or header file contains a valid wcs calibration
    local f=$1
    local x
    
    # check input file type
    if ! (is_ahead $f || is_fits $f || is_fitzip $f)
    then
        test "$AI_DEBUG" && echo "ERROR in is_wcs: $f has unsupported file type." >&2
        return 255
    fi
    
    x=$(get_header -q $f CTYPE1,CTYPE2,CRVAL1,CRVAL2,CRPIX1,CRPIX2 | wc -l)
    test $x -ne 6 && return 255

    x=$(get_header -q $f CD1_1,CD1_2,CD2_1,CD2_2 | wc -l)
    if [ $x -eq 4 ]
    then
        # TODO: handle no-coord registration with fixed CDX_Y values
        x=$(get_header -s $f CD1_1,CD1_2,CD2_1,CD2_2 | \
            awk -v a=3.000111E-04 -v b=0 -v e=1E-10 '{
                x=1*$1; if(x<0){x=-1*x}; d1=x-a; d2=x-b
                if(d1>e && d2>e){wcs=1}}END{if(wcs==1){print "ok"}}')
        test "$x" && return 0
    else
        x=$(get_header -q $f CDELT1,CDELT2,CROT1,CROT2 | wc -l)
        test $x -eq 4 && return 0
    fi
    
    return 255
}

is_raw () {
    # check if file is DSLR camera RAW file
    dcraw-tl -i "$1" > /dev/null 2>&1
    test $? -ne 0 && return 255
    return 0
}

is_gacam_raw () {
    local file=$(readlink -f "$1")
    local model
    local rows
    dcraw-tl -i "$file" > /dev/null 2>&1
    test $? -ne 0 && return 255
    model=$(exiftool -S -Model $file | sed -e 's|.*: ||')
    echo "$model" | grep -q "PENTAX K-5 II"
    rows=$(exiftool -S -RowsPerStrip $file | sed -e 's|.*: ||')
    case "$model" in
        "PENTAX K-5 II"*) test $rows -ne 3344 && return 255;;
        *)  return 255;;
    esac
    return 0
}

is_pnm () {
    local file=$(readlink -f "$1")
    pnmfile "$file" > /dev/null 2>&1
    test $? -ne 0 && return 255
    gm identify "$file" > /dev/null 2>&1
    test $? -ne 0 && return 255
    return 0
}

is_ppm () {
    local file=$(readlink -f "$1")
    is_pnm "$file" && pnmfile "$file" | cut -d ":" -f2 | grep -wq PPM
    test $? -ne 0 && return 255
    return 0
}

is_pgm () {
    local file=$(readlink -f "$1")
    is_pnm "$file" && pnmfile "$file" | cut -d ":" -f2 | grep -wq PGM
    test $? -ne 0 && return 255
    return 0
}

is_pbm () {
    local file=$(readlink -f "$1")
    is_pnm "$file" && pnmfile "$file" | cut -d ":" -f2 | grep -wq PBM
    test $? -ne 0 && return 255
    return 0
}

is_mask () {
    # check, if image has 2 colors and at most 50% forground pixels (inside mask area)
    local img=$1
    local fgcolor=$2  # color of pixels inside mask area (=foreground)
    local limit=${3:-50}
    local ncol
    local val
    local npix
    local fgpercent
    
    (test $# -gt 3 || test $# -lt 1 || test "$1" == "-h") &&
        echo "usage: is_mask <img> [fgcolor] [max%|$limit]" >&2 && return 1
    test "$fgcolor" != "white" && test "$fgcolor" != "black" &&
        echo "ERROR: fgcolor must be either white or black." >&2 && return 255

    ncol=$(identify -format "%k" $img)
    case $ncol in
        -1) # TODO: handle image of unique color
            test $fgcolor == "white" && val=0
            test $fgcolor == "black" && val=65535
            ;;
        2)  test $fgcolor == "white" && val=65535
            test $fgcolor == "black" && val=0;;
        *)  echo "ERROR: $img is not b/w image." >&2 &&
            return 255;
    esac
    
    npix=$(identify $img | cut -d ' ' -f3 | tr 'x' '*' | bc)
    fgpercent=$(gm convert $img -depth 16 pgm:- | pgmhist - | grep "^$val" | \
        awk -v n=$npix '{if (NF>2) printf("%.0f", $2*100/n)}')
    test "$AI_DEBUG" && echo "$img: $fgpercent% $fgcolor (ncol=$ncol)." >&2
    test -z "$fgpercent" &&
        echo "ERROR: no foreground pixels." >&2 &&
        return 255
    test $fgpercent -gt $limit &&
        echo "ERROR: too many foreground pixels ($fgpercent% > $limit%)." >&2 &&
        return 255
    return 0
}

is_fits () {
    file -L "$1" | cut -d ":" -f2 | grep -q "FITS image"
    test $? -ne 0 && return 255
    listhead "$1" 2> /dev/null | grep -wq HDU
    test $? -ne 0 && return 255
    return 0
}

is_fitsrgb () {
    # MEF with 3 extensions of 2D images
    local f="$1"
    local str
    file -L "$f" | cut -d ":" -f2 | grep -q "FITS image"
    test $? -ne 0 && return 255
    test $(listhead "$f" | grep -w HDU | wc -l) -ne 3 && return 255
    str=$(listhead "$f" | grep -w "^NAXIS" | awk '{printf("%s ", $3)}')
    test "$str" != "2 2 2 " && return 255
    return 0
}

is_fitsbayer () {
    # grayscale image using a bayer color filter
    local f="$1"
    local str
    file -L "$f" | cut -d ":" -f2 | grep -q "FITS image"
    test $? -ne 0 && return 255
    test $(listhead "$f" | grep -w HDU | wc -l) -ne 1 && return 255
    str=$(listhead "$f" | grep -w "^BAYERPAT=" | tr "='" " " | awk '{printf("%s", $2)}')
    test "$str" != "VALID" && return 255
    return 0
}

is_fitscube () {
    # fits cube with 3 2D image planes in first HDU
    local f="$1"
    local str
    file -L "$f" | cut -d ":" -f2 | grep -q "FITS image"
    test $? -ne 0 && return 255
    #test $(listhead "$f" | grep -w HDU | wc -l) -ne 1 && return 255
    str=$(listhead "$f[0]" | grep -wE "^NAXIS|^NAXIS3" | awk '{printf("%s ", $3)}')
    test "$str" != "3 3 " && return 255
    return 0
}

is_fitzip () {
    file -L "$1" | cut -d ":" -f2 | grep -q "Zip archive"
    test $? -ne 0 && return 255
    unzip -p "$1" | dd bs=2880c count=1 status=noxfer 2>/dev/null | \
        file - | cut -d ":" -f2 | grep -q "FITS image"
    test $? -ne 0 && return 255
    unzip -p "$1" | listhead - 2> /dev/null | grep -wq HDU
    test $? -ne 0 && return 255
    return 0
}

is_fitsgz () {
    file -L "$1" | cut -d ":" -f2 | grep -qi "gzip"
    test $? -ne 0 && return 255
    gunzip -c "$1" | dd bs=2880c count=1 status=noxfer 2>/dev/null | \
        file - | cut -d ":" -f2 | grep -q "FITS image"
    test $? -ne 0 && return 255
    gunzip -c "$1" | listhead - 2> /dev/null | grep -wq HDU
    test $? -ne 0 && return 255
    return 0
}

is_diskspace_ok () {
    # check if there is enough disk space to hold nimg images
    local showhelp
    local verbose
    local i=$1
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-v" && verbose=1 && shift 1
    done
    
    local dir=$1
    local img=$2
    local nimg=$3
    local bytes=${4:-6} # bytes per pixel required
    local size=${5:-""}
    local mbextra=${6:-20}
    local w
    local h
    local mbneeded
    local mbfree

    (test "$showhelp" || test $# -lt 3) &&
        echo -e "usage: is_diskspace_ok [-v] <dir> <img> <nimg> [Bpp|$bytes]" >&2 &&
        return 1

    # get image width and height from reference image $img
    w=$(identify $img | cut -d " " -f3 | cut -d "x" -f1)
    h=$(identify $img | cut -d " " -f3 | cut -d "x" -f2)
    mbneeded=$((w*h*nimg*bytes/1024/1024 + mbextra))
    mbfree=$(/bin/df -B 1M "$dir" | tail -1 | awk '{print $4}')
    test $mbneeded -ge $mbfree &&
        echo "ERROR: $mbneeded MB disk space needed ($mbfree MB free)." >&2 &&
        return 255
    test "$verbose" && echo "# requesting $mbneeded/$mbfree MB." >&2
    return 0
}

log10 () {
    echo $1 | awk '{print log($1)/log(10)}'
}

exp10 () {
    echo $1 | awk '{print exp($1*log(10))}'
}

sqrt () {
    echo $1 | awk '{print sqrt($1)}'
}

# intensity to magnitude
i2mag () {
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    local i=$1
    local texp=${2:-"1"}
    local zero=${3:-"25.5"} # zero point magnitude
    
    (test "$showhelp" || test $# -lt 1) &&
        echo -e "usage: i2mag <intensity> [texp|$texp] [magzero|$zero]" >&2 &&
        return 1

    echo $zero $texp $i | awk '{printf("%.3f\n", $1-2.5/log(10)*log($3/$2))}'
}

mag2i () {
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    local mag=$1
    local texp=${2:-"1"}
    local zero=${3:-"25.5"} # zero point magnitude
    
    (test "$showhelp" || test $# -lt 1) &&
        echo -e "usage: mag2i <mag> [texp|$texp] [magzero|$zero]" >&2 &&
        return 1

    echo $zero $texp $mag | awk '{printf("%.0f\n", $2*exp(log(10)*0.4*($1-$3)))}'
}

# intensity ratio to magnitude difference
di2dmag () {
    local di=$1
    echo $di | awk '{printf("%.3f\n", -2.5/log(10)*log($1))}'
}

# mag diff to intensity ratio
dmag2di () {
    local dm=$1
    echo $dm | awk '{print exp(0.4*$1*log(10))}'
}

# determine new mag of object from measurement in residual image
# using previous mag estimate from a photometry data file
newmag () {
    local showhelp
    local doublemagdiff # if set, split intensity into two components with the
                        # given magnitude difference
    local do_quiet      # if set, reduce some output messages
    local i
    for i in 1 2 3
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-d" && doublemagdiff=$2 && shift 2
        test "$1" == "-q" && do_quiet=1 && shift 1
    done
    local set=$1
    local photcat=$2
    local id=$3
    local area=$4       # area size in pixels
    local mrgb=$5       # mean rgb intensity within area, comma separated
    local scale=${6:-4} # xy-scale factor of the image, where mrgb has been measured
    local bg=${7:-1000}
    local line
    local mzero
    local c
    local oldmag
    local mag
    local val
    local sign
    local di
    local dmag
    local omag
    local odiff
    local off
    local x
    local y
    local msg
    
    (test "$showhelp" || test $# -lt 4) &&
        echo "usage: newmag [-d doublemagdiff] <set> <photcat> <id> <area> <mrgb> [scale|$scale] [bg|$bg]" >&2 &&
        return 1
    test "$photcat" && test ! -f $photcat &&
        echo "ERROR: photometry file $photcat does not exist." >&2 &&
        return 255
    
    test "$id" && test "$photcat" && line=$(grep "^$id " $photcat)
    #echo "line=$line"
    test "$id" && test -z "$line" && test ! "$do_quiet" &&
        echo "WARNING: object $id not found in $photcat" >&2
    test -z "$id" && id="XXXXX"
    texp=$(AIsetinfo -b $set | head -1 | awk '{print $5}')
    mzero=$(get_param camera.dat magzero $set)
    test ! "$do_quiet" && echo "# texp=$texp mzero=$mzero"
    x=$(echo $line | cut -d " " -f2)
    y=$(echo $line | cut -d " " -f3)
    msg=$(echo "$line" | cut -c 49-)
    for c in $(seq 1 $(echo $mrgb | awk -F ',' '{print NF}'))
    do
        oldmag=$(echo $line | cut -d " " -f$((3+c)))
        bgc=$(echo $bg | cut -d ',' -f$c)
        val=$(echo $mrgb | cut -d ',' -f$c | \
            awk -v a=$area -v b=$bgc -v s=$scale '{printf("%d", ($1-b)*a/s/s)}')
        sign=1; test $val -lt 0 && val=$((-1*val)) && sign=-1
        if [ $val -eq 0 ]
        then
            resmag=99.999; dmag=0.00; mag=$oldmag; val=1
            test -z "$oldmag" && mag="-" && oldmag="-"
        else
            resmag=$(i2mag $val $texp $mzero | awk '{printf("%.2f", $1)}')
            if [ "$oldmag" ]
            then
                val=$(echo $sign $val $(mag2i $oldmag $texp $mzero) | awk '{print $1*$2+$3}')
                if [ $val -le 0 ]
                then
                    dmag=2.00
                    mag=$(echo $dmag $oldmag | awk '{printf("%.2f", $1+$2)}')
                else
                    mag=$(i2mag $val $texp $mzero | awk '{printf("%.2f", $1)}')
                    dmag=$(echo $mag $oldmag | awk '{printf("%.2f", $1-$2)}')
                fi
            else
                dmag=0; mag=$resmag; oldmag="-"
            fi
        fi
        test ! "$do_quiet" && test $id != "XXXXX" && echo "#" $c $oldmag $resmag $dmag $mag
        omag="$omag $mag"
        odiff="$odiff $(echo $dmag | awk '{print $1*100}')"
    done
    if [ "$doublemagdiff" ]
    then
        for off in  $(di2dmag $(echo "$(dmag2di -$doublemagdiff) + 1" | bc -l)) \
                    $(di2dmag $(echo "$(dmag2di  $doublemagdiff) + 1" | bc -l))
        do
            echo $omag $odiff | awk -v c=$c -v o=$off -v id=$id -v x=$x -v y=$y -v m="$msg" '{
                if (c==1) {
                    printf("%-10s  %7.2f %7.2f  %5.2f %5.2f %5.2f  %s  dm %.0f\n",
                        id, x, y, $1-o, $1-o, $1-o, m, $2-100*o)
                } else {
                    printf("%-10s  %7.2f %7.2f  %5.2f %5.2f %5.2f  %s  dm %.0f/%.0f/%.0f\n",
                        id, x, y, $1-o, $2-o, $3-o, m, $4-100*o, $5-100*o, $6-100*o)
                }}'
        done
    else
        echo $omag $odiff | awk -v c=$c -v id=$id -v x=$x -v y=$y -v m="$msg" '{
                if (c==1) {
                    printf("%-10s  %7.2f %7.2f  %5.2f %5.2f %5.2f  %s  dm %.0f\n",
                        id, x, y, $1, $1, $1, m, $2)
                } else {
                    printf("%-10s  %7.2f %7.2f  %5.2f %5.2f %5.2f  %s  dm %.0f/%.0f/%.0f\n",
                        id, x, y, $1, $2, $3, m, $4, $5, $6)
                }}'
    fi
    return
}

# aperture photometry on single star or double star
aphot () {
    local showhelp
    local xy2           # xy image coordinates of companion star
    local texp=1        # effective exposure time (single exposure)
    local magzero=25.5
    local gain=1        # effective gain
    local drgb=0
    local bgval         # if set then use this background value(s) and ignore
                        #   the background annulus
    local do_adu=0      # if 1 return counts (ADU) instead of magnitude
    local do_bg_only    # if set then only bg measurement is returned
    local precision=2   # number of digits after decimal point
    local i
    for i in $(seq 1 10)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-c" && xy2=$2 && shift 2
        test "$1" == "-t" && texp=$2 && shift 2
        test "$1" == "-m" && magzero=$2 && shift 2
        test "$1" == "-g" && gain=$2 && shift 2
        test "$1" == "-d" && drgb=$2 && shift 2
        test "$1" == "-b" && bgval="$2" && shift 2
        test "$1" == "-a" && do_adu=1 && shift 1
        test "$1" == "-p" && precision="$2" && shift 2
        test "$1" == "-bg" && do_bg_only=1 && shift 1
    done
    
    local img="$1"      # image to be measured
    local xy=${2:-""}   # xy image coordinates of star, comma separated
    local rad=${3:-3}   # aperture radius or radii for aperture ring <r1>,<r2>
    local gap=${4:-3}   # gap between aperture and bg region
    local bgwidth=${5:-3} # bg annulus width
    local x
    local y
    local x2
    local y2
    local bsize
    local mag0
    local xi
    local yi
    local bgarea
    local bgr
    local bgg
    local bgb
    local sr
    local sg
    local sb
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmp1=$(mktemp "$tdir/tmp_dat1.XXXXXX.dat")
    local tmp2=$(mktemp "$tdir/tmp_dat2.XXXXXX.dat")

    (test "$showhelp" || test $# -lt 2) &&
        echo -e "usage: aphot [-a] [-bg] [-c xcomp,ycomp] [-t texp] [-m magzero|$magzero]" \
            "[-g gain] [-d drgb] [-b bgval] [-p precision|$precision]" \
            "<img> <xstar,ystar> [rad|$rad] [gap|$gap] [bgwidth|$bgwidth]" >&2 &&
        return 1

    test ! -f "$img" &&
        echo "ERROR: image $img not found." >&2 && return 255

    # split object coordinates into separate variables
    x=${xy%,*}
    y=${xy#*,}
    x2=${xy2%,*}
    y2=${xy2#*,}
    
    # get pixel intensities around x,y
    bsize=$(echo $rad $gap $bgwidth | awk '{
        na=split($1,a,",")
        printf 2*int(a[na]+$2+$3+1.5)}')
    xi=$(echo $x $bsize | awk '{print int($1-$2/2)}')
    yi=$(echo $y $bsize | awk '{print int($1-$2/2)}')
    #AIval -c $img $bsize $bsize $xi $yi > $tmp1
    gm convert $img -crop ${bsize}x${bsize}+${xi}+${yi} - | pnmnoraw | \
        awk -v cw=$bsize -v cx=$xi -v cy=$yi 'BEGIN{row=1; col=1; skip=3}{
            if((NR==1) && ($0=="P3")) {isppm=1}
            if((NR==1) && ($0=="P1")) {skip=2}
            if(NR>skip) {
                if(isppm==1) {np=split($0, p, "  ")} else {np=split($0, p, " ")}
                for(i=1;i<=np;i++) {
                    printf("%d %d %s\n", cx+col-1, cy+row-1, p[i])
                    col++
                    if (col>cw) {row++; col=1}
                }
            }
        }' > $tmp1
    

    # determine if pixel belongs to star or background area
    cat $tmp1 | awk -v x=$x -v y=$y \
        -v rad=$rad -v gap=$gap -v bgwidth=$bgwidth 'BEGIN{na=split(rad,a,",")}{
            dx=$1+0.5-x; dy=$2+0.5-y
            r=sqrt(dx*dx+dy*dy)
            # check if pixel counts as star pixel
            # z is fraction of pixel area within aperure
            z=a[na]+0.5-r
            if ((na>1) && (z>0)) {
                # zz is fraction of pixel outside of inner ring radius
                zz=r-(a[1]+0.5)
                if (zz<0) z=0
                if (zz<1) z=z-(1-zz)
            }
            if (z>1) z=1; if(z<0) z=0
            if (z>0) {
                type=1
            } else {
                # check if pixel is from bg region
                if ((r>=a[na]+gap) && (r<a[na]+gap+bgwidth)) {
                    type=2
                } else {
                    type=0
                }
            }
            if (type>=0) printf("%s %s %s %s %s  %7.2f %7.2f %7.2f\n",
                type, z, $3, $4, $5, x, y, r)
        }' > $tmp2

    
    # determine background
    if [ -z "$bgval" ]
    then
        bgarea=$(grep "^2 " $tmp2 | wc -l)
        set - $(grep "^2 " $tmp2 | kappasigma - 3 4 4)
        bgr=$1; sr=$2
        if [ $(grep "^2 " $tmp2 | head -1 | wc -w) -gt 6 ]
        then
            set - $(grep "^2 " $tmp2 | kappasigma - 4 4 4)
            bgg=$1; sg=$2
            set - $(grep "^2 " $tmp2 | kappasigma - 5 4 4)
            bgb=$1; sb=$2
        else
            bgg=$bgr; sg=$sr
            bgb=$bgr; sb=$sr
        fi
    else
        set - ${bgval//,/ }
        bgr=$1; bgg=$1; bgb=$1; sr=1; sg=1; sb=1; bgarea=1
        test $# -gt 1 && bgg=$2
        test $# -gt 2 && bgb=$3
    fi
    
    if [ "$do_bg_only" ]
    then
        echo $bgr $bgg $bgb $bgarea $sr $sg $sb | awk '{
            printf("%6.1f %6.1f %6.1f  %4d  %4.1f %4.1f %4.1f\n",
                $1, $2, $3, $4, $5, $6, $7)}'
    else
        # measure star
        mag0=$(echo $magzero $texp | awk '{
            printf("%.2f\n", $1+2.5/log(10)*log($2))}')
        grep "^1 " $tmp2 | awk -v x=$x -v y=$y \
            -v bgr=$bgr -v bgg=$bgg -v bgb=$bgb \
            -v sr=$sr   -v sg=$sg   -v sb=$sb \
            -v bgarea=$bgarea -v m0=$mag0 -v gain=$gain -v drgb=$drgb \
            -v adu=$do_adu -v prec=$precision '{
                a=a+$2
                if (NF==8) {
                    r=r+$2*($3-bgr); g=g+$2*($4-bgg); b=b+$2*($5-bgb)
                    png2=png2+$2*$4/gain
                } else {
                    r=r+$2*($3-bgr); g=r; b=r
                    png2=png2+$2*$3/gain
                }
            }END{
                fmt="%"prec+3"."prec"f"
                fmt=fmt" "fmt" "fmt
                if (adu==1) {
                    printf("%7.2f %7.2f  %5.0f %5.0f %5.0f  %3d %3d  %4d %3d 99\n",
                        x, y, r, g, b, a, bgarea, bgg, sg)
                } else {
                    nrgb=split(drgb,arr,",")
                    dr=arr[1]; dg=dr; if(nrgb>1) dg=arr[2]; db=dg; if(nrgb>2) db=arr[3]
                    mr=99; mg=99; mb=99; errg=99; ok=1
                    if (r<0) {ok=0; r=-1*r}
                    if (g<0) {ok=0; g=-1*g}
                    if (b<0) {ok=0; b=-1*b}
                    if (r>0) mr=m0-2.5/log(10)*log(r)-dr
                    if (g>0) {
                        mg=m0-2.5/log(10)*log(g)-dg
                        errg=2.5/log(10)*log(1+sqrt(png2)/g+1.2*sg/sqrt(bgarea)*a/g)
                    }
                    if (b>0) mb=m0-2.5/log(10)*log(b)-db
                    if (ok==0) printf("# ")
                    printf("%7.2f %7.2f  "fmt"  %3d %3d  %4d %3d %.3f",
                        x, y, mr, mg, mb, a, bgarea, bgg, sg, errg)
                    if (ok==0) printf("  # below background")
                    printf("\n")
                }
            }'
    fi
    
    test "$AI_DEBUG" || rm -f $tmp1 $tmp2
}

# aperture photometry on double star
doubleaphot () {
    local showhelp
    local doublemagdiff # if set, split intensity into two components with the
                        # given magnitude difference
    local i=$1
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-d" && doublemagdiff=$2 && shift 2
    done
    local img="$1"      # image to be measured
    local xydat="$2"    # object catalog with lines id x y or ds9 region file
    local id1="$3"
    local id2="$4"
    local rad=${5:-3}   # aperture radius or radii for aperture ring <r1>,<r2>
    local gap=${6:-3}   # gap between aperture and bg region
    local bgwidth=${7:-3} # bg annulus width
    local idcol=1
    local xcol=2
    local ycol=3

    (test "$showhelp" || test $# -lt 4) &&
        echo -e "usage: doublephot <img> <xydat> <id1> <id2> [rad|$rad] [gap|$gap]" \
            "[bgwidth|$bgwidth]" >&2 &&
        return 1

    test ! -f "$img" &&
        echo "ERROR: image $img not found." >&2 && return 255
    test "$xydat" != "-" && test ! -f "$xydat" &&
        echo "ERROR: object catalog $xydat not found." >&2 && return 255
    cat $xydat > $tmpxy
    if $(head -1 $tmpxy | grep -qi "region file")
    then
        cmd="reg2xy $img $tmpxy"
    else
        cmd="cat $tmpxy"
    fi


}

# convert from julian day to ut date
# ref: http://quasar.as.utexas.edu/BillInfo/JulianDatesG.html
jd2ut () {
    local showhelp
    local timeformat=1  # 1-fraction of day, 2-HH:MM:SS
    local prec=3
    local i
    for i in 1 2 3
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-p" && prec=$2 && shift 2
        test "$1" == "-t" && timeformat=2 && shift 1
    done
    local jd=$1

    (test "$showhelp" || test $# -lt 1) &&
        echo -e "usage: jd2ut [-p prec|$prec] [-t] <jd>" >&2 &&
        return 1
    
    echo $jd | awk -v p=$prec -v tf=$timeformat '{
        q=$1+0.5; z=int(q)
        w=int((z - 1867216.25)/36524.25)
        x=int(w/4)
        a = z+1+w-x
        b = a+1524
        c = int((b-122.1)/365.25)
        d = int(365.25*c)
        e = int((b-d)/30.6001)
        f = int(30.6001*e)
        dd=b-d-f+(q-z)
        mm=e-1; if (mm>12) mm=e-13
        yy=c-4715; if (mm>2) yy=c-4716
        #printf("%4d-%02d-%06.3f\n", yy, mm, dd)
        if (tf==1) {
            fmt="%4d-%02d-%"sprintf("%02d.%1df", p+3, p)"\n"
            printf(fmt, yy, mm, dd)
        }
        if (tf==2) {
            d=int(dd)
            h=int((dd-d)*24)
            m=int((dd-d)*24*60-h*60)
            s=int((dd-d)*24*3600-h*3600-m*60)
            fmt="%4d-%02d-%02d %02d:%02d:%02d\n"
            printf(fmt, yy, mm, d, h, m, s)
        }
    }'
}

ut2jd () {
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    
    local ut=$1     # h:m:s
    local utday=${2:-"$(date +"%y%m%d")"}

    (test "$showhelp" || test $# -lt 1) &&
        echo -e "usage: ut2jd <uttime-h:m:s> [utdate-yymmdd|$utday]" >&2 &&
        return 1

    echo "$ut $utday" | awk '{
        n=split($1,arr,/:/)
        h=arr[1]; if(n>1) h=h+arr[2]/60; if(n>2) h=h+arr[3]/3600
        if (length($2) == 8) {
            y=substr($2,1,4)
            m=substr($2,5,2)
            d=substr($2,7,2)
        } else {
            y="20"substr($2,1,2)
            m=substr($2,3,2)
            d=substr($2,5,2)
        }
        if (1*m<=2) {y=y-1; m=m+12}
        a=int(y/100); b=2-a+int(a/4)
        jd=int(365.25*(y+4716)) + int(30.6001*(m+1)) + d + h/24 + b - 1524.5
        printf("%.5f\n", jd)
    }'
}

mknlist () {
    # create list of 4-digit numbers
    local str
    local x
    for str in ${@//,/ }
    do
        if [ "${str/-//}" != "$str" ]
        then
            for x in $(seq ${str%-*} ${str#*-}); do printf "%04g\n" $x; done
        else
            printf "%04g\n" $str
        fi
    done
    return
    
}


get_imfilename () {
    # search for image in current working directory and AI_RAWDIR
    # try with several extensions appended to the provided string
    local img="$1"
    local fname=""
    local extlist="cr2 pef nef raf dng fit fits ppm pgm pnm png tif jpg"
    local d
    local b
    local i4
    local ext
    for d in "$(dirname "$img")" "$AI_RAWDIR/$(dirname "$img")"
    do
        test ! -d "$d" && continue
        b=$(basename $img)
        is_integer $b && i4=$(echo $b | awk '{printf("%04d", 1*$1)}')
        test "$fname" && break
        test -f "$d/$b" && fname="$d/$b" && break
        for ext in $extlist
        do
            test -f "$d/$b.$ext" && fname="$d/$b.$ext" && break
            is_integer $b && test -f "$d/$i4.$ext" && fname="$d/$i4.$ext" && break
            is_integer $b && test -f "$d/IMG_$i4.$ext" && fname="$d/IMG_$i4.$ext" && break
        done
    done
    test -z "$fname" &&
        echo "ERROR: image $img not found." >&2 && return 255
    echo "$fname"
}

get_rawfile () {
    # get raw image file name by searching exifdat and rawfilesdat
    local num=$1
    local exifdat="exif.dat"
    local rawfilesdat="rawfiles.dat"
    local rfile
    
    test -e "$exifdat" &&
        rfile=$(grep -v "^#" $exifdat | awk -v n=$num '{if($2==n){printf("%s", $1)}}' | head -1)
    test -z "$rfile" && test -e "$rawfilesdat" &&
        rfile=$(grep -v "^#" $rawfilesdat | awk -v n=$num '{if($1==n){printf("%s", $2)}}' | head -1)
    test -z "$rfile" &&
        echo "ERROR: no entry for $nref in $exifdat/$rawfilesdat." >&2 && return 255

    if [ -f $AI_RAWDIR/$rfile ]
    then
        readlink -f $AI_RAWDIR/$rfile
        return $?
    fi
    if [ -f "$AI_RAWDIR/${rfile//_/ }" ]
    then
        readlink -f "$AI_RAWDIR/${rfile//_/ }"
        return $?
    fi
    if [ -f $rfile ]
    then
        readlink -f $rfile
        return $?
    fi
    if [ -f "${rfile//_/ }" ]
    then
        readlink -f "${rfile//_/ }"
        return $?
    fi
    echo "ERROR: file $rfile not found." >&2 && return 255
}

get_header () {
    # get value of some image header keyword(s)
    local showhelp
    local do_quiet  # if set then missing header keywords are not reported
    local do_skip_keywords  # if set then skip keyword name on output and print
                            # the values only
    local extension
    for i in 1 2 3 4
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-q" && do_quiet=1 && shift 1
        test "$1" == "-s" && do_skip_keywords=1 && shift 1
        test "$1" == "-e" && extension="[${2}]" && shift 2
    done

    local tmp1=$(mktemp "/tmp/tmp_header_$$.XXXXXX")
    local img=$1
    local keylist=$2    # separated by ','
    local hdr
    local k
    local line
    local val
    local retval

    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: get_header [-s|-q] [-e extname] <img|hdrfile> <keylist>" >&2 &&
        return 1

    test ! -e "$img" &&
        echo "ERROR: file $img not found." >&2 && return 255
    if is_ahead "$img"
    then
        hdr="$img"
    else
        ! is_pnm "$img" && ! is_fits "$img" && ! is_fitzip "$img" && ! is_fitsgz "$img" &&
            echo "ERROR: $img has unsupported image format." >&2 && return 255
        is_pnm "$img" && hdr="${img%.*}.head" && test ! -e "$hdr" &&
            echo "ERROR: missing ascii header file $hdr." >&2 && return 255
        is_fits "$img"   && listhead "${img}$extension" | grep "=" > $tmp1 && hdr=$tmp1
        is_fitzip "$img" && unzip -p "$img" | listhead -  | grep "=" > $tmp1 && hdr=$tmp1
        is_fitsgz "$img" && gunzip -c "$img" | listhead -  | grep "=" > $tmp1 && hdr=$tmp1
    fi
    
    test "$keylist" == "all" && cat $hdr && return
    
    retval=1
    for k in ${keylist//,/ }
    do
        line=$(grep -i "^$k[ ]*=" "$hdr" | head -1)
        test -z "$line" && test -z "$do_quiet" && echo "# $k not found." >&2
        test -z "$line" && continue
        val=$(echo "$line" | sed -e 's,/.*,,' | cut -d '=' -f2- | \
            sed -e 's,^[ ]*,,' | sed -e 's,[ ]*$,,' | sed -e "s,^',," | sed -e "s,'$,,")
        if [ "${keylist/,/}" == "$keylist" ] || [ "$do_skip_keywords" ]
        then
            echo "${val}"
        else
            echo "${k^^}=${val}"
        fi
        retval=0
    done
    rm $tmp1
    return $retval
}

set_header () {
    # write value of given keyword to image header
    # keyword parameter and value syntax: keyword=value/comment
    # strings values should be quoted: "'new string value'"
    local showhelp
    local verbose
    local no_update     # if set then header keywords are not modified/added
    local i
    for i in 1 2 3
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-v" && verbose=1 && shift 1
        test "$1" == "-n" && no_update=1 && shift 1
    done

    local img=$1    # either image or ahead file
    local hdr
    local kv
    local k
    local val
    local c
    local s
    local n
    local oldval
    local oldcomm

    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: set_header [-n] <img|hdrfile> <keyword=value/description> [keyword2=value2/description2] ..." >&2 &&
        return 1
    
    test ! -e $img &&
        echo "ERROR: file $img not found." >&2 && return 255
    if is_ahead $img
    then
        hdr=$img
    else
        ! is_pnm $img && ! is_fits $img &&
        echo "ERROR: $img has unsupported format." >&2 && return 255
        is_pnm $img && hdr=${img%.*}.head && test ! -e $hdr &&
            echo "ERROR: missing ascii header file $hdr." >&2 && return 255
    fi

    test "$no_update" &&
        echo "WARNING: header keywords are not modified!" >&2
    shift 1
    if is_fits $img
    then
        for kv in "$@"
        do
            sethead $img ${kv#*/}
        done
        return
    fi

    for kv in "$@"
    do
        k=$(printf "%-8s" ${kv%%=*}); k=${k^^}
        s=$(echo "${kv#*=}" | sed -e 's/^[ ]*//; s/[ ]*$//')
        val=$(echo "${s%%/*}" | sed -e 's/^[ ]*//; s/[ ]*$//')
        test "$AI_DEBUG" && echo "k=_${k}_ s=_${s}_ val=_${val}_" >&2

        # read original value and comment
        oldval=$(get_header -q $hdr $k)
        oldcomm=$(grep "^${k}=.*/.*[a-zA-Z]" $hdr | sed -e "s|.*/[ ]*||")

        # empty value removes keyword from header file
        if [ -z "$val" ] && [ "$oldval" ]
        then
            test -z "$no_update" &&
                sed --follow-symlinks -i '/^'${k/ */}'[ ]*=/d' $hdr
            continue
        fi
        
        # keep comment from original keyword if not set
        c=""
        test "$s" != "$val" && c=$(echo "${s#*/}" | sed -e 's/^[ ]*//; s/[ ]*$//')
        test -z "$c" && c="$oldcomm"

        # skip writing to header if nothing has changed
        if [ "$val" == "$oldval" ] && [ "$c" == "$oldcomm" ]
        then
            test "$verbose" && echo "#" $k "is unchanged" >&2
            continue
        else
            test "$verbose" && echo "# val:  \"$oldval\" -> \"$val\""  >&2
            test "$verbose" && echo "# comm: \"$oldcomm\" -> \"$c\""  >&2
        fi
        
        # quote string value if necessary
        ! is_number "$val" &&
            ! is_number "$(echo $val | sed -e 's/E[+-]*[0-9][0-9]*$//')" &&
            test "${val:0:1}" != "'" &&
            test "$val" != "T" &&
            test "$val" != "F" &&
            val="'${val}'"
        
        # pad spaces around value
        test "${val:0:1}" == "'" && val=$(printf "%-20s" "$val")
        test "${val:0:1}" != "'" && val=$(printf "%20s"  "$val")
        
        # create record optionally trimming comment
        s="${k}= ${val}"
        n=$(echo ${#s} ${#c} | awk '{x=80-$1-3; if($2<x) x=$2; print x}')
        test "$c" && s="$s / ${c:0:n}"
        test "$verbose" && echo "$s" >&2
        if [ -z "$no_update" ]
        then
            if grep -q "^${k}=" $hdr
            then
                sed --follow-symlinks -i "s/^${k}=.*/${s//\//\\/}/" $hdr
            else
                sed --follow-symlinks -i '/^END[ ]*$/d' $hdr
                echo "${s}" >> $hdr
                echo "END" >> $hdr
            fi
        fi
    done
    return
}

get_exclude () {
    # read AI_EXCLUDE by evaluating last definition in imred_$day.txt
    local showhelp
    local i
    for i in 1
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    done
    local adir=$1
    local f
    local l

    (test "$showhelp" || test $# -ne 1) &&
        echo "usage: get_exclude <adir>" >&2 &&
        return 1

    test ! -d "$adir" && echo "ERROR: $adir not found." && return 255
    f=$(cd $adir; ls | grep -E "imred_[0-9]{6}[a-z]*.txt" 2>/dev/null | wc -l)
    test $f -eq 0 && echo "ERROR: file imred_[0-9]*.txt not found." && return 255
    test $f -gt 1 && echo "ERROR: file imred_[0-9]*.txt not unique." && return 255

    f=$(cd $adir; ls | grep -E "imred_[0-9]{6}[a-z]*.txt")
    l=$(grep -n "^AI_EXCLUDE=" $adir/$f | tail -1 | cut -d ':' -f1)
    test "$AI_DEBUG" && echo "f=$f" && echo "l=$l"
    echo $(cat $adir/$f | awk -v l=$l '{
        if(NR==l){ok=1}
        if(ok==1) {print $0}
        if(NR>l && $1!~/[0-9]/) ok=0
    }' | tr -d '\\\\' | tr '"' '\n' | grep "[0-9]")
}

getImageDateSec () {
    local num=$1
    local imDateTime=$(exiv2 -g "Exif.Image.DateTime" \
        $(get_imfilename $num) | awk '{print $4" "$5}' | \
        sed -e 's|:|-|;s|:|-|')
    local imSec=$(date -d "$imDateTime" +"%s")
    echo $imSec
}

get_jd () {
    # get jd by testing several keywords
    local klist="JD,DATE-OBS"   # keywords to check in order
    local do_quiet
    local showhelp
    local i
    for i in 1 2 3
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-k" && klist=$2 && shift 2
        test "$1" == "-q" && do_quiet=1 && shift 1
    done

    local hdr=$1    # image name or header file
    local k
    local jd
    local dobs
    local tobs
    
    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: get_jd [-q] [-k key1,key2,...|$klist] <hdr>" >&2 &&
        return 1

    for k in ${klist//,/ }
    do
        test -z "$jd" &&
        if [ "$k" != "DATE-OBS" ]
        then
            jd=$(get_header -q $hdr $k | awk '{printf("%.5f\n", $1)}')
        else
            dobs=$(get_header -q $hdr DATE-OBS)
            test "$AI_DEBUG" && echo "DATE-OBS=$dobs" >&2
            if [ "${dobs/T/}" != "$dobs" ]
            then
                jd=$(ut2jd $(echo $dobs | tr -d '-' | awk -F "T" '{
                    print $2" "substr($1,3)}'))
            else
                tobs=$(get_header -q $hdr TIME-OBS)
                test "$tobs" &&
                    echo ${dobs:2} $tobs | tr -d '-' >&2 &&
                    jd=$(ut2jd $(echo $tobs ${dobs:2} | tr -d '-'))
            fi
        fi
    done
    test -z "$jd" && ! test "$do_quiet" &&
        echo "ERROR: unable to obtain JD." >&2 && return 255
    echo $jd
}

get_jd_dmag () {
    # extract JD and dmag for individual images of a set using
    # measure/$num.src.head and reg.dat
    local guesstime # if set guess jd by means of mean jd of set and exposure time
    local showhelp
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-g" && guesstime=1 && shift 1
    done

    local set=$1
    local reg="reg.dat"
    local exifdat="exif.dat"
    local rawfilesdat="rawfiles.dat"
    local sites="sites.dat"
    local nlist
    local num
    local ut
    local tzoff
    local jd
    local dateobs
    local dmag
    
    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: get_jd_dmag [-g] <set>" >&2 &&
        return 1

    nlist=$(AIimlist -n $set 2>/dev/null)
    test -z "$nlist" && nlist=$(AIimlist -n $set "" raw 2>/dev/null)
    test -z "$nlist" &&
        echo "WARNING: no images for set $set in \$AI_TMPDIR and \$AI_RAWDIR" >&2 &&
        nlist=$(AIimlist -x $set)
    test -z "$nlist" && 
        echo "ERROR: image set $set not defined in set.dat" >&2 &&
        return 255

    if [ "$guesstime" ]
    then
        jd=$(get_jd $set.head)
        test $? -ne 0 && return 255
        texp=$(get_header $set.head EXPTIME)
        test $? -ne 0 && return 255
        nexp=$(get_header $set.head NEXP)
        test $? -ne 0 && return 255
        # determine time of reference image
        nref=$(AIsetinfo -b $set | grep -w o | head -1 | awk '{printf("%s", $8)}' )
        for num in $nlist
        do
            echo $num $nref $nexp $texp $jd | awk -v d=15 '{
                ds=($1-$2)*($4/$3+d)
                printf("%s %.3f %s\n", $1, $5+ds/3600/24, 0)}'
            i=$((i+1))
        done
        return
        
        i=1
        for num in $nlist
        do
            echo $i $nexp $texp $jd | awk -v n=$num -v d=15 '{
                m=(1+$2)/2
                ds=($1-m)*($3/$2+d)
                printf("%s %.3f %s\n", n, $4+ds/3600/24, 0)}'
            i=$((i+1))
        done
        return
    fi
    for num in $nlist
    do
        if [ -f measure/$num.src.head ]
        then
            jd=$(grep -E "^MJD_|^JD " measure/$num.src.head | head -1 | tr '=' ' ' | \
                awk '{printf("%s", $2)}')
            if [ -z "$jd" ]
            then
                dateobs=$(grep "^DATE-OBS=" measure/$num.src.head | tr -d "'" | awk '{print $2}')
                test "$dateobs" && jd=$(ut2jd $(echo $dateobs | tr -d '-' | \
                    awk -F "T" '{print $2" "substr($1,3)}'))
            fi
            test -z "$jd" &&
                echo "ERROR: failed to get jd from measure/$num.src.head." >&2 && return 255
        else
            # get texp jd from exifdat
            set - $(test -e $exifdat && grep -v "^#" $exifdat | \
                awk -v n=$num '{if($2==n){printf("%s", $0)}}' | head -1) x
            if [ $# -ge 3 ]
            then
                # we assume that time is in UT already
                jd=$(ut2jd $3 $day | awk '{printf("%.5f", $1)}')
                test ${3:0:1} -eq 0 && x=$(echo $x | awk '{printf("%.5f", $1+1)}')
            else
                # get texp jd from rawfilesdat
                set - $(test -e $rawfilesdat && grep -v "^#" $rawfilesdat | \
                    awk -v n=$num '{if($1==n){printf("%s", $0)}}' | head -1) x
                if [ $# -ge 5 ]
                then
                    jd=$5
                else
                    echo "ERROR: unable to determine JD for image $num." >&2 && return 255
                fi
            fi
        fi
        
        if [ -f $reg ]
        then
            dmag=$(grep "^$num " $reg | awk '{printf("%.3f", $10)}')
            test -z "$dmag" &&
                echo "ERROR: failed to get dmag from $reg ($num)." >&2 && return 255
        else
            dmag=0
        fi
        echo $num $jd $dmag
    done
    return
}

cometcenter () {
    # determine comet center
    # returns ds9 region file
    local use_isophotes # if set use isophotes in sextractor (AIsource)
    local use_max       # if set then return max pixel in smoothed image
    local showhelp
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-m" && use_max=1 && shift 1
    done
    local set=$1
    local cosub=${2:-""}

    local coreg=comet/$set.comet.reg
    local bgreg=comet/$set.cometbg.reg
    local badreg=comet/$set.bad.reg     # optional
    local cosub
    local hdr
    local imult=1
    local ext
    local f
    local mzero
    local texp
    local nexp
    local area
    local opts
    local x
    local tmpim1=$(mktemp "/tmp/tmp_im1_$$.XXXXXX.pnm")
    local tmpreg=$(mktemp "/tmp/tmp_reg_$$.XXXXXX.reg")
    local tmpsrc=$(mktemp "/tmp/tmp_src_$$.XXXXXX.dat")
    local tmpdat=$(mktemp "/tmp/tmp_dat_$$.XXXXXX.dat")
    
    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: cometcenter [-m] <set> [cosub]" >&2 &&
        return 1
    
    test -e $set.ppm && ext=ppm
    test -z "$ext" && test -e $set.pgm && ext=pgm
    test -z "$ext" &&
        echo "ERROR: no image stack ($set.ppm or $set.pgm) found." >&2 && return 255

    if [ -z "$cosub" ]
    then
        cosub=comet/$set.cosub.$ext
        test ! -e $cosub && cosub=comet/$set.cosub10.$ext && imult=10
    fi
    test ! -e $cosub &&
        echo "ERROR: no cosub image found." >&2 && return 255
    hdr=$set.head
    test ! -e $hdr &&
        echo "ERROR: header file $hdr not found." >&2 && return 255

    for f in $cosub $coreg
    do
        test ! -e $f &&
            echo "ERROR: region file $f not found." >&2 && return 255
    done
    
    # get total exposure time and number of images
    texp=$(get_header $hdr EXPTIME)
    test $? -ne 0 &&
        echo "ERROR: missing header keyword." >&2 && return 255
    nexp=$(get_header $hdr NEXP)
    test $? -ne 0 &&
        echo "ERROR: missing header keyword." >&2 && return 255
    # determine mag zero point of cosub image
    mzero=$(get_param camera.dat magzero $set AI_MAGZERO 25.5)
    x=$(di2dmag $(echo "$texp / $nexp * $imult" | bc -l))
    mzero=$(echo "$mzero $x" | awk '{printf("%.2f", $1-$2)}')
    # determine comet area in pixels
    area=$(get_header $hdr AC_AREA1)
    test -z "$area" && area=1
    
    cat $coreg > $tmpreg
    if [ -e $badreg ]
    then
        # prepend "-" to mark regions for excluding
        grep -E "^circle|^polygon|^box" $badreg | sed -e 's|^|-|' >> $tmpreg
    fi

    # smooth cosub image
    #convert $cosub -median 3 $tmpim1
    if [ $area -lt 1000 ]
    then
        pnmsmooth -size 3 3 $cosub > $tmpim1
    else
        pnmsmooth -size 5 5 $cosub > $tmpim1
    fi
    test ! "$AI_DEBUG" && opts="-q"
    AI_MAGZERO=$mzero AIsource $opts -2 -o $tmpsrc $tmpim1 "${use_isophotes}" 5
    regfilter $tmpsrc $tmpreg | sexselect - | grep -v "^#" | \
        LANG=C sort -n -k10 > $tmpdat
    test "$AI_DEBUG" && cat $tmpdat >&2
    set - $(head -1 $tmpdat)
    
    echo "# Region file format: DS9 version 4.1
global color=green dashlist=8 3 width=1 font=\"helvetica 10 normal roman\" \
select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1
physical"
    if [ "$use_max" ]
    then
        w=$(echo $6 | awk '{printf("%.0f", 3+2*int($1/2))}')
        h=$(imsize $tmpim1 | cut -d " " -f2)
        x1=$(echo $2 $w | awk '{printf("%.0f", $1-$2/2)}')
        y1=$(echo $3 $w | awk -v h=$h '{printf("%.0f", h-$1-$2/2)}')
        echo "# w=$w x1=$x1 y1=$y1" >&2
        # sortcol: pgm 3, ppm 4
        if is_ppm $tmpim1
        then
            AIval -c $tmpim1 $w $w $x1 $y1 | sort -n -k 4,4 | tail -9 > $tmpdat
        else
            AIval -c $tmpim1 $w $w $x1 $y1 | sort -n -k 3,3 | tail -9 > $tmpdat
        fi
        x1=$(median $tmpdat 1 | awk '{print $1+1}')
        y1=$(median $tmpdat 2 | awk -v h=$h '{print h-$1}')
        LANG=C printf "circle(%.2f,%.2f,%.1f) # text={%.1f cmax}\n" \
            $x1 $y1 $6 $7
    else
        LANG=C printf "circle(%.2f,%.2f,%.1f) # text={%.1f}\n" \
            $2 $3 $6 $7
    fi
    

    test "$AI_DEBUG" && echo $tmpim1 $tmpreg $tmpsrc $tmpdat >&2
    test -z "$AI_DEBUG" && rm -f $tmpim1 $tmpreg $tmpsrc $tmpdat
    return
}

cometsmooth () {
    # smooth comet image to enhance structure and eliminate background stars
    # TODO: operate on smaller image area only (outer coma region + trail_length + 2*20px)
    #       eliminate bg stars
    local showhelp
    local blurscale=1
    local bgcoimg       # bg in coimg
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-b" && blurscale=$2 && shift 2
        test "$1" == "-bg" && bgcoimg=$2 && shift 2
    done
    local set=$1
    local coimg=$2      # comet image (comet stack without star trails,
                        #   stretched by comult)
    local smoothreg=$3  # ds9 region file with polygon masks named core,
                        # inner, outer and optionally bad for core
                        #   (unsmoothed), inner coma, outer coma and excluded areas
    local bgval=2000    # bg val in result image
    local comult
    local ext
    local hdr
    local coreg
    local tdir=${AI_TMPDIR:-"/tmp"}
    local wdir=$(mktemp -d "$tdir/tmp_cosmooth_XXXXXX")

    (test "$showhelp" || test $# -ne 3) &&
        echo "usage: cometsmooth [-b blurscale|$blurscale] [-bg bgr,bgg,bgb] <set> <coimg> <smoothreg>" >&2 &&
        return 1
    
    test -e $set.ppm && ext=ppm
    test -z "$ext" && test -e $set.pgm && ext=pgm
    test -z "$ext" &&
        echo "ERROR: no image stack ($set.ppm or $set.pgm) found." >&2 && return 255

    test ! -e $coimg &&
        echo "ERROR: image $coimg does not exist." >&2 && return 255
    hdr=$set.head
    test ! -e $hdr &&
        echo "ERROR: header file $hdr not found." >&2 && return 255
    test ! -e $smoothreg &&
        echo "ERROR: region file $smoothreg does not exist." >&2 && return 255
    # TODO: check for named regions
    
    # create mask images
    reg2pbm $coimg $smoothreg core  > $wdir/x.core.m.pbm
    reg2pbm $coimg $smoothreg inner > $wdir/x.inner.m.pbm
    reg2pbm $coimg $smoothreg outer > $wdir/x.outer.m.pbm

    # TODO: measure bg in coimg just outside of outer region
    false && convert $wdir/x.outer.m.pbm -dilate 5 - | \
        pnmarith -sub - $wdir/x.outer.m.pbm > $wdir/x.bgmask.pbm
    test -z "$bgcoimg" && bgcoimg=2000
    test "$ext" == "ppm" &&
        test $(echo $bgcoimg | tr ',' ' ' | wc -w) -eq 1 &&
        bgcoimg="$bgcoimg,$bgcoimg,$bgcoimg"
    
    # TODO: replace bad area
    
    # create smoothed images
    # blur 0x1.8 2xS/N
    # blur 0x4   5xS/N
    add=$(echo $bgcoimg | tr ',' ' ' | awk -v b=$bgval '{
        printf("%.0f", b-$1)
        if (NF==3) printf(",%.0f,%.0f", b-$2, b-$3)}')
    echo add=$add >&2
    pnmccdred -a $add $coimg $wdir/x.core.$ext # bright core - not smoothed
    convert $wdir/x.core.$ext -blur 0x1.0 $wdir/x.inner.$ext # center coma
    convert $wdir/x.core.$ext -blur 0x2.6 $wdir/x.outer.$ext # outer coma and tail
        
    # TODO: measure size of regions to determine amount of blurring
    
    # blur edges of mask images
    # the second number in the blur parameter approximatly corresponds
    # to the distance of blurring at both sides of the edge
    (cd $wdir
    pnmdepth 65535 x.core.m.pbm  | convert - -blur 0x$blurscale x.core.mb.pgm
    pnmdepth 65535 x.inner.m.pbm | convert - -blur 0x$((blurscale*3)) - | \
        pnmccdred -d x.core.mb.pgm - x.inner.mb.pgm
    pnmdepth 65535 x.outer.m.pbm | convert - -blur 0x$((blurscale*9)) - | \
        pnmccdred -d x.core.mb.pgm - - | \
        pnmccdred -d x.inner.mb.pgm - x.outer.mb.pgm
    # outside of comet area
    pnmarith -add x.core.mb.pgm x.inner.mb.pgm | \
        pnmarith -add - x.outer.mb.pgm | pnminvert > x.outside.mb.pgm
    )
    
    # create smoothed comet image
    (cd $wdir
    pnmarith -mul x.core.$ext  x.core.mb.pgm    > x.core.part.$ext
    pnmarith -mul x.inner.$ext x.inner.mb.pgm   > x.inner.part.$ext
    pnmarith -mul x.outer.$ext x.outer.mb.pgm   > x.outer.part.$ext
    pnmccdred -m 0 -a $bgval x.core.$ext - | \
        pnmarith -mul -        x.outside.mb.pgm > x.outside.part.$ext
    )
    pnmarith -add $wdir/x.core.part.$ext $wdir/x.inner.part.$ext | \
        pnmarith -add - $wdir/x.outer.part.$ext | \
        pnmarith -add - $wdir/x.outside.part.$ext

    #test "$AI_DEBUG" &&
    echo $wdir >&2 && return
    rm -rf $wdir
    return
}

mkcotrail () {
    # create artificial motion blur of comet image corresponding to exposures
    # and mag differences read from <obsdata> text file
    local showhelp
    local outimg        # name of output image
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-o" && outimg=$2 && shift 2
    done
    local set=$1
    local coimg=$2      # comet image
    local omove=$3      # dr@pa@x,y: dr - object move on the sky in "/hr
                        # pa - pa in deg (N over W)
                        # x,y - object position in costack (image coord. system)
    local obsdata=$4    # observations data for individual images of ststack
                        # lines: imageID JD dmag (dmag with arbitrary zero point)
    local bgval=${5:-2000} # bg value in coimg
    
    local tmp1=$(mktemp "/tmp/tmp_cophot_$$.XXXXXX")
    local ext
    local wcshdr
    local jdref
    local magzero
    local texp
    local r
    local p
    local mmag
    local w
    local h
    local cmag
    local val
    local id
    local jd
    local mag
    local dm
    local dt
    local x
    local y
    
    (test "$showhelp" || test $# -lt 4) &&
        echo "usage: mkcophot <set> <coimg> <omove> <obsdata> [bgval|$bgval]" >&2 &&
        return 1

    # set output image name
    ext=${coimg##*.}
    test -z "$outimg" && outimg=$set.cotrail.$ext

    # read some header keywords
    wcshdr=$set.wcs.head
    jdref=$(get_header -q $set.head JD_REF)
    test -z "$jdref" && jdref=$(get_header -q $set.head MJD_REF)
    test -z "$jdref" && jdref=$(get_header -q $set.head JD_OBS)
    test -z "$jdref" && jdref=$(get_header -q $set.head MJD_OBS)
    test -z "$jdref" && jdref=$(get_header -q $set.head JD)
    test -z "$jdref" &&
        echo "ERROR: unknown JD." >&2 && return 255
    magzero=$(get_header $set.head MAGZERO)
    texp=$(get_header -s $set.head EXPTIME,NEXP | tr '\n' ' ' | awk '{print $1/$2}')
    r=$(get_wcsrot $wcshdr $(echo $omove | awk -F "@" '{print $3}' | tr ',' ' '))
    p=$(get_wcspscale $wcshdr)

    # round bgval to nearest integer
    bgval=$(echo $bgval | awk '{printf("%.0f", $1)}')
    
    # measure comet brightness (arbitrary zeropoint)
    w=$(identify $coimg | cut -d " " -f3 | cut -d "x" -f1)
    h=$(identify $coimg | cut -d " " -f3 | cut -d "x" -f2)
    x=$(imcount $coimg)
    cmag=$(for y in ${x//,/ }
        do
            val=$((y-w*h*bgval))
            test $val -gt 0 && i2mag $val $texp $magzero
            test $val -le 0 && echo 99
        done | \
        tr '\n' ',' | sed -e 's/,$//')
    echo "# cmag=$cmag" >&2

    # deal with empty obsdata file (no info about individual exposures)
    x=$(grep -v "^#" $obsdata | wc -l)
    test $x -eq 0 &&
        pnmccdred -a -$bgval $coimg $outimg &&
        rm -f $tmp1 && return

    
    # process obsdata file
    mmag=$(grep -v "^#" $obsdata | awk '{x=x+exp(-0.4*$3*log(10))}
            END {printf("%.3f\n", -2.5/log(10)*log(x/NR))}')
    grep -v "^#" $obsdata | while read id jd mag
    do
        # determine photometric correction with respect to ststack
        dm=$(echo $mmag $mag | awk '{printf("%.3f", $1-$2)}')
        
        # time offset with respect to nref in seconds
        dt=$(echo $jdref $jd | awk  '{printf("%d", ($2-$1)*24*3600)}')
        
        # determine comets offset with respect to jdref in cartesian x/y
        x=$(echo $omove $dt $r $p | awk '{
            split($1,a,/@/)
            r=(a[2]-$3)*3.1415926/180
            printf("%.2f", -1*a[1]*sin(r)*$2/$4/3600)}')
        y=$(echo $omove $dt $r $p | awk '{
            split($1,a,/@/)
            r=(a[2]-$3)*3.1415926/180
            printf("%.2f", a[1]*cos(r)*$2/$4/3600)}')

        test "$AI_DEBUG" && echo "# $dt $x $y" >&2
        # create "photometry" data file
        # x,y starting at upper left image corner = 0,0
        echo "$id $x $y $dm $dt ${cmag//,/ }" | awk -v w=$w -v h=$h '{
            r0=$6; g0=$6; b0=$6; if (NF==8) {g0=$7; b0=$8}
            printf("%s  %.2f %.2f  %.3f %.3f %.3f  %5d\n",
                $1, w/2+$2, h/2-$3, $4+r0, $4+g0, $4+b0, $5)
        }'
    done > $tmp1

    x=$(echo $texp $(wc -l $tmp1) | awk '{printf("%f", $1/$2)}')
    test "$AI_DEBUG" &&
        echo AIskygen -o $outimg $tmp1 $coimg $x $magzero 1 $w $h $bgval >&2
    AIskygen -o $outimg $tmp1 $coimg $x $magzero 1 $w $h $bgval
    
    test "$AI_DEBUG" || rm -f $tmp1
    return
}


get_telescope () {
    # get telescope identifier of the given set evaluating
    #   - $sname.head
    #   - measure/$nref.src.head
    #   - rawfile starting with $nref
    # fallback: unique entry in camera.dat according to flen,fratio
    local showhelp
    local quiet
    local i
    for i in 1 2
    do
        test "$1" == "-q" && quiet=1 && shift 1
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    done
    local sname=$1
    local sdat=${AI_SETS:-"set.dat"}
    local tel
    local exifdat="exif.dat"
    local cameradat="camera.dat"
    local nlist
    local nref
    local flen
    local fratio
    local line
    local fname
    
    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: get_telinfo <set|img>" >&2 &&
        return 1

    # examine environment
    test "$AI_TELESCOPE" && echo $AI_TELESCOPE && return
    
    # examine keywords TELESCOP and OBSERVAT in $sname.head
    fname="$sname.head"
    if [ -f $fname ]
    then
        tel=$(get_header -q $fname AI_TELID)
        test -z "$tel" &&
            tel=$(grep "^TELESCOP=" $fname | tr ' ' '\n' | tr -d "'i" | \
            grep "^T[0-9]*$" | head -1)
        test -z "$tel" &&
            tel=$(grep "^OBSERVAT=" $fname | tr ' ' '\n' | tr -d "'i" | \
            grep "^T[0-9]*$" | head -1)
        test "$AI_DEBUG" && test -z "$tel" && echo "INFO: tel not in $fname" >&2
    else
        test "$AI_DEBUG" && echo "WARNING: file $fname not found" >&2
    fi
    test "$tel" && echo "$tel" && return

    # try to obtain telescope identifier from set.dat (field 11)
    tel=$(grep -v "^#" $sdat | egrep "^[0-9]{2}:[0-9]{2} $sname " | head -1 | awk '{
        if ($11!~/^#/) {printf("%s", $11)}}')
    test "$AI_DEBUG" && test -z "$tel" && echo "INFO: tel not in $sdat" >&2
    test "$tel" && echo "$tel" && return
  
    # determine nref
    nref=$(grep -v "^#" $sdat | grep "^[0-9]*:[0-9]* $sname " | head -1 | awk '{
        printf("%s", $8)}')
    test "$AI_DEBUG" && echo "nref(1)=$nref" >&2
    if ! is_integer "$nref"
    then
        nref=""
        nlist=$(AIimlist -n $sname 2>/dev/null)
        test -z "$nlist" && nlist=$(AIimlist -n $sname "" raw 2>/dev/null)
        test "$nlist" && nref=$(echo $nlist | awk '{i=int(NF/2)+1; printf("%s", $i)}')
        test "$AI_DEBUG" && echo "nref(2)=$nref" >&2
    fi
    ! is_integer "$nref" &&
        echo "ERROR: cannot determine nref in set $sname." >&2 && return 255

    # examine measure/$nref.src.head
    fname="measure/$nref.src.head"
    if [ -f $fname ]
    then
        tel=$(grep "^TELESCOP=" $fname | tr ' ' '\n' | tr -d "'i" | \
            grep "^T[0-9]*$" | head -1)
        test -z "$tel" &&
            tel=$(grep "^OBSERVAT=" $fname | tr ' ' '\n' | tr -d "'i" | \
            grep "^T[0-9]*$" | head -1)
        test "$AI_DEBUG" && test -z "$tel" && echo "INFO: tel not in $fname" >&2
    else
        test "$AI_DEBUG" && echo "WARNING: file $fname not found" >&2
    fi
    test "$tel" && echo "$tel" && return
    
    # examine raw file
    fname=$(AIimlist -f $sname "" raw 2>&1 | grep "/$nref\.")
    #test -z "$fname" && fname=$(get_imfilename $nref)
    test ! "$quiet" && test -z "$fname" &&
        echo "WARNING: no image for nref=$nref found." >&2
    if [ -f "$fname" ]
    then
        if is_raw $fname
        then
            test "$AI_DEBUG" &&
                echo "INFO: $fname is DSLR camera RAW file" >&2
        else
            tel=$(get_header -q -s $fname TELESCOP,OBSERVAT | tr ' ' '\n' | tr -d "i" | \
                grep "^T[0-9]*$" | head -1)
            test "$AI_DEBUG" && test -z "$tel" &&
                echo "WARNING: tel not in $fname" >&2
        fi
    fi
    test "$tel" && echo "$tel" && return

    
    # examine header file associated with raw file
    fname=${fname%.*}".hdr"
    if [ -f $fname ]
    then
        tel=$(get_header -q $fname TELESCOP 2>/dev/null)
    fi
    test "$tel" && echo "$tel" && return
    
    # try to find unique entry for flen/fratio (from exif.dat) in cameradat
    test ! -f $cameradat && echo "ERROR: file $cameradat not found." >&2 && return 255
    if [ -e $exifdat ]
    then
        flen=$(get_param -k 2 $exifdat flen $nref)
        fratio=$(get_param -k 2 $exifdat fn $nref)
        line=$(cat $cameradat | awk -v flen=$flen -v fratio=$fratio 'BEGIN{hfound=0}{
            if(hfound==0 && $1=="#") {
                hfound=1
                for(i=1;i<=NF;i++) {if($i=="flen") cflen=i-1; if($i=="fratio") cfratio=i-1}
            }
            if (hfound>0 && cflen>0 && cfratio>0) {
                if ($cflen == flen && $cfratio == fratio) {
                    printf("%s\n", $1)
                }
            }
        } END {
            if (cflen==0 && cfratio==0) printf("ERROR: column(s) flen and/or fratio not found")
        }')
    fi

    test "$AI_DEBUG" && echo "line=$line" >&2
    if [ $(echo $line | wc -w) -eq 0 ]
    then
        test ! "$quiet" &&
            echo "WARNING: no match of flen=$flen fratio=$fratio in $cameradat" >&2
        return 255
        # fallback: first entry in cameradat
        #tel=$(grep -v "^#" $cameradat | head -1 | cut -d ' ' -f1)
    else
        test $(echo $line | wc -w) -eq 1 && echo $line && return
        test $(echo $line | wc -w) -ge 2 && echo "$line" | grep -q -w ERROR - &&
            echo "$line" >&2 && return 255
        if [ $(echo $line | wc -w) -ge 2 ]
        then
            test ! "$quiet" &&
                echo "WARNING: multiple matches of flen=$flen fratio=$fratio in $cameradat" >&2
            return 255
        fi
    fi
}

get_param () {
    # get parameter from environment or named column in data file or from
    #   default value (5th parameter)
    # requires column names at start of data file like: # col1 col2 ... colN
    local showhelp
    local kname=1   # either column name or number
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-k" && kname=$2 && shift 2
    done
    local dat=$1
    local paramname=$2
    local sname=$3
    local envname=${4:-""}
    local valdefault=${5:-""}
    local val
    local line
    local errmsg
    local keyval
    
    (test "$showhelp" || test $# -lt 3) &&
        echo "usage: get_param [-k keyname|keycolumn] <datafile> <paramname> <keyvalue|setname> [envname] [default]" >&2 &&
        return 1
    
    # get value of envname from environment
    test "$envname" && val=$(eval echo \$$envname)
    test "$val" && echo "$val" && return
    
    # checkings
    test ! -f "$dat" &&
        echo "ERROR: data base file $dat not found." >&2 && return 255

    # set keyvalue for given data file
    case "$dat" in
        camera.dat)     if [ "$AI_TELESCOPE" ]
                        then
                            keyval=$AI_TELESCOPE
                        else
                            keyval=$sname
                            # check if sname has matching entry in set.dat
                            if is_setname $sname
                            then
                                keyval=$(get_telescope $sname 2>/dev/null)
                                test $? -ne 0 &&
                                    echo "ERROR: failed command: get_telescope $sname" >&2 &&
                                    return 255
                            fi
                        fi
                        ;;
        *)              keyval=$sname;;
    esac
    test "$AI_DEBUG" &&
        echo "cat $dat | awk -v keyval=\"$keyval\" -v kname=$kname -v pname=\"$paramname\" ..." >&2
    line=$(cat $dat | awk -v keyval="$keyval" -v kname=$kname -v pname="$paramname" \
    'BEGIN{hfound=0; hline=""; kcol=0; pcol=0}{
        if(NF==0) next
        if(hfound==0 && $1=="#") {
            hline=$0
            if(kname~/^[0-9]+$/) {kcol=kname} else {
                for(i=1;i<=NF;i++) if($i==kname) kcol=i-1
            }
            for(i=1;i<=NF;i++) if($i==pname) pcol=i-1
        } else {
            if (length(hline)>0) hfound=1
        }
        if (hfound>0 && kcol>0 && pcol>0) {
            if ($kcol == keyval) printf("%s\n", $pcol)
        }
    } END {
        if (kcol==0) printf("column %s not found\n", kname)
        if (pcol==0) printf("column %s not found\n", pname)
    }')
    test "$AI_DEBUG" && echo "line=$line" >&2
    test $(echo $line | wc -w) -eq 1 && echo $line && return


    # no unique match
    # create error message
    test $(echo $line | wc -w) -eq 0 &&
        errmsg="no match of $keyval in column $kname of $dat"
    test $(echo $line | wc -w) -ge 2 &&
        echo "$line" | grep -q "column .* not found" - && errmsg="$line"
    test -z "$errmsg" &&
        errmsg="multiple matches of $keyval in column $kname of $dat"
    
    # use default value if defined
    test "$valdefault" && echo "WARNING: $errmsg" >&2 &&
        echo "$valdefault" && return

    # otherwise exit with error
    echo "ERROR: $errmsg" >&2 && return 255
}

# extract image rotation angle from wcs header at arbitrary position on image
# value 90 means true north is right
get_wcsrot () {
    local showhelp
    local i
    for i in 1
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    done
    local whdr=$1       # ascii wcs header file or set name
    local x=${2:-""}    # image coordinate, if empty use CRPIXn
    local y=${3:-""}
    local w
    local wdeg
    local rad
    local ded
    local xy1
    local xy2
    
    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: get_wcsrot <set|wcshead> [x] [y]" >&2 &&
        return 1
    
    test $# -lt 1 && echo "ERROR: missing parameter <wcshdr>." >&2 && return 255
    test ! -f $whdr && whdr=$1.wcs.head
    test ! -f $whdr && echo "ERROR: file $whdr not found." >&2 && return 255
    
    test -z "$x" && x=$(grep "^CRPIX1 " $whdr | awk '{print 1*$3}')
    test -z "$y" && y=$(grep "^CRPIX2 " $whdr | awk '{print 1*$3}')

    ps=$(get_wcspscale $whdr)
    
    set - $(echo "id1 $x $y" | xy2rade - $whdr)
    rad=$1; ded=$2
    # two points dec +-100px
    xy1=$(echo $rad $ded $ps | awk '{printf("id1 %f %f", $1, $2-$3/36)}' | \
        rade2xy - $whdr)
    xy2=$(echo $rad $ded $ps | awk '{printf("id2 %f %f", $1, $2+$3/36)}' | \
        rade2xy - $whdr)
    echo $xy1 $xy2 | awk '{printf("%.3f\n", atan2($5-$2,$3-$6)*180/3.1415926)}'
}

# extract pixel scale from wcs projection matrix data
get_wcspscale () {
    local whdr=$1   # ascii wcs header file
    local ps

    test $# -lt 1 && echo "ERROR: missing parameter <wcshdr>." >&2 && return 255
    test ! -f $whdr && whdr=$1.wcs.head
    test ! -f $whdr && echo "ERROR: file $whdr not found." >&2 && return 255

    ps=$(grep "^CD[12]_[12] " $whdr | awk '{print $3}' | tr '\n' ' ' | awk '{
        pi=3.141592653
        r1=sqrt($1*$1 + $2*$2)
        r2=sqrt($3*$3 + $4*$4)
        printf("%.5f\n", 3600*(r1+r2)/2)
    }')
    test -z "$ps" &&
    ps=$(get_header -q -s $whdr CDELT1,CDELT2 | tr '\n' ' ' | awk '{
        pi=3.141592653
        r1=sqrt($1*$1)
        r2=sqrt($2*$2)
        printf("%.5f\n", 3600*(r1+r2)/2)
    }')
    test -z "$ps" && return 255
    echo $ps
}

get_omove () {
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    
    local sname=$1          # set name
    local wcshdr=${2:-""}   # ascii fits header file containing wcs data
    local dt=${3:-""}       # time diff in hours
    local dra=${4:-""}      # in sec
    local dde=${5:-""}      # in asec
    local de=${6:-""}       # in deg
    local ox=${7:-""}       # object position on image (default: CRPIXn in wcshdr)
    local oy=${8:-""}
    local sdat=${AI_SETS:-"set.dat"}
    local n1
    local n2
    local nref
    local jd1
    local jd2
    local jdref
    local dateobs
    
    (test "$showhelp" || test $# -lt 1) &&
        echo -e "usage: get_omove <set> [wcshdr] [dt/hrs] [dra/s] [dde/\"] [de/deg] [ox/px] [oy/px]" >&2 &&
        return 1

    if [ $# -lt 6 ]
    then
        if [ -f $sname.head ] && [ "$(get_header -q $sname.head NEXP)" == "1" ]
        then
            jdref=$(get_header -q $sname.head MJD_REF)
            test -z "$jdref" && jdref=$(get_header -q $sname.head MJD_OBS)
            test -z "$jdref" && jdref=$(get_header -q $sname.head JD)
            test -z "$jdref" && echo "ERROR: unable to determine jdref." >&2 && return 255
            set - $(grep   -v "^#" $sdat | awk -v s=$sname '{if($2==s){print $0}}')
            echo $3 $(jd2ut -t $jdref | cut -d ' ' -f2) 0
            return
        fi
        
        n1=$(AIimlist -n $sname 2>/dev/null | head -1)
        test -z "$n1" && echo "ERROR: no images found, missing AIccd?" >&2 && return 255
        n2=$(AIimlist -n $sname 2>/dev/null | tail -1)
        set - $(grep   -v "^#" $sdat | awk -v s=$sname '{if($2==s){print $0}}')
        for f in measure/$n1.src.head measure/$n2.src.head measure/$8.src.head
        do
            test ! -f "$f" && echo "ERROR: header file $f does not exist." >&2 &&
            return 255
        done
        jd1=$(grep -E "^MJD_OBS[ ]*=|^JD " measure/$n1.src.head  | head -1 | tr '=' ' ' | \
            awk '{printf("%s", $2)}')
        if [ -z "$jd1" ]
        then
            dateobs=$(grep "^DATE-OBS=" measure/$n1.src.head | tr -d "'" | awk '{print $2}')
            test "$dateobs" && jd1=$(ut2jd $(echo $dateobs | tr -d '-' | \
                awk -F "T" '{print $2" "substr($1,3)}'))
        fi
        jd2=$(grep -E "^MJD_OBS[ ]*=|^JD " measure/$n2.src.head  | head -1 | tr '=' ' ' | \
            awk '{printf("%s", $2)}')
        if [ -z "$jd2" ]
        then
            dateobs=$(grep "^DATE-OBS=" measure/$n2.src.head | tr -d "'" | awk '{print $2}')
            test "$dateobs" && jd2=$(ut2jd $(echo $dateobs | tr -d '-' | \
                awk -F "T" '{print $2" "substr($1,3)}'))
        fi
        jdref=$(grep -E "^MJD_OBS[ ]*=|^JD " measure/$8.src.head | head -1 | tr '=' ' ' | \
            awk '{printf("%s", $2)}')
        if [ -z "$jdref" ]
        then
            dateobs=$(grep "^DATE-OBS=" measure/$8.src.head | tr -d "'" | awk '{print $2}')
            test "$dateobs" && jdref=$(ut2jd $(echo $dateobs | tr -d '-' | \
                awk -F "T" '{print $2" "substr($1,3)}'))
        fi
        echo $3 $jd1 $jd2 $jdref | awk '{
                f=$4-int($4); x=f*24+12; h=int(x);
                y=(x-h)*60; m=int(y);
                s=(y-m)*60
            } END {
                printf("%s %d:%02d:%02.0f %.1f\n",
                    $1, h, m, s, ($3-$2)*24)
            }'
        return 255
    fi

    # dt in hrs, dra in sec, dde in arcsec, de in deg
    # get move in pix/min, x>0: move right (W), y>0: move up (N)
    oxy=$(echo "dt=$dt; dra=$dra; dde=$dde; de=$de;
        ox=-1*dra*15/dt/60*c(de*3.14159/180)/$AI_PIXSCALE;
        oy=dde/dt/60/$AI_PIXSCALE; ox; oy" | bc -l)

    # correct for field rotation (from wcs fit)
    rot=$(get_wcsrot $sname "$ox" "$oy")

    echo $oxy $rot | awk '{pi=3.141592;
        r=atan2($2, $1)*180/pi-$3; l=sqrt($1*$1+$2*$2)
        x=l*cos(r*pi/180); y=l*sin(r*pi/180)
        printf("oxmove=%.3f; oymove=%.3f; rot=%.3f\n", x, y, $3)}'
}


# convert from omove (dr/"@pa (N over W)) to trail vector parameters
# length,angle,centerfrac
omove2trail () {
    local showhelp
    local duration  # duration of image sequence in minutes
    local cfrac     # star stack reference point (0=start, 1=end of image sequence)
    for i in 1 2 3
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-d" && duration=$2 && shift 2
        test "$1" == "-c" && cfrac=$2 && shift 2
    done
    local set=$1
    local omove=$2  # dr@pa, where dr is object move in "/hr, pa is direction
                    #   of move on sky (N over W)
    local sdat=${AI_SETS:-"set.dat"}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpdat=$(mktemp "$tdir/tmp_dat_XXXXXX.dat")
    local trail     # length,angle,centerfrac - length in pix, pa in deg from
                    #   right over top, center fraction (0=start, 1=end of trail)
    local hdr=$set.head
    local whdr
    local nexp
    local nref
    local jd1
    local jd2
    local jdref
    local pscale
    local rot
    local length
    local angle
    local line
    
    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: omove2trail [-h] [-d duration_minutes] [-c cfrac]" \
            "<set> [omove_\"/hr@pa]" >&2 &&
        return 1

    ! is_setname $set &&
        echo "ERROR: entry for set $set in $sdat is missing (or incomplete)" >&2 && return 255
    test ! -e $hdr &&
        echo "ERROR: file $hdr not found." >&2 && return 255
    test -e $set.wcs.head && whdr=$set.wcs.head
    test -z "$whdr" && whdr=$hdr && test "$AI_DEBUG" &&
        echo "WARNING: $set.wcs.head not found" >&2
    
    # TODO check for valid wcs header
    pscale=$(get_wcspscale $whdr)
    test -z "$pscale" &&
        echo "ERROR: unable to determine pixel scale from $whdr" >&2 && return 255
    
    test -z "$omove" && omove=$(get_header $hdr AI_OMOVE)
    test -z "$omove" && echo "ERROR: unknown omove" >&2 && return 255

    if [ -z "$duration" ]
    then
        nexp=$(get_header $hdr NEXP)
        if [ "$nexp" == "1" ]
        then
            duration=$(get_header $hdr EXPTIME | awk '{print $1/60}')
            cfrac=0.5
            test $? -eq 0 && test "$AI_DEBUG" &&
                echo "# DEBUG $FUNCNAME: duration=$duration (nexp=1)" >&2
        fi
    fi
    if [ -z "$duration" ]
    then
        nref=$(AIsetinfo $set | awk '{printf("%s", $4)}')
        test -z "$nref" && echo "ERROR: unable to determine nref." >&2 && return 255
        get_jd_dmag $set > $tmpdat
        test ! -s $tmpdat && echo "ERROR: unknown duration of image sequence" >&2 && return 255
        
        jd1=$(grep -v "^#" $tmpdat | LANG=C sort -n -k 2,2 | head -1 | awk '{printf("%s", $2)}')
        jd2=$(grep -v "^#" $tmpdat | LANG=C sort -n -k 2,2 | tail -1 | awk '{printf("%s", $2)}')
        duration=$(echo $jd1 $jd2 | awk '{printf("%.1f", ($2-$1)*24*60)}')
        test "$AI_DEBUG" &&
            echo "# DEBUG $FUNCNAME: duration=$duration" >&2
    fi
    test "$duration" == "0" && echo "0,0,0" && return

    if [ -z "$cfrac" ] && [ "$jd1" ] && [ "$jd2" ]
    then
        # get jdref from $set.head or measure/$nref.src.head
        if [ -f $set.head ]
        then
            jdref=$(get_header -q $set.head JD_REF)
            test -z "$jdref" && jdref=$(get_header -q $set.head MJD_REF)
            test -z "$jdref" && jdref=$(get_header -q $set.head JD_OBS)
            test -z "$jdref" && jdref=$(get_header -q $set.head MJD_OBS)
        fi
        test -z "$jdref" && echo "WARNING: no JD_REF/JD_OBS in $set.head" >&2
        test -z "$jdref" && test -f measure/$nref.src.head &&
            jdref=$(get_header -q measure/$nref.src.head MJD_OBS)
        test -z "$jdref" &&
            jdref=$(grep -w "^$nref" $tmpdat | awk '{printf("%s", $2)}')
        test -z "$jdref" &&
            echo "ERROR: jdref undefined." >&2 && return 255
        cfrac=$(echo $jd1 $jd2 $jdref | awk '{printf("%.2f", ($3-$1)/($2-$1))}')
    fi
    if [ -z "$cfrac" ]
    then
        # determine cfrac from n1 n2 nref in set.dat
        # assuming set of continuous images
        line=$(grep -v "^#" $sdat | sed -e 's|#.*||' | \
            awk -v s=$set '{if($2==s && $4=="o") {print $0}}')
        cfrac=$(echo $line | awk '{x=0.5; if($6!=$7){x=($8-$6)/($7-$6)}; printf("%.2f", x)}')
    fi
    test -z "$cfrac" &&
        echo "ERROR: unknown cfrac (reference point of star stack)" >&2 && return 255
    
    length=$(echo $duration $pscale ${omove//@/ } | awk '{printf("%.0f", $1/60/$2*$3)}')
    rot=$(get_wcsrot $whdr $(echo $omove | awk -F "@" '{print $3}' | tr ',' ' '))
    angle=$(echo $rot ${omove//@/ } | awk '{printf("%.0f", ($3-$1+90)%360)}')
    echo $length","$angle,"$cfrac"

    # TODO: get dt(nref-first) dt(last-nref) from $tmpdat
    #   get dr1 dr2 and compute length and cfract
    #   get_wcsrot $set.wcs.head $center and compute angle
    rm -f $tmpdat
    return
}


img_info () {
    # extract image meta data from raw/jpeg/fits images
    # note: output times are UT, DSLR camera local time is converted to UT
    #   by querying sites.dat using the value of AI_SITE
    # TODO: add utdate, camera
    local showhelp
    local cam_is_ut     # if set then camera time is in UT otherwise LT
    local gpsinfo=""    # if set then include gps tags
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-u" && cam_is_ut=1 && shift 1
        test "$1" == "-g" && gpsinfo=1 && shift 1
    done
    local tzoff=${AI_TZOFF:-""}
    local dat="sites.dat"
    local filter
    local method
    local shortname
    local num
    local found
    local line
    local f
    local x
    local slen=12
    
    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: img_info [-u] [-g] <image1> [image2 ...]" >&2 &&
        return 1

    _exiftool_extract () {
        filter="DateTimeOriginal|ImageWidth|ImageHeight|ExposureTime|FNumber|ISO|\
FocalLength|SRFocalLength"
        # Pentax
        filter="$filter|CameraTemperature|BlackPoint|PictureMode"

        test "$gpsinfo" && filter="$filter|GPSTimeStamp|GPSLatitude|GPSLongitude\
|GPSAltitude|GPSSatellites|GPSTrack|GPSImgDirection|PitchAngle|RollAngle"
        LANG=C exiftool -S -c "%.5f" "$1" | grep -wE "$filter" | awk -v tzoff=$tzoff 'BEGIN{
            fn="-"; fl="-"; ms=0; temp="-"; black="-"; mode="-"
            gtime="-"; lat="-"; lon="-"; alt=-1; sat=-1; trck=-1; az=-1; pitch=-1; roll=-1}
        {
            if ($1=="DateTimeOriginal:")          {
                gsub(/:/, " ")
                hms=strftime("%H:%M:%S", mktime($2" "$3" "$4" "$5" "$6" "$7)-tzoff*3600)
            }
            if ($1=="ImageWidth:")      w=$2
            if ($1=="ImageHeight:")     h=$2
            if ($1=="ExposureTime:")    texp=$2
            if ($1=="ISO:")             iso=$2
            if ($1=="FNumber:")         if ($2~/^[+-]?[[:digit:]\.]+$/) {fn=$2}
            if ($1=="FocalLength:")     if ($2~/^[+-]?[[:digit:]\.]+$/) {fl=sprintf("%3.0f", $2)}
            #if ($1=="SRFocalLength:" && 1*fl==0 && $2~/^[+-]?[[:digit:]\.]+$/) {fl=sprintf("%3.0f", $2)}

            if ($1=="CameraTemperature:")   temp=$2
            if ($1=="BlackPoint:")          black=$2+$3+$4+$5
            if ($1=="PictureMode:")         mode=$2
            sub(/[,;]/,"",mode)

            # GPS Info, Kompass Info
            if ($1=="GPSTimeStamp:")    gtime=$2
            if ($1=="GPSLatitude:")     lat=$2
            if ($1=="GPSLongitude:")    long=$2
            if ($1=="GPSAltitude:")     alt=$2
            if ($1=="GPSSatellites:")   sat=$2
            if ($1=="GPSTrack:")        trck=$2
            if ($1=="GPSImgDirection:") az=$2
            if ($1=="PitchAngle:")      pitch=$2
            if ($1=="RollAngle:")       roll=$2
        }
        END{
            n=split(texp,a,"/"); if (n==2) texp=a[1]/a[2]
            if (ms!=0) texp=ms/1000
            printf(" %s %6.2f %4d %-4s %s", hms, texp, iso, fn, fl)
            printf(" %2s %4s %-6s %d %d", temp, black, mode, w, h)
            if (lat!="-") printf("   %s %s %s %6.1f %2d %6.2f %6.2f %.1f %.1f",
                gtime, lat, long, alt, sat, trck, az, pitch, roll)
            printf("\n")
        }'
            
    }

    _fits_extract () {
        listhead "$1" | tr "='" ' ' | awk -v tzoff=$tzoff 'BEGIN{
            hms="";
            dia="-"; fl=0; ms=0; temp="-"; black="-"; mode="-"
            lat="-"; lon="-"; alt=-1; sat=-1; trck=-1; az=-1}
        {
            if ($1=="DATE-OBS")     {
                sub(/^DATE-OBS/, "")
                gsub(/[:T-]/, " ")
                hms=strftime("%H:%M:%S", mktime($1" "$2" "$3" "$4" "$5" "$6)-tzoff*3600)
            }
            if ($1=="NAXIS1")       w=$2
            if ($1=="NAXIS2")       h=$2
            if ($1=="EXPTIME" || $1=="EXPOSURE") texp=1*$2
            if ($1=="FOCALLEN")     fl=$2
            if ($1=="APTDIA")       dia=$2
            if ($1=="CCD-TEMP")     temp=sprintf("%.0f", $2)
            if ($1=="CBLACK")       black=$2
            iso="-"
        }
        END{
            if (dia=="-" || dia==0) {
                fn=0
            } else {
                fn=sprintf("%.1f", fl/dia)
                gsub(/.0$/, "", fn)
            }
            printf(" %s %6.2f %4d %-4s %3d", hms, texp, iso, fn, fl)
            printf(" %2s %4s %-6s %d %d", temp, black, mode, w, h)
            if (lat!="-") printf("   %s %s %6.1f %2d %6.2f %6.2f", lat, lon, alt, sat, trck, az)
            printf("\n")
        }'
    }


    test "$cam_is_ut" && tzoff=0
    test $(exiftool -q -GPSLongitude $@ | wc -l) -gt 0 && gpsinfo=1
    for f in "$@"
    do
        shortname=$(echo $f | sed -e 's,^'$AI_RAWDIR',,; s,^/,,')
        x=$(echo $shortname | wc -c)
        test $x -gt $slen && slen=$x
    done
    for f in "$@"
    do
        # choose a method for data extraction
        method=""
        test -z "$method" && is_fits   $f && method="fits"
        test -z "$method" && is_fitzip $f && method="fitzip"
        test -z "$method" && exiftool "$f" >/dev/null 2>&1 && method="exiftool"
        test -z "$method" &&
            echo "WARNING: skipping $f" >&2 && continue
        shortname=$(echo $f | sed -e 's,^'$AI_RAWDIR',,; s,^/,,')
        num=$(basename "$f" | sed -e 's/\.[A-Za-z0-9]*$//; s/^[^0-9]*//')
        test -z "$num" && num="-"
        
        # disabled section as of airfun.sh version 3.4
        false && if [ $method == "exiftool" ] && [ -z "$tzoff" ]
        then
            # determine tzoff (camera time (LT) - UT)
            test -f $dat && test "$AI_SITE" && tzoff=$(awk -v s="$AI_SITE" '{
                if ($1~/^#/) next
                if (($1==s) || ($2==s)) {print $3+$4; nextfile}}' $dat)
            test -z "$tzoff" && tzoff=0 &&
                echo "WARNING: site $AI_SITE in sites.dat not found, setting tzoff=0." >&2
            echo "AI_SITE=$AI_SITE  AI_TZOFF=$AI_TZOFF  tzoff=$tzoff" >&2
        fi
        test -z "$tzoff" && tzoff=0
        
        # header
        if [ -z "$found" ]
        then
            printf "%-${slen}s num  hms        texp  iso fn  flen" "# name"
            printf " temp black mode   w    h"
            test "$gpsinfo" && printf "   gpstime  latitude longitude   alt sat trck azimuth pitch roll"
            printf "\n"
            found=1
        fi
        
        # extract tags
        printf "%-${slen}s %s" $shortname $num
        case $method in
            exiftool) _exiftool_extract "$f";;
            fits)   _fits_extract "$f";;
            fitzip) unzip -p "$f" | _fits_extract -;;
        esac
    done
    return 0
}

exiv2hdr () {
    # extract some image tags
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    local img=$1
    local obj=$2
    local jd0=$3          # julian day of last noon
    local dt=${4:-"1"}    # offset between camera time and UT
    #local flen=${5:-"800"}   # focal length in mm - if not found in image metadata
    #local fratio=${6:-"4.0"} # f/d ratio - if not found in image metadata

    (test "$showhelp" || test $# -lt 3) &&
        echo -e "usage: exiv2hdr <img> <object> <jd0> [camtime-UT|$dt] [flen|$flen] [fratio|$fratio]" >&2 &&
        return 1

    echo "imnum=$(basename $img | sed -e 's/.[a-zA-Z]*$//')"
    echo "object=$obj"
    LANG=C exiv2 -pa $img | awk -v j=$jd0 -v dt=$dt 'BEGIN{
        fn="-"; fl="-"; ms=0; temp="-"; black="-"; mode="-"}
    {
        if ($1=="Exif.Image.DateTime")          hms=$5
        if ($1=="Exif.Photo.ExposureTime")      texp=$4
        # special tags
        if ($1=="Exif.Pentax.ExposureTime")     ms=$4
    }
    END{
        n=split(texp,a,"/"); if (n==2) texp=a[1]/a[2]
        if (mode=="Bulb") texp=ms/1000
        nn=split(hms,a,":"); hut=a[1]+a[2]/60+a[3]/3600-dt-12; if(hut<0) hut+=24
        printf("exptime=%.1f\njdmid=%.5f\n", texp, j+hut/24)
    }'
}

hdr2ahead () {
    # read some data from hdr file and write ascii FITS header keywords
    # to stdout
    local hdr=$1
    local jdref
    local epoch
    local exptime
    local object
    local ratel
    local detel
    local sidtime
    
    test ! -f "$hdr" &&
        echo "ERROR: file $hdr not found." >&2 && return 255

    # determine time of observation and exposure time
    jdref=$(grep "^jdmid=" $hdr | cut -d '=' -f2)
    epoch=$(echo $jdref | awk '{printf("%.1f", ($1-2451544.5)/365.25+2000)}')
    exptime=$(grep "^exptime=" $hdr | cut -d '=' -f2)
    test -z "$jdref" &&
        echo "WARNING: unknown observation time." >&2
    test -z "$exptime" &&
        echo "WARNING: unknown exposure time." >&2

    # extract telescope position
    object=$(grep "^object=" $hdr | cut -d '=' -f2)
    ratel=$(grep "^ra=" $hdr | cut -d '=' -f2)
    detel=$(grep "^de=" $hdr | cut -d '=' -f2)
    sidtime=$(grep "^st=" $hdr | cut -d '=' -f2)
    # TODO: compute airmass
    
    # write keywords to header file
    echo "OBJECT  = '$object'"
    test "$ratel" &&
        echo "RATEL   = '$ratel'"
    test "$detel" &&
        echo "DETEL   = '$detel'"
    test "$sidtime" &&
        echo "SIDTIME = '$sidtime'"
    test "$exptime" &&
        echo "EXPTIME =      $exptime / Exposure time in seconds"
    test "$jdref" &&
        echo "MJD_OBS =      $jdref  / Time of observation in julian days" &&
        echo "EPOCH   =      $epoch  / Epoch"
    return
}

# convert from sexagesimal to decimal units
sexa2dec () {
    local hms=$1
    local mult=${2:-1}
    local prec=${3:-4}
    (test "$1" == "-h" || test $# -lt 1) &&
        echo "usage: sexa2dec <hms> [mult] [prec]" >&2 &&
        return 1
    
    test "${hms%%:*}" == "$hms" && echo $hms && return
    echo $hms | awk -F ":" -v m=$mult -v p=$prec '{
        fmt="%."p"f\n"
        if($1~/^-/) {x=$1-$2/60-$3/3600} else {x=$1+$2/60+$3/3600}
        printf(fmt, m*x)}'
}

# convert from decimal to sexagesimal units
dec2sexa () {
    local num_units=3   # number of units, default 3 means hour:minutes:seconds
    local i
    for i in 1 2
    do
        test "$1" == "-h" && num_units=1 && shift 1
        test "$1" == "-m" && num_units=2 && shift 1
    done
    local h=$1
    local div=${2:-1}
    local prec=${3:-1}
    test $# -lt 1 &&
        echo "usage: dec2sexa <-h|-m> <dec> [div] [prec]" >&2 &&
        return 1

    echo $h | awk -v d=$div -v p=$prec -v l=$num_units '{
        x=$1*3600./d
        if (x<0) {x=-1*x; sign="-"} else {sign="+"}
        h=int(x/3600.); m=int((x-h*3600)/60.); s=x-h*3600-m*60
        ns=2+p+1; if (p==0) ns=2
        if (l==1) {
            fmt="%s%0"ns"."p"f\n"
            printf(fmt, sign, x/3600.)
        }
        if (l==2) {
            fmt="%s%02d:%0"ns"."p"f\n"
            printf(fmt, sign, h, (x-h*3600)/60.)
        }
        if (l==3) {
            fmt="%s%02d:%02d:%0"ns"."p"f\n"
            printf(fmt, sign, h, m, s)
        }
    }'
}

minmax () {
    # return min/max from values of given column in data file
    local fname=${1:-"-"}
    local col=${2:-"1"}
    local min
    local max
    local tmp1=$(mktemp "/tmp/tmp_dat_$$.XXXXXX")
    cat $fname > $tmp1
    min=$(grep -v "^#" $tmp1 | awk -v c=$col '{print 1*$c}' | \
        LANG=C sort -n | head -1)
    max=$(grep -v "^#" $tmp1 | awk -v c=$col '{print 1*$c}' | \
        LANG=C sort -nr | head -1)
    echo $min $max
    rm $tmp1
}

sum () {
    # return sum from values of given column in data file
    local fname=${1:-"-"}
    local col=${2:-"1"}
    local n
    local tmp1=$(mktemp "/tmp/tmp_dat_$$.XXXXXX")
    grep -v "^#" $fname > $tmp1
    n=$(cat $tmp1 | wc -l)
    test $n -eq 0 && echo "ERROR: no data to compute mean from." >&2 && return 255
    cat $tmp1 | awk -v c=$col '{x=x+$c} END {printf("%.15g\n", x)}'
    rm $tmp1
}

mean () {
    # return mean from values of given column in data file
    local fname=${1:-"-"}
    local col=${2:-"1"}
    local n
    local tmp1=$(mktemp "/tmp/tmp_dat_$$.XXXXXX")
    grep -v "^#" $fname > $tmp1
    n=$(cat $tmp1 | wc -l)
    test $n -eq 0 && echo "ERROR: no data to compute mean from." >&2 && return 255
    cat $tmp1 | awk -v c=$col '{x=x+$c} END {printf("%.15g\n", x/NR)}'
    rm $tmp1
}

median () {
    # return median from values of given column in data file
    local fname=${1:-"-"}
    local col=${2:-"1"}
    local n
    local tmp1=$(mktemp "/tmp/tmp_dat_$$.XXXXXX")
    grep -v "^#" $fname > $tmp1
    n=$(cat $tmp1 | wc -l)
    test $n -eq 0 && echo "ERROR: no data to compute median from." >&2 && return 255
    cat $tmp1 | awk -v c=$col '{printf("%.15g\n", 1*$c)}' | \
        LANG=C sort -n | head -$(((n+1)/2)) | tail -1
    rm $tmp1
}

stddev () {
    # return stddev from values of given column in data file
    local fname=${1:-"-"}
    local col=${2:-"1"}
    local mean
    local tmp1=$(mktemp "/tmp/tmp_dat_$$.XXXXXX")
    cat $fname > $tmp1
    mean=$(mean $tmp1 $col)  # $(median $fname $col)
    grep -v "^#" $tmp1 | awk -v c=$col -v m=$mean '{
        x=x+($c-m)^2} END {print sqrt(x/(NR-1))}'
    rm $tmp1
}


normstat () {
    # return median,stddev from values of given column in data file
    # using probability function (assuming normal distribution)
    # n<40: measure low1 (+-1.0*stddev) at 0.1586 and high at 0.8414, stddev1=(high-low)/2
    # n>40: measure low2 (+-1.5*stddev) at 0.0668 and high at 0.9332, stddev2=(high-low)/3
    # TODO: recheck code if data is float values
    local fname=${1:-"-"}
    local col=${2:-"1"}
    local n
    local debug
    
    test "$AI_DEBUG" && test $AI_DEBUG -gt 1 && debug="yes"
    cat $fname | grep -v "^#" | LANG=C sort -n -k$col,$col | \
    awk -v c=$col -v debug="$debug" '{
        count++;
        val[count]=1*$c
    }END{
        if (count<40) {
            nlow=0.1586*count+0.5; nhigh=0.8414*count+0.5; width=2
        } else {
            nlow=0.0668*count+0.5; nhigh=0.9332*count+0.5; width=3
        }
        if (debug) print "nlim: "int(nlow)" "int(nhigh)
        lowval=val[int(nlow)] + (val[int(nlow)+1]-val[int(nlow)]) * (nlow-int(nlow))
        highval=val[int(nhigh)] + (val[int(nhigh)+1]-val[int(nhigh)]) * (nhigh-int(nhigh))
        if (debug) print "val: "lowval" "highval
        
        if (count % 2 == 0) {
            md=(val[count/2]+val[count/2+1])/2
        } else {
            md=val[(count+1)/2]
        }

        printf("%f %f\n", md, (highval-lowval)/width)
    }'
}


_stat () {
    # return mean or median, stddev from values of given column in data file
    local method="median"
    test "$1" == "-m" && method="mean" && shift 1
    local fname=${1:-"-"}
    local col=${2:-"1"}

    cat $fname | grep -v "^#" | LANG=C sort -n -k$col,$col | \
        awk -v c=$col -v m=$method '{
            count++;
            val[count]=1*$c
            sum+=1*$c
            sumsq+=1*$c*$c
        }END{
            mean=sum/count
            sd=sqrt(sumsq/count - (mean)**2)
            if (m=="median") {
                # compute median
                if (count % 2 == 0) {
                    md=(val[count/2]+val[count/2+1])/2
                } else {
                    md=val[(count+1)/2]
                }
                printf("%f %f\n", md, sd)
            } else {
                printf("%f %f\n", mean, sd)
            }
        }'
}

_stat2 () {
    # return median,stddev from values of given column in data file
    # note: requires external program sta (https://github.com/simonccarter/sta)
    local fname=${1:-"-"}
    local col=${2:-"1"}
    cat $fname | grep -v "^#" | awk -v c=$col '{print 1*$c}' | sta --brief --median --sd
}

kappasigma () {
    # statistics (mean/stddev) after kappa-sigma-clipping
    local verbose
    local showhelp
    local do_nonzero    # if set any data values <=0 are rejected
    local do_print_n    # if set append number of valid data points
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-v" && verbose=1 && shift 1
        test "$1" == "-p" && do_nonzero=1 && shift 1
        test "$1" == "-n" && do_print_n=1 && shift 1
    done
    local fname=${1:-"-"}
    local col=${2:-"1"}
    local kappa=${3:-"3.5"}
    local iter=${4:-"4"}
    local md
    local sd
    local n
    local n2
    local tmp1=$(mktemp "/tmp/tmp_dat1_$$.XXXXXX")
    local tmp2=$(mktemp "/tmp/tmp_dat2_$$.XXXXXX")

    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: kappasigma [-p(ositiv)] [-n(umber)] <dat> [col|$col] [kappa|$kappa] [iter|$iter]" >&2 &&
        return 1
    
    grep -v "^#" $fname | awk -v c=$col -v z=${do_nonzero:-0} '{
        x=1*$c; if ((x>0) || (z==0)) print x}' | \
        LANG=C sort -n > $tmp1
    n=$(cat $tmp1 | wc -l)
    test $n -lt 5 &&
        echo "ERROR: too few data samples (n<5)." >&2 && return 255
    cp $tmp1 $tmp2
    for i in $(seq 1 $iter)
    do
        set - $(normstat $tmp2)
        n1=$(cat $tmp2 | wc -l)
        md=$1
        sd=$2
        cat $tmp1 | awk -v md=$md -v sd=$sd -v k=$kappa 'BEGIN{low=md-k*sd; high=md+k*sd}{
            if (sd>0) {
                if (($1>=low) && ($1<=high)) printf("%s\n", $1)
            } else {
                printf("%s\n", $1)
            }
        }' > $tmp2
        n2=$(cat $tmp2 | wc -l)
        test "$verbose" &&
            LANG=C printf "# i=%d  md=%.1f sd=%.1f  skip=%d\n" $i $md $sd $((n-n2)) >&2
        test $n2 -lt 4 &&
            echo "ERROR: too few data samples (n2<4)." >&2 && return 255
        test $n2 -eq $n1 && break
    done
    if [ "$do_print_n" ]
    then
        echo $(_stat -m $tmp2) $n2
    else
        _stat -m $tmp2
    fi
    rm $tmp1 $tmp2
}


#------------------------------------------
#   conversion functions for object lists
#------------------------------------------

roi2geom () {
    # convert ROI's from ImageJ measurements file into list of geometry specs
    # columns Label BX BY Width Height must be present
    local mfile="$1"
    local cl
    local cx
    local cy
    local cw
    local ch
    local tmp1=$(mktemp "/tmp/tmp_roi_$$.XXXXXX")
    # find column index of BX BY Width Height
    head -1 $mfile | tr ' \t' '\n' | grep -v "^$" > $tmp1
    cl=$(grep -nw "Label" $tmp1 | cut -d ":" -f1)
    test -z "$cl" &&
        echo "roi2geom: ERROR: column Label not found." >&2 && return 255
    cl=$(($cl + 1))
    cx=$(grep -nw "BX" $tmp1 | cut -d ":" -f1)
    test -z "$cx" &&
        echo "roi2geom: ERROR: column BX not found." >&2 && return 255
    cx=$(($cx + 1))
    cy=$(grep -nw "BY" $tmp1 | cut -d ":" -f1)
    test -z "$cy" &&
        echo "roi2geom: ERROR: column BY not found." >&2 && return 255
    cy=$(($cy + 1))
    cw=$(grep -nw "Width" $tmp1 | cut -d ":" -f1)
    test -z "$cw" &&
        echo "roi2geom: ERROR: column Width not found." >&2 && return 255
    cw=$(($cw + 1))
    ch=$(grep -nw "Height" $tmp1 | cut -d ":" -f1)
    test -z "$ch" &&
        echo "roi2geom: ERROR: column Height not found." >&2 && return 255
    ch=$(($ch + 1))
    #echo "  cx=$cx  cy=$cy  cw=$cw  ch=$ch" >&2
    
    # extract ROI's, make geom unique, sort in x
    cat $mfile | awk -v cl=$cl -v cx=$cx -v cy=$cy -v cw=$cw -v ch=$ch '{
        if (NR>1) {
            printf("%s %s\n", $cl, $cw"x"$ch"+"$cx"+"$cy)
        }
    }' | tr ':' ' ' | cut -d ' ' -f4 | LANG=C sort -t "+" -n -k 2,2 -u

    rm $tmp1
}

# dump contents of ImageJ binary ROI file
# ref: imagej-1.47c/ij/io/RoiDecoder.java
#      http://dylan-muir.com/resources/code/ReadImageJROI.m
# note: converting decimal to hex in bash: printf "%02X\n" 10
roi2xy () {
    local roi=$1
    local hdr
    local type=""
    local ncoo=0
    
    hdr=$(hexdump -v -e '/1 "%02X" ""' 0001-0563-1521.roi -n 64 $roi)
    test "${hdr:0:8}" != "496F7574" &&
        echo "ERROR: this is not a valid ImageJ ROI file." >&2 && return 255
    version=$((16#${hdr:8:4}))
    roitype=$((16#${hdr:12:2}))
    top=$((16#${hdr:16:4}))
    left=$((16#${hdr:20:4}))
    bottom=$((16#${hdr:24:4}))
    right=$((16#${hdr:28:4}))
    ncoo=$((16#${hdr:32:4}))
    subtype=$((16#${hdr:96:4}))
    options=$((16#${hdr:100:4}))
    
    case $roitype in
        0)  type="polygon";;
        1)  type="rect";;
        2)  type="oval";;
        3)  type="line";;
        4)  type="freeline";;
        5)  type="polyline";;
        6)  type="noRoi";;
        7)  type="freehand";;
        8)  type="traced";;
        9)  type="angle";;
        10)  type="point";;
    esac
    echo "type=$type  bounds=$top $left $bottom $right  ncoo=$ncoo"
    echo "subtype=$subtype  options=$options"
    
    # data, starting at byte 64
    #   x ncoo int16, y ncoo int16
    # if subpixel==1 (options 128) then additionally
    #   xf ncoo float32, xf ncoo float 32
}

# get telescope identifyers from iTelescope log files
get_itel_telid () {
    local showhelp
    local i
    for i in 1
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    done
    logfiles="$@"

    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: get_itel_telid file1 [file2] ..." >&2 &&
        return 1

    false && cat $logfiles | grep "Telescope .* ACP" | tr '\->' ' ' | \
        awk '{print $6}' | tr -d ',' | sort -u
    cat $logfiles | grep "Telescope is ACP" | sed -e 's,.*\->,,' | \
        awk '{
            if ($1~/iTelescope/) {
                print $2
            } else {
                print $1
            }}' | tr -d ',' | sort -u
}

# convert observations log file from iTelescope.net into tabular observations
# data file or display commands for linking files from subdirectory zip
itel2obs () {
    local showhelp
    local loglevel=0    # 1 - add focus log info to output
                        # 2 - add even more log info to output
    local linkmode=0    # 1 - show commands for linking files from subdirectory zip
                        # 2 - use calibrated images for linking
    local use_filenames # if set the get file names from directory 'zip' instead
                        # of evaluating the log files
    local n=1           # start file numbering at n
    local i
    for i in 1 2 3 4 5 6
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-v" && loglevel=$((loglevel + 1)) && shift 1
        test "$1" == "-l" && linkmode=1 && shift 1
        test "$1" == "-c" && linkmode=2 && shift 1
        test "$1" == "-f" && use_filenames=1 && shift 1
        test "$1" == "-n" && n=$2 && shift 2
    done
    local logdir=${1:-$AI_RAWDIR}
    local filter
    local tellist
    local tel
    local logfiles
    local cadd=9000
    local tmp1=$(mktemp "/tmp/tmp_tmp1_$$.XXXXXX.txt")
    local d

    (test "$showhelp" || test $# -gt 1) &&
        echo -e "usage: itel2obs [-f|-a|-l|-c] [logdir|$logdir]" >&2 &&
        return 1
    test $linkmode -gt 0 && loglevel=0
    
    # date
    if [ $linkmode -eq 0 ]
    then
        d=$(basename $logdir | tr -d '[a-z]')
        echo
        echo "#" $d
    fi
    
    #tellist=$(cat $logdir/2* | grep -i "saved to" | awk '{print $NF}' |  \
    #    grep -i "^T" | cut -d "-" -f1 | sort -u)
    tellist=$(get_itel_telid $logdir/2*)
    test -z "$tellist" &&
        echo "ERROR: no exposures in log files." >&2 && return 255

    filter="starting run|Telescope|script|autofocus|focus position|defocus|express"
    filter="$filter|temperature|hfd =|saved to"

    for tel in $tellist
    do
        #for logfile in $(grep -il "saved to $tel-" $logdir/2*)
        for logfile in $logdir/2*
        do
            test "$(get_itel_telid $logfile)" != "$tel" && continue
            test $linkmode -ne 0 && echo "# $tel $logfile" >&2
            grep -iE "$filter" $logfile | \
                grep -viE "slew|no focus|binning|exposure|p-Focus"
        done
    done > $tmp1
    test $linkmode -eq 0 && echo "#" $tellist
    
    # column header
    if [ $linkmode -eq 0 ]
    then
        echo
        echo "# LT"
        echo "# h:m set  target type texp n1 n2   nref dark flat tel"
    fi
    
    cat $tmp1 | tr -d '\r' | \
    awk -v loglevel=$loglevel -v linkmode=$linkmode -v n=$n -v cadd=$cadd \
    'BEGIN{num=n-1; nplan=-1; focusinfo=""}{
        if ($0~/Starting run for plan/) {nplan++}
        if ($0~/Image File Saved to [Tt]/) {
            if (focusinfo != "") {printf("# %s\n", focusinfo); focusinfo=""}
            split($NF,a,/-/)
            ta=a[3]         # target
            if (tolower(ta)=="bias" || tolower(ta)=="dark") {
                gsub(/[a-zA-Z]/,"",a[4])
                t=1*a[4]    # exposure time
                f=a[10]     # filter
                b=a[9]      # bin
                s=a[8]; gsub(/[a-zA-Z]/,"",s)   # LT start
                temp="-"a[6]    # temperatur
                ty="d"
                ta=tolower(ta)
                gsub(/[a-zA-Z]/,"",b)
            } else {
                t=1*a[9]    # exposure time
                f=a[6]      # filter
                b=a[7]      # bin
                s=a[5]      # LT start
                temp=""     # temperature unknown
                ty="o"
                if (tolower(ta)=="cal") {
                    ty="d"
                    if (t==0) {ta="bias"} else {ta="dark"}
                } else {
                    if (t==0) {ty="d"; ta="sky"}
                }
                gsub(/[a-zA-Z]/,"",b)
            }
            # convert start time string to HH:MM
            if (substr(s,5,2)<30) {
                s=substr(s,1,2)":"substr(s,3,2)
            } else {
                s=sprintf("%s:%02d", substr(s,1,2), substr(s,3,2)+1)
            }
            if (loglevel>0) {
                if (loglevel>1) print $0
                s="# "s
                printf("%s %s %04d\n", s, ta, num+1)
            }
            if (linkmode < 1) {
                if (tel=="") {
                    firstnum=num+1; tel=a[1]; target=ta; type=ty; texp=t; filter=f; bin=b; start=s
                    if (type=="d") {
                        set="dkxx"; nref="-   "
                        txt="-    -    "tel
                        if ((temp!="") || (bin!="1")) {txt=txt" #"}
                        if (temp!="") {txt=txt" "temp}
                        if (bin!="1") {txt=txt" bin"bin}
                    } else {
                        set="coxx"; nref=0
                        txt="doxx mgxx "tel
                        if ((temp!="") || (filter!="") || (bin!="1")) {txt=txt" #"}
                        if (temp!="")   {txt=txt" "temp}
                        if (filter!="") {txt=txt" "filter}
                        if (bin!="1")   {txt=txt" bin"bin}
                    }
                } else {
                    # check if this image file belongs to a new set
                    if (a[1]!=tel || ta!=target || t!=texp || f!=filter || b!=bin ||
                        nplan>0) {
                        # new set found
                        nplan=0
                        if (type=="o") nref=sprintf("%04.0f", (firstnum+num)/2)
                        printf("%s %s %-8s %s %3d %04d %04d %s %s\n",
                            start, set, target, type, texp, firstnum, num, nref, txt)
                        firstnum=num+1; tel=a[1]; target=ta; type=ty; texp=t; filter=f; bin=b; start=s
                        if (type=="d") {
                            set="dkxx"; nref="-   "
                            txt="-    -    "tel
                            if ((temp!="") || (bin!="1")) {txt=txt" #"}
                            if (temp!="") {txt=txt" "temp}
                            if (bin!="1") {txt=txt" bin"bin}
                        } else {
                            set="coxx"; nref=0
                            txt="doxx mgxx "tel
                            if ((temp!="") || (filter!="") || (bin!="1")) {txt=txt" #"}
                            if (temp!="") {txt=txt" "temp}
                            if (filter!="") {txt=txt" "filter}
                            if (bin!="1")   {txt=txt" bin"bin}
                        }
                    }
                }
            } else {
                zname=tolower($NF)".zip"
                n=num+1
                if (linkmode==2 && ty=="o") {
                    zname="calibrated-"tolower($NF)".zip"
                    n=num+cadd+1
                }
                printf("ln -s zip/%s %04d.fitzip\n", zname, n)
            }
            num++
        } else {
            if (loglevel>1) {
                print $0
            }
            if (loglevel>0 && tolower($0)~/starting run|express|focus|temperature|hfd/) {
                print $0
            }
            if (loglevel==0 && tolower($0)~/focus position|temperature|mean hfd/) {
                gsub(/^[0-9: ]*/,"")
                if (focusinfo != "") focusinfo=focusinfo"; "
                focusinfo=focusinfo""$0
            }
        }
    }END{
        if (linkmode == 0) {
            if (type=="o") nref=sprintf("%04.0f", (firstnum+num)/2)
            printf("%s %s %-8s %s %3d %04d %04d %s %s\n",
                start, set, target, type, texp, firstnum, num, nref, txt)
        }
    }'
    if [ $loglevel -eq 0 ] && [ $linkmode -eq 0 ]
    then
        printf "\n(" >&2
        grep "Starting run for plan" $tmp1 | tr -d '\r' | \
            sed -e 's|\.*$||' | awk '{
            printf("echo; echo; echo \"#### %s\"; cat ~/itel/%s\n", $NF, $NF)}' >&2
        printf ") >> %s/obs.txt\n" $logdir >&2
        echo "vi $logdir/obs.txt" >&2
    fi
    test "$AI_DEBUG" && echo $tmp1
    test ! "$AI_DEBUG" && rm $tmp1
}


map_rawfiles () {
    # create mapping of image number to file name for new raw images
    #   note: spaces in file name are converted to "_"
    #   output to stdout: num fname tstart texp jd w h temp
    #   output might be written to rawfiles.dat
    local showhelp
    local verbose
    local skip_existing # if set, skip images which already have an entry in rdat
    local firstnum
    local i
    for i in 1 2 3 4
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-x" && skip_existing=1 && shift 1
        test "$1" == "-n" && firstnum=$2 && shift 2
        test "$1" == "-v" && verbose=1 && shift 1
    done
    local sdat=${AI_SETS:-"set.dat"}
    local rdat="rawfiles.dat"
    local edat="exif.dat"
    local x
    local cidx
    local nmax=0
    local tstart
    local texp
    local jd
    local w
    local h
    local f
    local b
    local d
    local temp
    local len=12
    local tmphdr=$(mktemp "/tmp/tmp_header_XXXXXX.txt")
    local tmpdat=$(mktemp "/tmp/tmp_data_XXXXXX.dat")
    
    test "$showhelp" &&
        echo "usage: map_rawfiles [-v] [-n firstnum] [-x] file1 [file2] ..." >&2 &&
        return 1

    if [ "$firstnum" ]
    then
        nmax=$((firstnum - 1))
    else
        # get max number in use by $rdat, $edat and in $AI_RAWDIR
        if [ "$AI_RAWDIR" ] && [ -d $AI_RAWDIR ]
        then
            x=$(ls $AI_RAWDIR/[0-9][0-9][0-9][0-9].* 2>/dev/null | grep -v "^0000" | \
                LANG=C sort | tail -1 | cut -d "." -f1)
            test "$x" && test "$x" \> "$nmax" && nmax=$x
            test "$verbose" && echo "# AI_RAWDIR: x=$x nmax=$nmax" >&2
        fi
        i=0
        for f in "$edat" "$rdat"
        do
            i=$((i+1))
            test "$verbose" && echo "# f=$f" >&2
            test ! -e $f && continue
            case $i in
                1)  cidx=2;;
                2)  cidx=1;;
            esac

            x=$(grep -v "^#" $f | awk -v i=$cidx '{if($i~/^[0-9]{4}$/) {printf("%s\n", $i)}}' | \
                LANG=C sort | tail -1)
            test "$x" && test "$x" \> "$nmax" && nmax=$x
            test "$verbose" && echo "# $(basename $f): x=$x nmax=$nmax" >&2
        done
    fi

    # extract very basic file information: fname tstart texp jd w h temp
    #   sort images according to JD
    #   spaces in file name are replaced by "_"
    i=$((10#$nmax))
    for f in "$@"
    do
        test "$verbose" && echo "# $f" >&2
        test ! -e "$f" && continue
        b=$(basename "$f" | tr ' ' '_')
        d=$(dirname "$f" | awk -v l="${#AI_RAWDIR}" '{
            if (length($1)>l) printf("%s/", substr($1,l+2))}')
        test "$skip_existing" && test -e "$rdat" &&
            grep -q "^[0-9][0-9][0-9][0-9] $d$b " $rdat &&
            echo "# file $b exists" && continue
        if is_fits "$f" || is_fitzip "$f" || is_fitsgz "$f"
        then
            get_header "$f" all > $tmphdr
        else
            echo "WARNING: $f has unsupported file type." >&2
            false
        fi
        test $? -ne 0 && continue
        # determine JD
        jd=$(get_jd "$f")
        test -z "$jd" &&
            echo "ERROR: missing JD." >&2 && continue
        # get w h
        w=$(grep    "^NAXIS1  =" $tmphdr | head -1 | cut -d "=" -f2 | awk '{printf("%d", $1)}')
        h=$(grep    "^NAXIS2  =" $tmphdr | head -1 | cut -d "=" -f2 | awk '{printf("%d", $1)}')
        (test -z "$w" || test -z "$h") &&
            echo "ERROR: missing NAXIS[12]." >&2 && continue
        # determine tstart
        x=$(grep    "^DATE-OBS=" $tmphdr | head -1 | cut -d "=" -f2 | cut -d "'" -f2)
        test "$x" && tstart=$(echo $x | cut -d "T" -f2 | sed -e 's,\..*,,')
        test -z "$tstart" && tstart="-"
        # get texp
        texp=$(grep "^EXPTIME =" $tmphdr | head -1 | cut -d "=" -f2 | awk '{printf("%.1f", 1*$1)}')
        test -z "$texp" &&
            texp=$(grep "^EXPOSURE=" $tmphdr | head -1 | cut -d "=" -f2 | awk '{printf("%.1f", 1*$1)}')
        test -z "$texp" && texp="-1"
        # get ccd temp
        temp=$(get_header -q $tmphdr CCD-TEMP | awk '{printf("%.0f", 1*$1)}')
        test -z "$temp" && temp="-"
        echo $d$b $tstart $texp $jd $w $h $temp
    done | LANG=C sort -n -k4,4 > $tmpdat
    test "$AI_DEBUG" && echo "# tmpdat=$tmpdat" >&2
    test ! -s $tmpdat &&
        echo "ERROR: no raw images found." >&2 &&
        return 255
    ! grep -q -v "^#" $tmpdat &&
        echo "WARNING: no new raw images found." >&2 &&
        return 0
    
    # length of file name
    x=$(grep -v "^#" $tmpdat | awk '{print 1+length($1)}' | sort -n | tail -1)
    test $x -gt $len && len=$x

    # output image number and file info
    while read
    do
        test "$verbose" && echo "# $REPLY" >&2
        test "${REPLY:0:1}" == "#" && continue
        i=$((i+1))
        # fields are: fname tstart texp jd w h temp
        LANG=C printf "%04d %-"$len"s %8s %6.1f %.5f %4d %4d %s\n" $i $REPLY
    done < $tmpdat
    
    rm -f $tmphdr $tmpdat
    return 0
}


# starter function used for comet observations
AIstart () {
    # check headers of comet observations required by
    # airtools tasks psfextract,cometphot,photcal
    # TODO: AI_SITE should be read from image header
    local showhelp
    local accept_mjd    # accept keyword MJD_OBS if JD is missing
    local is_centered   # if set then comet locates near center
    local single_image  # if set then deal with missing costack
    local jd_data       # optional text file providing JD of all individual images
                        # (first field: image number, second field: JD)
    local do_flip       # flip images top-bottom
    local no_gui        # if set, interactive gui (AIexamine) is not started
    local keylist       # header keywords to add using set_header
    local i
    for i in $(seq 1 20)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-m" && accept_mjd=1 && shift 1
        test "$1" == "-c" && is_centered=1 && shift 1
        test "$1" == "-s" && single_image=1 && shift 1
        test "$1" == "-j" && jd_data=$2 && shift 2
        test "$1" == "-f" && do_flip=1 && shift 1
        test "$1" == "-n" && no_gui=1 && shift 1
        test "$1" == "-k" && keylist="$keylist $2" && echo "$2" >&2 && shift 2
    done
    local sname=$1
    local ststack=${2:-""}  # image name of star centered stack
    local costack=${3:-""}  # image name of comet centered stack
    local sdat=${AI_SETS:-"set.dat"}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpim=$(mktemp $tdir/tmp_im_$$.XXXXXX.pnm)
    local tmpfits=$(mktemp $tdir/tmp_im_$$.XXXXXX.fits)
    local tmpdat=$(mktemp $tdir/tmp_data_$$.XXXXXX.dat)
    local orighdr=$(mktemp $tdir/tmp_orig_$$.XXXXXX.head)
    local camdat="camera.dat"
    local sitesdat="sites.dat"
    local ext
    local hdr
    local whdr
    local x
    local str
    local line
    local err
    local object
    local texp
    local nexp
    local has_wcs
    local has_mpcephem
    local tlen
    local tpa
    local tref
    local ra
    local dec

    (test "$showhelp" || test $# -lt 1) &&
        echo -e "usage: AIstart [-c] [-f] [-s] [-j jd_datafile] [-k keylist] <setname> [starstack] [cometstack]" >&2 &&
        return 1
    
    # check set.dat
    test ! -e $sdat &&
        echo "ERROR: missing observations data file $sdat" >&2 && return 255
    ! is_setname $sname &&
        echo "ERROR: entry for set $sname in $sdat is missing (or incomplete)" >&2 && return 255
    # check files
    for x in $camdat $sitesdat $jd_data "$ststack" "$costack"
    do
        test -z "$x" && continue
        test ! -e "$x" && echo "ERROR: missing file \"$x\"" >&2 && return 255
    done
    

    # check for image files related to set
    if [ -e $sname.ppm ]
    then
        ext=ppm
        ststack=$sname.ppm
        echo "reusing star stack image $ststack" >&2
    else
        if [ -e $sname.pgm ]
        then
            ext=pgm
            ststack=$sname.pgm
            echo "reusing star stack image $ststack" >&2
        fi
    fi
    if [ "$ext" ]
    then
        test -e ${sname}_m.$ext && costack=${sname}_m.$ext &&
            echo "reusing comet stack image $costack" >&2
    else
        if [ -e ${sname}_m.ppm ]
        then
            costack=${sname}_m.ppm
            echo "reusing comet stack image $costack" >&2
        else
            test -e ${sname}_m.pgm && costack=${sname}_m.pgm &&
                echo "reusing comet stack image $costack" >&2
        fi
    fi
    test -z "$ststack" &&
        echo "ERROR: missing star stack (2nd parameter)" >&2 && return 255
    test -z "$costack" && test ! "$single_image" &&
        echo "ERROR: missing comet stack (3rd parameter)" >&2 && return 255


    # check input image format
    test "$ststack" && ! is_pnm "$ststack" && ! is_fits "$ststack" &&
        echo "ERROR: \"$ststack\" has unsupported image format" >&2 && return 255
    test "$costack" && ! is_pnm "$costack" && ! is_fits "$costack" &&
        echo "ERROR: \"$costack\" has unsupported image format" >&2 && return 255
    

    # check for identical image size
    if [ "$ststack" ] && [ "$costack" ] && [ "$ststack" != "$costack" ]
    then
        x=$(imsize "$ststack")
        test "$(imsize "$ststack")" != "$(imsize "$costack")" &&
            echo "ERROR: stacks have different dimensions" >&2 && return 255
    fi

    
    # convert stacked images if they are in FITS format
    hdr=$sname.head
    if ! is_pnm "$ststack"
    then
        echo "Converting \"$ststack\" ..." >&2
        x=$(datarange "$ststack")
        test $? -ne 0 &&
            echo "ERROR: cannot determine data range of \"$ststack\"" >&2 && return 255
        echo "# min/median/max: $x" >&2
        set - $(echo $x)
        test ${3%.*} -gt 70000 &&
            echo "WARNING: max. intensity exceeds 16bit range" >&2
        test ${3%.*} -lt 1000 &&
            echo "WARNING: dynamic range is very low" >&2
        test ${2%.*} -gt 60000 &&
            echo "ERROR: median intensity above limit" >&2 && return 255
        test ${2%.*} -le 2 &&
            echo "ERROR: median intensity below limit" >&2 && return 255
        test ${2%.*} -gt 30000 &&
            echo "WARNING: median intensity is surprisingly high" >&2

        test -z "$do_flip" && meftopnm "$ststack" > $tmpim
        test    "$do_flip" && meftopnm "$ststack" | pnmflip -tb > $tmpim
        ! is_pgm $tmpim && ! is_ppm $tmpim &&
            echo "ERROR: unable to convert \"$ststack\"" >&2 && return 255
        if [ -e $hdr ]
        then
            echo "reusing header file $hdr" >&2
        else
            meftopnm -a "$ststack" > $hdr
        fi
        is_pgm $tmpim && mv $tmpim $sname.pgm && ststack=$sname.pgm
        is_ppm $tmpim && mv $tmpim $sname.ppm && ststack=$sname.ppm
    fi
    test "$costack" && if ! is_pnm "$costack"
    then
        echo "Converting \"$costack\" ..." >&2
        x=$(datarange "$costack")
        test $? -ne 0 &&
            echo "ERROR: cannot determine data range of \"$costack\"" >&2 && return 255
        echo "# min/median/max: $x" >&2
        set - $(echo $x)
        test ${3%.*} -gt 70000 &&
            echo "WARNING: max. intensity exceeds 16bit range" >&2
        test ${3%.*} -lt 1000 &&
            echo "WARNING: dynamic range is very low" >&2
        test ${2%.*} -gt 60000 &&
            echo "ERROR: median intensity above limit" >&2 && return 255
        test ${2%.*} -le 2 &&
            echo "ERROR: median intensity below limit" >&2 && return 255
        test ${2%.*} -gt 30000 &&
            echo "WARNING: median intensity is surprisingly high" >&2

        test -z "$do_flip" && meftopnm "$costack" > $tmpim
        test    "$do_flip" && meftopnm "$costack" | pnmflip -tb > $tmpim
        ! is_pgm $tmpim && ! is_ppm $tmpim &&
            echo "ERROR: unable to convert \"$costack\"" >&2 && return 255
        is_pgm $tmpim && mv $tmpim ${sname}_m.pgm && costack=${sname}_m.pgm
        is_ppm $tmpim && mv $tmpim ${sname}_m.ppm && costack=${sname}_m.ppm
    fi
    test ! -e "$ststack" && echo "WARNING: no star stack" >&2
    test ! -e "$costack" && echo "WARNING: no comet stack" >&2
    test ! -e $hdr && echo "ERROR: missing header file $hdr" >&2 && return 255
    cp -p $hdr $orighdr
    test -e "$costack" && test ! -e ${sname}_m.head &&
        ln -s $hdr ${sname}_m.head
    whdr=$hdr
    test -e $sname.wcs.head && whdr=$sname.wcs.head


    #----------------------------
    # checking basic keywords
    #----------------------------
    # add header keywords if requested
    test "$keylist" && set_header $hdr $keylist

    # check mean JD (middle of exposures)
    if [ "$accept_mjd" ]
    then
        x=$(get_jd -q -k "JD,DATE-OBS,MJD_OBS" $hdr)
    else
        x=$(get_jd -q -k "JD,DATE-OBS" $hdr)
    fi
    if [ -z "$x" ]
    then
        # try to get mean JD from jd_data
        test "$jd_data" && test -e "$jd_data" && x=$(mean $jd_data 2)
        if [ -z "$x" ] && [ -e exif.dat ] && [ -e reg.dat ]
        then
            get_jd_dmag $sname > $tmpdat
            test $? -eq 0 && test -s $tmpdat && x=$(mean $tmpdat 2)
        fi
    fi
    test "$x" && set_header $hdr JD=$x
    test -z "$x" && err="$err JD" &&
        echo "ERROR: keyword JD (or DATE-OBS) is missing" >&2

    # use entry of the given set in set.dat for the following keywords
    line=$(grep -v "^#" $sdat | sed -e 's|#.*||' | \
        awk -v s=$sname '{if($2==s && $4=="o") {print $0}}')

    # number of images
    nexp=$(grep -v "^#" $sdat | awk -v s=$sname -v ex="$AI_EXCLUDE" '{
        if($2==s && ($4=="o" || $4=="a")) {
            for (i=$6; i<=$7; i++) {
                num=sprintf("%04d", i)
                if (index(ex, num) == 0) printf("%s\n", num)
            }}}' | sort -u | wc -l)
    set_header $hdr NEXP="$nexp/Number of exposures"
    
    # cumulative exposure time
    str=$(get_header -q $hdr EXPTIME | awk '{printf("%.2f", $1*1)}')
    x=$(echo $nexp $line | awk '{printf("%.2f", $1*$6)}')
    test "$str" && test "$str" != "$x" &&
        echo "# modifying EXPTIME from $str to $x" >&2
    set_header $hdr EXPTIME="$x/Total exposure time in seconds"

    # get object from entry in $sdat
    object=$(get_header -q $hdr OBJECT)
    x=$(echo $line | cut -d " " -f3)
    if [ "$object" != "$x" ]
    then
        test "$object" &&
            echo "# modifying OBJECT from $object to $x" >&2
        object=$x
        set_header $hdr OBJECT=$x
    fi
    
    # store AI_SITE
    x=$(get_header -q $hdr AI_SITE)
    test -z "$x" && x=$AI_SITE
    test -z "$x" && err="$err AI_SITE" &&
        echo "ERROR: AI_SITE is undefined" >&2
    set_header $hdr AI_SITE="$AI_SITE/Observatory site"

    # get telescope from entry in $sdat
    # TODO: maybe accept AI_TELESCOPE in first place
    x=$(echo $line | cut -d " " -f11)
    test "$x" && set_header $hdr AI_TELID="$x/Instrument identifier"
    test -z "$x" && x=$(get_header -q $hdr AI_TELID)
    if [ "$x" ]
    then
        ! grep -q -w "^$x" $camdat && err="$err AI_TELID" &&
            echo "ERROR: AI_TELID=$x does not exist in $camdat" >&2
    else
        err="$err AI_TELID"
        echo "ERROR: keyword AI_TELID is missing" >&2
    fi

    # add AI_COMST header keyword
    x=$(get_header -q $hdr AI_COMST)
    test -z "$x" && test "$costack" &&
        set_header $hdr AI_COMST="$costack/Comet stack image file name"

    # abort program if basic header information is missing
    test "$err" &&
        echo "ABORTING $FUNCNAME due to missing image header keywords." >&2 &&
        return 255
    
    
    #------------------------------
    # image center and orientation
    #------------------------------
    # adding comet ephemerides
    x=$(get_header -q $hdr AI_CORA,AI_CODEC,AI_OMOVE | wc -l)
    if [ $x -eq 3 ]
    then
        has_mpcephem=1
        echo "# Found comet ephemerides keywords (AI_CORA,AI_CODEC,AI_OMOVE)." >&2
    else
        get_mpcephem -w $sname > /dev/null
        if [ $? -eq 0 ]
        then
            has_mpcephem=1
            echo "# Comet ephemerides keywords added" >&2
        else
            echo "ABORTING $FUNCNAME due to failure in get_mpcephem $sname." >&2 &&
            return 255
        fi
    fi

    # check image coordinates
    ra=$(get_header -q $hdr RA)
    test -z "$ra" && ra=$(get_header -q $hdr OBJCTRA)
    test -z "$ra" && test "$is_centered" && ra=$(get_header -q $hdr AI_CORA)
    dec=$(get_header -q $hdr DEC)
    test -z "$dec" && dec=$(get_header -q $hdr OBJCTDEC)
    test -z "$dec" && test "$is_centered" && dec=$(get_header -q $hdr AI_CODEC)
    
    test -z "$ra" && err="$err RA"
    test -z "$dec" && err="$err DEC"
    (test -z "$ra" || test -z "$dec") &&
        echo "ERROR: missing approximate image center coordinates (RA, DEC)" >&2
    (test -z "$ra" || test -z "$dec") && ! test "$is_centered" &&
        echo "       (if comet is near image center then rerun AIstart using -c switch)" >&2

    # TODO: get image center from wcs calibrated images

    
    #----------------------------
    # comet position
    #----------------------------
    is_wcs $whdr && has_wcs=1
    x=$(get_header -q $hdr AI_OXY)
    if [ "$x" ]
    then
        # TODO: check correct format of AI_OXY
        echo "# Found image pixel coordinates of comet (AI_OXY)." >&2
    else
        # try to estimate AI_OXY
        test "$has_mpcephem" && test "$has_wcs" &&
            x=$(echo comet $(get_header -s $hdr AI_CORA,AI_CODEC) | \
                rade2xy - $whdr | awk '{printf("%.0f,%.0f", $2, $3)}')
        if [ -z "$x" ]
        then
            if [ "$has_wcs" ] || [ -z "$has_mpcephem" ]
            then
                err="$err AI_OXY"
                echo "ERROR: unable to determine image pixel coordinates of the comet (AI_OXY)." >&2
            fi
        fi                
    fi
    

    #----------------------------
    # comet trail information
    #----------------------------
    str=$(get_header -q $hdr AI_TRAIL)
    if [ "$str" ]
    then
        x=$(echo $str | tr ',' ' ' | wc -w)
        test $x -gt 0 && tlen=$(echo $str | cut -d "," -f1)
        test $x -gt 1 && tpa=$(echo $str | cut -d "," -f2)
        test $x -eq 3 && echo "# Using comet trail parameters (keyword AI_TRAIL)." >&2
        test $x -nq 3 && echo "# Using incomplete comet trail parameters (AI_TRAIL=$str)." >&2
    else
        if [ ! "$has_mpcephem" ]
        then
            err="$err AI_TRAIL"
            str="ERROR: unable to determine trail parameters.
                .    Please measure moving object trail length (in pixel) and angle
                .    (in degrees from right over top) and add keyword by using the
                .    command:   set_header $sname.head AI_TRAIL=length,angle"
            echo "$str" | sed -e 's|^[[:space:]]*\.||' >&2
        fi
    fi

    
    # restore file if contents has not changed
    echo ""
    if diff $orighdr $hdr > /dev/null
    then
        mv $orighdr $hdr
    else
        echo "Image header file $hdr has been modified." >&2
        test ! -e $sname.orig.head && mv $orighdr $sname.orig.head
    fi
    if [ "$err" ]
    then
        echo "Please fix errors by supplying missing header keywords." >&2
    else
        echo "All required keywords successfully validated." >&2
        if [ -z "$no_gui" ]
        then
            read -p "Do you want to start the AIRTOOLS graphical user interface now?  [Y/n]  " -r -n 1 answer
            echo
            answer=${answer,,}
            test -z "$answer" && answer=y
            if [ "$answer" == "y" ]
            then
                AIexamine $ststack $costack &
            else
                echo "To start the GUI later use: AIexamine $ststack $costack &" >&2
            fi
        fi
    fi
    echo
    
    rm -f $tmpim $tmpfits $tmpdat $orighdr
    echo $err
    test "$err" && return 255
    return 0
}


check_url () {
    # check if a given website is reachable
    local url=${1:-"http://www.google.com"}
    local tries=${2:-6}
    local delay=1
    local retval
    local i=1
    (test "$1" == "-h" || test $# -gt 2) &&
        echo "usage: check_url [url|$url] [trials|$tries]" >&2 &&
        return 1
    while [ $i -le $tries ]
    do
        if [ $i -gt 1 ]
        then
            test "$AI_DEBUG" && echo "# $i/$tries sleep $delay" >&2
            sleep $delay
            delay=$(echo $delay | awk '{
                x=1.5*$1; if(x>10){x=10}; printf("%.1f", x)}')
        fi
        wget -q --tries=2 --timeout=10 --spider $url
        retval=$?
        test $retval -eq 0 && break
        i=$((i+1))
    done
    return $retval
}

click2mpcheck () {
    # convert click-position as given by jaicomp to data suitable for input
    # to MPChecker (http://scully.cfa.harvard.edu/cgi-bin/checkmp.cgi)
    local s=$1      # setname
    local rad=$2
    local ded=$3
    local nref
    local jd
    (test "$1" == "-h" || test $# -ne 3) &&
        echo "usage: click2mpcheck <setname> <rad> <ded>" >&2 &&
        return 1

    test -f $s.head &&
        jd=$(grep "^MJD_REF"  $s.head | awk '{printf("%.3f\n", $3)}')
    test -z "$jd" &&
        nref=$(grep "^[0-9].:.. $s " set.dat | awk '{printf("%s", $8)}') &&
        test -f $AI_RAWDIR/$nref.hdr &&
        jd=$(grep jdmid $AI_RAWDIR/$nref.hdr | cut -d '=' -f2)
    test -z "$jd" &&
        echo "ERROR: unknown jd." >&2 && return 255
    d=$(echo "scale=3; (${day:4} + 0.${jd#*.} + 0.5)/1" | bc -l)
    echo $jd $d
    ras=$(dec2sexa $rad 15 1 | tr ':' ' ')
    des=$(dec2sexa $ded 1 0 | tr ':' ' ')
    echo $ras " " $des
}

mpchecker () {
    local showhelp
    local ref=http://www.minorplanetcenter.net/cgi-bin/checkmp.cgi
    local url=http://www.minorplanetcenter.net/cgi-bin/mpcheck.cgi
    local utdate    # yyyy-mm-dd.dd
    local mlim
    local rad       # search radius in arcmin
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-d" && utdate=$2 && shift 2
        test "$1" == "-m" && mlim=$2 && shift 2
        test "$1" == "-r" && rad=$2 && shift 2
    done
    
    local sname="$1"
    local ra="$2"
    local de="$3"

    local cameradat="camera.dat"
    local reg
    local jd
    local date
    local name
    local coord
    local x
    local str
    local args
    local args2
    local tmp1=$(mktemp "/tmp/tmp_tmp1_$$.XXXXXX.html")
    local tmp2=$(mktemp "/tmp/tmp_tmp2_$$.XXXXXX.dat")
    local tmpreg=$(mktemp "/tmp/tmp_reg_$$.XXXXXX.reg")

    (test "$showhelp" || test $# -lt 2) &&
        echo -e "usage: mpchecker [-d yyyy-mm-dd.dd] [-m maglim] [-r rad] <set> <reg | ra de>" >&2 &&
        return 1
    
    # check for region file
    test -f "$ra" && reg="$ra"
    test -z "$reg" && test -z "$de" &&
        echo -e "usage: mpchecker [-d yyyy-mm-dd.dd] [-m maglim] [-r rad] <set> <reg | ra de>" >&2 &&
        return 1

    # date parameters
    if [ "$utdate" ]
    then
        date=$(echo $utdate | awk -F '-' '{printf("year=%d&month=%02d&day=%06.3f", $1,$2,$3)}')
    else
        jd=$(AIsetinfo -l $sname | awk '{printf("%s", $5)}')
        date=$(jd2ut $jd | awk -F '-' '{printf("year=%d&month=%02d&day=%06.3f", $1,$2,$3)}')
    fi
    
    # coordinates parameter
    if [ -z "$reg" ]
    then
        ra=$(dec2sexa $(sexa2dec $ra 1 7) 1 2 | tr -d "+-")
        de=$(dec2sexa $(sexa2dec $de 1 7) 1 1)
        echo "circle($ra,$de,10) # text={X}" > $tmpreg
        reg=$tmpreg
    fi
    
    # determine maglim and search radius
    if [ -z "$mlim" ]
    then
        x=$(get_param camera.dat aperture $sname)
        mlim=15
        test $x -gt 15 && mlim=16
        test $x -gt 30 && mlim=17
        test $x -gt 50 && mlim=18
        test $x -gt 70 && mlim=19
        test $x -gt 100 && mlim=20
        test $x -gt 180 && mlim=21
        test $x -gt 280 && mlim=22
        str="maglim=$mlim"
    fi
    if [ -z "$rad" ]
    then
        x=$(exp10 $(echo "$mlim/10" | bc -l))
        rad=$(echo $x | awk '{
            x=500/$1
            if (x > 5) {
                printf("%.0f", x)
            } else {
                x=int(2*x+0.5)/2
                printf("%.1f", x)
            }
        }')
        str="$str rad=$rad"
    fi
    test "$str" && echo "# using" $str >&2

    i=0
    while read
    do
        #echo "# $REPLY"
        test "${REPLY:0:6}" != "circle" && continue
        set - $(echo $REPLY | tr '(,){}' ' ')
        ra="$2"; de="$3"; name="$7"
        ra=$(dec2sexa $(sexa2dec $ra 1 7) 1 2 | tr -d "+-")
        de=$(dec2sexa $(sexa2dec $de 1 7) 1 1)
        coord="ra=${ra//:/+}&decl=${de//:/+}"
        test "$AI_DEBUG" &&
            echo "date=$date   coord=$coord" >&2
        
        #POST /cgi-bin/cmtcheck.cgi year=2014&month=11&day=22.91&ra=03+49+01.6&decl=%2B21+50+10
        #&which=obs&TextArea=&radius=5&limit=18.0&oc=500&sort=d&mot=h&tmot=s&pdes=u&needed=f&ps=n&type=p

        args="${date}&which=pos&${coord}&TextArea=&radius=$rad&limit=$mlim"
        args2="oc=500&sort=d&mot=h&tmot=s&pdes=u&needed=f&ps=n&type=p"
        test "$AI_DEBUG" && echo "curl -s --referer $ref --data \"$args&${args2}\" $url" >&2
        
        curl -s --referer $ref --data "${args}&${args2}" -o $tmp1 $url
        test $? -ne 0 &&
            echo "ERROR: curl error."  && return 255
        grep -q "Incorrect Form Entry" $tmp1 &&
            echo "ERROR: incorrect web form entry, see $tmp1" >&2 && return 255
        grep -qi "Error" $tmp1 &&
            echo "ERROR: cgi error, see $tmp1" >&2 && return 255

        cat $tmp1 | awk 'BEGIN{sectionnum=0; data=0; drow=0}{
            if ($0~/<hr>/) {
                sectionnum++
                getline
                gsub(/[ ]*<[\/]*b>[ ]*/,"")
                if (sectionnum==1) print "# "$0
            }
            if ($0~/<pre>/) {data=1; getline}
            if ($0~/<\/pre>/) {data=0; drow=0}
            if (data == 1) {
                drow+=1
                if (drow==1 || drow>3) {gsub(/<a href.*/,""); print $0}
            }
            }' > $tmp2
        test ! -s $tmp2 && continue
        i=$((i+1))
        test $i -eq 1 && echo "#  $(grep -i "Object designation" $tmp2)"
        echo "$name: $(tail -1 $tmp2 | sed -e 's/[ ]*None needed.*//')"
    done < $reg
    test "$AI_DEBUG" && echo $tmpreg $tmp1 $tmp2
    test ! "$AI_DEBUG" && rm -f $tmpreg $tmp1 $tmp2
}

get_cobs_old () {
    # get observations from COBS database
    # output is written to stdout
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1

    local comet="$1"    # comet ID (1074 = 2014Q2) or name
    local start=${2:-"$(date +"%F" -d 'now - 1 year')"}
    local cdat=${3:-"../cobs.cometid.csv"}  # ID data file with lines:
                                            # cometid,name,fullname
    local prog=http://www.cobs.si/analysis2
    #local interval="start_date=2015/07/01%2000:00&end_date=2015/12/31%2000:00"
    local interval
    #local url="${prog}?plot_type=0&comet_id=${cid}&${interval}&obs_type=0"
    local url=""
    local cid
    local cname
    local end
    local tmp1=$(mktemp "/tmp/tmp_tmp1_$$.XXXXXX.html")

    (test "$showhelp" || test $# -lt 1) &&
        echo -e "usage: get_cobs <comet> [start_yyyy-mm-dd|$start] [cobs_id_file|$cdat]" >&2 &&
        return 1

    test ! -f $cdat &&
        echo "ERROR: COBS cometID data file $cdat not found." >&2 && return 255
    is_integer "$comet" && cid=$comet
    # TODO: do exact query of second field in $cdat
    test -z "$cid" && cid=$(grep -w "$comet" $cdat | cut -d "," -f1)
    test -z "$cid" && if is_integer "${comet:0:4}" && [ ${#comet} -ge 6 ]
    then
        test "${comet:4:1}" != " " && cname="C/${comet:0:4} ${comet:4}"
        test "${comet:4:1}" == " " && cname="C/$comet"
        cid=$(grep -w "$cname" $cdat | cut -d "," -f1)
    fi
    test -z "$cid" &&
        echo "ERROR: no comet ID for $comet in $cdat" >&2 && return 255
    
    end=$(date +"%F" -d 'now + 1 day')
    interval="start_date=${start//-/\/}%2000:00&end_date=${end//-/\/}%2000:00"
    url="${prog}?plot_type=0&obs_type=0&comet_id=${cid}&${interval}"
    # analysis2 arguments:
    #   plot_type (0-magnitude , ...)
    #   obs_type (0 - all)

    echo "url=$url" >&2
    wget -O $tmp1 "$url"
    w3m -dump $tmp1
    rm -f $tmp1
    return
}

get_cobs () {
    # get observations from COBS database
    # output is written to stdout
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1

    local comet="$1"    # comet name, e.g. "2016 R2"
    local start=${2:-"$(date +"%F" -d 'now - 3 years')"}
    local end
    local interval
    local prog=http://www.cobs.si/analysis
    local x
    local n
    local fullname
    local par1
    local par2
    local url
    local cname         # full comet name
    local tmp1=$(mktemp "/tmp/tmp_tmp1_$$.XXXXXX.html")
    local tmpcdb=$(mktemp "/tmp/tmp_cdb_$$.XXXXXX.dat") # comet name database

    (test "$showhelp" || test $# -lt 1) &&
        echo -e "usage: get_cobs <comet> [start_yyyy-mm-dd|$start]" >&2 &&
        return 1

    # get comet names database
    wget -O $tmp1 "$prog"
    cat $tmp1 | awk '{
        if ($0~/Select comet/) {getline; ok=1}
        if ($0~/\/select/) {ok=0}
        if (ok==1) {print $0}
        }' | tr '<>' '\n' | grep "[a-zA-Z0-9]" | grep -v "option" > $tmpcdb
    # convert comet name YYYYXX to YYYY XX
    x=$(echo $comet | awk '{
        if($0~/^[1-2][0-9][0-9][0-9][A-Z][A-Z]*[0-9]/) {
            printf("%s %s", substr($0,1,4), substr($0,5))
        } else {printf("%s", $0)}}')
    #   search in $tmpcdb and convert to fullname
    n=$(grep -w "$x" $tmpcdb | wc -l)
    test $n -ne 1 &&
        echo "ERROR: comet $x unknown to database $tmpcdb" >&2 &&
        return 255
    fullname=$(grep -w "$x" $tmpcdb)
    echo "fullname=$fullname" >&2
    
    # example
    # comet="C/2016 R2 (PANSTARRS)"
    par1="required_fields=COMET_FULLNAME&COMET_FULLNAME=${fullname}"
    par2="COMET_MPC=&PERIHELION_DATE=&PLOT_TYPE=Magnitude&OBSERVER=0&ASSOCIATION=0&SUBMIT=Get+Obs&COUNTRY=0"
    interval="START_DATE=YYYY%2FMM%2FDD+hh%3Amm&H0=&N=&END_DATE=YYYY%2FMM%2FDD+hh%3Amm"
    
    url="${prog}?${par1}&${par2}&${interval}"
    wget -O $tmp1 "$url"
    w3m -dump $tmp1 | awk '{
        if ($0~/^IIIYYYYMnL/) {ok=1}
        if ($0~/^$/) {ok=0}
        if (ok==1) {print $0}
        }'
    
    rm -f $tmp1 $tmpcdb
    return
}

get_mpcephem () {
    local showhelp
    local do_write_header   # if set write some results to image header keywords
    local do_aladin_commands # if set show aladin commands for plotting positions
    local n=1   # number of ephemerides entries per object
    local dhr="120:00"   # interval in HH:MM:SS
    local i
    for i in 1 2 3 4
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-w" && do_write_header=1 && shift 1
        test "$1" == "-a" && do_aladin_commands=1 && shift 1
        test "$1" == "-n" && n=$2 && shift 2
        test "$1" == "-i" && dhr=$2 && shift 2
    done
    
    local sname="$1"    # set name or header file or objects (separated by comma)
    # objects="C%2F2012+K1%2CC%2F2010+S1%2C154P%2C2P%2CC%2F2012+S1%2CC%2F2013+R1"
    local utday="$2"    # e.g. "2013-09-29"
    local uttime="$3"   # HH:MM, note seconds are not allowed
    local hdr
    local objects       # e.g. "C/2012 K1,154P"
    local sdat=${AI_SETS:-"set.dat"}
    local ref=https://www.minorplanetcenter.net/iau/MPEph/MPEph.html
    local url=https://cgi.minorplanetcenter.net/cgi-bin/mpeph2.cgi
    local jd
    local dateobs
    local dmin
    local interval
    local long
    local lat
    local alt
    local args
    local args2
    local tmp1=$(mktemp "/tmp/tmp_tmp1_$$.XXXXXX.html")
    local tmp2=$(mktemp "/tmp/tmp_tmp2_$$.XXXXXX.dat")
    local ra
    local de
    local dr
    local pa
    local mphase
    local mdist
    local malt
    local str
    local nval
    local y
    local m
    local d
    local u
    local rah
    local ram
    local ras
    local ded
    local dem
    local des
    local x
    
    (test "$showhelp" || test $# -lt 1) &&
        echo -e "usage: get_mpcephem [-w] [-n num] [-i interval_hh:mm] <set|objects> [utday_yyyy-mm-dd] [uttime_hh:mm]" >&2 &&
        return 1

    # set name or header file or objects
    if [ -e "$sdat" ] && is_setname "$sname"
    then
        hdr=$sname.head
    else
        if is_ahead "$sname"
        then
            hdr="$sname" && sname=""
        else
            objects="$sname" && sname=""
        fi
    fi
    test "$do_write_header" && (test -z "$hdr" || test ! -e "$hdr") &&
        echo "ERROR: header file $hdr is missing (required by option -w)" >&2 && return 255
    
    # get object name(s)
    test -z "$objects" && test "$hdr" &&
        objects=$(get_header -q $hdr OBJECT | sed -e 's,^[ ]*,,; s,[ ]*$,,')
    test -z "$objects" && if [ "$sname" ]
    then
        # read target name from $sdat
        set - $(grep   -v "^#" $sdat | awk -v s=$sname '{if($2==s){print $0}}')
        test -z "$objects" && objects="$3"
        test -z "$objects" && echo "ERROR: no matching $sname in $sdat." >&2 && return 255
    fi
    test -z "$objects" &&
        echo "ERROR: missing object name(s)." >&2 && return 255
    # TODO: deal with multiple objects
    #   e.g. adjust names, disable writing to header
    if is_integer ${objects:0:4} && [ ${#objects} -ge 6 ]
    then
        test "${objects:4:1}" != " " && objects="C/${objects:0:4} ${objects:4}"
        test "${objects:4:1}" == " " && objects="C/$objects"
    fi

    # get lat/long
    if [ "$AI_SITE" ]
    then
        test -f "$hdr" &&
            long=$(get_header -q $hdr SITELONG | cut -d ':' -f1-3)
        test "$long" || long=$(get_param -k 2 sites.dat long "$AI_SITE" AI_LONGITUDE)
        test $? -ne 0 && return 255
        test "${long/:/}" != "$long" && long=$(sexa2dec $long)
        test -f "$hdr" &&
            lat=$(get_header -q $hdr SITELAT | cut -d ':' -f1-3)
        test "$lat"  || lat=$(get_param  -k 2 sites.dat lat  "$AI_SITE" AI_LATITUDE)
        test $? -ne 0 && return 255
        test "${lat/:/}" != "$lat" && lat=$(sexa2dec $lat)
        alt=$(get_param  -k 2 sites.dat alt  "$AI_SITE" "" 500)
    else
        test "$do_write_header" &&
            echo "ERROR: AI_SITE is not set (required by option -w)" >&2 && return 255
        echo "WARNING: AI_SITE is not set." >&2
        long=0
        lat=0
        alt=0
    fi
    test "$AI_DEBUG" && echo "# long=$long  lat=$lat" >&2
    test "$do_write_header" && test $n -ne 1 &&
        echo "WARNING: changing n from $n to 1 (required by option -w)" >&2 && n=1
    
    # convert and check interval
    dmin=$(echo "$dhr" | awk -F ":" '{printf("%.0f", $1*60+$2)}')
    dhr=$(echo "$dhr" | awk -F ":" '{printf("%.0f", $1+$2/60)}')
    #test $dhr -gt 480 &&
    #    echo "ERROR: interval is bejond limit of 480 hours." >&2 && return 255

    # determine utday and uttime
    if [ -z "$hdr" ]
    then
        test -z "$utday"  && test -z "$uttime" &&
            utday=$(date -u +"%Y-%m-%d") && uttime=$(date -u +"%H:%M")
        test -z "$utday"  && utday=$(date -u +"%Y-%m-%d")
        test -z "$uttime" && uttime="00:00"
    fi
    test "$utday" && test ${#utday} -eq 8 &&
        utday=${utday:0:4}"-"${utday:4:2}"-"${utday:6:2}
    # TODO: check correct format of uttime, hours must have 2 digits (leading zero)
    if [ -z "$utday" ] || [ -z "$uttime" ]
    then
        jd=$(get_jd -k "JD,JD_OBS,DATE-OBS" $hdr)
        # try header of nref
        test -z "$jd" && if [ "$sname" ]
        then
            set - $(AIsetinfo -b $sname | grep -w o | head -1)
            test -f measure/$8.src.head &&
                jd=$(get_jd -q -k "JD,JD_OBS,MJD_OBS,DATE-OBS" measure/$8.src.head)
        fi
        test -z "$jd" &&
            echo "ERROR: cannot get jd to calculate missing utday/uttime." >&2 && return 255
        
        test -z "$utday" && utday=$(jd2ut -t $jd | cut -d " " -f1)
        test -z "$uttime" && uttime=$(jd2ut -t $jd | cut -d " " -f2)
    fi
    test "$AI_DEBUG" && echo "# objects=\"$objects\" ut=\"$utday $uttime\""
    
    # check internet connection
    ! check_url && echo "ERROR: no internet connection." >&2 && return 1
    ! check_url $url && echo "ERROR: no access to $url" >&2 && return 2
    
    # set interval
    interval=""
    test $n -eq 1 && interval="1&u=s"
    test -z "$interval" && test $dmin -le 240 && interval=$dmin"&u=m"
    test -z "$interval" && test $dhr  -le 240 && interval=$dhr"&u=h"
    

    args="l=$n&i=$interval&uto=0&c=&long=$long&lat=$lat&alt=$alt"
    args2="raty=a&s=t&m=h&adir=N&oed=&e=-2&resoc=&tit=&bu=&ch=c&ce=f&js=f"
    test "$AI_DEBUG" && echo "args=\"$args\"" >&2 && echo "args2=\"$args2\"" >&2
    
    test "$AI_DEBUG" && echo "curl -s --referer $ref --data" \
        "\"ty=e&TextArea=$objects&d=$utday+${uttime//:/}&$args&$args2\" -o $tmp1 $url" >&2
    curl -s --referer $ref --data "ty=e&TextArea=$objects&d=$utday+${uttime//:/}&$args&$args2" \
        -o $tmp1 $url
    #w3m -dump -T text/html $tmp1
    test $? -ne 0 &&
        echo "ERROR: get_mpcephem: curl failed" >&2 && return 255
    cat $tmp1 | awk 'BEGIN{sectionnum=0; objectline=0; data=0; drow=0}{
        if ($0~/<hr>/) {
            sectionnum++
            i=0
            while (objectline == 0 && i<10) {
                getline
                if ($0~/No current elements/) objectline=-1
                if ($0~/<b>/) objectline=1
                i++
            }
            gsub(/[ ]*<[\/]*b>[ ]*/,"")
            if (sectionnum==1) {
                if (objectline==1) print "# "$0
                if (objectline==-1) {gsub(/\. .*/,""); print "# "$0}
            }
        }
        if (objectline == 1) {
            if ($0~/<i>MPC<\/i>/ || $0~/<i>MPO<\/i>/) {
                gsub(/<[\/]*i>/,"")
                gsub(/\.[ ]*/,"")
                print "#"$0
            }
            if ($0~/<pre>/) {data=1; getline}
            if ($0~/<\/pre>/) {data=0; drow=0}
            if (data == 1) {
                drow+=1
                if (drow==2 || drow==3) print "#"$0
                if (drow>3) print $0
            }
        }
        }' > $tmp2
    grep "^#" $tmp2
    grep -v "^#" $tmp2 | sed -e 's|/.*||'
    if [ $? -ne 0 ]
    then
        test "$AI_DEBUG" && echo $tmp1 $tmp2 >&2
        test "$AI_DEBUG" || rm $tmp1 $tmp2
        echo "ERROR: No current elements found for $objects." >&2
        return 3
    fi
    
    set - $(grep -v "^#" $tmp2 | sed -e 's|/.*||' | head -1) xx
    nval=$#
    (test $nval -lt 23 || test $nval -gt 26) &&
        echo "WARNING: $objects: wrong number of values ($nval)" >&2 &&
        echo $tmp1 $tmp2 >&2 &&
        return 255

    if [ "$do_write_header" ] && grep -q -v "^#" $tmp2
    then
        shift 4
        ra="$1:$2:$3"; de="$4:$5:$6"
        set_header $hdr AI_CORA="$ra" AI_CODEC="$de"
        set_header $hdr AI_CODEL="$7/Distance from observer"
        set_header $hdr AI_COR="$8/Distance from Sun"
        set_header $hdr AI_COEL="$9/Solar elongation"
        set_header $hdr AI_COPH="$10/Phase angle of comet"
        test $nval -eq 23 && shift 10
        test $nval -eq 24 && shift 11
        test $nval -eq 25 && shift 11
        test $nval -eq 26 && shift 11
        dr=$1; pa=$2; mphase=$6; mdist=$7; malt=$8
        set_header $hdr AI_COAZI=$3 AI_COALT=$4
        set_header $hdr AI_OMOVE="$(LANG=C printf "%.1f@%.1f" $dr $pa)/Object motion on sky per hour"
        set_header $hdr AI_MOP="$mphase/Moon phase" AI_MOD="${mdist##+(0)}/Moon distance angle" AI_MOALT="$malt/Moon altitude"
        #str=$(LANG=C printf "%s %s %s %s  %.1f@%.1f  %.2f %3g %s\n" \
        #    $hdr $ra $de $alt  $dr $pa  $mphase $mdist $malt)
        #AIsetkeys "$str" AI_CORA AI_CODEC AI_COALT AI_OMOVE AI_MOP AI_MOD AI_MOALT
    fi

    if [ "$do_aladin_commands" ] && grep -q -v "^#" $tmp2
    then
        grep -v "^#" $tmp2 | while read y m d u rah ram ras ded dem des x
        do
            str=$u
            echo "draw red tag($rah:$ram:$ras,$ded:$dem:$des,\"$str\",0,0,circle,10);"
        done
    fi
    test "$AI_DEBUG" && echo $tmp1 $tmp2 >&2
    test "$AI_DEBUG" || rm $tmp1 $tmp2
}

mkrefcat () {
    # download objects from vizier database (CDS) and create
    # astrometric or photometric reference catalog
    # ref.: http://vizier.u-strasbg.fr/doc/asu-summary.htx
    local showhelp
    local server=cds
    local wcshdr
    local nmax=1000
    local rdat=refcat.dat   # catalog column description
    local outfmt="tsv"      # output table format, tsv - tab separated ASCII,
                            # fits - FITS LDAC table
    local all_columns       # if set then all columns are queried
    local i
    for i in 1 2 3 4 5 6
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-s" && server="$2" && shift 2
        test "$1" == "-w" && wcshdr="$2" && shift 2
        test "$1" == "-n" && nmax="$2" && shift 2
        test "$1" == "-f" && outfmt="fits" && shift 1
        test "$1" == "-a" && all_columns=1 && shift 1
    done
    local catalog=$1
    local ra=$2     # center coordinates
    local de=$3
    local radius=$4 # search radius in degrees
    local vizprog
    local vid
    local sortcol
    local rad
    local ded
    local center
    local args
    local opts
    local pscale
    local w
    local x
    local tmp1=$(mktemp "/tmp/tmp_tmp1_$$.XXXXXX.dat")
    local tmp2=$(mktemp "/tmp/tmp_tmp2_$$.XXXXXX.dat")
    local ahead=$(mktemp "/tmp/tmp_ahead_$$.XXXXXX.head")
    local tmpldac=$(mktemp "/tmp/tmp_ldac_$$.XXXXXX.dat")
    
    (test "$showhelp" || test $# -lt 4) &&
        echo -e "usage: mkrefcat [-h] [-f] [-a] [-s server|$cds] [-w wcshdr] [-n nmax|$nmax]" \
            "<catalog> <ra> <de> <radius>" >&2 &&
        return 1

    case "$server" in
        cds)    vizprog="http://vizier.u-strasbg.fr/viz-bin/asu-$outfmt";;
        us)     vizprog="http://vizier.cfa.harvard.edu/viz-bin/asu-$outfmt";;
        uk)     vizprog="http://archive.ast.cam.ac.uk/viz-bin/asu-$outfmt";;
        jp)     vizprog="http://vizier.nao.ac.jp/viz-bin/asu-$outfmt";;
        *)      echo "ERROR: unknown database server $server. Try one of cds, us, uk, jp." >&2 &&
                return 255;;
    esac

    # get vizier catalog identifier
    vid=$(get_param $rdat vid $catalog)
    test -z "$vid" && echo "ERROR: unknown catalog." >&2 && return 255
    
    # get sort column (brightest sources)
    sortcol=$(get_param $rdat msort $catalog)
    test "$outfmt" != "tsv" && test -z "$sortcol" &&
        echo "ERROR: mag sort column (msort) undefined." >&2 && return 255

    # TODO: evaluate wcs header to determine center coordinates and search radius
    # convert center coordinates to degrees unit
    test "${ra/:/}" != "$ra" && rad=$(sexa2dec $ra 15)
    test -z "$rad" && rad=$ra
    test "${de/:/}" != "$de" && ded=$(sexa2dec $de)
    test -z "$ded" && ded=$de
    # TODO: replace "+" by "%2b"
    center="${rad}%20${ded/+/%2b}"
    #args="-mime=%7c&-source=${vid}&-out.max=${nmax}&-c.rd=${radius}"
    args="-source=${vid}&-sort=*phot.mag&-out.max=${nmax}&-c.rd=${radius}"
    if [ "$outfmt" == "tsv" ]
    then
        args="$args&-mime=%7c"   # delimiter |
    else
        test "$all_columns" && args="$args&-out.all"
        test ! "$all_columns" && args="$args&-out.add=$sortcol"
    fi
    
    # run database query
    test "$AI_DEBUG" &&
        echo "wget -O $tmp1 \"${vizprog}?${args}${opts}&-c=${center}\"" >&2
    wget -O $tmp1 "${vizprog}?${args}${opts}&-c=${center}"
    
    if [ "$outfmt" == "tsv" ]
    then
        cat $tmp1
    else
        # create global ahead file (using arbitrary pixscale)
        pscale=0.001
        w=$(echo $radius $pscale | awk '{printf("%d", 8*int(2.04*$1/$2/8+2))}')
        x=$(echo $w | awk '{printf("%.1f", $1/2+0.5)}')
        echo "\
SIMPLE  =                    T / This is a FITS file                            
BITPIX  =                    0 /                                                
NAXIS   =                    2 / 2D data                                        
NAXIS1  =                $w / Number of rows                                 
NAXIS2  =                $w / Number of columns                              
EXTEND  =                    T / This file may contain FITS extensions          
TELESCOP= 'Telescope'  / Observatory: Telescope
INSTRUME= 'Camera'     / Detector: Camera
FILTER  = 'FILTER'     / Detector: Filter
EXPTIME =      1       / Exposure time in seconds
EPOCH   =      2000.0  / Epoch
EQUINOX =      2000.0  / Mean equinox
RADESYS = 'ICRS    '   / Astrometric system
CTYPE1  = 'RA---TAN'   / WCS projection type for this axis
CUNIT1  = 'deg     '   / Axis unit
CRVAL1  =      $rad    / World coordinate on this axis
CRPIX1  =      $x     / Reference pixel on this axis
CD1_1   =      -$pscale   / Linear projection matrix
CD1_2   =      0          / Linear projection matrix
CTYPE2  = 'DEC--TAN'   / WCS projection type for this axis
CUNIT2  = 'deg     '   / Axis unit
CRVAL2  =      $ded    / World coordinate on this axis
CRPIX2  =      $x     / Reference pixel on this axis
CD2_1   =      0          / Linear projection matrix
CD2_2   =      $pscale    / Linear projection matrix
PHOTFLAG=      F
END     " > $ahead

        # create LDAC_IMHEAD table
        echo '# "Field Header Card"' > $tmp2
        printf '"' >> $tmp2
        cat $ahead | awk '{printf("%-80s\n", $0)}' | tr -d '\n' >> $tmp2
        echo '"' >> $tmp2
        stilts tcopy ifmt=ascii ofmt=fits-basic $tmp2 $tmpldac
        sethead $tmpldac",1" EXTNAME=LDAC_IMHEAD
        sethead $tmpldac",1" TDIM1='(80,'$(wc -l $ahead | cut -d ' ' -f1)')'

        # combine LDAC_IMHEAD and LDAC_OBJECTS
        stilts tcopy ifmt=fits ofmt=fits-basic in=${tmp1}"#"1 out=$tmp2
        sethead $tmp2",1" EXTNAME=LDAC_OBJECTS
        stilts tmulti ifmt=fits ofmt=fits-basic in=$tmpldac in=$tmp2 out=$tmp1

        # add required columns for scamp reference catalog
        #   note: MAGERR and FLAGS are not strictly required
        #
        fitscopy "$tmp1[LDAC_OBJECTS][col \
            *;\
            X_WORLD=RAJ2000;\
            Y_WORLD=DEJ2000;\
            ERRA_WORLD=0.00001;\
            ERRB_WORLD=0.00001;\
            MAG=${sortcol//\./_};\
            MAGERR=0.2;\
            FLAGS=0;\
            OBSDATE=2000.0;\
            ]" - > $tmp2
        
        # listhead
        x=$(get_header -e 2 $tmp1 TFIELDS)
        sethead $tmp2",2" TUNIT$((x+1))='deg'
        sethead $tmp2",2" TUNIT$((x+2))='deg'
        sethead $tmp2",2" TUNIT$((x+3))='deg'
        sethead $tmp2",2" TUNIT$((x+4))='deg'
        sethead $tmp2",2" TUNIT$((x+5))='mag'
        sethead $tmp2",2" TUNIT$((x+6))='mag'
        sethead $tmp2",2" TUNIT$((x+8))='yr'

        cat $tmp2
    fi
    
    test "$AI_DEBUG" && echo "$tmp1 $tmp2 $ahead $tmpldac" >&2
    test ! "$AI_DEBUG" && rm -f $tmp1 $tmp2 $ahead $tmpldac
    return
}

photplot () {
    # plotting results from photometry data files
    local showhelp
    local color="V"     # color band name (V|B|R)
    local type="mag"    # type of residuals to plot mag|color
    local title         # plot title
    local gpcmd         # additional gnuplot commands
    local yrange        # yrange in the form y1:y2
    local outfile       # if set then print to given file
    local verbose
    local i
    for i in $(seq 1 10)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-B" && color="B" && shift 1
        test "$1" == "-V" && color="V" && shift 1
        test "$1" == "-R" && color="R" && shift 1
        test "$1" == "-c" && type="color" && shift 1
        test "$1" == "-t" && title="$2" && shift 2
        test "$1" == "-g" && gpcmd="$2" && shift 2
        test "$1" == "-y" && yrange="$2" && shift 2
        test "$1" == "-o" && outfile="$2" && shift 2
        test "$1" == "-v" && verbose="1" && shift 1
    done
    
    local set=$1
    local catalog=$2
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpdat=$(mktemp "$tdir/tmp_dat1.XXXXXX.dat")
    local hdr
    local xphot
    local f
    local x
    local xlist
    local magzero
    local data
    local aidx
    local apmzer
    local apmmag
    local aprmag
    local apslop
    local apcind
    local apcval
    local magdiff
    local cimd
    local colmag
    local colcat
    local colci1
    local colci2
    
    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: photplot [-v] [-c] [-B|-V|-R] <set> <refcat>" >&2 &&
        return 1
    
    ! is_setname "$set" &&
        echo "ERROR: unknown set $set." >&2 && return 255
        
    hdr=$set.head
    xphot=phot/$set.$catalog.xphot.dat
    for f in $hdr $xphot
    do
        ! test -s $f && echo "ERROR: file $f not found." >&2 && return 255
    done
    
    # read calibration data from header file
    magzero=$(get_header $hdr MAGZERO)
    test $? -ne 0 && echo "ERROR: no MAGZERO in $hdr" >&2 && continue
    xlist=$(get_header $hdr all | grep "^AP_AIDX[1-9]=" | cut -c8 | sort -nu)
    test -z "$xlist" &&
        echo "ERROR: no calibration data in $hdr." >&2 && continue
    for x in $xlist
    do
        set - $(get_header -q -s $hdr AP_PCAT$x,AP_PCOL$x,AP_CIND$i)
        test "${verbose}${AI_DEBUG}" && LANG=C printf "# $x %-6s %s %s\n" $1 $2 $3
        test "$1" == "$catalog" && test "$2" == "$color" && aidx=$x
    done
    test -z "$aidx" &&
        echo "ERROR: no match found for given catalog and color." >&2 && return 255
    
    test "${verbose}${AI_DEBUG}" && echo "# aidx=$aidx"
    apmzer=$(get_header $hdr AP_MZER$aidx)
    apmmag=$(get_header $hdr AP_MMAG$aidx)
    aprmag=$(get_header $hdr AP_RMAG$aidx)
    apslop=$(get_header $hdr AP_SLOP$aidx)
    apcind=$(get_header $hdr AP_CIND$aidx)
    apcval=$(get_header $hdr AP_CVAL$aidx)
    #magdiff=$(echo $apmzer $magzero | awk '{printf("%f", $1-$2)}')
    magdiff=$(echo $aprmag $apmmag | awk '{printf("%f", $1-$2)}')
    echo "# mzer=$apmzer mdiff=$magdiff m=$color+$apcval*($apcind)"
    
    colmag=5
    colcat=8
    colci1=7
    colci2=8
    
    # determine median color index
    cimd=$(grep -v "^#" $xphot | awk -v cci1=$colci1 -v cci2=$colci2 '{
        printf("%.3f", $cci1-$cci2)}' | median)
    test "${verbose}${AI_DEBUG}" && echo "# cimd = $cimd"
    
    # create plot title and gnuplot labels
    if [ -z "$title" ]
    then
        case $type in
            mag)
                title="Photometric error, $set, m_{ref}=${color}_{$catalog}"
                test "${apcval:0:1}" != "-" && title="${title}+"
                title="$title$apcval*(${apcind})_{$catalog}"
                x="set grid lc rgb '#808080'"
                x="$x; set ylabel 'mag - m_{ref}'"
                x="$x; set xlabel 'mag'"
                ;;
            color)
                title="Color term, $set, slope=$apcval"
                x="set grid lc rgb '#808080'"
                x="$x; set ylabel 'mag - ${color}_{$catalog}'"
                x="$x; set xlabel '(${apcind})_{$catalog}'"
                ;;
        esac
    fi
    
    # additional gnuplot commands
    test "$yrange" && x="$x; set yrange [$yrange]"
    test "$gpcmd" && x="$x; $gpcmd"
    test "$AI_DEBUG" && echo "# gpcmd=$x"
    
    # create plot data
    echo "# mag mobs $color$catalog $apcind $color\' dmag dmcol" > $tmpdat
    grep -v "^#" $xphot | awk -v type=$type -v mdiff=$magdiff -v slop=$apslop \
        -v cval=$apcval -v cimd=$cimd \
        -v cmag=$colmag -v ccat=$colcat -v cci1=$colci1 -v cci2=$colci2 '{
        cind=$cci1-$cci2
        mref=$ccat - cval*(cind)
        mobs=$cmag+mdiff
        dm=mobs-mref
        dmc=mobs-$ccat + cval*cimd
        printf("%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f\n",
            $cmag, mobs, $ccat, cind, mref, dm, dmc)
    }' >> $tmpdat
    case $type in
        mag)
            test -z "$outfile" && AIplot -p -t "$title" -g "$x" $tmpdat 2 6
            test    "$outfile" && AIplot -p -o $outfile -t "$title" -g "$x" $tmpdat 2 6
            ;;
        color)
            test -z "$outfile" && AIplot -p -t "$title" -g "$x" $tmpdat 4 7
            test    "$outfile" && AIplot -p -o $outfile -t "$title" -g "$x" $tmpdat 4 7
            ;;
    esac
    
    test "$AI_DEBUG" && echo $tmpdat && return
    rm $tmpdat
    return
}

phot2icq () {
    # convert photometry data (stored in header keywords) into icq format
    local showhelp
    local verbose   # show additional data
    local observer="OBSxx"
    test "$USER" == "lehmann" && observer="LEHaa"
    local method="Z"
    local sfwkey="AIT"  # ICQ Photometry Software Key for AIRTOOLS
    local calib=5       # 1-bias 4-bias/dark 5-bias/dark/flat
    local ccdinfo       # if set then show additional CCD info in ICQ record
    local i
    for i in 1 2 3 4 5
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-v" && verbose=1 && shift 1
        test "$1" == "-o" && observer=$2 && shift 2
        test "$1" == "-m" && method=$2 && shift 2
        test "$1" == "-c" && ccdinfo=1 && shift 1
    done
    local setname=${1:-""}
    local catalog=${2:-""}
    local sdat=${AI_SETS:-"set.dat"}
    local sname
    local ltime
    local type
    local nref
    local x
    local hdr
    local whdr
    local object
    local mjd
    local ut
    local texp
    local nexp
    local magzero
    local pixscale
    local rot
    local flen
    local fratio
    local tel
    local inst
    local cam
    local csum
    local ccorr
    local cglim
    local cdia
    local dtlen
    local dtang
    local ptlen
    local ptang
    local papcorr
    local pcref
    local paref
    
    local mag
    local cmag
    local dmag
    local mlim
    local xlist
    local aidx
    local pcat
    local ptail
    local val
    local str
    local site
    local camchip   # PDS/CAC-Pentax/APS-C CDS/CFC-Canon/FullFrame NDS-Nikon
                    # https://cobs.si/help?page=ccd_type https://cobs.si/help?page=ccd_chip
    
    test "$showhelp" &&
        echo -e "usage: phot2icq [-v] [-o observercode|$observer] [-m method|$method] " \
            "[-c] [setname] [catalog]" >&2 &&
        return 1

    while read ltime sname x type x x x nref x
    do
        (echo "$ltime" | grep -q "^#") && continue
        test "$type" != "o" && continue
        test "$setname" && test "$setname" != "$sname" && continue
        hdr=$sname.head
        test ! -e $hdr && echo "ERROR: header file $hdr not found." >&2 && continue
        whdr=$sname.wcs.head
        test ! -e $whdr && echo "ERROR: wcs header file $whdr not found." >&2 && continue

        # reading keywords
        object=$(get_header $hdr OBJECT | sed -e 's,^[ ]*,,; s,[ ]*$,,')
        test $? -ne 0 && echo "ERROR: no OBJECT in $hdr" >&2 && continue
        # check for AI_COMST which is indicative for a comet observation
        val=$(get_header -q $hdr AI_COMST)
        test -z "$val" &&
            (test "$setname" || test "$verbose") &&
            echo "# skipping $sname ($object), no AI_COMST keyword" >&2
        test -z "$val" && continue
        mjd=$(get_header -q $hdr JD_OBS)
        test -z "$mjd" && mjd=$(get_header -q $hdr MJD_OBS)
        test -z "$mjd" && mjd=$(get_header -q $hdr JD)
        test -z "$mjd" && echo "ERROR: no JD_OBS, MJD_OBS or JD in $hdr" >&2 && continue
        ut=$(jd2ut -p 2 $mjd)
        texp=$(get_header $hdr EXPTIME)
        test $? -ne 0 && echo "ERROR: no EXPTIME in $hdr" >&2 && continue
        nexp=$(get_header $hdr NEXP)
        test $? -ne 0 && echo "ERROR: no NEXP in $hdr" >&2 && continue
        magzero=$(get_header $hdr MAGZERO)
        test $? -ne 0 && echo "ERROR: no MAGZERO in $hdr" >&2 && continue

        # telescope, instrument, camera
        tel=$(get_header -q $hdr AI_TELID | sed -e 's,^[ ]*,,; s,[ ]*$,,')
        test $? -ne 0 && echo "ERROR: no AI_TELID in $hdr" >&2 && continue
        apert=$(AI_TELESCOPE=$tel  get_param camera.dat aperture xxx)
        fratio=$(AI_TELESCOPE=$tel get_param camera.dat fratio  xxx)
        ttype=$(AI_TELESCOPE=$tel  get_param camera.dat ttype   xxx)
        inst=$(echo $apert $ttype $fratio | awk '{printf("%04.1f%s %.0f", $1/10, $2, $3)}')
        
        # convert object name to icq notation
        test "${object: -1}" == "P" && object=$(printf "%3d" ${object:0:-1})
        is_integer $object   && object=$(printf "%3d        " $object)
        ! is_integer $object && object=$(printf "   %-8s" $object)

        pixscale=$(get_wcspscale $sname)
        rot=$(get_wcsrot $sname)
        #ticq=$(echo $texp | awk '{printf("%04.0f", $1)}' | sed -e 's/^0/a/' | sed -e \
        #    's/^1/A/; s/^2/B/; s/^3/C/; s/^4/D/; s/^5/E/; s/^6/F/; s/^7/G/')
        ticq=$(echo $texp | awk '{x=int(1*$1+0.5); sub(/...$/,"",x);
            s="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            if($1<1000){x=0; s="a"}
            printf("%s%03d\n", substr(s,x,1), $1-x*1000)}')
        #echo "texp=$texp  ticq=$ticq"

        
        # get comet photometry/tail keywords
        xlist=$(get_header $hdr all | grep "^AP_CMAG[1-9]=" | cut -c8 | sort -nu)
        if [ "$xlist" ]
        then
            for x in $xlist
            do
                pcat=$(get_header $hdr AP_PCAT$x)
                test "$catalog" && test "$pcat" != "$catalog" && continue
                case "$pcat" in
                    tycho2) refcat="TK";;
                    apass)  refcat="AQ";;
                    *)      refcat="--";;
                esac
                mag=$(get_header  $hdr AP_CMAG$x | awk '{printf("%4.1f", $1+$2)}')
                mlim=$(get_header $hdr AP_MLIM$x | awk '{printf("%.1f", $1+$2)}')
                #test -z "$mlim" && mlim="    "
                
                aidx=$(get_header $hdr AP_AIDX$x)
                test -z "$aidx" &&
                    echo "ERROR: missing AP_AIDX$x, skipping $sname ($pcat)" >&2 &&
                    continue
                cdia=$(get_header $hdr AC_DIAM$aidx)
                
                dtlen=$(get_header -q $hdr AI_DLEN)
                dtang=$(get_header -q $hdr AI_DANG)
                ptlen=$(get_header -q $hdr AI_PLEN)
                ptang=$(get_header -q $hdr AI_PANG)
                
                # convert coma diameter and tail parameter
                coma="    "; tail="         "; pa="   "; ptail=""
                is_number "$cdia"  && coma=$(echo $cdia $pixscale | \
                    awk '{x=$1*$2/60; fmt="%4.1f"
                        if (x>10) {fmt="%2.0f  "}
                        printf(fmt, x)}')
                is_number "$dtlen" && tail=$(echo $dtlen $pixscale | tr -d '>' | \
                    awk '{if($1=="-") {print $1} else {printf("%9.2f", $1*$2/3600)}}')
                is_number "$dtang" && pa=$(echo $dtang $rot | \
                    awk '{if($1=="-") {print $1} else {printf("%3.0f", ($1-90+$2+720)%360)}}')
                is_number "$ptlen" && ptail=$(echo $ptlen $pixscale | tr -d '>' | \
                    awk '{printf("plasma tail %.2f deg", $1*$2/3600)}')
                is_number "$ptang" && ptail=$(echo $ptang $rot | \
                    awk -v p="$ptail" '{printf("%s at pa=%.0f", p, ($1-90+$2+720)%360)}')

                if [ "$verbose" ]
                then
                    str="$pcat/"$(get_header -q $hdr AP_PCOL$x)":"
                    val=$(get_header -q $hdr AP_MZER$x)
                    test "$val" && str=$str" mzero=$val"
                    val=$(get_header -q $hdr AP_NFIT$x)
                    test "$val" && str=$str" nstar=$val"
                    val=$(get_header -q $hdr AP_MRMS$x)
                    test "$val" && str=$str" rms=$val"
                    val=$(get_header -q $hdr AI_MOALT | grep -v "^-")
                    test "$val" &&
                        val=$(echo $(get_header -q -s $hdr AI_MOP,AI_MOD,AI_MOALT) | tr ' ' '/') &&
                        str=$str" moon=$val"
                    val=$(get_header -q $hdr AI_COALT)
                    test "$val" && str=$str" alt=$val"
                    val=$(get_header -q $hdr AP_CMAG$x)
                    test "$val" && str=$str" m1=$val"
                    echo "# $str d=${coma// /}'"
                fi

                # camera info
                cam=$(AI_TELESCOPE=$tel    get_param camera.dat ctype   xxx)
                filt=$(get_header $hdr AC_ICOL$aidx)
                if [ "$cam" == "DSLR" ]
                then
                    test "$filt" == "R" && cam="$cam red"
                    test "$filt" == "G" && cam="$cam green"
                    test "$filt" == "B" && cam="$cam blue"
                else
                    cam="$cam/"$filt
                fi
                
                site=$(get_header $hdr AI_SITE)
                case "$site" in
                    Mayhill|SSO|Nerpio) cam="$cam remote ($site)";;
                esac

                # create additional ccd information
                # ref.: https://cobs.si/help?page=icq_format
                _icqformatccd="
f InT APERTURcamchip SFW C ## u.uu xx.x PIXELSIZE       guideline
         9        10        11        12        13
123456789 123456789 123456789 123456789 123456789 123456789  
"
                if [ "${ccdinfo// /}" ]
                then
                    camchip=$(AI_TELESCOPE=$tel get_param camera.dat camchip xxx)
                    test "$camchip" == "-" && camchip=""
                    str=$(LANG=C printf "%4.1fs%4.1f" $pixscale $pixscale)
                    ccdinfo=$(LANG=C printf "I     C%5.2fm%-7s %-3s %1s %12s %9s" $coma "${camchip/[,_\/]/ }" $sfwkey $calib "" "$str")
                else
                    ccdinfo="      "
                fi

                # show results
                str=$(printf "%-5s%s" $observer "$ccdinfo")
                test "$mlim" && str="$str mlim=$mlim,"
                echo "$object${ut//-/ }  $method $mag $refcat $inst$ticq " \
                     "$coma $tail $pa        $str $cam" $ptail
            done
        else
            # old keywords, AI_VERSION<2.7
        
            # reference catalog abbreviation
            pcat=$(get_header $hdr AI_PCAT)
            test $? -ne 0 && echo "ERROR: no AI_PCAT in $hdr" >&2 && continue
            case $pcat in
                tycho2) refcat="TK";;
                apass)  refcat="AQ";;
                *)      refcat="--";;
            esac

            # photometry
            csum=$(get_header $hdr AI_CSUM)
            test $? -ne 0 && echo "ERROR: no AI_CSUM in $hdr" >&2 && continue
            ccorr=$(get_header $hdr AI_CCORR)
            test $? -ne 0 && echo "ERROR: no AI_CCORR in $hdr" >&2 && continue
            papcorr=$(get_header $hdr AI_PAPCO)
            test $? -ne 0 && echo "ERROR: no AI_PAPCO in $hdr" >&2 && continue
            pcref=$(get_header $hdr AI_PCREF)
            test $? -ne 0 && echo "ERROR: no AI_PCREF in $hdr" >&2 && continue
            paref=$(get_header $hdr AI_PAREF)
            test $? -ne 0 && echo "ERROR: no AI_PAREF in $hdr" >&2 && continue
            cglim=$(get_header $hdr AI_CGLIM)
            test $? -ne 0 && echo "ERROR: no AI_CGLIM in $hdr" >&2 && continue
        
            cmag=$(i2mag $(echo $csum $ccorr | awk '{print $1+$2}') $texp $magzero)
            dmag=$(echo $pcref $paref $papcorr | awk '{printf("%.2f", $1-$2-$3)}')
            mag=$(echo $cmag $dmag | awk '{printf("%4.1f", $1+$2)}')
            cmag=$(echo $cmag  $dmag | awk '{printf("%5.2f", $1+$2)}')
            mlim=$(i2mag $cglim $texp $magzero | awk -v dm=$dmag '{printf("%.1f", $1+dm)}')
            echo "# $sname:  mlim=$mlim  dmag=$dmag  mag=$cmag" >&2
        
            # coma diameter and tail parameter
            cdia=$(get_header $hdr AI_CDIA)
            test $? -ne 0 && echo "ERROR: no AI_CDIA in $hdr" >&2 && continue
            dtlen=$(get_header $hdr AI_CTLEN)
            test $? -ne 0 && echo "ERROR: no AI_CTLEN in $hdr" >&2 && continue
            dtang=$(get_header $hdr AI_CTANG)
            test $? -ne 0 && echo "ERROR: no AI_CTANG in $hdr" >&2 && continue

            # convert coma diameter and tail parameter
            coma="    "; tail="         "; pa="   "
            is_number "$cdia"  && coma=$(echo $cdia $pixscale | \
                awk '{x=$1*$2/60; fmt="%4.1f"
                    if (x> 2 && x<= 4) {x=sprintf("%.0f", 5*x);   x=x/5} 
                    if (x> 4 && x<=10) {x=sprintf("%.0f", 2*x);
                                      if(x%2==0) {fmt="%2.0f  "}; x=x/2} 
                    if (x>10) {fmt="%2.0f  "}
                    if (x>20 && x<=40) {x=sprintf("%.0f", 0.5*x); x=x/0.5} 
                    if (x>40)          {x=sprintf("%.0f", 0.2*x); x=x/0.2} 
                    printf(fmt, x)}')
            is_number "$dtlen" && tail=$(echo $dtlen $pixscale | tr -d '>' | \
                awk '{if($1=="-") {print $1} else {printf("%9.2f", $1*$2/3600)}}')
            is_number "$dtang" && pa=$(echo $dtang $rot | \
                awk '{if($1=="-") {print $1} else {printf("%3.0f", ($1-90+$2+720)%360)}}')
            
            # show results
            str=$(printf "%-8s" $observer)
            echo "$object${ut//-/ }  C $mag $refcat $inst$ticq " \
                 "$coma $tail $pa        $str    $mlim  $cam"
        fi
    done < $sdat
}

icqsort () {
    # sort observations in icq format for submission to FGK
    local showhelp
    local sortopts
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-r" && sortopts="-r" && shift 1
    done
    local dat=$1
    local tchars=12-24  # characters defining date and time
    local tmpdat=$(mktemp "/tmp/tmp_dat_$$.XXXXXX.dat")
    local tmpkey=$(mktemp "/tmp/tmp_key_$$.XXXXXX.dat")
    
    (test "$showhelp" || test $# -ne 1) &&
        echo -e "usage: icqsort [-h] [-r] <fullicqfile>" >&2 &&
        return 1
    local lnum
    
    grep "[0-9]" $dat | grep -v "^#" | grep -n "." > $tmpdat
    grep "[0-9]" $dat | grep -v "^#" | cut -c $tchars | grep -n "." > $tmpkey
    cat $tmpkey | LANG=C sort $sortopts -t ":" -k2,99 | cut -d ":" -f1 | while read lnum
    do
        grep "^$lnum:" $tmpdat | cut -d ":" -f2-
    done | LANG=C sort -s -t "|" -k1.1,1.11
    rm -f $tmpdat $tmpkey
}

fullicq2web () {
    # convert from full icq data format to short web format
    # short: UT to 0.01 day, chronolog. order
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1

    local dat=$1  # data file containing full format icq data
    local obs="T. Lehmann, Weimar, Germany"
    local clist
    local c
    local cc
    
    (test "$showhelp" || test $# -ne 1) &&
        echo -e "usage: fullicq2web [-h] <fullicqfile>" >&2 &&
        return 1
    
    test ! -f "$dat" && echo "ERROR: data file $dat not found." && return 255

    # get list of comets
    clist=$(grep -v "^#" $dat | cut -c 1-11 | sort -u | sort -n)
    for c in $clist
    do
        test ${#c} -gt 3 && cc="C/${c:0:4} ${c:4:4}" && cs="   $c"
        test ${#c} -le 3 && cc="$c"P && cs=$(printf "%3d " $c)
        echo "COMET $cc"
        grep -v unpublished $dat | grep "^$cs" | awk -v o="$obs" 'BEGIN{
            split("Jan._Feb._Mar._Apr._May_June_July_Aug._Sep._Oct._Nov._Dec.", ma, "_")}{
            y=substr($0,12,4)
            m=substr($0,17,2)
            d=substr($0,20,5)
            mag=substr($0,28,6); gsub(/^[ \t]+/, "", mag); gsub(/[ \t]+$/, "", mag)
            co=substr($0,49,6);  gsub(/^[ \t]+/, "", co); gsub(/[ \t]+$/, "", co)
            if (length(co) == 0) {
                co="--"
            } else {
                if (index(co, ".") > 0) {
                    gsub(/\./, "\047.", co)
                } else {
                    co=co"\047"; gsub(/:\047/, "\047:", co)
                }
            }
            aa=substr($0,36,5)
            t=substr($0,41,1)
            inst="#### UNKNOWN INSTRUMENT ####"
            if (t == "L") inst=sprintf("%.2f-m reflector", aa/100)
            if (t == "A") inst=sprintf("%.0f-cm telephoto lens", aa)
            if (t == "R") inst=sprintf("%.0f-cm refractor", aa)
            if (t == "B") inst=sprintf("%.0f-cm binoculars", aa)
            notes=substr($0,94,100); gsub(/^[ \t]+/, "", notes); gsub(/[ \t]+$/, "", notes)
            if (length(notes) > 0) {
                sub("DSLR green", "CCD via DSLR green", notes)
                sub("CCD/V", "CCD + V filter", notes)
                sub("CCD/G", "CCD + G filter", notes)
                sub(/ remote .Mayhill./, ", remotely from Mayhill, NM, USA", notes)
                sub(/ remote .SSO./,     ", remotely from Siding Spring Obs., Australia", notes)
                sub(/ remote .Nerpio./,  ", remotely from Nerpio, Spain", notes)
                notes=" + "notes
            }
            if (y != lasty) print y
            printf("%4s %5.2f, %s, %s (%s, %s%s);\n", ma[1*m], d, mag, co, o, inst, notes)
            lasty=y
        }'
        echo ""
    done
}

comet_lightcurve () {
    # create comet lightcurve from icq formatted observations data file
    # format of photometric data records: <utday>,<mag>,<coma>
    #   e.g. 20140910.75,13.8,1.6
    local showhelp
    local i
    local title     # plot title, e.g. "C/2014 Q2 (Lovejoy)  2014 - 2015"
    local fsizeadd=0    # additive correction to default font size
    local mpcparam  # use this set of model parameters for MPC curve, format: <g>,<k> e.g. 8.5,4
    local newparam  # if set, plot additional model curve, format: <g>,<k>
    local keypos="top left reverse Left invert" # e.g. "bottom right"
    local kwidthadd=0   # additive correction to key area width
    local do_big    # if set create large plot
    local size="6.5,4.5"  # w,h page size of output file (inches)
    local do_update # if set download new elements (MPCORB), ICQ and FGK observations
    local xrange    # date range
    local yrange    # mag range
    local do_all_data   # plot all data, do not limit to interval from obsdat
    local visdb="cobs"  # comma separated list of visual observations databases
                        # known databases are cobs, icq, fgk
    local do_plot_distance  # overplot solar distance
    local otherdat  # additional photometry data file: yyyymmdd.dd,mag
    local otherdesc
    local obs="mag"
    local color
    local ptsize
    local days
    local peri
    local startymd
    local x
    for i in $(seq 1 18)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-t" && title="$2"     && shift 2
        test "$1" == "-f" && fsizeadd="$2"  && shift 2
        test "$1" == "-m" && mpcparam="$2"  && shift 2
        test "$1" == "-n" && newparam="$2"  && shift 2
        test "$1" == "-k" && keypos="$2"    && shift 2
        test "$1" == "-w" && kwidthadd="$2" && shift 2
        test "$1" == "-x" && xrange="$2"    && shift 2
        test "$1" == "-y" && yrange="$2"    && shift 2
        test "$1" == "-b" && do_big=1       && shift 1
        test "$1" == "-l" && size="$2"      && shift 2
        test "$1" == "-u" && do_update=1    && shift 1
        test "$1" == "-p" && obs="pa"       && shift 1
        test "$1" == "-c" && obs="coma"     && shift 1
        test "$1" == "-a" && do_all_data=1  && shift 1
        test "$1" == "-v" && visdb="$2"     && shift 2
        test "$1" == "-d" && do_plot_distance=1 && shift 1
        test "$1" == "-o" && otherdat=${2/,*/} && otherdesc=${2#*,} && shift 2
    done
    
    local comet=$1
    local obsdat=$2     # containing records in ICQ data format
    local dslrdesc=${3:-"DSLR/G (T. Lehmann)"}
    local ccddesc=${4:-"CCD/G (T. Lehmann)"}
    local visdesc
    local mpcorburl="http://www.minorplanetcenter.net/iau/MPCORB/CometEls.txt"
    local icqobsurl="http://www.icq.eps.harvard.edu/CometMags.html"
    local fgkobsurl="http://kometen.fg-vds.de/fgicq.zip"
    local fgkobsurl2="http://kometen.fg-vds.de/older_fgicq.zip"
    local outfile
    local cname
    local n
    local latest
    local dhr=0
    local mpcorb
    local date
    local endymd
    local d
    local r
    local mag
    local coma
    local retval
    local size
    local fsize
    local plotcmd
    local incr
    local xticsfmt
    local drange
    local dinter
    local docviewer
    local ocol
    local interval
    
    local tmp1=$(mktemp "/tmp/tmp_tmp1_$$.XXXXXX.dat")
    local tmpcobs=$(mktemp "/tmp/tmp_cobs_$$.XXXXXX.dat")
    local tmpobs=$(mktemp "/tmp/tmp_obs_$$.XXXXXX.dat")
    local tmpmpc=$(mktemp "/tmp/tmp_mpc_$$.XXXXXX.dat")
    local tmpgp=$(mktemp "/tmp/tmp_gp_$$.XXXXXX.gp")


    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: comet_lightcurve [-h] [-u] [-b | -l w,h|$size] [-v visdb|$visdb] [-d] [-a] [-t <plottitle>] [-m <mpc_g,k,desc>]" \
            "[-n <new_g,k,desc>] [-f <fontsize-add>] [-k <keypos>] [-w <keywidth-add>]" \
            "[-x start_YYYYMMDD:end_YYYYMMDD] [-y ymin:ymax] <comet> <obsdat>" \
            "[dslrlabel|$dslrdesc] [ccdlabel|$ccddesc]" >&2 &&
        return 1
    
    test ! -f "$obsdat" && echo "ERROR: observations data file $obsdat not found." >&2 && return 255
    test "$obs" != "mag" && mpcparam=0 && newparam=""
    test "$xrange" && test "$xrange" == "${xrange/:/}" && xrange=$xrange":"


    # -------------------------
    # process own observations
    # -------------------------
    cname=${comet%P}
    grep "^[ ]*$cname[ ]*[0-9][0-9][0-9][0-9] " $obsdat | awk -v o=$obs '{
        date=substr($0,12,4)""substr($0,17,2)""substr($0,20,5); gsub(/ /,"0",date)
        method=substr($0,27,1)
        #if (method == "Z") next
        if (substr($0,28,1) == "[") next
        mag=substr($0,29,5);  gsub(/ /,"",mag)
        coma=substr($0,49,6); gsub(/ /,"",coma); if (coma=="") coma=-1
        pa=substr($0,65,3); gsub(/ /,"",pa);    if (pa=="") pa=-1
        obs=substr($0,76,10); gsub(/ /,"",obs)
        if (substr($0,88) ~ /CCD/) {
            printf("ccd,%s,%s,%s,%s,%s,%s\n", method, date, mag, coma, pa, obs)
        } else {
            printf("dslr,%s,%s,%s,%s,%s,%s\n", method, date, mag, coma, pa, obs)
        }
    }' > $tmpobs
    if [ ! -s $tmpobs ]
    then
        echo "WARNING: no observation records found for comet $cname." >&2
    else
        n=$(grep "^dslr," $tmpobs | wc -l)
        test $n -gt 0 && printf "# %4s %4d\n" "DSLR" $n
        n=$(grep "^ccd," $tmpobs | wc -l)
        test $n -gt 0 && printf "# %4s %4d\n" "CCD" $n
    fi


    # --------------------------------------------------
    # retrieve data from visual observations databases
    # --------------------------------------------------
    cname=${comet%P}
    is_number "$cname" && cname="${cname}P"
    latest="latest.$cname.dat"
    test -f "$latest" &&
        dhr=$(echo $(date +'%s') $(stat -c '%Y' $latest) | \
            awk '{printf("%.0f", ($1-$2)/3600)}')
     
    
    # process observations from COBS (ICQ format)
    if echo $visdb | grep -qw cobs
    then
        n=0
        if [ -f "$latest" ] && [ $dhr -lt 24 ]
        then
            grep "^cobs," $latest > $tmp1
            n=$(cat $tmp1 | wc -l)
            test $n -gt 0 && printf "# %4s %4d  %s\n" "COBS" $n "($latest)"
        fi
        if [ $n -eq 0 ]
        then
            get_cobs $cname > $tmpcobs
            if [ ! -s $tmpcobs ]
            then
                echo "WARNING: no COBS observations." >&2
            else
                cname=${comet%P}
                grep "^[ ]*$cname[ ]*[0-9][0-9][0-9][0-9] " $tmpcobs | awk -v o=$obs '{
                    date=substr($0,12,4)""substr($0,17,2)""substr($0,20,5); gsub(/ /,"0",date)
                    method=substr($0,27,1)
                    if (method == "Z") next
                    if (substr($0,28,1) == "[") next
                    mag=substr($0,29,5);  gsub(/ /,"",mag)
                    coma=substr($0,49,6); gsub(/ /,"",coma); if (coma=="") coma=-1
                    pa=substr($0,65,3); gsub(/ /,"",pa);    if (pa=="") pa=-1
                    obs=substr($0,76,10); gsub(/ /,"",obs)
                    
                    printf("cobs,%s,%s,%s,%s,%s,%s\n", method, date, mag, coma, pa, obs)
                }' > $tmp1
                n=$(cat $tmp1 | wc -l)
                printf "# %4s %4d\n" "COBS" $n
            fi
        fi
        test $n -gt 0 && cat $tmp1 >> $tmpobs
    fi


    # download latest ICQ comet magnitudes (web data)
    cname="$comet"
    is_number ${comet%P} && cname=$(printf "%04gP" ${comet%P})
    if echo $visdb | grep -qw icq
    then
        n=0
        if [ -f "$latest" ] && [ $dhr -lt 120 ]
        then
            grep "^icq," $latest > $tmp1
            n=$(cat $tmp1 | wc -l)
            test $n -gt 0 && printf "# %4s %4d  %s\n" "ICQ" $n "($latest)"
        fi
        if [ $n -eq 0 ]
        then
            (test ! -f CometMags.html || test "$do_update") &&
                rm -f CometMags.html &&
                wget -nH $icqobsurl
            cat CometMags.html | awk -v c="$cname" -v o=$obs 'BEGIN{
                cpat="^<a name=\""c"\""
            }{
                if ($0~cpat) {found=1; y=0; m=0; d=0; next}
                if (found==1 && $0~/^<a name=/) found=0
                if (found==1) {
                    if ($1~/^Total/) next
                    if ($1~/<b>[0-9][0-9][0-9][0-9]<\/b>/) {
                        gsub(/[^0-9]/,"",$1); y=$1; next
                    }
                    if ($1 ~ /^[A-Z]/) {
                        ismonth=0
                        if ($1 == "Jan.") {m=1; ismonth=1}
                        if ($1 == "Feb.") {m=2; ismonth=1}
                        if ($1 == "Mar.") {m=3; ismonth=1}
                        if ($1 == "Apr.") {m=4; ismonth=1}
                        if ($1 == "May")  {m=5; ismonth=1}
                        if ($1 == "June") {m=6; ismonth=1}
                        if ($1 == "July") {m=7; ismonth=1}
                        if ($1 == "Aug.") {m=8; ismonth=1}
                        if ($1 == "Sep.") {m=9; ismonth=1}
                        if ($1 == "Oct.") {m=10; ismonth=1}
                        if ($1 == "Nov.") {m=11; ismonth=1}
                        if ($1 == "Dec.") {m=12; ismonth=1}
                        if (ismonth==0) {
                            printf("# %s\n", $0); next
                        } else {
                            d=$2; sub(/,$/,"",d)
                        }
                    } else {
                        d=$1; sub(/,$/,"",d)
                    }
                    split($0,a,",")
                    mag=a[2];  gsub(/ /,"",mag)
                    coma=a[3]; gsub(/[\047 ]/,"",coma); gsub(/\(.*/,"",coma)
                    method="S"
                    if ($0 ~ /CCD/) method="C"
                    if (o=="mag" && substr(mag,1,1) ~ /\[/) next
                    if (NF>=3) {
                        printf("icq,%s,%4d%02d%05.2f,%s,%s,-1 # %s\n", method, y, m, d, mag, coma, $0)
                    }
                }
            }' > $tmp1
            #'
            n=$(cat $tmp1 | wc -l)
            printf "# %4s %4d\n" "ICQ" $n
        fi
        test $n -gt 0 && cat $tmp1 >> $tmpobs
    fi


    # download observations from FG Kometen (ICQ format)
    cname=${comet%P}
    if echo $visdb | grep -qw fgk
    then
        if [ "$do_update" ]
        then
            rm -f fgk.icq
            wget $fgkobsurl -O $tmp1
            unzip -p $tmp1 > fgk.icq
            wget $fgkobsurl2 -O $tmp1
            unzip -p $tmp1 >> fgk.icq
        fi
        if [ -s fgk.icq ]
        then
            grep "^[ ]*$cname[ ]*[0-9][0-9][0-9][0-9] " fgk.icq | awk '{
                date=substr($0,12,4)""substr($0,17,2)""substr($0,20,5); gsub(/ /,"0",date)
                method=substr($0,27,1); sub(/[ -]/,"S",method)
                if (method == "Z") next
                if (substr($0,28,1) == "[") next
                mag=substr($0,29,5);  gsub(/ /,"",mag)
                coma=substr($0,49,6); gsub(/ /,"",coma); if (coma=="") coma=-1
                pa=substr($0,65,3); gsub(/ /,"",pa);    if (pa=="") pa=-1
                obs=substr($0,76,10); gsub(/ /,"",obs)

                printf("fgk,%s,%s,%s,%s,%s,%s\n", method, date, mag, coma, pa, obs)
            }' > $tmp1
            n=$(cat $tmp1 | wc -l)
            printf "# %4s %4d\n" "FGK" $n
            cat $tmp1 >> $tmpobs
        fi
    fi
    
    # save all observations
    cp $tmpobs $latest
    
    # select observations according to type
    cat $latest | 
    grep -v "^#" $latest | awk -F ',' -v o=$obs '{
        if (o=="mag"  && $4>=0) print $0
        if (o=="coma" && $5>=0) print $0
        if (o=="pa"   && $6>=0) print $0
    }' > $tmpobs
    
    
    # ------------------------------
    # determine time range for plot
    # ------------------------------
    
    # determine startymd, endymd and number of days
    if [ "$do_all_data" ]
    then
        startymd=$(grep -v "^#" $tmpobs | \
            LANG=C sort -t ',' -k3,3 | head -1 | awk -F ',' '{printf("%d", int($3))}')
        endymd=$(grep -v "^#" $tmpobs | \
            LANG=C sort -t ',' -k3,3 | tail -1 | awk -F ',' '{printf("%d", int($3)+1)}')
    else
        startymd=$(grep -E "^dslr,|^ccd," $tmpobs | \
            LANG=C sort -t ',' -k3,3 | head -1 | awk -F ',' '{printf("%d", int($3))}')
        endymd=$(grep -E "^dslr,|^ccd," $tmpobs | \
            LANG=C sort -t ',' -k3,3 | tail -1 | awk -F ',' '{printf("%d", int($3)+1)}')
    fi
    if [ -z "$startymd" ]
    then
        echo "WARNING: no observations data to plot." >&2
        startymd=$(date -d 'now - 2 month' '+%Y%m%d')
        endymd=$(date -d 'now + 4 month' '+%Y%m%d')
    fi
    days=$(echo "$(ut2jd 12 ${endymd}) - $(ut2jd 12 ${startymd}) + 1" | bc | cut -d "." -f1)
    echo "# start=$startymd  end=$endymd  days=$days" >&2
    
    # apply x-axis range
    if [ "$xrange" ]
    then
        test "${xrange%:*}" && startymd=${xrange%:*}
        test "${xrange#*:}" && endymd=${xrange#*:}
        days=$(echo "$(ut2jd 12 ${endymd}) - $(ut2jd 12 ${startymd}) + 1" | bc | cut -d "." -f1)
        # add some margin around xrange
        xrange=$(echo $xrange | awk -v d=$days '{
            split($1,a,/:/)
            if (a[1]!="") {
                str=substr(a[1],1,4)" "substr(a[1],5,2)" "substr(a[1],7,2)" 0 0 0"
                x=strftime("\"%Y%m%d\"", mktime(str)-d/20*24*3600)
            }
            if (a[2]!="") {
                str=substr(a[2],1,4)" "substr(a[2],5,2)" "substr(a[2],7,2)" 0 0 0"
                y=strftime("\"%Y%m%d\"", mktime(str)+d/20*24*3600)
            }
            printf("%s:%s", x, y)
        }')
        echo "# using xrange:  start=$startymd  end=$endymd  days=$days" >&2
        echo "# xrange: $xrange" >&2
    fi

    # code source of observation and apply time range
    grep -v "^#" $latest | awk -F ',' -v a=$startymd -v b=$endymd '{
            src=0
            if ($1=="dslr") src=1
            if ($1=="ccd")  src=2
            if ($1=="cobs") src=3
            if ($1=="icq")  src=4
            if ($1=="fgk")  src=5
            if (src>2 && $2!~/^[BEIMOSZ-]$/) src=src+10  # CCD observation, not vis. equivalent
            # limit time range
            if ($3>=a && $3<=b) printf("%s,%s,%s,%s,%s,%s\n", $1, src, $2, $3, $4, $5)
        }' > $tmpobs
    n=$(cat $tmpobs | wc -l)
    echo "# using $n/$(grep -v "^#" $latest | wc -l) observations of type $obs" >&2


    # ---------------------------------
    # create ephemerides from MPC data
    # ---------------------------------
    
    # download MPCORB data
    cname=${comet%P}
    (test ! -f CometEls.txt || test "$do_update") &&
        rm -f CometEls.txt &&
        wget -nH $mpcorburl
    mpcorb=$(cat CometEls.txt | awk -v c="$cname" 'BEGIN{
        if (c~/^[0-9]{4}[A-Z]/) {
            cpat="^C/"substr(c,1,4)" "substr(c,5)" "
        } else {
            cpat="^"c"P/"
        }
        }{
        cname=substr($0,103,57)
        if (cname ~ cpat) {
            sub(/[ ]*$/,"",cname)
            peri=substr($0,15,14); gsub(/ /,"",peri)
            m0=substr($0,92,4)
            slope=substr($0,97,4)
            ref=substr($0,160); sub(/[ ]*$/,"",ref)
            printf("%s,%s,%.1f,%.1f,%s\n", cname, peri, m0, slope, ref)
        }
        }')
    test -z "$mpcorb" &&
        echo "ERROR: comet not found in CometEls.txt (try -u switch?)." >&2 && return 255
    test "$AI_DEBUG" && echo "mpcorb=$mpcorb" >&2

    # set title if empty
    test "$comet" == "${comet//[A-Z]/}" && comet=$comet"P"
    if [ ! "$title" ]
    then
        title=${mpcorb%%,*}"  - "
        test "$obs" == "mag"  && title="$title Light Curve"
        test "$obs" == "coma" && title="$title Coma Diameter"
        test "$obs" == "pa"   && title="$title Tail PA"
        title="$title ${startymd:0:4}"
        test ${startymd:0:4} -ne ${endymd:0:4} && title="$title - ${endymd:0:4}"
    fi
    # set parameters of model curves
    test -z "$mpcparam" &&
        mpcparam=$(echo $mpcorb | awk -F "," '{print $3","$4",Model ("$5")"}')
    test "$newparam" &&
        test -z "$(echo $newparam | cut -d ',' -f3)" &&
        newparam="$newparam,m = ${newparam%,*} + 5log(D) + ${newparam#*,} x 2.5log(r)"
    echo "# title=$title" >&2
    echo "# mpcparam=$mpcparam" >&2
    test "$newparam" && echo "# newparam=$newparam" >&2
    # get time of perihel
    peri=$(echo $mpcorb | awk -F "," '{print $2}')
    
    # download and process MPC ephemerides
    cname="$comet"
    is_number ${comet%P} && cname="${comet%P}P"
    interval=24
    test $days -gt 1000 && interval=48
    test $days -gt 2000 && interval=96
    test $days -gt 5000 && interval=240
    echo "# running: get_mpcephem -n $((days*24/interval+1)) -i $interval $cname $startymd 0" >&2
    AI_SITE="" get_mpcephem -n $((days*24/interval+1)) -i $interval $cname $startymd 0 > $tmp1 2>/dev/null
    test $? -ne 0 &&
        echo "ERROR during get_mpcephem" >&2 &&
        return 255

    grep -v "^#" $tmp1 | while read
    do
        test "${REPLY:0:1}" == "#" && continue
        date="${REPLY:0:4}${REPLY:5:2}${REPLY:8:2}"
        d="${REPLY:40:6}"
        r="${REPLY:48:6}"
        mag="${REPLY:69:4}"
        echo "$date,$d,$r,$mag"
    done > $tmpmpc
    test "$AI_DEBUG" && wc -l $tmpmpc >&2
    # determine distance range
    drange=$(LANG=C sort -n -t ',' $tmpmpc -k3,3 | awk -F ',' '{
        if(NR==1) x=$3} END {y=$3; m=(y-x)/10; printf("%f:%f", x-m, y+m)}')
    dinter=$(echo $drange | awk -F ':' '{dr=$2-$1; x=0.1
        if(dr>0.6)  x=0.2
        if (dr>1.5) x=0.5
        if (dr>3)   x=1
        print x}')
    echo "# drange=$drange  dinter=$dinter" >&2
    
    
    # -----------------------------
    # plotting
    # -----------------------------
    
    # gnuplot
    # pngcairo:
    #outfile=$comet.$obs.$(date +'%y%m%d').png
    #size="700,480"; fsize=11
    #test "$do_big" && size="900,600"; fsize=12
    # postscript:
    outfile=$comet.$obs.$(date +'%y%m%d').eps
    #test "$do_big" && size="7,4.9"
    #size="6.5,4.5"
    fsize=$(echo ${size#,*} $fsizeadd | awk '{printf("%.0f", $1*1.6+10+$2)}')
    cat <<EOF > $tmpgp
#set term pngcairo size $size font "Arial,$fsize" enhanced
set term postscript size $size font ",$fsize" enhanced eps color blacktext dashlength 2.5
set output "$outfile"
set border lw 1
set xtics nomirror
set ytics nomirror
set grid lc rgb '#808080'
#set key $keypos samplen 1 spacing 1.0 font "Arial,$((fsize-2))"
set key ${keypos//_/ } height +0.5 width ${kwidthadd//_/ } samplen 1 spacing 1.2 font ",$((fsize-2))"

set datafile separator ","
set xdata time
set timefmt "%Y%m%d"
set title '${title//_/ }' font ",$((fsize+4))"
set xlabel 'Date'
set arrow from '$peri', graph 0.98 to '$peri', graph 1 nohead
set label "P" at '$peri', graph 0.95 center
EOF

    # set xrange
    test "$xrange" && echo "set xrange [$xrange]" >> $tmpgp

    # set yrange, obscolumn
    case $obs in
        mag)    ocol=5
                echo "set yrange [$yrange] reverse" >> $tmpgp
                echo "set ylabel 'mag' offset 1" >> $tmpgp
                ;;
        pa)     ocol=5
                echo "set yrange [$yrange]" >> $tmpgp
                echo "set ylabel 'degrees' offset 1" >> $tmpgp
                ;;
        coma)   ocol=6
                echo "set yrange [$yrange]" >> $tmpgp
                echo "set ylabel 'arcmin' offset 1" >> $tmpgp
                ;;
    esac
    
    # set xtics "20110105", 1209600, "20110430"  # interval in seconds
    # 1 month = 365.2425/12 days
    incr=$(echo $days | awk -v y=365.2425 '{
        x=$1/5; d=0
        if (x<450) d=y
        if (x<250) d=y/2
        if (x<150) d=4*y/12
        if (x<100) d=3*y/12
        if (x<75)  d=2*y/12
        if (x<45)  d=y/12
        if (x<22)  d=14
        if (x<11)  d=7
        if (x<6.0) d=5
        if (x<3.5) d=2
        if (x<1.5) d=1
        if (d>0) printf("%.1f", d)}')
    xticsfmt="%Y"
    if [ "$incr" ]
    then
        echo "# incr=$incr" >&2
        test ${incr%.*} -lt 300 && xticsfmt="%b \'%y"
        #'
        test ${incr%.*} -lt  70 && xticsfmt="%b"
        test ${incr%.*} -lt  20 && xticsfmt="%b %d"
        if [ ${incr%.*} -lt 150 ] && [ ${incr%.*} -gt 20 ]
        then
            # start tics at beginning of month
            incr=$(echo $incr | awk -v s=$startymd '{
                a=int(s/100)*100+1
                printf("\"%d\",%d", a, $1*24*3600)}')
        else 
            incr=$(echo $incr | awk '{
                printf("%d", $1*24*3600)}')
        fi
    fi
    echo "# set xtics $incr format \"$xticsfmt\"" >&2
    echo "set xtics $incr format \"$xticsfmt\"" >> $tmpgp
    
    test "$mpcparam" && test "$mpcparam" != "0" && (cat <<EOF >> $tmpgp
gmpc='$(echo $mpcparam | cut -d ',' -f1)'
kmpc='$(echo $mpcparam | cut -d ',' -f2)'
tmpc='$(echo $mpcparam | cut -d ',' -f3-)'
EOF
)
    test "$newparam" && (cat <<EOF >> $tmpgp
gnew='$(echo $newparam | cut -d ',' -f1)'
knew='$(echo $newparam | cut -d ',' -f2)'
tnew='$(echo $newparam | cut -d ',' -f3-)'
EOF
)

    # plotting solar distance
    plotcmd="plot"
    test "$do_plot_distance" && (cat << EOF >> $tmpgp
set y2range [$drange]
set y2label 'r_{sun} / AU' offset -1
set y2tics $dinter
$plotcmd '$tmpmpc'  using 1:(\$1>$startymd && \$1<=$endymd ? \$3 : 1/0) \\
        title 'Heliocentric Distance' lw 2 lc rgb '#D07010' lt 3 with lines axes x1y2 \\
EOF
) && plotcmd="    ,"

    
    # MPC model data
    if [ "$mpcparam" ] && [ "$mpcparam" != "0" ]
    then
        cat <<EOF >> $tmpgp
$plotcmd '$tmpmpc'  using 1:(\$1>$startymd && \$1<=$endymd ? gmpc + 5*log10(\$2) + 2.5*kmpc*log10(\$3) : 1/0) \\
        title tmpc  lw 2 lc rgb '#B0D0F0' lt 1 with lines \\
EOF
        plotcmd="    ,"
    fi
    if [ ! "$mpcparam" ]
    then
        cat <<EOF >> $tmpgp
$plotcmd '$tmpmpc'  using 1:(\$1>=$startymd && \$1<=$endymd ? \$4 : 1/0) \\
        title 'MPC model' pt 7 ps 0.5 lw 2 lc rgb '#B0D0F0' lt 1 \\
EOF
        plotcmd="    ,"
    fi

    # new model data
    if [ "$newparam" ]
    then
        cat <<EOF >> $tmpgp
$plotcmd '$tmpmpc' using 1:(\$1>=$startymd && \$1<=$endymd ? gnew + 5*log10(\$2) + 2.5*knew*log10(\$3) : 1/0) \\
        title tnew lw 2 lc rgb '#80E870' lt 1 with lines \\
EOF
        plotcmd="    ,"
    fi


    # determine point size
    ptsize=1.4
    n=$(cat $tmpobs | wc -l)
    test $n -gt 20 && ptsize=1.3
    test $n -gt 100 && ptsize=1.2

    # observations from COBS,ICQ,FGK
    # CCD: src=13,14,15
    visdesc=""
    grep -q "^cobs," $tmpobs && visdesc="COBS"
    grep -q "^icq,"  $tmpobs && visdesc="$visdesc,ICQ"
    grep -q "^fgk,"  $tmpobs && visdesc="$visdesc,FGK"
    n=$(grep -E "^cobs,1[345],|^icq,1[345],|^fgk,1[345]," $tmpobs | wc -l)
    if [ $n -gt 0 ]
    then
        color="#90B0C8"  # #90B0C8 #D0B040 #60C840
        test $n -lt 25 && color="#6295BA"
        cat <<EOF >> $tmpgp
$plotcmd '$tmpobs'  using 4:(\$2>=10 ? \$$ocol : 1/0) \\
        title 'CCD (${visdesc##,})' pt 6 ps $ptsize lc rgb '$color' \\
EOF
        plotcmd="    ,"
    fi

    # vis. or CCD vis. equivalent: src=3,4,5
    visdesc=""
    grep -q "^cobs," $tmpobs && visdesc="COBS"
    grep -q "^icq,"  $tmpobs && visdesc="$visdesc,ICQ"
    grep -q "^fgk,"  $tmpobs && visdesc="$visdesc,FGK"
    n=$(grep -E "^cobs,[345],|^icq,[345],|^fgk,[345]," $tmpobs | wc -l)
    if [ $n -gt 0 ]
    then
        color="#E6C886"  # #90B0C8 #D0B040 #60C840
        test $n -lt 25 && color="#DBAE4B"
        cat <<EOF >> $tmpgp
$plotcmd '$tmpobs'  using 4:((\$2==3 || \$2==4 || \$2==5) ? \$$ocol : 1/0) \\
        title 'vis. (${visdesc##,})' pt 6 ps $ptsize lc rgb '$color' \\
EOF
        plotcmd="    ,"
    fi


    # intern (own) observations
    # CCD observations, src=2
    if grep -q "^ccd,2," $tmpobs
    then
        cat <<EOF >> $tmpgp
$plotcmd '$tmpobs'  using 4:(\$2==2 ? \$$ocol : 1/0) \\
        title '$ccddesc' pt 7 ps $ptsize lc rgb '#0000F0' \\
EOF
        plotcmd="    ,"
    fi

    # DSLR or visual observations, src=1
    if grep -q "^dslr,1," $tmpobs
    then
        cat <<EOF >> $tmpgp
$plotcmd '$tmpobs'  using 4:(\$2==1 ? \$$ocol : 1/0) \\
        title '$dslrdesc' pt 7 ps $ptsize lc rgb '#D03000' \\
EOF
        plotcmd="    ,"
    fi

    # other extern observations (obs data in column 2)
    if [ -f "$otherdat" ]
    then
        color="#91D8FF"  # #FCD974 #39B92E #F05020
        x=$(echo $ptsize | awk '{print $1*0.7}')
        cat <<EOF >> $tmpgp
$plotcmd '$otherdat'  using 1:(\$1>=$startymd && \$1<=$endymd ? \$2 : 1/0) \\
        title '$otherdesc' pt 7 ps $ptsize lc rgb '$color' \\
EOF
        plotcmd="    ,"
    fi
    

    # run gnuplot
    cat $tmpgp | gnuplot -p
    retval=$?
    if [ $retval -eq 0 ]
    then
        # show plot
        #docviewer="evinve"
        docviewer="xdg-open"
        ps uxaw | grep -vw grep | grep -q "$USER .* $docviewer $outfile" || \
            (echo "# displaying $outfile ..." >&2; $docviewer $outfile 2>/dev/null &)
    fi

    if [ "$AI_DEBUG" ] || [ $retval -ne 0 ]
    then
        echo "obs:     $tmpobs"
        echo "mpc:     $tmpmpc"
        echo "gnuplot: $tmpgp"
    else
        rm $tmp1 $tmpcobs $tmpobs $tmpmpc $tmpgp
    fi
    return $retval
}

focas () {
    # multi-aperture photometry of a comet in comet/$set.cosub*.$ext
    # note: large aperture photometry data must exist already
    # test cases:
    # 160813s co02 226P     0433+007 2457614.295 180  6  6.6  178 1.7  f=530,f/5.0 SSO    # co.bad
    # 160820s co03 226P     0445+027 2457621.297 120  7 10.0  954 2.1  f=530,f/5.0 SSO
    # 160709m co01 2015WZ   1604+363 2457579.777 120  9  6.5   78 2.1  f=530,f/5.0 Mayhill
    # 160421m co01 252P     1725+069 2457500.954  60  8  9.5 1073 3.4  f=530,f/5.0 Mayhill
    local showhelp
    local bgval
    local center    # xf,yf object center in fits coordinates
    local i
    for i in 1 2 3
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-b" && bgval="$2" && shift 2
        test "$1" == "-c" && center="$2" && shift 2
    done
    local dir=$1
    local set=$2
    local aplist=$3 # apertures (diameter) in arcsec, separated by comma
    local tmpim1=$(mktemp "/tmp/tmp_im1_$$.XXXXXX.pnm")
    local tmpim2=$(mktemp "/tmp/tmp_im2_$$.XXXXXX.pnm")
    local tmpmask=$(mktemp "/tmp/tmp_mask_$$.XXXXXX.pbm")
    local tmpdat1=$(mktemp "/tmp/tmp_data1_$$.XXXXXX.dat")
    local tmpdat2=$(mktemp "/tmp/tmp_data2_$$.XXXXXX.dat")
    local tmpgp=$(mktemp "/tmp/tmp_gp_$$.XXXXXX.txt")
    local hdr
    local ext
    local b
    local f
    local cosub
    local coreg
    local cobad
    local pscale
    local mult
    local mjd
    local ut
    local texp
    local nexp
    local magzero
    local fwhm
    local rmsg
    local dia
    #local papcorr
    #local pcref
    #local paref
    local shrink
    local mbox
    local cfwhm
    local c
    local dmag
    local dasec # aperture diameter in arcsec
    local rpix  # aperture radius in pix
    local mag
    local aidx
    local xlist
    local x
    local h
    
    (test "$showhelp" || test $# -lt 3) &&
        echo "usage: focas [-c xfits,yfits] [-b bgval] <dir> <set> <apert_dia_asec>" >&2 &&
        return 1

    hdr=$dir/$set.head
    test ! -f $hdr && echo "ERROR: missing $hdr." >&2 && return 255
    
    # get image extension
    b=$(basename $hdr)
    ext=""
    test -f $(dirname $hdr)/${b%.*}.pgm && ext=pgm
    test -f $(dirname $hdr)/${b%.*}.ppm && ext=ppm
    test -z "$ext" && echo "ERROR: no image ${b%.*}.p?m found." >&2 && return 255

    # get cosub image
    cosub=""
    f=$(dirname $hdr)/comet/${b%.*}.cosub10.$ext
    test -f $f && cosub=$f && mult=10
    test -z "$cosub" && f=$(dirname $hdr)/comet/${b%.*}.cosub1.$ext &&
        test -f $f && cosub=$f && mult=1
    test -z "$cosub" && f=$(dirname $hdr)/comet/${b%.*}.cosub.$ext &&
        test -f $f && cosub=$f && mult=1
    test -z "$cosub" && echo "ERROR: no cosub image found." >&2 && return 255
    
    # get coregion file
    coreg=""
    f=$(dirname $hdr)/comet/${b%.*}.comet.reg
    test -f $f && coreg=$f
    test -z "$coreg" && f=$(dirname $hdr)/comet/${b%.*}.cometin.reg &&
        test -f $f && coreg=$f
    test -z "$coreg" && echo "ERROR: no coreg file found." >&2 && return 255

    # get cobad region
    cobad=""
    f=$(dirname $hdr)/comet/${b%.*}.bad.reg
    test -f $f && cobad=$f

    # determine pixelscale
    f=$(dirname $hdr)/${b%.*}.wcs.head
    test ! -f $f && echo "ERROR: wcs header file is missing." >&2 && return 255
    pscale=$(get_wcspscale $f)
    
    # get required keywords from header file
    jd=$(get_header -q $hdr JD)
    test -z "$jd" && jd=$(get_header -q $hdr MJD_OBS)
    test -z "$jd" && echo "ERROR: missing keyword JD or MJD_REF." >&2 && continue
    ut=$(jd2ut -p 2 $jd)
    set - $(get_header -s $hdr EXPTIME,NEXP,AI_FWHM,AI_RMSG) x
    test $# -ne 5 && echo "ERROR: missing keyword(s)." >&2 && return 255
    texp=$1
    nexp=$2
    fwhm=$3
    rmsg=$4
    
    # get index for comet aperture measurements in G color band
    aidx=""
    xlist=$(get_header $hdr all | grep "^AC_ICOL[1-9]=" | cut -c8 | sort -nu)
    for x in $xlist
    do
        test "$(get_header $hdr AC_ICOL$x)" == "G" && aidx=$x && break
    done
    test -z "$aidx" && echo "ERROR: missing measurements in G color band." >&2 && return 255

    # get comet aperture diameter (in pix)
    dia=$(get_header -q -s $hdr AC_DIAM$aidx)
    test -z "$dia" && echo "ERROR: missing keyword(s) AC_DIAM$aidx." >&2 && return 255
    # get comet background (old: AI_CBG)
    test -z "$bgval" && bgval=$(get_header $hdr AC_BCKG$aidx)
    test -z "$bgval" && echo "ERROR: missing keyword AC_BCKG$aidx." >&2 && return 255
    texp=$(echo $texp $nexp | awk '{printf $1/$2}')
    echo "# $cosub $coreg d=$dia bg=$bgval texp=$texp pscale=$pscale" >&2
    
    # get photometry results from APASS
    # get index for comet aperture measurements in G color band
    pidx=""
    xlist=$(get_header $hdr all | grep "^AP_AIDX[1-9]=" | cut -c8 | sort -nu)
    for x in $xlist
    do
        test "$(get_header $hdr AP_AIDX$x)" == "$aidx" &&
        test "$(get_header $hdr AP_PCAT$x)" == "apass" && pidx=$x && break
    done
    test -z "$pidx" && echo "ERROR: missing photometry in APASS." >&2 && return 255
    # old: set - $(get_header -s $hdr AI_PAPCO,AI_PCREF,AI_PAREF) x
    # get magzero (1ADU,1s) corrected for large aperture
    magzero=$(get_header -s $hdr AP_MZER$pidx)
    test -z "$magzero" && echo "ERROR: missing keyword." >&2 && return 255

    # correct magzero and background according to intensity multiplier
    magzero=$(echo $magzero $(di2dmag $mult) | awk '{printf("%.2f", $1-$2)}')
    bgval=$(echo $bgval $mult | awk '{x=($1-2000)*$2+2000; printf("%.2f", x)}')
    echo "# intensity_mult=$mult  corr_magzero=$magzero  corr_bg=$bgval" >&2
    
    
    # extract green channel, apply $coreg and $cobad
    if is_ppm $cosub
    then
        reg2pbm $cosub $coreg | pnmarith -m $cosub - 2>/dev/null | \
            gm convert - -channel Green pgm:- > $tmpim1
    else
        reg2pbm $cosub $coreg | pnmarith -m $cosub - 2>/dev/null > $tmpim1
    fi
    test "$cobad" &&
        reg2pbm $cosub $cobad | pnminvert | pnmarith -m $tmpim1 - 2>/dev/null > $tmpim2 &&
        mv $tmpim2 $tmpim1


    # aperture center
    if [ -z "$center" ]
    then
        # determine inner comet region
        #   get rid of star trails by median smooth using ${mbox}x${mbox}
        #   threshold image at bg+6*sd*mult/shrink/mbox, dilate mbox erode mbox
        mbox=3
        test $dia -gt  40 && mbox=5;   test $dia -gt  150 && mbox=7
        erode=2.5
        test $dia -gt 100 && erode=3.5; test $dia -gt 150 && erode=$((3+(dia-40)/80))
        threshold=$(echo $bgval $rmsg $mult $mbox | \
            awk '{x=$1+6*$2*$3/$4; printf("%.0f", x)}')
        test "$AI_DEBUG" && echo "# mbox=$mbox erode=$erode threshold=$threshold" >&2
        convert $tmpim1 -median ${mbox}x${mbox} $tmpim2
        convert $tmpim2 -threshold $threshold \
            -morphology Erode Disk:$erode -morphology Dilate Disk:1.5 \
            -morphology Erode Disk:2.5 -morphology Dilate Disk:$mbox $tmpmask
        test "$AI_DEBUG" && echo $tmpim1 $tmpim2 $tmpmask >&2
        
        # determine comets fwhm
        #   get max in masked median smoothed image
        #   count high signal pixels (above 50%) and "deconvolve" by mbox
        pnmarith -m $tmpim2 $tmpmask 2>/dev/null | AIval -c -a - | grep -v " 0$" > $tmpdat1
        max=$(sort -n -k3,3 $tmpdat1 | tail -1 | awk '{print $3}')
        threshold=$(echo $bgval $max | awk '{printf("%.0f", ($1+$2)/2)}')
        cat $tmpdat1 | awk -v t=$threshold '{if($3>=t){print $0}}' > $tmpdat2
        echo "# max=$max  i50=$threshold  n50=$(cat $tmpdat2 | wc -l)"
        cfwhm=$(cat $tmpdat2 | wc -l | awk -v m=$mbox '{x=sqrt(($1-m*m*0.4)/3.1416); printf("%.1f", x)}')
        echo "# psf fwhm=$fwhm  comet fwhm=$cfwhm" >&2
        test "$AI_DEBUG" && echo $tmpdat1 $tmpdat2 $tmpgp >&2
        
        # determine comet center by fitting parabolic surface to high signal pixels
        echo "# initial guess
            xm=$(mean $tmpdat2 1)
            ym=$(mean $tmpdat2 2)
            a=$(mean $tmpdat2 3)
            b=0.1
            
            set fit quiet
            f(x,y) = a + b*(x-xm)*(x-xm) + b*(y-ym)*(y-ym)
            fit f(x,y) '$tmpdat2' using 1:2:3:(1) via a, b, xm, ym
            out=sprintf(\"%d %6.3f %7.1f %7.3f %7.1f %7.1f\", \
                FIT_NDF, FIT_STDFIT, a, b, xm, ym)
            print out
            #show variables all
        " > $tmpgp
        x=$(gnuplot -p $tmpgp 2>&1)
        echo "# gpfit: $x"  # result is in image pixel indexes
        # show fits coord
        h=$(identify $cosub | cut -d " " -f3 | cut -d "x" -f2)
        center=$(echo $h $x | awk '{printf("%.1f,%.1f", $6+1, $1-$7)}')
        echo "# object center (fits): $center" 
    fi

    
    # do aperture photometry
    echo "# dir   set    jd          fcenter       d/\" mag   npx bg      mzero"
    #     .       co01a  2457964.371 2762.0,1662.2  12 16.38  77 2006.80 23.76
    # conversion to image pixel coordinates
    xycenter=$(echo "circle($center,5)" | reg2xy $cosub - | \
        awk '{printf("%.1f,%.1f", $2, $3)}') 
    for dasec in ${aplist//,/ }
    do
        rpix=$(echo $dasec $pscale | awk '{printf("%.2f", $1/2/$2)}')
        set - $(aphot -b $bgval -t $texp -m $magzero $tmpim1 $xycenter $rpix)
        mag=$4; npx=$6
        LANG=C printf "%-7s %-6s %11.3f %9s %3d %5.2f %3.0f %s %s\n" \
            $(dirname $hdr) ${b%.*} $jd $center $dasec $mag $npx $bgval $magzero
    done


    test -z "$AI_DEBUG" && rm -f $tmpim1 $tmpim2 $tmpmask
    test -z "$AI_DEBUG" && rm -f $tmpdat1 $tmpdat2 $tmpgp
    return
}

# convert from ds9 circle regions to xy points
# e.g. for single object: echo "circle 2886.3 1247.4" | reg2xy - 3284
# circles with r=0 are ignored
# TODO: check for keyword "physical"
reg2xy () {
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    local img=$1    # image or number (height of image)
    local reg=$2
    local h

    (test "$showhelp" || test $# -ne 2) &&
        echo "usage: reg2xy <img|height> <reg>" >&2 &&
        return 1

    test "$reg" == "-" && reg="/dev/stdin"
    is_integer "$img" && h=$img
    test -z "$h" && test ! -f "$img" &&
        echo "ERROR: image $img not found." >&2 && return 255
    
    test -z "$h" && h=$(identify $img | cut -d " " -f3 | cut -d "x" -f2)
    test -z "$h" && return 255
    
    cat $reg | tr '(){},=' ' ' | awk -v h=$h 'BEGIN{newid=1}{
        if($1=="circle") {
            if ($4==0) {
                printf("# ignoring %s\n", $0)
                next
            }
            if($6=="text") {id=$7} else {id=sprintf("N%04d",newid); newid++}
            n=index($0,"#")
            if (n>0) {x=" "substr($0,n)} else {x=""}
            printf("%s %.3f %.3f%s\n", id, $2-0.5, h-$3+0.5, x)
        }
    }'
}

reg2pbm () {
    # convert ds9 region file (circle/polygon/box) to pbm
    # regions are interpreted as good pixel regions (white, value=0)
    # output is directed to stdout
    # notes for applying mask:
    #    pnmarith -mul image.ppm mask.pbm > objects_in_reg.ppm
    #    pnminvert mask.pbm | pnmarith -mul image.ppm - > objects_outside_reg.ppm
    # TODO: deal with object rotation (e.g. for a box, rotation is 5th parameter)
    local showhelp
    local do_keep_svg   # keep svg file
    local i
    for i in $(seq 1 2)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-s" && do_keep_svg=1 && shift 1
    done
    local img=$1
    local reg=$2
    local id=${3:-""}
    local w
    local h
    local tmpsvg=$(mktemp "/tmp/tmp1_$$_XXXXXX.svg")

    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: reg2pbm [-s] <img> <reg> <text_id>" >&2 &&
        return 1

    test "$reg" == "-" && reg="/dev/stdin"
    test ! -f "$img" &&
        echo "ERROR: image $img not found." >&2 && return 255
    
    w=$(identify $img | cut -d " " -f3 | cut -d "x" -f1)
    h=$(identify $img | cut -d " " -f3 | cut -d "x" -f2)
    
    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<svg xmlns=\"http://www.w3.org/2000/svg\"
        version=\"1.1\" baseProfile=\"full\"
        width=\"${w}px\" height=\"${h}px\" viewBox=\"0 0 $w $h\">" > $tmpsvg

    # create svg (shift to left and up to get final mask image to match ds9 region)
    cat $reg | tr '()' ' ' | awk -v w=$w -v h=$h -v id="$id" 'BEGIN{t="text={"id"}"}{
        if(id!~/^$/ && $0!~t) next
        if($1=="circle") {
            na=split($2,a,/,/)
            if (a[3]==0) next
            printf("<circle cx=\"%.3f\" cy=\"%.3f\" r=\"%.3f\" />\n", a[1]-0.5, h-a[2]+0.5, a[3])
        }
        if($1=="box") {
            na=split($2,a,/,/)
            printf("<rect x=\"%.3f\" y=\"%.3f\" width=\"%.3f\" height=\"%.3f\" />\n",
                a[1]-0.5-a[3]/2, h-a[2]+0.5-a[4]/2, a[3], a[4])
        }
        if($1=="polygon") {
            na=split($2,a,/,/)
            printf("<polygon points=\"")
            for(i=1;i<=na/2;i++) {printf("%.3f %.3f ", a[2*i-1]-0.5, h-a[2*i]+0.5)}
            printf("\" />\n")
        }
    }' >> $tmpsvg

    echo "</svg>" >> $tmpsvg
    # note: canvas size is not kept if libmagick++-6.q16-5 is installed
    #   convert $tmpsvg -negate pbm:
    rsvg-convert $tmpsvg | pngtopnm -alpha - | convert - -threshold 45% pbm:
    test "$do_keep_svg" && mv $tmpsvg $(basename $reg).svg
    rm -f $tmpsvg
}

pbm2reg () {
    # output to stdout
    local showhelp
    local verbose
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-v" && verbose=1 && shift 1
    done
    local pbm=$1
    local angle=140
    local rad=3
    local h
    local svg=$(mktemp "/tmp/tmp_svg_$$_XXXXXX.svg")
    local tmp1=$(mktemp "/tmp/tmp_dat_$$_XXXXXX.dat")

    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: pbm2reg <pbmfile>" >&2 &&
        return 1
    
    echo "ERROR: program under construction (autotrace -> potrace transition)" >&2
    exit 255
    
    h=$(identify $pbm | cut -d " " -f3 | cut -d "x" -f2)
    # TODO: replace autotrace by potrace
    autotrace -output-format svg -corner-surround $rad -corner-threshold $angle $pbm > $svg
    cat $svg | awk '{
        if ($1~/<\/svg>/) ok=0
        if ($1~/<path/) {
            ok=0
            if ($2~/fill:#ffffff/) ok=1
        }
        if (ok==1) printf("%s ", $0)
    }' | sed -e 's/^.* d="//; s|z"/>[ ]*$||; s/L/\nL/g; s/C/\nC/g' > $tmp1
    n=$(grep -v "^[ML]" $tmp1 | wc -l)
    test $n -ne 0 &&
        echo "ERROR: pbm2reg has $n non-line segments (check $tmp1)." >&2 && return 255
    # TODO: maybe rerun auto-/potrace with increased angle
    test "$verbose" && echo "# creating $(cat $tmp1 | wc -l) points" >&2
    echo "# Region file format: DS9 version 4.1
global color=green dashlist=8 3 width=1 font=\"helvetica 10 normal roman\" \
select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1
physical"
    #("
    cat $tmp1 | awk -v h=$h '{
        if ($1~/^M/) onum++
        if (onum>lastnum) {
            if (onum>1) {printf(")\n")}
            printf("polygon(")
            lastnum=onum
        }
        if ($1~/^L/) printf(",")
        sub(/[LM]/, "")
        printf("%s,%s", $1+0.5, h-$2+0.5)
    } END {
        printf(")\n")
    }'
    rm $tmp1 $svg
}


regshift () {
    # shift coordinates in ds9 region file (circle/polygon/box)
    # TODO: deal with rotation of coordinate system for polygon and box
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    local reg=$1
    local dx=$2         # to the right
    local dy=$3         # to the top
    local da=${4:-"0"}  # rotation angle between coordinate systems in degrees
                        # (counting counter clockwise)
    local w=${5:-"0"}   # width of image where reg has been created from
    local h=${6:-"0"}   # height of image

    (test "$showhelp" || test $# -lt 3) &&
        echo "usage: regshift <reg> <dx> <dy> [da] [w] [h]" >&2 &&
        return 1

    test "$reg" == "-" && reg="/dev/stdin"
    test "$da" != "0" && test $(echo "$w * $h" | bc) -eq 0 &&
        echo "ERROR: both w and h are required (non-zero)." >&2 && return 255
    
    cat $reg | tr '()' ' ' | awk -v dx=$dx -v dy=$dy -v da=$da -v w=$w -v h=$h '{
        str=""
        for (i=3;i<=NF;i++) str=str" "$i
        if($1=="circle") {
            na=split($2,a,/,/)
            r=da*3.1415926/180
            x=w/2+(a[1]-w/2)*cos(r)+(a[2]-h/2)*sin(r)+dx
            y=h/2-(a[1]-w/2)*sin(r)+(a[2]-h/2)*cos(r)+dy
            printf("%s(%.3f,%.3f,%.2f)%s\n", $1, x, y, a[3], str)
            next
        }
        if($1=="box") {
            na=split($2,a,/,/)
            printf("%s(%.3f,%.3f,%s,%s)%s\n", $1, a[1]+dx, a[2]+dy, a[3], a[4], str)
            next
        }
        if($1=="polygon") {
            na=split($2,a,/,/)
            printf("%s(", $1)
            for(i=1;i<=na/2;i++) {
                if (i>1) printf(",")
                printf("%.3f,%.3f", a[2*i-1]+dx, a[2*i]+dy)}
            printf(")%s\n", str)
            next
        }
        print $0
    }'
}

# transform region file between large image and croped image
reg2reg () {
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    local reg="$1"
    local img1=$2       # image with corresponding region file
    local img2=$3       # image for which region file is transformed to
    local cropgeom=$4   # wxh+x+y, e.g. from comet/aicomet.dat
    local h1
    local h2
    local dx
    local dy

    (test "$showhelp" || test $# -ne 4) &&
        echo "usage: reg2reg <reg> <fromimg> <toimg> <cropgeom>" >&2 &&
        return 1

    test "$reg" != "-" && test ! -f "$reg" &&
        echo "ERROR: region file $reg does not exist." >&2 && return 255
    test ! -f "$img1" &&
        echo "ERROR: image $img1 does not exist." >&2 && return 255
    test ! -f "$img2" &&
        echo "ERROR: image $img2 does not exist." >&2 && return 255
        
    test "$reg" == "-" && reg="/dev/stdin"

    h1=$(identify $img1 | cut -d " " -f3 | cut -d "x" -f2)
    h2=$(identify $img2 | cut -d " " -f3 | cut -d "x" -f2)
    set - $(echo $cropgeom | tr 'x+' ' ')
    dx=$3
    if [ $h1 -ge $h2 ]
    then
        dy=$((h1-h2-$4))
        regshift $reg -$dx -$dy
    else
        dy=$((h2-h1-$4))
        regshift $reg $dx $dy
    fi
}

regcopy () {
    # copy region (physical coordinates) from one image to another
    # using wcs information
    # write resulting region file to stdout
    local showhelp
    local i
    for i in 1
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    done

    reg=$1
    fromimg=$2
    toimg=$3
    local rtype
    local coord
    local attrib
    local ncoo
    local fromwcs
    local towcs
    local fromps
    local tops
    local rad
    local newcoord
    local f
    local tmprade=$(mktemp "/tmp/tmp_rade_XXXXXX.dat")
    
    (test "$showhelp" || test $# -ne 3) &&
        echo "usage: regcopy <regfile> <fromimage> <toimage>" >&2 &&
        return 1

    fromwcs=${fromimg%.*}.wcs.head
    towcs=${toimg%.*}.wcs.head
    for f in $fromwcs $towcs
    do
        test ! -e $f && error "Header file $f is missing"
    done

    # determine scale factor
    fromps=$(get_wcspscale $fromwcs)
    tops=$(get_wcspscale $towcs)
    scale=$(echo $fromps $tops | awk '{print $2/$1}')
    echo -e "# Region file format: DS9 version 4.1
global color=green dashlist=8 3 width=1 font=\"helvetica 10 normal roman\" \
select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1
physical"

    grep -iwE "^circle|^polygon|^box" $reg | tr '()' ' ' | while read rtype coord attrib
    do
        newcoord=""
        # ncoo=$(echo $coord | tr ',' ' ' | wc -w | awk '{print $1/2}')
        # echo $rtype $ncoo $attrib
        case $rtype in
            polygon)
                    echo $coord | sed -e 's/\(,[^,]*\),/\1\n/g' | \
                        sed -e 's/^/circle /; s/,/ /' | \
                        reg2xy $fromimg - | xy2rade - $fromwcs > $tmprade
                    newcoord=$(cat $tmprade | sed -e 's/^/XX /' | \
                        rade2xy - $towcs | xy2reg $toimg - | \
                        grep "^circle" | tr '()' ' ' | cut -d ' ' -f2 | \
                        cut -d ',' -f1,2 | tr '\n' ',' | sed -e 's/,$//')
                    ;;
            circle)
                    rad=$(echo $coord | tr ',' ' ' | awk -v s=$scale '{print s*$3}')
                    echo $coord | tr ',' ' ' | sed -e 's/^/circle /' | \
                        reg2xy $fromimg - | xy2rade - $fromwcs > $tmprade
                    newcoord=$(cat $tmprade | sed -e 's/^/XX /' | \
                        rade2xy - $towcs | xy2reg $toimg - | \
                        grep "^circle" | tr '()' ' ' | cut -d ' ' -f2 | \
                        cut -d ',' -f1,2)
                    newcoord="$newcoord,$rad"
                    ;;
            *)      echo "WARNING: unsupported region type $rtype" >&2 && continue
                    ;;
        esac
        echo "$rtype($newcoord)" $attrib
    done
    rm $tmprade
    return
}

regskip () {
    # skip small regions below given size
    # it uses region extent to approximate size
    local showhelp
    local i
    for i in 1
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    done
    local reg=$1
    local minsize=${2:-"3"}
    local x
    local rtype
    
    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: regskip <regfile> [minsize|$minsize]" >&2 &&
        return 1

    ! is_reg $reg &&
        echo "ERROR: file $reg is not a ds9 region file." >&2 && return 255
    
    grep "^[a-z][a-z]*(.*)" $reg | while read
    do
        rtype=${REPLY%%(*}
        # check region extent
        x=""
        case "$rtype" in
            circle) x=$(echo $REPLY | tr '(,)' ' ' | awk '{
                        x=3.1416*$4*$4
                        printf("%.1f", x)}')
                    ;;
            box)    x=$(echo $REPLY | tr '(,)' ' ' | awk '{
                        x=$4*$5
                        printf("%.1f", x)}')
                    ;;
            polygon) x=$(echo $REPLY | cut -d ')' -f1 | cut -d '(' -f2 | \
                        tr ',' '\n' | awk '{
                        if (NR%2 == 1) {
                            if (NR==1 || $1<x1) x1=$1
                            if (NR==1 || $1>x2) x2=$1
                        } else {
                            if (NR==2 || $1<y1) y1=$1
                            if (NR==2 || $1>y2) y2=$1
                        }} END {
                        x=(x2-x1)*(y2-y1)
                        printf("%.1f", x)}')
                    ;;
        esac
        test -z "$x" && echo "$REPLY" && continue
        test "$AI_DEBUG" && echo $x ${REPLY%%,*} >&2
        if [ "$(echo $x $minsize | awk '{if($1>=$2) {print "ok"}}')" ]
        then
            echo "$REPLY"
        else
            echo "# size=$x $REPLY"
        fi
    done < $reg
    return
}


# create subset from ds9 region file by matching object ids (sep by ',')
# id is taken from first string in text attribute in <reg>
ds9match () {
    local showhelp
    local do_reject    # if set the given objects are rejected
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-n" && do_reject=1 && shift 1
    done
    local reg=$1
    local olist=$2      # separated by ','

    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: ds9match [-n] <reg> <idlist>" >&2 &&
        return 1

    test "$reg" == "-" && reg="/dev/stdin"
    cat $reg | awk -v olist="$olist" -v mode=${do_reject:-"0"} '{
        if ($1!~/^[a-z]*\(/) {
            print $0
        } else {
            n=index($0,"text={")
            id=substr($0,n+6)
            sub(/}.*/,"",id)
            sub(/ .*/,"",id)
            id=","id","
            if (match(","olist",", id) > 0) {
                if (mode==0) print $0
            } else {
                if (mode!=0) print $0
            }
        }
    }'
}


# convert from image coordinates to fits image coordinates (ds9 circle regions)
xy2reg () {
    local showhelp
    local regtype=c
    local has_fitscoord # if set, then assume data is in fits coordinates
    local i
    for i in 1 2 3
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-p" && regtype=p && shift 1
        test "$1" == "-f" && has_fitscoord=1 && shift 1
    done
    local img=$1    # image to extract height
    local dat=$2
    local dx=${3:-"0"}      # additive correction to xy coordinates
    local dy=${4:-"0"}
    local rad=${5:-"5"}
    local idcol=${6:-1}
    local xcol=${7:-2}
    local ycol=${8:-3}
    local magcol=${9:-5}    # will be appended to id string
    local h

    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: xy2reg [-p] [-f] <img> <xydat> [dx|$dx] [dy|$dy] [rad|$rad]" \
            "[idcol|$idcol] [xcol|$xcol] [ycol|$ycol] [magcol|$magcol]" >&2 &&
        return 1

    test "$dat" == "-" && dat="/dev/stdin"
    (test -z "$idcol" || test $idcol -lt 1) && idcol=0
    test ! -f $img &&
        echo "ERROR: image $img does not exist." >&2 && return 255

    h=$(identify $img | cut -d " " -f3 | cut -d "x" -f2)
    test "$has_fitscoord" && h=0
    
    echo -e "# Region file format: DS9 version 4.1
global color=green dashlist=8 3 width=1 font=\"helvetica 10 normal roman\" \
select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1
physical"
    cat $dat | awk -v h=$h -v dx=$dx -v dy=$dy -v ic=$idcol \
        -v xc=$xcol -v yc=$ycol -v mc=$magcol -v t=$regtype -v r=$rad '{
        if ($1~/^#/) next
        if (h>0) { # input is image coord
            xx=$xc+dx+0.5
            yy=h-$yc-dy+0.5
        } else { # input is fits coord
            xx=$xc+dx
            yy=$yc-dy
        }
        if (t=="p") {
            printf("polygon(%.2f,%.2f", xx-r, yy-r)
            printf(",%.2f,%.2f",        xx+r, yy-r)
            printf(",%.2f,%.2f",        xx+r, yy+r)
            printf(",%.2f,%.2f)",       xx-r, yy+r)
        } else {
            printf("circle(%.2f,%.2f,%s)", xx, yy, r)
        }
        id=""
        if (ic>0) id=$ic
        #if ((mc>0) && (mc<=NF) && ($mc~/^[0-9.+-]*$/)) id=id" "$mc
        if ((mc>0) && (mc<=NF)) id=id" "$mc
        if (id != "") {printf(" # text={%s}\n", id)} else {printf("\n")}
    }'
}

xymatch () {
    # match objects between two lists (format: id x y ...)
    # output: id xref yref xaff yaff dx dy d idref
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    local xydat="$1"
    local refdat="$2"
    local dmax=${3:-"3"}    # max. distance in pix
    local dx=${4:-"0"}      # xoff added to xydat
    local dy=${5:-"0"}      # yoff added to xydat (>0 mean downshift!)
    local da=${6:-""}       # rotation angle (degrees) added to xydat
    local w=${7:-""}
    local h=${8:-""}
    local idcol=${9:-1}     # currently unused!
    local xcol=${10:-2}
    local ycol=${11:-3}
    
    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: xymatch <xydat> <refdat> [dmax|$dmax] [dx|$dx]"\
            "[dy|$dy] [rot|$da] [w|$w] [h|$h]" >&2 &&
        return 1

    test "$da" && (test -z "$w" || test -z "$h") &&
        echo "ERROR: parameter w and/or h missing (required due to rotation)." >&2 &&
        return 255

    # TODO: for large catalogues it is advised to work in segments,
    #   e.g. cut xydat in smaller boxes and use those to work on
    #   subsets of refdat
    echo "# id     xref     yref      x      y        dx   dy   d    idref"
    while read id x y z
    do
        test "${id:0:1}" == "#" && continue
        # apply rotation with respect to image center and translation
        set - $(echo $x $y $dx $dy $w $h $da | awk '{
            if ($7 == 0) {
                printf("%s %s\n", $1+$3, $2+$4)
            } else {
                pi=3.1415927
                r=sqrt(($6/2-$2)^2 + ($1-$5/2)^2)
                a=atan2($2-$6/2, $1-$5/2)*180/pi+$7
                printf("%.2f %.2f\n", $5/2+r*cos(a*pi/180)+$3, $6/2+r*sin(a*pi/180)+$4)
            }}')
        #echo "circle($1,$2,5) # text={$id}" >&2
        grep -v "^#" $refdat | awk -v id=$id \
            -v x=$1 -v y=$2 -v z="$z" -v dlim=$dmax 'BEGIN{found=0}{
                dx=$2-x
                if ((dx>dlim) || (dx<-1.0*dlim)) next
                dy=$3-y
                if ((dy>dlim) || (dy<-1.0*dlim)) next
                d=sqrt(dx*dx+dy*dy)
                if (d>dlim) next
                found=1
                printf("%-8s %7.2f %7.2f  %7.2f %7.2f  %4.1f %4.1f %4.1f  %s\n",
                    id, $2, $3, x, y, dx, dy, d, $1)
            }END{
                if (found == 0)
                    printf("# %-8s %8s %8s  not found\n", id, x, y)
            }'
    done < $xydat
}


# get subset of region file based on object ids
regmatch () {
    local showhelp
    local i
    for i in 1
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    done
    local reg=$1
    local idlist=$2     # ids separated by space or comma
    local id

    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: regmatch <reg> <idlist>" \
            "[xcol|$xcol] [ycol|$ycol] [fwhmcol|$fwhmcol]" >&2 &&
        return 1

    grep -vE "^circle\(|^box\(|^polygon\(|^line\(|^ellipse\(" $reg
    for id in $idlist
    do
        grep "text={$id " $reg
    done
    return
}

regfilter () {
    # apply spatial filtering of a fits table using ds9 region file
    # output fits table to stdout
    local showhelp
    local maxfwhm     # if set limit to fwhm<=maxfwhm
    local verbose
    local i
    for i in 1 2 3
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-f" && maxfwhm=$2 && shift 2
        test "$1" == "-v" && verbose=1 && shift 1
    done
    local ftab=$1
    local reg=$2
    local xcol
    local ycol
    local fwhmcol="FWHM_IMAGE"
    local tmp1=$(mktemp "/tmp/tmp_tmp1_XXXXXX.fits")
    local tmp2=$(mktemp "/tmp/tmp_tmp1_XXXXXX.fits")
    local tmpftab=$(mktemp "/tmp/tmp_ftab_XXXXXX.fits")
    local tmpreg=$(mktemp "/tmp/tmp_reg_XXXXXX.reg")
    local filter
    local hlist
    local ncol
    local fext

    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: regfilter [-f maxfwhm] <fitstab> <regfile>" >&2 &&
        return 1

    test "$ftab" != "-" && test ! -f "$ftab" &&
        echo "ERROR: FITS table file $ftab not found." >&2 && return 255
    test "$reg" != "-" && test ! -f "$reg" &&
        echo "ERROR: ds9 region file $reg not found." >&2 && return 255

    test "$ftab" == "-" && cat > $tmpftab && ftab=$tmpftab
    test "$reg" == "-" && cat > $tmpreg && reg=$tmpreg

    # find HDU's with given columns
    filter="for HDU|X.*_IMAGE|Y.*_IMAGE"; ncol=2
    test "$maxfwhm" && filter="$filter|$fwhmcol" && ncol=3
    hlist=$(listhead $ftab | tr "'" '\n' | grep -wE "$filter" | \
        awk '{if (NF>1) printf("\n"); printf("%s ", $NF)}' | \
        awk -v n=$ncol '{if (NF==n+1) printf("%s ", $1)}' | tr -d '#:')
    test -z "$hlist" &&
        echo "ERROR: no table extension having columns x,y" >&2 && return 255
    test "$AI_DEBUG" && echo "# hlist=$hlist" >&2

    cp $ftab $tmp1
    for fext in $hlist
    do
        xcol=$(listhead ${ftab}"[$((fext-1))]" | tr "'" '\n' | grep -wE "X.*_IMAGE")
        ycol=$(listhead ${ftab}"[$((fext-1))]" | tr "'" '\n' | grep -wE "Y.*_IMAGE")
        if [ "$maxfwhm" ]
        then
            fitscopy $tmp1"[$((fext-1))][regfilter('$reg', $xcol, $ycol); $fwhmcol < $maxfwhm]" - > $tmp2
        else
            fitscopy $tmp1"[$((fext-1))][regfilter('$reg', $xcol, $ycol)]" - > $tmp2
            test $? -ne 0 && echo "ERROR in fitscopy." >&2 &&
                echo "fitscopy $tmp1\"[$((fext-1))][regfilter('$reg', $xcol, $ycol)]\" - > $tmp2" >&2 &&
                return 255
        fi
        mv $tmp2 $tmp1
    done
    cat $tmp1
    #rm $tmp1 $tmpftab $tmpreg
}


# image statistics within region
regstat () {
    local showhelp
    local kappa=3.5
    local do_green_only
    local do_merge_all_regions  # if set then stats is for the combined region
    local do_quick              # skip kappa-sigma clipping
    local do_minmax             # if set then show min/max/mean instead of noise stats
    local verbose               # currently not used
    local i
    for i in 1 2 3 4 5 6 7
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-a" && do_merge_all_regions=1 && shift 1
        test "$1" == "-k" && kappa="$2" && shift 2
        test "$1" == "-g" && do_green_only=1 && shift 1
        test "$1" == "-q" && do_quick=1 && shift 1
        test "$1" == "-m" && do_minmax=1 && shift 1
        test "$1" == "-v" && verbose=1 && shift 1
    done
    local img=$1
    local reg=$2
    local badreg=${3:-""}
    local tmpreg1=$(mktemp /tmp/tmp_reg1_XXXXXX.reg)
    local tmpreg2=$(mktemp /tmp/tmp_reg2_XXXXXX.reg)
    local opts=""

    (test "$showhelp" || test $# -lt 2 || test $# -gt 3) &&
        echo "usage: regstat [-q] [-g] [-m] [-a] [-k kappa|$kappa] <image> <reg> [badreg]" >&2 &&
        return 1
    test "$reg" == "-" && cat /dev/stdin > $tmpreg1 && reg=$tmpreg1
    test ! -f "$img" &&
        echo "ERROR: image file $img not found." >&2 && return 255
    #! is_reg "$reg" &&
    #    echo "ERROR: $reg is not a valid region file." >&2 && return 255
    
    test "$do_quick" && opts="-q"
    test "$do_minmax" && opts="-m"
    if [ "$do_merge_all_regions" ]
    then
        _regstat $opts $img $reg $badreg
    else
        grep -iwE "^circle|^polygon|^box" $reg | while read
        do
            echo "$REPLY" > $tmpreg2
            _regstat $opts $img $tmpreg2 $badreg
        done
    fi
    rm $tmpreg1 $tmpreg2
}

_regstat () {
    local do_quick
    local do_minmax
    test "$1" == "-q" && do_quick=1 && shift 1
    test "$1" == "-m" && do_minmax=1 && shift 1
    local img=$1
    local reg=$2
    local badreg=$3
    local tmpreg1=$(mktemp /tmp/tmp_reg1_XXXXXX.reg)
    local tmp1=$(mktemp /tmp/tmp_tmp1_XXXXXX.dat)
    local tmpmask=$(mktemp /tmp/tmp_mask_XXXXXX.pbm)
    local tmpmask2=$(mktemp /tmp/tmp_mask2_XXXXXX.pbm)
    local tmpim1=$(mktemp /tmp/tmp_img_XXXXXX.pnm)
    local w
    local h
    local xmin
    local xmax
    local ymin
    local ymax
    local dx
    local dy
    local area
    local mean
    local sum
    local bgmean
    local sd
    local min
    local max
    local idx
    local n

    # determine region extent
    w=$(identify $img | cut -d " " -f3 | cut -d "x" -f1)
    h=$(identify $img | cut -d " " -f3 | cut -d "x" -f2)
    cat $reg | tr '()' ' ' | awk -v w=$w -v h=$h '{
        if($1=="circle") {
            na=split($2,a,/,/)
            if (a[3]==0) next
            printf("%.3f %.3f\n", a[1]-a[3], a[2]-a[3])
            printf("%.3f %.3f\n", a[1]+a[3], a[2]+a[3])
        }
        if($1=="box") {
            na=split($2,a,/,/)
            printf("%.3f %.3f\n", a[1]-a[3]/2, a[2]-a[4]/2)
            printf("%.3f %.3f\n", a[1]+a[3]/2, a[2]+a[4]/2)
        }
        if($1=="polygon") {
            na=split($2,a,/,/)
            for(i=1;i<=na/2;i++) {printf("%.3f %.3f\n", a[2*i-1], a[2*i])}
        }
    }' > $tmp1
    # region boundary in image coordinates
    xmin=$(LANG=C sort -n -k1,1 $tmp1  | head -1 | awk -v w=$w '{
        x=$1-1.0; if(x<0) x=0; if(x>w) x=w; printf("%.0f",x)}')
    xmax=$(LANG=C sort -nr -k1,1 $tmp1 | head -1 | awk -v w=$w '{
        x=$1;     if(x<0) x=0; if(x>w) x=w; printf("%.0f",x)}')
    ymin=$(LANG=C sort -nr -k2,2 $tmp1 | head -1 | awk -v h=$h '{
        y=h-$2;     if(y<0) y=0; if(y>h) y=h; printf("%.0f",y)}')
    ymax=$(LANG=C sort -n -k2,2 $tmp1  | head -1 | awk -v h=$h '{
        y=h-$2+1.0; if(y<0) y=0; if(y>h) y=h; printf("%.0f",y)}')
    dx=$((xmax-xmin))
    dy=$((ymax-ymin))
    test "$AI_DEBUG" && echo "x: $xmin - $xmax   y: $ymin - $ymax" >&2
    
    (test $dx -eq 0 || test $dy -eq 0) &&
        echo "ERROR: region outside image." >&2 && return 255

    # create subimage, trim region file, create and apply mask image
    test "$AI_DEBUG" && echo "imcrop -1 <img> $dx $dy $xmin $ymin" >&2
    if is_pnm $img
    then
        imcrop -1 $img $dx $dy $xmin $ymin > $tmpim1
    else
        if is_fits $img
        then
            meftopnm $img | imcrop -1 - $dx $dy $xmin $ymin > $tmpim1
        else
            echo "ERROR: $img is not a valid image file." >&2 && return 255
        fi
    fi
    reg2reg $reg $img $tmpim1 ${dx}x${dy}+${xmin}+${ymin} > $tmpreg1
    reg2pbm $tmpim1 $tmpreg1 > $tmpmask
    if [ "$badreg" ]
    then
        mv $tmpmask $tmpmask2
        reg2reg $badreg $img $tmpim1 ${dx}x${dy}+${xmin}+${ymin} > $tmpreg1
        reg2pbm $tmpim1 $tmpreg1 | pnmarith -sub $tmpmask2 - > $tmpmask
    fi
    test "$AI_DEBUG" && echo $tmpim1 $tmpreg1 $tmpmask >&2
    
    
    if [ "$do_quick" ] && [ ! "$do_minmax" ]
    then
        area=$(imcount $tmpmask)
        sum=$(pnmarith -mul $tmpim1 $tmpmask 2>/dev/null | imcount -)
        mean=$(echo $sum $area | tr ',' ' ' | awk '{
            if($NF>0) {
                printf("%.1f", $1/$NF)
                if(NF==4) printf(",%.1f,%.1f", $2/$NF, $3/$NF)
            } else {
                printf("0")
                if(NF==4) printf(",0,0")
            }}')
        bgmean=$mean
        sd=0
    else
        # list data values shifted by +1
        is_pgm $tmpim1 && pnmccdred -a 1 $tmpim1 - | pnmarith -mul - $tmpmask 2>/dev/null | \
            pnmnoraw | grep -v "^#" | sed '1,3d;s/ /\n/g'  | grep "[0-9]" | grep -v "^0$" > $tmp1
        is_ppm $tmpim1 && pnmccdred -a 1 $tmpim1 - | pnmarith -mul - $tmpmask 2>/dev/null | \
            pnmnoraw | grep -v "^#" | sed '1,3d;s/  /\n/g' | grep "[0-9]" | grep -v "^0 0 0$" > $tmp1
        test "$AI_DEBUG" && echo $tmp1 >&2

        # get statistics
        clist=1
        is_ppm $tmpim1 && clist="1 2 3"
        test "$do_green_only" && is_ppm $tmpim1 && clist=2
        area=$(wc -l $tmp1 | cut -d ' ' -f1)
        test $area -eq 0 && echo "ERROR: no data points, no stats" && return 255
        for idx in $clist
        do
            test "$mean" && mean=$mean"," && sum=$sum"," &&
                bgmean=$bgmean"," && sd=$sd"," &&
                min=$min"," && max=$max","
            mean="$mean"$(mean $tmp1 $idx | awk '{printf("%.1f", $1-1)}')
            sum="$sum"$(sum $tmp1 $idx | awk -v a=$area '{printf("%.0f", $1-a)}')
            if [ "$do_minmax" ]
            then
                set - $(minmax $tmp1 $idx | awk '{printf("%.1f %.1f", $1-1, $2-1)}')
                min="$min"$1; max="$max"$2
            fi
            if [ $area -lt 5 ]
            then
                bgmean=$mean
                sd=0
            else
                set - $(kappasigma $tmp1 $idx $kappa)
                bgmean="$bgmean"$(echo $1 | awk '{printf("%.1f", $1-1)}')
                sd="$sd"$(echo $2| awk '{printf("%.1f", $1)}')
            fi
        done
    fi
    
    # get region text
    id=$(grep "^[a-z]*(.*).* # text={" $reg | cut -d '{' -f2 | tr -d '}')
    n=$(echo "$id" | wc -l)
    test $n -gt 1 && id="${n}_regions"
    test ! "$do_minmax" && echo $bgmean $sd $area $sum $mean $id
    test   "$do_minmax" && echo $min $max $mean $area $id
    
    test "$AI_DEBUG" || rm $tmp1 $tmpreg1 $tmpim1 $tmpmask $tmpmask2
    return
}

findgain () {
    # determine gain from noise statistics of a pair of images
    local showhelp
    local kappa=5
    local dkvalue
    local dknoise
    local i
    for i in 1 2 3 4
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-a" && do_merge_all_regions=1 && shift 1
        test "$1" == "-k" && kappa="$2" && shift 2
        test "$1" == "-d" && dkvalue="$2" && dknoise="$3" && shift 3
    done
    local img1=$1
    local img2=$2
    local reg=${3:-""}
    local noise
    local sd
    local mean
    local str
    local tmpimg=$(mktemp /tmp/tmp_img_XXXXXX.pnm)
    local tmpreg=$(mktemp /tmp/tmp_reg_XXXXXX.reg)
    local tmpdat=$(mktemp /tmp/tmp_dat_XXXXXX.dat)

    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: findgain [-a] [-k kappa|$kappa] [-d dkvalue dknoise]" \
            "<image1> <image2> [regfile]" >&2 &&
        return 1
    
    ! is_pnm $img1 &&
        echo "ERROR: $img1 is not a valid image (ppm, pgm)." >&2 &&
        return 255
    ! is_pnm $img2 &&
        echo "ERROR: $img2 is not a valid image (ppm, pgm)." >&2 &&
        return 255

    pnmccdred -a 1000 -d $img2 $img1 $tmpimg
    if [ -z "$reg" ] || [ ! -s "$reg" ]
    then
        touch x.findgain.reg
        reg=x.findgain.reg
        echo "# Please define bg regions and save as $reg ..." >&2
        AIexamine -n findgain -l $tmpimg
    fi 
    
    test ! -s "$reg" &&
        echo "ERROR: file $reg is empty." >&2 && return 255
    regstat -k $kappa $tmpimg $reg > $tmpdat
    # cat $tmpdat
    set - $(kappasigma $tmpdat 2 99 | awk -v n=$(cat $tmpdat | wc -l) '{
        printf("%.3f %.3f", $1/sqrt(2), $2/sqrt(2)/sqrt(n-1))}')
    noise=$1
    sd=$2
    if [ "$dknoise" ]
    then
        pnmcombine $img2 $img1 $tmpimg 2>/dev/null
        regstat -k $kappa $tmpimg $reg > $tmpdat
        mean=$(kappasigma $tmpdat 1 99 | awk -v dk=$dkvalue '{printf("%.1f", $1-dk)}') 
        str="$(echo $noise $sd $mean $dknoise | awk '{
            x=$1*$1-$4*$4
            l=($1+$2)*($1+$2)-$4*$4
            h=($1-$2)*($1-$2)-$4*$4
            g=sqrt($3/x)
            dg=(sqrt($3/h)-sqrt($3/l))/2
            printf("%.3f %.3f", g, dg)}')"
    fi
    echo $noise $sd $mean $str
    
    rm $tmpimg $tmpdat1 $tmpreg
}

# show subset of an object list located within given regions
xyinreg () {
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    local xydat="$1"
    local reg="$2"
    local line
    local tmpxy=$(mktemp "/tmp/tmp1_xy_XXXXXX.dat")
    local ftab=$(mktemp "/tmp/tmp1_tab_XXXXXX.fits")

    (test "$showhelp" || test $# -ne 2) &&
        echo "usage: xyinreg <xydat> <reg>" >&2 &&
        return 1

    test "$xydat" == "-" && xydat="/dev/stdin"
    test ! -f "$reg" &&
        echo "ERROR: ds9 region file $reg not found." >&2 && return 255

    # convert xydat to fits table (columns XWIN_IMAGE YWIN_IMAGE)
    echo "# ID XWIN_IMAGE YWIN_IMAGE" > $tmpxy
    cat $xydat >> $tmpxy
    stilts tcopy ifmt=ascii ofmt=fits $tmpxy $ftab
    regfilter $ftab $reg | stilts tcopy ifmt=fits ofmt=ascii -
    rm $tmpxy $ftab
}


# convert ra/de to x/y image coordinates (wrapper around sky2xy)
rade2xy () {
    # convert ra, de to x, y image coordinates using wcs header
    # information and program sky2xy
    # supports input coordinates in either decimal degrees or sexagesimal format
    # using colon separator (like h:m:s deg:amin:asec)
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    local radedat=$1    # datafile
    local wcshdr=$2
    local catorcolnums=${3:-"1,2,3"}   # either star catalog name or idcol,racol,decol
    local delim=${4:-" "}
    local drad=${5:-"0"}    # correction to be added to catalog ra, in degrees
    local dded=${6:-"0"}    # correction to be added to catalog de, in degrees
    local idcol
    local racol
    local decol
    local fits=$(mktemp /tmp/tmp_img_XXXXXX.fits)
    local tmp1=$(mktemp /tmp/tmp_tmp1_XXXXXX.dat)

    (test "$showhelp" || test $# -lt 2) &&
        echo -e "usage: rade2xy <radedat> <wcshdr> [catname_or_idcol,racol,decol|$catorcolnums]" \
            "[delim|\"$delim\"] [drad|$drad] [dded|$dded]" >&2 &&
        return 1

    test "$radedat" != "-" && test ! -f "$radedat" &&
        echo "ERROR: datafile $radedat not found." >&2 && return 255
    test ! -f "$wcshdr" &&
        echo "ERROR: wcs header file $wcshdr not found." >&2 && return 255
    ! grep -q "^CRPIX1" $wcshdr &&
        echo "ERROR: missing wcs keywords in $wcshdr." >&2 && return 255
    test "$radedat" == "-" && radedat=/dev/stdin
    
    case "$catorcolnums" in
        tycho2) idcol=1,2; racol=9; decol=10;;
        gspc2)  idcol=1; racol=2; decol=3;;
        nomad)  idcol=1; racol=3; decol=4;;
        apass)  idcol=0; racol=1; decol=3;; # idcol=0: using line number as ID
        *)      set - ${catorcolnums//,/ }
                test $# -ne 3 &&
                    echo "ERROR: unknown catalog/column specification." >&2 &&
                    return 255
                idcol=$1; racol=$2; decol=$3
                ;;
    esac
    
    # get original image size
    w=$(grep "^CRPIX1" $wcshdr | tr '=' ' ' | awk '{printf("%d", $2*2)}')
    h=$(grep "^CRPIX2" $wcshdr | tr '=' ' ' | awk '{printf("%d", $2*2)}')
    
    # create image-less fits file
    rm -f $fits
    newfits -o 8 -s $w $h $fits
    keys=$(grep -Ev "^BITPIX|^HISTORY|^COMMENT|^END" $wcshdr | \
        cut -d "/" -f1 | tr "'" ' ' | sed -e 's|[ ]*=[ ]*|=|' | tr '\n' ' ')
    sethead $fits $keys
    
    # conversion
    # TODO: deal with sexagesimal coordinates
    cat $radedat | grep -v -E -- "^--|^#|^$" | awk -F "$delim" -v cid=$idcol \
        -v cx=$racol -v cy=$decol -v dx=$drad -v dy=$dded '{
            if ($1~/^#/) next
            if ($cx~/[[:alpha:]]/ || $cx~/^[[:space:]]*$/) next
            if ($cy~/[[:alpha:]]/ || $cy~/^[[:space:]]*$/) next
            id=""
            if (cid == "0") {
                id=sprintf("LN%06d", NR)
            } else {
                ncid=split(cid,a,",")
                for (i=1; i<=ncid; i++ ) {
                    sub(/^[[:space:]]*/,"",$a[i])
                    sub(/[[:space:]]*$/,"",$a[i])
                    id=id""$a[i]
                }
            }
            na=split($cx,a,":")
            if (na>1) {rad=15*(a[1]+a[2]/60+a[3]/3600)} else {rad=$cx}
            na=split($cy,a,":")
            if (na>1) {
                if($cy~/^-/) {ded=a[1]-a[2]/60-a[3]/3600} else {ded=a[1]+a[2]/60+a[3]/3600}
            } else {ded=$cy}
            printf("%.5f %.5f _%s_\n", rad+dx, ded+dy, id)
        }' > $tmp1
    false && funsky $fits $tmp1 | paste $tmp1 - | awk -v h=$h '{
            gsub("_","",$3);
            printf("%s %.2f %.2f\n", $3, $4-0.5, h-$5+0.5)
        }'
    sky2xy $fits @$tmp1 | awk -v h=$h '{
            gsub("_","",$3);
            printf("%s %.2f %.2f\n", $3, $5-0.5, h-$6+0.5)
        }'

    rm $fits $tmp1
}


# convert x/y image coordinates to ra/de (wrapper around xy2sky)
xy2rade () {
    # convert from x,y image coordinates to ra (degrees), de (degrees) using wcs
    # header information
    # TODO: implement idcol,racol,decol
    local showhelp
    local do_out_sexa   # if set then output in sexagesimal units
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-s" && do_out_sexa=1 && shift 1
    done
    local xydat=$1
    local wcshdr=$2
    local colnums=${3:-"1,2,3"}
    local idcol
    local xcol
    local ycol
    local keys
    local opts="-d"
    local fits=$(mktemp /tmp/tmp_img_XXXXXX.fits)
    local tmp1=$(mktemp /tmp/tmp_tmp1_XXXXXX.dat)
    
    (test "$showhelp" || test $# -lt 2) &&
        echo -e "usage: xy2rade <xydat> <wcshdr> [idcol,xcol,ycol|$colnums]" >&2 &&
        return 1

    test "$xydat" != "-" && test ! -f "$xydat" &&
        echo "ERROR: datafile $xydat not found." >&2 && return 255
    test ! -f "$wcshdr" &&
        echo "ERROR: wcs header file $wcshdr not found." >&2 && return 255
    ! grep -q "^CRPIX1" $wcshdr &&
        echo "ERROR: missing wcs keywords in $wcshdr." >&2 && return 255
    test "$xydat" == "-" && xydat=/dev/stdin
    test "$do_out_sexa" && opts=""
    set - ${colnums//,/ }
    test $# -ne 3 &&
        echo "ERROR: unknown column specification." >&2 &&
        return 255
    idcol=$1; xcol=$2; ycol=$3

    # get original image size
    w=$(grep "^CRPIX1" $wcshdr | tr '=' ' ' | awk '{printf("%d", $2*2)}')
    h=$(grep "^CRPIX2" $wcshdr | tr '=' ' ' | awk '{printf("%d", $2*2)}')
    
    # create image-less fits file
    rm -f $fits
    newfits -o 8 -s $w $h $fits
    keys=$(grep -Ev "^BITPIX|^HISTORY|^COMMENT|^END" $wcshdr | \
        cut -d "/" -f1 | tr "'" ' ' | sed -e 's|[ ]*=[ ]*|=|' | tr '\n' ' ')
    sethead $fits $keys

    # conversion
    grep -v "^#" $xydat | awk -v h=$h -v cid=$idcol -v cx=$xcol -v cy=$ycol '{
            if ($1~/^#/) next
            printf("%.5f %.5f _%s_\n", $cx+0.5, h-$cy+0.5, id)
        }' > $tmp1
    xy2sky $opts $fits @$tmp1
   
    rm $fits $tmp1
}


rade2altaz () {
    # for coord. trans ref.: http://star-www.st-and.ac.uk/~fv/webnotes/chapter7.htm
    # sidereal time ref.: http://aa.usno.navy.mil/faq/docs/GAST.php
    # parallactic angle ref.: https://books.google.de/books?id=e7gGCAAAQBAJ&pg=PA30
    local showhelp
    local use_image_center  # if set then use image center instead of radedat
    local use_jd_now        # if set use current date/time
    for i in 1 2 3
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-c" && use_image_center=1 && shift 1
        test "$1" == "-n" && use_jd_now=1 && shift 1
    done
    local sname=$1
    local radedat=$2
    local long
    local lat
    local jd
    local st
    local rade
    local pangle
    local tmp1=$(mktemp /tmp/tmp_tmp1_XXXXXX.dat)
    
    (test "$showhelp" || test $# -lt 1) &&
        echo -e "usage: rade2altaz [-c] <sname> <radedat>" >&2 &&
        return 1

    if [ ! "$use_image_center" ]
    then
        test -z "$radedat" &&
            echo "ERROR: missing parameter for ra/de data file name." >&2 && return 255
        test "$radedat" != "-" && test ! -f "$radedat" &&
            echo "ERROR: datafile $radedat not found." >&2 && return 255
        test "$radedat" == "-" && radedat=/dev/stdin
    fi
    test ! -e $sname.head &&
        echo "ERROR: missing header file $sname.head" >&2 && return 255
    test "$use_image_center" && test ! -e $sname.wcs.head &&
        echo "ERROR: missing wcs header file $sname.wcs.head" >&2 && return 255

    long=$(get_param -k location sites.dat long $AI_SITE)
    lat=$(get_param -k location sites.dat lat $AI_SITE)
    if [ "$use_jd_now" ]
    then
        jd=$(ut2jd $(date -u +"%H:%M:%S %y%m%d"))
    else
        jd=$(get_header $sname.head MJD_OBS)
    fi
    # sidereal time in hr
    st=$(echo $jd $long | awk '{x=18.697374558+24.06570982441908*($1-2451545.0)+$2/15;
        x=x%24; if(x<0) x=x+24
        printf("%.4f", x)}')
    test "$AI_DEBUG" && echo "st=$st" >&2
    
    if [ "$use_image_center" ]
    then
        # image center in degrees
        echo $(get_header -s $sname.wcs.head CRVAL1,CRVAL2) > $tmp1
        # parallactic angle at image center (measured from north to zenith)
        #   tan(q) = sin(HA) / (tan(lat)*cos(de) - sin(de)*cos(HA))
        radedat=$tmp1
        pangle=$(echo $(cat $tmp1) $st $lat | awk 'BEGIN{r=3.14159/180}{
            x=sin($4*r)/cos($4*r)*cos($2*r)-sin($2*r)*cos(($3*15-$1)*r)
            x=sin(($3*15-$1)*r)/x
            printf("%5.2f\n", atan2(x,1)/r)
            }')
        echo "pangle=$pangle"
    fi
    
    # sin(h)  = sin(de) * sin(lat) + cos(de) * cos(lat) * cos(HA)
    # sin(az) = -sin(HA)*cos(lat)/cos(h)    #### maybe wrong ?
    # cos(az) = (sin(de)-sin(lat)*sin(h)) / (cos(lat)*cos(h))
    grep -v "^#" $radedat | awk -v l=$lat -v s=$st 'BEGIN{r=3.14159/180}
        {
            # hour angle
            ha=(s-$1/15+24)%24
            if(ha<0) ha=ha+24
            
            # altitude
            x=sin($2*r)*sin(l*r)+cos($2*r)*cos(l*r)*cos(ha*15*r)
            h=atan2(x,sqrt(1-x*x))/r    # asin
            
            # azimuth
            x=(sin($2*r)-sin(l*r)*sin(h*r)) / (cos(l*r)*cos(h*r))
            az=atan2(sqrt(1-x*x),x)/r   # acos
            if (ha>12 && az<0) az=-1*az
            if (ha<12 && az>0) az=-1*az
            if(az<0) az=az+360
            
            #y=-sin(ha*15*r)*cos(l*r)/cos(h*r)
            #az=atan2(y,x)/r
            
            # airmass
            zd=90-h;
            if (zd>89.9) {
                am=99
            } else {
                am=1/cos(zd*r)
            }
            if (am>99) am=99
            
            printf("%5.2f %5.2f %5.3f\n", az, h, am)
        }'
    
    rm -f $tmp1
    return
}


# affine transformation of image coordinates
# apply translation first, rotation is measured anti-clockwise
# note: origin of new system is at -dx,-dy of old system
#   y-axis in new system goes from origin downwards
#   new coords (or altitude) is appended to each input line
xytrans () {
    local showhelp
    local pscale=-1 # if set use this pixel scale to compute altitude
                    # difference in degrees and output altitude instead of
                    # xy image coordinates
    #local do_out_sexa   # if set then output in sexagesimal units
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-p" && pscale="$2" && shift 2
    done
    local xydat=$1
    local dx=$2
    local dy=$3
    local rot=${4:-0}
    local xcol=2
    local ycol=3
    local tmp1=$(mktemp /tmp/tmp_tmp1_XXXXXX.dat)
    
    (test "$showhelp" || test $# -lt 3) &&
        echo -e "usage: xytrans <xydat> <dx> <dy> [rot]" >&2 &&
        return 1

    test "$xydat" != "-" && test ! -f "$xydat" &&
        echo "ERROR: datafile $xydat not found." >&2 && return 255
    test "$xydat" == "-" && xydat=/dev/stdin

    cat $xydat | awk -v dx=$dx -v dy=$dy -v a=$rot -v xcol=$xcol -v ycol=$ycol -v p=$pscale \
    'BEGIN{arad=a*3.141596/180}{
        # translation
        x=$xcol+dx
        y=$ycol+dy
        # rotation, 
        xx=x*cos(arad)+y*sin(arad)
        yy=-x*sin(arad)+y*cos(arad)
        if (p>0) {
            printf("%s  %.3f\n", $0, yy*p/-3600.)
        } else {
            printf("%s  %.3f %.3f\n", $0, xx, yy)
        }
    }'
}


# TODO: deal with multiple extensions
# NOTE: this function is used by sexselect only
ahead2ldac () {
    # convert sextractor output catalog from ASCII_HEAD format to FITS_LDAC
    # optionally selecting a single extension number
    # output: to stdout
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    local acat=$1
    local w=${2:-"65536"}
    local h=${3:-"65536"}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpin=$(mktemp "$tdir/tmp_infile_XXXXXX.dat")
    local out=$(mktemp "$tdir/tmp_out_XXXXXX.fits")
    local tmp1=$(mktemp "$tdir/tmp_tmp1_XXXXXX.dat")
    local tmp2=$(mktemp "$tdir/tmp_tmp2_XXXXXX.dat")
    local tmp3=$(mktemp "$tdir/tmp_tmp3_XXXXXX.dat")
    
    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: ahead2ldac <infile> [w|$w] [h|$h]" >&2 &&
        return 1
    
    if [ "$acat" == "-" ]
    then
        cat > $tmpin
    else
        cp $acat $tmpin
    fi
    #echo "ERROR: not implemented yet." >&2 && return 255
    
    # TODO: determine number of extensions in $acat
    #grep "^#" $acat | grep EXTENSION 
    
    # create LDAC_IMHEAD table
    echo "# 'Field Header Card'                                                                                                                                             
        'SIMPLE  =                    T / This is a FITS file'" > $tmp1
    cat <<EOF > $tmp1
# "Field Header Card"                                                                                                                                             
"\
SIMPLE  =                    T                                                  \
BITPIX  =                    0                                                  \
NAXIS   =                    2                                                  \
NAXIS1  =               $w                                                  \
NAXIS2  =               $h                                                  \
END                                                                             \
"
EOF
    stilts tcopy ifmt=ascii ofmt=fits-basic $tmp1 $tmp2
    sethead $tmp2",1" EXTNAME=LDAC_IMHEAD

    # extract column names
    grep "^#" $tmpin | awk '{if($2~/^[0-9]+$/) x=x" "$3}END{print "#"x}' > $tmp1
    grep -v "^#" $tmpin >> $tmp1
    stilts tcopy ifmt=ascii ofmt=fits-basic $tmp1 $tmp3
    sethead $tmp3",1" EXTNAME=LDAC_OBJECTS
    stilts tmulti ifmt=fits ofmt=fits-basic in=$tmp2 in=$tmp3 out=$out
    
    # modify EXTNAME for tables
    sethead $out",1" TDIM1='(80,0)'
    
    cat $out
    rm $tmpin $tmp1 $tmp2 $tmp3 $out
}


addldacwcs () {
    # add simple wcs to LDAC_IMHEAD
    # note: only first 3 HDU's of input FITS file are used
    local scat=$1
    local wcshead=$2
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpcat=$(mktemp "$tdir/tmp_incat_XXXXXX.fits")
    local tmpdat=$(mktemp "$tdir/tmp_imhead_XXXXXX.dat")
    local tmptab=$(mktemp "$tdir/tmp_tab_XXXXXX.dat")
    local tmp1=$(mktemp "$tdir/tmp_tmp1_XXXXXX.fits")
    local tmp2=$(mktemp "$tdir/tmp_tmp2_XXXXXX.fits")
    
    test "$scat" == "-" && scat="/dev/stdin"
    cp $scat $tmpcat
    stilts tpipe in=$tmpcat"#"1 ofmt=csv | fold | \
        grep -vwE "^Field Header Card|^END" | \
        grep -vE "^FITS|^SEX" | \
        sed -e '/^BITPIX /s/16/ 0/' > $tmpdat
    grep -vw "^END" $wcshead | while read
    do
        printf "%-80s\n" "$REPLY"
    done >> $tmpdat
    printf "%-80s\n" "END" >> $tmpdat

    # create LDAC_IMHEAD table
    echo '# "Field Header Card"' > $tmptab
    printf '"' >> $tmptab
    cat $tmpdat | tr -d '\n' >> $tmptab
    echo '"' >> $tmptab
    stilts tcopy ifmt=ascii ofmt=fits-basic $tmptab $tmp1
    sethead $tmp1",1" EXTNAME=LDAC_IMHEAD
    sethead $tmp1",1" TDIM1='(80,0)'

    stilts tcopy ifmt=fits ofmt=fits-basic in=${tmpcat}"#"2 out=$tmp2
    stilts tmulti ifmt=fits ofmt=fits-basic in=$tmp1 in=$tmp2
    
    
    rm -f $tmpcat $tmpdat $tmptab $tmp1 $tmp2
}


# create RGB photometry data file (to stdout) from sextractor output catalog as
# produced by AIsource, for 3-color input images a crossmatching of sources
# is performed
# TODO: optionally keep crossmatched FITS table (includes all data from R/B channels
#   in columns which have _R or _B appended to the name)
sex2rgbdat () {
    local showhelp
    local i
    for i in $(seq 1 2)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    done
    
    local scat=$1
    local rad=$2        # match radius between colors in pixels
    local reg=${3:-""}  # ds9 region file to filter data
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmptab1=$(mktemp "$tdir/tmp_tab1_XXXXXX.fits")
    local tmptab2=$(mktemp "$tdir/tmp_tab2_XXXXXX.fits")
    local colnames
    local xcol
    local ycol
    local cmd
    local str
    local w
    local h

    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: sex2rgbdat <srccat> <rmax> [region]" >&2 &&
        return 1
    
    test ! -e "$scat" &&
        echo "ERROR: input catalog $scat not found." >&2 && return 255
    ! is_fits "$scat" &&
        echo "ERROR: input catalog $scat not in FITS format." >&2 && return 255
    #! is_sexcat $scat &&
    #    echo "ERROR: $scat is not a sextractor output catalog." >&2 && return 255
    
    # get original image height from LDAC_IMHEAD in scat
    w=$(stilts tpipe in=$scat"#"1 ofmt=fits-basic | fold | grep "[[:alnum:]]" | \
        grep -A 100000 "EXTNAME .*LDAC_IMHEAD" | \
        grep NAXIS1 | head -1 | awk '{print $3}')
    h=$(stilts tpipe in=$scat"#"1 ofmt=fits-basic | fold | grep "[[:alnum:]]" | \
        grep -A 100000 "EXTNAME .*LDAC_IMHEAD" | \
        grep NAXIS2 | head -1 | awk '{print $3}')

    # determine x,y column names
    colnames=$(stilts tpipe omode=meta in=$scat"#"4 | grep "^[ ]* [0-9]" | \
        sed -e 's/(.*//' | tr ' ' '\n' | grep -vE "^$|^[0-9]") #)
    xcol=$(echo "$colnames" | grep "^X" | head -1)
    ycol=$(echo "$colnames" | grep "^Y" | head -1)
    
    # matching R with respect to G
    stilts tskymatch2 in1=$scat"#"4 in2=$scat"#"2 ra1=$xcol/3600 ra2=$xcol/3600 \
        dec1=$ycol/3600 dec2=$ycol/3600 error=$rad find=best1 ofmt=fits-basic > $tmptab1
    # rename columns
    colnames=$(stilts tpipe omode=meta in=$tmptab1 | grep "^[ ]* [0-9]" | \
        sed -e 's/(.*//' | tr ' ' '\n' | grep -vE "^$|^[0-9]") #)
    cmd=$(echo "$colnames" | awk '{
        x=$1; sub(/_[12]/,"",x)
        if ($1~/^Separation$/) printf("colmeta -name %s_R %s;", x, $1)
        if ($1~/_1$/) printf("colmeta -name %s   %s;", x, $1)
        if ($1~/_2$/) printf("colmeta -name %s_R %s;", x, $1)}')
    stilts tpipe in=$tmptab1 ifmt=fits cmd="$cmd" ofmt=fits-basic > $tmptab2
    
    # matching B with respect to G
    stilts tskymatch2 in1=$tmptab2  in2=$scat"#"6 ra1=$xcol/3600 ra2=$xcol/3600 \
        dec1=$ycol/3600 dec2=$ycol/3600 error=$rad find=best1 ofmt=fits-basic > $tmptab1
    # rename columns
    colnames=$(stilts tpipe omode=meta in=$tmptab1 | grep "^[ ]* [0-9]" | \
        sed -e 's/(.*//' | tr ' ' '\n' | grep -vE "^$|^[0-9]") #)
    cmd=$(echo "$colnames" | awk '{
        x=$1; sub(/_[12]/,"",x)
        if ($1~/^Separation$/) printf("colmeta -name %s_B %s;", x, $1)
        if ($1~/_1$/) printf("colmeta -name %s   %s;", x, $1)
        if ($1~/_2$/) printf("colmeta -name %s_B %s;", x, $1)}')
    stilts tpipe in=$tmptab1 ifmt=fits cmd="$cmd" ofmt=fits-basic > $tmptab2

    # write photometry data file
    test "$reg" && regfilter $tmptab2 $reg > $tmptab1 && mv $tmptab1 $tmptab2
    str="FWHM_IMAGE,MAG_AUTO,MAGERR_AUTO,FLAGS,MAG_AUTO_R,Sep*_R,MAG_AUTO_B,Sep*_B"
    stilts tpipe in=$tmptab2 ifmt=fits \
        cmd="keepcols \"NUMBER X*IMAGE Y*IMAGE A*IMAGE ${str//,/ }\"" \
        ofmt=ascii | awk -v h=$h '{
            if ($1~/^#/) next
            printf("%-10s  %7.2f %7.2f  %5.2f %5.2f %5.2f  %3d %3d  %4d %3d %.3f\n",
                $1, $2-0.5, h-$3+0.5, $9, $6, $11, 0, 0, 0, 0, $7)
        }'

    rm -f $tmptab1 $tmptab2
    return
}


sdensity () {
    # determine source density in a star stack (per square degree)
    local showhelp
    local quiet # suppress output from AIsource
    local all   # if set show additional values: nsrc area
    local i
    for i in $(seq 1 2 3)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-a" && all=1  && shift 1
        test "$1" == "-q" && quiet=1 && shift 1
    done
    local set=$1
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpim=$(mktemp "$tdir/tmp_im1_$$.XXXXXX.pnm")
    local tmpcat=$(mktemp "$tdir/tmp_src_$$.XXXXXX.dat")
    local ststack
    local binning
    local pixscale
    local magzero
    local sopt
    local nsrc
    local area
    local dens

    (test "$showhelp" || test $# -ne 1) &&
        echo "usage: sdensity [-a] <set>" >&2 &&
        return 1
        
    # check for ststack and header file
    ststack=""
    test -f $set.pgm && ststack=$set.pgm
    test -f $set.ppm && ststack=$set.ppm
    test -z "$ststack" &&
        echo "ERROR: missing star stack $set.p[gp]m" >&2 && return 255
    ! test -e $set.head &&
        echo "ERROR: missing header file $set.head" >&2 && return 255
    
    # determine pixscale
    pixscale=""
    binning=""
    test -z "$binning" && binning=$(get_header -q $set.head BINNING)
    test -z "$binning" && binning=$(get_header -q $set.head XBINNING)
    test -z "$binning" && binning=1
    pixscale=$(get_param camera.dat pixscale $set | \
        awk -v b=$binning '{print $1*b}')
    test -z "$pixscale" &&
        error "unknown pixscale in $set"

    magzero=$(get_header -q $set.head MAGZERO)
    test -z $magzero && magzero=25
    imcrop $ststack 50 > $tmpim
    test "$quiet" && sopt="-q"
    AI_MAGZERO=$magzero AIsource $sopt -2 -o $tmpcat $tmpim "" 30
    nsrc=$(sexselect -s $tmpcat | tail -1 | awk '{print $7*4}')
    area=$(echo $pixscale $(imsize $tmpim) | \
        awk '{a=4*$1*$1*$2*$3/3600/3600; fmt="%.3f"
            if (a > 0.7) fmt="%.2f"
            if (a > 7) fmt="%.1f"
            printf(fmt, a)}')
    dens=$(echo $nsrc $area | awk '{printf("%.0f", $1/$2)}')
    
    test -z "$all" && echo $dens
    test    "$all" && echo $dens $nsrc $area
    rm -f $tmpim $tmpcat
    return 0
}


# select subset from sextractor catalog file to stdout
# only objects from a single color channel are extracted
sexselect () {
    # TODO: deal with tables where NUMBER is missing
    local showhelp
    local color         # set color channel to use (1 or 2 or 3) if
                        # source catalog contains multiple ext_numbers
                        # default: 2
    local outstats      # instead of listing object show some statistics
    local outregion     # change output format to ds9 region file
    local outfits       # change output format to FITS_LDAC table
    local outxy         # change coordinate system to image pixel in output
    local verbose
    local i
    for i in $(seq 1 7)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-s" && outstats=1  && shift 1
        test "$1" == "-r" && outregion=1 && shift 1
        test "$1" == "-f" && outfits=1   && shift 1
        test "$1" == "-x" && outxy=1     && shift 1
        (test "$1" == "-1" || test "$1" == "-2" || test "$1" == "-3") &&
            color=${1#-} && shift 1
        test "$1" == "-v" && verbose=1 && shift 1
    done
    local scat=$1
    local maglim=${2:-""}
    local magerrlim=${3:-""}
    local rrange=${4:-""}    # rmin,rmax or rmax
    local center=${5:-""}    # xc,yc in FITS coordinates
    local columns=${6:-""}
    local flagsmax=${7:-"3"}
    local w
    local h
    local filter
    local rmin
    local rmax
    local xc
    local yc
    local idcol
    local xcol
    local ycol
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmp1=$(mktemp "$tdir/tmp_tmp1_XXXXXX.fits")
    local tmp2=$(mktemp "$tdir/tmp_tmp2_XXXXXX.dat")
    local tmp3=$(mktemp "$tdir/tmp_tmp3_XXXXXX.fits")
    local cmds=$(mktemp "$tdir/tmp_cmds_XXXXXX.txt")
    local tmpcat=$(mktemp "$tdir/tmp_stdin_XXXXXX.dat")

    # set default columns
    test -z "$columns" &&
        columns="NUM*,X*,Y*,A*,ELONGATION,FWHM_IMAGE,MAG_AUTO,MAGERR_AUTO,FLAGS"
    test "$outregion" && columns="NUMBER,X*,Y*,FWHM*,MAG_AUTO"
    test "$outstats"  && columns="AWIN*,BWIN*,FWHM*,MAG_AUTO"

    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: sexselect [-s|-r|-f|-x] [-1|2|3] <scat> [maglim|$maglim]"\
            "[magerrlim|$magerrlim] [rrange] [fcenter] [columns|$columns]"\
            "[flagsmax|$flagsmax]" >&2 &&
        return 1

    # handle reading scat from stdin
    if [ "$scat" == "-" ]
    then
        cat > $tmpcat
        scat=$tmpcat
    fi
    test ! -f "$scat" &&
        echo "ERROR: input catalog $scat not found." >&2 && return 255
    
    # checkings
    test "$maglim" &&    ! is_integer ${maglim%.*} &&
        echo "ERROR: maglim=$maglim is not a number." >&2 && return 255
    test "$magerrlim" && ! is_integer ${magerrlim%.*} &&
        echo "ERROR: magerrlim=$magerrlim is not a number." >&2 && return 255
    test "$rrange" &&    ! is_integer ${rrange%,*} &&
        echo "ERROR: rrange=$rrange does not start with an integer." >&2 && return 255
    test "$center" &&    ! is_integer ${center%,*} &&
        echo "ERROR: center=$center does not start with an integer." >&2 && return 255

    # get original image height from LDAC_IMHEAD in scat
    w=$(stilts tpipe in=$scat"#"1 ofmt=fits-basic | fold | grep "[[:alnum:]]" | \
        grep -A 100000 "EXTNAME .*LDAC_IMHEAD" | \
        grep NAXIS1 | head -1 | awk '{print $3}')
    h=$(stilts tpipe in=$scat"#"1 ofmt=fits-basic | fold | grep "[[:alnum:]]" | \
        grep -A 100000 "EXTNAME .*LDAC_IMHEAD" | \
        grep NAXIS2 | head -1 | awk '{print $3}')

    # convert input catalog
    if is_fits $scat
    then
        cp $scat $tmp1
    else
        echo "ERROR: not implemented yet." >&2 && return 255
        ahead2ldac -$color $scat > $tmp1
        test "$color" && color=1
    fi

    # determine extension number going to be used
    test -z "$color" &&
        test $(listhead $tmp1 | grep "EXTNAME = 'LDAC_OBJECTS'" | wc -l) -gt 1 &&
        color=2
    test -z "$color" && color=1
    
    # determine x and y ranges to get approximate center and rrange
    if is_number $flagsmax
    then
        filter="flags<=$flagsmax"
    else
        filter="flags$flagsmax"
    fi
    stilts tpipe ofmt=ascii cmd='
        select "'$filter'"
        keepcols "X* Y*"
        stats name minimum maximum ngood' in=${tmp1}"#"$((color*2)) > $tmp2
    if [ -z "$center" ]
    then
        center=$((w/2))","$((h/2))
    fi
    if [ -z "$rrange" ]
    then
        rrange=$(echo $w $h | awk '{
            rmax=sqrt($1*$1+$2*$2)
            printf("0,%.2f", rmax)
        }')
    fi
    xc=${center%,*}
    yc=${center#*,}
    rmin=${rrange%,*}
    rmax=${rrange#*,}
    rmin=$(echo $rmin $rmax | awk '{if($1>=$2) {print 0} else {print $1}}')
    # get X,Y column names
    xcol=$(grep "^[ ]*X.*_IMAGE" $tmp2 | awk '{print $1}')
    ycol=$(grep "^[ ]*Y.*_IMAGE" $tmp2 | awk '{print $1}')
    test "$verbose" && echo "# center=$center xc=$xc yc=$yc" >&2
    
    # construct filter string
    if is_number $flagsmax
    then
        filter="flags<=$flagsmax"
    else
        filter="flags$flagsmax"
    fi
    test "$magerrlim" && filter="$filter && magerr_auto<$magerrlim"
    test "$maglim"    && filter="$filter && mag_auto<$maglim"
    test "$verbose" && echo "# $filter && r<$rmax && r>=$rmin" >&2
    
    echo 'select "'"$filter"'"
        addcol DX "'$xcol'-'$xc'"
        addcol DY "'$ycol'-'$yc'"
        addcol R "sqrt(DX*DX+DY*DY)"
        select "R<'$rmax' && R>='$rmin'"
        keepcols "'"${columns//,/ }"'"' > $cmds
    test "$verbose" && cat $cmds >&2
    if [ "$outstats" ]
    then
        echo 'stats name q.4 mean stdev minimum maximum ngood' >> $cmds
    fi
    # cat $cmds >&2
    
    if [ "$outfits" ]
    then
        stilts tcopy ifmt=fits ofmt=fits-basic in=${tmp1}"#"$((color*2-1)) out=$tmp3
        stilts tpipe ofmt=fits cmd="@$cmds" in=${tmp1}"#"$((color*2)) out=$tmp2
        stilts tmulti ifmt=fits ofmt=fits-basic in=$tmp3 in=$tmp2
    else
        stilts tpipe ofmt=ascii cmd="@$cmds" in=${tmp1}"#"$((color*2)) out=$tmp2
        head -1 $tmp2 | tr ' ' '\n' | grep -i "[a-z]" > $tmp3
        idcol=$(grep -n "^NUMBER" $tmp3 | cut -d ":" -f1 | head -1)
        xcol=$(grep -n  "^X"      $tmp3 | cut -d ":" -f1 | head -1)
        ycol=$(grep -n  "^Y"      $tmp3 | cut -d ":" -f1 | head -1)
        if [ "$outregion" ]
        then
            echo -e "# Region file format: DS9 version 4.1\nglobal " \
                "color=green dashlist=8 3 width=1" \
                "font=\"helvetica 10 normal roman\" select=1 highlite=1" \
                "dash=0 fixed=1 edit=0 move=0 delete=1 include=1" \
                "source=1\nphysical"
            cat $tmp2 | awk '{
                if ($1~/^#/) next
                printf("circle(%.2f,%.2f,%.2f)", $2, $3, 2*$4)
                printf(" # text={%s %.1f}\n", $1, $5)
            }'
        else
            if [ "$outxy" ]
            then
                cat $tmp2 | awk -v w=$w -v h=$h -v xcol=$xcol -v ycol=$ycol '{
                    if ($0 ~ /^#/) {print $0; next}
                    for (i=1; i<=NF; i++) {
                        if (i==xcol) {
                            printf(" %9.3f", $xcol-0.5)
                        } else {
                            if (i==ycol) {
                                printf(" %9.3f", h-$ycol+0.5)
                            } else {
                                printf(" %s", $i)
                            }
                        }
                    }
                    printf("\n")
                }'
            else
                cat $tmp2
            fi
        fi
    fi
    rm $tmp1 $tmp2 $tmp3 $cmds $tmpcat
    return
}


# convert objects data file containing id, x, y to sextractor ASCII_HEAD
# format
xy2ahead () {
    local showhelp
    for i in 1
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    done
    local xydat=$1
    local img=$2
    local colnums=${3:-"1,2,3"}
    local fwhm=${4:-"3.0"}
    local idcol
    local xcol
    local ycol
    local h
    local fits=$(mktemp /tmp/tmp_img_XXXXXX.fits)
    local tmp1=$(mktemp /tmp/tmp_tmp1_XXXXXX.dat)
    
    (test "$showhelp" || test $# -lt 2) &&
        echo -e "usage: xy2ahead <xydat> <img> [idcol,xcol,ycol|$colnums] [fwhm|$fwhm]" >&2 &&
        return 1

    test "$xydat" != "-" && test ! -f "$xydat" &&
        echo "ERROR: datafile $xydat not found." >&2 && return 255
    test ! -f "$img" &&
        echo "ERROR: input image $img not found." >&2 && return 255
    test "$xydat" == "-" && xydat=/dev/stdin
    set - ${colnums//,/ }
    test $# -ne 3 &&
        echo "ERROR: unknown column specification." >&2 &&
        return 255
    idcol=$1; xcol=$2; ycol=$3
    h=$(identify $img | cut -d " " -f3 | cut -d "x" -f2)

    echo "#  1 NUMBER
#  2 EXT_NUMBER
#  3 XWIN_IMAGE
#  4 YWIN_IMAGE
#  5 AWIN_IMAGE
#  6 ELONGATION
#  7 FWHM_IMAGE
#  8 MAG_AUTO
#  9 MAGERR_AUTO
# 10 FLAGS"
    cat $xydat | awk -v h=$h -v cid=$idcol -v cx=$xcol -v cy=$ycol \
        -v a=2.0 -v e=1.0 -v f=$fwhm -v m=10.0 -v me=0.02 '{
            if ($1~/^#/) next
            printf("%12s 1 %8.3f %8.3f %s %s %s %s %s 0\n",
                $cid, $cx+0.5, h-$cy+0.5, a, e, f, m, me)
        }'
}

mkwcs () {
    # create simple wcs header file (assuming binning=1)
    local showhelp
    local distort   # it set, add cubic distortion keywords to wcs header
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-d" && distort="$2" && shift 2
    done
    local setname=$1
    local rahms=$2  # center coordinates
    local dedms=$3
    local north=${4:-"0"}
    local pscale=${5:-""}
    
    local tmphdr=$(mktemp "/tmp/tmp_wcs_XXXXXX.head")
    local img
    local size
    local line
    
    (test "$showhelp" || test $# -lt 3) &&
        echo -e "usage: mkwcs <setname|wxh> <ra> <de> [north] [pscale]" >&2 &&
        return 1

    echo $setname | grep -q "^[0-9][0-9]*x[0-9][0-9]*$"
    if [ $? -eq 0 ]
    then
        size=$setname
    else
        test -z "$img" && test -f $setname.ppm && img=$setname.ppm
        test -z "$img" && test -f $setname.pgm && img=$setname.pgm
        test -z "$img" && test -f $setname     && img=$setname
        test -z "$img" && echo "ERROR: cannot find image for $setname." >&2 && return 255
        size=$(identify $img | cut -d ' ' -f3)
        test -z "$pscale" && pscale=$(get_param camera.dat pixscale $setname)
    fi
    test -z "$pscale" && echo "ERROR: unknown pixscale." >&2 && return 255
    
    # initial header
    echo "\
EQUINOX =        2000.00000000 / Mean equinox                                  
RADESYS = 'ICRS    '           / Astrometric system                            
CTYPE1  = 'RA---TAN'           / WCS projection type for this axis             
CTYPE2  = 'DEC--TAN'           / WCS projection type for this axis             
CUNIT1  = 'deg     '           / Axis unit                                     
CUNIT2  = 'deg     '           / Axis unit                                     " > $tmphdr
    
    # center coordinates
    set_header $tmphdr CRVAL1=$(sexa2dec $rahms 15) CRVAL2=$(sexa2dec $dedms)
    set_header $tmphdr CRPIX1=$(echo $size | awk -F "x" '{printf("%.1f", $1/2+0.5)}')
    set_header $tmphdr CRPIX2=$(echo $size | awk -F "x" '{printf("%.1f", $2/2+0.5)}')
    
    # wcs matrix
    line=$(echo $pscale $north | awk '{
        r=$1/3600; y=r*sin($2*3.1416/180); x=r*cos($2*3.1416/180);
        printf("%.8f %.8f %.8f %.8f\n", -1*x, -1*y, -1*y, x)
    }')
    set - $line
    set_header $tmphdr CD1_1=$1 CD1_2=$2 CD2_1=$3 CD2_2=$4
    
    # cubic distortion
    # x'= x * r' / r
    #   = x * r * (1 + distort3 * r²) / r
    #   = x + distort3 * x * (x² + y²)
    #   = x + distort3 * x³ + distort3 * x * y²
    if [ "$distort" ]
    then
        set_header $tmphdr PV1_0=0          # 1
        set_header $tmphdr PV1_1=1          # x
        set_header $tmphdr PV1_2=0          # y
        set_header $tmphdr PV1_4=0          # x²
        set_header $tmphdr PV1_5=0          # xy
        set_header $tmphdr PV1_6=0          # y²
        set_header $tmphdr PV1_7=${distort} # x³
        set_header $tmphdr PV1_8=0          # x²y
        set_header $tmphdr PV1_9=${distort} # xy²
        set_header $tmphdr PV1_10=0         # y³
        set_header $tmphdr PV2_0=0          # 1
        set_header $tmphdr PV2_1=1          # y
        set_header $tmphdr PV2_2=0          # x
        set_header $tmphdr PV2_4=0          # y²
        set_header $tmphdr PV2_5=0          # xy
        set_header $tmphdr PV2_6=0          # x²
        set_header $tmphdr PV2_7=${distort} # y³
        set_header $tmphdr PV2_8=0          # y²x
        set_header $tmphdr PV2_9=${distort} # yx²
        set_header $tmphdr PV2_10=0         # x³
        #set_header $tmphdr FGROUPNO=                    1 / SCAMP field group label
        #set_header $tmphdr ASTINST =                    1 / SCAMP astrometric instrument label
        #set_header $tmphdr FLSCALE =   1.000000000000E+00 / SCAMP relative flux scale
        #set_header $tmphdr MAGZEROP=           0.00000000 / SCAMP zero-point
        #set_header $tmphdr PHOTINST=                    1 / SCAMP photometric instrument label
        #set_header $tmphdr PHOTLINK=                    F / True if linked to a photometric field
    fi
    cat $tmphdr
    rm -f $tmphdr
    
}

mkregheader () {
    # create artificial header files for stacking without x-y-shift
    local setname=$1
    local object
    local nref
    local img
    local w
    local h
    local cx
    local cy
    local pscale
    local num
    local texp
    local jd
    
    set - $(AIsetinfo $setname)
    object=$2
    nref=$4
    img=$AI_TMPDIR/$nref.ppm
    test ! -e $img && img=$AI_TMPDIR/$nref.pgm
    test ! -e $img &&
        echo "ERROR: missing reference image $img (run AIccd first)." >&2 &&
        return 255
    test -z "$day" &&
        echo "ERROR: day is undefined." >&2 && return 255
    
    w=$(identify $img | cut -d " " -f3 | cut -d "x" -f1)
    h=$(identify $img | cut -d " " -f3 | cut -d "x" -f2)
    cx=$(echo $w | awk '{printf("%.3f", $1/2+0.5)}')
    cy=$(echo $h | awk '{printf("%.3f", $1/2+0.5)}')
    pscale=0.0003
    
    test ! -d measure && mkdir measure
    for num in $(AIimlist -n $setname)
    do
        test -e measure/$num.src.head &&
            echo "WARNING: skipping $num, measure/$num.src.head exists." >&2 &&
            continue
        set - $(grep "^$num." exif.dat)
        texp=$4
        jd=$(ut2jd $3 $day)
        echo "OBJECT  = '$object'
EXPTIME =    $texp       / Exposure time in seconds
MJD_OBS =      $jd  / Time of observation in julian days
EPOCH   =      2000.0  / Epoch
EQUINOX =      2000.0  / Mean equinox
RADESYS = 'ICRS    '           / Astrometric system                            
CTYPE1  = 'RA---TAN'   / WCS projection type for this axis
CUNIT1  = 'deg     '   / Axis unit
CRVAL1  =      10.0    / World coordinate on this axis
CRPIX1  =      $cx     / Reference pixel on this axis
CD1_1   =      -$pscale   / Linear projection matrix
CD1_2   =      0          / Linear projection matrix
CTYPE2  = 'DEC--TAN'   / WCS projection type for this axis
CUNIT2  = 'deg     '   / Axis unit
CRVAL2  =      0.0     / World coordinate on this axis
CRPIX2  =      $cy     / Reference pixel on this axis
CD2_1   =      0          / Linear projection matrix
CD2_2   =      $pscale    / Linear projection matrix
PHOTFLAG=      F
END     " > measure/$num.src.head
    done
    return
}



#-------------------------------
#   low level image operations
#-------------------------------

mkpgm () {
    # create gray image with given intensity
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    local val=$1
    local w=$2
    local h=$3
    local oname=${4:-"-"}

    (test "$showhelp" || test $# -lt 3) &&
        echo "usage: mkpgm <val> <w> <h> [outname]" >&2 &&
        return 1
    ppmmake "black" $w $h | pnmdepth 65535 - | ppmtopgm | \
        pnmccdred -a $val - $oname
}

mkppm () {
    # create gray image with given intensity
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    local val=$1
    local w=$2
    local h=$3
    local oname=${4:-"-"}

    (test "$showhelp" || test $# -lt 3) &&
        echo "usage: mkppm <val> <w> <h> [outname]" >&2 &&
        return 1
    ppmmake "black" $w $h | pnmdepth 65535 - | \
        pnmccdred -a $val - $oname
}

ppm2gray () {
    # convert from ppm to gray image, result goes to stdout
    # using a specific set of color ratios (other than ppmtopgm!)
    # this function replaces ppmtograyfits as of 130614
    local outfits    # if set create FITS format output file instead of PGM
    local quiet      # do not report warning upon writing keywords containing umlauts
    local showhelp
    local cboxsize   # if set then keep data in center box of given size
    local wcshead
    local rgb_ratios="0.26,0.40,0.34"
    for i in $(seq 1 6)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-f" && outfits=1 && shift 1
        test "$1" == "-q" && quiet=1 && shift 1
        test "$1" == "-c" && cboxsize=$2 && shift 2
        test "$1" == "-w" && wcshead=$2 && shift 2
        test "$1" == "-r" && rgb_ratios="$2" && shift 2
    done
    local ppm=${1:-"-"}
    local head=${2:-""}     # ascii header file containing FITS keywords
    local line
    local tmpim=$(mktemp "/tmp/tmp_im_XXXXXX.img")
    local tmp1=$(mktemp "/tmp/tmp1_XXXXXX.img")
    local tmpmask=$(mktemp "/tmp/tmp_mask_XXXXXX.pgm")
    local tmpppm=$(mktemp "/tmp/tmp_in_XXXXXX.pnm")
    local tmpkeys=$(mktemp "/tmp/tmp_keys_XXXXXX.head")
    local wdir=$(mktemp -d "/tmp/tmp_ppm2gray_XXXXXX")
    local str1
    local str2
    local w
    local h
    local key

    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: ppm2gray [-f] [-w wcshead] [-r rgbratio|$rgb_ratios] <ppm> [fitshdr]" >&2 &&
        return 1
    test "$ppm" != "-" && test ! -f "$ppm" &&
        echo "ERROR: ppm file $ppm not found." >&2 &&
        return 255
    test "$outfits" && test "$head" && test ! -f "$head" &&
        echo "ERROR: ascii FITS header file $head not found." >&2 &&
        return 255
    test "$outfits" && test "$wcshead" && test ! -f "$wcshead" &&
        echo "ERROR: ascii FITS header file $wcshead not found." >&2 &&
        return 255

    # handle input from stdin
    test "$ppm" == "-" &&
        cat > $tmpim && ppm=$tmpim

    # check format of $rgb_ratios
    str1=$(echo $rgb_ratios | awk -F ',' '{print NF" "1*$1","1*$2","1*$3}')
    # strip zeros from end of decimal numbers
    str2="3 "$(echo $rgb_ratios | tr ',' '\n' | \
        sed -e '/\./s|[0]*$||; s|\.$||' | tr '\n' ',' | sed -e 's|,$||')
    test "$str1" != "$str2" &&
        echo "ERROR: rgb_ratios in unsupported format (use: r,g,b)." >&2 &&
        echo "DEBUG:  $str1  $str2" >&2 &&
        return 255
    
    # blank any data outside of the given center box
    if [ "$cboxsize" ]
    then
        w=$(identify $ppm | cut -d " " -f3 | cut -d "x" -f1)
        h=$(identify $ppm | cut -d " " -f3 | cut -d "x" -f2)
        mkpgm 65535 $cboxsize $cboxsize | pnmpad -width $w -height $h - > $tmpmask
        pnmarith -mul $ppm $tmpmask 2>/dev/null > $tmpppm
        ppm=$tmpppm
    fi
    
    set - ${rgb_ratios//,/ }
    if [ "$outfits" ]
    then
        #convert "$setname" -channel G -separate - | ppmtopgm - | pnmtomef - > $sfits
        if is_ppm $ppm
        then
            # old:
            false && convert $ppm \
                -channel R  -evaluate multiply $1 \
                -channel G  -evaluate multiply $2 \
                -channel B  -evaluate multiply $3 \
                +channel -separate \
                -background black -compose plus -flatten - | \
                ppmtopgm - | pnmtomef - > $tmp1
            # new:
            gm convert $ppm -operator Red multiply $1 \
                -operator Green multiply $2 \
                -operator Blue  multiply $3 - | \
            (cd $wdir; ppmtorgb3 &&
                pnmarith -add noname.red noname.grn | pnmarith -add - noname.blu | \
                pnmtomef - > $tmp1)
        else
            pnmtomef $ppm > $tmp1
        fi
        
        if [ -f "$head" ]
        then
            # skip some keywords and replace umlauts
            grep -Ev "^BITPIX|^NAXIS |^NAXIS[1-9] " $head | \
                grep -Ev "^BSCALE |^BZERO |^HISTORY|^COMMENT|^END" | \
                grep -Ev "^RADESYS |^CUNIT[0-9] " | \
                grep -Ev "^FILE[0-9][0-9]|^WGHT[0-9][0-9]|^WGTT[0-9][0-9]|^INTF[0-9][0-9]|^SUBF[0-9][0-9]|^BCKT[0-9][0-9]|^BCKS[0-9][0-9]|^BKFS[0-9][0-9]" | \
                sed -e 's|[ ]*=[ ]*|=|' | tr 'öäüßÄÖÜ' '?' | awk -F "'" '{
                    #if(NF>1) {gsub("/"," ",$2)}
                    printf("%s", $1)
                    if(NF>1) {
                        printf("\047%s", $2)
                        if (length($2)>18) {
                            # skip comment
                            printf("\047")
                        } else {
                            for (i=3;i<=NF;i++) {printf("\047%s", $i)}
                        }
                    }
                    printf("\n")}' > $tmpkeys
            test "$AI_DEBUG" && echo "# keys: $tmpkeys" >&2
            sethead $tmp1 @$tmpkeys
            # workaround: delete malformed string keywords (truncated long strings)
            # note: should be handled already by last awk command
            listhead $tmp1 | grep "'" | awk -F "'" '{if(NF==2){print $0}}' | cut -c 1-8 | \
            while read key
            do
                # grep "^${key}=" $tmpkeys
                echo "WARNING: deleting key: $key" >&2
                delhead $tmp1 $key
            done
            #delwcs $tmp1
        fi
        if [ -f "$wcshead" ]
        then
            grep -Ev "^BITPIX|^NAXIS |^NAXIS[1-9] " $wcshead | \
                grep -Ev "^BSCALE |^BZERO |^HISTORY|^COMMENT|^END" | \
                sed -e 's|[ ]*=[ ]*|=|' | tr 'öäüßÄÖÜ' '?' | awk -F "'" '{
                    #if(NF>1) {gsub("/"," ",$2)}
                    printf("%s", $1)
                    if(NF>1) {
                        printf("\047%s", $2)
                        if (length($2)>18) {
                            # skip comment
                            printf("\047")
                        } else {
                            for (i=3;i<=NF;i++) {printf("\047%s", $i)}
                        }
                    }
                    printf("\n")}' > $tmpkeys
            test "$AI_DEBUG" && echo "# keys: $tmpkeys" >&2
            sethead $tmp1 @$tmpkeys
            # workaround: delete malformed string keywords (truncated long strings)
            listhead $tmp1 | grep "'" | awk -F "'" '{if(NF==2){print $0}}' | cut -c 1-8 | \
            while read key
            do
                # grep "^${key}=" $tmpkeys
                echo "WARNING: deleting key: $key" >&2
                delhead $tmp1 $key
            done
        fi
        cat $tmp1
    else
        if is_ppm $ppm
        then
            # old:
            false && convert $ppm \
                -channel R  -evaluate multiply $1 \
                -channel G  -evaluate multiply $2 \
                -channel B  -evaluate multiply $3 \
                +channel -separate \
                -background black -compose plus -flatten - | \
                ppmtopgm -
            # new:
            gm convert $ppm -operator Red multiply $1 \
                -operator Green multiply $2 \
                -operator Blue  multiply $3 - | \
            (cd $wdir; ppmtorgb3 &&
                pnmarith -add noname.red noname.grn | pnmarith -add - noname.blu)
        else
            cat $ppm
        fi
    fi
    test ! "$AI_DEBUG" && rm $tmpkeys
    rm -f $tmp1 $tmpim $tmpmask $tmpppm
    rm -rf $wdir
    return
}


meftopnm () {
    # convert from FITS to 16bit PNM image, result goes to stdout
    # note: automatic scaling of data values is applied according to
    #   physical value = BSCALE * (storage value) + BZERO
    local showhelp
    local do_ascii_header   # if set, also create ASCII header
                            # requires command line parameter outimage
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-a" && do_ascii_header=1 && shift 1
    done
    local fits="$1"
    local nx
    local tfits
    local tdir=${AI_TMPDIR:-"/tmp"}
    local wdir=$(mktemp -d "$tdir/tmp_meftopnm_XXXXXX")
    local tmptif=$(mktemp "$wdir/tmp_im1_XXXXXX.tif")
    local tmp=$(mktemp "$wdir/tmp_im2_XXXXXX")
    local mconf=$(mktemp "$wdir/tmp_missfits_XXXXXX.conf")
    local sconf=$(mktemp "$wdir/tmp_stiff_XXXXXX.conf")

    (test "$showhelp" || test $# -ne 1) &&
        echo "usage: meftopnm [-a] <fits>" >&2 &&
        return 1
    test ! -e "$fits" &&
        echo "ERROR: fits file $fits not found." >&2 &&
        return 255
    ! is_fits "$fits" &&
        echo "ERROR: $fits is not a supported FITS file." >&2 &&
        return 255

    if [ "$do_ascii_header" ]
    then
        # replace non-ASCII characters
        listhead "$fits" | tr 'öäüßÄÖÜ' '?' | grep -aE "^........=|^END$" # | grep -vwE "^SIMPLE|^BITPIX|^NAXIS[0-9 ]|^EXTEND"
    else
        nx=1
        if is_fitsrgb "$fits"
        then
            test "$AI_DEBUG" && echo "# FITSRGB" >&2
            ln -s -r "$fits" $wdir/
            missfits -d > $mconf
            (cd $wdir;
            missfits -c $mconf -verbose_type quiet -write_xml N -save_type new -new_suffix ".miss" \
                -outfile_type split -split_suffix ".%03d.fits" "$(basename "$fits")" >/dev/null)
            nx=3
        fi
        if is_fitscube "$fits"
        then
            test "$AI_DEBUG" && echo "# FITSCUBE" >&2
            imcopy "$fits[0]" $wdir/"$(basename $fits)"
            missfits -d > $mconf
            (cd $wdir;
            missfits -c $mconf -verbose_type quiet -write_xml N -save_type new -new_suffix ".miss" \
                -outfile_type slice -slice_suffix ".%03d.fits" "$(basename "$fits")" >/dev/null)
            nx=3
        fi
        test $nx -eq 1 &&
            cp "$fits" $wdir/"$(basename "$fits" | sed -e 's/\.[^.]*$//').001.miss.fits"
        test "$AI_DEBUG" && is_number "$AI_DEBUG" && test $AI_DEBUG -gt 1 &&
            echo "# $FUNCNAME: wdir=$wdir" >&2
        
        stiff -d > $sconf
        for i in $(seq 1 $nx)
        do
            #tfits=$[tfits$i]
            tfits=$wdir/"$(basename "$fits" | sed -e 's/\.[^.]*$//').00$i.miss.fits"
            listhead "$tfits" | grep -q "^DATAMIN " || sethead "$tfits" datamin=0
            listhead "$tfits" | grep -q "^DATAMAX " || sethead "$tfits" datamax=65535
            # note: fitstopnm does not handle 32bit FITS images
            #test $nx -eq 1 && fitstopnm $tfits 2>/dev/null | pnmflip -tb
            #test $nx -ne 1 && fitstopnm $tfits 2>/dev/null | pnmflip -tb > $tmp.$i
            stiff -c $sconf -sky_type manual -min_type manual -min_level 0 \
                -max_type manual -max_level 65535 -satur_level 65535 \
                -gamma 1 -bits_per_channel 16 -write_xml N \
                -verbose_type quiet -outfile_name $tmptif "$tfits"
            test $? -ne 0 &&
                echo "ERROR: stiff failed." >&2 && return 255
            gm convert $tmptif pgm:- > $tmp.$i
        done
        if [ $nx -eq 3 ]
        then
            rgb3toppm $tmp.1 $tmp.2 $tmp.3
        else
            cat $tmp.1
        fi
    fi
    test -z "$AI_DEBUG" && rm -rf $wdir
    return
}


meftocube () {
    # convert MEF to FITS image cube (output to stdout)
    local mef=$1
    local tdir=${AI_TMPDIR:-"/tmp"}
    local wdir=$(mktemp -d "$tdir/tmp_meftocube_XXXXXX")
    local tmphdr=$(mktemp "$wdir/tmp_img_XXXXXX.head")
    local next
    local i
    local keys
    
    echo "ABORTED: program meftocube is currently disabled." >&2 &&
        return 255
    
    # TODO: replace imstack and imcopy by missfits
    
    ! type -p imstack > /dev/null 2>&1 &&
        echo "ERROR: program imstack not found." >&2 && return 255

    next=$(listhead $mef | grep HDU | wc -l)
    if [ $next -eq 1 ]
    then
        cat $mef
    else
        for i in $(seq 1 $next)
        do
            imcopy $mef[$((i-1))] - > $wdir/$i.fits
        done
        imstack -o $wdir/stack.fits $wdir/[0-9].*fits
        imhead $wdir/stack.fits | grep -vwE "^SIMPLE|^BITPIX|^NAXIS[0-9 ]|^END" > $tmphdr
        delhead $wdir/stack.fits $(cat $tmphdr | tr '=' ' ' | cut -d ' ' -f1)
        sethead $wdir/stack.fits NAXIS$next=$next
        keys=$(grep -Ev "^HISTORY|^COMMENT|^EXTEND" $tmphdr | \
            cut -d "/" -f1 | tr "'" ' ' | sed -e 's|[ ]*=[ ]*|=|' | tr '\n' ' ')
        echo $keys | grep -q "=" && sethead $wdir/stack.fits $keys
        
        #imhead $wdir/stack.fits | grep -vwE "^SIMPLE|^BITPIX|^END|^NAXIS.*" > $tmphdr
        #delhead $wdir/stack.fits $(cat $tmphdr | tr '=' ' ' | cut -d ' ' -f1)
        #sethead $wdir/stack.fits @$tmphdr
        cat $wdir/stack.fits
    fi
    test "$AI_DEBUG" && echo $wdir >&2
    test -z "$AI_DEBUG" && rm -rf $wdir
    return
}


imslice () {
    # extract slice from 3D image to stdout
    local showhelp
    local do_ascii_header   # if set, also create ASCII header
                            # requires command line parameter outimage
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-a" && do_ascii_header=1 && shift 1
    done
    local img=$1
    local slicenum=$2
    local num
    local tfits
    local tdir=${AI_TMPDIR:-"/tmp"}
    local wdir=$(mktemp -d "$tdir/tmp_mef2cube_XXXXXX")
    local mconf=$(mktemp "$wdir/tmp_missfits_XXXXXX.conf")

    (test "$showhelp" || test $# -ne 2) &&
        echo "usage: imslice <image> <slice_number>" >&2 &&
        return 1
    test ! -e "$img" &&
        echo "ERROR: image file $img not found." >&2 &&
        return 255

    ! is_fitscube $img &&
        echo "ERROR: unsupported image type (not a cube?)." >&2 &&
        return 255

    imcopy "$img[0]" $wdir/"$(basename $img)"
    missfits -d > $mconf
    (cd $wdir;
    missfits -c $mconf -verbose_type quiet -write_xml N -save_type new -new_suffix ".miss" \
        -outfile_type slice -slice_suffix ".%03d.fits" $(basename $img) >/dev/null)
    test $? -ne 0 &&
        echo "ERROR: program missfits failed." >&2 &&
        return 255
    
    num=$(echo $slicenum | awk '{printf("%03d", $1)}')
    tfits=$wdir/$(basename $img | sed -e 's/\.[^.]*$//')".$num.miss.fits"
    #delhead $tfits CTYPE3
    cat $tfits
    
    rm -rf $wdir
    return
}


mkkernel () {
    # create rectangular b/w kernel (thick line)
    # output image to stdout
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    
    local len=$1    # box width (odd number)
    local width=$2  # line width
    local angle=$3  # position angle (0=right, 90=top)
    local x
    local w
    
    (test "$showhelp" || test $# -ne 3) &&
        echo "usage: mkkernel <length> <width> <angle>" >&2 &&
        return 1
    
    x=$((len*10+1))
    w=$(echo $width | awk '{printf("%.0f", 10*$1)}')
    gm convert -size ${x}x${x} xc:white -stroke black -strokewidth $w \
        -draw "line 0,$((x/2)) $((x-1)),$((x/2))" -rotate $((-1*angle)) \
        +repage -gravity center -crop ${x}x${x}+0+0 \
        -filter box -resize ${len}x${len}! pbm:-
}


imcrop () {
    # crop image, output goes to stdout
    # crop area values w,h,x,y are truncated to multiples of <mod>, default 2
    # old style: imcrop img refpix size, only used by AIval
    local mod=2
    local showhelp
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-1" && mod=1 && shift 1
    done
    
    local img=${1:-"-"}
    local cw=${2:-"20"}
    local ch=${3:-""}   # if empty then cw is percentage
    local cx=${4:-""}   # if empty use center, else used as offset from left 
    local cy=${5:-""}   # if empty use center, else used as offset from top
    local fname
    local tmp1=$(mktemp "/tmp/tmp_img_$$.XXXXXX")
    local tmpfits=$(mktemp "/tmp/tmp_img_$$.XXXXXX.fits")
    local outfmt="pnm"
    local w
    local h
    local ret

    test "$showhelp" &&
        echo "usage: imcrop [-1] <img> [w|$cw] [h] [xoff] [yoff]> " >&2 &&
        return 1

    if [ "$img" != "-" ]
    then
        fname=$(get_imfilename $img)
        test -z "$fname" && return 255
    else
        cat "$img" > $tmp1
        fname="$tmp1"
    fi
    test ! "$cw" && echo "ERROR: imcrop: cw is empty." >&2 && return 255
    for i in $cw $ch $cx $cy
    do
        ! is_integer $i &&
            echo "ERROR: w,h,xoff,yoff is not integer." >&2 && return 255
    done
    
    # get image width and height and outfmt
    if is_raw "$fname"
    then
        line=$(dcraw-tl -i -v "$fname" | grep "^Image size:")
        w=$(echo $line | cut -d " " -f3)
        h=$(echo $line | cut -d " " -f5)
    fi
    if [ -z "$w" ] && is_fitzip "$fname"
    then
        line=$(unzip -p "$fname" | identify - | cut -d " " -f3)
        w=$(echo $line | cut -d "x" -f1)
        h=$(echo $line | cut -d "x" -f2)
    fi
    if [ -z "$w" ]
    then
        line=$(identify $fname | head -1 | cut -d " " -f3)
        w=$(echo $line | cut -d "x" -f1)
        h=$(echo $line | cut -d "x" -f2)
        is_ppm $fname && outfmt="ppm"
        is_pgm $fname && outfmt="pgm"
        is_pbm $fname && outfmt="pbm"
    fi
    
    # determine crop area
    if [ "$ch" ]
    then
        test $mod -ne 1 && ch=$((ch/mod*mod)) && cw=$((cw/mod*mod))
    else
        if [ $mod -ne 1 ]
        then
            ch=$((h*cw/100/mod*mod))
            cw=$((w*cw/100/mod*mod))
        else
            ch=$((h*cw/100))
            cw=$((w*cw/100))
        fi
    fi
    if [ "$cx" ]
    then
        test $mod -ne 1 && cx=$((cx/mod*mod))
    else
        if [ $mod -ne 1 ]
        then
            cx=$(((w-cw)/2/mod*mod))
        else
            cx=$(((w-cw)/2))
        fi
    fi
    if [ "$cy" ]
    then
        test $mod -ne 1 && cy=$((cy/mod*mod))
    else
        if [ $mod -ne 1 ]
        then
            cy=$(((h-ch)/2/mod*mod))
        else
            cy=$(((h-ch)/2))
        fi
    fi
    
    test "$AI_DEBUG" && test $AI_DEBUG -gt 1 &&
        echo "DEBUG: imcrop: crop area: ${cw}x${ch}+${cx}+${cy}" >&2
    
    if is_raw "$fname"
    then
        AIraw2gray "$fname" | \
            gm convert - -crop ${cw}x${ch}+${cx}+${cy} +repage pnm:-
    else
        if is_fits $fname
        then
            meftopnm "$fname" | \
                gm convert - -crop ${cw}x${ch}+${cx}+${cy} +repage pnm:-
        else
            if is_fitzip $fname
            then
                unzip -p "$fname" > $tmpfits
                meftopnm $tmpfits | \
                    gm convert - -crop ${cw}x${ch}+${cx}+${cy} +repage pnm:-
            else
                gm convert "$fname" -crop ${cw}x${ch}+${cx}+${cy} +repage ${outfmt}:-
            fi
        fi
    fi
    ret=$?
    rm -f $tmp1 $tmpfits
    return $ret
}

imcount () {
    local img=${1:-"-"}
    local tmp1=$(mktemp "/tmp/tmp_img_$$.XXXXXX")
    local fname

    if [ "$img" != "-" ]
    then
        fname=$(get_imfilename $img)
        test -z "$fname" && echo "ERROR: in imcount." >&2 && return 255
    else
        cat "$img" > $tmp1
        fname="$tmp1"
    fi
    identify -verbose $fname | grep -iE "geometry:|mean:" | tr 'x+:' ' ' | \
    awk '{
        if (NR==1) {s=$2*$3; next}
        if ($1!="mean" || NR>4) next
        if (NR>2) printf(",")
        printf("%.0f", $2*s)
    }END{printf("\n")}'
    rm -f $tmp1
}

imsize () {
    # get image dimension
    local img="$1"
    local str
    local type
    local retval
    local tmpfits=$(mktemp /tmp/tmp_im_XXXXXX.fits)
    
    test -z "$type" && is_raw "$img" && type=RAW
    test -z "$type" && is_fits "$img" && type=FITS
    test -z "$type" && is_fitzip "$img" && type=FITZIP
    case "$type" in
        RAW)    str=$(dcraw-tl -i -v "$img" | grep "^Output size:")
                retval=$?
                set - $(echo $str)
                str="$3 $5"
                ;;
        FITS)   str=$(get_header -q -s "$img" NAXIS1,NAXIS2,NAXIS3)
                retval=$?
                ;;
        FITZIP) unzip -p "$img" > $tmpfits
                str=$(get_header -q -s $tmpfits NAXIS1,NAXIS2,NAXIS3)
                retval=$?
                ;;
        *)      str=$(identify "$img")
                retval=$?
                test $retval -eq 0 &&
                    str=$(echo $str | cut -d ' ' -f3 | tr 'x' ' ')
                ;;
    esac
    if [ $retval -eq 0 ]
    then
        echo $str
    else
        test "$AI_DEBUG" && echo "# str=$str" >&2
    fi
    rm -f $tmpfits
    return $retval
}

imcoord () {
    # determine image coordinates
    local showhelp
    local sexagesimal=1 # default output sexagesimal values
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-d" && sexagesimal="" && shift 1
    done
    local sname=$1       # set name
    #local x=${2:-""}    # image coordinate, if empty use CRPIXn
    local img
    local nref
    local hdr
    local whdr
    local rad
    local ded
    local kw
    local str
    
    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: imcoord [-d] <set>" >&2 &&
        return 1
    
    ! is_setname $sname && ! is_ahead $sname &&
        echo "ERROR: unsupported input file" >&2 && return 255
    
    is_setname $sname && whdr=$sname.wcs.head
    is_ahead $sname && whdr=$sname
    if [ "$whdr" ] && [ -e $whdr ]
    then
        # TODO: get coordinates from wcs header file
        rad=$(dec2sexa $(grep "^CRVAL1 " $whdr | awk '{print 1*$3}') 15 0)
        ded=$(dec2sexa $(grep "^CRVAL2 " $whdr | awk '{print 1*$3}') 1 1)
        #echo $rad $ded >&2
    else
        nref=$(AIsetinfo -b $sname | head -1 | awk '{printf("%s", $8)}')
        # get ra de from $sname.head or measure/$nref.src.head
        hdr=$sname.head
        #test "$singleimage" && hdr=${sname%.*}.head
        if [ -e $hdr ]
        then
            for kw in RA RATEL OBJCTRA AI_CORA
            do
                test -z "$rad" && test -f $sname.head &&
                    rad=$(get_header -q $sname.head $kw)
                test -z "$rad" && test -f measure/$nref.src.head &&
                    rad=$(get_header -q measure/$nref.src.head $kw)
            done
            test -z "$rad" && test -f $rdir/$nref.hdr &&
                rad=$(grep "^ra=" $rdir/$nref.hdr | cut -d '=' -f2)

            for kw in DEC DETEL OBJCTDEC AI_CODEC
            do
                test -z "$ded" && test -f $sname.head &&
                    ded=$(get_header -q $sname.head $kw)
                test -z "$ded" && test -f measure/$nref.src.head &&
                    ded=$(get_header -q measure/$nref.src.head $kw)
            done
            test -z "$ded" && test -f $rdir/$nref.hdr &&
                ded=$(grep "^de=" $rdir/$nref.hdr | cut -d '=' -f2)
        fi
        test -z "$rad" &&
            echo "ERROR: unknown ra center coordinate ($sname $nref)." >&2 &&
            return 255
        test -z "$ded" &&
            echo "ERROR: unknown de center coordinate ($sname $nref)." >&2 &&
            return 255
    fi
    test -z "$rad" && str="RA"
    test -z "$ded" && test "$str" && str="$str and DEC"
    test -z "$ded" && test ! "$str" && str="DEC"
    test "$str" &&
        echo "$str coordinate is missing" >&2 && return 255
    
    # convert sexadecimal to decimal coordinates
    rad=$(echo $rad | tr ' ' ':')
    ded=$(echo $ded | tr ' ' ':')
    test "${rad/:/}" != "$rad" && rad=$(sexa2dec $(echo $rad | tr ' ' ':') 15)
    test "${ded/:/}" != "$ded" && ded=$(sexa2dec $(echo $ded | tr ' ' ':'))
    if [ "$sexagesimal" ]
    then
        echo $(dec2sexa $rad 15 0 | sed -e 's/^+//') $(dec2sexa $ded 1 1)
    else
        echo $rad $ded
    fi
    return
}


_imstat () {
    # get statistics for the given image (or stdin)
    local img=${1:-"-"}
    local fname
    if [ "$img" != "-" ]
    then
        fname=$(get_imfilename $img)
        test -z "$fname" && return 255
    else
        fname="-"
    fi
    if is_raw "$fname"
    then
        stat=$(AIraw2gray "$fname" | identify -verbose - | \
            grep -iE "min:|max:|mean:|deviation:" | \
            awk '{if ($2~/deviation/) {printf("(%.1f)\n", $3)}
                else {if ($1~/mean/) {printf("%.1f\n", $2)}
                else printf("%d\n", $2)}}')
    else
        stat=$(identify -verbose "$fname" | \
            grep -iE "min:|max:|mean:|deviation:" | \
            awk '{if ($2~/deviation/) {printf("(%.1f)\n", $3)}
                else {if ($1~/mean/) {printf("%.1f\n", $2)}
                else printf("%d\n", $2)}}' | head -12)
        is_ppm "$fname" && test $(echo $stat | wc -w) -eq 4 &&
            stat="$stat $stat $stat"
    fi
    echo $stat
}

immedian () {
    # compute median in each color channel of the given image (or stdin)
    local do_bayer
    local showhelp
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-b" && do_bayer=1 && shift 1
    done
    
    local img=${1:-"-"}
    local fname
    local stat
    local tmp1=$(mktemp "/tmp/tmp_img_$$.XXXXXX")

    (test "$showhelp" || test $# -ne 1) &&
        echo "usage: immedian [-b] <img>" >&2 &&
        return 1

    if [ "$img" != "-" ]
    then
        fname=$(get_imfilename $img)
        test -z "$fname" && return 255
    else
        cat "$img" > $tmp1
        fname="$tmp1"
    fi

    if is_raw "$fname"
    then
        stat=$(AIraw2gray "$fname" | \
            pgmhist "$fname" | grep "^[0-9]" | tr -d '%' | awk '{
                if ($3>=50) {print $1; nextfile}}')
    else
        type=$(pnmfile $fname | awk '{print $2}')
        case $type in
            PGM)    if [ "$do_bayer" ]
                    then
                        # old:
                        #c11=$(convert $fname -roll +0+0 -define sample:offset=75 -sample 50% - | \
                        #    pgmhist | grep "^[0-9]" | tr -d '%' | awk '{
                        #        if ($3>=50) {print $1; nextfile}}')
                        c00=$(gm convert $fname -roll +0+0 -filter point -resize 50% - | \
                            pgmhist | grep "^[0-9]" | tr -d '%' | awk '{
                                if ($3>=50) {print $1; nextfile}}')
                        c10=$(gm convert $fname -roll +0-1 -filter point -resize 50% - | \
                            pgmhist | grep "^[0-9]" | tr -d '%' | awk '{
                                if ($3>=50) {print $1; nextfile}}')
                        c01=$(gm convert $fname -roll -1+0 -filter point -resize 50% - | \
                            pgmhist | grep "^[0-9]" | tr -d '%' | awk '{
                                if ($3>=50) {print $1; nextfile}}')
                        c11=$(gm convert $fname -roll -1-1 -filter point -resize 50% - | \
                            pgmhist | grep "^[0-9]" | tr -d '%' | awk '{
                                if ($3>=50) {print $1; nextfile}}')
                        stat="$c00 $c01 $c10 $c11"
                    else
                        stat=$(pgmhist "$fname" | grep "^[0-9]" | tr -d '%' | awk '{
                            if ($3>=50) {print $1; nextfile}}')
                    fi
                    ;;
            PPM)    cat "$fname" | ppmtorgb3
                    r=$(pgmhist noname.red | grep "^[0-9]" | tr -d '%' | awk '{
                        if ($3>=50) {print $1; nextfile}}')
                    g=$(pgmhist noname.grn | grep "^[0-9]" | tr -d '%' | awk '{
                        if ($3>=50) {print $1; nextfile}}')
                    b=$(pgmhist noname.blu | grep "^[0-9]" | tr -d '%' | awk '{
                        if ($3>=50) {print $1; nextfile}}')
                    stat="$r $g $b"
                    rm noname.red noname.grn noname.blu
                    ;;
            *)      echo "ERROR: immedian(): unknown type." >&2 && return 255;;
        esac
    fi
    echo $stat
    rm -f $tmp1
}

datarange () {
    # check data range of FITS image, output: min median max
    local showhelp
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    done
    
    local fimg="$1"
    local min
    local max
    local md
    local x
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpdat=$(mktemp $tdir/tmp_data_$$.XXXXXX.dat)
    local tmpfits=$(mktemp $tdir/tmp_im_$$.XXXXXX.fits)
    local tmpfits2=$(mktemp $tdir/tmp_im2_$$.XXXXXX.fits)

    (test "$showhelp" || test $# -ne 1) &&
        echo "usage: datarange <fitsimage>" >&2 &&
        return 1

    test ! -e "$fimg" &&
        echo "ERROR: file $fimg not found" >&2 && return 255
    ! is_fits "$fimg" &&
        echo "ERROR: unsupported file format" >&2 && return 255

    if is_fitscube "$fimg"
    then
        # choose green channel only
        imslice "$fimg" 2 > $tmpfits2
        fitscopy "$tmpfits2[:5,:5]" - > $tmpfits
    else
        fitscopy "$fimg[:5,:5]" - > $tmpfits
    fi
    # determine center area (80%)
    x=$(imsize $tmpfits | awk '{
        dx=0.1*$1; dy=0.1*$2
        printf("%.0f:%.0f,%.0f:%.0f\n", dx, $1-dx, dy, $2-dy)}')
    imlist "$tmpfits[$x]" | sed -e 's/^[ ]*[0-9]*//' | sed -e '1,2d' | tr ' ' '\n' | \
        grep "[0-9]" > $tmpdat
    set - $(minmax $tmpdat)
    min=$1
    max=$2
    md=$(median $tmpdat)
    
    test "$AI_DEBUG" && echo $tmpfits $tmpdat
    test -z "$AI_DEBUG" && rm -f $tmpfits $tmpdat
    rm -f $tmpfits2
    #echo "# min/median/max:" >&2
    echo $min $md $max
    return 0
}


# subtract smoothed background(s) from image
# output goes to stdout
imbgsub () {
    local showhelp
    local outmult=1
    local do_fits       # if set create FITS output instead of PNM
    local i
    for i in 1 2 3
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-m" && outmult=$2 && shift 2
        test "$1" == "-f" && do_fits=1 && shift 1
    done
    local img=${1:-""}
    local bgimg=${2:-""}
    local bgres=${3:-""}
    local bgmult=${4:-10}       # intensity multiplier used in bgimg, bgres
    local bgmean=${5:-1000}     # mean bg value in bgres
    local bgval=${6:-1000}      # bg value of resulting bg-subtracted image
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpim1=$(mktemp "/tmp/tmp_im1_XXXXXX.pnm")
    local tmpim2=$(mktemp "/tmp/tmp_im2_XXXXXX.pnm")
    local size
    local f
    
    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: imbgsub [-f] [-m outmult] <img> <bgimg> [bgres] [bgmult|$bgmult]" \
            "[bgresmean|$bgmean] [outbgval|$bgval]" >&2 &&
        return 1
    for f in $img $bgimg $bgres
    do
        test ! -f "$f" &&
            echo "ERROR: image $f does not exist." >&2 && return 255
        ! is_pnm $f &&
            echo "ERROR: image $f has unsupported file format." >&2 && return 255
    done

    size=$(identify $img | cut -d ' ' -f3)
    gm convert $bgimg -resize $size\! $tmpim1
    test "$bgres" &&
        gm convert $bgres -resize $size\! - | pnmarith -add - $tmpim1 | \
            pnmccdred -a -$bgmean - $tmpim2 &&
        cp $tmpim2 $tmpim1
    if [ "$do_fits" ]
    then
        # TODO: distinguish between single plane and RGB
        # output is fits cube
        pnmtomef $tmpim1 > $tmpfits
        meftocube $tmpfits > $tmpim1
        imarith $tmpim1 $(echo $outmult/$bgmult | bc -l) mul - > $tmpim2
        pnmtomef $img $tmpfits
        meftocube $tmpfits > $tmpim1
        imarith $tmpim1 $outmult $mul - | imarith - $tmpim2 sub - | imarith - $bgval add -
    else
        pnmccdred -m $(echo $outmult/$bgmult | bc -l) $tmpim1 $tmpim2
        pnmccdred -m $outmult $img - | pnmccdred -a $bgval -d $tmpim2 - -
    fi
    rm -f $tmpim1 $tmpim2
    return
}

# remove row or column pattern from image
# TODO: keep average gradient
impatsub () {
    local columns   # if set then remove column pattern instead of rows
    local plevel=50 # 0 lowest, 50 median, 100 highest
    local outfile   # if set then write result to outfile (default=infile)
    local showhelp
    local i
    for i in $(seq 1 4)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-c" && columns=1 && shift 1
        test "$1" == "-p" && plevel="$2" && shift 2
        test "$1" == "-o" && outfile="$2" && shift 2
    done
    local img=${1:-""}
    local w
    local h
    local pos
    local add
    local tmpsort=$(mktemp "/tmp/tmp_sort_XXXXXX.pnm")
    local tmppat=$(mktemp "/tmp/tmp_pat_XXXXXX.pnm")
    local tmppatsub=$(mktemp "/tmp/tmp_patsub_XXXXXX.pnm")
    local tmpline=$(mktemp "/tmp/tmp_line_XXXXXX.pnm")
    local tmpdat=$(mktemp "/tmp/tmp_data_XXXXXX.dat")

    (test "$showhelp" || test $# -ne 1) &&
        echo "usage: impatsub [-c] [-p plevel|$plevel] [-o outfile] <image>" >&2 &&
        return 1

    set - $(imsize $img)
    w=$1
    h=$2
    pos=$((w*plevel/100))
    test "$columns" && pos=$((h*plevel/100))

    if [ -z "$columns" ]
    then
        pnmrowsort $img $tmpsort
        gm convert $tmpsort -crop 1x${h}+${pos}+0 $tmpline
        if is_ppm $tmpline
        then
            AIval -a $tmpline > $tmpdat
            add=$(median $tmpdat 1)","$(median $tmpdat 2)","$(median $tmpdat 3)
        else
            AIval -a $tmpline > $tmpdat
            add=$(median $tmpdat 1)
        fi
        # TODO: remove gradient from tmpline (skip lowest/highest 10%)
        gm convert $tmpline -resize ${w}x${h}\! $tmppat
        pnmccdred -a $add -d $tmppat $img $tmppatsub
        test -z "$outfile" && mv $tmppatsub $img
        test    "$outfile" && mv $tmppatsub $outfile
    fi
    test "$AI_DEBUG" && echo "$tmpsort $tmpline $tmpdat $tmppat" >&2
    test ! "$AI_DEBUG" && rm -f $tmpsort $tmpline $tmpdat $tmppat $tmppatsub
    return 0
}

kmedian () {
    # compute median of image pixels within given kernel
    # output image to stdout
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    local img=$1
    local kernel=$2 # use this b/w image as kernel for computing median
                    # kernel pixels must be black , image must have
                    # odd number of pixels in both dimensions
    local tdir=${AI_TMPDIR:-"/tmp"}
    local wdir=$(mktemp -d "$tdir/tmp_median_XXXXXX")
    local xc
    local yc
    local roll

    (test "$showhelp" || test $# -ne 2) &&
        echo "usage: kmedian <image> <kernelimage>" >&2 &&
        return 1

    ! is_pbm $kernel &&
        echo "ERROR: kernel image must be in PBM format." >&2 &&
        return 255
    ! is_pnm $img &&
        echo "ERROR: only PNM images supported by kernel-median." >&2 &&
        return 255
    
    xc=$(identify $kernel | cut -d " " -f3 | awk -F "x" '{print ($1-1)/2}')
    yc=$(identify $kernel | cut -d " " -f3 | awk -F "x" '{print ($2-1)/2}')
    AIval -c -a -1 $kernel | while read x y z
    do
        roll=$(echo $((x-xc)) $((y-yc)) | awk '{
            if ($1<=0) {printf("+%d", -1*$1)} else {printf("%d", -1*$1)}
            if ($2<=0) {printf("+%d", -1*$2)} else {printf("%d", -1*$2)}
            }')
        #echo "$roll" >&2
        gm convert $img -roll $roll $wdir/roll.$roll.pnm
    done
    pnmcombine -d $wdir/* -
    
    rm -rf $wdir
    return

}

kmean () {
    # --- NOT USED ---
    # compute mean of image pixels within given kernel
    # optionally ignore pixels in badmask
    # optionally apply gaussian distance weight to kernel pixels
    # output image to stdout
    # TODO: allow for PGM input image
    local showhelp
    local gausswidth
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-g" && gausswidth=$2 && shift 2
    done
    local img=$1
    local kernel=$2 # use this b/w image as kernel for computing median
                    # kernel pixels must be black , image must be square with
                    # odd number of pixels in both dimensions
    local badmask=${3:-""}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpgauss=$(mktemp "$tdir/tmp_gauss_XXXXXX.pgm")
    local tmpkern=$(mktemp "$tdir/tmp_tmpkern_XXXXXX.pnm")
    local ikern=$(mktemp "$tdir/tmp_ikern_XXXXXX.dat")
    local div=$(mktemp "$tdir/tmp_div_XXXXXX.pnm")
    local width

    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: kmean [-g width] <image> <kernelimage> [badmask]" >&2 &&
        return 1

    ! is_pbm $kernel &&
        echo "ERROR: kernel image must be in PBM format." >&2 &&
        return 255
    ! is_ppm $img &&
        echo "ERROR: only PPM images supported." >&2 &&
        return 255
    test "$badmask" && test ! -f $badmask &&
        echo "ERROR: badmask $badmask does not exist." >&2 &&
        return 255

    # optionally gaussian smooth kernel
    #width=$(identify $kernel | cut -d " " -f3 | cut -d "x" -f1)
    if [ "$gausswidth" ]
    then
        #gauss -s $width "" "" "" "" $width > $tmpgauss
        #pnminvert $kernel | pnmarith -mul - $tmpgauss > $tmpkern
        width=$(echo $gausswidth | awk '{printf("%.1f", $1/2)}')
        pnminvert $kernel | convert - -blur 0x$width $tmpkern
    else
        cp $kernel $tmpkern
    fi
    
    # create imagemagick convolution kernel from kernel image
    pnmnoraw $tmpkern | awk '{
        if ($0~/^#/)  next
        if ($0=="P1") {maxval=1; ispbm=1; next}
        if ($0=="P2") {ispbm=0; next}
        if (dim=="") {dim=$1"x"$2; printf("%s: ", dim); next}
        if (maxval=="") {maxval=$1; next}
        
        # data
        if (ispbm==1) {
            gsub(/ /,"")
            for (i=1; i<=length($0); i++) {
                if (i>1) printf(",")
                printf("%s", substr($0,i,1))
            }
            printf(" ")
        } else {
            sub(/^[ ]*/,"")
            sub(/[ ]*$/,"")
            gsub(/ [ ]*/," ")
            gsub(/ /,",")
            printf(" %s", $0)
        }
        }' > $ikern
    
    # optionally apply badmask to img and convolve it with convolution kernel
    if [ "$badmask" ]
    then
        # convolve (avg) badmask (after mult by 65535) with convolution kernel
        convert $badmask -depth 16 -define convolve:scale=\! \
            -morphology Convolve "$(cat $ikern)" ppm: > $div
        # convolve img and apply intensity scaling
        pnmarith -mul $img $badmask | convert - -define convolve:scale=\! \
            -morphology Convolve "$(cat $ikern)" - | \
            pnmccdred -m 65535 -s $div - -
    else
        convert $img -define convolve:scale=\! \
            -morphology Convolve "$(cat $ikern)" -
    fi

    rm $tmpgauss $tmpkern $ikern $div
    return
}

demosaic () {
    # --- NOT USED ---
    # demosaic bayer matrix (bilinear interpolation)
    # output rgb image to stdout
    local showhelp
    for i in 1
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    done
    
    local img=${1:-"-"}
    local fname
    local tmpin=$(mktemp "/tmp/tmp_inimg_$$.XXXXXX.pgm")
    local tmp1=$(mktemp "/tmp/tmp_im1_$$.XXXXXX.pgm")
    local tmp2=$(mktemp "/tmp/tmp_im2_$$.XXXXXX.pgm")
    local r=$(mktemp "/tmp/tmp_red_$$.XXXXXX.pgm")
    local g=$(mktemp "/tmp/tmp_grn_$$.XXXXXX.pgm")
    local b=$(mktemp "/tmp/tmp_blu_$$.XXXXXX.pgm")
    local kernel

    (test "$showhelp" || test $# -ne 1) &&
        echo "usage: demosaic <img>" >&2 &&
        return 1

    if [ "$img" != "-" ]
    then
        fname=$(get_imfilename $img)
        test -z "$fname" && return 255
    else
        cat "$img" > $tmp1
        fname="$tmp1"
    fi
    
    ! is_pgm $fname &&
        echo "ERROR: input image is not in pgm format." >&2 && return 255

    w=$(identify $fname | cut -d " " -f3 | cut -d "x" -f1)
    h=$(identify $fname | cut -d " " -f3 | cut -d "x" -f2)
    
    # reconstruct green channel
    echo -e "P2\n2 2\n1\n0 1 1 0" | pnmtile $w $h - | \
        pnmarith -mult - $fname > $tmp1
    kernel="3x3: 0.00, 0.25, 0.00,  0.25, 0.00, 0.25,  0.00, 0.25, 0.00"
    convert $tmp1 -morphology Convolve "$kernel" pgm: | \
        pnmarith -add $tmp1 - > $g

    # reconstruct red channel
    echo -e "P2\n2 2\n1\n0 0 0 1" | pnmtile $w $h - | \
        pnmarith -mult - $fname > $tmp1
    kernel="3x3: 0.25, 0.00, 0.25,   0.00, 0.00, 0.00,   0.25, 0.00, 0.25"
    convert $tmp1 -morphology Convolve "$kernel" pgm: | \
        pnmarith -add $tmp1 - > $r
    cp $r $tmp2
    kernel="3x1: 0.50, 0.00, 0.50"
    convert $tmp1 -morphology Convolve "$kernel" pgm: | \
        pnmarith -add $tmp2 - > $r
    cp $r $tmp2
    kernel="1x3: 0.50,   0.00,   0.50"
    convert $tmp1 -morphology Convolve "$kernel" pgm: | \
        pnmarith -add $tmp2 - > $r

    # reconstruct blue channel
    echo -e "P2\n2 2\n1\n1 0 0 0" | pnmtile $w $h - | \
        pnmarith -mult - $fname > $tmp1
    kernel="3x3: 0.25, 0.00, 0.25,   0.00, 0.00, 0.00,   0.25, 0.00, 0.25"
    convert $tmp1 -morphology Convolve "$kernel" pgm: | \
        pnmarith -add $tmp1 - > $b
    cp $b $tmp2
    kernel="3x1: 0.50, 0.00, 0.50"
    convert $tmp1 -morphology Convolve "$kernel" pgm: | \
        pnmarith -add $tmp2 - > $b
    cp $b $tmp2
    kernel="1x3: 0.50,   0.00,   0.50"
    convert $tmp1 -morphology Convolve "$kernel" pgm: | \
        pnmarith -add $tmp2 - > $b

    # combine color channels
    rgb3toppm $r $g $b
    
    rm $r $g $b
    rm $tmpin $tmp1 $tmp2
}

AIraw2fullgray () {
    # convert raw image to gray scale with linear scale up to 16bit range
    # and keeping overscan area
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1

    local img=$1
    local bad=${2:-""}
    local sat
    local mult=1
    local param="-4 -t 0 -k 0 -r 1 1 1 1 $AI_DCRAWPARAM"
    
    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: AIraw2fullgray <img> [bad]" >&2 &&
        return 1
    
    test "$AI_RAWBITS" && sat=$(echo "2^$AI_RAWBITS - 1" | bc) &&
        mult=$(echo "2^(16-$AI_RAWBITS)" | bc)
    test "$sat"  && param="$param -S $sat"

    test "$bad" && param="$param -P $bad"
    dcraw-tl -c $param -E $img | pnmccdred -m $mult - -
}

AIraw2gray () {
    # convert raw image to gray scale image, output to stdout
    # - scale up from 12bit to 16bit
    # - optionally subtract scaled dark frame
    # - correct for overscan offset if text file $AI_OVERSCAN exists
    #   (containing lines with two fields: imnum overscan_value)
    # - if input image is FITS file then header keyword IMGROLL = 'Y' is
    #   accounted for
    local showhelp
    local add=0
    local scale=1   # only applied on FITS images
    local do_flip
    local i
    for i in 1 2 3
    do
        test "$1" == "-a" && add=$2 && shift 2
        test "$1" == "-s" && scale=$2 && shift 2
        test "$1" == "-f" && do_flip=1 && shift 1
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    done
    
    local img=$1
    local dark=${2:-""}
    local bad=${3:-""}
    local flat=${4:-""}     # must be at average level 10000
    local sat
    local param="-4 -t 0 -k 0 -r 1 1 1 1 $AI_DCRAWPARAM"
    local i4
    local oscorr=""
    local oszero=8192
    local ped
    local imgroll=""
    local cmd
    local origname
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpfits=$(mktemp "$tdir/tmp_im_XXXXXX.fits")

    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: AIraw2gray [-f] [-s scale|$scale] [-a add|$add] <img> [dark] [bad] [flat]" >&2 &&
        return 1

    test "$dark" && test ! -f $dark &&
        echo "ERROR: dark image $dark not found." >&2 && return 255
    test "$bad" && test ! -f $bad &&
        echo "ERROR: badpixel file $bad not found." >&2 && return 255
    test "$flat" && test ! -f $flat &&
        echo "ERROR: flat field image $flat not found." >&2 && return 255
    
    test "$AI_RAWBITS" && sat=$(echo "2^$AI_RAWBITS - 1" | bc)
    test "$sat"  && param="$param -S $sat"

    origname=$img
    is_fitzip $img && unzip -p $img > $tmpfits && img=$tmpfits

    if is_fits $img
    then
        imhead $img | grep "^IMGROLL " | tr -d "'" | grep -q -w Y &&
            imgroll="yes"
        test "$AI_DEBUG" && echo "$img  imgroll=$imgroll" >&2
        ped=$(listhead $img | grep "^PEDESTAL=" | awk '{print $2}')
        test -z "$ped" && ped=0
        param=""
        test "$dark" && param="$param -d $dark"
        test "$flat" && param="$param -m 10000 -s $flat"
        test "$AI_DEBUG" && echo "param=$param" >&2 &&
            echo "add=$add  ped=$ped  imgroll=$imgroll" >&2

        cmd="meftopnm $img | pnmccdred -a $ped - - | pnmccdred -m $scale - -"
        test "$do_flip" && cmd="$cmd | pnmflip -tb"
        test "$imgroll" && cmd="$cmd | pnmflip -r180"
        cmd="$cmd | pnmccdred -a $add $param - -"
        test "$AI_DEBUG" && echo $cmd >&2
        eval "$cmd"
        test -z "$AI_DEBUG" && rm $tmpfits
        return
    fi
    
    if is_raw $img
    then
        test "$dark" && param="$param -K $dark"
        test "$bad" && param="$param -P $bad"
        test "$flat" && param="$param -F $flat"
        if [ -f "$AI_OVERSCAN" ]
        then
            i4=$(echo $(basename $img) | awk '{printf("%04d", 1*$1)}')
            is_integer $i4 &&
                oscorr=$(grep -w "^$i4" "$AI_OVERSCAN" | awk -v zero=$oszero '{
                    printf("%.1f", zero-$2)}')
            test -z "$oscorr" && echo "WARNING: no overscan value found for $i4" >&2
        fi
        test "$AI_DEBUG" && param="$param -v"
        test "$AI_DEBUG" && echo dcraw-tl -c $param -d -l $img >&2
        test -z "$oscorr" && dcraw-tl -c $param -d -l $img
        test    "$oscorr" && dcraw-tl -c $param -d -l $img | pnmccdred -a $oscorr - -
        test -z "$AI_DEBUG" && rm $tmpfits
        return
    fi
    
    echo "ERROR: input image has unsupported format." >&2
    test -z "$AI_DEBUG" && rm $tmpfits
    return 255
}

AIraw2rgb () {
    # convert raw image to RGB image, output to stdout
    # - scale up from 12bit to 16bit
    # - optionally subtract dark frame (scaled to 16bit)
    # - optionally divide by normalized flat field (average level 10000)
    # - correct for overscan offset if text file $AI_OVERSCAN exists
    #   (containing lines with two fields: imnum overscan_value)
    # outputs RGB image (to stdout)
    local showhelp
    local quality=3             # 0=bilinear, 1=VNG, 2=PPG, 3=AHD
    local apply_color_matrix    # if set dcraw color matrix (channel multipliers)
                                # is applied
    local scale=1               # intensity scaling, only applied on fitsbayer images
    local do_flip
    local i
    for i in 1 2 3 4
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-q" && quality=$2 && shift 2
        test "$1" == "-s" && scale=$2 && shift 2
        test "$1" == "-f" && do_flip=1 && shift 1
        test "$1" == "-m" && apply_color_matrix=1 && shift 1
    done
    
    local img=$1
    local dark=${2:-""}
    local bad=${3:-""}
    local flat=${4:-""}     # must be at average level 10000
    local sat
    local param
    local i4
    local oscorr=""
    local oszero=8192
    local type  # either raw (is_raw) or fitsbayer (is_fitsbayer)
    local scale
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmppgm=$(mktemp "$tdir/tmp_gray_XXXXXX.pgm")
    local tmptif=$(mktemp "$tdir/tmp_rgb_XXXXXX.tif")

    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: AIraw2rgb [-m] [-q quality|$quality] [-f] [-s scale|$scale] <img> [dark] [bad] [flat]" >&2 &&
        return 1

    
    is_raw $img && type="raw"
    test -z "$type" && is_fitsbayer $img && type="fitsbayer"
    test -z "$type" &&
        echo "ERROR: image $img is not supported (neither DSLR-RAW nor FITS-Bayer)." >&2 &&
        return 255
    test "$dark" && test ! -f $dark &&
        echo "ERROR: dark image $dark not found." >&2 && return 255
    test "$bad" && test ! -f $bad &&
        echo "ERROR: badpixel file $bad not found." >&2 && return 255
    test "$flat" && test ! -f $flat &&
        echo "ERROR: flat field image $flat not found." >&2 && return 255
    
    test "$AI_RAWBITS" && sat=$(echo "2^$AI_RAWBITS - 1" | bc)
    
    if [ "$type" == "raw" ]
    then
        param="-q $quality -4 -t 0 -k 0 $AI_DCRAWPARAM"
        test "$apply_color_matrix" || param="-r 1 1 1 1 $param"
        test "$sat"  && param="$param -S $sat"

        test "$dark" && param="$param -K $dark"
        test "$bad"  && param="$param -P $bad"
        test "$flat" && param="$param -F $flat"
        if [ -f "$AI_OVERSCAN" ]
        then
            i4=$(echo $(basename $img) | awk '{printf("%04d", 1*$1)}')
            is_integer $i4 &&
                oscorr=$(grep -w "^$i4" "$AI_OVERSCAN" | awk -v zero=$oszero '{
                    printf("%.1f", zero-$2)}')
            test -z "$oscorr" && echo "WARNING: no overscan value found for $i4" >&2
        fi
        test "$AI_DEBUG" && param="$param -v"
        test "$AI_DEBUG" && echo dcraw-tl -c $param -o 0 -l $img >&2
        test -z "$oscorr" && dcraw-tl -c $param -o 0 -l $img
        test    "$oscorr" && dcraw-tl -c $param -o 0 -l $img | pnmccdred -a $oscorr - -
    else
        # flip, scale, dark, flat, debayer
        if [ "$do_flip" ]
        then
            AIraw2gray -f -s $scale $img "$dark" "$bad" "$flat" > $tmppgm
        else
            AIraw2gray -s $scale $img "$dark" "$bad" "$flat" > $tmppgm
        fi
        set - $(imsize $tmppgm)
        # TODO: make bayer pattern order be variable
        bayer2rgb -f GRBG -m BILINEAR -b 16 -t -w $1 -v $2 -i $tmppgm -o $tmptif
        convert $tmptif ppm:
    fi
    rm -f $tmppgm $tmptif
}

AImedian () {
    # median of a set of images
    # output image: median.pnm (1 or 3 samples per pixel)
    # TODO: rework
    # - compute mean image: tmpmean
    # - normalize images using tmpmean
    # - create variation map
    # - create median image
    local outfile="median.pnm"
    local showhelp
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-o" && outfile="$2" && shift 2
    done
    
    local img
    local ext
    local fname
    local ilist=""
    local dlist=""
    local mean
    local mul
    local tdir=${AI_TMPDIR:-"/tmp"}
    local wdir=$(mktemp -d "$tdir/tmp_median_$$.XXXXXX")
    local tmpmean=$(mktemp "$wdir/tmp_mean_XXXXXX.pnm")

    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: AImedian [-o outfile|$outfile] <set1|image1> [set2|image2 ...]" >&2 &&
        return 1

    for img in "$@"
    do
        if is_setname $img
        then
            ilist="$ilist $(AIimlist -f $img)"
        else
            fname=$(get_imfilename $img)
            test -z "$fname" && continue
            if is_raw "$fname"
            then
                b=$(basename $fname)
                AIraw2gray "$fname" > $tdir/${b%.*}.pnm
                dlist="$dlist $tdir/${b%.*}.pnm"
                ilist="$ilist $tdir/${b%.*}.pnm"
            else
                ilist="$ilist $fname"
            fi
        fi
    done
    test $(echo $ilist | wc -w) -eq 0 &&
        echo "ERROR: no input images" >&2 && return 255
    test "$AI_DEBUG" && echo $ilist
    pnmcombine $ilist $tmpmean
    mean=$(AImstat -c $tmpmean | awk '{printf("%.1f", $5)
        if(NF>9) printf(",%.1f,%.1f", $9, $13)}')
    echo "# mean=$mean" >&2
    
    # normalize images
    i=1
    for img in $ilist
    do
        mul=$(AImstat -c $img | awk -v mean=$mean '{
            n=split(mean,m,",")
            printf("%f", m[1]/$5)
            if(n>1) printf(",%f,%f", m[2]/$9, m[3]/$13)
            }')
        pnmccdred -m $mul $img $wdir/$i.norm.pnm
        i=$((i+1))
    done
    
    # median image
    pnmcombine -d $wdir/[0-9]*.norm.pnm $outfile
    test "$dlist" && rm $dlist
    
    rm $tmpmean
    if [ "$AI_DEBUG" ]
    then
        echo $wdir >&2
    else
        rm -rf $tmpmean $wdir/[0-9]*.norm.pnm
        rmdir $wdir
    fi
    return
}

AIbsplit () {
    # subtract dark and split bayer matrix into separate images for each color cell
    # create pgm output files into current directory
    # matrix geometry:  BGGR    GBRG
    #            A B    b1 g1   g1 b1
    #            C D    g2 r1   r1 g2
    #
    local showhelp
    local cell
    local matrix="BGGR"
    local i
    for i in 1 2 3
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-m" && matrix=$2 && shift 2
        (test "$1" == "-g1" || test "$1" == "-g2" || test "$1" == "-b1" || test "$1" == "-r1" ||
            test "$1" == "-g" || test "$1" == "-g" || test "$1" == "-r") &&
            cell=$(echo $1"1" | cut -c2-3) &&
            echo "# cell=$cell" >&2 &&
            shift 1
    done
    local img=$1
    local dark=${2:-""}
    local bad=${3:-""}
    local fname
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpim=$(mktemp "$tdir/tmp_im_XXXXXX.pgm")
    local a
    local b
    local c
    local d
    local gidx=1
    local f

    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: AIbsplit [-m matrix|$matrix] [-r|g1|g2|b] <img> [dark] [bad]" >&2 &&
        return 1

    matrix=${matrix,,}  # lower case
    a=${matrix:0:1}
    test "$a" != "g" && a=${a}1; test "$a" == "g" && a=${a}$gidx && gidx=2
    b=${matrix:1:1}
    test "$b" != "g" && b=${b}1; test "$b" == "g" && b=${b}$gidx && gidx=2
    c=${matrix:2:1}
    test "$c" != "g" && c=${c}1; test "$c" == "g" && c=${c}$gidx && gidx=2
    d=${matrix:3:1}
    test "$d" != "g" && d=${d}1; test "$d" == "g" && d=${d}$gidx && gidx=2
        
    fname=$(get_imfilename $img)
    test -z "$fname" && continue
    f=$(basename $fname)
    if is_raw "$fname"
    then
        if [ "$dark" ]
        then
            AIraw2gray "$fname" $dark $bad > $tmpim
        else
            AIraw2gray "$fname" ""    $bad > $tmpim
        fi
        fname=$tmpim
    fi
    # old:
    #convert $fname -roll +1+1 -define sample:offset=75 -sample 50% ${b%.*}.b1.pgm
    #convert $fname -roll +0+1 -define sample:offset=75 -sample 50% ${b%.*}.g1.pgm
    #convert $fname -roll +1+0 -define sample:offset=75 -sample 50% ${b%.*}.g2.pgm
    #convert $fname -roll +0+0 -define sample:offset=75 -sample 50% ${b%.*}.r1.pgm
    (test -z "$cell" || test "$cell" == $a) &&
        gm convert $fname -roll +0+0 -filter point -resize 50% ${f%.*}.$a.pgm
    (test -z "$cell" || test "$cell" == $b) &&
        gm convert $fname -roll -1+0 -filter point -resize 50% ${f%.*}.$b.pgm
    (test -z "$cell" || test "$cell" == $c) &&
        gm convert $fname -roll +0-1 -filter point -resize 50% ${f%.*}.$c.pgm
    (test -z "$cell" || test "$cell" == $d) &&
        gm convert $fname -roll -1-1 -filter point -resize 50% ${f%.*}.$d.pgm
    rm -f $tmpim
}

AIbmerge () {
    # combine 4 images each representing a single bayer matrix "color" into
    # BGGR 2x2 bayer grid
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1

    local b1=$1
    local g1=$2
    local g2=$3
    local r1=$4
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpim1=$(mktemp "$tdir/tmp_im1_XXXXXX.pgm")
    local tmpim2=$(mktemp "$tdir/tmp_im2_XXXXXX.pgm")
    local tmpmask=$(mktemp "$tdir/tmp_mask_XXXXXX.pgm")
    local w
    local h

    (test "$showhelp" || test $# -ne 4) &&
        echo "usage: AIbmerge <b1> <g1> <g2> <r1>" >&2 &&
        return 1
        
    w=$(identify $b1 | cut -d " " -f3 | cut -d "x" -f1)
    h=$(identify $b1 | cut -d " " -f3 | cut -d "x" -f2)
    echo -e "P2\n2 2\n65535\n65535 0 0 0" | pnmtile $((w*2)) $((h*2)) - > $tmpmask
    
    # old:
    #convert $b1 -scale 200% - | pnmarith -mul - $tmpmask > $tmpim1
    #convert $g1 -scale 200% - | pnmarith -mul - $tmpmask | convert - -roll +1+0 - | \
    #    pnmarith -add - $tmpim1 > $tmpim2
    gm convert $b1 -scale 200% - | pnmarith -mul - $tmpmask > $tmpim1
    gm convert $g1 -scale 200% - | pnmarith -mul - $tmpmask | gm convert - -roll +1+0 - | \
        pnmarith -add - $tmpim1 > $tmpim2
    mv $tmpim2 $tmpim1
    #convert $g2 -scale 200% - | pnmarith -mul - $tmpmask | convert - -roll +0+1 - | \
    #    pnmarith -add - $tmpim1 > $tmpim2
    gm convert $g2 -scale 200% - | pnmarith -mul - $tmpmask | gm convert - -roll +0+1 - | \
        pnmarith -add - $tmpim1 > $tmpim2
    mv $tmpim2 $tmpim1
    #convert $r1 -scale 200% - | pnmarith -mul - $tmpmask | convert - -roll +1+1 - | \
    #    pnmarith -add - $tmpim1 > $tmpim2
    gm convert $r1 -scale 200% - | pnmarith -mul - $tmpmask | gm convert - -roll +1+1 - | \
        pnmarith -add - $tmpim1 > $tmpim2
    cat $tmpim2
    rm -f $tmpim1 $tmpim2 $tmpmask
}
    
AIbnorm () {
    # normalize gray bayer image by average of each color
    # output PGM to stdout
    local showhelp
    local do_keep_brightness    # keep mean brightness instead of normalizing
                                # to value 10000
    local do_subtract           # do subtraction of mean instead of division
    local i
    for i in 1 2 3
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-k" && do_keep_brightness=1 && shift 1
        test "$1" == "-s" && do_subtract=1 && shift 1
    done
    
    local img=$1
    local val=10000
    local w
    local h
    local mxx
    #local tdir=${AI_TMPDIR:-"/tmp"}

    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: AIbnorm <img>" >&2 &&
        return 1

    w=$(identify $img | cut -d " " -f3 | cut -d "x" -f1)
    h=$(identify $img | cut -d " " -f3 | cut -d "x" -f2)
    mxx=$(AImstat -b -c $img | awk '{
        printf("%.0f %.0f %.0f %.0f", $5, $9, $13, $17)}')
    echo "# mxx=$mxx" >&2
    test "$do_keep_brightness" && val=$(echo $mxx | mean)
    if [ "$do_subtract" ]
    then
        echo -e "P2\n2 2\n65535\n$mxx" | pnmtile $w $h - | \
            pnmccdred -a $val -d - $img -
    else
        echo -e "P2\n2 2\n65535\n$mxx" | pnmtile $w $h - | \
            pnmccdred -m $val -s - $img -
    fi
}

#----------------------
#   utility functions
#----------------------

AIstat () {
    # statistics of an image
    # gray image:  min max mean stddev
    # rgb image:   Red-min max mean stddev Green-min ... Blue-min
    local showhelp
    local do_crop   # center only
    local do_bayer  # stats in each bayer cell
    local do_median # apply 3x3 median before statistics
    local imgtype
    local verbose
    local i
    for i in $(seq 1 9)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-b" && do_bayer=1 && shift 1
        test "$1" == "-c" && do_crop=1 && shift 1
        test "$1" == "-m" && do_median=1 && shift 1
        test "$1" == "-d" && imgtype="d" && shift 1
        test "$1" == "-f" && imgtype="f" && shift 1
        test "$1" == "-o" && imgtype="o" && shift 1
        test "$1" == "-v" && verbose=1 && shift 1
    done
    local img
    local stat
    local fname
    local sname
    local cmd
    local sdat=${AI_SETS:-"set.dat"}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local imlist=$(mktemp "$tdir/tmp_imlist.XXXXXX.dat")
    local tmpdat=$(mktemp "$tdir/tmp_data.XXXXXX.dat")
    local tmp1=$(mktemp "$tdir/tmp_img1.XXXXXX")
    local tmp2=$(mktemp "$tdir/tmp_img2.XXXXXX")
    local tmpstdin=$(mktemp "$tdir/tmp_stdin.XXXXXX")
    local str
    local num
    local c00
    local c01
    local c10
    local c11
    local scale=1   # apply intensity scaling (FITS images only)

    (test "$showhelp" || (test -z "$imgtype" && test $# -lt 1) ||
        (test "$imgtype" && test $# -ge 1)) &&
        echo "usage: AIstat [-m] [-b] [-c] -d|-f|-o" >&2 &&
        echo "   or: AIstat [-m] [-b] [-c] <image1|set1> [image2|set2 ...]" >&2 &&
        return 1
    
    # create image list (fields: sname num fname ...)
    if [ "$imgtype" ]
    then
        AIimlist -q "" "" raw $imgtype > $imlist
    else
        for img in "$@"
        do
            if [ -e $sdat ] && is_setname $img
            then
                AIimlist -q $img 2>/dev/null > $tmpdat
                if [ -s $tmpdat ]
                then
                    cat $tmpdat >> $imlist
                else
                    AIimlist -q $img "" raw >> $imlist
                fi
            else
                if [ "$img" == "-" ]
                then
                    cat /dev/stdin > $tmpstdin
                    fname=$tmpstdin
                else
                    fname=$(get_imfilename $img)
                fi
                test -z "$fname" && continue
                num="-"
                str=$(basename ${fname%.*})
                is_integer ${str:0:4} && num=${str:0:4}
                echo "-" $num $fname "- - -" >> $imlist
            fi
        done
    fi
    
    # statistics
    while read sname num fname x
    do
        test "$verbose" && echo "computing stats for $(basename $fname) ..." >&2

        # determine intensity scaling factor to stretch to full 16bit range
        # this is used in case of FITS images only
        if [ "$sname" == "-" ]
        then
            scale=1
        else
            scale=$(get_param camera.dat rawbits $sname | awk '{print 2^(16-$1)}')
        fi
        
        # apply raw conversion and cropping -> $tmp1
        cmd=""
        test -z "$cmd" && is_pnm "$fname"    && cmd="cat $fname"
        test -z "$cmd" && is_raw "$fname"    && cmd="AIraw2gray $fname"
        test -z "$cmd" && is_fits "$fname"   && cmd="meftopnm $fname | pnmccdred -m $scale - -"
        test -z "$cmd" && is_fitzip "$fname" && cmd="unzip -p $fname > $tmp2 && meftopnm $tmp2 | pnmccdred -m $scale - -"
        test -z "$cmd" && cmd="cat $fname"
        test "$do_crop" && cmd="$cmd | imcrop"
        eval $cmd > $tmp1
        test $? -ne 0 && continue
        
        # statistics
        cmd="cat"
        test "$do_median" && cmd="gm convert - -median 1 pnm:-"
        if [ "$do_bayer" ]
        then
            # old:
            #c00=$(convert $tmp1 -roll +1+1 -define sample:offset=75 -sample 50% - | \
            #    convert - -median 3 pnm: | _imstat)
            #c01=$(convert $tmp1 -roll +0+1 -define sample:offset=75 -sample 50% - | \
            #    convert - -median 3 pnm: | _imstat)
            #c10=$(convert $tmp1 -roll +1+0 -define sample:offset=75 -sample 50% - | \
            #    convert - -median 3 pnm: | _imstat)
            #c11=$(convert $tmp1 -roll +0+0 -define sample:offset=75 -sample 50% - | \
            #    convert - -median 3 pnm: | _imstat)
            c00=$(gm convert $tmp1 -roll +0+0 -filter point -resize 50% - | $cmd | _imstat)
            c10=$(gm convert $tmp1 -roll +0-1 -filter point -resize 50% - | $cmd | _imstat)
            c01=$(gm convert $tmp1 -roll -1+0 -filter point -resize 50% - | $cmd | _imstat)
            c11=$(gm convert $tmp1 -roll -1-1 -filter point -resize 50% - | $cmd | _imstat)
            stat="$c00 $c01 $c10 $c11"
        else
            # old:
            #stat=$(convert $tmp1 -median 3 pnm: | _imstat)
            stat=$(cat $tmp1 | $cmd | _imstat)
        fi
        echo "$(basename $fname) $num "$stat
    done < $imlist
    rm -f $tmp1 $tmp2 $tmpstdin $imlist $tmpdat
    return
}


AImstat () {
    # median statistics
    AIstat -m $@
}


AIsfit () {
    # fit surface to each channel of image ignoring any zero value intensities
    # output fitted image to stdout
    # output coefficients of fit to stderr
    local showhelp
    local do_plane  # if set then apply planar fit (instead of quadratic fit)
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-p" && do_plane=1 && shift 1
    done
    local img="$1"
    local rgbdat=$(mktemp "/tmp/tmp_rgbdat_$$.XXXXXX")
    local fitdat=$(mktemp "/tmp/tmp_fitdat_$$.XXXXXX")
    local tmp1=$(mktemp "/tmp/tmp_dat_$$.XXXXXX")
    local tmpgp=$(mktemp "/tmp/tmp_sfit_$$.XXXXXX.gp")
    local tmpout=$(mktemp "/tmp/tmp_out_$$.XXXXXX.txt")
    local w
    local h
    local xm
    local ym
    local c
    local fitfun
    local fitvars
    local out
    local retval
    local ncolors=3
    local gpversion
    
    (test "$showhelp" || test $# -ne 1) &&
        echo "usage: AIsfit [-p] <img>" >&2 &&
        return 1

    is_pgm $img && ncolors=1
    
    # create rgb data file
    w=$(identify $img | cut -d " " -f3 | cut -d "x" -f1)
    h=$(identify $img | cut -d " " -f3 | cut -d "x" -f2)
    AIval -c $img $w $h > $rgbdat

    xm=$(echo $w | awk '{print $1/2}')
    ym=$(echo $h | awk '{print $1/2}')
    fitfun="a + b1*(x-$xm) + b2*(y-$ym) \
        + c1*(x-$xm)*(x-$xm) + c2*(y-$ym)*(y-$ym) + c3*(x-$xm)*(y-$ym)"
    fitvars="a, b1, b2, c1, c2, c3"
    test "$do_plane" &&
        fitfun="a + b1*(x-$xm) + b2*(y-$ym); c1=0; c2=0; c3=0" &&
        fitvars="a, b1, b2"
    
    # check gnuplot version
    gpversion=$(gnuplot -V | awk '{printf("%s", $2)}')
    case "$gpversion" in
        4*) ;;
        5*) ;;
        *)  echo "ERROR: unsupported gnuplot version $gpversion." >&2
            return 255
    esac
    
    for c in $(seq 1 $ncolors)
    do
        # extract data >0
        grep -v "^#" $rgbdat | awk -v cid=$((c+2)) '{if ($cid>0) {print $0}}' > $tmp1

        # coefficients
        echo "# gather statistics
        stats '$tmp1' using $((c+2)) noout
        a=STATS_mean
        stats '$rgbdat' using 1:2 noout
        nx=STATS_max_x+1
        ny=STATS_max_y+1
        # data fitting
        set fit quiet
        # until 171228: b1=0.1; b2=0.1; c1=0.1; c2=0.1; c3=0.1
        b1=100; b2=100; c1=100; c2=100; c3=100
        f(x,y) = $fitfun" > $tmpgp
        case "$gpversion" in
            4*)
                echo "       " \
                "fit f(x,y) '$tmp1' using 1:2:$((c+2)):(1) via $fitvars" >> $tmpgp
                ;;
            5*) echo "       " \
                "fit f(x,y) '$tmp1' using 1:2:$((c+2)) via $fitvars" >> $tmpgp
                ;;
        esac
        echo "
        out=sprintf(\"%d %6.3f %8.3f %7.3f %7.3f %6.3f %6.3f %6.3f\", \
            FIT_NDF, FIT_STDFIT, a, b1, b2, c1, c2, c3)
        print out
        # create fitted data points
        set samples nx
        set isosamples ny
        set table '$fitdat'
        splot [STATS_min_x:STATS_max_x] [STATS_min_y:STATS_max_y] f(x,y)
        unset table
        #plot '$fitdat' with image
        #show variables all
        " >> $tmpgp
        gnuplot -p $tmpgp > $tmpout 2>&1
        test $? -ne 0 &&
            echo "ERROR: unable to fit data." >&2 && return 255
        echo "$c $(grep -v "number of data points scaled up to" $tmpout)" >&2
        
        # create fitted surface
        grep -av "^#" $img | head -3 | sed -e 's,P.,P2,' > $fitdat.$c.pgm
        grep -v "^#" $fitdat | grep "[0-9]" | awk '{
            if(($3>=0) && ($3<=2^16-1)) {printf("%d\n", $3)} else {print 0}
            }' >> $fitdat.$c.pgm
    done
    if [ $ncolors -eq 3 ]
    then
        rgb3toppm $fitdat.1.pgm $fitdat.2.pgm $fitdat.3.pgm
        retval=$?
        rm $fitdat.1.pgm $fitdat.2.pgm $fitdat.3.pgm
    else
        cat $fitdat.1.pgm
        retval=$?
        rm $fitdat.1.pgm
    fi
    rm -f $tmp1 $fitdat $tmpout
    test -z "$AI_DEBUG" && rm -f $rgbdat $tmpgp
    test "$AI_DEBUG" && echo $rgbdat $tmpgp >&2
    return $retval
}


bgresmodel () {
    # model background using low-resolution residual images as
    # created by bggradient
    # use minimum value after normalization
    local showhelp
    local bgmult=10
    local bgres=1000
    local scale=1.0
    local bgval
    local verbose=1
    for i in $(seq 1 4)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-v" && verbose=1 && shift 1
        test "$1" == "-m" && bgmult=$2 && shift 2
        test "$1" == "-s" && scale=$2 && shift 2
        test "$1" == "-b" && bgval=$2 && shift 2
    done
    local target=${1:-""}   # target set
    local reflist=${2:-""}  # bg reference sets separated by ,
    local tdir=${AI_TMPDIR:-"/tmp"}
    local wdir=$(mktemp -d "$tdir/tmp_bgres_$$.XXXXXX")
    local cdir=bgcorr
    local ext
    local ncol
    local refdir
    local sname
    local x
    local i
    local add
    local mult
    local img
    
    (test "$showhelp" || test $# -ne 2) &&
        echo "usage: bgresmodel [-m bgmult|$bgmult] [-s scale|$scale] [-b setbgval]" \
            "<set> <refset1,refset2,...>" >&2 &&
        return 1

    # get extension from first reference image
    ext=""
    refdir=$(dirname ${reflist%%,*})
    sname=$(basename ${reflist%%,*})
    test -e $refdir/$cdir/$sname.bgm${bgmult}res.pgm && ext="pgm"
    test -e $refdir/$cdir/$sname.bgm${bgmult}res.ppm && ext="ppm"
    test -z "$ext" &&
        echo "ERROR: missing image ${reflist%%,*}.p[pg]m" >&2 && return 255

    # measure bgvalue on target
    if [ -z "$bgval" ]
    then
        bgval=($(AImstat -c $target.$ext | awk '{
            printf("%s", $5); if(NF>13) {printf(" %s %s", $9, $13)}}'))
        test "$verbose" && echo "# bgval=${bgval[@]}" >&2
    fi
    ncol=${#bgval[@]}
    test "$ext" == "ppm" && test $ncol -eq 1 && bgval=$bgval" "$bgval" "$bgval
        
    # normalize bgres images in each color
    for sname in ${reflist//,/ }
    do
        refdir=$(dirname $sname)
        sname=$(basename $sname)
        x=($(AIstat -c $refdir/$cdir/$sname.bgm${bgmult}.$ext | awk -v m=$bgmult '{
            printf("%s", $5/m); if(NF>13) {printf(" %s %s", $9/m, $13/m)}}'))
        test "$verbose" && echo "# $refdir/$sname: x=${x[@]}" >&2
        for i in $(seq 0 $((ncol-1)))
        do
            mult[$i]=$(echo ${x[i]} ${bgval[i]} | \
                awk -v s=$scale '{printf("%.4f", $2/$1*s)}')
            add[$i]=$(echo ${x[i]} ${bgval[i]} | \
                awk -v b=$bgres -v s=$scale '{printf("%.1f", b-$2/$1*s*b)}')
        done
        test "$verbose" && echo "mult=${mult[@]} add=${add[@]}" >&2
        x=$(basename $refdir | tr '/' '_')
        test "$x" == "." && x=""
        test "$x" && x=${x}"_"
        pnmccdred -m $(echo ${mult[@]} | tr ' ' ',') $refdir/$cdir/$sname.bgm${bgmult}res.$ext - | \
        pnmccdred -a $(echo ${add[@]} | tr ' ' ',') - $wdir/$x$sname.norm.$ext
    done
    
    # get min
    convert $wdir/*.norm.$ext -evaluate-sequence min ${ext}:-

    #echo $wdir >&2
    rm -rf $wdir
}


AIval () {
    # get intensities for given pixels
    # old syntax: AIval [img] [refpix] [size] used by AIoverscan, AInoise
    local showcoords    # if set show image coordinates
    local showhelp
    local do_allpixels  # if set then all image pixel are printed
    local matchval=-1
    for i in $(seq 1 5)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-c" && showcoords=1 && shift 1
        test "$1" == "-a" && do_allpixels=1 && shift 1
        test "$1" == "-0" && matchval=0 && shift 1
        test "$1" == "-1" && matchval=1 && shift 1
    done
    
    local img=${1:-""}
    local cw=${2:-"1"}
    local ch=${3:-"1"}
    local cx=${4:-""}   # empty = center box
    local cy=${5:-""}   # empty = center box
    local sc
    local fname
    local line
    local w
    local h
    local cmd
    local tmp1=$(mktemp "/tmp/tmp_img_$$.XXXXXX")

    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: AIval [-a] [-c] [-0|1] <img> [w] [h] [x_topleft] [y_topleft]" >&2 &&
        return 1

    sc=0
    test "$showcoords" && sc=1
    #test $matchval -ge 0 && sc=1
    #test "$showcoords" || matchval=-1

    # handle image via stdin
    if [ "$img" != "-" ]
    then
        fname=$(get_imfilename $img)
        test -z "$fname" && return 255
    else
        cat "$img" > $tmp1
        fname="$tmp1"
    fi

    # get image width and height
    if is_raw "$fname"
    then
        line=$(dcraw-tl -i -v "$fname" | grep "^Image size:")
        w=$(echo $line | cut -d " " -f3)
        h=$(echo $line | cut -d " " -f5)
    else
        w=$(identify $fname | cut -d " " -f3 | cut -d "x" -f1)
        h=$(identify $fname | cut -d " " -f3 | cut -d "x" -f2)
    fi
    
    if [ "$do_allpixels" ]
    then
        cw=$w
        ch=$h
        cx=0
        cy=0
    else
        # determine crop area
        test -z "$cx" && cx=$(((w-cw)/2))
        test -z "$cy" && cy=$(((h-ch)/2))
    
        # truncates cx and cy to integer
        cx=$(echo $cx | awk '{print int($1)}')
        cy=$(echo $cy | awk '{print int($1)}')
    fi
    
    # crop and show values
    if is_pnm "$fname"
    then
        cmd="gm convert \"$fname\" -crop ${cw}x${ch}+${cx}+${cy} -"
    else
        cmd="imcrop -1 \"$fname\" \"$cw\" \"$ch\" \"$cx\" \"$cy\""
    fi
    test "$AI_DEBUG" && echo "$cmd" >&2

    eval "$cmd" | pnmnoraw - | \
    awk -v sc=$sc -v cw=$cw -v ch=$ch -v cx=$cx -v cy=$cy -v m=$matchval 'BEGIN{
        row=1; col=1; maxval=1
    }{
        if (NR==1) {
            if ($0=="P1") {type=1; skip=2}
            if ($0=="P2") {type=2; skip=3}
            if ($0=="P3") {type=3; skip=3}
        }
        if(type>1 && NR==3) maxval=$1 
        if(NR>skip) {
            if (type==3) np=split($0, p, "  ")
            if (type==2) np=split($0, p, " ")
            if (type==1) {
                if ((m==0) && ($0!~/0/)) {
                    col=col+length($0); np=0
                } else {
                    if ((m==1) && ($0!~/1/)) {
                        col=col+length($0); np=0
                    } else {
                        np=split($0, p, "")
                    }
                }
            }
            for(i=1;i<=np;i++) {
                if (sc==0) {
                    if (m<0 || p[i]==m*maxval) printf("%s\n", p[i])
                } else {
                    if (m<0 || p[i]==m*maxval)
                        printf("%d %d %s\n", cx+col-1, cy+row-1, p[i])
                    col++
                }
            }
            if (col>cw) {row++; col=1}
        }
    }'
    
    # cleanup
    rm -f $tmp1
}


AIpeak () {
    # TODO: improve performance by running parallel processes
    local showhelp
    local channel=2     # color channel
    local merrlim=0.01  # max. photometric error of objects
    local nmax=100      # max. number of objects
    local i
    for i in 1 2 3 4
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        (test "$1" == "-1" || test "$1" == "-2" || test "$1" == "-3") &&
            channel=${1#-} && shift 1
        test "$1" == "-m" && merrlim=$2 && shift 2
        test "$1" == "-n" && nmax=$2 && shift 2
    done

    local img=$1        # image with objects to measure
    local sdat=${2:-""} # sextractor datafile containing object locations
    local dmax=3        # box size = 1+2*dmax
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmp1=$(mktemp "$tdir/tmp_dat.XXXXXX.dat")
    local tmpimg=$(mktemp "$tdir/tmp_img.XXXXXX.pgm")
    local grayimg
    local rmax
    local n
    local bsize
    local x
    local y
    local a
    local e
    local f
    local m
    local z
    local xi
    local yi
    local max
    
    (test "$showhelp" || test $# -eq 0 || test $# -gt 2) &&
        echo -e "usage: AIpeak [-1|2|3] [-m magerrlim|$merrlim]" \
            "[-n nmax|$nmax] <img> [sdat]" >&2 &&
        return 1
    
    test ! -f "$img" &&
        echo "ERROR: file $img does not exist." >&2 && return 255
    test -z "$sdat" && sdat=${img%.*}.src.dat
    test ! -e $sdat &&
        echo "ERROR: file $sdat does not exist." >&2 && return 255

    # extract single color channel from image
    if is_ppm $img
    then
        case $channel in
            1)  gm convert $img -channel red   $tmpimg && grayimg=$tmpimg;;
            2)  gm convert $img -channel green $tmpimg && grayimg=$tmpimg;;
            3)  gm convert $img -channel blue  $tmpimg && grayimg=$tmpimg;;
        esac
    fi
    is_pgm $img && channel=1 && grayimg=$img
    test -z "$grayimg" &&
        echo "ERROR: unsupported image type." >&2 && return 255
    
    # determine size of center circle with nmax objects
    rmax=$(imsize $grayimg | tr ' ' '\n' | sort -n | head -1 | awk '{printf("%d", $1/3)}')
    sexselect -x -$channel $sdat "" $merrlim $rmax "" "" 99 > $tmp1
    n=$(grep -v "^#" $tmp1 | wc -l)
    echo "channel=$channel, magerrlim=$merrlim, r=$rmax, n=$n" >&2
    if [ $n -gt $((nmax*15/10)) ]
    then
        rmax=$(echo $rmax $n | awk -v nmax=$nmax '{printf("%d", $1*sqrt(nmax/$2))}')
        echo "reducing rmax to $rmax" >&2
        sexselect -x -$channel $sdat "" $merrlim $rmax "" "" 99 > $tmp1
    fi
    
    #echo "# id     peak  a    fwhm mag"
    bsize=$((1+2*dmax))
    grep -v "^#" $tmp1 | \
    while read id x y a e f m z
    do
        xi=$(echo $x $bsize | awk '{printf("%.0f", $1-0.5-($2-1)/2)}')
        yi=$(echo $y $bsize | awk '{printf("%.0f", $1-0.5-($2-1)/2)}')
        test "$AI_DEBUG" && echo "$id $x $y $xi $yi" >&2
        #max=$(AIval $grayimg $bsize $bsize $xi $yi | sort -n | tail -1)
        max=$(gm convert $grayimg -crop ${bsize}x${bsize}+${xi}+${yi} - | \
            pnmnoraw | sed '1,3d' | tr ' ' '\n' | sort -n | tail -1)
        LANG=C printf "%-8s %5d %4.2f %4.2f %5.2f\n" $id $max $a $f $m
    done | AIplot -p -t "Peak Intensity of Objects in $img" -g "set xlabel 'mag'; set ylabel 'peak / ADU'" - 5 2
    rm -f $tmp1 $tmpimg
}


AIimlist () {
    # get image list for sets of a certain type
    #   exclude images according to $AI_EXCLUDE
    #   checks if input image files exist in the following directories:
    #   . $AI_TMPDIR $AI_RAWDIR
    # splitted image sets: lines using the same set name and exposure time
    #   but type==a (nref,dark,bias are ignored but should be set to "-")
    #   TODO: match nref as well, use dark and flat as given in each line
    #         modify AIccd and AIfindbad accordingly
    #AIcheck_ok -q || return 255
    local showhelp
    local show_file_only
    local show_num_only
    local no_image_check
    local do_check_reg  # if set check for corresponding entry in reg.dat
    local quiet
    local i
    for i in $(seq 1 6)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-f" && show_file_only=1 && shift 1
        test "$1" == "-n" && show_num_only=1 && shift 1
        test "$1" == "-r" && do_check_reg=1 && shift 1
        test "$1" == "-x" && no_image_check=1 && shift 1
        test "$1" == "-q" && quiet=1 && shift 1
    done

    local setname=${1:-""}
    local insuffix=${2:-""}     # filename part after number
    local inext=${3:-""}        # file extension, if empty search ppm/pgm/pnm
    local intype=${4:-""}
    local sdat=${AI_SETS:-"set.dat"}
    local ex=${AI_EXCLUDE:-""}  # space separated list of image numbers
    local tmp1=$(mktemp "/tmp/tmp_flist_$$.XXXXXX")
    local inpath=""
    local rawext="cr2 pef nef raf dng fit fits fitzip"
    local ltime
    local sname
    local target
    local type
    local texp
    local n1
    local n2
    local nref
    local dark
    local flat
    local ext
    local nlist
    local cmd
    local x
    local num
    local ext
    local extlist
    local f
    local use_rdat
    

    test "$showhelp" &&
        echo "usage: AIimlist [-q] [-f|-n] [-r|-x] [set] [insuffix] [inext|$inext] [intype|$intype]" >&2 &&
        return 1

    # allow uppercase extension in raw image file names
    rawext=$(echo $(for x in $rawext; do echo ${x,,} ${x^^}; done))

    while read ltime sname target type texp n1 n2 nref dark flat x
    do
        #(echo "$ltime" | grep -q "^#") && continue
        test "${ltime:0:1}" == "#" && continue
        test "$setname" && test "$sname" != "$setname" && continue
        test -z "$setname" && test "$intype" && test "$type" != "$intype" && continue
        test ${#type} -ne 1 && continue
        is_integer $n1 || continue
        is_integer $n2 || continue
        test "$type" == "a" && continue
        test $n2 -lt $n1 && n2=$((n2+10000))    # e.g. image number wrap on DSLRs
        nlist=$(seq $n1 $n2 | awk '{printf("%04d\n", $1)}')
        
        # try to find associated images of the same set (splitted sets)
        cmd=$(grep -v "^#" $sdat | awk -v s=$sname -v e=$texp -v n1=$n1 -v n2=$n2 '{
            if ($2==s && $4=="a" && $5==e && $6!=n1 && $7!=n2) {
                printf("seq %s %s;", $6, $7)}}')
        test "$cmd" && nlist="$nlist $(eval "$cmd" | awk '{printf("%04d\n", $1)}')"
        test "$AI_DEBUG" && echo "nlist="$nlist >&2
        test -z "$setname" && test -z "$quiet" && echo "set $sname" >&2


        use_rdat=""
        inpath=""
        for num in $nlist
        do
            test $num -gt 9999 && num=$(echo $num | awk '{printf("%04d", $1-10000)}')
            echo $ex | grep -q -w $num - &&
                (test ! "$quiet" && echo "excluding image $num." >&2 || true) && continue
            test "$no_image_check"  && echo "$num" && continue
            test "$do_check_reg" && test -s reg.dat &&
                grep -q -w "^$num" reg.dat &&
                echo "$num" && continue
            
            # find inpath and set inext
            if [ -z "$inpath" ]
            then
                extlist=$inext
                test "$inext" == "raw" && extlist=$rawext
                test -z "$inext" && extlist="ppm pgm pnm"
                for ext in $extlist
                do
                    test -z "$inpath" && test -f "./$num$insuffix.$ext" &&
                        inpath="."
                    test -z "$inpath" && test -f "$AI_TMPDIR/$num$insuffix.$ext" &&
                        inpath="$AI_TMPDIR"
                    test -z "$inpath" && test -f "$AI_RAWDIR/$num$insuffix.$ext" &&
                        inpath="$AI_RAWDIR"
                    test "$inpath" && break
                done
                if [ -z "$inpath" ] && [ "$inext" == "raw" ]
                then
                    # try to read file name from exif.dat/rawfiles.dat
                    f=$(get_rawfile $num 2>/dev/null | head -1)
                    test "$f" &&
                        ext=$(echo $f | sed -e 's,.*\.,,') &&
                        inpath=$(dirname $f) &&
                        use_rdat=1 &&
                        test "$AI_DEBUG" && echo "# ext=$ext" >&2
                fi
                if [ "$AI_DEBUG" ] && [ "$inpath" ]
                then
                    if [ "$use_rdat" ]
                    then
                        echo "found images in directory $inpath (using get_rawfile)" >&2
                    else
                        echo "found images in directory $inpath (ext=$ext)" >&2
                    fi
                fi
            fi
            
            test -z "$inpath" &&
                (test ! "$quiet" &&
                    echo "WARNING: no image dir found for $num$insuffix.$inext." >&2 || true) &&
                continue
            if [ "$use_rdat" ]
            then
                #f="$inpath/$(grep -w "^$num" $rdat | awk '{printf("%s", $2)}')"
                f=$(get_rawfile $num 2>/dev/null | head -1)
            else
                f="$inpath/$num$insuffix.$ext"
            fi
            (test -z "$f" || test ! -f "$f") &&
                (test ! "$quiet" &&
                    echo "WARNING: $f not found." >&2 || true) &&
                continue
            
            # output
            test "$show_file_only" && echo "$f" && continue
            test "$show_num_only"  && echo "$num" && continue
            echo "$sname $num $f $nref $dark $flat"
        done
        if [ -z "$no_image_check" ] && [ -z "$do_check_reg" ] && [ -z "$inpath" ]
        then
            test "$setname" &&
                echo "ERROR: no images found for set $sname." >&2 && return 255
            test ! "$quiet" && echo "WARNING: no images found for set $sname." >&2
        fi
    done < $sdat
    rm $tmp1
    return 0
}


AIexamine () {
    # interactively examine images using ds9 and analysis scripts
    # note:
    #   the name of the default ds9 instance is AIRTOOLS
    #   the name of newly started instance is written to env variable DS9NAME
    #   the analysis 
    local showhelp
    local wcshead
    local afile="airds9.ana"    # default ds9 analysis file
    local small=0               # if > 0 reduce window size
    local ds9opts               # xpaset commands to be added at the end
    local ds9name="AIRTOOLS"
    local do_linear
    local do_lock_colorbar
    local do_replace_image
    local verbose
    local i
    for i in 1 2 3 4 5 6 7 8 9 10
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-w" && wcshead=$2 && shift 2
        test "$1" == "-a" && afile=$2 && shift 2
        test "$1" == "-n" && ds9name=$2 && shift 2
        test "$1" == "-v" && verbose=1 && shift 1
        test "$1" == "-s" && small=$((small+1)) && shift 1
        test "$1" == "-p" && ds9opts="$2" && shift 2
        test "$1" == "-l" && do_linear=1 && shift 1
        test "$1" == "-c" && do_lock_colorbar=1 && shift 1
        test "$1" == "-r" && do_replace_image=1 && shift 1
    done
    local tdir=${AI_TMPDIR:-"/tmp"}
    local sdat=${AI_SETS:-"set.dat"}
    local tmp1=$(mktemp "$tdir/tmp_wcs_XXXXXX.head")
    local pardir=$(mktemp -d "$tdir/tmp_par_XXXXXX")
    local add
    local ilist=""
    local tlist=""
    local slist=""
    local nimg=0
    local cx
    local cy
    local opts
    local fopts
    local xcmd
    local fxcmd
    local infile
    local zoom
    local pan
    local geom
    local has_wcs=1
    local firstimage
    local lastimage
    local par
    local tel
    local str
    local pan
    local zoom
    local ext
    local keys
    local sw
    local sh
    local w
    local h
    local sname
    local newframe
    local hdr
    

    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: AIexamine [-v] [-l] [-c] [-n ds9name] [-w wcshead] [-a ds9anafile] <image1|regfile1> [image2|regfile2 ...]" >&2 &&
        return 1
    ! type -p ds9 > /dev/null 2>&1 &&
        echo "ERROR: program ds9 not in search path." >&2 && return 255
    test "$wcshead" && test ! -f "$wcshead" &&
        echo "ERROR: file $wcshead not found." >&2 && return 255
    
    test "$AI_DEBUG" && verbose=$((verbose+1))
    
    # check for an existing instance of ds9
    case "$(xpaaccess -n -t "2,2" $ds9name)" in
        0)  add="";;
        1)  add=1;;
        *)  echo "WARNING: multiple ds9 instances using name $name." >&2
            add=1;;
    esac


    # ds9 startup options
    sw=$(xrandr --current | grep "^Screen 0" | tr ',' '\n' | grep current | awk '{print $2}')
    sh=$(xrandr --current | grep "^Screen 0" | tr ',' '\n' | grep current | awk '{print $4}')
    h=$((sh-80))
    test $h -gt 1200 && h=1200
    case "$small" in
        0)  w=$((h-150));;
        1)  h=$((h*75/100)); w=$((h-100));;
        *)  h=$((h*58/100)); w=$((h-50));;
    esac
    test $w -lt 480 && w=480
    geom="${w}x${h}"
    test "$AI_DEBUG" && echo "screen=${sw}x${sh}  geom=$geom" >&2
    opts="-title $ds9name -geometry $geom -regions system physical -view physical no"
    test $small -gt 1 && opts="$opts -view colorbar no -view panner no -view object no \
        -view magnifier no -view frame no"
    # TL: line disabled in v2.8.1 to suit ds9 v7.5
    #opts="$opts -frame delete"

    # check for analysis file
    if [ "$afile" ]
    then
        str=$(type -p $afile)
        test -z "$str" && test -e $afile &&
            str=$afile
        test -z "$str" && test -e /usr/share/airtools/$afile &&
            str=/usr/share/airtools/$afile
        test -z "$str" && test -e /usr/local/share/airtools/$afile &&
            str=/usr/local/share/airtools/$afile
        test -z "$str" &&
            echo "ERROR: ds9 analysis file $afile not found." >&2 &&
            return 255
        afile=$str
        opts="$opts -analysis load $afile"
    fi
    test "$AI_DEBUG" && echo "afile=$afile" >&2

    # set ds9 options for intensity scaling
    if [ "$do_linear" ]
    then
        fopts="-scale linear"
    else
        fopts="-scale log"
    fi
    fopts="$fopts -scale mode zmax"  # -cmap value 2.5 0.15

    # set xpa commands to be used for every image
    if [ "$add" ]
    then
        zoom=$(xpaget $ds9name zoom)
        pan=$(xpaget $ds9name pan)
        fxcmd="xpaset -p $ds9name zoom to $zoom; xpaset -p $ds9name pan to $pan"
    fi
    
    # determine if images are loaded into new frame or current frame
    newframe="new"
    test "$do_replace_image" && newframe=""
    
    # cycle over input files and create ds9 input file parameter list
    xcmd=""
    for infile in "$@"
    do
        test ! -f "$infile" &&
            echo "ERROR: input file $infile does not exist." >&2 && return 255
        # check region file
        is_reg "$infile" &&
            opts="$opts -region $infile" &&
            xcmd="$xcmd; xpaset -p $ds9name region $infile" &&
            continue
        # check image file type
        ftype=""
        is_fitzip $infile && ftype="FITZIP"
        is_fitscube $infile && ftype="FITSCUBE"
        test -z "$ftype" && ftype=$(identify $infile | cut -d " " -f2)
        test -z "$ftype" &&
            echo "ERROR: $infile is neither region file nor image." >&2 && return 255
        test "$AI_DEBUG" && echo "$ftype: $infile" >&2
        b=$(basename ${infile%.*})
        case "$ftype" in
            FITS)   opts="$opts -fits $infile"
                    xcmd="$xcmd; xpaset -p $ds9name fits $newframe $infile"
                    ! is_wcs $infile && has_wcs=""
                    test -z "$firstimage" && firstimage=$infile
                    lastimage=$infile
                    nimg=$((nimg + 1));;
            FITZIP) tfits=$tdir/tmp_${RANDOM}_$b.fits
                    unzip -p $infile > $tfits
                    tlist="$tlist $tfits"
                    opts="$opts -fits $tfits"
                    xcmd="$xcmd; xpaset -p $ds9name fits $newframe $tfits"
                    ! is_wcs $tfits && has_wcs=""
                    test -z "$firstimage" && firstimage=$infile
                    lastimage=$infile
                    nimg=$((nimg + 1));;
            FITSCUBE) tfits=$tdir/tmp_${RANDOM}_$b.fits
                    imslice $infile 2 > $tfits
                    tlist="$tlist $tfits"
                    opts="$opts -fits $tfits"
                    xcmd="$xcmd; xpaset -p $ds9name fits $newframe $tfits"
                    ! is_wcs $tfits && has_wcs=""
                    test -z "$firstimage" && firstimage=$infile
                    lastimage=$infile
                    nimg=$((nimg + 1));;
            PBM|PGM|PPM|PNG)
                    hdr=${infile%.*}.head
                    test -f $hdr || hdr=""
                    
                    tfits=$tdir/$b.tmp_${RANDOM}.fits
                    if [ $ftype == "PPM" ]
                    then
                        ppm2gray -q -f $infile $hdr > $tfits
                    else
                        if [ $ftype == "PGM" ]
                        then
                            ppm2gray -q -f $infile $hdr > $tfits
                        else
                            gm convert $infile pgm:- | ppm2gray -q -f - $hdr > $tfits
                        fi
                    fi
                    # TODO: the arbitrary wcs header should be removed by AIstack
                    false && test "$hdr" &&
                        str=$(get_header -q $hdr SOFTNAME) &&
                        test "$(echo $str | tr '[A-Z]' '[a-z]')" == "swarp" &&
                        str=$(get_header -q $hdr AUTHOR) &&
                        test "$(echo $str | tr '[A-Z]' '[a-z]')" == "lehmann" &&
                        delwcs $tfits
                    test "$hdr" && delwcs $tfits
                    sethead $tfits AI_IMAGE=$infile
                    if [ "$wcshead" ]
                    then
                        cat "$wcshead" | grep -Ev "^SIMPLE|^BITPIX|^NAXIS" > $tmp1
                        sethead $tfits "@${tmp1}"
                        cx=$(identify $infile | cut -d " " -f3 | awk -F x '{print $1/2}')
                        cy=$(identify $infile | cut -d " " -f3 | awk -F x '{print $2/2}')
                        sethead $tfits CRPIX1=$cx CRPIX2=$cy
                        ! is_wcs $tmp1 && has_wcs=""
                    else
                        has_wcs=""
                    fi
                    tlist="$tlist $tfits"
                    opts="$opts -fits $tfits"
                    xcmd="$xcmd; xpaset -p $ds9name fits $newframe $tfits"
                    test -z "$firstimage" && firstimage=$infile
                    lastimage=$infile
                    nimg=$((nimg + 1));;
            *)      echo "WARNING: ignoring $infile, unsupported filetype $ftype." >&2
                    continue;;
        esac
        xcmd="$xcmd; $fxcmd"
    done
    xcmd=$(echo $xcmd | sed -e 's,^;,,')

    # more ds9 command line options
    test $nimg -gt 1 && opts="$opts -single -frame first"
    opts="$opts -mode region $fopts -match scale -match colorbar"
    test "$do_lock_colorbar" && opts="$opts -lock scale yes -lock colorbar yes"
    test "$has_wcs" &&
        opts="$opts -lock frame wcs"
    test ! "$has_wcs" &&
        opts="$opts -lock frame image"


    #### creating ds9 parameter files used by analysis tasks
    test -d $pardir || mkdir $pardir

    # names of all image sets
    test -f $sdat && slist=$(grep -v "^#" $sdat | awk '{
            x=$5""$6""$7; gsub(/[0-9]/,"",x); if($4=="o" && x==""){print $2}}' | \
        tr '\n' '|' | sed -e 's/.$//')
    # get setname from $firstimage or use first entry in $slist
    if [ "$firstimage" ]
    then
        sname=$(basename $firstimage)
        sname=${sname%%.*}
        echo $slist | grep -q -w $sname
        test $? -ne 0 && sname=""
    fi
    test -z "$sname" && sname=$(echo $slist | awk -F "|" '{printf("%s", $1)}')
    
    if [ "$afile" ] # && [ ! "$(xpaget xpans 2>/dev/null)" ]
    then
        # ref.: https://heasarc.gsfc.nasa.gov/lheasoft/headas/pil/node12.html
        # default parameter file used by tasks test, regstat, imflip
        cat <<EOF > $pardir/airtools.par
#
# default airtools parameter file
#
image,s,l,,,,"Image file name (default: current image)"
EOF
        #cp -p $pardir/airtools.par $pardir/regstat.par
        #cp -p $pardir/airtools.par $pardir/imflip.par

        cat <<EOF > $pardir/regphot.par
#
# regphot parameter file
#
image,s,l,,,,"Image to be measured (default: current)"
bgrgb,s,l,2000,,,"Background rgb (comma separated)"
EOF
#photcat,s,l,,,,"Photometry data file (default: comet/\$sname.newphot.dat)"
#ddiff,r,l,,,,"Approx. mag difference in case of double star"

        # determine mag limit for astrometric ref catalog stars
        # depending on magzero
        par=("" "" ""); str=""
        tel=$(get_telescope $sname 2>/dev/null)
        if [ "$tel" ]
        then
            # mlim
            str=$(get_param camera.dat magzero $tel "" 15)
            test "$str" && test "$(echo $str 19 | awk '{if($1<$2)print 1}')" &&
                par[0]="$(echo $str | awk '{x=$1-3.6; printf("%.1f", int(2*x)/2)}')"
            # determine default north angle (taken from camera.dat)
            str=$(get_param camera.dat rot $tel "" 0)
            test "$str" == "-" && str="0"
            # itel: PIERSIDE=WEST == IMGROLL=N: using rot from camera.dat
            # check PIERSIDE keyword, if required adjust north angle
            test "$(get_header -q $firstimage PIERSIDE 2>/dev/null | tr -d ' ')" == "EAST" &&
                str=$((str+180))
            test "$str" && par[1]="$str"
        fi
        
        cat <<EOF > $pardir/wcscalib.par
#
# wcscalib parameter file
#
starstack,s,l,,,,"Image stacked on stars (default: current)"
catalog,s,l,ucac-4,ucac-4|ucac-3|ppmx,,"Astrometric reference catalog"
maglim,r,l,"${par[0]}",,,"Limiting magnitude"
thres,r,l,10,,,"Detection threshold for stars in image"
north,r,l,"${par[1]}",,,"North position angle (0: N is up; 90: N is left)"
opts,s,l,,,,"Additional options passed to scamp"
EOF
        #cat $pardir/wcscalib.par

        cat <<EOF > $pardir/bggradient.par
#
# bggradient parameter file
#
starstack,s,l,,,,"Image stacked on stars (default: current)"
bgmult,r,l,10,,,"Multiplier for intensity stretching"
EOF

        par=("")     # id's of skipped stars (flagged by leading '#')
        test -f comet/$sname.psfphot.dat &&
            par=("$(echo $(grep "^#" comet/$sname.psfphot.dat | \
            cut -d " " -f1 | tr -d '#'))")
        # TODO: make better guess of psfsize
        cat <<EOF > $pardir/psfextract.par
#
# psfextract parameter file
#
set,s,l,$sname,$slist,,"Name of image set"
starstack,s,l,$firstimage,,,"Image stacked on stars"
rlim,r,l,10,,,"Max distance of stars from comet (in % of image size)"
merrlim,r,l,0.2,,,"Max error of background star mag"
psfsize,r,l,128,,,"Width of psf (in pix)"
skip,s,l,"${par[0]}",,,"Stars to exclude from psf creation (space sep.)"
EOF

        par=("")     # streched image used for bg correction
        ext=""
        is_pgm $firstimage && ext="pgm"
        is_ppm $firstimage && ext="ppm"
        if [ "$ext" ]
        then
            par=("$(ls -tr bgcorr/$sname.bgm*.$ext 2>/dev/null | \
                grep -E "$sname.bgm[0-9]*.$ext|$sname.bgm[0-9]*all.$ext" | tail -1)")
            test -z ${par[0]} && par=("bgcorr/$sname.bgm10.$ext")
        fi
        cat <<EOF > $pardir/cometextract.par
#
# cometextract parameter file
#
set,s,l,$sname,$slist,,"Name of image set"
starstack,s,l,$firstimage,,,"Image stacked on stars"
bgimage,s,l,${par[0]},,,"Background correction image (stretched)"
comult,r,l,10,,,"Multiplier for stretching contrast before photometry"
EOF

        # TODO: read parameter values from $sname.head
        par=("1" "1")
        is_ppm $firstimage && par=("2" "1|2|3")
        if [ -f $sname.head ]
        then
            par=("${par[@]}" "$(get_header -q $sname.head AI_ACOR${par[0]})")
            par=("${par[@]}" "$(get_header -q $sname.head AI_ALIM${par[0]})")
            par=("${par[@]}" "$(get_header -q $sname.head AI_DLEN)")
            par=("${par[@]}" "$(get_header -q $sname.head AI_DANG)")
            par=("${par[@]}" "$(get_header -q $sname.head AI_PLEN)")
            par=("${par[@]}" "$(get_header -q $sname.head AI_PANG)")
        fi
        cat <<EOF > $pardir/manualdata.par
#
# manual measurements parameter file
#
set,s,l,$sname,$slist,,"Name of image set"
idx,s,l,${par[0]},${par[1]},,"Image plane (or extension)"
ccorr,s,l,${par[2]},,,"Manual correction of comets measured ADU"
stlim,s,l,${par[3]},,,"Limiting star total ADU"
dtlen,s,l,${par[4]},,,"Dust tail length in pixel"
dtang,s,l,${par[5]},,,"Dust tail angle in image (right=0)"
ptlen,s,l,${par[6]},,,"Plasma tail length in pixel"
ptang,s,l,${par[7]},,,"Plasma tail angle in image (right=0)"
EOF

        # list of reference catalog color bands and indexes
        par[2]="B+c(B-V)|V|V+c(B-V)|V+c(V-R)|R+c(V-R)"
        str="V+c(B-V)"
        cat <<EOF > $pardir/photcal.par
#
# photometry parameter file
#
set,s,l,$sname,$slist,,"Name of image set"
idx,s,l,${par[0]},${par[1]},,"Image plane (or extension)"
catalog,s,l,apass,apass|tycho2,,"Photometric reference catalog"
color,s,l,$str,${par[2]},,"Catalog color band and color index to fit"
aprad,r,l,"",,,"Aperture radius (empty=automatic)"
topts,s,l,"-l 12.5",,,"Options applied for Tycho2 stars"
aopts,s,l,"-n 200",,,"Options applied for APASS stars"
skip,s,l,,,,"Stars to exclude (space sep.)"
EOF

    fi

    # display images
    if [ "$add" ]
    then
        test "$verbose" && echo $xcmd >&2
        echo "$xcmd" | bash
    else
        # UPARM is used by ds9 when searching for parameter files
        # user modified variables are NOT written back to parameter files
        export DS9NAME=$ds9name
        export UPARM=$pardir
        test "$verbose" && echo ds9 $opts $ds9opts >&2
        ds9 $opts $ds9opts
    fi

    test "$tlist" && test -z "$AI_DEBUG" && rm $tlist
    rm -f $tmp1
    rm -f $pardir/*
    rmdir $pardir
    return
}


AIimcompare () {
    local showhelp
    local no_divide     # not implemented yet
    local do_average    # if set, then average of img1 img3 are compared to img2=ref
    local dmag
    for i in 1 2 3 4
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-a" && do_average=1 && shift 1
        test "$1" == "-n" && no_divide=1 && shift 1
        test "$1" == "-m" && dmag=$2 && shift 2
    done
    #local image1=${1:-""}
    #local image2=${2:-""}
    #local image3=${3:-""}
    local img1=${1:-""}
    local ref=${2:-""}
    local img2=${3:-""}
    local sdat=${AI_SETS:-"set.dat"}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local wdir=$(mktemp -d "$tdir/tmp_imcomp_XXXXXX")
    local tmpgray=$(mktemp "$wdir/tmp_gray_XXXXXX.pnm")
    local tmpref=$(mktemp "$wdir/tmp_ref_XXXXXX.pnm")
    local tmpim1=$(mktemp "$wdir/tmp_im1_XXXXXX.pnm")
    local tmpim2=$(mktemp "$wdir/tmp_im2_XXXXXX.pnm")
    local mean=$(mktemp "$wdir/tmp_mean_XXXXXX.pnm")
    local mask=$(mktemp "$wdir/tmp_mask_XXXXXX.pnm")
    local div=$(mktemp "$wdir/tmp_div_XXXXXX.pnm")
    local diff=$(mktemp "$wdir/tmp_diff_XXXXXX.pnm")
    local difflow=$(mktemp "$wdir/tmp_difflow_XXXXXX.pnm")
    local tmpscat=$(mktemp "$wdir/tmp_scat_XXXXXX.dat")
    local tmp1=$(mktemp "$wdir/tmp_dat1_XXXXXX.dat")
    local tmp2=$(mktemp "$wdir/tmp_dat2_XXXXXX.dat")
    local tmpreg=$(mktemp "$wdir/tmp_reg_XXXXXX.dat")
    local bgmean=1000    # background of tmpim1, tmpim2, mean image
    local bgdiff=20000  # average intensity of diff image
    local add
    local x
    #local ref
    #local img1
    #local img2
    local aprad
    local mhigh
    local low
    local val
    local imlist
    local ds9opts

    (test "$showhelp" || test $# -lt 2 ) &&
        echo "usage: AIimcompare [-h] [-a] [-m dmag] <image> <refimage> [checkimage]" >&2 &&
        return 1

    # check if header files exist
    for x in $img1 $ref $img2
    do
        test ! -f $x && echo "ERROR: image $x not found." >&2 && return 255
        test ! -f ${x%.*}.head &&
            echo "ERROR: image header file ${x%.*}.head is missing" >&2 && return 255
        test ! -f ${x%.*}.wcs.head &&
            echo "ERROR: wcs header file ${x%.*}.wcs.head is missing" >&2 && return 255
    done
    
    # determine reference image
    #img1=$image1; ref=$image2; img2=""
    #test "$image3" && ! test "$do_average" && ref=$image3 && img2=$image2
    #test "$image3" &&   test "$do_average" && ref=$image2 && img2=$image3

    
    # remove bg structure and warp ref image
    echo "warping images ..."
    ppm2gray $ref > $tmpgray
    pgmtopbm -threshold -value 0.000001 $tmpgray > $mask
    (cd $wdir && AIbgmap -q $tmpgray 256 1 $mask)
    imbgsub $tmpgray ${tmpgray%.*}".bgm1.pgm" "" 1 "" $bgmean | \
        pnmarith -mult - $mask > $tmpref
    cp ${ref%.*}.head ${tmpref%.*}.head
    cp ${ref%.*}.wcs.head ${tmpref%.*}.wcs.head
    (cd $wdir && AIwarp -q -r bilinear -w $mask $tmpref)

    # remove bg structure and warp img1/img2
    ppm2gray $img1 > $tmpgray
    pgmtopbm -threshold -value 0.000001 $tmpgray > $mask
    (cd $wdir && AIbgmap -q $tmpgray 256 1 $mask)
    imbgsub $tmpgray ${tmpgray%.*}".bgm1.pgm" "" 1 "" $bgmean | \
        pnmarith -mult - $mask > $tmpim1
    cp ${img1%.*}.head ${tmpim1%.*}.head
    cp ${img1%.*}.wcs.head ${tmpim1%.*}.wcs.head
    (cd $wdir && AIwarp -q -r bilinear -w $mask ${tmpref%.*}.warped.head $tmpim1)
    if [ "$img2" ]
    then
        ppm2gray $img2 > $tmpgray
        pgmtopbm -threshold -value 0.000001 $tmpgray > $mask
        (cd $wdir && AIbgmap -q $tmpgray 256 1 $mask)
        imbgsub $tmpgray ${tmpgray%.*}".bgm1.pgm" "" 1 "" $bgmean | \
            pnmarith -mult - $mask > $tmpim2
        cp ${img2%.*}.head ${tmpim2%.*}.head
        cp ${img2%.*}.wcs.head ${tmpim2%.*}.wcs.head
        (cd $wdir && AIwarp -q -r bilinear -w $mask ${tmpref%.*}.warped.head $tmpim2)
    fi

    
    # create mean images
    echo "creating mean and mask images ..."
    if [ "$img2" ] && [ "$do_average" ]
    then
        # mask of all images
        pnmarith -minimum ${tmpref%.*}.warped.pgm ${tmpim1%.*}.warped.pgm | \
            pnmarith -minimum - ${tmpim2%.*}.warped.pgm | \
            pgmtopbm  -threshold -value 0.000001 > $mask
            #convert - -morphology Dilate Disk:1.5 -morphology Erode Disk:2.0 $mask
        # mean of all images
        pnmcombine ${tmpref%.*}.warped.pgm ${tmpim1%.*}.warped.pgm ${tmpim2%.*}.warped.pgm $tmpim2
        pnmarith -mult $tmpim2 $mask > $mean
        # average of img1 img2
        pnmcombine ${tmpim1%.*}.warped.pgm ${tmpim2%.*}.warped.pgm $tmpim2
        pnmarith -mult $tmpim2 $mask > $tmpim1
    else
        # mask of all images
        pnmarith -minimum ${tmpref%.*}.warped.pgm ${tmpim1%.*}.warped.pgm | \
            pgmtopbm  -threshold -value 0.000001 > $mask
        # mean of all images
        pnmcombine ${tmpref%.*}.warped.pgm ${tmpim1%.*}.warped.pgm $tmpim2
        pnmarith -mult $tmpim2 $mask > $mean
        # img1
        cp ${tmpim1%.*}.warped.pgm $tmpim1
    fi
    cp ${img1%.*}.head ${mean%.*}.head
    cp ${tmpref%.*}.warped.pgm $tmpref
    
    
    if [ ! "$dmag" ]
    then
        # photometry of some stars
        echo "do aperture photometry ..."
        AIsource -q -o $tmpscat $mean "" 20
        # determine aprad and high mag limit (brightest+0.5mag)
        sexselect -s $tmpscat "" 0.03 500  "" "" 0 > $tmp1
        aprad=$(grep FWHM $tmp1 | awk '{printf("%.1f", sqrt($2*$2+3)-0.3)}')
        mhigh=$(grep MAG_AUTO $tmp1 | awk '{printf("%.2f", $5+0.5)}')
        # select brightest 15 stars (below mhigh) for photometry
        # TODO: determine rlim
        sexselect -r $tmpscat "" 0.03 500  "" "" 0 > $tmp1
        grep -v "^circle(" $tmp1 > $tmpreg
        grep "^circle(" $tmp1 | LANG=C sort -n -k4,4 | \
            awk -v mh=$mhigh '{if(1*$4>mh)print $0}' | head -15 >> $tmpreg
        AIaphot $tmpref $tmpreg $aprad 4 > $tmp1
        AIaphot $tmpim1 $tmpreg $aprad 4 > $tmp2
        dmag=$(join $tmp1 $tmp2 | grep -v "^#" | awk '{print $16-$5}' | median -)
        echo "dmag=$dmag  aprad=$aprad  mhigh=$mhigh"
    fi
    
    # create unscaled diff image (at bg level bg)
    add=$(echo $bgmean $(dmag2di $dmag) | awk '{printf("%.0f", $1*(1-$2))}')
    pnmccdred -a $add -m $(dmag2di $dmag) $tmpim1 - | \
        pnmccdred -a $bgdiff -d ${tmpref%.*}.warped.pgm - - | \
        pnmarith -mult - $mask > $diff

    # create divider image used to scale down differences around bright sources
    set - $(imcrop -1 $diff 3 | AIval -a - | kappasigma -)
    echo $2 | awk '{printf("rms(diff)=%.1f\n", $1)}'
    low=$(echo $2 | awk -v l=20 -v bg=$bgmean '{printf("%d", bg+l*$1)}')
    val=$(echo $2 | awk -v s=0.08 '{print $1*s}')
    pnmccdred -a -$low $mean - | pnmccdred -a 100 -m $val - $div

    # create scaled diff image
    # signal above <bg>
    pnmccdred -a -$bgdiff $diff - | pnmccdred -m 100 -s $div - - | \
        pnmarith -mult - $mask > $tmpim1
    # signal below <bg>
    pnmccdred -a $bgdiff -m 0 $diff - | pnmccdred -d $diff - - | \
        pnmccdred -m 100 -s $div - - | \
        pnmarith -mult - $mask > $tmpim2
    pnmccdred -a 1000 -m 0 $diff - | pnmccdred -d $tmpim2 - - | \
        pnmarith -add - $tmpim1 > $difflow
    
    # get list of warped images
    imlist="${tmpim1%.*}.warped.pgm ${tmpref%.*}.warped.pgm"
    test "$img2" && imlist="$imlist ${tmpim2%.*}.warped.pgm"
    
    # display
    ds9opts="-grid yes -grid system image -grid grid no -grid axes type exterior"
    ds9opts="$ds9opts -view layout vertical -zoom 2"
    AIexamine -p "$ds9opts" -w ${tmpref%.*}.warped.head $difflow $imlist $mean

    test ! "$AI_DEBUG" && rm $wdir/* && rmdir $wdir
    return
}


AIplot () {
    local a10k      # if set, add 10000 to x values starting with 0
    local nofit     # if set, linear fit of points is omitted
    local small=0   # control plot window size
    local wide=0    # control plot window size
    local useboxes  # if set plot histogram like filled boxes
    local uselines  # if set plot lines and points
    local printfile # if set the plot is saved to printfile
    local gpcmd     # gnuplot commands inserted before plotting
    local title
    local quiet
    local showhelp
    local i
    for i in $(seq 1 11)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-a" && a10k=1 && shift 1
        test "$1" == "-p" && nofit=1 && shift 1
        test "$1" == "-l" && uselines=1 && nofit=1 && shift 1
        test "$1" == "-b" && useboxes=1 && nofit=1 && shift 1
        test "$1" == "-s" && small=1 && shift 1
        test "$1" == "-w" && wide=1 && shift 1
        test "$1" == "-o" && printfile="$2" && shift 2
        test "$1" == "-t" && title="$2" && shift 2
        test "$1" == "-g" && gpcmd="$2" && shift 2
        test "$1" == "-q" && quiet=1 && shift 1
    done
    
    local dat="$1"      # datafile
    local xcol=$2       # x column to be plotted
    local ycol=${3:-""} # if empty, then use ycol=xcol and xcol=1
    local xmin=${4:-""}
    local xmax=${5:-""}
    local ranges=${6:-""}    # ranges passed to plot command
    local ex=${AI_XSKIP:-""}  # space separated list of x values
    local pat
    local xm
    local ym
    local term="x11"
    local termopts
    local font=sans
    local fsize=12
    local tfsize
    local w
    local h
    local lnum
    local tmp1=$(mktemp "/tmp/tmp_dat_$$.XXXXXX")
    local tmp2=$(mktemp "/tmp/tmp_cmd_$$.XXXXXX")
    local log=$(mktemp "/tmp/tmp_log_$$.XXXXXX")

    test "$showhelp" &&
        echo "usage: AIplot [-a] [-o outfile] [-t title] [-g gpcmd] [-p|b] [-s|w]" \
            "<dat> [xcol] <ycol> [xmin] [xmax] [ranges]" >&2 &&
        return 1

    test "$dat" == "-" && dat="/dev/stdin"
    test -z "$xcol" && echo "ERROR: missing parameter." >&2 && return 255
    pat="$(echo $ex | sed -e 's/ / |^/g; s/^/\^/; s/$/ /')"
    test -z "$ycol" && ycol=$xcol && xcol=1
    cat $dat | awk -v xc=$xcol -v yc=$ycol -v xmin="$xmin" -v xmax="$xmax" \
        -v a10k="$a10k" 'BEGIN{i=0}{
        if ($1~/^#/) next
        i++
        if (xc == yc) {x=i} else {
            if ($xc~/:/) {
                split($xc, a, ":")
                x=a[1]+a[2]/60.+a[3]/3600.
            } else {x=$xc}
        }
        if (a10k!~/^$/ && x~/^0[0-9][0-9][0-9]$/) {x=x+10000}
        if ((xmin != "") && (x < xmin)) next
        if ((xmax != "") && (x > xmax)) next
        printf("%s %s\n", x, $yc)
        }' | grep -Ev "${pat}" > $tmp1
    test ! -s $tmp1 &&
        echo "ERROR: no data to be plotted." >&2 &&
        rm -f $tmp1 $tmp2 $log && return 1
    xm=$(median $tmp1 1)
    ym=$(median $tmp1 2)

    # determine terminal type
    if [ "$printfile" ]
    then
        case ${printfile##*.} in
            ps|PS|eps|EPS)  term=postscript
                            termopts="enhanced eps color blacktext dashlength 2.5"
                            font=""; fsize=20
                            ;;
            png|PNG)        term=pngcairo
                            termopts="enhanced"
                            font="sans"; fsize=10
                            ;;
            *)              printfile=""
                            echo "# WARNING: unknown output file type" >&2
                            ;;
        esac
    fi
    
    # set plot window size
    case "$small$wide" in
        10) w=400; h=280
            fsize=$(echo $fsize | awk '{printf("%.0f", 0.9*$1)}')
            ;;
        01) w=950; h=350
            ;;
        11) w=500; h=230
            fsize=$(echo $fsize | awk '{printf("%.0f", 0.9*$1)}')
            ;;
        *)  w=630; h=460
            ;;
    esac
    echo -n "set terminal $term $termopts font '$font,$fsize'" >> $tmp2
    if [ "$w" ] && [ "$h" ]
    then
        test "$term" == "postscript" &&
            w=$(echo $w | awk '{print $1/100}') &&
            h=$(echo $h | awk '{print $1/100}')
        echo -n " size $w,$h" >> $tmp2
    fi
    echo "" >> $tmp2
    test "$printfile" && echo "set output '$printfile'" >> $tmp2
    test "$quiet" && echo "set fit quiet" >> $tmp2
    
    # set plot title
    if [ -z "$title" ]
    then
        title="$dat col$ycol=f(col$xcol)"
        test $xcol -eq 1 && test $ycol -eq 2 && title="$dat"
        test $xcol -eq $ycol && title="$dat"
    fi
    tfsize=$(echo $fsize | awk '{printf("%.0f", 1.15*$1)}')
    echo "set title '$title' font '$font,$tfsize'" >> $tmp2
    
    # some style changes
    echo "set style line 11 lc rgb '#505050' lt 1
        set border lw 1.2
        set style line 1 lc rgb '#e00000' # --- red
        set style line 2 lc rgb '#00e000' # --- green" >> $tmp2
    test "$useboxes" && echo "set style fill solid 1.00 border
        set boxwidth 1" >> $tmp2
    echo "set offsets graph 0.02, graph 0.02, graph 0.03, graph 0.03" >> $tmp2
    echo "set grid" >> $tmp2
    
    # linear fit
    test -z "$nofit" && echo "f1(x) = a0 + a1*(x-$xm)
        a0 = $ym; a1 = 0.1
        fit f1(x) '$tmp1' using 1:2 via a0, a1" >> $tmp2

    # insert user provided gnuplot commands
    echo "$gpcmd" >> $tmp2

    # plotting data
    echo -n "plot $ranges '$tmp1' u 1:2 title '' ls 1" >> $tmp2
    test "$useboxes" && echo -n " with boxes" >> $tmp2
    test "$uselines" && echo -n " with linespoints" >> $tmp2
    test -z "$nofit" && echo ", f1(x)" >> $tmp2
    echo "" >> $tmp2
    
    false && if [ "$printfile" ]
    then
        echo -n "set term postscript enhanced eps $termopts " >> $tmp2
        case "$small$wide" in
            10) echo "font ',16' size 4,  2.8" >> $tmp2;;
            01) echo "font ',20' size 9.5,3.5" >> $tmp2;;
            11) echo "font ',16' size 5,  2.3" >> $tmp2;;
            *)  echo "font ',20' size 6.3,4.6" >> $tmp2;;
        esac
        echo "set title '$title' font ',24'" >> $tmp2
        echo "set output '$printfile'; replot" >> $tmp2
    fi
    
    cat $tmp2 | gnuplot -p > $log 2>&1
    if [ $? -eq 0 ]
    then
        test -z "$nofit" && test -z "$quiet" &&
            lnum=$(grep -n "After .* iterations the fit converged" fit.log | \
                tail -1 | cut -d ":" -f1) &&
            sed -ne "$lnum,\$p" fit.log
        test "$printfile" && display $printfile &
    else
        cat $log
        echo "ERROR: gnuplot error in AIplot."
    fi
    test "$AI_DEBUG" && echo "$tmp1 $tmp2 $log" >&2 && return
    rm -f $tmp1 $tmp2 $log
    return
}


AIpreview () {
    # create 8bit preview of DSLR images
    local showhelp
    local nlist
    local do_color
    local verbose
    local i
    for i in $(seq 1 5)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-n" && nlist=$(mknlist "$2") && shift 2
        test "$1" == "-c" && do_color="1" && shift 1
        test "$1" == "-v" && verbose="1" && shift 1
    done
    local rdir=$1
    local telid=$2
    local contrast=${3:-"100"}     # contrast scaling
    local dcrawopts=${AI_DCRAWOPTS:-""}
    local tmp1=$(mktemp -d /tmp/tmp_preview_$day.XXXXXX)
    local tmpscript=$(mktemp /tmp/tmp_script_$day.XXXXXX)
    local tmpimg
    local tmpcrop
    local tmpdat
    local imlist
    local flat
    local f
    local num
    local black
    local fbopts
    local n
    local md
    local low
    local high
    local gam
    local x
    
    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: AIpreview [-v] [-c] [-n nlist] <rawdir> <telid> [contrast|$contrast]" >&2 &&
        return 1

    case $telid in
        K135)   flat=$A/calib/170127/sk03.pgm # 2.0/135, K5II
                ;;
        K300)   flat=$A/calib/181011/sk46.pgm # 4.0/300 poly K5II
                ;;
        GSO)    flat=$A/calib/170720/sk12.pgm  # 200/800 sky
                ;;
        GSOG)   flat=$A/calib/180417/sk13.pgm  # 200/800 poly GPUCC
                ;;
        RC5s)   flat=$A/calib/181010/sk01.pgm  # RS 12" f/5, poly
                ;;
        *)      echo "WARNING: unknown telid, no flat field correction" >&2
                ;;
    esac
    test -z "$dcrawopts" && test "$flat" && dcrawopts="-R 4950 3284 0 0"

    imlist=$(ls $rdir/*.{pef,PEF,fits,FITS,cr2,CR2,raf,RAF} 2>/dev/null)
    test -z "$imlist" &&
        echo "ERROR: no images to process" >&2 &&
        return 255
    echo '#!/bin/bash
        f=$1
        
        nlist="'$nlist'"
        tmp1='$tmp1'
        contrast='$contrast'
        dcrawopts="'$dcrawopts'"
        flat="'$flat'"
        
        . $(type -p airfun.sh) > /dev/null 2>&1
        num=$(basename ${f%.*} | sed -e '\''s/^[^0-9]*//; s/[^0-9]*$//'\'')
        tmpimg=$(mktemp /tmp/tmp_img.XXXXXX.pnm)
        tmpcrop=$(mktemp /tmp/tmp_crop.XXXXXX.pnm)
        tmpdat=$(mktemp /tmp/tmp_tmp1.XXXXXX.dat)
        test "$nlist" && ! echo "$nlist" | grep -qw $num && exit 0
        test -f $tmp1/$num.png && exit 0

        is_fits $f && meftopnm $f | pnmflip -tb | \
            convert - -normalize -gamma 2 -level 3%,80% -depth 8 $tmp1/$num.png &&
            exit 0
        black=$(AI_TZOFF=1 img_info $f | tail -1 | awk '\''{printf("%s", $9)}'\'')
        fbopts=""
        test "$flat" && fbopts="-F $flat"
        test "$black" && test "$black" != "-" && fbopts="$fbopts -k $((black/4))"
        echo -n "$num " >&2
        if [ "$do_color" ]
        then
            dcraw-tl -c -r 1.7 1 2.2 1 -q 0 -4 -t 0 -h $fbopts $dcrawopts -o 0 $f > $tmpimg
            imcrop $tmpimg 70 > $tmpcrop
            (cd /tmp
                AIbgmap -q -m $tmpcrop 64
                AIval -a ${tmpcrop/.pgm/.bgm1.pgm} | awk '\''{printf("%s\n", $2)}'\''
                rm -f ${tmpcrop/.pgm/.bgm1.pgm}
            ) | sort -n > $tmpdat
            n=$(cat $tmpdat | wc -l)
            md=$(head -$((n*50/100)) $tmpdat | tail -1)
            low=$(head -$((n*30/100))  $tmpdat | tail -1 | awk -v m=$md '\''{print 2*$1-m}'\'')
            high=$(echo $contrast | awk '\''{x=8000/$1; printf("%.0f", x*x)}'\'')
            rm -f $tmpcrop $tmpdat
            echo $low $md $high >&2
            #convert $tmpimg -level $((low-md*max/2000-50)),$((high+md*max/300+400)) -gamma 2.5 -depth 8 $tmp1/$num.png
            convert $tmpimg -level $((low-md*3/contrast-50)),$((high+md*20/contrast+400)) -gamma 2.2 -depth 8 $tmp1/$num.png
        else
            dcraw-tl -c -r 1 1 1 1 -q 0 -4 -t 0 $fbopts $dcrawopts -o 0 $f | \
            ppm2gray - > $tmpimg
            imcrop $tmpimg 70 > $tmpcrop
            (cd /tmp
                AIbgmap -q -m $tmpcrop 64
                AIval -a ${tmpcrop/.pgm/.bgm1.pgm}
                rm -f ${tmpcrop/.pgm/.bgm1.pgm}
            ) | sort -n > $tmpdat
            n=$(cat $tmpdat | wc -l)
            md=$(head -$((n*50/100)) $tmpdat | tail -1)
            low=$(head -$((n*15/100))  $tmpdat | tail -1 | awk -v m=$md '\''{print 2*$1-m}'\'')
            high=$(head -$((n*75/100)) $tmpdat | tail -1 | awk -v m=$md '\''{print 2*$1-m}'\'')
            rm -f $tmpcrop $tmpdat
            echo $low $md $high >&2
            #convert $tmpimg -level $((low-md*max/2000-50)),$((high+md*max/300+400)) -gamma 2.2 -depth 8 $tmp1/$num.png
            convert $tmpimg -level $((low-md*3/contrast-50)),$((high+md*20/contrast+400)) -gamma 2.2 -depth 8 $tmp1/$num.png
        fi
        ln -s $f $tmp1
        false && dcraw-tl -c -t 0 -q 0 $dcrawopts $f | ppm2gray - | \
            convert - -normalize -level 2%,98% -gamma $gam -depth 8 $tmp1/$num.png &&
        ln -s $f $tmp1
        rm -f $tmpimg $tmpcrop $tmpdat
    ' > $tmpscript
    chmod u+x $tmpscript
    ls -l $tmpscript

    echo $tmp1
    #gthumb $tmp1 &
    geeqie $tmp1 &
    echo "$imlist" | parallel -j -1 $tmpscript {}
    return
}


AIpublish () {
    local showhelp
    local mag
    local tscale=1  # text scaling
    local outfile
    local is_negative   # if image is grayscale negative choose different line
                        # and text colors
    local quality=95
    local i
    for i in 1 2 3 4 5 6
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-m" && mag=$2 && shift 2
        test "$1" == "-t" && tscale=$2 && shift 2
        test "$1" == "-o" && outfile=$2 && shift 2
        test "$1" == "-q" && quality=$2 && shift 2
        test "$1" == "-n" && is_negative=1 && shift 1
    done
    local set="$1"
    local img="$2"
    local scale="$3"
    local object=${4:-""}
    local title=${5:-""}
    local text=${6:-""}
    local author="Thomas Lehmann, Weimar"
    local camera    # "DSLR Pentax K5IIs"
    local telescope
    local iso
    local jd
    local texp
    local nexp
    local utdate
    local uttime
    local oshort
    local add
    local x
    local w
    local fov
    local jpg
    local add
    local tsize
    local bs
    local fg
    local bg
    local copyright
    local subtxt
    local tprop
    local str

    (test "$showhelp" || test $# -lt 3) &&
        echo "usage: AIpublish [-m mag] [-q quality] [-t tscale] [-o outfile] [set] [img] [scale] <object> <title> <text>" >&2 &&
        return
    
    test ! -f $set.wcs.head &&
        echo "ERROR: $set.wcs.head not found." >&2 && return 255
    
    # determine telescope
    x=$(get_telescope $set)
    if [ "$x" ]
    then
        camera=$(get_param camera.dat camera $x)
        case $camera in
            K5II*)  camera="Pentax $camera";;
        esac
        str=$(get_param camera.dat ctype $x)
        if [ "$str" == "DSLR" ]
        then
            set - $(AIsetinfo $set)
            iso="ISO"$7
        fi
        str=$(get_param camera.dat flen $x)
        if [ $str -le 400 ]
        then
            telescope="telelens ${str}mm f/$(get_param camera.dat fratio $x)"
        else
            telescope=$(get_param camera.dat aperture $x | awk '{printf("%.0f", $1/25.4)}')"\""
            telescope="$telescope f/$(get_param camera.dat fratio $x)"
        fi
    fi
    test -z "$telescope" && telescope="unknown telescope"
    
    # get ut
    set - $(AIsetinfo -l $set)
    test $# -lt 8 &&
        echo "ERROR: AIsetinfo -l $set does not work." >&2 && return 255
    oshort=$3
    test -z "$object" && object=$oshort
    x=$(jd2ut $5)
    utdate=${x%.*}
    uttime=$(echo 0.${x#*.} | awk '{
        x=$1*24; printf("%02d:%02.0f", int(x), (x-int(x))*60)}')
    
    # extract some data from image stack header
    jd=$(get_header $set.head MJD_OBS)
    nexp=$(get_header $set.head NEXP)
    texp=$(echo $(get_header $set.head EXPTIME) | awk -v n=$nexp '{
        s=1*$1/n
        if (s<60) {printf("%.0fs", s)} else {printf("%.0fmin", s/60)}}')

    # determine field size from image dimension
    x=$(get_wcspscale $set.wcs.head)
    fov=$(identify $img | cut -d " " -f3 | awk -F "x" -v ps=$x -v s=$scale '{
        if (s>2) {s=s/100}
        w=$1*ps/s/3600; h=$2*ps/s/3600
        fmt="%.1f°x%.1f°"
        if (w>10 && h>10) fmt="%.0f°x%.0f°"
        printf(fmt, w, h)
        }')
    
    # set outfile name
    jpg=${oshort}_${day}_${set}.jpg
    test "$outfile" && jpg="$outfile"

    # additional text info
    test "$mag" && add="$add, mv=${mag}mag"
    
    test -z "$title" &&
        title="$object  -  $utdate, $uttime UT, ${nexp}x$texp, field size $fov" &&
        echo "##  title=\"$title\""
    test -z "$text" &&
        text="$telescope, $camera, $iso, ${nexp}x$texp, FOV ${fov//°/}deg$add" &&
        echo "##  text=\"$text\""
    echo "##  web form data:"
    echo "##  ;;;${utdate//-/.};;;;;$object;$uttime UT, $text;$jpg;;$oshort;$author;"
    test -z "$outfile" && test -f "$jpg" &&
        echo "WARNING: keeping existing $jpg" >&2 && return

    # create jpg image with borders and annotations
    set - $(identify $img | cut -d " " -f3 | awk -F "x" -v s=$tscale '{w=$1; h=$2;
        x=sqrt($1*$1+$2*$2); bs=s*x/130+2; printf("%.0f %.0f %.0f", s*x/110+2, bs, w+4+bs*4/6)}')
    tsize=$1    # text size
    bs=$2       # border scaling constant (~tsize)
    w=$3        # label width
    bg="#080808"
    fg="gray60"
    test "$is_negative" && fg="gray80"
    copyright="© ${utdate%%-*}, ${author%%,*}"
    test "$AI_DEBUG" && echo "tsize=$tsize bs=$bs" >&2
    
    # text labels
    x=$(echo -e "$title" | wc -l)
    echo "x=$x  h=$((tsize*x+5*(x-1)))"
    tprop="-fill $fg -font Helvetica -pointsize $tsize -interline-spacing 5"
    convert -size ${w}x$((tsize*x+5*x)) -background $bg $tprop -gravity west label:"$title" \
        -bordercolor $bg -border $bsx$((bs*1/3)) label.l.tif
    # add copyright text to label
    convert -background $bg $tprop label:"$copyright" \
        -bordercolor $bg -border $bsx$((bs*1/3)) label.r.tif
    composite -gravity northeast -geometry +1+1 label.r.tif label.l.tif label.tif
    # adding border and labels
    convert $img ppm: | convert - -bordercolor $bg -border $((bs*4/6))x$((bs*4/6)) \
        -bordercolor "#a0a0a0" -border 2x2 -bordercolor $bg -border 0x$((bs*5/6)) \
        -background $bg label.tif -append -border $((bs*12/6))x$((bs*4/6)) \
        -quality $quality "$jpg"
    test $? != 0 && return 255
    xdg-open "$jpg" &
    test ! "$AI_DEBUG" && rm -f label.l.tif label.r.tif label.tif
    return
}


# create psf by averaging selected objects
# by default use re-sampling to 1/scale-pixels for better preservation of resolution
# setting AI_DEBUG will keep log (magnitudes) and individual shifted object
#   images
AIstarcombine () {
    local showhelp
    local resamptype    # resampling type (e.g. lanczos3, bilinear)
    local fwhm=4        # fwhm of stars, used to define region where peak
                        # intensity is measured
    local outbg=1000     # background level of resulting psf image
    local psfmult=1     # scale factor for psf intensities
    local bgval         # average bg value of psf stars in img (comma
                        #   separated r,g,b)
    local i
    for i in 1 2 3 4 5 6
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-f" && fwhm="$2" && shift 2
        test "$1" == "-r" && resamptype="$2" && shift 2
        test "$1" == "-b" && bgval="$2" && shift 2
        test "$1" == "-m" && psfmult="$2" && shift 2
        test "$1" == "-o" && outbg="$2" && shift 2
    done
    local img=$1                # image containing psf objects
    local photcat=$2            # photometry data file with fields id,x,y,r,g,b
                                # where x,y are in image coordinates
    local outpsf=$3             # output psf image
    local psfsize=${4:-"100"}   # image box size used for psf
    local scale=${5:-"4"}       # scale up psf for better sampling
    local tdir=${AI_TMPDIR:-"/tmp"}
    local conf=$(mktemp "$tdir/tmp_swarp.XXXXXX.conf")
    local wdir=$(mktemp -d "$tdir/tmp_psf_XXXXXX")
    local clist="red grn blu"
    local bsize=$((psfsize + 8))
    local id
    local xc
    local yc
    local xi
    local yi
    #local sx
    #local sy
    local cx
    local cy
    local nimg=0
    local psfrgb
    local psfadd
    local pixscale=2
    local str
    local mult
    local bg
    local add
    local param
    local xbgval
    
    (test "$showhelp" || test $# -lt 3) &&
        echo "usage: AIstarcombine [-f fwhm|$fwhm] [-b imgbg|$bgval] [-o outbg|$outbg] [-m psfmult|$psfmult] [-r resamptype]" \
            "<img> <photcat> <outpsf> [psfsize|$psfsize] [scale|$scale]" >&2 &&
        return 1

    for f in $img $photcat
    do
        test ! -f $f && echo "ERROR: file $f not found." >&2 && return 255
    done
    is_pgm $img && clist="gray"
    
    # extract sub-images for individual objects
    while read id xc yc r g b z
    do
        (echo "$id" | grep -q "^#") && continue
        test -z "$yc" && continue
        nimg=$((nimg + 1))

        # extract and translate oimg section to center object at bsize/2, bsize/2
        xi=$(echo $xc | awk '{printf("%d", $1)}')
        yi=$(echo $yc | awk '{printf("%d", $1)}')
        #sx=$(echo $xi $xc | awk -v s=$scale '{printf("%.2f", s*($1-$2))}')
        #sy=$(echo $yi $yc | awk -v s=$scale '{printf("%.2f", s*($2-$1))}')
        # echo $xi $yi $sx $sy
        if is_pgm $img
        then
            imcrop -1 $img $bsize $bsize $((xi - bsize/2)) $((yi - bsize/2)) | \
                pnmtomef - > $wdir/$nimg.$clist.fits
        else
            imcrop -1 $img $bsize $bsize $((xi - bsize/2)) $((yi - bsize/2)) | \
                (cd $wdir; ppmtorgb3)
            for c in red grn blu
            do
                pnmtomef $wdir/noname.$c > $wdir/$nimg.$c.fits
            done
            rm $wdir/noname.{red,grn,blu}
        fi
        
        # create artificial .head files
        # note: cx cy are in fits image coordinates
        pscale=$(echo $pixscale | awk '{print $1/3600.}')
        cx=$(echo $bsize $xc $xi | awk '{printf("%.3f", $1/2+$2-$3+0.5)}')
        cy=$(echo $bsize $yc $yi | awk '{printf("%.3f", $1/2-$2+$3+0.5)}')
        echo "EXPTIME =      1       / Exposure time in seconds
EPOCH   =      2000.0  / Epoch
EQUINOX =      2000.0  / Mean equinox
CTYPE1  = 'RA---TAN'   / WCS projection type for this axis
CUNIT1  = 'deg     '   / Axis unit
CRVAL1  =      10.0    / World coordinate on this axis
CRPIX1  =      $cx     / Reference pixel on this axis
CD1_1   =      -$pscale   / Linear projection matrix
CD1_2   =      0          / Linear projection matrix
CTYPE2  = 'DEC--TAN'   / WCS projection type for this axis
CUNIT2  = 'deg     '   / Axis unit
CRVAL2  =      0.0     / World coordinate on this axis
CRPIX2  =      $cy     / Reference pixel on this axis
CD2_1   =      0          / Linear projection matrix
CD2_2   =      $pscale    / Linear projection matrix
END     " > $wdir/$nimg.red.head
        if is_pgm $img
        then
            mv $wdir/$nimg.red.head $wdir/$nimg.gray.head
        else
            cp -p $wdir/$nimg.red.head $wdir/$nimg.grn.head
            cp -p $wdir/$nimg.red.head $wdir/$nimg.blu.head
        fi
        # shift image to center object at bsize/2, bsize/2
        # old: pnmaffine -x $sx -y $sy -s $scale -i 3 $crop \
        #  $wdir/crop.${xi}-${yi}.ppm
    done < $photcat
    
    # average sub-images using different pscale
    pscale=$(echo $pixscale $scale | awk '{printf("%f", $1/$2)}')
    swarp -d > $conf
    param="-resample_dir $wdir"
    test "$resamptype" && param="$param -resampling_type $resamptype"
    for c in $clist
    do
        swarp -c $conf -combine_type average -subtract_back N \
            -fscale_default $((scale*scale)) \
            -pixelscale_type manual -pixel_scale $pscale \
            -center_type manual -center 10,0 \
            -image_size $((psfsize*scale)),$((psfsize*scale)) \
            -verbose_type QUIET $param $wdir/*.$c.fits
        sethead coadd.fits datamin=0 datamax=65535
        
        if [ "$psfmult" != "1" ]
        then
            ## scale intensities to max=50000
            #str=$(echo $psfsize $scale $fwhm | awk '{
            #    a=$1*$2/2-$2*($3+2); b=$1*$2/2+$2*($3+2)
            #    printf("[%.0f:%.0f,%.0f:%.0f]\n", a,b,a,b)}')
            #mult=$(imlist "coadd.fits$str" | tr ' ' '\n' | sort -nr | head -1 | \
            #    awk '{printf("%.3f", 50000/$1)}')
            #test "$psfmult" && psfmult=$psfmult","
            #psfmult="$psfmult$mult"
            imarith coadd.fits $psfmult mul - > $wdir/$c.fits
            mv $wdir/$c.fits coadd.fits
        fi

        if [ -z "$bgval" ]
        then
            # radii for measurement of xbgval (psf background)
            if [ -z "$bg" ]
            then
                r=$(echo $fwhm $scale | awk -v rmax=$((psfsize*scale/4)) '{
                    r=(4*$1+1)*$2; if(r>rmax){r=rmax}; printf("%.0f", r)}')
                y=$((r/4+scale+2))
                echo "# measure psf bg in annulus $((r+y)) $((r+3*y))" >&2
            fi

            # measure (unscaled) bg
            x=$((psfsize*scale/2))
            meftopnm coadd.fits > $wdir/$c.pgm
            bg=$(echo "psfcenter $x $x" | \
                AI_MAGZERO=20 AIaphot $wdir/$c.pgm - $r $y $((3*y)) | grep -v "^#" | \
                awk -v m=$psfmult '{printf("%.1f", $9/m)}')
            test "$xbgval" && xbgval=$xbgval","
            xbgval="$xbgval$bg"
        else
            case $c in
                grn)    x=2;;
                blu)    x=3;;
                *)      x=1;;
            esac
            bg=$(echo $bgval | tr ',' '\n' | head -$x | tail -1)
        fi

        # shift the bg level to outbg
        add=$(echo $bg $psfmult $outbg | awk '{printf("%.1f", $3-$1*$2)}')
        test "$psfadd" && psfadd=$psfadd","
        psfadd="$psfadd$add"
        imarith coadd.fits $add add - > $wdir/$c.fits
        mv $wdir/$c.fits coadd.fits
        
        cp coadd.fits x.psf.$c.fits
        meftopnm coadd.fits > $wdir/$c.pgm
    done
    test "$xbgval" && echo "# xbgval=$xbgval" >&2
    test "$AI_DEBUG" && echo "# psfadd=$psfadd" >&2
    rm coadd.fits coadd.weight.fits swarp.xml
    if is_pgm $img
    then
        mv $wdir/$clist.pgm $outpsf
    else
        rgb3toppm $wdir/red.pgm $wdir/grn.pgm $wdir/blu.pgm > $outpsf
    fi
    
    # clean-up
    rm -f $conf
    test "$AI_DEBUG" || rm -rf $wdir
}


# create and apply mask from psf image either by using a circular aperture
# of radius r or by thresholding with respect to maximum or by reusing an
# existing mask
# TODO: implement automatic mask creation from psf profile
AIpsfmask () {
    local showhelp
    local mask      # if it exists, use this mask, otherwise save it to this filename
    local trail     # l,pa,c - length in pix, pa in deg, center fraction (0=start
                    # 1=end of trail), l and pa are measured on inpsf
    local do_quiet
    local i
    for i in $(seq 1 4)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-m" && mask=$2    && shift 2
        test "$1" == "-t" && trail=$2   && shift 2
        test "$1" == "-q" && do_quiet=1 && shift 1
    done
    
    local inpsf=$1
    local outpsf=$2
    local psfoff=${3:-1000}
    local rmax=${4:-""}
    local thres=${5:-"0.001"}    
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpdat=$(mktemp "$tdir/tmp_dat_XXXXXX.dat")
    local tmpreg=$(mktemp "$tdir/tmp_mask_XXXXXX.reg")
    local tmpmask=$(mktemp "$tdir/tmp_mask_XXXXXX.pbm")
    local tmpim1=$(mktemp "$tdir/tmp_im1_XXXXXX.pnm")
    local tmpim2=$(mktemp "$tdir/tmp_im2_XXXXXX.pnm")
    local f
    local ext
    local w
    local x
    local y
    local a

    (test "$showhelp" || test $# -lt 2 || test $# -gt 5) &&
        echo "usage: AIpsfmask [-q] [-m mask] [-t traillen,pa,cfrac] <inpsf> <outpsf>" \
            "[psfoff|$psfoff] [rmax|$rmax] [thres|$thres]" >&2 &&
        return 1

    # checkings
    for f in $inpsf
    do
        test ! -f $f && echo "ERROR: file $f not found." >&2 && return 255
    done

    ext="pgm"
    is_ppm $inpsf && ext="ppm"

    if [ "$mask" ] && [ -e $mask ]
    then
        if is_reg $mask
        then
            reg2pbm $inpsf $mask > $tmpmask
        else
            cp $mask $tmpmask
        fi
    else
        # create region mask
        w=$(identify $inpsf | cut -d " " -f3 | cut -d "x" -f1)
        echo "star_mask $((w/2)) $((w/2))" | xy2reg $inpsf - "" "" $rmax > $tmpreg
        test "$trail" && sed -i '/^circle/d' $tmpreg &&
        echo ${trail//,/ } 0.5 | awk -v w=$w -v s=1 -v r=$rmax '{
            pi=3.14159
            
            # center 1
            l=s*$1*($3-1)
            x=w/2+l*cos($2*pi/180)+0.5
            y=w/2+l*sin($2*pi/180)+0.5
            # point 1
            dx=s*r*cos(($2-90)*pi/180)
            dy=s*r*sin(($2-90)*pi/180)
            printf("polygon(%.1f,%.1f,", x+dx, y+dy)
            # point 2
            dx=s*r*cos(($2-135)*pi/180)
            dy=s*r*sin(($2-135)*pi/180)
            printf("%.1f,%.1f,", x+dx, y+dy)
            # point 3
            dx=s*r*cos(($2-180)*pi/180)
            dy=s*r*sin(($2-180)*pi/180)
            printf("%.1f,%.1f,", x+dx, y+dy)
            # point 4
            dx=s*r*cos(($2-225)*pi/180)
            dy=s*r*sin(($2-225)*pi/180)
            printf("%.1f,%.1f,", x+dx, y+dy)
            # point 5
            dx=s*r*cos(($2-270)*pi/180)
            dy=s*r*sin(($2-270)*pi/180)
            printf("%.1f,%.1f,", x+dx, y+dy)

            # center 2
            l=s*$1*$3
            x=w/2+l*cos($2*pi/180)+0.5
            y=w/2+l*sin($2*pi/180)+0.5
            # point 6
            dx=s*r*cos(($2+90)*pi/180)
            dy=s*r*sin(($2+90)*pi/180)
            printf("%.1f,%.1f,", x+dx, y+dy)
            # point 7
            dx=s*r*cos(($2+45)*pi/180)
            dy=s*r*sin(($2+45)*pi/180)
            printf("%.1f,%.1f,", x+dx, y+dy)
            # point 8
            dx=s*r*cos(($2+0)*pi/180)
            dy=s*r*sin(($2+0)*pi/180)
            printf("%.1f,%.1f,", x+dx, y+dy)
            # point 9
            dx=s*r*cos(($2-45)*pi/180)
            dy=s*r*sin(($2-45)*pi/180)
            printf("%.1f,%.1f,", x+dx, y+dy)
            # point 10
            dx=s*r*cos(($2-90)*pi/180)
            dy=s*r*sin(($2-90)*pi/180)
            printf("%.1f,%.1f) # text={trail_mask}\n", x+dx, y+dy)
        }' >> $tmpreg
        reg2pbm $inpsf $tmpreg > $tmpmask
        test "$mask" && cp -p $tmpreg $mask
        
        # old style: mask is pbm image
        false && (
        w=$(identify $inpsf | cut -d " " -f3 | cut -d "x" -f1)
        convert -size $w"x"$w xc:black -fill white \
            -draw "circle $((w/2)),$((w/2)) $((w/2+rmax)),$((w/2))" $tmpmask
        if [ "$trail" ]
        then
            #convert -size $((w-1))"x"$((w-1)) xc:white -fill black -stroke black -strokewidth 3 \
            #  -draw "$str" $tmpkernel
            # kmean $tmpmask $tmpkernel > $tmpim
            set - ${trail//,/ } 0.5
            x=$(echo $1 $3 | awk '{printf("%.0f", $1*(1-$2)/2)}')
            y=$(echo $1 $3 | awk '{printf("%.0f", $1*$2/2)}')
            a=$(echo $2 | awk '{printf("%.0f", $1)}')
            convert $tmpmask -colorspace gray -depth 16 -motion-blur $x"x"$((2*x))"+"$((360-a)) $tmpim1
            convert $tmpmask -colorspace gray -depth 16 -motion-blur $y"x"$((2*y))"+"$((180-a)) $tmpim2
            convert $tmpim1 $tmpim2 -evaluate-sequence max -threshold 0.1% $tmpmask
        fi
        test "$mask" && cp -p $tmpmask $mask
        )
    fi

    # apply mask
    pnmccdred -m 0 $inpsf - | \
        pnmccdred -a $psfoff - - | \
        pnmcomp -alpha $tmpmask $inpsf > $outpsf
    
    rm -f $tmpdat $tmpreg $tmpmask $tmpim1 $tmpim2
    return
}

# wrapper around sky(maker) to create artificial star field image from
#   star photometry file (generated by AIaphot) and psf image
# number of color planes is taken from psf-image
# format of stars photometry catalog: id xc yc rmag gmag bmag
#   xc, yc in image coordinates starting at upper left corner=0,0
# default output image name: ${photcat%.dat}.$ext
AIskygen () {
    local do_fits           # if set generate FITS output file instead of PGM/PPM
    local outfile           # name of output file (default: ${photcat%.dat}.$ext
    local vtype="quiet"     # value of verbose_type parameter of sky
    local mcorr             # mag correction dr,dg,db applied to photcat
    local showhelp
    for i in $(seq 1 3)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-f" && do_fits=1 && shift 1
        test "$1" == "-o" && outfile=$2 && shift 2
        test "$1" == "-m" && mcorr="$2" && shift 2
        test "$1" == "-v" && vtype="normal" && shift 1
    done
    
    local photcat=$1
    local psf=$2            # psf image (TODO: width of gaussian profile)
    local texp=$3           # exposure time in seconds 
    local magzero=$4        # magnitude zero point
    local oversamp=${5:-4}  # psf oversampling factor
    local w=${6:-1024}
    local h=${7:-1024}
    local psfbg=${8:-"1000"}
    #local noise=${9:-""}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpdat=$(mktemp "$tdir/tmp_dat_XXXXXX.dat")
    local tmppsf=$(mktemp "$tdir/tmp_psf_XXXXXX.fits")
    local tmpfits1=$(mktemp "$tdir/tmp_im1_XXXXXX.fits")
    local tmpfits2=$(mktemp "$tdir/tmp_im2_XXXXXX.fits")
    local tmpr=$(mktemp "$tdir/tmp_r_XXXXXX.img")
    local tmpg=$(mktemp "$tdir/tmp_g_XXXXXX.img")
    local tmpb=$(mktemp "$tdir/tmp_b_XXXXXX.img")
    local conf=$(mktemp "$tdir/tmp_sky_XXXXXX.conf")
    local ext
    local ncol
    local pw
    local ph
    local colorcol
    local x
    local y
    local c
    local madd
    
    (test "$showhelp" || test $# -lt 4) &&
        echo "usage: AIskygen [-v] [-o outfile] [-m dr,dg,db] <photcat> <psf> <texp>" \
            "<magzero> [oversamp|$oversamp] [width|$w] [height|$h] [psfbg|$psfbg]" >&2 &&
        return 1

    for f in $photcat $psf
    do
        test ! -e $f && echo "ERROR: file $f not found." >&2 && return 255
    done
    
    ext="pgm"; ncol=1
    is_ppm $psf && ext="ppm" && ncol=3
    if [ ! "$outfile" ]
    then
        outfile=$(basename ${photcat%.dat}.$ext)
        test "$do_fits" && outfile=$(basename ${photcat%.dat}.fits)
    fi

    pw=$(identify $psf | cut -d " " -f3 | cut -d "x" -f1)
    ph=$(identify $psf | cut -d " " -f3 | cut -d "x" -f2)

    pnmtomef $psf > $tmppsf
    for c in $(seq 1 $ncol)
    do
        # additive mag correction
        madd=0
        test "$mcorr" && madd=$(echo ${mcorr//,/ } | cut -d " " -f$c)
        
        # note: default oversampled psf peak in skymaker has offset
        #   for even number of cols/rows center+(0.5,0.5)/s
        #   for odd number of cols/rows there is correct center
        cat $photcat | awk -v mcol=$((c+3)) -v madd=$madd -v s=$oversamp \
            -v pw=$pw -v ph=$ph -v h=$h 'BEGIN{xoff=(1-pw%2)*0.5/s; yoff=(1-ph%2)*0.5/s}{
            if ($1~/^#/) next
            printf("100 %7.2f %7.2f %5.2f # %-10s\n",
                $2+0.5+xoff, h-$3+0.5+yoff, $mcol+madd, $1)}' > $tmpdat
        #test "$AI_DEBUG" && cat $tmpdat
        # prepare psf image
        x=$(echo $texp $oversamp | awk '{print $1*$2*$2}')
        y=$(echo $psfbg | awk '{print 2^15-$1}')
        
        imcopy $tmppsf[$((c-1))] - > $tmpfits1
        sethead $tmpfits1 EXPTIME=$x MAGZERO=$magzero PSFSAMP=$oversamp BZERO=$y
        #echo sky -image_size $w","$h -exposure_time $texp -mag_zeropoint $magzero \
        #    -pixel_size 3.5 -seeing_fwhm 6 -starcount_zp 0 -readout_noise 0 \
        #    -back_mag 22 -psf_oversamp 20 $tmpdat
        sky -d > $conf
        sky -c $conf -image_name $tmpfits2 -image_size $w","$h \
            -image_type sky_nonoise -verbose_type quiet \
            -psf_oversamp $oversamp -seeing_type none -aureole_radius 0 \
            -exposure_time $texp -mag_zeropoint $magzero -back_mag 99 -starcount_zp 0 \
            -psf_type file -psf_name $tmpfits1 $tmpdat
        test $? -ne 0 &&
            echo "ERROR: command sky ... has failed." >&2 && return 255
        rm ${tmpfits2%.fits}.list
        
        # combine single color images
        #test $c -eq 1 && cp $tmpfits2 $tmpoutfits
        
        if [ "$do_fits" ]
        then
            test $c -eq 1 && mv $tmpfits2 $tmpr
            test $c -eq 2 && mv $tmpfits2 $tmpg
            test $c -eq 3 && mv $tmpfits2 $tmpb
        else
            sethead $tmpfits2 datamin=0 datamax=65535
            test $c -eq 1 && meftopnm $tmpfits2 > $tmpr
            test $c -eq 2 && meftopnm $tmpfits2 > $tmpg
            test $c -eq 3 && meftopnm $tmpfits2 > $tmpb
        fi
    done
    
    # combine color channels
    test $ncol -eq 1 && mv $tmpr $outfile
    test $ncol -eq 3 && test "$do_fits" && echo "ERROR: not implemented yet." >&2
    test $ncol -eq 3 && test ! "$do_fits" &&
        rgb3toppm $tmpr $tmpg $tmpb > $outfile

    rm -f $conf $tmppsf $tmpdat $tmppsf $tmpfits1 $tmpfits2 $tmpr $tmpg $tmpb
    return
}



#--------------------
#   imred functions
#--------------------

# create master dark image
# lineary scale up images from 12 to 16 bit
# median group of 3+ images (to get rid of cosmics)
# average those
AIdark () {
    AIcheck_ok -r || return 255
    local rowsub    # if set then subtract median from each row
    local showhelp
    for i in $(seq 1 3)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-r" && rowsub=1 && shift 1
    done

    local setname=${1:-""}
    local rdir=${AI_RAWDIR:-"."}
    local bad=${AI_BADPIX:-""}
    local sdat=${AI_SETS:-"set.dat"}
    local ccdregion=${AI_CCDREGION:-""}  # w h xoff yoff
    local tdir=${AI_TMPDIR:-"/tmp"}
    local imlist=$(mktemp "$tdir/tmp_imlist_XXXXXX.dat")
    local sname
    local target
    local type
    local texp
    local n1
    local n2
    local nref
    local dark
    local flat
    local x
    local i
    local ilist
    local dcrawopts
    local n
    local ng
    local ig
    local scale
    local flip
    local opts

    test "$showhelp" &&
        echo "usage: AIdark [set]" >&2 &&
        return 1
    
    test "$bad" && test ! -e $bad &&
        echo "ERROR: badpix file $bad is missing." >&2 &&
        return 1

    while read ltime sname target type texp n1 n2 nref dark flat x
    do
        (echo "$ltime" | grep -q "^#") && continue
        test "$type" != "d" && continue
        test "$setname" && test "$setname" != "$sname" && continue
        (! is_integer "$n1" || ! is_integer "$n2") && continue
        
        test -f $sname.pgm &&
            echo "WARNING: $sname.pgm exists, skipping set $sname." >&2 && continue
        
        is_dark_subtracted=""
        test "$(AIsetinfo $sname | awk '{print $11}')" == "0" &&
            is_dark_subtracted=1 &&
            echo "$sname: in-camera dark subtraction assumed."
        
        AIimlist $sname "" raw > $imlist
        n=$(cat $imlist | wc -l)
        test $n -lt 3 && echo "ERROR: set $sname has too few images ($n < 3)." >&2 &&
            rm $imlist && continue
        test $n -lt 6 && echo "WARNING: set $sname has few images ($n < 6)." >&2
        echo "processing $n darks in set $sname ..."
        
        dcrawopts=""
        is_gacam_raw $(head -1 $imlist | cut -d ' ' -f3) && test "$ccdregion" &&
            dcrawopts="-R $ccdregion"

        # determine intensity scaling factor to stretch to full 16bit range
        # this is used by AIraw2gray in case of FITS images only
        scale=$(get_param camera.dat rawbits $sname | awk '{if ($1!="-" && $1<16) print 2^(16-$1)}')

        # check if top-down image flipping is required
        flip=$(get_param camera.dat flip $sname | awk '{if ($1=="1") print 1}')
        
        # options for raw image conversion
        opts=""
        test "$scale" && opts="-s $scale"
        test "$flip"  && opts=$(echo $opts "-f")

        # median in groups of 3+ images
        ng=$(($n / 3))
        ig=1
        i=0; ilist=""
        rm -f $tdir/$sname.m[0-9][0-9].pgm
        while read x num fname x
        do
            echo "  $num"
            i=$(($i+1)); ilist="$ilist $tdir/$num.pgm"
            AI_DCRAWPARAM="$dcrawopts $AI_DCRAWPARAM" \
                AIraw2gray $opts $fname "" $bad > $tdir/$num.pgm
            test "$rowsub" && impatsub $tdir/$num.pgm
            test $ig -lt $ng && test $(($i %3)) -eq 0 &&
                ig2=$(printf "%02d" $ig) &&
                echo "median in group $ig -> $tdir/$sname.m$ig2.pgm" &&
                pnmcombine -d $ilist $tdir/$sname.m$ig2.pgm &&
                ig=$(($ig+1)) && ilist=""
            test $ig -eq $ng && test $i -eq $n &&
                ig2=$(printf "%02d" $ig) &&
                echo "median in group $ig -> $tdir/$sname.m$ig2.pgm" &&
                pnmcombine -d $ilist $tdir/$sname.m$ig2.pgm &&
                ilist=""
        done < $imlist
        
        # average over medians
        echo "average median images ..."
        pnmcombine $tdir/$sname.m[0-9][0-9].pgm $sname.pgm
        # stddev over medians
        #pnmcombine -s $tdir/$sname.m[0-9][0-9].pgm $sname.sd3.pgm
        
        # clean up
        rm -f $tdir/$sname.m[0-9][0-9].pgm
        test -z "$AI_DEBUG" && while read x num fname x
        do
            rm -f $tdir/$num.pgm
        done < $imlist
    done < $sdat
    test "$AI_DEBUG" && echo $tdir
    rm -f $imlist
}


# create master flat field image
# scale from 12bit to 16bit, subtract (optionally cropped) dark
# work within groups of 6+ images
#   - get mean intensity of each image (center region)
#   - normalize flats
#   - median of odd/even images in group (to get rid of stars),
#     e.g.: median of 1 3 5 and median of 2 4 6
# average those median frames
AIflat () {
    AIcheck_ok -r || return 255
    local showhelp
    local do_bayer      # if set then keep bayer matrix and create gray
                        # flat field instead of rgb
    local do_simple     # simple algorithm using single group of images
    local i
    for i in 1 2 3
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-b" && do_bayer=1 && shift 1
        test "$1" == "-s" && do_simple=1 && shift 1
    done
    
    local setname=${1:-""}
    local rdir=${AI_RAWDIR:-"."}
    local bad=${AI_BADPIX:-""}
    local sdat=${AI_SETS:-"set.dat"}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local ccdregion=${AI_CCDREGION:-""}  # w h xoff yoff
    local imlist=$(mktemp "$tdir/tmp_imlist_XXXXXX.dat")
    local statfile=$(mktemp "$tdir/tmp_imstat_XXXXXX.dat")
    local tmpim=$(mktemp "$tdir/tmp_im1_XXXXXX.pnm")
    local tmpdark=$(mktemp "$tdir/tmp_dark_XXXXXX.pgm")
    local tmpmean=$(mktemp "$tdir/tmp_mean_XXXXXX.pnm")
    local mask=$(mktemp "$tdir/tmp_mask_XXXXXX.pbm")
    local ltime
    local sname
    local target
    local type
    local texp
    local n1
    local n2
    local nref
    local dark
    local flat
    local x
    local mdk
    local num
    local ext
    local fname
    local ielist
    local iolist
    local n
    local w
    local h
    local ng
    local ig
    local im
    local im2
    local mxx
    local mrgb
    local mr
    local mg
    local mb
    local xx
    local draw
    local dcrawopts
    local is_dark_subtracted
    local scale
    local flip
    local opts

    test "$showhelp" &&
        echo "usage: AIflat [-b] [-s] [set]" >&2 &&
        return 1
    
    test "$bad" && test ! -e $bad &&
        echo "ERROR: badpix file $bad is missing." >&2 &&
        return 1

    while read ltime sname target type texp n1 n2 nref dark flat x
    do
        (echo "$ltime" | grep -q "^#") && continue
        test "$type" != "f" && continue
        test "$setname" && test "$setname" != "$sname" && continue
        (! is_integer "$n1" || ! is_integer "$n2") && continue
        
        test ! "$dark" &&
            echo "ERROR: set $sname has no dark defined." && continue
        test ! -f "$dark".pgm &&
            echo "ERROR: dark image $dark.pgm for set $sname not found." && continue
        
        is_dark_subtracted=""
        test "$(AIsetinfo $sname | awk '{print $11}')" == "0" &&
            is_dark_subtracted=1 &&
            echo "$sname: in-camera dark subtraction assumed."

        AIimlist $sname "" raw > $imlist
        n=$(cat $imlist | wc -l)
        test ! "$do_simple" && test $n -lt 6 &&
            echo "ERROR: set $sname has too few images ($n < 6)." &&
            rm $imlist && continue
        
        ext="ppm"
        fname=$(head -1 $imlist | awk '{print $3}')
        is_fits $fname && ! is_fitscube $fname && ext=pgm
        #is_fitzip $fname && ext=pgm
        test "$do_bayer" && ext="pgm"
        test -f $sname.$ext &&
            echo "WARNING: $sname.$ext exists, skipping set $sname." >&2 && continue
        

        # check if images of this set are captured by gacam
        dcrawopts=""
        if is_gacam_raw "$fname" && test "$ccdregion"
        then
            dcrawopts="-R $ccdregion"
            w=$(echo $ccdregion | cut -d ' ' -f1)
            h=$(echo $ccdregion | cut -d ' ' -f2)
        else
            set - $(imsize "$fname")
            w=$1
            h=$2
        fi
        
        # crop dark image if necessary
        if [ $(imsize $dark.pgm | cut -d ' ' -f2) -gt $h ]
        then
            echo "# croping $dark.pgm to $w $h"
            imcrop -1 $dark.pgm $w $h 0 0 > $tmpdark
        else
            cp $dark.pgm $tmpdark
        fi

        # check for in-camera dark subtraction (black=0)
        test "$is_dark_subtracted" &&
            mdk=$(AImstat $tmpdark  | awk '{printf("%d", $5+0.5)}') &&
            dcrawopts="$dcrawopts -B $mdk"
        test "$dcrawopts" && echo "# dcrawopts = $dcrawopts"

        # determine intensity scaling factor to stretch to full 16bit range
        # this is used by AIraw2gray in case of FITS images only
        scale=$(get_param camera.dat rawbits $sname | awk '{if ($1!="-" && $1<16) print 2^(16-$1)}')

        # check if top-down image flipping is required
        flip=$(get_param camera.dat flip $sname | awk '{if ($1=="1") print 1}')
        
        # options for raw image conversion
        opts=""
        test "$scale" && opts="-s $scale"
        test "$flip"  && opts=$(echo $opts "-f")

        echo "processing $n flats in set $sname ..."
        
        echo "dark subtraction"
        while read x num fname x
        do
            echo "  $num"
            if [ "$ext" == "pgm" ]
            then
                AI_DCRAWPARAM="$AI_DCRAWPARAM $dcrawopts" \
                AIraw2gray $opts $fname $tmpdark $bad > $tdir/$num.$ext
            else
                AI_DCRAWPARAM="$AI_DCRAWPARAM $dcrawopts" \
                AIraw2rgb  $opts $fname $tmpdark $bad > $tdir/$num.$ext
            fi
        done < $imlist
        
        # get image dimensions
        num=$(head -1 $imlist | awk '{printf("%s", $2)}')
        w=$(identify $tdir/$num.$ext | cut -d " " -f3 | cut -d "x" -f1)
        h=$(identify $tdir/$num.$ext | cut -d " " -f3 | cut -d "x" -f2)
        
        # median in even/odd images in groups of 6+ images
        ng=$(($n / 6))
        test "$do_simple" && ng=1
        ig=1; im=1
        i=0; ielist=""; iolist=""  # lists with even and odd image index
        rm -f $tdir/$sname.m[0-9][0-9].$ext
        while read x num fname x
        do
            i=$(($i+1))
            if [ "$do_simple" ]
            then
                iolist="$iolist $tdir/$num.$ext"
            else
                test $(($i %2)) -eq 0 && ielist="$ielist $tdir/$num.$ext"
                test $(($i %2)) -eq 1 && iolist="$iolist $tdir/$num.$ext"
            fi
            if ([ $ig -lt $ng ] && [ $(($i %6)) -eq 0 ]) ||
               ([ $ig -eq $ng ] && [ $i -eq $n ])
            then
                # statistics for images of this group
                echo "normalize group $ig out of $ng ..."
                if [ $do_bayer ]
                then
                    AImstat -b -c $ielist $iolist > $statfile
                    cat $statfile
                    # get mean rgb
                    mxx=$(cat $statfile | awk '{a=a+$5; b=b+$9; c=c+$13; d=d+$17}END{
                        printf("%.1f %.1f %.1f %.1f", a/NR, b/NR, c/NR, d/NR)}')
                    echo "  mean mxx = $mxx"
                else
                    AImstat -c $ielist $iolist > $statfile
                    cat $statfile
                    if [ "$ext" == "pgm" ]
                    then
                        mxx=$(mean $statfile 5 | awk '{printf("%.1f", $1)}')
                        echo "  mean mxx = $mxx"
                    else
                        # get mean rgb
                        mrgb=$(cat $statfile | awk '{r=r+$5; g=g+$9; b=b+$13}END{
                            printf("%.1f %.1f %.1f", r/NR, g/NR, b/NR)}')
                        mr=$(echo $mrgb | cut -d " " -f1)
                        mg=$(echo $mrgb | cut -d " " -f2)
                        mb=$(echo $mrgb | cut -d " " -f3)
                        echo "  mean rgb = $mrgb"
                    fi
                fi
                
                # normalize images
                if [ $do_bayer ]
                then
                    while read f x   x x a x   x x b x   x x c x   x x d x
                    do
                        xx=$(echo $mxx $a $b $c $d | awk -v l=20000 '{
                            printf("%.0f %.0f %.0f %.0f\n",
                                l*$5/$1, l*$6/$2, l*$7/$3, l*$8/$4)}')
                        echo $f $xx
                        echo -e "P2\n2 2\n65535\n$xx" | pnmtile $w $h - | \
                            pnmccdred -m 20000 -s - $tdir/$f $tmpim &&
                            mv $tmpim $tdir/$f
                    done < $statfile
                else
                    if [ "$ext" == "pgm" ]
                    then
                        while read f x   x x a x
                        do
                            xx=$(echo "scale=4; $mxx/$a" | bc)
                            pnmccdred -m $xx $tdir/$f $tmpim &&
                                mv $tmpim $tdir/$f
                        done < $statfile
                    else
                        while read f x   x x r x   x x g x   x x b x
                        do
                            mulR=$(echo "scale=4; $mr/$r" | bc)
                            mulG=$(echo "scale=4; $mg/$g" | bc)
                            mulB=$(echo "scale=4; $mb/$b" | bc)
                            echo "  normalize $f: $mulR,$mulG,$mulB"
                            pnmccdred -m $mulR,$mulG,$mulB $tdir/$f $tmpim &&
                                mv $tmpim $tdir/$f
                        done < $statfile
                    fi
                fi
                
                # process iolist
                im2=$(printf "%02d" $im)
                echo "median odd images in group $ig -> $tdir/$sname.m$im2.$ext"
                pnmcombine -d $iolist $tdir/$sname.m$im2.$ext
                im=$(($im + 1))
                # process ielist
                if [ "$ielist" ]
                then
                    im2=$(printf "%02d" $im)
                    echo "median even images in group $ig -> $tdir/$sname.m$im2.$ext"
                    pnmcombine -d $ielist $tdir/$sname.m$im2.$ext
                    im=$(($im + 1))
                fi
                ig=$(($ig+1))
                ielist=""; iolist=""
            fi
        done < $imlist
        
        # average over medians
        if [ "$do_simple" ]
        then
            mv $tdir/$sname.m01.$ext $sname.$ext
        else
            echo "average median images ..."
            pnmcombine $tdir/$sname.m[0-9][0-9].$ext $sname.$ext
        fi
        
        # interpolation of bad pixels
        if [ "$do_bayer" ] && [ "$bad" ]
        then
            mv $sname.$ext $tmpim
            # average 4 cells in 2 pix distance
            convert $tmpim -define convolve:scale=\! \
                -morphology Convolve Ring:1.5,2 $tmpmean
            # convert bad to mask image
            draw=$(grep -v "^#" $bad | grep "[0-9]" | awk -v w=$w -v h=$h '{
                if(found>0)printf("; ")
                if ($1<w && $2<h) {
                    printf("color %d,%d point", $1, $2)
                    found=1
                }}')
            convert $tmpim -fill black -draw 'color 1,1 reset' -fill white \
                -draw "$draw" $mask
            # replace bad pixels by interpolated pixel
            pnmcomp -alpha $mask $tmpmean $tmpim $sname.$ext
        fi

        # clean up
        rm -f $tdir/$sname.m[0-9][0-9].$ext
        while read x num fname x
        do
            rm -f $tdir/$num.$ext
        done < $imlist
    done < $sdat
    rm -f $imlist $statfile $tmpim $tmpdark $tmpmean $mask
}


# DSLR ccd image reduction (bad pixel, dark, flat)
# optionally limit to a given set name (first argument)
# it creates PPM or PGM images in $AI_TMPDIR
AIccd () {
    AIcheck_ok -r || return 255
    local showhelp
    local do_bayer          # if set then keep bayer matrix and create gray
                            # images instead of rgb
    local quality=3         # set demosaicing algorithm ("quality"):
                            # 0=bilinear, 1=VNG, 2=PPG, 3=AHD
    local add=0             # add offset to output image (applies only to gray images)
    local is_calibrated     # if set ignore dark and flat
    local i
    for i in 1 2 3 4 5 6
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-z" && echo "WARNING: obsolete option -z." >&2 && shift 1
        test "$1" == "-b" && do_bayer=1 && shift 1
        test "$1" == "-q" && quality=$2 && shift 2
        test "$1" == "-a" && add=$2 && shift 2
        test "$1" == "-c" && is_calibrated=1 && shift 1
    done
    local setname=${1:-""}
    local rdir=${AI_RAWDIR:-"."}
    local bad=${AI_BADPIX:-""}
    local sdat=${AI_SETS:-"set.dat"}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local ex=${AI_EXCLUDE:-""}  # space separated list of image numbers
    local ccdregion=${AI_CCDREGION:-""}  # w h xoff yoff
    local imlist=$(mktemp "$tdir/tmp_imlist_XXXXXX.dat")
    local tmpdark=$(mktemp "$tdir/tmp_dark_XXXXXX.pgm")
    local tmpflat=$(mktemp "$tdir/tmp_flat_XXXXXX.pnm")
    local tmpim=$(mktemp "$tdir/tmp_im_XXXXXX.pnm")
    local ltime
    local sname
    local target
    local type
    local texp
    local n1
    local n2
    local nref
    local dark
    local flat
    local n
    local nlist
    local ext
    local is_dark_subtracted    # black=0 indicates in-camera dark subtraction
    local x
    local num
    local fname
    local mdk
    local dcrawopts
    local bytesperpix
    local mxx
    local mrgb
    local size
    local scale
    local flip
    local retval=0

    test "$showhelp" &&
        echo "usage: AIccd [-b] [-q quality|$quality] [-a add] [-c] [set]" >&2 &&
        return 1
    
    test "$bad" && test ! -e $bad &&
        echo "ERROR: badpix file $bad is missing." >&2 &&
        return 1

    while read ltime sname target type texp n1 n2 nref dark flat x
    do
        (echo "$ltime" | grep -q "^#") && continue
        echo "$ltime" | grep -q "^[0-9][0-9]:[0-9][0-9]$" || continue
        test "$type" != "o" && continue
        test "$setname" && test "$setname" != "$sname" && continue
        (! is_integer "$n1" || ! is_integer "$n2") && continue
        if [ ! "$is_calibrated" ]
        then
            (test ! "$dark" || test "$dark" == "-") &&
                echo "ERROR: set $sname has no dark defined." >&2 &&
                retval=255 && continue
            test ! -f "$dark".pgm &&
                echo "ERROR: dark image $dark.pgm for set $sname not found." >&2 &&
                retval=255 && continue
            (test ! "$flat" || test "$flat" == "-") &&
                echo "ERROR: set $sname has no flat defined." >&2 &&
                retval=255 && continue
            test "$do_bayer" && test ! -f "$flat".pgm &&
                echo "ERROR: flat image $flat.pgm for set $sname not found." >&2 &&
                retval=255 && continue
            test ! -f "$flat".pgm && test ! -f "$flat".ppm &&
                echo "ERROR: flat image $flat.p[gp]m for set $sname not found." >&2 &&
                retval=255 && continue
        fi
        
        AIimlist $sname "" raw > $imlist
        n=0; nlist=""; ext=ppm
        while read x num fname x
        do
            echo $ex | grep -q -w $num - && echo "excluding image $num." && continue
            n=$(($n + 1)) && nlist="$nlist $num"
            if [ $n -eq 1 ]
            then
                test "$do_bayer" && ext=pgm
                is_fits $fname && ! is_fitscube $fname && ! is_fitsbayer $fname && ext=pgm
                is_fitzip $fname && ext=pgm
            fi
        done < $imlist
        # check disk space requirements
        bytesperpix=6
        test "$ext" == "pgm" && bytesperpix=2
        test ! "$is_calibrated" && ! is_diskspace_ok "$tdir" "$dark.pgm" $n $bytesperpix &&
            echo "ERROR: not enough disk space to process set $sname." &&
            retval=255 && continue
        echo "processing $n images in set $sname ..."
        
        fname=$(get_rawfile $nref)
        is_dark_subtracted=""
        is_raw $fname && test ! "$is_calibrated" && test "$(AIsetinfo $sname | awk '{print $11}')" == "0" &&
            is_dark_subtracted=1 &&
            echo "$sname: in-camera dark subtraction assumed."
        
        # determine size of output images of this set
        dcrawopts=""
        if is_gacam_raw "$fname" && test "$ccdregion"
        then
            dcrawopts="-R $ccdregion"
            w=$(echo $ccdregion | cut -d ' ' -f1)
            h=$(echo $ccdregion | cut -d ' ' -f2)
        else
            set - $(imsize "$fname")
            w=$1
            h=$2
        fi
        test "$dcrawopts" && echo "# dcrawopts = $dcrawopts"
        
        if [ ! "$is_calibrated" ]
        then
            # crop dark image if necessary
            if [ $(imsize $dark.pgm | cut -d ' ' -f2) -gt $h ]
            then
                echo "# croping $dark.pgm to $w $h"
                imcrop -1 $dark.pgm $w $h 0 0 > $tmpdark
            else
                cp $dark.pgm $tmpdark
            fi

            # crop flat image if necessary
            if [ -f $flat.pgm ]
            then
                if [ $(imsize $flat.pgm | cut -d ' ' -f2) -gt $h ]
                then
                    echo "# croping $flat.pgm to $w $h"
                    imcrop -1 $flat.pgm $w $h 0 0 > $tmpflat
                else
                    cp $flat.pgm $tmpflat
                fi
            else
                if [ $(imsize $flat.ppm | cut -d ' ' -f2) -gt $h ]
                then
                    echo "# croping $flat.ppm to $w $h"
                    imcrop -1 $flat.ppm $w $h 0 0 > $tmpflat
                else
                    cp $flat.ppm $tmpflat
                fi
            fi
            
            # check sizes of dark and flat
            set - $(identify $tmpdark) x
            size=$3
            set - $(identify $tmpflat) x
            test "$3" != "$size" &&
                echo "ERROR: size mismatch between dark and flat" >&2 &&
                continue
            
            # get mean RGB values for dark and flat
            test "$is_dark_subtracted" &&
                mdk=$(AImstat $tmpdark | awk '{printf("%d", $5+0.5)}') &&
                dcrawopts="$dcrawopts -B $mdk"
            if is_pgm $tmpflat
            then
                # normalize flat to value 10000
                # TODO: deal with xtrans matrices
                AIbnorm $tmpflat > $tmpim
                mv $tmpim $tmpflat
            else
                mrgb=$(AImstat -c $tmpflat | awk '{
                    if ($13=="") {print $3","$4","$5} else {print $5","$9","$13}}')
                echo "  mrgb = $mrgb"
            fi
        fi
        
        # determine intensity scaling factor to stretch to full 16bit range
        # this is used by AIraw2rgb in case of FITS images only
        scale=$(get_param camera.dat rawbits $sname | awk '{if ($1!="-" && $1<16) print 2^(16-$1)}')
        
        # check if top-down image flipping is required
        flip=$(get_param camera.dat flip $sname | awk '{if ($1=="1") print 1}')
        
        # ccd reduction
        opts=""
        test "$scale" && opts="-s $scale"
        test "$flip"  && opts=$(echo $opts "-f")
        test "$is_calibrated" && rm -f $tmpdark $tmpflat && tmpdark="" && tmpflat=""
        while read x num fname x
        do
            test -f $tdir/$num.$ext &&
                echo "image $num.$ext already processed." && continue
            echo "  $num"
            
            # monochrome image
            if [ "$do_bayer" ] || [ "$ext" == "pgm" ] || (is_fits $fname && ! is_fitsbayer $fname)
            then
                test "$AI_DEBUG" && echo "AI_DCRAWPARAM=\"$AI_DCRAWPARAM $dcrawopts\" \
                    AIraw2gray $opts -a $add $fname \"$tmpdark\" \"$bad\" \"$tmpflat\" > $tdir/$num.$ext"
                AI_DCRAWPARAM="$AI_DCRAWPARAM $dcrawopts" \
                AIraw2gray $opts -a $add $fname "$tmpdark" "$bad" "$tmpflat" > $tdir/$num.$ext
            fi
            (test "$do_bayer" || test "$ext" == "pgm" || (is_fits $fname && ! is_fitsbayer $fname)) && continue
            
            # RGB image
            if is_pgm $tmpflat || [ -z "$tmpflat" ]
            then
                test "$AI_DEBUG" && echo "AI_DCRAWPARAM=\"$AI_DCRAWPARAM $dcrawopts\" \
                AIraw2rgb $opts -q $quality $fname \"$tmpdark\" \"$bad\" \"$tmpflat\" > $tdir/$num.$ext"
                AI_DCRAWPARAM="$AI_DCRAWPARAM $dcrawopts" \
                AIraw2rgb $opts -q $quality $fname "$tmpdark" "$bad" "$tmpflat" > $tdir/$num.$ext
            else
                test "$AI_DEBUG" && echo "AI_DCRAWPARAM=\"$AI_DCRAWPARAM $dcrawopts\" \
                AIraw2rgb $opts -q $quality $fname \"$tmpdark\" \"$bad\"  | \
                    pnmccdred -s \"$tmpflat\" -m $mrgb - $tdir/$num.$ext"
                AI_DCRAWPARAM="$AI_DCRAWPARAM $dcrawopts" \
                AIraw2rgb $opts -q $quality $fname "$tmpdark" "$bad" | \
                    pnmccdred -s "$tmpflat" -m $mrgb - $tdir/$num.$ext
            fi
        done < $imlist
    done < $sdat
    test "$AI_DEBUG" || rm -f $imlist $tmpdark $tmpflat $tmpim
    return $retval
}


# source extraction
# requires PPM/PGM images as produced by AIccd in $AI_TMPDIR
# creates sources data files in directory measure
# note on bayer images: single color images g1 or g2 are heavily undersampled
#   resulting in poor detections, therefore we operate on g1+g2 and replace
#   b1,r1 by average of 4 surrounding green pixel values
AIsource () {
    #AIcheck_ok || return 255
    local showhelp
    local quiet         # if set suppress messages from sextractor
    local color         # if set then extract given color channel, either 1,2,3
                        # for r,g,b or g to use gray conversion, default is to
                        # process all channels
    local outascii      # change results file format to ASCII_HEAD (default FITS-LDAC)
    local outname
    local do_bayer      # if set then use g1/g2 from bayer matrix of gray
                        # input images (produced by AIccd -b)
    local do_crossmatch # if set then associate detections in different color
                        # bands (NOT implemented yet!)
    local i
    for i in $(seq 1 7)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-q" && quiet=1 && shift 1
        (test "$1" == "-1" || test "$1" == "-2" || test "$1" == "-3" || \
            test "$1" == "-g") && color=${1#-} && shift 1
        test "$1" == "-a" && outascii=1 && shift 1
        test "$1" == "-o" && outname=$2 && shift 2
        test "$1" == "-b" && do_bayer=1 && shift 1
        test "$1" == "-x" && do_crossmatch=1 && shift 1
    done
    local setname=${1:-""}
    local use_isophotes=${2:-""} # use isophotes for object shape instead of
                                 # windowed measurements (sextractor)
    local threshold=${3:-10}     # detection threshold (sextractor)
    local bgsize=${4:-"64"}      # bg mesh size used for bg subtraction
    local dbnthresh=${5:-"64"}   # Number of deblending sub-thresholds
    local dbmincont=${6:-"0.0005"} # Minimum contrast parameter for deblending
    local fwhm=${7:-"4"}         # stellar FWHM in arcsec
    local sparam=${8:-""}        # additional sextractor parameters
    local sdat=${AI_SETS:-"set.dat"}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local imlist=$(mktemp "$tdir/tmp_imlist_XXXXXX.dat")
    local sfits=$(mktemp "$tdir/tmp_im_XXXXXX.fits")
    local g12img=$(mktemp "$tdir/tmp_g12img_XXXXXX.pgm")
    local assoclist=$(mktemp "$tdir/tmp_assoc_XXXXXX.dat")
    local tmpcat=$(mktemp "$tdir/tmp_scat_XXXXXX.dat")
    local saturation            # saturation in ADU (scaled to 16bit)
    local gain                  # effective gain in e-/ADU
    local magzero               # magzero for texp=1
    local hdr
    local sname
    local target
    local type
    local texp
    local n1
    local n2
    local nref
    local dark
    local flat
    local singleimage
    local inext
    local setparam
    local pixscale
    local sopts
    local assocopts
    local nexp
    local mag0
    local w
    local h
    local telid

    sopts="-backphoto_type local -filter N $sparam"
    test "$quiet" && sopts="-verbose_type quiet $sopts"
    
    test "$showhelp" &&
        echo "usage: AIsource [-q] [-a] [-o outname] [-b] [-1|2|3|g] [set|img]" \
            "[use_isophotes] [thres|$threshold]" \
            "[bgsize|$bgsize] [dbnthresh|$dbnthresh] [dbmincont|$dbmincont]" \
            "[fwhm\"|$fwhm] [sparam|$sparam]" >&2 &&
        return 1
    # <130611
    false && test "$showhelp" &&
        echo "usage: AIsource [set|img] [use_isophotes] [thres|$threshold]"\
            "[bgsize|$bgsize] [fwhm\"|$fwhm] [magzero|$magzero] [gain|$gain]" >&2 &&
        return 1

    # experimental features
    test "$do_crossmatch" &&
        echo "WARNING: using experimental feature is highly discouraged!" >&2 &&
        echo "    continue in 10 seconds ..." >&2 &&
        sleep 10

    # sextractor parameters
    sconf=$tdir/sex.config
    sex -d > $sconf
    fields=$tdir/sex.fields
    if [ "$use_isophotes" ]
    then
        echo NUMBER EXT_NUMBER X_IMAGE Y_IMAGE ERRX2_IMAGE ERRY2_IMAGE \
        A_IMAGE B_IMAGE THETA_IMAGE ERRA_IMAGE ERRB_IMAGE \
        ERRTHETA_IMAGE ELONGATION FWHM_IMAGE \
        MAG_AUTO MAGERR_AUTO FLUX_AUTO FLUXERR_AUTO FLUX_RADIUS \
        FLAGS FLAGS_WEIGHT | tr ' ' '\n' > $fields
    else
        echo NUMBER EXT_NUMBER XWIN_IMAGE YWIN_IMAGE ERRX2_IMAGE ERRY2_IMAGE \
        AWIN_IMAGE BWIN_IMAGE THETAWIN_IMAGE ERRAWIN_IMAGE ERRBWIN_IMAGE \
        ERRTHETAWIN_IMAGE ELONGATION FWHM_IMAGE \
        MAG_AUTO MAGERR_AUTO FLUX_AUTO FLUXERR_AUTO FLUX_RADIUS \
        FLAGS FLAGS_WEIGHT | tr ' ' '\n' > $fields
    fi
    sopts="-parameters_name $fields -back_size $bgsize
        -deblend_nthresh $dbnthresh -deblend_mincont $dbmincont
        -seeing_fwhm $fwhm
        $sopts"
    assocopts="-assoc_name $assoclist -assoc_radius 1 -assoc_type nearest -assoc_data 0"
    if [ "$outascii" ]
    then
        sopts="$sopts -catalog_type ASCII_HEAD"
    else
        sopts="$sopts -catalog_type FITS_LDAC"
    fi


    if [ -f "$setname" ]
    then
        ! (is_fits $setname || is_pnm $setname) &&
            echo "ERROR: $setname is not a recogniced file type (FITS|PNM)." >&2 &&
            rm -f $imlist $sfits &&
            return 255
        
        test -z "$outname" && outname=$(basename ${setname%.*}.src.dat)

        # try to read some keywords from $img.head
        hdr=${setname%.*}.head
        texp=""     # exposure time in sec
        nexp=""     # number of exposures that have been averaged
        if [ -f $hdr ]
        then
            texp=$(grep "^EXPTIME" $hdr | tr '=' ' ' | awk '{if ($2>0) printf("%d", 1*$2)}')
            nexp=$(grep "^NEXP" $hdr | tr '=' ' ' | awk '{if ($2>0) printf("%d", $2)}')
            gain=$(grep "^GAIN" $hdr | tr '=' ' ' | awk '{if ($2>0) printf("%.3f", 1*$2)}')
            magzero=$(grep "^MAGZERO" $hdr | tr '=' ' ' | awk '{if ($2>0) printf("%.2f", $2)}')
            saturation=$(grep "^SATURATE" $hdr | tr '=' ' ' | awk '{if ($2>0) printf("%.2f", $2)}')
            pixscale=$(get_wcspscale $hdr)
            telid=$(get_header -q $hdr AI_TELID)
            if [ "$telid" ]
            then
                test -z "$gain"       && gain=$(get_param       camera.dat gain     $telid)
                test -z "$pixscale"   && pixscale=$(get_param   camera.dat pixscale $telid)
                test -z "$magzero"    && magzero=$(get_param    camera.dat magzero  $telid) &&
                    set_header $hdr MAGZERO=$magzero
                test -z "$saturation" && saturation=$(get_param camera.dat satur    $telid) &&
                    set_header $hdr SATURATE=$saturation
            fi
        fi
        test -z "$texp"   && texp=1
        test -z "$nexp"   && nexp=1

        # read data from environment
        test "$AI_SATURATION"   && saturation=$AI_SATURATION
        test "$AI_GAIN"         && gain=$AI_GAIN
        test "$AI_PIXSCALE"     && pixscale=$AI_PIXSCALE
        test "$AI_MAGZERO"      && magzero=$AI_MAGZERO
        
        sdat=$tdir/tmp_set_$$.dat
        echo "00:00 $setname xx o $texp 0 0 0 xx xx xx" > $sdat

        singleimage="y"
    else
        test ! -d measure && mkdir measure
        nexp=1
    fi

    while read ltime sname target type texp n1 n2 nref dark flat x
    do
        (echo "$ltime" | grep -q "^#") && continue
        test "$type" != "o" && continue
        test "$setname" && test "$setname" != "$sname" && continue
        (! is_integer "$n1" || ! is_integer "$n2") && continue

        inext=""
        if [ "$singleimage" != "y" ]
        then
            test -z "$(AIimlist -q $sname)" &&
                echo "WARNING: skipping set $sname (missing lights)" && continue
            AIimlist $sname > $imlist
            n=0; nlist=""
            while read x num fname x
            do
                test -z "$inext" && is_pgm $fname && inext="pgm"
                test -z "$inext" && inext="ppm"
                if [ "$do_bayer" ]
                then
                    test ! -f "$tdir/$num.pgm" &&
                        echo "ERROR: $tdir/$num.pgm not found." >&2 && n=0 && break
                    test -f "measure/$num.src.dat" &&
                        echo "WARNING: skipping $num, measure/$num.src.dat exists." >&2 &&
                        continue 
                else
                    test ! -f "$tdir/$num.$inext" &&
                        echo "ERROR: $tdir/$num.$inext not found." >&2 && n=0 && break
                    test -f "measure/$num.src.dat" &&
                        echo "WARNING: skipping $num, measure/$num.src.dat exists." >&2 &&
                        continue 
                fi
                n=$(($n + 1))
                nlist="$nlist $num"
            done < $imlist
            test $n -eq 0 && echo "WARNING: skipping set $sname" && continue
            echo "processing $n images in set $sname ..."

            # read data from camera.dat or environment
            get_telescope $sname > /dev/null
            test $? -ne 0 && continue
            saturation=$(get_param camera.dat satur    $sname AI_SATURATION)
            gain=$(get_param       camera.dat gain     $sname AI_GAIN)
            pixscale=$(get_param   camera.dat pixscale $sname AI_PIXSCALE)
            magzero=$(get_param    camera.dat magzero  $sname AI_MAGZERO)
        fi
        
        # set parameters depending on set name (e.g. pixscale, magzero)
        setparam=""
        test "$gain"       && setparam="$setparam -gain $gain"
        test "$saturation" && setparam="$setparam -satur_level $saturation"
        test "$pixscale"   && setparam="$setparam -pixel_scale $pixscale"
        test -z "$magzero" &&
            echo "WARNING: magzero unknown, using 25.5" >&2 && magzero=25.5
        mag0=$(echo $magzero $texp $nexp | awk '{
            printf("%.2f\n", $1+2.5/log(10)*log($2/$3))}')
        setparam="$setparam -mag_zeropoint $mag0"
        if [ ! "$singleimage" ]
        then
            echo "# texp=$texp nexp=$nexp gain=$gain pixscale=$pixscale" \
                "magzero=$magzero saturation=$(echo $saturation | awk '{printf("%.0f", $1)}')" >&2
        fi

        if [ "$singleimage" == "y" ]
        then
            sopts="$sopts -detect_thresh $threshold"
            if is_pnm "$setname"
            then
                if is_pgm "$setname"
                then
                    if [ "$do_bayer" ]
                    then
                        w=$(identify $setname | cut -d " " -f3 | cut -d "x" -f1)
                        h=$(identify $setname | cut -d " " -f3 | cut -d "x" -f2)
                        echo -e "P2\n2 2\n1\n0 1 1 0" | pnmtile $w $h - | \
                            pnmarith -mult - $setname > $g12img
                        convert $g12img -morphology Convolve "$kernel" pgm: | \
                            pnmarith -add $g12img - | pnmtomef - > $sfits
                    else
                        pnmtomef "$setname" > $sfits
                    fi
                    sex -c $sconf $setparam $sopts -catalog_name $outname $sfits
                    test $? -ne 0 && echo "ERROR: sex failed." >&2 && return 255
                else
                    if [ "$color" ]
                    then
                        case "$color" in
                            # old: ppm2gray -f "$setname" "1,0,0" > $sfits;;
                            1)  gm convert "$setname" -channel Red   pgm:- | pnmtomef - > $sfits;;
                            2)  gm convert "$setname" -channel Green pgm:- | pnmtomef - > $sfits;;
                            3)  gm convert "$setname" -channel Blue  pgm:- | pnmtomef - > $sfits;;
                            g)  ppm2gray -f "$setname" > $sfits;;
                        esac
                        sex -c $sconf $setparam $sopts -catalog_name $outname $sfits
                        test $? -ne 0 && echo "ERROR: sex failed." >&2 && return 255
                    else
                        if [ "$do_crossmatch" ]
                        then
                            # G
                            # old: ppm2gray -f "$setname" "0,1,0" > $sfits
                            gm convert "$setname" -channel Green pgm:- | pnmtomef - > $sfits
                            #echo sex -c $sconf $setparam $sopts -catalog_name $outname $sfits >&2
                            sex -c $sconf $setparam $sopts -catalog_name $outname $sfits
                            test $? -ne 0 && echo "ERROR: sex failed." >&2 && return 255
                            sexselect $outname "" "" "" "" "NUMBER,X*,Y*,MAG_AUTO" > $assoclist
                            echo "VECTOR_ASSOC()" >> $fields
                            # R
                            gm convert "$setname" -channel Red   pgm:- | pnmtomef - > $sfits
                            sex -c $sconf $setparam $sopts $assocopts -catalog_name $tmpcat $sfits
                            test $? -ne 0 && echo "ERROR: sex failed." >&2 && return 255
                            echo "G=$outname R=$tmpcat" >&2
                            echo "WARNING: further processing needed ..."
                            return
                            # merge tables $outname and $tmpcat, rename to $outname
                            gm convert "$setname" -channel Blue  pgm:- | pnmtomef - > $sfits
                            sex -c $sconf $setparam $sopts $assocopts -catalog_name $tmpcat $sfits
                            test $? -ne 0 && echo "ERROR: sex failed." >&2 && return 255
                            # merge tables $outname and $tmpcat, rename to $outname
                        else
                            pnmtomef "$setname" > $sfits
                            sex -c $sconf $setparam $sopts -catalog_name $outname $sfits
                            test $? -ne 0 && echo "ERROR: sex failed." >&2 && return 255
                        fi
                    fi
                fi
            else
                # TODO: try to read exposure time from FITS header and adjust magzero
                sex -c $sconf $setparam $sopts -catalog_name $outname $setname
                test $? -ne 0 && echo "ERROR: sex failed." >&2 && return 255
            fi
        else
            # TODO: if requested increase threshold based on object counts
            #   in $tdir/$nref.$inext
            sopts="$sopts -detect_thresh $threshold"
            for num in $nlist
            do
                outname=measure/$num.src.dat
                if [ -z "$color" ]
                then
                    if [ "$do_bayer" ]
                    then
                        if [ "$num" == "$(echo $nlist | cut -d ' ' -f1)" ]
                        then
                            w=$(identify $tdir/$num.pgm | cut -d " " -f3 | cut -d "x" -f1)
                            h=$(identify $tdir/$num.pgm | cut -d " " -f3 | cut -d "x" -f2)
                            echo $num $w $h
                        fi
                        echo -e "P2\n2 2\n1\n0 1 1 0" | pnmtile $w $h - | \
                            pnmarith -mult - $tdir/$num.pgm > $g12img
                        convert $g12img -morphology Convolve \
                            "3x3: 0.0,0.25,0.0  0.25,0.0,0.25   0.0,0.25,0.0" pgm: | \
                            pnmarith -add $g12img - | pnmtomef - > $sfits
                    else
                        pnmtomef $tdir/$num.$inext > $sfits
                    fi
                else
                    if [ "$inext" == "ppm"]
                    then
                        case "$color" in
                            # old: ppm2gray -f $tdir/$num.ppm "1,0,0" > $sfits;;
                            1)  gm convert $tdir/$num.ppm -channel Red   pgm:- | pnmtomef - > $sfits;;
                            2)  gm convert $tdir/$num.ppm -channel Green pgm:- | pnmtomef - > $sfits;;
                            3)  gm convert $tdir/$num.ppm -channel Blue  pgm:- | pnmtomef - > $sfits;;
                            g)  ppm2gray -f $tdir/$num.ppm > $sfits;;
                        esac
                    else
                        pnmtomef $tdir/$num.$inext > $sfits
                    fi
                fi
                sex -c $sconf -verbose_type quiet \
                    $setparam $sopts \
                    -catalog_name $outname $sfits
                test $? -ne 0 && echo "ERROR: sex failed." >&2 && return 255
            done
        fi
    done < $sdat
    rm -f $fields $sconf $imlist $sfits $g12img $tmpcat $assoclist
    test "$singleimage" && rm $sdat
    return 0
}


# register stars with respect to reference image
# output: results are written to stdout
# input: requires sources data files in directory measure
# notes:
#   - if no images are found in $AI_TMPDIR and $AI_RAWDIR then use n1 and n2
#     to guess relevant source cataloges
#   - if header files are not found ($AI_RAWDIR) some header data
#     might not be propagated to measure/<num>.src.head (e.g. ra, de)
AIregister () {
    AIcheck_ok || return 255
    local showhelp
    local coloropt      # set color channel to use (1 or 2 or 3) if
                        # source catalog contains multiple ext_numbers
                        # default: 2
    local has_poor_pos  # if set allow for larger errors on position
    local do_show_processed # if set results from previous registration are
                        # shown
    local mdiff=0.1     # allowed mag diff between images
    local nbright=250   # number of brightmost stars to use for matching
    local verbose       # if set then print results of previously registered
                        # images as well
    for i in $(seq 1 7)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        (test "$1" == "-1" || test "$1" == "-2" || test "$1" == "-3") &&
            coloropt=$1 && shift 1
        test "$1" == "-p" && has_poor_pos=1 && shift 1
        test "$1" == "-s" && do_show_processed=1 && shift 1
        test "$1" == "-m" && mdiff=$2 && shift 2
        test "$1" == "-n" && nbright=$2 && shift 2
        test "$1" == "-v" && verbose=1 && shift 1
    done
    local setname=${1:-""}
    local refimg=${2:-""}
    local magerrlim=${3:-"0.03"}
    local scampopts=${4:-""}
    local sdat=${AI_SETS:-"set.dat"}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local rdir=${AI_RAWDIR:-"."}
    local exifdat="exif.dat"
    local rawfilesdat="rawfiles.dat"
    local conf=$(mktemp "$tdir/tmp_sconf_XXXXXX.txt")
    local inldac=$(mktemp "$tdir/tmp_inldac_XXXXXX.fits")
    local refldac=$(mktemp "$tdir/tmp_refldac_XXXXXX.fits")
    local xydat=$(mktemp "$tdir/tmp_xy_XXXXXX.dat")
    local xyref=$(mktemp "$tdir/tmp_xyref_XXXXXX.dat")
    local wcscat=$(mktemp "$tdir/tmp_wcscat_XXXXXX.fits")
    local ahead=$(mktemp "$tdir/tmp_ahead_XXXXXX.dat")
    local tmp1=$(mktemp "$tdir/tmp_tmp1_XXXXXX.dat")
    local tmp2=$(mktemp "$tdir/tmp_tmp2_XXXXXX.dat")
    local sname
    local type
    local nref
    local dark
    local mycolor
    local has_hline
    local refcat
    local acat
    local singleimage
    local w
    local h
    local cx
    local cy
    local pixscale
    local pscale
    local crad
    local mres      # match_resol = 3*pixscale
    local posmaxerr
    local anglemaxerr
    local snhigh
    local mref
    local nsrc
    local nmatch
    local nhigh
    local nmag
    local filter
    local line
    local refroll   # refroll=1 if ref image has IMGROLL=Y, otherwise 0
    local imgroll   # imgroll=1 if image has IMGROLL=Y, otherwise 0
    local has_poor_match
    local rot180
    local x
    local nmax
    local mm
    local rfile
    
    test "$showhelp" &&
        echo "usage: AIregister [-1|2|3] [-p] [-s] [-v] [-m mdiff|$mdiff] [-n nbright|$nbright]" \
            "[set|img] [refimg] [magerrlim|$magerrlim] [scampopts|$scampopts]" >&2 &&
        return 1

    # some checkings
    test "$refimg" && test ! -f $refimg &&
        echo "ERROR: reference image $refimg not found." >&2 && return 255

    if [ -f "$setname" ]
    then
        ! is_pnm "$setname" &&
            echo "ERROR: $setname is not a recogniced file type (PNM)." >&2 &&
            rm -f $sfits &&
            return 255
        test -z "$refimg" &&
            echo "ERROR: ref image argument missing." >&2 && return 255

        # try to read some keywords from $img.head
        hdr=${setname%.*}.head
        if [ -f $hdr ]
        then
            pixscale=$(get_wcspscale $hdr)
        fi
        test "$AI_PIXSCALE" && pixscale=$AI_PIXSCALE

        sdat=$tdir/tmp_set_$$.dat
        echo "00:00 $setname xx o 0 0 0 $refimg xx xx xx" > $sdat
        singleimage="y"
    else
        test ! -d measure && mkdir measure
    fi

    # high s/n detection level
    snhigh=$(echo $magerrlim | awk '{x=1.2/$1; if(x<10) {x=10}; printf("%d", x)}')
    
    while read ltime sname target type texp n1 n2 nref dark flat x
    do
        (echo "$ltime" | grep -q "^#") && continue
        test "$type" != "o" && continue
        test "$setname" && test "$setname" != "$sname" && continue
        (! is_integer "$n1" || ! is_integer "$n2") && continue
        test -z "$singleimage" && ! is_integer "$nref" &&
            echo "ERROR: nref for $sname undefined, skipping set." >&2 && continue
        
        # check for refcat
        refcat=""
        if [ "$singleimage" ]
        then
            test -f "${refimg%.*}.src.dat" && refcat="${refimg%.*}.src.dat"
        else
            test -z "$refcat" &&
                test -f "measure/$(basename $nref.src.dat)" &&
                refcat="measure/$(basename $nref.src.dat)"
        fi
        test -z "$refcat" &&
            echo "ERROR: reference catalog $nref.src.dat not found." >&2 && continue
        
        # check for raw image header file
        rfile=$(get_rawfile $nref)
        test -z "$rfile" &&
            echo "ERROR: no entry for $nref in $exifdat/$rawfilesdat." >&2 &&
            continue
        test ! -f $rdir/$nref.hdr && ! is_fits "$rfile" && ! is_fitzip "$rfile" &&
            echo "WARNING: missing raw header files, some keywords will be missing." >&2
        
        if [ ! "$singleimage" ]
        then
            nlist=$(AIimlist -n $sname 2>/dev/null)
            test $? -ne 0 &&
                echo "WARNING: no images in AI_TMPDIR found." >&2 &&
                nlist=$(AIimlist -n $sname "" raw 2>/dev/null) &&
                test $? -ne 0 &&
                    echo "WARNING: no images in AI_RAWDIR found." >&2 &&
                    nlist=$(seq $n1 $n2 | awk '{printf("%04d\n", $0)}')
            n=0; nlistok=""
            for num in $nlist
            do
                test ! -f "measure/$num.src.dat" &&
                    echo "WARNING: measure/$num.src.dat not found." >&2 && continue
                n=$(($n + 1))
                nlistok="$nlistok $num"
            done
            nlist=$nlistok
            test $n -eq 0 && echo "WARNING: skipping set $sname" >&2 && continue
            echo "processing $n source lists in set $sname ..." >&2

            # read data from camera.dat or environment
            pixscale=$(get_param camera.dat pixscale $sname AI_PIXSCALE)
        else
            n=1; nlist="$(basename ${setname%.*})"
        fi
        
        # determine parameters depending on set (e.g. pixscale, magzero)
        test -z "$pixscale" &&
            echo "ERROR: $sname: pixscale unknown" >&2 && continue
        #crad=$(echo $pixscale | awk '{print 3*$1}')    # crossid_radius
        mres=$(echo $pixscale | awk '{print 3*$1}')     # match_resol

        # check FITS header keyword IMGROLL in reference image
        refroll=0
        (is_fits "$rfile" || is_fitzip "$rfile") &&
            test "$(get_header -q "$rfile" IMGROLL | tr -d ' ')" == "Y" &&
            refroll=1
        
        # get image width and height from LDAC_IMHEAD in refcat
        w=$(stilts tpipe in=$refcat"#"1 ofmt=fits-basic | fold | grep "[[:alnum:]]" | \
            grep -A 100000 "EXTNAME .*LDAC_IMHEAD" | \
            grep NAXIS1 | (head -1; dd of=/dev/null status=none) | awk '{print $3}')
        h=$(stilts tpipe in=$refcat"#"1 ofmt=fits-basic | fold | grep "[[:alnum:]]" | \
            grep -A 100000 "EXTNAME .*LDAC_IMHEAD" | \
            grep NAXIS2 | (head -1; dd of=/dev/null status=none) | awk '{print $3}')

        # max distance from image center for statistics (a, e, fwhm, dm)
        dlim=0.3
        rmax=$(echo $w $h | awk -v dlim=$dlim '{
            printf("%d", dlim*sqrt($1*$1+$2*$2))}')

        # create global ahead file (only approx. pixscale required)
        # cx,cy are center of image in fits pixel coordinates
        # 140823: replaced pixscale/3600 by fixed pscale (in deg), crad in asec
        #pscale=$(echo $pixscale | awk '{print $1/3600.}')
        pscale=0.0003; mres=5
        cx=$(echo $w | awk '{printf("%.3f", $1/2+0.5)}')
        cy=$(echo $h | awk '{printf("%.3f", $1/2+0.5)}')
        echo "TELESCOP= 'Telescope'  / Observatory: Telescope
INSTRUME= 'Camera'     / Detector: Camera
FILTER  = 'FILTER'     / Detector: Filter
EXPTIME =      1       / Exposure time in seconds
EPOCH   =      2000.0  / Epoch
EQUINOX =      2000.0  / Mean equinox
RADESYS = 'ICRS    '   / Astrometric system
CTYPE1  = 'RA---TAN'   / WCS projection type for this axis
CUNIT1  = 'deg     '   / Axis unit
CRVAL1  =      10.0    / World coordinate on this axis
CRPIX1  =      $cx     / Reference pixel on this axis
CD1_1   =      -$pscale   / Linear projection matrix
CD1_2   =      0          / Linear projection matrix
CTYPE2  = 'DEC--TAN'   / WCS projection type for this axis
CUNIT2  = 'deg     '   / Axis unit
CRVAL2  =      0.0     / World coordinate on this axis
CRPIX2  =      $cy     / Reference pixel on this axis
CD2_1   =      0          / Linear projection matrix
CD2_2   =      $pscale    / Linear projection matrix
PHOTFLAG=      F
END     " > $ahead

        # extract good sources for single color channel from reference
        # catalog and convert to FITS_LDAC format
        sexselect -f $coloropt $refcat "" $magerrlim "" "" "*" 0 | \
            addldacwcs - $ahead > $refldac
        # bright sources in central region used by photometric calibration
        sexselect $refldac "" "" $rmax | LANG=C sort -n -k7,7 | \
            grep -v "^#" | (head -$nbright; dd of=/dev/null status=none) > $xyref
        x=$(tail -1 $xyref | awk -v m=$mdiff '{printf("%.2f", m+$7)}')
        sexselect $refldac $x "" $rmax | LANG=C sort -n -k7,7 | \
            grep -v "^#" > $xyref
        
        # add required columns to WCS reference catalog
        fitscopy "$refldac[LDAC_OBJECTS][col \
            NUMBER;\
            EXT_NUMBER;\
            X_WORLD=10+($w/2+0.5-XWIN_IMAGE)*$pscale;\
            Y_WORLD=(YWIN_IMAGE-$h/2-0.5)*$pscale;\
            ERRA_WORLD=ERRAWIN_IMAGE*$pscale;\
            ERRB_WORLD=ERRBWIN_IMAGE*$pscale;\
            MAG=MAG_AUTO;\
            MAGERR=MAGERR_AUTO;\
            OBSDATE=2000.0;\
            FLAGS;\
            ]" - > $wcscat
        sethead $wcscat",2" TUNIT3='deg'
        sethead $wcscat",2" TUNIT4='deg'
        sethead $wcscat",2" TUNIT5='deg'
        sethead $wcscat",2" TUNIT6='deg'
        sethead $wcscat",2" TUNIT7='mag'
        sethead $wcscat",2" TUNIT8='mag'
        sethead $wcscat",2" TUNIT9='yr'
        
        # match and register stars using scamp, creates measure/$num.src.head
        test -z "$has_hline" &&
            echo "# num nref nsrc nhigh a   e   fw    ns nmag  dm      sx     sy   0  da    dmsd  sxsd sysd 0"
        has_hline=1
        scamp -d > $conf
        for num in $nlist
        do
            #echo $num >&2
            rm -f scamp.xml
            acat=""
            test -f "$num.src.dat" && acat=$num.src.dat
            test -z "$acat" &&
                test -f "measure/$num.src.dat" && acat=measure/$num.src.dat
            test -z "$acat" &&
                echo "WARNING: object catalog $num.src.dat not found." >&2 && continue
            test -f ${acat%.*}.head && test -z "$verbose" &&
                echo "WARNING: skipping $num (${acat%.*}.head exists)" >&2 && continue

            # extract good sources for single color channel from sextractor
            # catalog and convert to FITS_LDAC format
            sexselect -f $coloropt $acat "" $magerrlim "" "" "*" 0 > $inldac

            # create inldac header file
            cp $ahead ${inldac/.fits/.ahead}
            # check of FITS header keyword IMGROLL
            imgroll=0
            rfile=$(get_rawfile $num)
            (is_fits "$rfile" || is_fitzip "$rfile") &&
                test "$(get_header -q "$rfile" IMGROLL | tr -d ' ')" == "Y" &&
                imgroll=1
            test $imgroll -ne $refroll &&
                echo "WARNING: IMGROLL of $num differs from $nref." >&2 &&
                grep "^CD[12]_[12] " $ahead | \
                    sed -e 's/^CD1_1 /CDX_1 /; s/^CD2_2 /CD1_1 /; s/^CDX_1 /CD2_2 /' \
                    > ${inldac/.fits/.ahead}

            nsrc=-1
            nmatch=-1
            nhigh=-1
            has_poor_match=""
            rot180=""
            if [ -f ${acat%.*}.head ]
            then
                echo "WARNING: reusing ${acat%.*}.head." >&2
            else
                # set posmaxerr in arcmin, anglemaxerr in degrees
                #posmaxerr=$(echo "0.1*($w+$h)/2*$pixscale/60" | bc -l)
                posmaxerr=$(echo "0.1*($w+$h)/2*$pscale*60" | bc -l)
                anglemaxerr=10
                # 151016: 0.3 -> 0.5
                test "$has_poor_pos" &&
                    posmaxerr=$(echo "0.5*($w+$h)/2*$pscale*60" | bc -l) &&
                    anglemaxerr=40
                test "$num" == "$nref" &&
                    posmaxerr=$(echo "0.02*($w+$h)/2*$pscale*60" | bc -l) &&
                    anglemaxerr=1

                # run scamp
                # 131121: replaced "-crossid_radius $crad" by "-match_resol $mres"
                # 140823: removed -match_resol $mres
                # 140909: added "-match_resol $mres" back
                cmd="scamp -c $conf -astref_catalog file -astrefcat_name $wcscat \
                    -aheader_global $ahead -position_maxerr $posmaxerr -posangle_maxerr $anglemaxerr \
                    -match_resol $mres -sn_thresholds 5,$snhigh $scampopts \
                    $inldac"
                    #-mergedoutcat_type FITS_LDAC -fulloutcat_type FITS_LDAC \

                test ! "$AI_DEBUG" && cmd="$cmd -verbose_type quiet -checkplot_type NONE"
                test "$AI_DEBUG" && echo $cmd
                eval "$cmd" 2>/dev/null
                test $? -ne 0 &&
                    echo "ERROR: scamp terminated with error (num=$num)." >&2 &&
                    return 255

                test ! -f  ${inldac/.fits/.head} &&
                    echo "ERROR: ${inldac/.fits/.head} not found." >&2 &&
                    return 255

                # extract scamp fitting data from scamp.xml
                line=$(stilts tpipe ofmt=text scamp.xml cmd=transpose | \
                awk 'BEGIN{nsrc=0;nmatch=0;nhigh=0;dm=0}{
                        if($2=="NDetect")               nsrc=$4
                        if($2=="NDeg_Reference")        nmatch=$4
                        if($2=="NDeg_Reference_HighSN") nhigh=$4
                        if($2=="ZeroPoint_Corr")        dm=$4
                    }END{
                        printf("%d %d %d %.3f", nsrc, nmatch, nhigh, dm)
                    }')
                nsrc=$(echo $line | awk '{print $1}')
                nmatch=$(echo $line | awk '{print $2}')
                nhigh=$(echo $line | awk '{print $3}')
            
                # TODO: check number of detections
                #   if below threshold then try with large posmaxerr/anglemaxerr
                #   if still below match try with rot180 and small posmaxerr/anglemaxerr
                #   if still below match try with rot180 and large posmaxerr/anglemaxerr
                has_poor_match=$(echo $nsrc $nmatch | awk '{r=$2/$1; x=1
                    if ($1>500 && r>0.18) x=""
                    if ($1>200 && r>0.20) x=""
                    if ($1>100 && r>0.24) x=""
                    if ($1>50 && r>0.28) x=""
                    if ($1>30 && r>0.35) x=""
                    if ($1>14 && r>0.5) x=""
                    if ($1<=14 || $2<10) x=""
                    print x
                }')
                rot180=$has_poor_match
                if [ "$rot180" ]
                then
                    echo "WARNING: poor match ($nmatch/$nsrc), try rot180." >&2
                    cp ${inldac/.fits/.ahead} $tmp1
                    grep "^CD[12]_[12] " $tmp1 | \
                    sed -e 's/^CD1_1 /CDX_1 /; s/^CD2_2 /CD1_1 /; s/^CDX_1 /CD2_2 /' \
                    > ${inldac/.fits/.ahead}
                    
                    eval "$cmd" 2>/dev/null
                    test $? -ne 0 &&
                        echo "ERROR: scamp terminated with error (num=$num)." >&2 &&
                        return 255

                    test ! -f  ${inldac/.fits/.head} &&
                        echo "ERROR: ${inldac/.fits/.head} not found." >&2 &&
                        return 255

                    # extract scamp fitting data from scamp.xml
                    line=$(stilts tpipe ofmt=text scamp.xml cmd=transpose | \
                    awk 'BEGIN{nsrc=0;nmatch=0;nhigh=0;dm=0}{
                            if($2=="NDetect")               nsrc=$4
                            if($2=="NDeg_Reference")        nmatch=$4
                            if($2=="NDeg_Reference_HighSN") nhigh=$4
                            if($2=="ZeroPoint_Corr")        dm=$4
                        }END{
                            printf("%d %d %d %.3f", nsrc, nmatch, nhigh, dm)
                        }')
                    nsrc=$(echo $line | awk '{print $1}')
                    nmatch=$(echo $line | awk '{print $2}')
                    nhigh=$(echo $line | awk '{print $3}')                    
                fi
                
                # propagate some header keywords
                if [ -f $rdir/$num.hdr ]
                then
                    hdr2ahead $rdir/$num.hdr > ${acat%.*}.head
                else
                    filter="^OBJECT  =|^DATE-OBS=|^EXPTIME =|^EXPOSURE=|^JD      =|^MJD|^OBSERVAT=|^TELESCOP="
                    filter="$filter|^IMGROLL =|^PIERSIDE=|^PEDESTAL=|^BINNING =|^[XY]BINNING="
                    filter="$filter|^FILTER  =|^AIRMASS =|^ST      =|^RA      =|^DEC     ="
                    rfile=$(get_rawfile $num)
                    test -z "$rfile" &&
                        echo "ERROR: no entry for $num in $exifdat/$rawfilesdat." >&2 &&
                        continue
                    
                    if is_fitzip "$rfile"
                    then
                        unzip -p "$rfile" | listhead - | grep -E "$filter" > ${acat%.*}.head
                    else
                        if is_fits "$rfile"
                        then
                            imhead "$rfile" | grep -E "$filter" > ${acat%.*}.head
                        else
                            touch ${acat%.*}.head
                            # get texp jd from exifdat
                            set - $(test -e $exifdat && grep -v "^#" $exifdat | \
                                awk -v n=$num '{if($2==n){printf("%s", $0)}}' | head -1) x
                            if [ $# -ge 3 ]
                            then
                                texp=$4
                                set_header ${acat%.*}.head EXPTIME=$texp/"Exposure time in seconds"
                                x=$(ut2jd $3 $day | awk '{printf("%.5f", $1)}')
                                test ${3:0:1} -eq 0 && x=$(echo $x | awk '{printf("%.5f", $1+1)}')
                                set_header ${acat%.*}.head MJD_OBS=$x/"Time of observation in julian days"
                            else
                                # get texp jd from rawfilesdat
                                set - $(test -e $rawfilesdat && grep -v "^#" $rawfilesdat | \
                                    awk -v n=$num '{if($1==n){printf("%s", $0)}}' | head -1) x
                                set_header ${acat%.*}.head EXPTIME=$4/"Exposure time in seconds"
                                set_header ${acat%.*}.head MJD_OBS=$5/"Time of observation in julian days"                                
                            fi
                            x=$(echo $day | awk '{
                                    y=substr($1,1,2)
                                    m=substr($1,3,2)
                                    d=substr($1,5,2)
                                    printf("%.1f\n", 2000+y+((m-1)*30.4+d)/365)
                                }')
                            set_header ${acat%.*}.head EPOCH=$x/"Epoch"
                        fi
                    fi
                fi
                # reformat EXPTIME
                x=$(get_header -q ${acat%.*}.head EXPTIME)
                test "$x" && set_header ${acat%.*}.head EXPTIME=$(echo $x | awk '{printf("%.2f", 1*$1)}')
                # combine headers
                sed -i '/^END$/d' ${acat%.*}.head
                cat ${inldac/.fits/.head} >> ${acat%.*}.head
                rm -f ${inldac/.fits/.head} ${inldac/.fits/.ahead}
            fi

            # compute pixel offset and rotation angle from ${acat%.*}.head
            sx=$(grep "^CRVAL1" ${acat%.*}.head  | tr '=' ' ' | \
                awk -v p=$pscale '{printf("%.2f", (10-$2)/p)}')
            sy=$(grep "^CRVAL2" ${acat%.*}.head  | tr '=' ' ' | \
                awk -v p=$pscale '{printf("%.2f", $2/p)}')
            da=$(grep "^CD._" ${acat%.*}.head  | tr '=' ' ' | LANG=C sort | \
                awk '{print $2}' | tr '\n' ' ' | awk '{
                    pi=3.141592653
                    r1=180/pi*atan2($2, -$1)
                    r2=180/pi*atan2($3, $4)
                    printf("%.3f\n", (r1+r2)/2)
                }')
            
            sxsd=$(grep "^ASTRRMS1" ${acat%.*}.head  | tr '=' ' ' | \
                awk -v p=$pscale '{printf("%.2f", $2/p)}')
            sysd=$(grep "^ASTRRMS2" ${acat%.*}.head  | tr '=' ' ' | \
                awk -v p=$pscale '{printf("%.2f", $2/p)}')

            # determine a e fw, from a subset of measure/$num.src.dat
            set - $(sexselect -s $inldac "" $magerrlim $rmax $((w/2)),$((h/2)) \
                2>/dev/null | awk '{
                    if($1~/^#/) next
                    if($1~/^AWIN/) a=$2
                    if($1~/^BWIN/) e=a/$2
                    if($1~/^FWHM/) f=$2
                }END{printf("%.2f %.2f %.2f", a, e, f)}')
            a=$1
            e=$2
            fw=$3
            
            # determine mag offset from bright sources
            #test $num == "0001" && echo sexselect $inldac "" "" $rmax ";" $xyref && return 1
            sexselect $inldac "" "" $rmax | LANG=C sort -n -k7,7 | \
                grep -v "^#" | (head -$nbright; dd of=/dev/null status=none) > $xydat
            x=$(tail -1 $xydat | awk -v m=0.1 '{printf("%.2f", m+$7)}')
            sexselect $inldac $x "" $rmax | LANG=C sort -n -k7,7 | \
                grep -v "^#" > $xydat

            echo "" > $tmp1
            xymatch $xydat $xyref 2 $sx $sy $da $w $h | grep -v "^#" | \
                (head -250; dd of=/dev/null status=none) > $tmp1
            nmag=$(cat $tmp1 | wc -l | awk '{printf("%d", $1*0.6)}')
            cat $tmp1 | while read id x x x x x x x idref
            do
                mref=$(grep "^[ ]*$idref " $xyref | awk '{print $7}')
                mm=$(grep "^[ ]*$id " $xydat | awk -v mref=$mref '{printf("%.2f", (mref+$7)/2)}')
                dm=$(grep "^[ ]*$id " $xydat | awk -v mref=$mref '{printf("%.2f", mref-$7)}')
                LANG=C printf "%6s %6s  %5.2f  %5.2f\n" $idref $id $mm $dm
            done | sort -n -k3,3 | (head -$nmag; dd of=/dev/null status=none) > $tmp2
            if [ $nmag -lt 5 ]
            then
                dm=-2
                dmsd=99
            else
                set - $(kappasigma $tmp2 4)
                dm=$(echo $1 | awk '{printf("%.3f", $1)}')
                dmsd=$(echo $2 | awk '{printf("%.3f", $1)}')
            fi

            # na, dasd are undefined/unset (0)
            test "$rot180" && da=$(echo "$da + 180" | bc)
            line=$(printf "%s %s %4d %4d" $num $nref $nsrc $nhigh
            printf " %s %s %s %4d %3d" $a $e $fw $nmatch $nmag
            LANG=C printf " %6.3f %6.2f %6.2f 0 %6.3f" $dm $sx $sy $da
            printf " %s %s %s 0\n" $dmsd $sxsd $sysd)
            test $nsrc -lt 0 && echo "$line" >&2 # set already processed
            test $nsrc -ge 0 && echo "$line"
            test "$AI_DEBUG" || rm $inldac
        done
        test "$AI_DEBUG" || rm $refldac
        test "$AI_DEBUG" && echo "refldac=$refldac; inldac=$inldac" >&2
    done < $sdat
    test "$singleimage" && rm $sdat
    test "$AI_DEBUG" || rm -f $conf $wcscat $ahead $tmp1 $tmp2 $xydat $xyref
    test "$AI_DEBUG" && echo "xydat=$xydat; xyref=$xyref" >&2
    return 0
}


# simplified AIccd/AIsource/crossmatch(part)/AIplot procedure to estimate
# best focus from a set of images in current directory
# TODO: check directories . $AI_TMPDIR, $AI_RAWDIR for images and hdr files
AIfocus () {
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1

    local nmin=$1
    local nmax=$2
    local threshold=${3:-5}     # detection threshold (sextractor)
    local rlim=${4:-1200}       # limit stars to center distance < rlim
    local ex=${AI_EXCLUDE:-""}  # space separated list of image numbers
    local magzero=${AI_MAGZERO:-"25.5"}
    local tdir="/tmp"
    local raw
    local hdr
    local xy
    local dlim=""
    local magerrlim=0.03
    local i
    local texp
    local mag0
    local tmp1=$(mktemp "/tmp/tmp_src_$$.XXXXXX")
    local tmp2=$(mktemp "/tmp/tmp_ptsrc_$$.XXXXXX")

    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: AIfocus <nmin> <nmax> [thres|$threshold] [rlim|$rlim]" >&2 &&
        return 1

    rm -f focus.dat
    for i in $(seq $nmin $nmax)
    do
        num=$(echo $i | awk '{printf("%04d", $1)}')
        echo $ex | grep -q -w $num - && echo "excluding image $num." >&2 && continue
        raw=""
        raw=$(get_imfilename $num)
        test -z "$raw" && echo "WARNING: raw file for $num not found." >&2 && continue

        # get image width and height, determine dlim
        if [ -z "$dlim" ]
        then
            w=$(dcraw-tl -i -v $raw | grep "Output size:" | awk '{print $3}')
            h=$(dcraw-tl -i -v $raw | grep "Output size:" | awk '{print $5}')
            dlim=$(echo $w $h $rlim | awk '{printf("%.2f", 2*$3/sqrt($1*$1+$2*$2))}')
            echo "# image ${w}x${h}, using dlim=$dlim" >&2
        fi
        
        # get xy offset for use in AI_DCRAWPARAM
        if [ $((2*rlim)) -lt $w ] && [ $((2*rlim)) -lt $h ]
        then
            xy=$(echo $w $h $rlim | awk '{x=$1/2-$3; y=$2/2-$3; printf("%d %d", x, y)}')
            AI_DCRAWPARAM="-R $((2*rlim)) $((2*rlim)) $xy"
        fi

        # source extraction
        if [ -f $num.src.dat ]
        then
            echo -n "$num (existing $num.src.dat) " >&2
        else
            # raw to fits
            echo -n "$num " >&2
            AIraw2rgb -q 0 $raw | gm convert - -channel Green - | \
                pnmtomef - > $tdir/$num.fits

            # try to read exposure time from exif data
            texp=""     # exposure time in sec
            texp=$(exiv2 -g Exif.Photo.ExposureTime $raw | awk '{print $4}')
            test -z "$texp" && texp=1
            mag0=$(echo $magzero $texp 1 | awk '{
                printf("%.2f\n", $1+2.5/log(10)*log($2/$3))}')
            
            # source extraction
            AI_MAGZERO=$mag0 AIsource -q $tdir/$num.fits "" $threshold 2>/dev/null
            test $? -ne 0 &&
                echo "ERROR: AIsource failed." >&2 && return 255
        fi
    
        # get stats from point sources in center region
        sexselect $num.src.dat "" $magerrlim 2>/dev/null | awk -v amin=0.4 '{
                if($1~/^#/) next
                if($4<amin) next  # cosmic or hot pixel
                print $0
            }' > $tmp1
        n=$(cat $tmp1 | wc -l)
        test $n -lt 8 &&
            echo "WARNING: $num too few stars (n=$n)" >&2 && continue
            
        a=$(kappasigma $tmp1 4 | awk '{printf("%.2f", $1)}')
        e=$(kappasigma $tmp1 5 | awk '{printf("%.2f", $1)}')
        fwhm=$(kappasigma $tmp1 6 | awk '{printf("%.2f", $1)}')
        m=$(kappasigma $tmp1 7 | awk '{printf("%.2f", $1)}')
        
        false && (set - $(sexselect -s $num.src.dat "" $magerrlim \
            2>/dev/null | awk '{
                if($1~/^#/) next
                if($1~/^AWIN/) a=$2
                if($1~/^BWIN/) e=a/$2
                if($1~/^FWHM/) {f=$2; n=$7}
                if($1~/^MAG/)  m=$2
            }END{printf("%d %.2f %.2f %.2f %.2f", n, a, e, f, m)}')
        n=$1
        a=$2
        e=$3
        fwhm=$4
        m=$5)
        
        # try to find hdr file
        hdr=""
        for d in . $AI_TMPDIR $AI_RAWDIR
        do
            test -z "$hdr" && test -f $d/$num.hdr && hdr=$d/$num.hdr
            test -z "$hdr" && test -f $d/IMG_$num.hdr && hdr=$d/IMG_$num.hdr
        done

        # get focus value from comment in hdr file
        test "$hdr" &&
            f=$(grep "^comment" $hdr | cut -d '=' -f2- | tr -d '=' | \
                tr ' ,;/' '\n' | grep -E "^f[0-9]+$" | cut -c 2-)
        test -z "$f" && f=$num
        echo $f $n $fwhm $e $m >&2
        echo $num $f $n $fwhm $e $m >> focus.dat
    done
    rm -f $tmp1 $tmp2
    # TODO: handle 100
    AIplot -p -t "fwhm(f)" focus.dat 2 4
}


# sky background estimation
AIbg () {
    AIcheck_ok || return 255
    local showhelp
    local i
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1

    local img=${1:-""}
    local bsize=${2:-20}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local nx=5
    local ny=5
    local w
    local h
    local channel=1
    local geom
    local geomlist
    local j
    local x0
    local y0
    local tmp1=$(mktemp "/tmp/tmp_bg_val_$$.XXXXXX")
    local tmp2=$(mktemp "/tmp/tmp_bg_med_$$.XXXXXX")

    test "$showhelp" &&
        echo "usage: AIbg [img] [bsize|$bsize]" >&2 &&
        return 1

    is_ppm $img && channel=2
    
    # build list of regions
    w=$(identify $img | cut -d " " -f3 | cut -d "x" -f1)
    h=$(identify $img | cut -d " " -f3 | cut -d "x" -f2)
    for j in $(seq 1 $ny)
    do
        y0=$(echo $j $ny $h $bsize | awk '{
            x=(0.2+0.6*($1-1)/($2-1))*$3 - $4/2
            printf("%d", x)}')
        for i in $(seq 1 $nx)
        do
            x0=$(echo $i $nx $w $bsize | awk '{
                x=(0.2+0.6*($1-1)/($2-1))*$3 - $4/2
                printf("%d", x)}')
            AIval $img $bsize $bsize $x0 $y0 | kappasigma - $channel >> $tmp1
        done
    done
    cat $tmp1 | sort -nr -k2,2 > $tmp2
    tail -$((nx*ny*40/100)) $tmp2 | head -1
    rm -f $tmp1
    test "$AI_DEBUG" && echo $tmp2 >&2
    test -z "$AI_DEBUG" && rm $tmp2
}


# determine sky background diffs of images within set
# output (small) PPM images to directory bgvar
AIbgdiff () {
    AIcheck_ok || return 255
    local showhelp
    local do_bayer          # if set then operate separately on each bayer grid
                            # color
    local do_keepdiff       # if set then the bg mesh of diff image is kept
    local do_use_nref       # use nref instead of mean image (default until v2.2.2)
    local do_all_mean       # include images which have a bad region mask when
                            # creating mean image
    local do_plane          # fit diff image by plane instead of surface
    local nmax=11           # max. number of images to use
    local i
    for i in 1 2 3 4 5 6
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-b" && do_bayer=1 && shift 1
        test "$1" == "-k" && do_keepdiff=1 && shift 1
        test "$1" == "-r" && do_use_nref=1 && shift 1
        test "$1" == "-a" && do_all_mean=1 && shift 1
        test "$1" == "-p" && do_plane=1 && shift 1
        test "$1" == "-n" && nmax=$2 && shift 2
    done
    local setname=${1:-""}
    local bsize=${2:-"128"}
    local bgzero=${3:-"10000"}
    local diffdir=${4:-"bgvar"}
    local sfitdat="bgsfit.dat"
    local sdat=${AI_SETS:-"set.dat"}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local ccdregion=${AI_CCDREGION:-"10000 10000 0 0"}
    local imlist=$(mktemp "$tdir/tmp_imlist_XXXXXX.dat")
    local imlist2=$(mktemp "$tdir/tmp_imlist2_XXXXXX.dat")
    local diff=$(mktemp "$tdir/tmp_im1_$$.XXXXXX.pnm")
    local tmpim=$(mktemp "$tdir/tmp_im2_$$.XXXXXX.pnm")
    local tmpref=$(mktemp "$tdir/tmp_ref_$$.XXXXXX.pnm")
    local tmpdat=$(mktemp "$tdir/tmp_txt1_$$.XXXXXX.dat")
    local sname
    local type
    local nref
    local w
    local h
    local b
    local n
    local inext
    local nlist
    local has_bgdiff
    local num
    local fname
    local ref
    local bgm
    local nbad
    local filter

    test "$showhelp" &&
        echo "usage: AIbgdiff [-b] [-k] [-r|-a] [-n nmax|$nmax] [-p] [set] [bsize|$bsize] [bgzero|$bgzero] [diffdir|$diffdir]" >&2 &&
        return 1
    test -d "$diffdir" || mkdir "$diffdir"

    if [ "$AI_DEBUG" ]
    then
        echo "WARNING: DEBUG mode - no diff stats are written to output files !" >&2 &&
        sleep 5 && echo "" >&2
    else
        test -f "$sfitdat" && echo "WARNING: appending sfit data to $sfitdat." >&2
    fi
    
    while read ltime sname target type texp n1 n2 nref dark flat x
    do
        (echo "$ltime" | grep -q "^#") && continue
        test "$type" != "o" && continue
        test "$setname" && test "$setname" != "$sname" && continue
        (! is_integer "$n1" || ! is_integer "$n2" || ! is_integer "$nref") && continue

        inext=""
        test -f $tdir/$nref.pgm && inext="pgm"
        test -f $tdir/$nref.ppm && inext="ppm"
        test -z "$inext" &&
            echo "ERROR: set $sname has no ref image $nref.{pgm,ppm}." >&2 && continue

        if [ "$do_bayer" ]
        then
            AIimlist $sname "" pgm > $imlist
        else
            AIimlist $sname > $imlist
        fi
        n=0; nlist=""; has_bgdiff=""
        while read x num fname ref x
        do
            test -f $diffdir/$num.bgdiff.$inext && has_bgdiff=1 && continue
            n=$(($n + 1)) && nlist="$nlist $num"
        done < $imlist
        test "$has_bgdiff" && echo "WARNING: some bgdiff images do already exist." >&2
        test $n -eq 0 && echo "WARNING: skipping set $sname" >&2 && continue
        echo "processing $n images in set $sname ..." >&2

        # determine background of reference image
        if [ "$do_bayer" ]
        then
            if [ "$do_use_nref" ]
            then
                AIbsplit $tdir/$nref.pgm
                rgb3toppm $nref.r1.pgm $nref.g1.pgm $nref.b1.pgm > $tmpref
                rm $nref.[rgb][12].pgm
            else
                # skip images with associated mask bgvar/$num.bad.*
                nbad=$(cd bgvar && ls [0-9][0-9][0-9][0-9].bad.* | cut -d '.' -f1)
                grep -Ewv "$(echo $nbad | tr ' ' '|')" $imlist > $imlist2
                n=$(cat $imlist2 | wc -l)
                test $n -le 9 && echo "create mean of $n images ..." >&2
                test $n -gt 9 && echo "create mean using 9 out of $n images ..." >&2
                pnmcombine $(cut -d " " -f3 $imlist2 | head -$((n-(n-9)/2)) | tail -9) $tmpim
                AIbsplit $tmpim
                b=$(basename ${tmpim%.*})
                rgb3toppm $b.r1.pgm $b.g1.pgm $b.b1.pgm > $tmpref
                rm $b.[rgb][12].pgm
            fi
        else
            if [ "$do_use_nref" ]
            then
                cp $tdir/$nref.$inext $tmpref
            else
                # skip images with associated bad region mask bgvar/$num.bad.*
                if [ -z "$do_all_mean" ] && ls bgvar/[0-9][0-9][0-9][0-9].bad.* > /dev/null 2>&1
                then
                    filter=""
                    nbad=$(cd bgvar && ls [0-9][0-9][0-9][0-9].bad.* | cut -d '.' -f1)
                    AI_EXCLUDE="$AI_EXCLUDE $nbad" AIimlist -q $sname > $imlist2
                else
                    cp $imlist $imlist2
                fi
                n=$(cat $imlist2 | wc -l)
                test $n -le 9 && echo "create mean of $n images ..." >&2
                test $n -gt 9 && echo "create mean using 9 out of $n images ..." >&2
                pnmcombine $(cut -d " " -f3 $imlist2 | head -$((n-(n-9)/2)) | tail -9) $tmpref
                test $? -ne 0 &&
                    echo "ERROR: pnmcombine failed." >&2 && continue
            fi
        fi
        AIbgmap -q -m $tmpref $bsize 1
        test $? -ne 0 &&
            echo "Failed command: AIbgmap -q -m $tmpref $bsize 1" >&2 && return 255
        b=$(basename ${tmpref%.*})
        case $inext in
            ppm)    bgrgb=$(imcrop -1 $b.bgm1.$inext 80 | AImstat - | awk '{
                    printf("%.1f %.1f %.1f", $5, $9, $13)}');;
            pgm)    bgrgb=$(imcrop -1 $b.bgm1.$inext 80 | AImstat - | awk '{
                    printf("%.1f", $5)}');;
        esac
        rm $b.bgm1.$inext
        echo "bgref = $bgrgb" >&2
        test $n -eq 1 &&
            echo "WARNING: single image, no diffs" >&2 &&
            echo "$nref.$inext $nref $bgzero $bgzero $bgzero (0.0) ${bgrgb//,/ }" &&
            continue

        
        # create small bgdiff images
        while read x num fname x
        do
            test "$do_use_nref" && test $num -eq $nref && continue
            test -f $diffdir/$num.bgdiff.$inext &&
                echo "$num (reusing $num.bgdiff.$inext)" >&2 &&
                continue

            echo -n "$num " >&2
            if [ "$do_bayer" ]
            then
                AIbsplit $fname
                rgb3toppm $num.r1.pgm $num.g1.pgm $num.b1.pgm | \
                    pnmccdred -a $bgzero -d $tmpref - $diff
                rm $num.[rgb][12].pgm
            else
                pnmccdred -a $bgzero -d $tmpref $fname $diff
            fi
            AIbgmap -q -m $diff $bsize 1
            test $? -ne 0 &&
                echo "Failed command: AIbgmap -q -m $diff $bsize 1" && return 255
            bgm=$(basename ${diff/.pnm/.bgm1.$inext})
            test "$do_keepdiff" && cp $bgm $diffdir/$num.bgm1.$inext
            w=$(gm identify $bgm | cut -d " " -f3 | cut -d "x" -f1)
            h=$(gm identify $bgm | cut -d " " -f3 | cut -d "x" -f2)
            #echo "$bgm  $w  $h" >&2
            if [ -f $diffdir/$num.bad.png ]
            then
                ! is_mask $diffdir/$num.bad.png white &&
                    echo "ERROR: $diffdir/$num.bad.png is not a valid mask (white on black)." >&2 &&
                    continue
                
                if [ -f $diffdir/$nref.bad.png ] && [ 1 -eq 0 ] # disabled in v2.2.3
                then
                    gm composite -compose plus $diffdir/$nref.bad.png $diffdir/$num.bad.png - | \
                        gm convert - -resize ${w}x${h}\! \
                        -threshold 10% -depth 16 -negate $inext:- | \
                        pnmarith -min $bgm - > $tmpim
                    test $? -ne 0 && return 255
                else
                    gm convert $diffdir/$num.bad.png -resize ${w}x${h}\! \
                        -threshold 10% -negate -depth 16 $inext:- | \
                        pnmarith -min $bgm - > $tmpim
                    test $? -ne 0 && return 255
                fi
            else
                if [ -f $diffdir/$num.bad.reg ]
                then
                    reg2pbm $tmpref $diffdir/$num.bad.reg | \
                    gm convert - -resize ${w}x${h}\! \
                        -threshold 10% -negate -depth 16 $inext:- | \
                        pnmarith -min $bgm - > $tmpim
                    test $? -ne 0 && return 255
                else
                    if [ -f $diffdir/$nref.bad.png ] && [ 1 -eq 0 ] # disabled in v2.2.3
                    then
                        gm convert $diffdir/$nref.bad.png -resize ${w}x${h}\! \
                            -threshold 10% -negate -depth 16 $inext:- | \
                            pnmarith -min $bgm - > $tmpim
                        test $? -ne 0 && return 255
                    else
                        cp $bgm $tmpim
                    fi
                fi
            fi
            if [ "$AI_DEBUG" ]
            then
                mv $tmpim ${tmpim/im2/$num}
            else
                # surface fit, print coeffs to $sfitdat and partly to stderr
                if [ "$do_plane" ]
                then
                    AIsfit -p $tmpim > $diffdir/$num.bgdiff.$inext 2> $tmpdat
                else
                    AIsfit $tmpim > $diffdir/$num.bgdiff.$inext 2> $tmpdat
                fi
                test $? -ne 0 &&
                    echo "ERROR during: AIsfit $tmpim" >&2 &&
                    rm -f $diffdir/$num.bgdiff.$inext \
                          $(basename ${diff/.pnm/.bgm1.$inext}) \
                          $tmpdat $diff &&
                    return 255
                x=1
                test "$inext" == "ppm" && x=2
                grep "^$x " $tmpdat >&2
                cat $tmpdat | awk -v n=$num '{print n" "$0}' >> $sfitdat 
            fi
        done < $imlist
        test "$AI_DEBUG" && echo "nref=$nref  wxh=${w}x${h}  bgzero=$bgzero" >&2

        # get stats from bgdiff images
        test "$AI_DEBUG" || while read x num fname x
        do
            test "$do_use_nref" && test $num -eq $nref && test "$inext" == "ppm" &&
                echo "$num.xxxxxx.$inext $num $bgzero $bgzero $bgzero (0.0) $bgzero $bgzero $bgzero (0.0)" \
                    "$bgzero $bgzero $bgzero (0.0)" $bgrgb &&
                continue
            test "$do_use_nref" && test $num -eq $nref && test "$inext" == "pgm" &&
                echo "$num.xxxxxx.$inext $num $bgzero $bgzero $bgzero (0.0)" $bgrgb &&
                continue
            test ! -f $diffdir/$num.bgdiff.$inext &&
                echo "ERROR: $diffdir/$num.bgdiff.$inext does not exist." >&2 &&
                continue
            imcrop $diffdir/$num.bgdiff.$inext 70 > $tmpim
            AIstat $tmpim | awk -v img=$num.bgdiff.$inext -v num=$num -v bgrgb="$bgrgb" -v z=$bgzero '{
                n=split(bgrgb, bg)
                skip=length($1)+length($2)+3
                if (n>1) {
                    printf("%s %s %s %.1f %.1f %.1f\n", img, num, substr($0,skip), $5+bg[1]-z,
                        $9+bg[2]-z, $13+bg[3]-z)
                } else {
                    printf("%s %s %s %.1f\n", img, num, substr($0,skip), $5+bg[1]-z)
                }}'
            #rm -f $(basename ${diff/.$inext/.bg$bsize.$inext}) $bgm $tmpim $tmpdat $diff
        done < $imlist
        rm -f $tmpref $tmpim $tmpdat $diff
        rm -f $bgm
    done < $sdat
    rm -f $imlist $imlist2
}


# extract smoothed background map using sextractor
AIbgmap () {
    local showhelp
    local quiet     # if set suppress messages from sextractor
    local do_fitsurface
    local do_fitplane
    local do_minibg_only
    local do_stats_only # ignore all image creation
    local do_diag   # additionally create normalized bg image and residual image
    local bgmsub    # if given, subtract it before fitting data, intensities
                    # are assumed to be scaled by mult
    local maxbad=60 # max. percent of bad pixel to exclude from bg
    local show_bg_stddev
    for i in $(seq 1 10)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-q" && quiet=1 && shift 1
        test "$1" == "-p" && do_fitplane=1 && shift 1
        test "$1" == "-s" && do_fitsurface=1 && shift 1
        test "$1" == "-m" && do_minibg_only=1 && shift 1
        test "$1" == "-d" && do_diag=1 && shift 1
        test "$1" == "-b" && bgmsub=$2 && shift 2
        test "$1" == "-sd" && show_bg_stddev=1 && shift 1
        test "$1" == "-x" && maxbad=$2 && shift 2
        test "$1" == "-stats" && do_stats_only=1 && shift 1
    done
    local img=${1:-""}
    local bsize=${2:-256}   # background area size (default in sex: 128)
    local msize=${3:-3}     # background mesh size = median points (default: 3)
    local weightmap=${4:-""}   # weight map, pgm or png, black = bad background
    local mult=${5:-1}      # intensity multiplier
    local tdir=${AI_TMPDIR:-"/tmp"}
    local conf=$(mktemp "$tdir/tmp_conf_XXXXXX.dat")
    local tmpxml=$(mktemp "$tdir/tmp_sex_XXXXXX.xml")
    local tmpmask=$(mktemp "$tdir/tmp_mask_XXXXXX.pbm")
    local tmp1=$(mktemp "$tdir/tmp_tmp1_XXXXXX.pnm")
    local tmpnofit=$(mktemp "$tdir/tmp_tmpnofit_XXXXXX.pnm")
    local tmpbg=$(mktemp "$tdir/tmp_tmpbg_XXXXXX.pnm")

    local out
    local outsmall
    local f
    local b
    local c
    local clist
    local inext="ppm"
    local param="-filter N -detect_thresh 100 -write_xml Y"
    local fields=$tdir/sex.$$.fields
    local wfits=$tdir/weight.$$.fits
    local rgb
    local mrgb
    local ampl
    local bgsd
    local size

    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: AIbgmap [-q] [-p|s] [-m] [-d] [-sd] [-x maxbad|$maxbad]" \
            "[-b bgmsubimg] <img> [bsize|$bsize] [msize|$msize] [bgmask] [mult|$mult]" >&2 &&
        return 1

    for f in $img $bgmsub $weightmap
    do
        test ! -f $f && echo "ERROR: file $f does not exist." >&2 && return 255
    done

    # TODO: check img is either ppm or pgm
    
    if [ "$weightmap" ]
    then
        # convert bad bg region to mask
        if is_reg $weightmap
        then
            reg2pbm $img $weightmap | gm convert - -negate $tmpmask
            test $(identify -format "%k" $tmpmask) -eq 1 &&
                echo "WARNING: empty regions file $weightmap." >&2 &&
                weightmap=""
            test "$weightmap" && weightmap=$tmpmask
        else
            # ignore bgmask if it is of uniform color
            test $(identify -format "%k" $weightmap) -eq 1 &&
                echo "WARNING: weightmap $weightmap has constant value." >&2 &&
                weightmap=""
        fi

        # check if mask is black/white only
        test "$weightmap" && ! is_mask $weightmap black $maxbad && return 255
    fi
    
    echo XWIN_IMAGE YWIN_IMAGE | tr ' ' '\n' > $fields
    test "$quiet" && param="$param -verbose_type quiet"
    # TODO: sex does not work with weightmap
    #test "$weightmap" &&
    #    pnmtomef $weightmap > $wfits &&
    #    param="$param -weight_type map_weight -weight_image $wfits"

    
    # abbreviations
    b=$(basename ${img%\.*})
    is_pgm $img && inext="pgm"
    out="$b.bg.$inext"
    outsmall="$b.bgm$mult.$inext"
    #day=$(basename $(dirname $img))
    #test "$day" && test "$day" != "." && out="$day.$b.bg$bsize.ppm"

    if [ ! "$do_stats_only" ]
    then
        # convert pnm to fits
        # note: if noise in $img is low (<~3) then background image from sex and
        #   the residual image will show staircase structure, independant of $mult
        #   maybe we should add some random noise proportional to $mult
        case $inext in
            ppm)    clist="red grn blu"
                    cat $img | (cd $tdir; ppmtorgb3)
                    for c in $clist
                    do
                        pnmccdred -m $mult $tdir/noname.$c - | pnmtomef - > $tdir/$b.$c.fits
                        rm $tdir/noname.$c
                    done
                    ;;
            pgm)    clist="gray"
                    pnmccdred -m $mult $img - | pnmtomef - > $tdir/$b.$clist.fits
                    ;;
        esac
        
        # create background map
        test "$quiet" || echo "creating $out and $outsmall ..." >&2
        sex -d > $conf
        for c in $clist
        do
            sex -c $conf -xml_name $tmpxml -parameters_name $fields \
                $param -back_size $bsize -back_filtersize $msize \
                -checkimage_type "background minibackground" \
                -checkimage_name "$tdir/bg.$b.$c.fits $tdir/bgm.$b.$c.fits" \
                $tdir/$b.$c.fits
            #test ! "$do_minibg_only" && convert $tdir/bg.$b.$c.fits pgm: > $tdir/bg.$b.$c.pgm
            #convert $tdir/bgm.$b.$c.fits pgm: > $tdir/bgm.$b.$c.pgm
            test ! "$do_minibg_only" && meftopnm $tdir/bg.$b.$c.fits > $tdir/bg.$b.$c.pgm
            meftopnm $tdir/bgm.$b.$c.fits > $tdir/bgm.$b.$c.pgm
            rm $tdir/$b.$c.fits $tdir/bg.$b.$c.fits $tdir/bgm.$b.$c.fits
            
            # bg stddev
            test "$bgsd" && bgsd=$bgsd","
            bgsd="$bgsd"$(stilts tpipe ofmt=text $tmpxml cmd=transpose | \
                grep -w Background_StDev | awk '{printf("%.1f", $4)}')
            rm -f $tmpxml
        done
        case $inext in
            ppm)    test ! "$do_minibg_only" && rgb3toppm $tdir/bg.$b.red.pgm $tdir/bg.$b.grn.pgm $tdir/bg.$b.blu.pgm \
                        > $out
                    rgb3toppm $tdir/bgm.$b.red.pgm $tdir/bgm.$b.grn.pgm $tdir/bgm.$b.blu.pgm \
                        > $outsmall
                    rm -f $tdir/bg.$b.red.pgm $tdir/bg.$b.grn.pgm $tdir/bg.$b.blu.pgm
                    rm -f $tdir/bgm.$b.red.pgm $tdir/bgm.$b.grn.pgm $tdir/bgm.$b.blu.pgm
                    ;;
            pgm)    test ! "$do_minibg_only" && mv $tdir/bg.$b.$clist.pgm $out
                    mv $tdir/bgm.$b.$clist.pgm $outsmall
                    ;;
        esac
        rm -f test.cat $conf $fields
        
        # optionally apply fit to create smoothed background map
        if [ "$do_fitplane" ] || [ "$do_fitsurface" ]
        then
            test "$do_fitplane" && echo "fitting plane surface to background ..." >&2
            test "$do_fitsurface" && echo "fitting parabolic surface to background ..." >&2
            cp $outsmall $tmpnofit
            # subtract user-provided bg model image first
            if [ "$bgmsub" ]
            then
                gm convert "$bgmsub" -scale $(gm identify $outsmall | cut -d ' ' -f3)\! $tmpbg
                pnmccdred -a 1000 -d $tmpbg $tmpnofit $outsmall
            fi

            param=""; test "$do_fitplane" && param="-p"
            if [ "$weightmap" ]
            then
                gm convert $weightmap -scale $(gm identify $outsmall | cut -d ' ' -f3)\! \
                    -depth 1 pbm:- | pnmarith -mul $outsmall - > $tmp1 2>/dev/null
            else
                cp $outsmall $tmp1
            fi
            
            test "$AI_DEBUG" &&
                echo "AIsfit $param $tmp1" >&2
            AIsfit $param $tmp1 > $outsmall
            test $? -ne 0 &&
                echo "ERROR: AIsfit failed" >&2 &&
                return 255
            ! is_pnm $outsmall &&
                echo "ERROR: invalid image $outsmall created by AIsfit" >&2 &&
                return 255
            if [ "$bgmsub" ]
            then
                pnmarith -add $outsmall $tmpbg | pnmccdred -a -1000 - $tmp1
                mv $tmp1 $outsmall
            fi
            test ! "$do_minibg_only" &&
                gm convert $outsmall -resize $(gm identify $img | cut -d ' ' -f3)\! $out
            # optionally create residual image
            test "$do_diag" &&
                pnmccdred -a 1000 -d $outsmall $tmpnofit $b.bgm${mult}res.$inext
        fi
    fi

    # optionally create normalized $outsmall and show some statistics
    if [ "$do_diag" ] || [ "$do_stats_only" ]
    then
        # statistics using masked outsmall
        if [ "$weightmap" ]
        then
            gm convert $weightmap -scale $(gm identify $outsmall | cut -d ' ' -f3)\! \
                -depth 1 pbm:- | pnmarith -mul $outsmall - 2>/dev/null | AIval -a - | \
                grep -v -w 0 > $tmp1
            rgb=$(median $tmp1 1)
            test $(head -1 $tmp1 | wc -w) -eq 3 &&
                rgb=$rgb","$(median $tmp1 2)","$(median $tmp1 3)
        else
            rgb=$(AIstat $outsmall | awk '{
                if(NF>8) {printf("%.0f,%.0f,%.0f", $5, $9, $13)} else {printf("%f", $5)}}')
        fi
        false && ampl=$(imcrop -1 $outsmall 85 | AImstat - | awk -v rgb=$rgb '{
            if(NF>8) {
                split(rgb,mn,",")
                x=($8-$7)/mn[2]
            } else {
                x=($4-$3)/rgb
            }
            printf("%.1f", x*100)}')

        size=$(imsize $outsmall)
        ampl=$(AIval -c -a $outsmall | awk -v w=${size% *} -v h=${size#* } 'BEGIN{
            rmax=w/2; if (h<w) rmax=h/2
            gmin=2^16; gmax=0; gsum=0; gnum=0
        }{
            if (NF==5) {col=4} else {col=3}
            dx=$1-(w/2-0.5)
            dy=$2-(h/2-0.5)
            r=sqrt(dx*dx+dy*dy)
            if(r<rmax) {
                gnum=gnum+1
                gsum=gsum+$col
                if ($col < gmin) gmin=$col
                if ($col > gmax) gmax=$col
                #printf("%s %.1f %d %d\n", $0, r, gmin, gmax)
            }
        }END{
            printf("%.1f\n", 1.2*100*(gmax-gmin)/gsum*gnum)
        }')
        echo "$outsmall:  ampl=$ampl%  rgb*$mult=$rgb"

    fi
    if [ "$do_diag" ] && [ ! "$do_stats_only" ]
    then
        # create normalized bg image
        mrgb=$(echo $rgb | awk -F ',' '{x=10000; if(NF>1) {
            printf("%f,%f,%f", x/$1, x/$2, x/$3)} else {printf("%f", x/$1)}}')
        pnmccdred -m $mrgb $outsmall $b.bgm${mult}n.$inext
    fi
    
    test "$show_bg_stddev" && echo "$bgsd"
    test !"$AI_DEBUG" && rm -f $tmp1 $wfits $tmpnofit $tmpbg $tmpmask
    return 0
}


# fit astrometric solution to a PPM image using a reference catalog (FITS table)
# if the reference catalog is not provided it will be queried from vizier
# database and stored on disk (<set|img>.<refcat>.cat)
# result: WCS FITS image header (<set|img>.wcs.head)
# TODO: using an existing image filename for setname is NOT tested!
#       currently only green channel is fitted, how about color dependant fits
AIwcs () {
    local showhelp
    local plotdev="PNG" # checkplot_dev parameter of scamp (e.g. SVG, NULL)
    local nosex         # if set use $set.src.dat
    local nocatquery    # if set use $set.<refcat>.cat
    local maskreg       # if set then use this region mask to limit image sources
    local maxoff        # max position offset in degrees
    local fitdegrees=3  # degree of polynomial fit of image distortions (<=10)
    local sopts         # additional options passed to scamp
    local noescapes     # strip formatting escape sequences from scamp output
    local quiet         # suppress most of scamps output
    local north         # user defined north position angle (up=0, left=90)
                        # default is using value AI_NPA or entry in camera.dat
    local binning       # detector pixel binning
    local ra            # approx. image center
    local de
    local i
    for i in $(seq 1 13)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-p" && plotdev=$2 && shift 2
        test "$1" == "-s" && nosex=1 && shift 1
        test "$1" == "-r" && nocatquery=1 && shift 1
        test "$1" == "-f" && noescapes=1 && shift 1
        test "$1" == "-q" && quiet=1 && shift 1
        test "$1" == "-o" && maxoff=$2 && shift 2
        test "$1" == "-d" && fitdegrees=$2 && shift 2
        test "$1" == "-n" && north=$2 && shift 2
        test "$1" == "-b" && binning=$2 && shift 2
        test "$1" == "-c" && ra="$2" && de="$3" && shift 3
        test "$1" == "-x" && sopts="$2" && shift 2
        test "$1" == "-m" && maskreg="$2" && shift 2
    done
    local setname=${1:-""}
    local refcat=${2:-""}       # e.g. USNO-B1, 2MASS
    local maglim=${3:-"99"}     # magnitude limit in refcat
    local threshold=${4:-5}     # threshold for object detection in sextractor
    local bgsize=${5:-"64"}     # bg mesh size used for bg subtraction
    local fwhm=${6:-"4"}        # FWHM in arcsec (used by sextractor)
    local rdir=${AI_RAWDIR:-"."}
    local sdat=${AI_SETS:-"set.dat"}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpcat=$(mktemp "$tdir/tmp_src_$$.XXXXXX.dat")
    local tmpcat2=$(mktemp "$tdir/tmp_src2_$$.XXXXXX.dat")
    local sconf=$(mktemp "$tdir/tmp_scamp_$$.XXXXXX.conf")
    local slog=$(mktemp "$tdir/tmp_scamp_$$.XXXXXX.log")
    local p
    local b
    local hdr
    local singleimage
    local sexcat
    local refcatfile
    local ahead
    local ltype
    local sname
    local type
    local texp
    local nref
    local rad
    local ded
    local img
    local w
    local h
    local pixscale
    local magzero
    local posmaxerr
    local mres
    local nadd
    local x
    local y
    local kw
    local cmd
    local escfilter
    local allcats
    local server
    local retval
    
    test "$showhelp" &&
        echo "usage: AIwcs [-s] [-r] [-f|-q] [-c ra dec] [-n north] [-b binning]" \
            "[-p plotdev|$plotdev] [-o maxoff_deg] [-d fitdegrees|$fitdegrees]" \
            "[-m maskreg] [-x sopts]" \
            "[set|img] [refcat] [maglim|$maglim]" \
            "[thres|$threshold] [bgsize|$bgsize] [fwhm|$fwhm]" >&2 &&
        return 1
    
    test "${1:0:1}" == "-" &&
        echo "ERROR: unknown option $1." >&2 && return 255

    for p in ppmtorgb3
    do
        ! type -p $p > /dev/null 2>&1 && retval=255 &&
            echo "ERROR: program $p not in search path" >&2 && return 255
    done

    if [ -f "$setname" ]
    then
        # try to read some keywords from $img.head
        hdr=${setname%.*}.head
        if [ -f $hdr ]
        then
            magzero=$(get_header -q $hdr MAGZERO)
            test -z "$binning" && binning=$(get_header -q $hdr BINNING)
            test -z "$binning" && binning=1
            pixscale=$(get_wcspscale $hdr | awk -v b=$binning '{print $1*b}')
        fi
        test "$AI_PIXSCALE" && pixscale=$AI_PIXSCALE
        test "$AI_MAGZERO"  && magzero=$AI_MAGZERO

        sdat=$tdir/tmp_set_$$.dat
        echo "00:00 $setname xx o 0 0 0 0 xx xx xx" > $sdat
        singleimage="y"
    fi

    # create output directory for checkplots and catalogs
    test ! -d wcs && mkdir wcs

    # get default astref_catalog
    if [ ! "$refcat" ]
    then
        set - $(scamp -d | grep ASTREF_CATALOG)
        refcat=$2
    else
        # "translate" refcat
        case $refcat in
            ucac3)  refcat=ucac-3;;
            ucac4)  refcat=ucac-4;;
            tycho2) refcat=tycho-2;;
            gsc)    refcat=gsc-2.3;;
            ppm)    refcat=ppmx;;
            cmc14)  refcat=cmc-14;;
        esac
        # check with supported catalogs
        allcats=$(scamp -d | awk '{
            if ($1=="ASTREF_CATALOG") {ok=1} else {if($0!~/^ [ ]*#/){ok=0}}
            if (ok==1) {print tolower($0)}}' | cut -d '#' -f2- | tr ', ' '\n' | \
            grep "[a-z]" | grep -vwE "none|file")
        echo $allcats | grep -wq $refcat
        test $? -ne 0 &&
            echo "ERROR: unsupported catalog $refcat." >&2 &&
            echo "  (choose one of: " $allcats ")" >&2 &&
            return 255
    fi
   
    while read ltime sname target type texp n1 n2 nref dark flat x
    do
        (echo "$ltime" | grep -q "^#") && continue
        test "$type" != "o" && continue
        test "$setname" && test "$setname" != "$sname" && continue

        rad=$ra
        ded=$de
        img=""
        if [ "$singleimage" == "y" ]
        then
            img=$setname
        else
            test -f $sname.pgm && img=$sname.pgm
            test -f $sname.ppm && img=$sname.ppm
            pixscale=$AI_PIXSCALE
            if [ -z "$pixscale" ]
            then
                if [ -e $sname.head ]
                then
                    test -z "$binning" && binning=$(get_header -q $sname.head BINNING)
                    test -z "$binning" && binning=$(get_header -q $sname.head XBINNING)
                fi
                test -z "$binning" && binning=1
                pixscale=$(get_param camera.dat pixscale $sname | \
                    awk -v b=$binning '{print $1*b}')
            fi
            magzero=$(get_param    camera.dat magzero  $sname AI_MAGZERO)
        fi
        test -z "$img" &&
            echo "ERROR: no image found for set $sname." >&2 && return 255
        test ! -f "$img" &&
            echo "ERROR: image $img not found." >&2 && return 255
        
        # determine parameters depending on set (e.g. pixscale, magzero)
        test -z "$pixscale" &&
            echo "ERROR: $sname: pixscale unknown" >&2 && return 255
        #test -z "$magzero" &&
        #    echo "ERROR: $sname: magzero unknown" >&2 && continue
        mres=$(echo $pixscale | awk '{print 3*$1}')  # match_resol
        mres=$(echo $pixscale | awk '{print 1*$1}')  # match_resol
        
        # get image width and height
        w=$(identify $img | cut -d " " -f3 | cut -d "x" -f1)
        h=$(identify $img | cut -d " " -f3 | cut -d "x" -f2)
        
        # determine posmaxerr in arcmin
        if [ "$maxoff" ]
        then
            posmaxerr=$(echo $maxoff | awk '{print $1*60}')
        else
            posmaxerr=$(echo $w $h $pixscale | \
                awk '{printf("%.0f", 5+0.1*sqrt($1*$1+$2*$2)*$3/60)}')
        fi
        
        b=${img%\.*}
        #test -e $b.wcs.head &&
        #    echo "WARNING: skipping $b, WCS data file $b.wcs.head exists" &&
        #    continue
        sexcat=wcs/$b.src.dat
        ahead=${sexcat%.*}.ahead
        test "$nosex" && test ! -e $sexcat &&
            echo "WARNING: skipping $b, $sexcat does not exist." &&
            continue
        refcatfile=wcs/$b.$refcat.dat
        test "$nocatquery" && test ! -e $refcatfile &&
            echo "WARNING: skipping $b, $refcatfile does not exist." &&
            continue
        
        # get ra de from $sname.head or measure/$nref.src.head
        hdr=$sname.head
        test "$singleimage" && hdr=${sname%.*}.head
        test -e $hdr && if [ -z "$rad" ] || [ -z "$ded" ]
        then
            for kw in RA RATEL OBJCTRA AI_CORA
            do
                test -z "$rad" && test -f $hdr &&
                    rad=$(get_header -q $hdr $kw)
                test -z "$rad" && test -f measure/$nref.src.head &&
                    rad=$(get_header -q measure/$nref.src.head $kw)
            done
            test -z "$rad" && test -f $rdir/$nref.hdr &&
                rad=$(grep "^ra=" $rdir/$nref.hdr | cut -d '=' -f2)

            for kw in DEC DETEL OBJCTDEC AI_CODEC
            do
                test -z "$ded" && test -f $hdr &&
                    ded=$(get_header -q $hdr $kw)
                test -z "$ded" && test -f measure/$nref.src.head &&
                    ded=$(get_header -q measure/$nref.src.head $kw)
            done
            test -z "$ded" && test -f $rdir/$nref.hdr &&
                ded=$(grep "^de=" $rdir/$nref.hdr | cut -d '=' -f2)
        fi
        test -z "$rad" &&
            echo "ERROR: unknown ra center coordinate ($sname $nref)." >&2 &&
            return 255
        test -z "$ded" &&
            echo "ERROR: unknown de center coordinate ($sname $nref)." >&2 &&
            return 255

        # convert sexadecimal to decimal coordinates
        rad=$(echo $rad | tr ' ' ':')
        ded=$(echo $ded | tr ' ' ':')
        test "${rad/:/}" != "$rad" && rad=$(sexa2dec $(echo $rad | tr ' ' ':') 15)
        test "${ded/:/}" != "$ded" && ded=$(sexa2dec $(echo $ded | tr ' ' ':'))
        
        # determine north angle from AI_NPA or $cameradat and IMGROLL
        nadd=0
        test -z "$north" && north=$(get_header -q $hdr AI_NPA)
        if [ -z "$north" ]
        then
            north=$(get_param camera.dat rot $sname)
            test "$north" == "-" && north=0
            # check IMGROLL keyword (if required adjust north angle)
            x=$(get_header -q $hdr IMGROLL)
            test -z "$x" && test -f measure/$nref.src.head &&
                x=$(get_header -q measure/$nref.src.head IMGROLL | tr -d ' ')
            test "$x" == "Y" && nadd=180
        fi
        test -z "$north" &&
            echo "WARNING: assuming north is up." >&2 &&
            north=0
            
        if [ $nadd -eq 0 ]
        then
            x=$(echo $posmaxerr | awk '{printf("%.1f", $1/60)}')
            echo "calibrating $img using $rad, $ded" \
                "(north=$north, pixscale=${pixscale}\", maxoff=${x}deg) ..."
        else
            echo "calibrating $img using $rad, $ded" \
                "(north=$north+$nadd, pixscale=${pixscale}\", maxoff=${x}deg) ..."
        fi
        
        # convert ra, de, if given in sexagesimal units
        rad=$(sexa2dec $rad 15)
        ded=$(sexa2dec $ded)

        if [ ! "$nosex" ]
        then
            # source extraction
            is_ppm $img && AIsource -2 -q -o $sexcat $img "" $threshold
            is_pgm $img && AIsource    -q -o $sexcat $img "" $threshold
        fi

        # create head file
        # reference pixel (image center) and coefficients cdNN
        x=$(echo "$w/2" | bc)
        y=$(echo "$h/2" | bc)
        scale=$(echo "scale=6; $pixscale/3600" | bc -l)
        # NEW: north is given in degrees
        north=${north#+}    # need to remove leading +
        xproj="RA---TAN"; yproj="DEC--TAN";
        xval=$rad; yval=$ded
        cd11=$(echo "scale=6; -c(($north+$nadd)/180*3.14159)*$pixscale/3600" | bc -l)
        cd12=$(echo "scale=6; -s(($north+$nadd)/180*3.14159)*$pixscale/3600" | bc -l)
        cd21=$(echo "scale=6; -s(($north+$nadd)/180*3.14159)*$pixscale/3600" | bc -l)
        cd22=$(echo "scale=6;  c(($north+$nadd)/180*3.14159)*$pixscale/3600" | bc -l)
        
        # ascii header file
        echo "\
TELESCOP= 'Telescope'  / Observatory: Telescope
INSTRUME= 'Camera'     / Detector: Camera
FILTER  = 'Filter'     / Detector: Filter" > wcs/$b.src.ahead
        if [ -f $rdir/$nref.hdr ]
        then
            # note: only FLXSCALE is affected in scamp output file
            hdr2ahead $rdir/$nref.hdr >> wcs/$b.src.ahead
        fi
        echo "\
EQUINOX =      2000.0000 / Mean equinox
CTYPE1  = '$xproj'           / WCS projection type for this axis
CUNIT1  = 'deg     '           / Axis unit
CRVAL1  =      $xval   / World coordinate on this axis
CRPIX1  =      $x      / Reference pixel on this axis
CD1_1   =      $cd11   / Linear projection matrix
CD1_2   =      $cd12   / Linear projection matrix
CTYPE2  = '$yproj'           / WCS projection type for this axis
CUNIT2  = 'deg     '           / Axis unit
CRVAL2  =      $yval   / World coordinate on this axis
CRPIX2  =      $y      / Reference pixel on this axis
CD2_1   =      $cd21   / Linear projection matrix
CD2_2   =      $cd22   / Linear projection matrix
END     " >> wcs/$b.src.ahead
        #RADECSYS= 'ICRS    '           / Astrometric system
        #GAIN    =      1    / Maximum equivalent gain (e-/ADU)
        
        test ! -f $sexcat &&
            echo "ERROR: $sexcat missing." >&2 && return 255
        test ! -f wcs/$b.src.ahead &&
            echo "ERROR: wcs/$b.src.ahead missing." >&2 && return 255

        # skip bad/poor detections from sexcat
        sexselect -f $coloropt $sexcat "" 0.05 "" "" "*" 0 > $tmpcat
        if [ "$maskreg" ]
        then
            regfilter $tmpcat $maskreg > $tmpcat2
            mv $tmpcat2 $tmpcat
        fi
        cp wcs/$b.src.ahead ${tmpcat%.*}.ahead

        # compute wcs
        plotparams="-checkplot_dev $plotdev \
            -checkplot_type fgroups,distortion,astr_referror1d \
            -checkplot_name fgroups,distortion,astr_referror1d"
        photparams="-solve_photom N" # "-solve_photom N -magzero_out 25.5"
        posparams="-position_maxerr $posmaxerr -posangle_maxerr 30"
        #test "$maxoff" &&
        #    posparams="-position_maxerr $posmaxerr -posangle_maxerr 50"
        escfilter="cat"
        (test "$noescapes" || test "$quiet") &&
            escfilter="sed -r s/\x1b\[[0-9;]*[mAM]?//g"

        rm -f scamp.xml
        scamp -d > $sconf
        failure=""
        cmd="scamp -c $sconf \
                $plotparams $photparams $posparams \
                -astrefmag_limits -99,$maglim -distort_degrees $fitdegrees \
                -sn_thresholds 10,40 -match_resol $mres \
                -mergedoutcat_type FITS_LDAC -mergedoutcat_name wcs/$b.match.dat \
                $sopts $tmpcat"
        if [ "$nocatquery" ]
        then
            cmd="$cmd -astref_catalog file -astrefcat_name $refcatfile"
        else
            cmd="$cmd -astref_catalog  $refcat -save_refcatalog Y"
            # requires aclient and online access to vizier database
            server=$(echo $sopts | sed 's| -|\n-|g' | grep -i REF_SERVER | awk '{printf("%s", $2)}')
            test -z $server &&
                server=$(grep REF_SERVER $sconf | awk '{printf("%s", $2)}')
            test "$AI_DEBUG" && echo "# server = $server"
            ! check_url &&
                echo "ERROR: no internet connection." >&2 &&
                return 255
            # check server url
            # NOTE: disabled, because cds server is not checked reliably
            false && if ! check_url $server
            then
                echo "# WARNING: server $server is unreachable, trying fallback (vizier.cfa.harvard.edu)"
                cmd="$cmd -ref_server vizier.cfa.harvard.edu"
            fi
        fi
        eval "$cmd" 2>&1 | $escfilter > $slog
        (test $? -ne 0 || test ! -f scamp.xml || ! test -s ${tmpcat%.*}.head) &&
            failure=1
        test -z "$nocatquery" &&
            vizcat=$(ls -tr *cat 2>/dev/null | grep -i "^$refcat" | tail -1) &&
            test ! "$vizcat" &&
            echo "# ERROR: scamp has failed" >&2 &&
            failure=1
        test "$failure$AI_DEBUG" && echo "# $cmd" | sed -e 's, [[:space:]]*, ,g'
        if [ "$quiet" ]
        then
            cat $slog | awk '{
                if ($0~/SCAMP .* started/) print $0
                if (tolower($0)~/error|warning/ &&
                    $0!~/executable .* without .* multithreading/) print $0
                if ($0~/detections loaded|standards found/) print $0
                if ($0~/instruments/) print "\n" $0
                if ($0~/^tmp/ && $0!~/detections/) print $0 "\n"
                if ($0~/Astrometric stats \(external\)/) {
                    print $0; for (i=1;i<=4;i++) {getline; print $0}}
            }' >&2
        else
            grep -v "tmp.*reference pair.*processed'" $slog >&2
        fi
        test "$failure" && echo "ERROR: scamp failed:" >&2 && return 255
        test -z "$nocatquery" && test -f "$vizcat" && mv "$vizcat" $refcatfile
        
        mv ${tmpcat%.*}.head $b.wcs.head
        case $plotdev in
            NULL)   ;;
            SVG)    for p in {fgroups,distort,astr_referror}*svg
                    do
                        rsvg-convert $p > wcs/$b.${p%.*}.png && rm $p
                    done
                    ;;
            PNG)    for p in {fgroups,distort,astr_referror}*png
                    do
                        mv $p wcs/$b.$p
                    done
                    ;;
            *)      for p in {fgroups,distort,astr_referror}*
                    do
                        mv $p wcs/$b.$p
                    done
                    echo "WARNING: not converting checkplots ($plotdev)." >&2
                    ;;
        esac

        # TODO: propagate some header keywords to $b.wcs.head, e.g.
        #   EXPTIME,NEXP,MJD_REF,MJD_OBS,MAGZERO,GAIN,SATURATE
        if [ 0 -eq 1 ] && [ -f $hdr ]
        then
            for h in EXPTIME NEXP MJD_REF MJD_OBS MAGZERO GAIN SATURATE
            do
                echo "TODO"
            done
        fi
        
        # evaluate star matches and show summary
        #x=$(get_header -e LDAC_OBJECTS $refcatfile NAXIS2)
        x=$(stilts tpipe ifmt=fits ofmt=ascii cmd='select "mag<='$maglim'"' \
            in=$refcatfile"#2" | grep -v "^#" | wc -l)
        set - $(stilts tpipe ofmt=text scamp.xml cmd=transpose | awk -v ncat=$x '{
            if($2=="NDetect")               nsrc=$4
            if($2=="NDeg_Reference")        nmatch=$4
            if($2=="NDeg_Reference_HighSN") nhigh=$4
        }END{
            printf("%d %d %d %d\n", nsrc, ncat, nmatch, nhigh)
        }')
        test $((($3-5)*100/$1)) -lt 5 &&
            echo "ERROR: too few stars matched ($3 out of $1)." >&2 &&
            return 255
        set_header $b.wcs.head POLYDEG=$fitdegrees NIMG=$1 NCAT=$2 NMATCH=$3 NHIGH=$4
        echo ""
        echo "nimg=$1   ncat=$2   nmatch=$3   nhigh=$4"
        echo $(get_header -s $b.wcs.head ASTRRMS1,ASTRRMS2) | awk '{
            printf("xrms=%.3f\"  yrms=%.3f\"\n", $1*3600, $2*3600)}'
                            
        rm -f $tmpcat $tmpcat2 ${tmpcat%.*}.ahead scamp.xml $sconf $slog
    done < $sdat
    test "$singleimage" == "y" && rm $sdat
    #rm -f $tmp1 $tmp2
    return 0
}


# warp PPM images using wcs calibration data (default: <img>.wcs.head)
# result: <img>.warped.ppm and associated FITS header (<img>.warped.head)
# requires imhead in PATH
# weight maps are used if files $b.num.pgm exist
AIwarp () {
    local showhelp
    local do_quiet
    local resamptype        # resampling type (e.g. lanczos3, bilinear)
    local weightmap
    local i
    for i in 1 2 3 4
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-q" && do_quiet=1 && shift 1
        test "$1" == "-r" && resamptype="$2" && shift 2
        test "$1" == "-w" && weightmap="$2" && shift 2
    done
    
    local rdir=${AI_RAWDIR:-"."}
    local sdat=${AI_SETS:-"set.dat"}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local sconf=$(mktemp "$tdir/tmp_swarp_XXXXXX.conf")
    local param
    local img
    local ref
    local out
    local p
    local n1
    local n2
    local ps
    local ra
    local de
    local b
    local c
    local ropts
    local blist
    local clist
    local wopts
    local imgext    # input image extension (ppm or pgm)
    
    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: AIwarp [-r resamptype] [refhead] <img1> [img2] ..." >&2 &&
        return 1
    
    for p in imhead ppmtorgb3
    do
        ! type -p $p > /dev/null 2>&1 && retval=255 &&
            echo "ERROR: program $p not in search path" >&2 && return 255
    done
    
    # check for reference image header file
    ropts=""
    test -f "$1" &&
        grep -q "^BITPIX" $1 && grep -q "^NAXIS1" $1 && grep -q "^NAXIS2" $1 &&
        ref="$1" && shift 1
    
    # some parameters for swarp
    param="-combine_type average -subtract_back N -fscale_keyword NOTHING -blank_badpixels Y"
    test "$do_quiet"    && param="$param -verbose_type quiet $wopts"
    test "$resamptype"  && param="$param -resampling_type $resamptype"

    # evaluate reference image header
    if [ "$ref" ]
    then
        n1=$(grep "^NAXIS1" "$ref" | tr '=' ' ' | awk '{print $2}')
        n2=$(grep "^NAXIS2" "$ref" | tr '=' ' ' | awk '{print $2}')
        ps=$(grep "^CD2_2" "$ref" | tr '=' ' ' | awk '{print 3600*$2}')
        ra=$(grep "^CRVAL1" "$ref" | tr '=' ' ' | awk '{print $2}')
        de=$(grep "^CRVAL2" "$ref" | tr '=' ' ' | awk '{print $2}')
        (test -z "$ps" || test -z "$ra" || test -z "de") &&
            echo "ERROR: missing wcs keywords in $ref." >&2 && return 255
        ropts="-image_size $n1,$n2 -pixelscale_type manual -pixel_scale $ps
            -center_type manual -center $ra,$de"
    fi
    #echo $ropts
    
    # set output file names
    imgext="ppm"; is_pgm $1 && imgext="pgm"; is_pbm $1 && imgext="pgm"
    out=$(basename ${1%\.*}.warped)
    test -f "$out.$imgext" && echo "ERROR: output file $out.$imgext exists." >&2 && return 255
    test -f "$out.head" && echo "ERROR: output file $out.head exists." >&2 && return 255
    swarp -d > $sconf

    # convert to fits
    blist=""
    wopts=""
    for img in "$@"
    do
        test ! -f $img &&
            echo "WARNING: image $img not found." >&2 && continue

        b=${img%\.*}
        test ! -e $b.wcs.head &&
            echo "WARNING: skipping $img, missing file $b.wcs.head." >&2 &&
            continue

        case "$imgext" in
            ppm)    ppmtorgb3 $img; clist="red grn blu";;
            pgm)    cp $img $b.gray; clist="gray";;
        esac
        for c in $clist
        do
            pnmtomef $b.$c > $b.$c.fits
            cp -p $b.wcs.head $b.$c.head
            # weight map
            if [ "$weightmap" ]
            then
                test -f $weightmap &&
                    pnmtomef $weightmap > $b.$c.weight.fits &&
                    cp -p $b.wcs.head $b.$c.weight.head &&
                    test -z "$wopts" &&
                        wopts="-weight_type MAP_WEIGHT -rescale_weights N"
            else
                test -f $b.num.pgm &&
                    pnmtomef $b.num.pgm > $b.$c.weight.fits &&
                    cp -p $b.wcs.head $b.$c.weight.head &&
                    test -z "$wopts" &&
                        wopts="-weight_type MAP_WEIGHT -rescale_weights N"
            fi
            rm $b.$c
        done
        blist="$blist ${b}.XXX"
    done
    test -z "$blist" && echo "no images to process." >&2 && return 255

    # warp images
    for c in $clist
    do
        test ! "$do_quiet" &&
            echo swarp -c $sconf $param $wopts $ropts ${blist//.XXX/.$c.fits}
        swarp -c $sconf $param $wopts $ropts ${blist//.XXX/.$c.fits}
        (test "$c" == "grn" || test "$c" == "gray") &&
            imhead -z coadd.fits > $out.head &&
            test "$wopts" && cp -p coadd.weight.fits $out.weight.fits
        sethead coadd.fits datamin=0 datamax=65535
        meftopnm coadd.fits > out.$c.pgm
        test "$AI_DEBUG" && mv coadd.fits out.$c.fits
        test ! "$AI_DEBUG" &&
            rm -f ${blist//.XXX/.$c.fits} ${blist//.XXX/.$c.weight.fits} &&
            rm -f ${blist//.XXX/.$c.head} ${blist//.XXX/.$c.weight.head}
    done

    # convert result to ppm
    case "$imgext" in
        ppm)    rgb3toppm out.red.pgm out.grn.pgm out.blu.pgm > $out.ppm;;
        pgm)    mv out.gray.pgm $out.pgm;;
    esac
    
    test "$AI_DEBUG" || rm -f out.red.pgm out.grn.pgm out.blu.pgm
    rm -f coadd.fits coadd.weight.fits swarp.xml $sconf
}


# download DSS image at given center coordinates and field size
# or using an existing image filename (wcs calibration must exist)
AIdss () {
    local showhelp
    local outps             # pixelsize of output dss image in arcsec (default:
                            # pixel size of input image)
    local outfile           # name of output file
    local testonly          # if set, do not download DSS images
    local do_use_eso        # if set retrieve data from ESO archive instead of STScI
    local dsscat="dss2r"    # dss catalog to get images from
    local dssopts
    local i
    for i in 1 2 3 4 5 6
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-p" && outps=$2 && shift 2
        test "$1" == "-1" && dsscat="dss1r" && dssopts="-1" && shift 1
        test "$1" == "-o" && outfile="$2" && shift 2
        test "$1" == "-t" && testonly=1 && shift 1
        test "$1" == "-e" && do_use_eso=1 && shift 1
    done
    
    local imgorrad=${1:-""} # image file name or center RA (sexagesimal or
                            # decimal degrees)
    local ded=${2:-""}      # center DEC (sexagesimal or decimal degrees)
    local width=${3:-""}    # field width in degrees
    local height=${4:-""}   # field height in degrees
    local outps=${5:-""}    # output dss image pixel size in arcsec
    local north=${6:-0}     # pa of celestial north pole on the input image
    local sdat=${AI_SETS:-"set.dat"}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local wdir=$(mktemp -d "$tdir/tmp_dss_XXXXXX")
    local tmpwcshdr=$(mktemp "$tdir/tmp_whdr_XXXXXX.head")
    #local tmppgm=$(mktemp "$tdir/tmp_pgm_XXXXXX.pgm")
    local cgiurl="http://archive.stsci.edu/cgi-bin/dss_search"
    local sizelimit=2.0     # max allowed size of downloadable image (degrees)
    local img
    local whdr
    local rad
    local s
    local w     # dimensions of img in pix
    local h
    local inps  # pixelsize of img in arcsec
    local rot   # position angle of true north in img
    local nx    # number of chunks at given axis
    local ny
    local dx    # offset between chunks in pix
    local dy
    local cx    # chunk size in pix
    local cy
    local x
    local y
    local coord
    local param
    local smult=1.05 # chunk size multiplier to allow for field overlaping
    
    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: AIdss [-t] [-1] [-o outfile]" \
            "<image|ra> [de] [width/deg] [height/deg] [pixscale] [northangle]" >&2 &&
        return 1

    test "$do_use_eso" && cgiurl="http://archive.eso.org/dss/dss"
    
    if [ -f "$imgorrad" ]
    then
        # using image to derive center coordinates and field size
        img=$imgorrad
        whdr=${img%.*}.wcs.head
        test ! -f "$whdr" && echo "ERROR: missing wcs header file $whdr" >&2 && return 255
        set - $(identify $img | cut -d " " -f3 | tr 'x' ' ')
        w=$1; h=$2
        # determine rad ded width height inps
        rad=$(get_header $whdr CRVAL1 | awk '{print 1*$1}')
        ded=$(get_header $whdr CRVAL2 | awk '{print 1*$1}')
        inps=$(get_wcspscale $whdr)
        rot=$(get_wcsrot $whdr | awk '{print -1*$1}')
        test -z "$width"  && width=$(echo $w $h $rot $inps  | \
            awk '{a=$3/180*3.14159; x=$1*cos(a); y=$2*sin(a)
                print (sqrt(x*x)+sqrt(y*y))*$4/3600}')
        test -z "$height" && height=$(echo $w $h $rot $inps | \
            awk '{a=$3/180*3.14159; x=$1*sin(a); y=$2*cos(a)
                print (sqrt(x*x)+sqrt(y*y))*$4/3600}')
        echo "# size $width x $height deg" >&2
    else
        test $# -lt 4 &&
            echo "ERROR: missing required parameters." >&2 && return 255
        rad=$(sexa2dec $imgorrad 15)
        ded=$(sexa2dec $ded)

        # create artificial wcs header file which is later being used to
        # determine center coordinates of image chunks
        # largest image dimension is set to 2000 pix
        set - $(echo $width $height | awk '{
            if ($1>=$2) {
                w=2000; h=$2/$1*2000; ps=$1*3600/w
            } else {
                h=2000; w=$1/$2*2000; ps=$2*3600/h
            }
            printf("%d %d %f\n", w, h, ps)
            }')
        w=$1; h=$2; inps=$3
        mkwcs ${w}x${h} $rad $ded $north $inps > $tmpwcshdr
        whdr=$tmpwcshdr
    fi

    # set output file name
    s="$(dec2sexa -m $rad 15 0 | tr -d ':+')$(dec2sexa -h $ded 1 1 | tr -d ':.')"
    test ! "$outfile" && outfile=$s.$dsscat.fits.gz
    test -s $outfile &&
        echo "ERROR: output file $outfile already exists." >&2 &&
        return 255

    
    # if either image dimension is larger then $sizelimit then divide
    #   image into chunks of max. 1 deg
    # determine chunk size multiplier dependant on declination
    # (because dss images are NOT aligned to north celestial pole)
    smult=1.06
    x=$(echo ${ded%.*} | tr -d "+-")
    test $x -gt 30 && smult=1.10
    test $x -gt 50 && smult=1.14
    test $x -gt 60 && smult=1.20
    test $x -gt 70 && smult=1.30
    test $x -gt 80 && smult=1.40
    set - $(echo $width $height $inps | awk -v lim=$sizelimit -v m=$smult '{
        nx=1; ny=1
        if ($1>lim) {nx=int($1)+1}
        if ($2>lim) {ny=int($2)+1}
        if (nx*ny == 1) {m=1}
        x=$1*3600/nx/$3
        y=$2*3600/ny/$3
        printf("%d %d %.1f %d %d %.1f\n", nx, x, m*$1*60/nx, ny, y, m*$2*60/ny)
        }')
    # number of chunks
    nx=$1; ny=$4
    # offset between chunks in pixel
    dx=$2; dy=$5
    test "$AI_DEBUG" && echo "# offset/pix      dx=$dx dy=$dy" >&2
    # chunk size in arcmin
    cx=$3; cy=$6
    test "$AI_DEBUG" && echo "# chunk size/amin  cx=$cx cy=$cy" >&2


    # downloads
    echo "download $nx x $ny chunks ..." >&2
    i=1
    for y in $(seq $((h/2-(ny-1)*dy/2)) $dy $((h/2+(ny-1)*dy/2+3)))
    do
        for x in $(seq $((w/2-(nx-1)*dx/2)) $dx $((w/2+(nx-1)*dx/2+3)))
        do
            coord=$(echo "id $x $y" | xy2rade - $whdr | awk '{printf("r=%f&d=%f", $1, $2)}')
            param="v=poss2ukstu_red&e=J2000&f=fits&c=gzip&w=$cx&h=$cy&${coord}"
            test "$do_use_eso" &&
                coord=$(echo "id $x $y" | xy2rade - $whdr | awk '{printf("ra=%f&dec=%f", $1, $2)}') &&
                param="Sky-Survey=DSS2-red&mime-type=display/gz-fits&x=$cx&y=$cy&equinox=J2000&${coord}"
            echo "# $i/$(($nx*ny))"
            i=$((i+1))
            test "$testonly" &&
                echo "wget -O $wdir/$$.$x.$y.dss.fits.gz \"$cgiurl?$param\"" &&
                continue
            wget -O $wdir/$$.$x.$y.dss.fits.gz "$cgiurl?$param"
            test $((nx*ny)) -gt 1 && gunzip $wdir/$$.$x.$y.dss.fits.gz
        done
    done

    if [ -z "$testonly" ]
    then
        if [ $((nx*ny)) -gt 1 ] || [ "$outps" ]
        then
            # note: coadded image is always aligned to celestial north pole
            sopts="-subtract_back Y -fscalastro_type none"
            test "$outps" && sopts="$sopts -pixelscale_type manual -pixel_scale $outps"
            swarp -center_type manual -center "$rad,$ded" $sopts $wdir/$$.*.dss.fits
            test $? -ne 0 &&
                echo "ERROR: swarp program error during
swarp -subtract_back Y -center_type manual -center \"$rad,$ded\" \
-pixelscale_type manual -pixel_scale $outps \
-fscalastro_type none $wdir/$$.*.dss.fits" >&2 && return 255
            # -image_size "${size/x/,}"
            #imrot -x 16 coadd.fits
            #mv coaddb16.fits $outfile
            #sethead $outfile TELESCOP="Oschin Schmidt - D"
            gzip -c coadd.fits > $outfile
        else
            # note: dss image is NOT aligned to celestial north pole
            mv $wdir/$$.$x.$y.dss.fits.gz $outfile
        fi
    fi
    
    test -z "$AI_DEBUG" &&
        rm -f $tmpwcshdr &&
        rm -f $wdir/$$.*.dss.fits* &&
        rmdir $wdir &&
        rm -f coadd.fits coadd.weight.fits
    return
}


# stack a set of RGB or grayscale images
# uses wcs calibration data and bad region maps (in bgvar)
# output image size is the same as first input image, for mosaics this
#   must be changed to full coverage size (option -f)
# TODO: use instrumental weight map to reduce weight in vignetted areas.
AIstack () {
    local showhelp
    local insuffix=""       # suffix added to base of input images
    local outsuffix=""      # suffix added to base of output file names
    local imgsize=""        # use this image size for coadded image
    local xyscale=1         # scale up/down output image resolution
    local use_full_size     # if set use full coverage of input images
    local do_subtract_bg    # if set apply background subtraction
    local omove=""          # stack on moving object using either dx,dy
                            #   (pix/min) or dr@pa@x,y where dr@pa is object
                            #   move on sky in "/hr,deg and x,y is position of
                            #   object on image in image coords
    local sparam=""         # additional parameters passed over to swarp
    local cref=""           # if set use center coordinates of this image
    local verbose=0         # if >0 print some info about shifted image center
                            # if >1 print additional messages from scamp
    #local do_weight_combine # if set use combine_type weighted instead of average
    local do_bayer          # if set then stack separately on each bayer grid
                            # color
    local do_halfset        # if set create two stacks from first/second half
                            # number of images in the set
    local do_not_register   # no registration, use combine_type median
    local badpix            # badpix bitmask (ignore white pixels)
    local ctype="average"   # combine_type
    local resamptype="bilinear" # resampling type (e.g. lanczos3, bilinear)
    local bgdiffzero=10000  # must match the bgzero value used by AIbgdiff to
                            # create bgvar/*.bgm1.* images
    local i
    for i in $(seq 1 18)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-i" && insuffix="$2" && shift 2
        test "$1" == "-o" && outsuffix="$2" && shift 2
        test "$1" == "-c" && cref="$2" && shift 2
        test "$1" == "-s" && imgsize="$2" && shift 2
        test "$1" == "-z" && xyscale="$2" && shift 2
        test "$1" == "-f" && use_full_size=1 && shift 1
        test "$1" == "-b" && do_bayer=1 && shift 1
        test "$1" == "-bg" && do_subtract_bg=1 && shift 1
        test "$1" == "-t" && ctype="$2" && shift 2
        test "$1" == "-w" && do_weight_combine=1 &&
            echo "ERROR: option do_weight_combine is not available any more" >&2 &&
            echo "       please use '-ctype weighted' instead" && return 255
        test "$1" == "-v" && verbose=$((verbose+1)) && shift 1
        test "$1" == "-m" && omove="$2" && shift 2
        test "$1" == "-p" && sparam="$2" && shift 2
        test "$1" == "-2" && do_halfset=1 && shift 1
        test "$1" == "-bad" && badpix=$2 && shift 2
        test "$1" == "-bz" && bgdiffzero=$2 && shift 2
        test "$1" == "-r" && resamptype="$2" && shift 2
        test "$1" == "-n" && do_not_register=1 && shift 1
    done
    local setname=${1:-""}          # empty or setname or first image
    local bsize=512                 # default: 128
    local iweight="iweight.pgm"     # instrumental weight map
    local sdat=${AI_SETS:-"set.dat"}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local imlist=$(mktemp "$tdir/tmp_imlist_XXXXXX.dat")
    local wdir=$(mktemp -d "$tdir/tmp_mosaic_XXXXXX")
    local conf=$(mktemp "$tdir/tmp_conf_XXXXXX.dat")
    local badtmp=$(mktemp "$tdir/tmp_bad_XXXXXX.pbm")
    local ilist=""          # list of input images
    local wlist=""          # list of input weight images
    local out=""            # base of output file names
    local outlist
    local param
    local setparam
    local gain=1.0          # effective detector gain in e-/ADU
    local saturation
    local pixscale          # (approx.) pixel scale in arcsec per pixel
    local magzero
    local ltime
    local sname
    local target
    local type
    local texp
    local n1
    local n2
    local nref
    local dark
    local flat
    local x
    local has_image_args
    local inext
    local num
    local fname
    local wcs
    local href
    local rot
    local regpixscale       # arbitrary pixscale used by AIregister
    local clist             # names of color channels
    local c
    local ncolors
    local bpp
    local b
    local w
    local h
    local mem=1024
    local jdref
    local jdmean
    local jd
    local dateobs
    local imgroll
    local pierside
    local filter
    local binning
    local retval=0

    test "$showhelp" &&
        echo "usage: AIstack [-i <insuffix>] [-o <outsuffix>] [-2] [-f] [-b] [-bg]" \
            "[-v] [-n] [-bz bgdiffzero|$bgdiffzero]" \
            "[-c combinetype] [-r resamptype] [-bad badpix] [-m dx,dy | -m dr@pa] [-c <centerrefimg>]" \
            "[-z <xyscale>] [-s <w,h>] [-p <sparam>] [<setname>|<img1> <img2> ...]" >&2 &&
        return 1
    
    test "$badpix" && test ! -f "$badpix" &&
        echo "ERROR: badpix file $badpix not found." >&2 && return 255

    param="-mem_max $mem -combine_bufsize $mem -resample_dir $wdir"
    param="$param -blank_badpixels Y -fscale_keyword XYZ"
    if [ "$do_subtract_bg" ]
    then
        param="$param -subtract_back Y -back_size $bsize"    # default: 128
    else
        param="$param -subtract_back N"
    fi
    if [ $verbose -gt 1 ] || [ "$AI_DEBUG" ]
    then
        param="$param -verbose_type NORMAL"
    else
        param="$param -verbose_type QUIET"
    fi
    
    # combine_type resampling type
    test -z "$resamptype" && resamptype="bilinear"
    param="$param -combine_type $ctype -resampling_type $resamptype"
    echo "# combine: $ctype  resampling: $resamptype" >&2

    test "$imgsize"  && param="$param -image_size $imgsize"
    test "$AI_DEBUG" && param="$param -delete_tmpfiles N"

    if [ -f "$setname" ]
    then
        ! is_pnm $setname &&
            echo "ERROR: $setname is not a recogniced file type (PNM)." >&2 &&
            rm -f $imlist &&
            return 255
        sdat=$tdir/tmp_set_$$.dat
        echo "00:00 $setname xx o 0 0 0 ${setname%.*} xx xx" > $sdat
        has_image_args="y"
    fi
    
    if [ "$cref" ]
    then
        test ! -f "${cref%.*}.head" &&
            echo "ERROR: image header for $cref (cref) not found." >&2 && return 255
        outcrval1=$(grep "^CRVAL1 " ${cref%.*}.head | awk '{print $3}')
        outcrval2=$(grep "^CRVAL2 " ${cref%.*}.head | awk '{print $3}')
        (test -z "$outcrval1" || test -z "$outcrval2") &&
            echo "ERROR: missing CRVAL* in ${cref%.*}.head." >&2 && return 255
        param="$param -center_type manual -center $outcrval1,$outcrval2"
        
        if [ "$use_full_size" ] && [ -z "$imgsize" ]
        then
            param="$param -image_size $(imsize $cref | tr ' ' ',')"
        fi
    fi

    while read ltime sname target type texp n1 n2 nref dark flat x
    do
        (echo "$ltime" | grep -q "^#") && continue
        test "$type" != "o" && continue
        test "$setname" && test "$setname" != "$sname" && continue
        (! is_integer "$n1" || ! is_integer "$n2") && continue
        test -z "$has_image_args" && ! is_integer "$nref" && continue
 
        inext=""
        if [ "$has_image_args" ]
        then
            for img in "$@"; do echo "xx yy $img" >> $imlist; done
            outlist="mosaic$outsuffix"
            test "$AI_SATURATION" && saturation=$AI_SATURATION
            test "$AI_GAIN"       && gain=$AI_GAIN
            test "$AI_PIXSCALE"   && pixscale=$AI_PIXSCALE && regpixscale=$AI_PIXSCALE
            test "$AI_MAGZERO"    && magzero=$AI_MAGZERO
        else
            if [ "$do_bayer" ]
            then
                AIimlist $sname "" pgm > $imlist
            else
                AIimlist $sname > $imlist
                set - $(head -1 $imlist) x
                test -s "$imlist" && is_pgm $3 && inext="pgm"
                test -z "$inext" && inext="ppm"
            fi
            outlist="${sname}$outsuffix"
            test "$do_halfset" && outlist="${sname}a$outsuffix ${sname}b$outsuffix"

            # read data from camera.dat or environment
            saturation=$(get_param camera.dat satur    $sname AI_SATURATION)
            gain=$(get_param       camera.dat gain     $sname AI_GAIN       $gain)
            pixscale=$(get_param   camera.dat pixscale $sname AI_PIXSCALE)
            magzero=$(get_param    camera.dat magzero  $sname AI_MAGZERO)
            test -z "$pixscale" &&
                echo "ERROR: cannot determine pixscale for $sname, skipping set." >&2 &&
                retval=1 && continue

            # get regpixscale from measure/$nref.src.head
            test ! -f measure/$nref.src.head &&
                echo "ERROR: measure/$nref.src.head is missing, skipping set." >&2 &&
                retval=1 && continue
            regpixscale=$(get_wcspscale measure/$nref.src.head)
            test -z "$regpixscale" &&
                echo "ERROR: cannot determine regpixscale for $sname, skipping set." >&2 &&
                retval=1 && continue
        fi
        for out in $outlist
        do
            test -f $out.head &&
                echo "WARNING: skipping $sname, output header file $out.head already exists." >&2 &&
                rm -f $imlist $conf &&
                continue
        done
        test ! -f $imlist && retval=1 && continue
        
        # determine image rotation of reference image (and star stack) with
        # respect to true north (if omove is given as dr@pa@x,y
        if [ "$omove" ] && [ "${omove/@/}" != "$omove" ]
        then
            rot=$(get_wcsrot $sname $(echo $omove | awk -F "@" '{print $3}' | tr ',' ' '))
            test -z "$rot" &&
                echo "ERROR: cannot get wcsrot for set $sname." >&2 && retval=255 && continue
        fi
        
        # determine swarp parameters depending on set (e.g. regpixscale, magzero)
        setparam=""
        test "$gain"       && setparam="$setparam -gain_default $gain"
        test "$saturation" && setparam="$setparam -satlev_default $saturation"
        if [ "$regpixscale" ]
        then
            regpixscale=$(echo $regpixscale $xyscale | awk '{print $1/$2}')
            setparam="$setparam -pixelscale_type manual -pixel_scale $regpixscale"
        else
            # if regpixscale is not set then swarp uses median from input images
            echo "WARNING: pixscale not set, using median from input images." >&2
        fi

        # check for image file and wcs header
        n=0; ilist=""
        while read x num fname x
        do
            test ! -f ${fname%.*}$insuffix.${fname##*.} &&
                echo "ERROR: ${fname%.*}$insuffix.${fname##*.} not found." >&2 && n=0 && break
            wcs=${fname%.*}.wcs.head
            if [ ! -f "$wcs" ]
            then
                wcs=measure/$(basename ${fname%.*}.src.head)
                test ! -f "$wcs" &&
                    echo "WARNING: skipping $fname (header file not found)." >&2 &&
                    retval=1 && continue
            fi
            if [ "$omove" ]
            then
                ! grep -q "^MJD_OBS =" $wcs && ! grep -q "^JD      =" $wcs &&
                    ! grep -q "^DATE-OBS=" $wcs &&
                    echo "WARNING: skipping $fname (missing MJD_OBS in header file)." >&2 &&
                    retval=1 && continue
            fi 
            n=$(($n + 1))
            ilist="$ilist $fname"
        done < $imlist
        
        # if appropriate, set center coordinates
        if [ -z "$use_full_size" ]
        then
            if [ ! "$cref" ]
            then
                wcs=$nref.wcs.head
                test ! -f "$wcs" && wcs=measure/$nref.src.head
                test ! -f "$wcs" &&
                    echo "WARNING: $nref.wcs.head not found, cannot set center." >&2 &&
                    break
                outcrval1=$(grep "^CRVAL1 " $wcs | awk '{print $3}')
                outcrval2=$(grep "^CRVAL2 " $wcs | awk '{print $3}')
                (test -z "$outcrval1" || test -z "$outcrval2") &&
                    echo "ERROR: missing CRVAL* in $wcs." >&2 && return 255
                setparam="$setparam -center_type manual -center $outcrval1,$outcrval2"
            fi
        fi
        
        if [ "$has_image_args" ]
        then
            test $n -eq 0 && echo "WARNING: no input images." && retval=1 && continue
            echo "processing $n images ..."
        else
            test $n -eq 0 && echo "WARNING: skipping set $sname" && retval=1 && continue
            echo "processing $n images in set $sname ..."
        fi

        # disk space
        #   fits image:     ncolors*2byte*npixin / image
        #   weight maps:    1byte*npixin / image
        #   sratio=npixout/npixin=z*xyscale^2  # z=1 if ! $imgsize and ! use_full_size 
        #   resamp.fits:    3*2byte*npixout/image # 2x because of possible 45deg rotation,
        #                                           # 1.5x because of margins
        #   resamp.weight.fits: 3*2byte*npixout/image
        #   coadding:       2*ncolors*2byte*npixout / set
        img=$(head -1 $imlist | awk '{print $3}')
        ncolors=3
        is_pgm $img && ncolors=1
        test "$do_bayer"     && ncolors=2   # ??
        # wratio=num_weight_maps/num_input_images
        # bpp=2*ncolors*2*(1+wratio+sratio)  # bytes/pixel/input_image
        # bpp=$(echo $ncolors 0.1 $xyscale | awk '{printf("%.0f\n", 3*$1*(1+$2+$3*$3))}')
        bpp=$(echo $ncolors 0.1 $xyscale | awk '{printf("%.0f\n", 2*$1+1 + 12*($3*$3))}')
        ! is_diskspace_ok -v "$tdir" "$img" $((n+2)) $((bpp)) &&
            echo "ERROR: not enough disk space to process set $sname." >&2 && retval=1 && continue
        
        # get jd, filter, pierside, imgroll from reference image header
        jdref=""; filter=""; binning=""; pierside=""; imgroll=""
        href=$nref.head
        test ! -f $href && href=measure/$nref.src.head
        if [ -f $href ]
        then
            jdref=$(get_header -q $href JD)
            test -z "$jdref" &&
                jdref=$(grep -E "^MJD_REF =|^MJD_OBS =" $href | head -1 | \
                    awk '{printf("%s", $3)}')
            if [ -z "$jdref" ]
            then
                dateobs=$(grep "^DATE-OBS=" $href | tr -d "'" | awk '{print $2}')
                test "$dateobs" && jdref=$(ut2jd $(echo $dateobs | tr -d '-' | \
                    awk -F "T" '{print $2" "substr($1,3)}'))
            fi
            grep "^IMGROLL =" $href | tr -d "'" | grep -q -w Y &&
                imgroll="yes"
            filter=$(get_header -q $href FILTER)
            binning=$(get_header -q $href BINNING)
            test -z "$binning" && binning=$(get_header -q $href XBINNING)
            pierside=$(get_header -q $href PIERSIDE)
        fi
        test -z "$jdref" &&
            echo "ERROR: cannot determine jd from reference image header." >&2 &&
            retval=1 && continue
        # determine mean MJD_OBS (mean from all images)
        jdmean=$(LANG=C printf "%.5f" $(get_jd_dmag $sname | mean - 2))
        test -z "$jdmean" &&
            echo "ERROR: cannot determine mean jd (from get_jd_dmag $sname)." >&2 &&
            retval=1 && continue
        # correct pixscale for binning
        test "$binning" &&
            pixscale=$(echo $pixscale $binning | awk '{print $1*$2}')

        # convert to fits images
        echo "converting to fits ($(date +'%H:%M:%S')) ..." >&2
        n=0
        wopts=""
        test "$do_bayer" && wopts="-weight_type map_weight"
        sopts=""
        for img in $ilist
        do
            n=$(($n + 1))
            # get image width and height
            w=$(identify $img | cut -d " " -f3 | cut -d "x" -f1)
            h=$(identify $img | cut -d " " -f3 | cut -d "x" -f2)
            test $verbose -gt 0 && echo "img=$img  ${w}x${h}" >&2

            wcs=${img%.*}.wcs.head
            test ! -f "$wcs" && wcs=measure/$(basename ${img%.*}.src.head)

            if [ "$omove" ] && [ "$jdref" ]
            then
                # determine shifted reference pixel coordinates
                #dsec=$(echo $(getImageDateSec $num) - $(getImageDateSec $nref) | bc)
                jd=$(grep -E "^MJD_OBS =|^JD " $wcs | head -1 | awk '{printf("%s", $3)}')
                if [ -z "$jd" ]
                then
                    dateobs=$(grep "^DATE-OBS=" $wcs | tr -d "'" | awk '{print $2}')
                    test "$dateobs" && jd=$(ut2jd $(echo $dateobs | tr -d '-' | \
                        awk -F "T" '{print $2" "substr($1,3)}'))
                fi
                dsec=$(echo $jd $jdref | awk '{print ($1-$2)*24*3600}')
                if [ "${omove/@/}" == "$omove" ]
                then
                    # omove=dx,dy
                    crpix1=$(grep "^CRPIX1  =" $wcs | \
                        awk -v s=$dsec -v m=${omove%,*} '{printf("%.2f", $3+m*s/60)}')
                    crpix2=$(grep "^CRPIX2  =" $wcs | \
                        awk -v s=$dsec -v m=${omove#*,} '{printf("%.2f", $3+m*s/60)}')
                else
                    # omove=dr@pa with respect to true wcs
                    # TODO: use true wcs pixscale, add xy to get_wcsrot
                    crpix1=$(grep "^CRPIX1  =" $wcs | awk -v s=$dsec -v r=$rot \
                        -v rimg=$(get_wcsrot $wcs) -v p=$pixscale -v m=$omove '{
                            split(m,a,/@/); r=(a[2]-r-rimg)*3.14159/180
                            printf("%.2f", $3-a[1]*sin(r)*s/3600/p)}')
                    crpix2=$(grep "^CRPIX2  =" $wcs | awk -v s=$dsec -v r=$rot \
                        -v rimg=$(get_wcsrot $wcs) -v p=$pixscale -v m=$omove '{
                            split(m,a,/@/); r=(a[2]-r-rimg)*3.14159/180
                            printf("%.2f", $3+a[1]*cos(r)*s/3600/p)}')
                fi
                test "$verbose" -gt 0 &&
                    echo $img crpix1=$crpix1 crpix2=$crpix2 >&2
            fi
            
            # convert pnm to fits
            clist=""
            if is_pgm $img
            then
                if [ -f bgvar/$(basename ${img%.*}).bgdiff.$inext ]
                then
                    convert bgvar/$(basename ${img%.*}).bgdiff.$inext \
                        -resize ${w}x${h}! - | \
                        pnmccdred -a $bgdiffzero -d - $img - | \
                        pnmtomef - > $wdir/$n.gray.fits
                else
                    pnmtomef $img  > $wdir/$n.gray.fits
                fi
                clist="gray"
                if [ "$do_bayer" ]
                then
                    clist="red grn blu"
                    for c in $clist
                    do
                        ln -s $wdir/$n.gray.fits $wdir/$n.$c.fits
                    done
                fi
            else
                if [ -f bgvar/$(basename ${img%.*}).bgdiff.$inext ]
                then
                    convert bgvar/$(basename ${img%.*}).bgdiff.$inext \
                        -resize ${w}x${h}! - | \
                        pnmccdred -a $bgdiffzero -d - $img - | ppmtorgb3
                else
                    cat ${img%.*}$insuffix.${img##*.} | ppmtorgb3
                fi
                clist="red grn blu"
                for c in $clist
                do
                    pnmtomef noname.$c > $wdir/$n.$c.fits
                    rm noname.$c
                done
            fi
            
            # create/modify wcs header with appropriate reference pixel
            if [ "$omove" ] && [ "$jdref" ]
            then
                for c in $clist
                do
                    cat $wcs | awk -v x=$crpix1 -v y=$crpix2 '{
                        if ($1=="CRPIX1") {printf("CRPIX1  = %s\n", x); next}
                        if ($1=="CRPIX2") {printf("CRPIX2  = %s\n", y); next}
                        print $0}' > $wdir/$n.$c.head
                done
            else
                for c in $clist
                do
                    if [ "$do_not_register" ]
                    then
                        grep -vE "^CRVAL|^CD[12]_|^PV[12]_|^AST.RMS|^END" $wcs \
                            > $wdir/$n.$c.head
                        echo "\
CRVAL1  =      10.0     / World coordinate on this axis
CD1_1   =      -0.0003  / Linear projection matrix
CD1_2   =      0.0      / Linear projection matrix
CRVAL2  =      0.0      / World coordinate on this axis
CD2_1   =      0.0      / Linear projection matrix
CD2_2   =      0.0003   / Linear projection matrix
" >> $wdir/$n.$c.head
                    else
                        cp $wcs $wdir/$n.$c.head
                    fi
                done
            fi
                        
            # create weight maps
            #### TODO: use $iweight
            # unity weight map used if no badimg exists
            if [ $n -eq 1 ]
            then
                if [ "$do_bayer" ]
                then
                    echo -e "P2\n2 2\n1\n0 0 0 1" | \
                        pnmtile $w $h - | pnmtomef - > $wdir/red.weight.fits
                    echo -e "P2\n2 2\n1\n0 1 1 0" | \
                        pnmtile $w $h - | pnmtomef - > $wdir/grn.weight.fits
                    echo -e "P2\n2 2\n1\n1 0 0 0" | \
                        pnmtile $w $h - | pnmtomef - > $wdir/blu.weight.fits
                else
                    echo -e "P2\n2 2\n1\n1 1 1 1" | \
                        pnmtile $w $h - | pnmtomef - > $wdir/gray.weight.fits
                fi
            fi
            
            # combine individual bad region masks with (per set) bad pixel image
            badimg="bgvar/"$(basename ${img%.*}.bad.png)
            test $verbose -gt 0 && test -f $badimg &&
                echo "using badimg $(identify $badimg | cut -d ' ' -f1-3)" >&2
            if [ -f $badimg ] && [ "$badpix" ]
            then
                convert $badimg $badpix -evaluate-sequence max $badtmp
            else
                if [ -f $badimg ]
                then
                    cp $badimg $badtmp
                else
                    if [ "$badpix" ]
                    then
                        cp $badpix $badtmp
                    else
                        echo -e "P2\n1 1\n1\n0" | pnmtile $w $h > $badtmp
                    fi
                fi
            fi
            test ! "$do_bayer" &&
                convert $badtmp -negate -depth 1 pbm: | \
                    pnmtomef - > $wdir/$n.gray.weight.fits
            for c in $clist
            do
                if [ "$do_bayer" ]
                then
                    convert $badtmp -negate $wdir/$c.weight.fits \
                        -compose Multiply -composite -depth 1 pbm: | \
                        pnmtomef - > $wdir/$n.$c.weight.fits
                else
                    test ! -f $wdir/$n.$c.weight.fits &&
                        ln -s $wdir/$n.gray.weight.fits $wdir/$n.$c.weight.fits
                fi
                ln -s $wdir/$n.$c.head $wdir/$n.$c.weight.head
            done
            test -z "$wopts" && wopts="-weight_type map_weight"

            # if requested use image size from first image
            if [ -z "$imgsize" ] && [ -z "$use_full_size" ]
            then
                sopts="-image_size $(identify ${img%.*}$insuffix.${img##*.} | \
                    cut -d " " -f3 | tr 'x' ' ' | awk -v x=$xyscale '{
                        printf("%d,%d\n", $1*x, $2*x)}')"
            fi
        done

        # combine images
        #   n is number of all (good) images in set
        swarp -d > $conf
        for c in $clist
        do
            echo "stacking on $c ($(date +"%H:%M:%S")) ..." >&2
            for out in $outlist
            do
                case "$out" in
                    "${sname}a$outsuffix")
                        flist=$(ls -tr $wdir/[0-9]*.$c.fits | head -$((n/2)));;
                    "${sname}b$outsuffix")
                        flist=$(ls -tr $wdir/[0-9]*.$c.fits | tail -$((n - n/2)));;
                    *)  flist="$wdir/[0-9]*.$c.fits";;
                esac
                    
                test "$AI_DEBUG" &&
                    echo "swarp -c $conf $sopts $wopts $param $setparam $sparam $flist" >&2
                swarp -c $conf $sopts $wopts $param $setparam $sparam $flist
                if [ $? -ne 0 ]
                then
                    echo "ERROR: swarp failed" >&2
                    test -z "$AI_DEBUG" &&
                    echo "failed command: swarp -c $conf $sopts $wopts" \
                        "$param $setparam $sparam $flist" >&2 &&
                    return 255
                fi
                (test "$c" == "grn" || test "$c" == "gray") &&
                    imhead -z coadd.fits > $out.head &&
                    cp coadd.weight.fits $out.weight.fits &&
                    rm -f $out.weight.fits.gz &&
                    gzip $out.weight.fits
                test "$do_bayer" && test "$c" != "grn" &&
                    imhead -z coadd.fits > $out.$c.head &&
                    cp coadd.weight.fits $out.$c.weight.fits &&
                    rm $out.$c.weight.fits.gz &&
                    gzip $out.$c.weight.fits
                test "$do_bayer" && mv swarp.xml swarp.$c.xml
                sethead coadd.fits datamin=0 datamax=65535
                meftopnm coadd.fits > $out.$c.pgm
                rm -f coadd.fits coadd.weight.fits
            done
        done
        for out in $outlist
        do
            case "$out" in
                "${sname}a$outsuffix")  x=$((n/2));;
                "${sname}b$outsuffix")  x=$((n - n/2));;
                *)                      x=$n;;
            esac
            set_header $out.head NEXP="$x/Number of stacked exposures"

            test "$filter" &&
                set_header $out.head FILTER="$filter/Filter name"
            test "$binning" &&
                set_header $out.head BINNING=$binning
            test "$pierside" &&
                set_header $out.head PIERSIDE=$pierside
            test "$imgroll" &&
                set_header $out.head IMGROLL='Y'
            test "$omove" &&
                set_header $out.head OMOVE="$omove/Object movement in pix/hr"
            test "$badpix" &&
                set_header $out.head BADPIX="$badpix/Global badpixel mask"
            test "$magzero" &&
                set_header $out.head MAGZERO="$magzero/Arbitrary magnitude zero point (1ADU, 1s)"
            # mean MJD_OBS of all images
            test "$jdmean" &&
                set_header $out.head MJD_OBS="$jdmean/Mean JD of stacked images" &&
                set_header $out.head JD="$jdmean/Mean JD of stacked images"
            # MJD_OBS of reference image
            test "$nref" &&
                set_header $out.head NREF="$nref/Reference image"
            test "$jdref" &&
                set_header $out.head MJD_REF="$jdref/JD of reference image"
            
            # reformat some header keywords
            x=$(get_header -q $out.head EXPTIME)
            test "$x" && set_header $out.head EXPTIME=$(echo $x | awk '{printf("%.2f", 1*$1)}')

            if is_pgm $img
            then
                mv $out.gray.pgm $out.pgm
            else
                # combine color channels into RGB
                rgb3toppm $out.red.pgm $out.grn.pgm $out.blu.pgm > $out.ppm &&
                    test ! "$AI_DEBUG" && rm $out.red.pgm $out.grn.pgm $out.blu.pgm
            fi
        done
        
        (test $verbose -gt 0 || test "$AI_DEBUG") && du -m $wdir
        test "$AI_DEBUG" || for c in $clist
        do
            rm -f $wdir/[0-9]*.$c.{fits,head} $wdir/[0-9]*.$c.weight.{fits,head}
        done
        test "$AI_DEBUG" || rm -f $wdir/{gray,red,grn,blu}.weight.fits
        test "$AI_DEBUG" || rm -f $wdir/*.gray.weight.fits
    done < $sdat
    rm -f $imlist $conf $badtmp coadd.fits coadd.weight.fits
    test "$AI_DEBUG" || rmdir $wdir
    test "$has_image_args" && rm $sdat
    return $retval
}


AIstiff () {
    local showhelp
    local bits=8
    local outfile
    local i
    for i in 1 2 3
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-o" && outfile=$2 && shift 2
        test "$1" == "-16" && bits=16 && shift 1
    done
    local img=$1
    local max=${2:-"0.995"}
    local gamfactor=${3:-"0.7"}
    local colorsat=${4:-"2.2"}
    local gamma=${5:-"2.2"}
    local min=${6:-"0.01"}
    local sopts=${7:-""}  # additional options passed to stiff
    local b=${img%\.*}
    
    (test "$showhelp" || test $# -lt 1) &&
        echo "usage: AIstiff [-16] [-o outfile] <img> [max|$max] [gamfactor|$gamfactor]" \
            "[colorsat|$colorsat] [gamma|$gamma] [min|$min] [sopts]" >&2 &&
        return 1

    test -z "$outfile" && outfile=$b.tif
    ppmtorgb3 $img
    for c in red grn blu
    do
        pnmtomef $b.$c > $b.$c.fits
    done
    sopts="-MIN_LEVEL $min -MAX_LEVEL $max -GAMMA $gamma -GAMMA_FAC $gamfactor \
        -COLOUR_SAT $colorsat -BITS_PER_CHANNEL $bits $sopts"
    stiff $sopts -OUTFILE_NAME $outfile $b.red.fits $b.grn.fits $b.blu.fits
    rm $b.{red,grn,blu} $b.{red,grn,blu}.fits
}


# aperture photometry using objects from catalog (id x y) or ds9 region file
# output fields: id  x y  r g b  n nbg bgg sdg gerr
AIaphot () {
    local showhelp
    local drgb=0        # brighten star magnitudes by this values (sep. by comma)
    local precision=2   # number of digits after decimal point
    local do_bg_only    # if set then only bg measurement is returned
    local i
    for i in 1 2 3 4
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-a" && drgb=$2    && shift 2
        test "$1" == "-p" && precision="$2" && shift 2
        test "$1" == "-bg" && do_bg_only=1 && shift 1
    done
    local img="$1"      # image to be measured
    local xydat="$2"    # object catalog with lines id x y or ds9 region file
    local rad=${3:-"3"} # aperture radius or radii for aperture ring <r1>,<r2>
    local gap=${4:-""}  # gap between aperture and bg region
    local bgwidth=${5:-""} # bg annulus width
    local idcol=1
    local xcol=2
    local ycol=3
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpxy=$(mktemp "$tdir/tmp_xyorreg.XXXXXX.dat")
    local tmpxy1=$(mktemp "$tdir/tmp_xy1.XXXXXX.dat")
    local tmpxy2=$(mktemp "$tdir/tmp_xy2.XXXXXX.dat")
    local opts
    local cmd
    local hdr
    local texp
    local nexp
    local gain=1.0      # default detector gain in e-/ADU
    local mygain
    local magzero
    local id
    local x
    local y
    local z
    local line
    local pid1
    local pid2

    # set gap used in aperture photometry according to aprad
    test -z "$gap" && gap=$(echo $rad | awk '{printf("%.1f", 1.5+$1/2)}')
    test -z "$bgwidth" && bgwidth=$(echo $rad | awk '{printf("%.1f", 2.3+$1/4)}')

    (test "$showhelp" || test $# -lt 2) &&
        echo -e "usage: AIaphot [-a dr,dg,db] [-p prec] <img> <xydat> [rad|$rad] [gap|$gap]" \
            "[bgwidth|$bgwidth]" >&2 &&
        return 1

    test ! -f "$img" &&
        echo "ERROR: image $img not found." >&2 && return 255
    test "$xydat" != "-" && test ! -f "$xydat" &&
        echo "ERROR: object catalog $xydat not found." >&2 && return 255
    cat $xydat > $tmpxy
    if $(head -1 $tmpxy | grep -qi "region file")
    then
        reg2xy $img $tmpxy | sed 'n; d' > $tmpxy1
        reg2xy $img $tmpxy | sed '1d; n; d' > $tmpxy2
    else
        cat $tmpxy | sed 'n; d' > $tmpxy1
        cat $tmpxy | sed '1d; n; d' > $tmpxy2
    fi
    
    # try to read some keywords from $img.head
    hdr=${img%.*}.head
    texp=""     # exposure time in sec
    nexp=""     # number of exposures that have been averaged
    mygain=""   # effective gain
    magzero=""  # magzero for texp=1
    if [ -f $hdr ]
    then
        texp=$(grep    "^EXPTIME" $hdr | tr '=' ' ' | awk '{if ($2>0) printf("%d", 1*$2)}')
        nexp=$(grep    "^NEXP"    $hdr | tr '=' ' ' | awk '{if ($2>0) printf("%d", $2)}')
        mygain=$(grep  "^GAIN"    $hdr | tr '=' ' ' | awk '{if ($2>0) printf("%.3f", 1*$2)}')
        magzero=$(grep "^MAGZERO" $hdr | tr '=' ' ' | awk '{if ($2>0) printf("%.2f", $2)}')
    fi
    test -z "$texp"    && texp=1
    test -z "$nexp"    && nexp=1
    test -z "$mygain"  && mygain=$gain
        
    # read data from environment
    #saturation=$(get_param camera.dat satur ${setname%.*} AI_SATURATION $saturation)
    test "$AI_GAIN"     && mygain=$AI_GAIN
    test "$AI_MAGZERO"  && magzero=$AI_MAGZERO
    test -z "$magzero" &&
        echo "ERROR: magzero unknown." >&2 && return 255
    if [ "$do_bg_only" ]
    then
        opts="-bg"
        echo "# texp=$texp nexp=$nexp gain=$mygain magzero=$magzero drgb=$drgb"
        echo "# id         bgr    bgg    bgb     nbg   sdr  sdg  sdb"
    else
        echo "# texp=$texp nexp=$nexp gain=$mygain magzero=$magzero drgb=$drgb"
        echo "# id        x       y        r     g     b       n  nbg   bgg sdg gerr$nexp"
    fi
    
    # exposure time of single exposure
    texp=$(echo $texp $nexp | awk '{printf("%f", $1/$2)}')
    
    cat $tmpxy1 | awk -v cid=$idcol -v cx=$xcol -v cy=$ycol '{
        if ($1~/^#/) next
        if (cid>NF || cx>NF || cy>NF) next
        printf("%s %s %s # %s\n", $cid, $cx, $cy, $0)
    }' | \
    while read id x y z
    do
        line=$(aphot $opts -p $precision -t $texp -m $magzero -g $mygain -d $drgb \
            $img $x","$y $rad $gap $bgwidth)
        test "${line:0:1}" != "#" && printf "%-10s  %s\n" $id "$line"
        test "${line:0:1}" == "#" && printf "# %-10s  %s\n" $id "${line:2}"
    done &
    pid1=$!

    cat $tmpxy2 | awk -v cid=$idcol -v cx=$xcol -v cy=$ycol '{
        if ($1~/^#/) next
        if (cid>NF || cx>NF || cy>NF) next
        printf("%s %s %s # %s\n", $cid, $cx, $cy, $0)
    }' | \
    while read id x y z
    do
        line=$(aphot $opts -p $precision -t $texp -m $magzero -g $mygain -d $drgb \
            $img $x","$y $rad $gap $bgwidth)
        test "${line:0:1}" != "#" && printf "%-10s  %s\n" $id "$line"
        test "${line:0:1}" == "#" && printf "# %-10s  %s\n" $id "${line:2}"
    done &
    pid2=$!
    wait $pid1 $pid2
    
    test "$AI_DEBUG" || rm -f $tmpxy
}


# match objects between AIaphot photometry output file and vizier catalog
# using their id
# print lines to stdout, fields: $id $x $y $b $g $r $bref vref
AIphotmatch () {
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    local photcat=$1
    local vizcat=$2
    local cattype=$3    # e.g. tycho2
    #local colcorr=${4:-"0"}   # mag = vmag + <colorcorr>*(bmag-vmag)
    local cid
    local cbmag
    local cvmag
    local crmag
    local cbvmag    # B-V column
    local cvrmag    # V-R column
    local delim
    
    (test "$showhelp" || test $# -lt 3) &&
        echo "usage: AIphotmatch <photcat> <vizcat> <cattype>" >&2 &&
        return 1
    # TODO: determine vizier catalog type and related columns using refcat.dat
    # cid=0   ... use line number
    # c?mag=0 ... mag undefined
    delim="|"
    case "$cattype" in
        tycho2) cid=1,2; cbmag=6;  cvmag=7;  crmag=0;;
        gspc2)  cid=1;   cbmag=5;  cvmag=8;  crmag=11;;
        nomad)  cid=1;   cbmag=10; cvmag=12; crmag=14;;
        apass)  cid=0;   cbmag=8;  cvmag=6;  crmag=12;   delim=",";;
        *)      echo "ERROR: unsupported catalog type $cattype." >&2
                return 255;;
    esac

    echo "# id      x       y        bmag  gmag  rmag   bcat   vcat   rcat"
    while read id x y r g b z
    do
        test "${id:0:1}" == "#" && continue
        test -z "$b" && continue
        # TODO: deal with B-V and V-R columns
        bvr=$(cat $vizcat | grep -v -E -- "---|^#|^$" | \
            awk -F $delim -v id=$id -v cid=$cid -v cb=$cbmag -v cv=$cvmag -v cr=$crmag '{
                catid=""
                if (cid == "0") {
                    catid=sprintf("LN%06d", NR)
                } else {
                    ncid=split(cid,a,",")
                    for (i=1; i<=ncid; i++ ) {
                        sub(/^[[:space:]]*/,"",$a[i])
                        sub(/[[:space:]]*$/,"",$a[i])
                        catid=catid""$a[i]
                    }
                }
                if (catid==id) {
                    b=$cb; if (b~/^[ ]*$/ || b~/[a-zA-Z]/) b="-"
                    v=$cv; if (v~/^[ ]*$/ || v~/[a-zA-Z]/) v="-"
                    if (cr>0) {
                        r=$cr; if(r~/^[ ]*$/ || r~/[a-zA-Z]/) r="-"
                    } else {
                        r="-"
                    }
                    print b" "v" "r
                }
            }')
        echo $id $x $y $b $g $r $bvr | awk '{
            printf("%-8s  %7.2f %7.2f  %5.2f %5.2f %5.2f  %6s %6s %6s\n",
                $1, $2, $3, $4, $5, $6, $7, $8, $9)}'
    done < $photcat
}


# calibrate aperture photometry
# TODO: deal with image orientation pa!=0 when computing extinction correction
# for coord. trans ref.: http://star-www.st-and.ac.uk/~fv/webnotes/chapter7.htm
AIphotcal () {
    # note: as of airfun version 4 it requires gnuplot version 5
    local showhelp
    local color="V"     # color band name (V|B|R)
    local citerm=""     # color index term (e.g. B-V or V-R) 
    local skip=""       # refcat id's of neglected objects separated by space
    local cxy           # object center <x>,<y> (in fits coordinates)
    local rlim          # max. distance (in pix) from object
    local nlim=100      # max. number of stars in sextractor source cat (starting
                        #   at brightest)
    local mlim          # aphot mag limit used for final curve fit
    local magerrlim=0.05
    local fittype=0     # 0-normal, 1-color, 2-ext, 3-color+ext
    local zangle        # position angle of zenith with respect to N
    local maxdist=2     # max distance for position matching in pixels
    local no_update     # if set do not save results in header keywords
    local codir="comet"
    local i
    for i in $(seq 1 17)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-B" && color="B" && shift 1
        test "$1" == "-V" && color="V" && shift 1
        test "$1" == "-R" && color="R" && shift 1
        test "$1" == "-s" && skip="$2" && shift 2
        test "$1" == "-r" && rlim="$2" && shift 2
        test "$1" == "-n" && nlim="$2" && shift 2
        test "$1" == "-c" && cxy="$2" && shift 2
        test "$1" == "-m" && magerrlim="$2" && shift 2
        test "$1" == "-e"  && fittype=$((fittype+2)) && shift 1    # extinction
        test "$1" == "-bv" && citerm="B-V" && fittype=$((fittype+1)) && shift 1 # color correction
        test "$1" == "-vr" && citerm="V-R" && fittype=$((fittype+1)) && shift 1 # color correction
        test "$1" == "-z" && zangle="$2" && shift 2
        test "$1" == "-l" && mlim="$2" && shift 2
        test "$1" == "-d" && maxdist="$2" && shift 2
        test "$1" == "-t" && no_update=1 && shift 1
    done
    local setname=${1:-""}
    local catalog=${2:-""}  # e.g. tycho2
    local aprad=${3:-""}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmp1=$(mktemp "$tdir/tmp_dat1.XXXXXX.dat")
    local tmp2=$(mktemp "$tdir/tmp_dat2.XXXXXX.dat")
    local tmpbright=$(mktemp "$tdir/tmp_bright.XXXXXX.dat")
    local tmpgp=$(mktemp "$tdir/tmp_gp.XXXXXX.gp")
    local tmpres=$(mktemp "$tdir/tmp_res.XXXXXX.txt")
    local head
    local whead
    local scat
    local inext
    local fwhm
    local gap
    local centerdeg
    local size
    local opts
    local texp
    local nexp
    local magzero
    #local pixscale
    local flen
    local xoff=0
    local yoff=0
    local apcolumn
    local refcolumn
    local ct1column  # id of column used by color term (minuend)
    local ct2column  # id of column used by color term (subtrahend)
    local amcolumn=10
    local gapcorr
    local refmd
    local colormd=0
    local nstars
    # local apmagmd
    local w
    local h
    local c
    local x
    local r
    local str
    local yrange
    local delim
    local coreg
    local rescol
    local refxydat
    local refxyreg
    local skip2
    local skip3
    local magrms
    local afit
    local bfit
    local cfit
    local efit
    local aidx
    local pidx
    local comag
    #local codia
    local stmlim
    local clist
    local rot
    local tel
    local nlow
    local nskip
    local sd
    local gpversion
    local paramchange

    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: AIphotcal [-B|-V|-R] [-bv|-vr] [-t] [-e] [-z zangle] [-s skip] [-l maglim] [-d maxdist]" \
            "[-m magerrlim|$magerrlim] [-n nlim] [-r rlim] [-c xc,yc] <set> <refcat> <aprad>" >&2 &&
        return 1

    # checkings
    head=$setname.head
    test ! -f "$head" &&
        echo "ERROR: image header file $head not found." >&2 && return 255
    whead=$setname.wcs.head
    test ! -f "$whead" &&
        echo "ERROR: image wcs header file $whead not found." >&2 && return 255
    scat=$codir/$setname.src.dat
    test ! -f "$scat" &&
        echo "WARNING: source catalog $scat not found, trying $setname.src.dat." >&2 &&
        scat=$setname.src.dat
    test ! -f "$scat" &&
        echo "ERROR: source catalog $scat not found." >&2 && return 255

    # check for input image
    inext=""
    test -f ${setname}.pgm   && inext="pgm"
    test -f ${setname}.ppm   && inext="ppm"
    test -z "$inext" &&
        echo "ERROR: no input image ${setname}.p[gp]m found." >&2 && return 255

    # check gnuplot version
    gpversion=$(gnuplot -V | awk '{printf("%s", $2)}')
    case "$gpversion" in
        5*) ;;
        *)  echo "ERROR: unsupported gnuplot version $gpversion." >&2
            return 255
    esac
    
    # set columns of aperture photometry file according to color
    case "$color" in
        B)  apcolumn=4; refcolumn=7;;
        V)  apcolumn=5; refcolumn=8;;
        R)  apcolumn=6; refcolumn=9;;
        *)  echo "ERROR: unknown color $color." >&2 && return 255;;
    esac
    # set columns of aperture photometry file to use in color index term
    case "$citerm" in
        B-V) ct1column=7; ct2column=8;;
        V-R) ct1column=8; ct2column=9;;
        *)  test "$citerm" && echo "ERROR: unknown color term $citerm." >&2 && return 255;;
    esac

    # determine magzero
    texp=""
    nexp=""
    magzero=""
    texp=$(grep    "^EXPTIME" $head | tr '=' ' ' | awk '{if ($2>0) printf("%d", 1*$2)}')
    nexp=$(grep    "^NEXP"    $head | tr '=' ' ' | awk '{if ($2>0) printf("%d", $2)}')
    magzero=$(grep "^MAGZERO" $head | tr '=' ' ' | awk '{if ($2>0) printf("%.2f", $2)}')
    tel=$(get_header -q $head AI_TELID)
    test -z "$texp"    && texp=1
    test -z "$nexp"    && nexp=1
    texp=$(echo $texp $nexp | awk '{printf("%f", $1/$2)}')
    test "$AI_MAGZERO" && magzero=$AI_MAGZERO
    if [ -z "$magzero" ] && [ "$tel" ]
    then
        magzero=$(get_param camera.dat magzero $tel)
    fi
    test -z "$magzero"    &&
        echo "ERROR: magzero unknown." >&2 && return 255
    
    # determine pixscale
    #pixscale=$(get_wcspscale $whead)
    #test -z "$pixscale" &&
    #    echo "ERROR: pixscale unknown." >&2 && return 255


    test -d phot || mkdir phot

    # calculate image size (degrees)
    size=$(echo $(imsize $setname.$inext) $(get_wcspscale $whead) | \
        awk '{printf("%.1fx%.1f", $1*$3/3600, $2*$3/3600)}')
    test "$AI_DEBUG" && echo "size=$size" >&2

    # old: set rlim for wide field images >3 deg to 1/6 diagonale
    # new 150828: set rlim to 1/6 diagonale, 150922: 1/4 diagonale
    test -z "$rlim" &&
        rlim=$(echo ${size/x/ } $(get_wcspscale $whead) | awk '{
            dia=sqrt($1*$1+$2*$2); m=0.25
            if (dia > 4) m=0.22
            if (dia > 6) m=0.19
            if (dia > 8) m=0.17
            if (dia > 12) m=0.16
            printf("%d", m*dia*3600/$3)}')
    # search radius for catalog query
    radius=$(echo $size | awk -F "x" '{x=0.4*sqrt($1*$1+$2*$2); printf("%.1f", x+0.1)}')
    #radius=$(echo $rlim $(get_wcspscale $whead) | awk '{x=$1*$2/3600; fmt="%.2f"
    #    if(x>2) {fmt="%.1f"}; if(x>20) {fmt="%.0f"}; printf(fmt, x)}')

    # get center of comet cxy=<xfits>,<yfits>, if comet/$setname.cometin.reg
    # exists, image center otherwise
    w=$(identify $setname.$inext | cut -d " " -f3 | cut -d "x" -f1)
    h=$(identify $setname.$inext | cut -d " " -f3 | cut -d "x" -f2)
    coreg=""
    test -f comet/$setname.comet.reg && coreg=comet/$setname.comet.reg
    test -z "$coreg" && test -f comet/$setname.cometin.reg && coreg=comet/$setname.cometin.reg
    if [ -z "$cxy" ] && [ "$coreg" ] && grep -q "^polygon(" $coreg
    then
        # TODO: check for single object
        echo "# get object center from $coreg" >&2
        cxy=$(grep "^polygon(.*)" $coreg | tr '(),' ' ' | awk '{
            x1=$2; x2=$2; y1=$3; y2=$3
            for (i=4;i<=NF;i++) {
                if (i%2==0) {
                    if($i<x1) x1=$i; if($i>x2) x2=$i
                } else {
                    if($i<y1) y1=$i; if($i>y2) y2=$i
                }
            }
            #printf("%s %s   %s %s\n", x1, x2, y1, y2)
            printf("%.0f,%.0f\n", (x1+x2)/2, (y1+y2)/2)}')
    fi
    test -z "$cxy" && cxy=$((w/2))","$((h/2))

    # get fwhm
    fwhm=$(get_header -q $head AI_FWHM)
    if [ -z "$fwhm" ] && [ -f $scat ]
    then
        fwhm=$(sexselect -s $scat "" 0.03 $rlim "$cxy" "" 0 | \
            grep FWHM_IMAGE | awk '{if($7>3) printf("%.2f", $2)}')
    fi
    test -z "$fwhm" &&
        echo "ERROR: unknown FWHM." >&2 && return 255

    # determine aprad and gap
    test -z "$aprad" && aprad=$(echo $fwhm | awk '{printf("%.1f", 3*sqrt($1+1)+0.1*$1-2.0)}')
    test -z "$aprad" &&
        echo "ERROR: cannot determine aprad." >&2 && return 255
    gap=$(echo $aprad | awk '{printf("%.1f", 2+$1/2.5)}')
    echo "# aprad=$aprad  gap=$gap  size=${size}deg  rlim=$rlim  radius=${radius}deg cxy=$cxy" >&2

    # download reference stars
    centerdeg=$(echo "object ${cxy//,/ }" | xy2rade - $whead | awk '{printf("%s %s", $1, $2)}')
    echo "# centerdeg=$centerdeg" >&2
    #echo $centerdeg >&2
    if [ -s phot/$setname.$catalog.dat ]
    then
        echo "reusing photometric reference catalog phot/$setname.$catalog.dat" >&2
    else
        case "$catalog" in
            apass)  url="https://www.aavso.org/cgi-bin/apass_download.pl"
                    ! check_url $url &&
                        echo "ERROR: unable to retrieve reference catalog stars." >&2 &&
                        return 255
                    set - $centerdeg
                    opts="ra=$1&dec=$2&radius=$radius"
                    echo "opts=$opts" >&2
                    wget -O $tmp1 "$url?$opts&outtype=1"
                    cat $tmp1 | awk -F ',' '{if ($6!~/NA/){print $0}}' | \
                        LANG=C sort -t ',' -k6,6 | head -5000 > phot/$setname.$catalog.dat;;
            *)      mkrefcat -n 5000 $catalog $centerdeg $radius > phot/$setname.$catalog.dat;;
        esac
        test -z "before_150911" && case $catalog in
            tycho2)     method="vget"; opts="-b $size -n 1000 -s VTmag";;
            gspc2)      method="vget"; opts="-b $size -n 1000 -s Vmag -o Vmag=<18";;
            nomad)      method="vget"
                        test "$rlim" &&
                            size=$(echo $rlim $(get_wcspscale $whead) | \
                            awk '{x=2*$1*$2/3600+0.05; printf("%.1fx%.1f", x, x)}')
                        opts="-b $size -n 1000 -s Rmag -o \"Rmag=<17\"";;
            apass)      method="apass";;
            *)          echo "ERROR: unsupported catalog $catalog." >&2
                        return 255;;
        esac
        test -z "before_150911" && case $method in
            vget)       test "$AI_DEBUG" && echo "vget.sh $opts $catalog" \
                            "$centerdeg > phot/$setname.$catalog.dat" >&2
                        vget.sh $opts $catalog $centerdeg > phot/$setname.$catalog.dat;;
            apass)      url="https://www.aavso.org/cgi-bin/apass_download.pl"
                        x=$(echo $rlim $(get_wcspscale $whead) | awk '{printf("%.2f", $1*$2/3600)}')
                        set - $centerdeg
                        opts="ra=$1&dec=$2&radius=$x"
                        echo "opts=$opts" >&2
                        wget -O phot/$setname.$catalog.dat "$url?$opts&outtype=1";;
            *)          echo "ERROR: no catalog retrival method for $catalog." >&2
                        return 255;;
        esac
    fi
    test ! -s phot/$setname.$catalog.dat &&
        echo "ERROR: empty reference star catalog." >&2 && return 255
    grep -q "^#INFO.*Error" phot/$setname.$catalog.dat &&
        echo "ERROR: catalog error, please check phot/$setname.$catalog.dat" >&2 && return 255

    # get index of photometric calibration data set
    clist=$(get_header $head all | grep "^AP_PCAT[1-9]=" | cut -c8 | sort -nu)
    c=0
    test "$clist" && for c in $clist
    do
        x=$(get_header -s $head AP_PCAT$c,AP_PCOL$c | tr '\n' ';')
        test "$x" == "$catalog;$color;" &&
            has_photcal=1 &&
            pidx=$c && break
    done
    test "$has_photcal" && gapcorr=$(get_header -q $head AP_MCOR$pidx)
    test -z "$pidx" && pidx=$((c+1))
    

    # reuse existing aperture photometry if no critical parameters have changed
    paramchange=""
    test ! "$paramchange" &&
        test "$(get_header -q $head AP_RMAX$pidx)" != "$rlim" && paramchange=1 &&
        gapcorr=""
    test ! "$paramchange" &&
        test -z "$(get_header -q $head AP_NMAX$pidx)" && paramchange=1
    test ! "$paramchange" &&
        test $(get_header -q $head AP_NMAX$pidx) -lt $nlim && paramchange=1
    test ! "$paramchange" &&
        test "$(get_header -q $head AP_ARAD$pidx)" != "$aprad" && paramchange=1 &&
        gapcorr=""
    
    # aperture photometry and matching with reference catalog
    if [ -s phot/$setname.$catalog.xphot.dat ] &&
       [ phot/$setname.$catalog.xphot.dat -nt phot/$setname.$catalog.dat ] &&
       [ ! "$paramchange" ]
    then
        echo "reusing phot/$setname.$catalog.xphot.dat" >&2
    else
        echo "# matching stars ..."
        # convert photometric reference catalog
        delim="|"
        test "$catalog" == "apass" && delim=","
        if [ -f phot/$setname.$catalog.xymanu.reg ]
        then
            echo "reusing manually created phot/$setname.$catalog.xymanu.reg" >&2
            reg2xy $setname.$inext phot/$setname.$catalog.xymanu.reg > phot/$setname.$catalog.xymanu.dat
            refxyreg=phot/$setname.$catalog.xymanu.reg
            refxydat=phot/$setname.$catalog.xymanu.dat
        else
            rade2xy phot/$setname.$catalog.dat $whead $catalog "$delim" > phot/$setname.$catalog.xy.dat
            #xy2reg $setname.$inext phot/$setname.$catalog.xy.dat > phot/$setname.$catalog.xy.reg
            #sexselect -r $scat "" 0.03 "$rlim" "$cxy" | grep "^circ" | \
            #    LANG=C sort -n -k4,4 | head -$((nlim*2)) | reg2xy $setname.$inext - > $tmp1
            xy2reg $setname.$inext phot/$setname.$catalog.xy.dat $xoff $(echo "-1 * $yoff" | bc) 10 \
                > phot/$setname.$catalog.xy.reg
            refxydat=phot/$setname.$catalog.xy.dat
            refxyreg=phot/$setname.$catalog.xy.reg
        fi
        sexselect -f $scat "" $magerrlim "$rlim" "$cxy" | \
            regfilter - $refxyreg | sexselect -r - | \
            grep "^circ" | LANG=C sort -n -k4,4 | head -$((nlim*2)) | \
            reg2xy $setname.$inext - > $tmp1

        # match stars in photometric reference catalog
        # not implemented yet: eliminate stars close to image border
        # co01: eliminate stars close to border -> $setname.$catalog.xy.reg
        #        reg2xy ../$setname.$inext $setname.$catalog.xy.reg > $setname.$catalog.xy.dat
        xymatch $refxydat $tmp1 $maxdist $xoff $yoff > phot/$setname.$catalog.match.dat

        # sort by mag (from sextractor catalog)
        sort -k 1,1 $tmp1 > $tmp2
        grep -v '^#' phot/$setname.$catalog.match.dat | sort -k 9,9 | \
            join -1 9 -2 1 - $tmp2 | LANG=C sort -n -k 15,15 | head -$nlim |
            cut -d " " -f2- > $tmp1
        
        # do aperture photometry
        nstars=$(cat $tmp1 | wc -l)
        test $nstars -lt 4 &&
            echo "ERROR: only $nstars stars matched (min=4)" >&2 && return 255
        echo "# AIaphot on $nstars stars ..." >&2
        AI_MAGZERO=$magzero AIaphot $setname.$inext $tmp1 $aprad $gap > phot/$setname.$catalog.phot.dat
        test "$AI_DEBUG" && echo "AIphotmatch phot/$setname.$catalog.phot.dat" \
            "phot/$setname.$catalog.dat $catalog" >&2
        AIphotmatch phot/$setname.$catalog.phot.dat phot/$setname.$catalog.dat $catalog | \
            LANG=C sort -n -k5,5 > phot/$setname.$catalog.xphot.dat
        test $? -ne 0 &&
            echo "ERROR: failed command: AIphotmatch phot/$setname.$catalog.phot.dat" \
            "phot/$setname.$catalog.dat $catalog" >&2 && return 255
    fi
    test ! -s phot/$setname.$catalog.xphot.dat &&
        echo "ERROR: no data in phot/$setname.$catalog.xphot.dat" && return 255
    
    # flag those stars which are to be skipped during calibration
    #   inserting "#" at begin of line (phot/$setname.$catalog.xphot.dat)
    #   keep file timestamp (but change inode)
    if [ "$skip" ]
    then
        cp phot/$setname.$catalog.xphot.dat $tmp1
        for id in ${skip//,/ }
        do
            sed --follow-symlinks -i 's/^'$id' /#'$id'/' $tmp1
        done
        touch -r phot/$setname.$catalog.xphot.dat $tmp1
        mv $tmp1 phot/$setname.$catalog.xphot.dat
    fi
    
    # measure gapcorr (photometry offset with respect to large apertures)
    if [ -z "$gapcorr" ]
    then
        # select bright stars
        if [ -s $codir/$setname.psfphot.dat ]
        then
            # using psf stars within rlim
            echo "# determine gapcorr using psf stars"
            grep -v "^#" $codir/$setname.psfphot.dat | awk -v h=$h -v cx=${cxy%,*} -v cy=${cxy#*,} -v rlim=$rlim '{
                dx=$2-cx; dy=$3-(h-cy)
                d=sqrt(dx*dx+dy*dy)
                if (d<rlim) {print $0}}' > $tmpbright
        else
            # select 30 brightest stars
            # TODO: only use starlike sources
            echo "# determine gapcorr using brightest calibration stars"
            sexselect -r $scat "" $magerrlim "$rlim" "$cxy" | \
                grep "^circ" | LANG=C sort -n -k4,4 | head -50 | \
                awk -v f=$fwhm '{
                    x=$1; gsub(/[(),]/," ",x);
                    na=split(x,a," ")
                    if (a[4] < 2.7*f) print $0
                }' | head -30 | reg2xy $setname.$inext - > $tmpbright
        fi

        # photometry using different apertures
        AI_MAGZERO=$magzero AIaphot $setname.$inext $tmpbright $aprad $gap | \
            awk -v me=$magerrlim '{if($11<=2*me) print $0}' > x.phot$aprad.dat
        for r in $(echo $aprad | awk '{
            if ($1<6) {
                printf("%.1f %.1f", 1.6+1.4*$1, 6+1.8*$1)
            } else {
                printf("%.1f %.1f", 10.0+($1-6), 16.8+1.2*($1-6))
            }
            }')
        do
            AI_MAGZERO=$magzero AIaphot $setname.$inext $tmpbright $r $gap > x.phot$r.dat
            while read
            do
                test "${REPLY:0:1}" == "#" && continue
                #set - $REPLY
                #echo "$skip" | grep -qw $1 && continue
                grep -v "^#" x.phot$aprad.dat | awk -v l="$REPLY" -v c=$apcolumn '{
                    split(l,a); if($1!=a[1]) next; print $c" "a[c]-$c}'
            done < x.phot$r.dat | LANG=C sort -n -k2,2 | sed '1,3d' > $tmp2
            gapcorr=$(median $tmp2 2)
            echo "r=$r  gapcorr=$gapcorr" >&2
        done
        yrange=$(kappasigma $tmp2 2 | awk '{l=$1-5*$2-0.05; h=$1+4*$2+0.05
            printf("%.2f:%.2f", h, l)}')
        str=$setname.$catalog.$color.apcorr
        AIplot -p -o x.$str.png -t "Large Aperture Correction of Stars (m_{r$r}-m_{r$aprad}, $setname)" \
            -g "set xlabel 'mag'; set ylabel 'dmag'; set grid" $tmp2 1 2 "" "" "[][$yrange]" 
        (test -f phot/$str.png && diff -q x.$str.png phot/$str.png >/dev/null) || \
            cp -p x.$str.png phot/$str.png
    fi
    
    # if mlim is not set, use reasonable limit on faint end based
    # on number statistics of stars
    if [ ! "$mlim" ]
    then
        nstars=$(grep -v "^#"  phot/$setname.$catalog.xphot.dat | wc -l)
        if [ $nstars -gt 20 ]
        then
            nlow=$((6+nstars/5))    # includes nskip
            nskip=$((1+nstars/35))
            test $nstars -gt 50 &&
                nlow=$((13+nstars/15)) &&
                nskip=$((2+nstars/80))
            grep -v "^#" phot/$setname.$catalog.xphot.dat | \
                awk -v ca=$apcolumn '{printf("%s\n", $ca)}' | \
                LANG=C sort -n | tail -$nlow | head -$((nlow-nskip)) > $tmp1
            sd=$(stddev $tmp1)
            mlim=$(tail -1 $tmp1 | awk -v s=$sd '{printf("%.2f", $1+s+0.1)}')
            str=$(LANG=C printf "sd=%.2f" $sd)
            echo "# setting mlim=$mlim  (stats: unused=$nskip, n=$((nlow-nskip)), $str)" >&2
        else
            mlim=99
        fi
    fi
     
    # remove stars with missing ref mags
    if [ $fittype -eq 1 ] || [ $fittype -eq 3 ]
    then
        # fitting color requires color information
        # TODO allow mlim with 2 values
        grep -v "^#" phot/$setname.$catalog.xphot.dat | head -$nlim | \
            grep -vEw "^${skip// / |^} " | \
            awk -v lim=$mlim -v ca=$apcolumn -v cr=$refcolumn -v cc1=$ct1column -v cc2=$ct2column '{
                if ($ca>lim || $cr=="-" || $cc1=="-" || $cc2=="-") next
                print $0}' > $tmp1
        refmd=$(cat $tmp1 | awk -v ref=$refcolumn '{
            printf("%f\n", $ref)}' | median - 1)
        colormd=$(cat $tmp1 | awk -v cc1=$ct1column -v cc2=$ct2column '{
            printf("%f\n", $cc1-$cc2)}' | median - 1)
        echo "# refmd=$refmd colormd=$colormd" >&2
    else
        grep -v "^#" phot/$setname.$catalog.xphot.dat | head -$nlim | \
            grep -vEw "^${skip// / |^} " | \
            awk -v lim=$mlim -v ca=$apcolumn -v cr=$refcolumn '{
                if ($ca>lim || $cr=="-") next
                print $0}' > $tmp1
    fi
    nstars=$(cat $tmp1 | wc -l)
    #apmagmd=$(median $tmp1 $apcolumn)

    # add column 10 with relative altitude in degrees
    # TODO: replace column 10 with airmass
    cp $tmp1 $tmp2
    if [ "$zangle" ]
    then
        rot=$(echo $(get_wcsrot $set) $zangle | awk '{print 360+$1-$2}')
        set - $(echo "circle($cxy,5)" | reg2xy $setname.$inext -)
        xytrans -p $(get_wcspscale $setname) $tmp2 -$2 -$3 $rot > $tmp1
    else
        cat $tmp2 | sed -e 's/$/ 0/' > $tmp1
    fi
    
    # gnuplot fitting
    # e.g. map = a + b*(V-Vmd)     + c*((B-V)-(B-V)md) + e*(am-ammd)
    #      map = a + b*(ref-refmd) + c*(color-colormd) + e*(am-ammd)
    # map ... measured mag in aperture using magzero from camera.dat (dependent variable)
    # ref ... reference catalog magnitude of closest color band (independent variable x)
    # color ... reference catalog color index (independant variable y)
    # am  ... airmass at time of observation
    # note about 'using' clause: the last column reference is dependant variable
    echo "# gather statistics
    set fit quiet
    set fit errorvariables
    a=$refmd
    b=1
    c=0.01; c_err=99    # until 171118: c=0.00000001
    e=0.01; e_err=99    # until 171118. e=0.00000001
    # data fitting" > $tmpgp
    case $fittype in
        0)  # no color, no ext
            echo "
    f(x) = a + b*(x-$refmd)
    fit f(x)   '$tmp1' using $refcolumn:$apcolumn via a,b"   >> $tmpgp
            ;;
        1|3)  # color
            echo "
    f(x,y) = a + b*(x-$refmd) + c*(y-$colormd)
    fit f(x,y) '$tmp1' using $refcolumn:(\$$ct1column-\$$ct2column):$apcolumn via a,b,c" >> $tmpgp
            ;;
        2)  # ext
            echo "
    f(x,z) = a + b*(x-$refmd) + e*z
    fit f(x,z) '$tmp1' using $refcolumn:$amcolumn:$apcolumn via a,b,e" >> $tmpgp
            ;;
        99) # color + ext
            echo "
    f(x,y,z) = a + b*(x-$refmd) + c*(y-$colormd) + e*z
    fit f(x,y,z) '$tmp1' using $refcolumn:(\$$ct1column-\$$ct2column):$amcolumn:$apcolumn via a,b,c,e" >> $tmpgp
            ;;
    esac
    echo "out=sprintf(\"n=%d  rms=%.3f  a=%.3f  b=%.3f  c=%.3f  e=%.6f\", \
        FIT_NDF, FIT_STDFIT, a-b*$refmd-c*$colormd, b, c, e)
    print out
    
    # write coefficients to text file
    set print 'x.gnuplotout.txt'
    print FIT_NDF, FIT_STDFIT
    print \"a \", a-b*$refmd-c*$colormd, a_err
    print \"b \", b, b_err
    print \"c \", c, c_err
    print \"e \", e, e_err
    " >> $tmpgp
    cat $tmpgp | gnuplot -p 2>&1
   
    # get coefficients/errors from fit
    magrms=$(head -1 x.gnuplotout.txt | awk '{if (NF>=2) printf("%.3f", $2)}')
    afit=$(grep "^a " x.gnuplotout.txt | awk '{if (NF>=3) printf("%.3f,%.3f", $2, $3)}')
    bfit=$(grep "^b " x.gnuplotout.txt | awk '{if (NF>=3) printf("%.3f,%.3f", $2, $3)}')
    grep "^a " x.gnuplotout.txt | awk '{printf("  %s= %7.3f +- %.3f\n", $1, $2, $3)}'
    grep "^b " x.gnuplotout.txt | awk '{printf("  %s= %7.3f +- %.3f\n", $1, $2, $3)}'
    case $fittype in
        1|3)    cfit=$(grep "^c " x.gnuplotout.txt | awk '{if (NF>=3) printf("%.3f,%.3f", $2, $3)}')
                grep "^c " x.gnuplotout.txt | \
                awk '{printf("  %s= %7.3f +- %.3f\n", $1, $2, $3)}';;
        2|3)    efit=$(grep "^e " x.gnuplotout.txt | awk '{if (NF>=3) printf("%.3f,%.3f\n", $2, $3)}')
                grep "^e " x.gnuplotout.txt | \
                awk '{printf("  %s= %7.3f +- %.3f\n", $1, $2, $3)}';;
    esac
    
    # determine true magzero for large aperture photometry
    x=$(echo $magzero ${afit#,*} ${bfit#,*} $refmd 0        | awk '{
        printf("%.2f", $1-$2-($3-1)*$4-$5)}')
    echo "# magzero (stars) = $x"
    x=$(echo $magzero ${afit#,*} ${bfit#,*} $refmd $gapcorr | awk '{
        printf("%.2f", $1-$2-($3-1)*$4-$5)}')
    echo "# magzero (comet) = $x"
    magzero=$x
    
    # create different kinds of "residuals"
    # 1. to check linearity (assume b=1)
    # 2. to view color term (assume c=1)
    # 3. to view extinction (assume e=1)
    # output: id x y  apmag refinstr  color airmass  resid res1 res2 res3
    #    col: 1  2 3   4     5         6     7        8     9    10   11
    echo "# id      x       y        apmag refinstr  color am     res   reslin rescol resext" > $tmpres
    cat $tmp1 | awk -v cmag=$apcolumn -v cref=$refcolumn -v rmd=$refmd \
        -v cc1=$ct1column -v cc2=$ct2column -v cmd=$colormd \
        -v cam=$amcolumn \
        -v a=${afit%,*} -v b=${bfit%,*} -v c=${cfit%,*} -v e=${efit%,*} '{
            refinstr=a+b*$cref
            if (c!="") refinstr+=c*($cc1-$cc2)
            if (e!="") refinstr+=e*$cam
            reslin=$cmag-refinstr+(b-1)*($cref-rmd)
            rescol=0
            if (c!="") rescol=$cmag-refinstr+c*($cc1-$cc2-$cmd)
            resext=0
            if (e!="") resext=$cmag-refinstr+e*$cam
            printf("%-9s %7.2f %7.2f  %6.3f %6.3f  %6.3f %4.2f  %6.3f %6.3f %6.3f %6.3f\n",
                    $1, $2, $3,   $cmag, refinstr,  $cc1-$cc2, $cam,  $cmag-refinstr, reslin, rescol, resext)
        }' >> $tmpres
    #echo $tmp1; echo $tmpgp; echo $tmpres
    #return
    
    # save residuals to permanent data file
    str=$setname.$catalog.$color.resid
    (test -f phot/$str.dat && diff -q $tmpres phot/$str.dat >/dev/null) || \
        cp -p $tmpres phot/$str.dat
    r=$(echo $aprad | awk '{print $1+2}')
    xy2reg $setname.$inext phot/$setname.$catalog.$color.resid.dat "" "" $r "" "" "" 9 > x.$setname.$catalog.reg
    
    # plot residuals
    # extinction
    if [ $fittype -eq 2 ] || [ $fittype -eq 3 ]
    then
        str=$setname.$catalog.$color.ext
        grep -v "^#" $tmpres | AIplot -q -o x.$str.png \
            -t "Extinction (aprad=$aprad, $setname, $catalog)" \
            -g "set xlabel 'air mass'; set ylabel 'dmag'; set yrange [] reverse" \
            - 7 11
        (test -f phot/$str.png && diff -q x.$str.png phot/$str.png >/dev/null) || \
            cp -p x.$str.png phot/$str.png
    fi
    # color term
    str=$setname.$catalog.$color.color
    grep -v "^#" $tmpres | AIplot -q -o x.$str.png \
        -t "Color term (aprad=$aprad, $setname, $catalog)" \
        -g "set xlabel '$citerm'; set ylabel 'dmag'; set yrange [] reverse" \
        - 6 10
    (test -f phot/$str.png && diff -q x.$str.png phot/$str.png >/dev/null) || \
        cp -p x.$str.png phot/$str.png
    # linearity
    str=$setname.$catalog.$color.lin
    grep -v "^#" $tmpres | AIplot -q -p -o x.$str.png \
        -t "Photometric error (aprad=$aprad, $setname, $catalog)" \
        -g "set xlabel 'mag'; set ylabel 'mag - $color ($catalog)'; set yrange [] reverse" \
        - 4 9
    (test -f phot/$str.png && diff -q x.$str.png phot/$str.png >/dev/null) || \
        cp -p x.$str.png phot/$str.png
    # residuals
    false && (
    str=$setname.$catalog.$color.resid
    grep -v "^#" $tmpres | AIplot -q -o x.$str.png \
        -t "Residuals (aprad=$aprad, $setname, $catalog)" \
        -g "set xlabel 'mag'; set ylabel 'mag - $color ($catalog)'; set yrange [] reverse" \
        - 4 8
    (test -f phot/$str.png && diff -q x.$str.png phot/$str.png >/dev/null) || \
        cp -p x.$str.png phot/$str.png
    )

    # search for multiple matches of the same star
    # skip2 ... reference star matches multiple stars in image
    # skip3 ... multiple reference stars match same star in image
    skip2=$(grep -v "^#" phot/$setname.$catalog.xphot.dat | cut -d ' ' -f1 | sort | awk '{
        if($1==last)print $1;last=$1}')
    skip3=$(grep -v "^#" phot/$setname.$catalog.xphot.dat | sort -k2,3 | awk '{
        s=$2" "$3; if(s==last)print lastid" "$1;last=s;lastid=$1}')
    (test "$skip2" || test "$skip3") && echo "ambigeous star matches:" >&2 &&
        echo $skip2 $skip3 | tr ' ' '\n' | sort -u | tr '\n' ' ' | sed -e 's/$/\n/' >&2

    # show possible outliers
    if [ $(cat phot/$setname.$catalog.$color.resid.dat | wc -l) -ge 9 ]
    then
        rescol=9
        set - $(grep -v "^#" phot/$setname.$catalog.$color.resid.dat | tr '/' ' ' | \
            kappasigma - $rescol)
        dv=$(echo $1 | awk '{printf("%.2f", $1)}')
        x=$(echo $2 | awk '{printf("%.2f", 4*$1)}')
        grep -v "^#" phot/$setname.$catalog.$color.resid.dat | tr '/' ' ' | \
                awk -v rcol=$rescol -v dv=$dv -v lim=$x '{
                    x=$rcol+dv; if((x<-1*lim)||(x>lim)){printf("%s dm=%5.2f\n", $0, x)}
                }' > $tmp2
        test -s "$tmp2" && echo "outliers (mean mag-ref=$dv, rejection limit=$x)" >&2 &&
            cat $tmp2 >&2 &&
            cat $tmp2 | awk 'BEGIN{printf("# idlist:")}{printf(" %s", $1)}END{printf("\n")}'
    fi


    # saving results to header keywords
    # get matching index of related large aperture measurements data set
    #   unmatched/undefined is represented by value 0
    clist=$(get_header $head all | grep "^AC_ICOL[1-9]=" | cut -c8 | sort -nu)
    aidx=0
    test "$clist" && for c in $clist
    do
        x=$(get_header -s $head AC_ICOL$c | tr -d "'") # instrumental color band
        test -z "$x" && continue
        case "$x" in
            B|V|R)  test "$x" == "$color" && aidx=$c;;
            G|L)    test "$color" == "V"  && aidx=$c;;
        esac
        test $aidx -ne 0 && break
    done
    test "$clist" && test $aidx -eq 0 && test $c -eq 1 && aidx=$c
    
    # determine comet magnitude and coma diameter if appropriate
    comag=""
    #codia=""
    stmlim=""
    if [ $aidx -eq 0 ]
    then
        echo "WARNING: no matching comet measurements data found." >&2
        # trying old keywords from AI_VERSION<2.7
        x=$(get_header -s $head AI_CSUM,AI_CCORR | tr '\n' ' ' | awk '{if(NF>=1) print $1+$2}')
        test "$x" && comag=$(i2mag $x $texp $magzero  | awk '{printf("%.2f", $1)}')
        x=$(get_header -s $head AI_CGLIM)
        test "$x" && stmlim=$(i2mag $x $texp $magzero | awk '{printf("%.1f", $1)}')
        #x=$(get_header $head AI_CDIA)
        #test "$x" && is_number "$x" &&
        #    codia=$(echo $x $pixscale | awk '{printf("%4.1f", $1*$2/60)}')
    else
        echo "# using comet aperture measurements in $x color band"
        x=$(get_header -s $head AC_ASUM$aidx,AI_ACOR$aidx | tr '\n' ' ' | awk '{if(NF>=1) print $1+$2}')
        test "$x" && comag=$(i2mag $x $texp $magzero  | awk '{printf("%.2f", $1)}')
        x=$(get_header -s $head AI_ALIM$aidx)
        test "$x" && stmlim=$(i2mag $x $texp $magzero | awk '{printf("%.1f", $1)}')
        #x=$(get_header $head AC_DIAM$aidx)
        #test "$x" && is_number "$x" &&
        #    codia=$(echo $x $pixscale | awk '{printf("%4.1f", $1*$2/60)}')
    fi
    test -z "$comag" &&
        echo "WARNING: could not determine comet magnitude" >&2
    
    
    # write results
    test -z "$has_photcal" && str="writing new calibration results"
    test "$has_photcal"    && str="updating calibration results for $catalog/$color"
    str="$str (AP-index=$pidx)"
    if [ "$no_update" ]
    then
        echo "WARNING: NOT" $str >&2
    else
        echo "#" $str
        
        set_header $head \
        AP_VERS$pidx="${AI_VERSION}    / airfun version (AIphotcal)" \
        AP_AIDX$pidx="$aidx            / Index of related aperture photometry data" \
        AP_PCAT$pidx="$catalog         / Photometric reference catalog" \
        AP_PCOL$pidx="$color           / Photometric reference color band" \
        AP_RMAX$pidx="$rlim            / Search radius for catalog objects in pix" \
        AP_NMAX$pidx="$nlim            / Max. number of reference stars" \
        AP_NFIT$pidx="$nstars          / Number of valid reference stars" \
        AP_ARAD$pidx="$aprad           / Aperture radius in pix" \
        AP_RMAG$pidx="$refmd           / Reference catalog mag (median)" \
        AP_DMAG$pidx="${afit%,*}       / Mag offset from MAGZERO" \
        AP_DMER$pidx="${afit#*,}       / Mag offset error" \
        AP_SLOP$pidx="${bfit%,*}       / Slope of catalog mag vs. apphot mag" \
        AP_SLER$pidx="${bfit#*,}       / Slope error" \
        AP_MCOR$pidx="$gapcorr         / Mag correction for large aperture" \
        AP_MZER$pidx="$magzero         / Mag zero point, corrected for large aperture" \
        AP_MRMS$pidx="$magrms          / Mag residual rms"
        
        if [ "${cfit/,/}" != "$cfit" ]
        then
            set_header $head \
        AP_CIND$pidx="$citerm          / Photometric reference color index" \
        AP_CIMD$pidx="$colormd         / Color index of reference stars (median)" \
        AP_CTRA$pidx="${cfit%,*}       / Color transformation coefficient" \
        AP_CTER$pidx="${cfit#*,}       / Color transformation coefficient error"
        else
            set_header $head \
        AP_CIND$pidx="" \
        AP_CIMD$pidx="" \
        AP_CTRA$pidx="" \
        AP_CTER$pidx=""
        fi
        
        if [ "${efit/,/}" != "$efit" ]
        then
            set_header $head \
        AP_AMMD$pidx="$ammd            / Airmass of reference stars (median)" \
        AP_EXCO$pidx="${efit%,*}       / Extinction coefficient" \
        AP_EXER$pidx="${efit#*,}       / Extinction coefficient error"
        else
            set_header $head \
        AP_AMMD$pidx="" \
        AP_EXCO$pidx="" \
        AP_EXER$pidx=""
        fi
        
        if [ "$comag" ]
        then
            set_header $head \
        AP_CMAG$pidx="$comag           / Calibrated large aperture comet magnitude"
        else
            set_header $head \
        AP_CMAG$pidx=""
        fi
        
        if [ "$stmlim" ]
        then
            set_header $head \
        AP_MLIM$pidx="$stmlim          / Limiting star mag"
        else
            set_header $head \
        AP_MLIM$pidx=""
        fi
    fi

    
    #rm -f $tmp2
    test "$AI_DEBUG" && echo "$tmp1" >&2 && echo "$tmpgp" >&2
    test "$AI_DEBUG" || rm -f $tmp1 $tmp2 $tmpbright $tmpgp $tmpres fit.log
}


# extract psf from image
# additionally it creates photometry files and psf mask file
# elongated mask is used when -t <trail> are specified
# results are stored in the directory of <scat>
AIpsfextract () {
    local showhelp
    local trail     # length,angle,centerfrac - length in pix, pa in deg from
                    #   right over top, center fraction (0=start, 1=end of trail)
    local psfoff=1000        # background of resulting psf image
    local bgres=2000        # background of psf subtracted residual image
    local i
    for i in $(seq 1 3)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-b" && psfoff=$2 && shift 2
        test "$1" == "-t" && trail=$2 && shift 2
    done
    
    local img=$1
    local scat=$2           # source catalog file (sextractor output file)
                            # AIsource -q -2 -o $srccat $starstack "" 5 32 64 0.0005
    local center=${3:-""}   # xc,yc center of psf stars region in image coords
                            # (e.g. approx. comet center), default is image center
    local rlim=${4:-"10"}   # max distance from center in percent of image diameter
    local merrlim=${5:-""}  # mag error limit for field stars
    local psfsize=${6:-"128"}   # size of psf images
    local scale=${7:-"4"}   # psf oversampling factor (e.g. used by AIstarcombine)
    local nbright=30
    #local nreject=7
    local mlimpsf=0.03
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpcat=$(mktemp "$tdir/tmp_scat_XXXXXX.fits")
    local tmpdat=$(mktemp "$tdir/tmp_dat_XXXXXX.dat")
    local tmpphot=$(mktemp "$tdir/tmp_phot_XXXXXX.dat")
    local tmpreg=$(mktemp "$tdir/tmp_reg_XXXXXX.reg")
    local tmppsf=$(mktemp "$tdir/tmp_psf_XXXXXX.pnm")
    local tmpim1=$(mktemp "$tdir/tmp_im1_XXXXXX.pnm")
    local tmpim2=$(mktemp "$tdir/tmp_im2_XXXXXX.pnm")
    local ext               # image format
    local ncol              # number of colors
    local w
    local h
    local outpsf            # output psf image
    local psfphot           # output psf star photometry file
    local compphot          # output comparison star photometry file
    local subreg            # optional user provided region file to limit comphot
                            # (and star subtraction) to r<rlim and subreg
    local outresid          # output of residual file (after subtracting all stars)
    local hdr
    local texp
    local nexp
    local magzero
    local resampopts
    local rmax
    local str
    local fwhm
    local xrad
    local col
    local dmag
    local psfrgb
    local psfbg
    local psfmult
    local mcorr
    local id
    local x
    local y
    local r
    local gap

    test -z "$merrlim" && test ${rlim%.*} -gt 17 && merrlim=0.1
    test -z "$merrlim" && test ${rlim%.*} -gt 12 && merrlim=0.15
    test -z "$merrlim" && merrlim=0.2
    
    (test "$showhelp" || test $# -lt 2) &&
        echo "usage: AIpsfextract [-t trail/len,angle,cfrac] [-b $psfoff|$psfoff] <img> <srccat> [<center>]" \
            "[rlim%|$rlim] [merrlim|$merrlim] [psfsize|$psfsize] [psfoversamp|$scale]" >&2 &&
        return 1

    # checkings
    for f in $img ${img%.*}.head $scat
    do
        test ! -f $f && echo "ERROR: file $f not found." >&2 && return 255
    done
    
    
    # TODO: check image type
    ext="pgm"; ncol=1
    is_ppm $img && ext="ppm" && ncol=3
    psfphot=${scat//.*/}.psfphot.dat
    compphot=${scat//.*/}.starphot.dat
    subreg=${scat//.*/}.sub.reg
    if [ -z "$trail" ]
    then
        #outmask=${scat//.*/}.starmask.pbm
        outmask=${scat//.*/}.starmask.reg
        outresid=x.stsub.$ext
        test -z $outpsf && outpsf=${scat//.*/}.starpsf.$ext
    else
        #outmask=${scat//.*/}.trailmask.pbm
        outmask=${scat//.*/}.trailmask.reg
        outresid=x.cosub.$ext
        test -z $outpsf && outpsf=${scat//.*/}.trailpsf.$ext
    fi
    test -e ${outresid%.*}.head && rm ${outresid%.*}.head
    hdr=${img%.*}.head
    test -e $hdr && ln -s $hdr ${outresid%.*}.head
    
    # trail parameter for psf mask creation
    if [ "$trail" ]
    then
        # adjust trail parameter to psf oversampling
        set - ${trail//,/ }
        trail=$(echo $1 $2 $3 0.5 | awk -v s=$scale '{printf("-t %d,%s,%s", s*$1, $2, $3)}')
    fi
    
    # read some image header keywords
    texp=""     # exposure time in sec
    nexp=""     # number of exposures that have been averaged
    magzero=""  # magzero for texp=1
    if [ -f $hdr ]
    then
        texp=$(grep    "^EXPTIME" $hdr | tr '=' ' ' | awk '{if ($2>0) printf("%d", 1*$2)}')
        nexp=$(grep    "^NEXP"    $hdr | tr '=' ' ' | awk '{if ($2>0) printf("%d", $2)}')
        magzero=$(grep "^MAGZERO" $hdr | tr '=' ' ' | awk '{if ($2>0) printf("%.2f", $2)}')
    fi
    test -z "$texp" &&
        echo "ERROR: missing keyword EXPTIME." >&2 && return 255
    test -z "$nexp" && nexp=1

    # read data from environment
    test "$AI_MAGZERO"  && magzero=$AI_MAGZERO
    test -z "$magzero" &&
        echo "ERROR: magzero unknown." >&2 && return 255

    # exposure time of single exposure
    texp=$(echo $texp $nexp | awk '{printf("%f", $1/$2)}')

    # keep resampling type
    resampopts="$(grep '^RESAMPT1=' ${img%.*}.head | awk -F "'" '{print "-r "$2}')"
    resampopts=""   # 160928 disabled
    #'
    echo "# texp=$texp  magzero=$magzero  resampopts=$resampopts" >&2
    
    
    # -------------------------------------------
    #   extract position and brightness of stars
    # -------------------------------------------
    
    w=$(identify $img | cut -d " " -f3 | cut -d "x" -f1)
    h=$(identify $img | cut -d " " -f3 | cut -d "x" -f2)
    # convert center from image to FITS coordinates
    test "$center" &&
        center=$(echo ${center//,/ } $h | awk '{printf("%.0f,%.0f", $1-0.5, $3-$2+0.5)}')
    # if center has not been specified by the user then use image center
    test -z "$center" && center=$((w/2)),$((h/2))

    rmax=$(identify $img | cut -d " " -f3 | awk -F "x" -v r=$rlim '{
        printf("%.0f", sqrt($1*$1+$2*$2)*r/100)}')
    echo "# w=$w h=$h rmax=$rmax" >&2
    str="FWHM_IMAGE,MAG_AUTO,MAGERR_AUTO,FLAGS"
    # identify bright sources
    sexselect -x $scat "" 0.03 $rmax "$center" "NUMBER,X*,Y*,A*,$str" 0 | \
         LANG=C sort -n -k6,6 | grep -v "^#" | head -$nbright > $tmpdat
    # determine median fwhm from bright sources
    set - $(kappasigma $tmpdat 5)
    fwhm=$(echo $1 | awk '{printf("%.2f", $1)}')
    x=$(echo $2 | awk '{printf("%.2f", $1)}')
    xrad=$(echo $fwhm | awk '{printf("%.1f", 0.5+$1/4)}')
    echo "# fwhm=$fwhm"+-"$x  xrad=$xrad" >&2

    if [ -e $psfphot ] && [ $psfphot -nt $scat ]
    then
        echo "reusing existing $psfphot." >&2
    else
        # region file (stars only)
        echo -e "# Region file format: DS9 version 4.1
global color=green dashlist=8 3 width=1 font=\"helvetica 10 normal roman\" \
select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1
physical" > $tmpreg
        cat $tmpdat | awk -v w=$w -v h=$h -v f=$fwhm -v s=$x -v pw=$psfsize '{
            if ($1~/^#/) {print $0; next}
            if ($5 > 1.3*f+3*s) next
            # skip sources close to border
            margin=pw/2+2
            if (($2-0.5 < margin) || ($2-0.5 > w-margin)) next
            if (($3-0.5 < margin) || ($3-0.5 > h-margin)) next
            #r=$5-(f3*s); if (r<0) r=0; r=5+r/s+0.1*r*r/s*s
            r=2
            printf("circle(%.2f,%.2f,%.1f) # text={%s %.1f}\n", $2+0.5, h-$3+0.5, r, $1, $6)}' >> $tmpreg
        
        # create photometry data file with columns id xc yc r g b
        if [ $ncol == 3 ]
        then
            sex2rgbdat $scat $xrad $tmpreg > $psfphot 2>/dev/null
            test $? -ne 0 &&
                echo "ERROR: failed command: sex2rgbdat $scat $xrad $tmpreg" >&2 && return 255
        else
            cat $tmpdat | awk -v w=$w -v h=$h -v f=$fwhm -v s=$x -v pw=$psfsize '{
                if ($1~/^#/) {print $0; next}
                if ($5 > 1.3*f+3*s) next
                # skip sources close to border
                margin=pw/2+2
                if (($2-0.5 < margin) || ($2-0.5 > w-margin)) next
                if (($3-0.5 < margin) || ($3-0.5 > h-margin)) next
                printf("%-10s  %7.2f %7.2f  %5.2f %5.2f %5.2f  %3d %3d  %4d %3d %.3f\n",
                    $1, $2, $3, $6, $6, $6, 0, 0, 0, 0, $7)
            }' > $psfphot
        fi
    fi

    if [ -e $compphot ] && [ $compphot -nt $scat ]
    then
        echo "reusing existing $compphot." >&2
    else
        # select field stars
        if [ -f $subreg ]
        then
            echo "# select field stars within $subreg (and r<$((rmax+psfsize)))" >&2
            cp $subreg $tmpreg
            echo "circle($center,$((rmax+psfsize)))" >> $tmpreg
            regfilter $scat $tmpreg | \
                sexselect -x - "" $merrlim "" "" \
                "NUMBER,X*,Y*,A*,$str" 7 > $tmpdat
            cp -p $tmpreg x.compreg.reg
        else
            # all stars (except faintest ones)
            sexselect -x $scat "" $merrlim "" "" "NUMBER,X*,Y*,A*,$str" 7 > $tmpdat
        fi
        # region file (stars only)
        echo -e "# Region file format: DS9 version 4.1
global color=green dashlist=8 3 width=1 font=\"helvetica 10 normal roman\" \
select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1
physical" > $tmpreg
        cat $tmpdat | awk -v h=$h -v f=$fwhm -v s=$x '{
            if ($1~/^#/) {print $0; next}
            #r=$5-(f-3*s); if (r<0) r=0; r=5+r/s+0.1*r*r/s*s
            r=2
            sflag=""
            if ($NF >= "4") {
                sflag="s"
            } else {
                if ($5 > 2+1.3*f+5*s) next
            }
            printf("circle(%.2f,%.2f,%.1f) # text={%s %.1f%s}\n",
                $2+0.5, h-$3+0.5, r, $1, $6, sflag)}' >> $tmpreg
        # create photometry file
        if [ $ncol == 3 ]
        then
            sex2rgbdat $scat $xrad $tmpreg > $compphot 2>/dev/null
            test $? -ne 0 &&
                echo "ERROR: failed command: sex2rgbdat $scat $xrad" >&2 && return 255
            # adding comment for saturated stars
            for id in $(grep " 4[ ]*$" $tmpdat | awk '{printf("%s ", $1)}')
            do
                sed --follow-symlinks -i '/^'$id' /s,$, sat,' $compphot
            done
        else
            cat $tmpdat | awk -v f=$fwhm -v s=$x '{
                if ($1~/^#/) {print $0; next}
                #if ($5 > 1.3*f+5*s) next
                sflag=""
                if ($NF >= "4") {
                    sflag=" sat"
                } else {
                    if ($5 > 1+1.3*f+5*s) next
                }
                printf("%-10s  %7.2f %7.2f  %5.2f %5.2f %5.2f  %3d %3d  %4d %3d %.3f%s\n",
                    $1, $2, $3, $6, $6, $6, 0, 0, 0, 0, $7, sflag)
            }' > $compphot
        fi
    fi
    echo "# removing $(grep -v "^#" $compphot | wc -l) field stars" >&2
    
    # determine mean brightness and background of psf stars
    for col in 4 5 6
    do
        test "$psfrgb" && psfrgb="$psfrgb,"
        x=$(grep -v "^#" $psfphot | awk -v col=$col '{
                if (NF>=col) i=i+exp(0.9211*(15-$col))
            } END {
                if (NF>=col) printf("%.3f",15-1.0857*log(i/NR))
            }')
        test -z "$x" && break
        psfrgb="$psfrgb$x"
    done
    echo "# psfrgb=$psfrgb" >&2
    # determine background
    r=$(echo $fwhm | awk '{printf("%.1f", 3*sqrt($1+1)+0.1*$1-2.0)}')
    gap=$(echo $r | awk '{printf("%.1f", 8+$1*1.2)}')
    x=$(echo $r $gap | awk '{printf("%.1f", 5+$1/2+$2)}')
    echo "# bg annulus r=$gap-$x (aprad=$r)" >&2
    x=$(echo $x $gap | awk '{printf("%.1f", $1-$2)}')
    AIaphot -bg $starstack $psfphot $r $gap $x > $tmpdat
    psfbg=$(grep -v "^#" $tmpdat | awk '{
        r=r+$2; g=g+$3; b=b+$4}END{printf("%.1f,%.1f,%.1f", r/NR, g/NR, b/NR)}')
    echo "# psfbg=$psfbg  (n=$(grep -v "^#" $tmpdat | wc -l))"

    # determine intensity multiplier
    x=$(grep -v "^#" $psfphot | awk '{printf("%s\n%s\n%s\n", $4, $5, $6)}' | \
        LANG=C sort -n | head -1)
    dmag=$(echo $psfrgb | tr ',' '\n' | LANG=C sort -n | head -1 | \
        awk -v x=$x '{printf("%.3f", $1-x)}')
    psfmult=$(dmag2di $dmag)
    echo "# psfmult=$psfmult"

    

    # ----------------------------------
    #   determine PSF - first iteration
    # ----------------------------------

    if [ -e $outpsf ]
    then
        echo "reusing existing $outpsf" >&2
    else
        # create first approx of psf
        echo "# first iteration ..."
        test "$AI_DEBUG" &&
            echo "$(date +'%H:%M:%S') AIstarcombine -m $psfmult -f $fwhm $resampopts $img $psfphot $tmppsf $psfsize $scale" >&2
        AIstarcombine -b $psfbg -m $psfmult -f $fwhm $resampopts $img $psfphot $tmppsf $psfsize $scale
        (test $? -ne 0 || ! is_pnm $tmppsf) &&
            echo "ERROR: AIstarcombine failed" >&2 && return 255
        cp -p $tmppsf x.psf0.$ext
        
        # mask central region
        #r=$(echo $fwhm $scale | awk '{printf("%.0f", (2.5*$1+1)*$2)}')
        r=$(echo $fwhm $scale | awk '{
            x=1+$1+2/3*sqrt($1**3+9)
            if($1>3) x=6+4*sqrt(0.5*($1-2.5))
            printf("%.0f", x*$2)}')
        test "$AI_DEBUG" && echo "# mask r=$r" >&2
        AIpsfmask $trail $tmppsf $tmpim1 $psfoff $r
        (test $? -ne 0 || ! is_pnm $tmpim1) && echo "ERROR: failed command:" >&2 &&
            echo "  AIpsfmask $trail $tmppsf $tmpim1 $psfoff $r" >&2 && return 255
        cp $tmpim1 $tmppsf

        # subtract field stars excluding psf stars
        str=$(cat $psfphot | awk '{
            if ($1~/^#/) next
            if (x!="") x=x","; x=x""$1
        } END {printf("%s\n", x)}')
        cp $compphot $tmpdat
        for id in ${str//,/ }; do sed --follow-symlinks -i '/^'$id' /s,^,# ,' $tmpdat; done
        test "$AI_DEBUG" &&
            echo $(date +'%H:%M:%S') AIskygen -o $tmpim1 $tmpdat $tmppsf $texp $magzero $scale $w $h $psfoff
        AIskygen -o $tmpim1 $tmpdat $tmppsf $texp $magzero $scale $w $h $psfoff
        (test $? -ne 0 || ! is_pnm $tmpim1) && echo "ERROR: failed command:" >&2 &&
            echo "  AIskygen -o $tmpim1 $tmpdat $tmppsf $texp $x $scale $w $h $psfoff" >&2 &&
            return 255

        # create second approximation of psf
        echo "# second iteration ..."
        pnmccdred -d $tmpim1 $img $tmpim2
        AIstarcombine -b $psfbg -m $psfmult -f $fwhm $resampopts $tmpim2 $psfphot $tmppsf $psfsize $scale
        (test $? -ne 0 || ! is_pnm $tmppsf) &&
            echo "ERROR: AIstarcombine failed" >&2 && return 255
        cp -p $tmppsf $outpsf
        
        # mask central region
        # measure photometric correction in psf image
        # subtract field stars excluding psf stars
        # create psf image
    fi
    
    # mask central region
    #r=$(echo $fwhm $scale | awk '{printf("%.0f", (4*$1+1)*$2)}')
    r=$(echo $fwhm $scale | awk '{
        x=1.5+1.5*$1+sqrt($1**3+9)
        if($1>3) x=9.6+8*sqrt(0.3*($1-2.7))
        printf("%.0f", x*$2)}')
    test "$AI_DEBUG" && echo "# mask r=$r" >&2
    AIpsfmask -m $outmask $trail $outpsf $tmpim1 $psfoff $r
    (test $? -ne 0 || ! is_pnm $tmpim1) && echo "ERROR: failed command:" >&2 &&
        echo "  AIpsfmask -m $outmask $trail $outpsf $tmpim1 $psfoff $r" >&2 && return 255
    cp $tmpim1 $tmppsf
    
    # measure photometric correction in psf image
    if [ -z "$trail" ]
    then
        # do large aperture photometry in $outpsf
        # limit large radius to 1.1*size of starmask
        reg2pbm $tmppsf $outmask > $tmpim1
        rmax=$(imcount $tmpim1 | awk '{printf("%.0f", 1.1*sqrt($1/3.14))}')
        echo $psfsize $scale | awk '{x=$1*$2/2; printf("psfcenter %.1f %.1f\n", x, x)}' > $tmpdat
        x=$(di2dmag $(echo $texp $scale | awk '{printf("%.1f", $1*$2*$2)}') | \
            awk -v m=$magzero -v d=$dmag '{printf("%.3f", m-$1+d)}')
        r=$(echo $fwhm $scale | awk -v rmax=$rmax '{
            r=(4*$1+1)*$2; if(r>rmax){r=rmax}; printf("%.0f", r)}')
        y=$((r/4+scale+2))
        test "$AI_DEBUG" &&
            echo "# AI_MAGZERO=$x AIaphot -p 3 $outpsf $tmpdat $r $y $((4+y/2))" >&2
        AI_MAGZERO=$x AIaphot -p 3 $outpsf $tmpdat $r $y $((4+y/2)) > $tmpphot
        
        # determine mag differences
        set - $(tail -1 $tmpphot)
        mcorr=$(echo ${psfrgb//,/ } $4 $5 $6 | awk '{
            dr=$4-$1; dg=$5-$2; db=$6-$3
            if(dr>0) {dr=0}; if(dg>0) {dg=0}; if(db>0) {db=0}
            printf("%.3f,%.3f,%.3f", dr, dg, db)}')
        echo "# mcorr=$mcorr" >&2
        set_header $hdr "AI_PSFMC=$mcorr"
        
        # write rlim and psfsize to header
        set_header $hdr "AI_PSFRL=$rlim"
        set_header $hdr "AI_PSFSZ=$psfsize"
    else
        mcorr=$(get_header -q $hdr AI_PSFMC)
        test "$mcorr" && echo "# reusing mcorr=$mcorr"
        test -z "$mcorr" && mcorr="0,0,0" &&
            echo "WARNING: unknown AI_PSFMC, using mcorr=$mcorr" >&2
    fi
    # apply mag correction to $starphot -> $tmpphot
    grep -v "^#" $compphot | awk -v mcorr=$mcorr 'BEGIN{split(mcorr,mc,",")}{
        printf("%-10s  %7.2f %7.2f  %5.2f %5.2f %5.2f  %3d %3d  %4d %3d %.3f\n",
        $1, $2, $3, $4+mc[1], $5+mc[2], $6+mc[3], $7, $8, $9, $10, $11)}' > $tmpphot

    # subtract both psf and companion stars
    AIskygen -o $tmpim1 $tmpphot $tmppsf $texp $magzero $scale $w $h $psfoff
    (test $? -ne 0 || ! is_pnm $tmpim1) && echo "ERROR: failed command:" >&2 &&
        echo "  AIskygen -o $tmpim1 $tmpphot $tmppsf $texp $magzero $scale $w $h $psfoff" >&2 &&
        return 255

    # TODO: measure residuals for each psf star
    pnmccdred -a $((bgres-psfoff)) -d $tmpim1 $img $outresid
    echo "# residual image: $outresid" >&2

    # reject most deviating psf stars
    # rebuild psf
    # rebuild residual image
    
    rm -f $tmpcat $tmpim1 $tmpim2 $tmpphot
    #echo $tmpdat $tmpreg $tmppsf
    rm -f $tmpdat $tmpreg $tmppsf
}


# comet extraction (star removal) and large aperture photometry
AIcomet () {
    local showhelp
    local newphot       # photometry data file for new/corrected stars,
                        # default: $codir/$sname.newphot.dat
    local stsub         # initial star stack with stars removed
    local cosub         # initial comet stack with star trails removed
    local bgfit10       # image of background fit enhanced by factor 10
    local do_examine    # examine comet/bg regions even if files do already exist
    local do_aphot_only # only do large aperture photometry (never assigned)
    local no_trail      # currently this variable is never set
    local comult=1      # contrast multiplier for cosub image used by large
                        # aperture photometry (requires bgfit10)
    local no_update     # if set do save results in header keywords
    local codir="comet"
    local i
    for i in $(seq 1 9)
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-p" && newphot=$2 && shift 2
        test "$1" == "-s" && stsub=$2   && shift 2
        test "$1" == "-c" && cosub=$2   && shift 2
        test "$1" == "-d" && codir=$2   && shift 2
        test "$1" == "-b" && bgfit10=$2 && shift 2
        test "$1" == "-e" && do_examine=1    && shift 1
        #test "$1" == "-a" && do_aphot_only=1 && shift 1
        test "$1" == "-m" && comult=$2  && shift 2
        test "$1" == "-t" && no_update=1 && shift 1
    done
    
    local ststack=$1
    local costack=${2:-""}
    local omove=$3      # dr@pa@x,y: dr - object move on the sky in "/hr
                        # pa - pa in deg (N over W)
                        # x,y - object position in costack (image coord. system)
    local obsdata=$4    # observations data for individual images of ststack
                        # lines: imageID JD dmag (dmag with arbitrary zero point)
    local psfoff=${5:-"1000"} # background of psf images and x.cotrail
    local starpsf=${6:-""}
    local trailpsf=${7:-""}
    local starmask=${8:-""}
    local trailmask=${9:-""}
    local starphot=${10:-""}
    local psfphot=${11:-""}
    local scale=4           # psf oversampling factor (e.g. used by AIpsfextract)
    local bgres=2000        # background of stsub, cosub, residual image
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpim1=$(mktemp "$tdir/tmp_im1_XXXXXX.pnm")
    local tmpim2=$(mktemp "$tdir/tmp_im2_XXXXXX.pnm")
    local tmpmask=$(mktemp "$tdir/tmp_mask_XXXXXX.pbm")
    local tmpbadmask=$(mktemp "$tdir/tmp_badmask_XXXXXX.pbm")
    local tmpkernel=$(mktemp "$tdir/tmp_kernel_XXXXXX.pbm")
    local tmpdat1=$(mktemp "$tdir/tmp_tmp1_XXXXXX.dat")
    local tmpdat2=$(mktemp "$tdir/tmp_tmp2_XXXXXX.dat")
    local tmpphot=$(mktemp "$tdir/tmp_phot_XXXXXX.dat")
    local tmpbgcorr=$(mktemp "$tdir/tmp_bgcorr_XXXXXX.pnm")
    local tmpreg=$(mktemp "$tdir/tmp_reg_XXXXXX.reg")
    local sname
    local coreg
    local bgreg
    local badreg
    local cotrail
    local hdr
    local wcshdr
    local ext
    local w
    local h
    local f
    local fwhm
    local rad
    local gap
    local xrad
    local val
    local copos
    local coregion
    local whxy
    local trailbg
    local nref
    local jdref
    local r
    local p
    local cmag
    local mmag
    local dm
    local dt
    local x
    local y
    local texp
    local nexp
    local magzero
    local mcorr
    local str
    local bgmult
    local cosub10
    local coblur
    local cosubimage
    local bgmn
    local bgsd
    local sum
    local aidx
    local filter
    local newmagcorr
    
    (test "$showhelp" || test $# -lt 4) &&
        echo "usage: AIcomet [-t] [-e] [-d outdir|$codir] [-b bgfit10] [-p newphot]" \
            "<ststack> <costack> <omove> <obsdata> [psfoff|$psfoff] [starpsf|$starpsf]" \
            "[trailpsf|$trailpsf] [starmask|$starmask] [trailmask|$trailmask] [starphot|$starphot]" >&2 &&
        return 1

    ext=""
    is_pgm $ststack && ext="pgm"
    is_ppm $ststack && ext="ppm"
    test -z "$ext" &&
        echo "ERROR: $ststack not in PGM or PPM image format." && return 255

    sname=$(basename ${ststack//.*/})
    test -z "$costack"   && costack=${ststack/./_m.}
    test -z "$starpsf"   && starpsf=$codir/$sname.starpsf.$ext
    test -z "$trailpsf"  && trailpsf=$codir/$sname.trailpsf.$ext
    test -z "$starmask"  && starmask=$codir/$sname.starmask.reg
    test -z "$trailmask" && trailmask=$codir/$sname.trailmask.reg
    test -z "$starphot"  && starphot=$codir/$sname.starphot.dat
    test -z "$psfphot"   && psfphot=$codir/$sname.psfphot.dat
    # allow masks in PBM format
    test ! -e $starmask  && test -e ${starmask%.reg}.pbm  && starmask=${starmask%.reg}.pbm
    test ! -e $trailmask && test -e ${trailmask%.reg}.pbm && trailmask=${trailmask%.reg}.pbm
    # allow masks in PGM format
    test ! -e $starmask  && test -e ${starmask%.reg}.pgm  && starmask=${starmask%.reg}.pgm
    test ! -e $trailmask && test -e ${trailmask%.reg}.pgm && trailmask=${trailmask%.reg}.pgm
    coreg=$codir/$sname.comet.reg
    bgreg=$codir/$sname.cometbg.reg
    badreg=$codir/$sname.bad.reg

    # checkings
    for f in $ststack $costack $obsdata \
        $newphot $stsub $cosub $bgfit10
    do
        test ! -e $f && echo "ERROR: file $f not found." >&2 && return 255
        test ! -s $f && echo "ERROR: file $f is empty." >&2 && return 255
    done
    (test ! "$do_aphot_only" || test -z "$stsub" || test -z "$cosub") &&
        for f in $starpsf $trailpsf $starmask $trailmask $starphot $psfphot
        do
            test ! -e $f && echo "ERROR: file $f not found." >&2 && return 255
            test ! -s $f && echo "ERROR: file $f is empty." >&2 && return 255
        done
    hdr=${ststack%.$ext}".head"
    test ! -e $hdr && hdr=$sname.head
    test ! -e $hdr &&
        echo "ERROR: file $hdr not found." >&2 && return 255
    wcshdr=${ststack%.$ext}".wcs.head"
    test ! -e $wcshdr && wcshdr=$sname.wcs.head
    test ! -e $wcshdr &&
        echo "ERROR: file $wcshdr not found." >&2 && return 255

    # determine copos in FITS coordinates
    h=$(identify $ststack | cut -d " " -f3 | cut -d "x" -f2)
    w=$(identify $ststack | cut -d " " -f3 | cut -d "x" -f1)
    copos=$(echo $omove | tr ',@' ' ' | awk -v h=$h '{printf("%.0f %.0f", $3, h-$4)}')
    #echo "# omove=$omove  copos=$copos" >&2

    # get fwhm
    fwhm=$(get_header -q $hdr AI_FWHM)
    if [ -z "$fwhm" ] && [ -f $codir/$sname.src.dat ]
    then
        x=$(echo $w $h | awk '{printf("%.0f", 0.2*sqrt($1*$1+$2*$2))}')
        fwhm=$(sexselect -s $codir/$sname.src.dat "" 0.03 $x "${copos/ /,}" "" 0 | \
            grep FWHM_IMAGE | awk '{if($7>3) printf("%.2f", $2)}')
    fi
    test -z "$fwhm" &&
        echo "ERROR: unknown FWHM." >&2 && return 255

    texp=""     # exposure time in sec
    nexp=""     # number of exposures that have been averaged
    magzero=""  # magzero for texp=1
    if [ -f $hdr ]
    then
        texp=$(grep    "^EXPTIME" $hdr | tr '=' ' ' | awk '{if ($2>0) printf("%d", 1*$2)}')
        nexp=$(grep    "^NEXP"    $hdr | tr '=' ' ' | awk '{if ($2>0) printf("%d", $2)}')
        magzero=$(grep "^MAGZERO" $hdr | tr '=' ' ' | awk '{if ($2>0) printf("%.2f", $2)}')
        filter=$(get_header -q $hdr FILTER)
    fi
    test -z "$texp" &&
        echo "ERROR: missing keyword EXPTIME." >&2 && return 255
    test -z "$nexp" && nexp=1
    texp=$(echo $texp $nexp | awk '{printf("%f", $1/$2)}')  # single exposure
    test -z "$magzero" &&
        magzero=$(get_param camera.dat magzero $sname AI_MAGZERO)
    test -z "$magzero" &&
        echo "ERROR: magzero unknown." >&2 && return 255

    # output file name containing new or corrected photometry
    test -z "$newphot"  && newphot=$codir/$sname.newphot.dat

    # apply mag correction to $starphot -> $tmpphot
    mcorr=$(get_header -q $hdr AI_PSFMC)
    test "$mcorr" && echo "# mcorr=$mcorr"
    test -z "$mcorr" && mcorr="0,0,0" &&
        echo "WARNING: unknown AI_PSFMC, using mcorr=$mcorr" >&2
    grep -v "^#" $starphot | awk -v mcorr=$mcorr 'BEGIN{split(mcorr,mc,",")}{
        printf("%-10s  %7.2f %7.2f  %5.2f %5.2f %5.2f  %3d %3d  %4d %3d %.3f\n",
        $1, $2, $3, $4+mc[1], $5+mc[2], $6+mc[3], $7, $8, $9, $10, $11)}' > $tmpphot

    # subtract stars and star trails (if not using already existing files)
    h=$(identify $ststack | cut -d " " -f3 | cut -d "x" -f2)
    w=$(identify $ststack | cut -d " " -f3 | cut -d "x" -f1)
    grep -v "^#" $tmpphot > $tmpdat1
    if [ -e $newphot ]
    then
        echo "# applying $newphot for photometric corrections" >&2
        str=$(grep -v "^#" $newphot | awk '{printf("%s ", $1)}')
        for id in $str; do sed --follow-symlinks -i '/^'$id' /s,^,# ,' $tmpdat1; done
        cat $newphot >> $tmpdat1
    fi
    x=$(grep -v "^#" $tmpdat1 | wc -l)
    if [ -z "$stsub" ]
    then
        stsub=x.stsub.$ext
        rm -f x.stsub.head
        # subtract stars from star stack -> stsub
        echo "$(date +'%H:%M:%S') subtracting $x stars from star stack ..." >&2
        AIpsfmask -q -m $starmask $starpsf $tmpim1 $psfoff
        AIskygen -o $tmpim2 $tmpdat1 $tmpim1 $texp $magzero $scale $w $h $psfoff
        test $? -ne 0 &&
            echo "ERROR: failed command: AIskygen -o $tmpim2 $tmpdat1 $tmpim1" \
                "$texp $magzero $scale $w $h $psfoff" >&2 && return 255
        pnmccdred -a $((bgres-psfoff)) -d $tmpim2 $ststack $stsub
        test $? -ne 0 &&
            echo "ERROR: failed command: pnmccdred -a $((bgres-psfoff)) -d $tmpim2 $ststack $stsub" >&2 &&
            return 255
    fi
    if [ -z "$cosub" ]
    then
        cosub=x.cosub.$ext
        rm -f x.cosub.head
        # subtract trails from comet stack -> cosub
        echo "$(date +'%H:%M:%S') subtracting $x trails from comet stack ..." >&2
        AIpsfmask -m $trailmask $trailpsf $tmpim1 $psfoff
        AIskygen -o $tmpim2 $tmpdat1 $tmpim1 $texp $magzero $scale $w $h $psfoff
        test $? -ne 0 &&
            echo "ERROR: failed command: AIskygen -o $tmpim2 $tmpdat1 $tmpim1" \
                "$texp $magzero $scale $w $h $psfoff" >&2 && return 255
        pnmccdred -a $((bgres-psfoff)) -d $tmpim2 $costack $cosub
        test $? -ne 0 &&
            echo "ERROR: failed command: pnmccdred -a $((bgres-psfoff)) -d $tmpim2 $costack $cosub" >&2 &&
            return 255
    fi
    cosub10=${cosub%.*}10.$ext
    coblur=x.$sname.blur.$ext
    test ! -e ${stsub%.*}.head && ln -s $hdr ${stsub%.*}.head
    test ! -e ${cosub%.*}.head && ln -s $hdr ${cosub%.*}.head

    if [ "$bgfit10" ]
    then
        # TODO: move before "--> define polygon region" ...
        # create contrast enhanced images
        echo "$(date +'%H:%M:%S') create contrast enhanced image ..." >&2
        convert $bgfit10 -resize $w"x"$h\! $tmpim1
        pnmccdred -m 0.1 $tmpim1 - | pnmccdred -m 10 - - | \
            pnmccdred -a $psfoff -d - $tmpim1 $tmpbgcorr
        pnmccdred -a $((-9*bgres)) -m 10 $cosub - | \
            pnmccdred -a $psfoff -d $tmpbgcorr - $cosub10
        convert $cosub10 -blur 0x2 $coblur
    else
        pnmccdred -a $((-9*bgres)) -m 10 $cosub - | \
            convert - -blur 0x2 $coblur
    fi
    (! test -s $coblur || ! is_pnm $coblur) &&
        echo "ERROR: unable to create $coblur" >&2 && return 255
    rm -f ${coblur%.*}.head
    ln -s $hdr ${coblur%.*}.head

    # define regions for comet and background
    str=""
    if [ ! -f $coreg ] || ! grep -q -iwE "^polygon" $coreg
    then
        str="do_it"
        # get jd (mean jd) and jdref
        jd=$(get_jd -k JD,JD_OBS,DATE-OBS $hdr)
        test -z "$jd" &&
            echo "ERROR: unable to determine JD from $hdr." >&2 &&
            return 255
        
        jdref=$(get_header -q $hdr JD_REF)
        test -z "$jdref" && jdref=$(get_header -q $hdr MJD_REF)
        if [ -z "$jdref" ]
        then
            # get jdref from rawfiles.dat
            nref=$(get_header -q $hdr NREF)
            test -z "$nref" && nref=$(AIsetinfo -b $sname | head -1 | awk '{printf("%s", $8)}')
            test "$nref" && test -s rawfiles.dat &&
                jdref=$(grep "^$nref " rawfiles.dat | awk '{printf("%s", $5)}') &&
                echo "# nref=$nref jdref=$jdref (rawfiles.dat)"
        fi
        
        if [ -z "$jdref" ]
        then
            echo "# WARNING: unable to determine time of reference image," >&2
            echo "#  initial comet region might be off." >&2
            x=0; y=0
        else
            # time offset between mean jd and nref in seconds
            dt=$(echo $jdref $jd | awk  '{printf("%d", ($2-$1)*24*3600)}')
        
            # image rotation angle and pixel scale
            r=$(get_wcsrot $wcshdr $(echo $omove | awk -F "@" '{print $3}' | tr ',' ' '))
            p=$(get_wcspscale $wcshdr)
            
            # determine comets offset with respect to jdref in cartesian x/y
            x=$(echo $omove $dt $r $p | awk '{
                split($1,a,/@/)
                r=(a[2]-$3)*3.1415926/180
                printf("%.2f", -1*a[1]*sin(r)*$2/$4/3600)}')
            y=$(echo $omove $dt $r $p | awk '{
                split($1,a,/@/)
                r=(a[2]-$3)*3.1415926/180
                printf("%.2f", a[1]*cos(r)*$2/$4/3600)}')
            echo "# comet offset: x=$x y=$y" >&2
        fi

        # create initial comet region
        echo "# Region file format: DS9 version 4.1
global color=green dashlist=8 3 width=1 font=\"helvetica 10 normal roman\" " \
            "select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 " \
            "include=1 source=1" > $coreg
        echo "physical" >> $coreg
        echo ${omove//@/ } | tr ',' ' ' | awk -v r=20 -v h=$h -v x=$x -v y=$y '{
            z=sqrt(2);
            if(NF<4) next
            printf("polygon(%.2f,%.2f", $3-x+0.5-r, h-$4-y+0.5-r)
            printf(",%.2f,%.2f",  $3-x,         h-$4-y+0.5-z*r)
            printf(",%.2f,%.2f",  $3-x+0.5+r,   h-$4-y+0.5-r)
            printf(",%.2f,%.2f",  $3-x+0.5+z*r, h-$4-y)
            printf(",%.2f,%.2f",  $3-x+0.5+r,   h-$4-y+0.5+r)
            printf(",%.2f,%.2f",  $3-x,         h-$4-y+0.5+z*r)
            printf(",%.2f,%.2f",  $3-x+0.5-r,   h-$4-y+0.5+r)
            printf(",%.2f,%.2f)", $3-x+0.5-z*r, h-$4-y)
        }' >> $coreg
    else
        echo "reusing comet region from $coreg" >&2
    fi
    if [ ! -f $bgreg ] || ! grep -q -iwE "^circle|^polygon|^box" $bgreg
    then
        str="do_it"
        echo "# Region file format: DS9 version 4.1
global color=green dashlist=8 3 width=1 font=\"helvetica 10 normal roman\" " \
            "select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 " \
            "include=1 source=1" > $bgreg
        echo "physical" >> $bgreg
    else
        echo "reusing background region from $codir/$bgreg" >&2
    fi
    test "$str$do_examine" &&
        echo "\
--> define polygon regions for
  - comet,       save as $coreg
  - background,  save as $bgreg
  - bad areas,   save as $badreg (optional)" &&
        AIexamine -n CometRegions -p "-pan to $copos -regions shape polygon" \
            $coblur $coreg $ststack

    # check for correct region format
    for f in $coreg $bgreg $badreg
    do
        ! grep -q -iwE "^physical|^image" $coreg &&
            echo "ERROR: $f has unsupported region file format (must be physical)." >&2 && return 255
    done
    
    # skip regions smaller than 3 pix
    for f in $coreg $bgreg # $badreg
    do
        test -s "$f" && regskip $f > $tmpreg &&
            ! diff -q $tmpreg $f > /dev/null && cp $tmpreg $f
    done
    
    # TODO: allow for ellipse regions, needs some tweeks in reg2pbm
    ! grep -q -iwE "^polygon" $coreg &&
        echo "ERROR: no polygon region in $coreg." >&2 && return 255
    ! grep -q -iwE "^circle|^polygon|^box" $bgreg &&
        echo "ERROR: no region in $bgreg." >&2 && return 255
    test $(grep -iwE "^circle|^polygon|^box" $bgreg | sort -u | wc -l) -lt 3 &&
        echo "ERROR: too few region in $bgreg (min=3)." >&2 && return 255
    if [ -f $badreg ]
    then
        ! grep -q -iwE "^circle|^polygon|^box" $badreg &&
        echo "WARNING: no valid regions in $badreg." >&2 && badreg=""
    else
        badreg=""
    fi
    
    # check for identical regions
    for str in $(grep -iwE "^polygon" $coreg | awk '{print $1}')
    do
        grep -q "^$str" $bgreg &&
            echo "ERROR: identical region(s) in $coreg and $bgreg." >&2 && return 255
    done
    
    
    # ---------------------
    #   create comet trail
    # ---------------------
    test ! "$do_aphot_only" && test ! "$no_trail" && if [ -e $codir/$sname.cotrail.$ext ]
    then
        echo "WARNING: using existing $codir/$sname.cotrail.$ext" >&2
        cp -p $codir/$sname.cotrail.$ext x.cotrail.$ext
    else
        x=$(grep -v "^#" $obsdata | wc -l)
        echo "$(date +'%H:%M:%S') creating comet trail ($x positions) ..." >&2

        # determine comet extent
        h=$(identify $ststack | cut -d " " -f3 | cut -d "x" -f2)
        w=$(identify $ststack | cut -d " " -f3 | cut -d "x" -f1)
        # TODO: allow for box or circle as well
        coregion=$(grep "^polygon(" $coreg | tr '() ' ' ' | awk -v w=$w -v h=$h -v m=20 '{
            n=split($2,a,/,/)
            for (i=0;i<n/2;i++) {
                x=a[2*i+1]; y=a[2*i+2]
                if (i==0) {
                    x1=x; x2=x; y1=y; y2=y
                } else {
                    if (x<x1) x1=x
                    if (x>x2) x2=x
                    if (y<y1) y1=y
                    if (y>y2) y2=y
                }
            }
            x1=x1-m; if (x1<0.5)   x1=0.5
            x2=x2+m; if (x2>w+0.5) x2=w+0.5
            y1=y1-m; if (y1<0.5)   y1=0.5
            y2=y2+m; if (y2>h+0.5) y2=h+0.5
            printf("%dx%d+%d+%d\n", int(x2+0.5)-int(x1-0.5), int(h-y1+0.5)-int(h-y2-0.5),
                int(x1-0.5), int(h-y2+0.5))
        }')
        #)
        echo "# coregion=$coregion" >&2
        # add 1/2 psf size (sampled to orig pixscale) around coregion
        x=$(identify $starpsf | cut -d " " -f3 | cut -d "x" -f1)
        whxy=$(echo "$coregion" | tr '+x' ' ' | awk -v x=$x -v scale=$scale -v h=$h -v w=$w '{
            pw=1+2*int(x/scale/2)
            x1=$3-pw/2; if (x1<0) x1=0
            y1=$4-pw/2; if (y1<0) y1=0
            x2=$1+$3+pw/2; if (x2>w) x2=w
            y2=$2+$4+pw/2; if (y2>h) x2=h
            printf("%d %d %d %d", x2-x1+1, y2-y1+1, x1, y1)}')
        echo "# whxy=$whxy"

        # comet mask
        if [ "$badreg" ]
        then
            reg2pbm $cosub $badreg | imcrop -1 - $whxy | convert - -negate $tmpbadmask
            reg2pbm $cosub $coreg  | imcrop -1 - $whxy | \
                pnmarith -mul - $tmpbadmask > $tmpmask
        else
            reg2pbm $cosub $coreg  | imcrop -1 - $whxy > $tmpmask
        fi

        # determine background in $cosub, shift intensity to bg=psfoff
        trailbg=$(regstat -q -a $cosub $bgreg $badreg | cut -d ' ' -f1)
        x=$(echo $trailbg | awk -F ',' -v b=$psfoff '{
            printf("%.0f", b-$1)
            if(NF==3) {printf(",%.0f,%.0f", b-$2, b-$3)}
            }')
        imcrop -1 $cosub $whxy | pnmccdred -a $x - $tmpim1
        AIpsfmask -m $tmpmask $tmpim1 $tmpim2 $psfoff
        
        # smooth cropped costack
        # TODO: for large FWHM work on binned image
        #       use less smoothing for center part of comet
        r=$(get_wcsrot $wcshdr $(echo $omove | awk -F "@" '{print $3}' | tr ',' ' '))
        # core, r=0...3 pix
        x=3
        y=3
        #echo "# mkkernel $x $y" >&2
        #mkkernel $x $y > $tmpkernel
        #kmedian $tmpim2 $tmpkernel > $tmpim1 2>/dev/null
        # inner coma, r=3...15 pix
        x=7
        y=5
        #echo "# mkkernel $x $y" >&2
        #mkkernel $x $y $(echo $r | awk '{printf("%.0f", -1*$1)}') > $tmpkernel
        #kmedian $tmpim2 $tmpkernel > $tmpim1 2>/dev/null
        # outer coma, r>15fwhm
        x=$(echo $fwhm 3.0 | awk '{x=4+$1*$2; printf("%d", 2*int(x/2)+1)}')
        y=$(echo $fwhm 2.0 | awk '{printf("%.0f", 2.5+$1*$2)}')
        #echo "# mkkernel $x $y $(echo $r | awk '{printf("%.0f", -1*$1)}')" >&2
        #mkkernel $x $y $(echo $r | awk '{printf("%.0f", -1*$1)}') > $tmpkernel
        #kmedian $tmpim2 $tmpkernel > $tmpim1 2>/dev/null
        
        x=$(echo $fwhm 2.2 | awk '{x=3+$1*$2; printf("%d", 2*int(x/2)+1)}')
        y=$(echo $fwhm 1.2 | awk '{printf("%.0f", 2+$1*$2)}')
        echo "# mkkernel $x $y $(echo $r | awk '{printf("%.0f", -1*$1)}')" >&2
        mkkernel $x $y $(echo $r | awk '{printf("%.0f", -1*$1)}') > $tmpkernel
        kmedian $tmpim2 $tmpkernel > $tmpim1 2>/dev/null
        test $? -ne 0 &&
            echo "ERROR: kmedian has failed." >&2 && return 255

        # create artificial comet trail
        test "$AI_DEBUG" &&
            echo "mkcotrail -o $tmpim2 $sname $tmpim1 $omove $obsdata $psfoff" >&2
        mkcotrail -o $tmpim2 $sname $tmpim1 $omove $obsdata $psfoff
        set - $whxy
        pnmccdred -m 0 $ststack - | pnmpaste $tmpim2 $3 $4 - > x.cotrail.$ext
    fi
    
    
    # --------------------------------------------------
    #   new photometry of stars affected by comet trail
    # --------------------------------------------------
    # radii
    # v2.7.3:
    #rad=$(echo $fwhm | awk '{printf("%.1f\n", 3*sqrt($1+1)+0.05*$1-1.3)}')
    #gap=$(echo $rad | awk '{printf("%.1f", 1.5+$1/2)}')
    # new in 3.0.2
    rad=$(echo $fwhm | awk '{printf("%.1f\n", 2.5*sqrt($1+2)-2.8)}')
    gap=$(echo $rad | awk '{printf("%.1f", 3.5+0.7*$1)}')
    xrad=$(echo $fwhm | awk '{printf("%.1f", 1+$1/3)}')
    echo "# fwhm=$fwhm  rad=$rad  gap=$gap  xrad=$xrad" >&2
        
    test "$no_trail" && cp $stsub x.resid.$ext
    test ! "$no_trail" && pnmccdred -d x.cotrail.$ext $stsub x.resid.$ext
    rm -f x.resid.head
    ln -s $hdr x.resid.head
    test ! "$do_aphot_only" && if [ ! -e $newphot ]
    then
        # TODO: create x.stars.reg
        test ! -e x.newphot.reg && (
        echo "# Region file format: DS9 version 4.1" \
            "global color=green dashlist=8 3 width=1 font=\"helvetica 10 normal roman\" " \
            "select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 " \
            "include=1 source=1" > x.newphot.reg
        echo "physical" >> x.newphot.reg)
        echo "--> identify stars which need photometric correction, save as x.newphot.reg"
        #AIexamine $ststack $coreg $bgreg x.resid.$ext x.newphot.reg
        AIexamine -n PhotCorr -p "-pan to $copos" $ststack $coreg $bgreg $badreg x.resid.$ext x.newphot.reg
        cp -p x.newphot.reg x.newphot.00.reg

        # determine aperture correction
        # do small and large aperture photometry in $outpsf
        # limit large radius to 1.1*size of starmask
        r=$(reg2pbm $starpsf $starmask | imcount - | awk '{printf("%.1f", 1.1*sqrt($1/3.14))}')
        set - $(identify $starpsf)
        echo $3 | tr 'x' ' ' | awk '{x=$1/2; printf("psfcenter %.1f %.1f\n", x, x)}' > $tmpdat1
        x=$(echo $rad $scale | awk '{printf("%.0f", $1*$2/2+5)}') # gap
        y=$((4+x/2)) # bg annulus width
        test "$AI_DEBUG" &&
            echo "# AI_MAGZERO=25 AIaphot -p 3 $outpsf $tmpdat $r $x $y" >&2
        AI_MAGZERO=25 AIaphot -p 3 $starpsf $tmpdat1 $r $x $y > $tmpdat2
        # small aperture photometry
        x=$(echo $r $x $rad $scale | awk '{print $1+$2-$3*$4}') # gap
        r=$(echo $rad $scale | awk '{print $1*$2}')
        test "$AI_DEBUG" &&
            echo "# AI_MAGZERO=25 AIaphot -p 3 $outpsf $tmpdat $r $x $y" >&2
        AI_MAGZERO=25 AIaphot -p 3 $starpsf $tmpdat1 $r $x $y >> $tmpdat2
        test "$AI_DEBUG" && cat $tmpdat2
        newmagcorr=$(grep -v "^#" $tmpdat2 | awk '{
            if(NR==1) {r=$4; g=$5; b=$6}
            if(NR==2) {printf("%.2f,%.2f,%.2f", r-$4, g-$5, b-$6)}
        }')
        echo "# newmag in r=$rad, mcorr=$newmagcorr"
        
        newid=0
        if grep -q -iwE "^circle" x.newphot.reg
        then
            # do aperture photometry on x.resid.$ext
            echo "# fwhm=$fwhm  rad=$rad  gap=$gap  xrad=$xrad" >> $newphot
            echo "$(date +'%H:%M:%S') aperture photometry of new/corrected stars ..." >&2
            reg2xy $ststack x.newphot.reg > $tmpdat1
            xymatch $tmpdat1 $tmpphot $xrad > $tmpdat2
            str=$(grep -v "^#" $tmpdat2 | awk '{printf("%s ", $NF)}')
            echo "# mag corr for: $str" >&2
            cat $tmpdat2 | while read line
            do
                #echo "# line: $line"
                set - $line
                test "$1" == "#" && test "${2:0:1}" != "N" && continue
                if [ $# -ge 9 ]
                then
                    # measure matched stars using their original position from tmpphot
                    x=$2; y=$3; id=$9
                    set - $(aphot -a x.resid.$ext $x,$y $rad $gap 4)
                    #echo newmag -q $sname $tmpphot $id 1 $3,$4,$5 1 0
                    newmag -q $sname $tmpphot $id 1 $3,$4,$5 1 0
                else
                    # measure new stars
                    newid=$((newid + 1))
                    id=$(printf "N%04d" $newid); x=$3; y=$4
                    # note: AIaphot x.resid.$ext requires MAGZERO keyword
                    #       apply newmagcorr-mcorr
                    echo "$id $x $y" | \
                        AIaphot x.resid.$ext - $rad $gap 4 | grep -v "^#" | \
                        awk -v mcorr=$mcorr -v newcorr=$newmagcorr '
                        BEGIN{split(mcorr,mc,","); split(newcorr,nc,",")}{
                        printf("%-10s  %7.2f %7.2f  %5.2f %5.2f %5.2f  %3d %3d  %4d %3d %.3f\n",
                            $1, $2, $3, $4+nc[1]-mc[1], $5+nc[2]-mc[2], $6+nc[3]-mc[3],
                            $7, $8, $9, $10, $11)
                        }'
                fi
            done | tee -a $newphot
            # sorting newphot
            grep "^#" $newphot > $tmpdat1
            grep "^[0-9]" $newphot | LANG=C sort -n -k1,1 >> $tmpdat1
            grep -E -v "^#|^[0-9]" $newphot | LANG=C sort -k1,1 >> $tmpdat1
            cp $tmpdat1 $newphot
            
        
            # subtract stars and create new stsub, cosub
            str=$(grep -v "^#" $newphot | awk '{printf("%s ", $1)}')
            grep -v "^#" $starphot | awk -v mcorr=$mcorr 'BEGIN{split(mcorr,mc,",")}{
                printf("%-10s  %7.2f %7.2f  %5.2f %5.2f %5.2f  %3d %3d  %4d %3d %.3f\n",
                $1, $2, $3, $4+mc[1], $5+mc[2], $6+mc[3], $7, $8, $9, $10, $11)}' > $tmpdat1
            for id in $str; do sed --follow-symlinks -i '/^'$id' /s,^,# ,' $tmpdat1; done
            grep -v "^#" $newphot >> $tmpdat1

            # subtract stars from star stack -> new stsub
            x=$(grep -v "^#" $tmpdat1 | wc -l)
            echo "$(date +'%H:%M:%S') subtracting $x stars and trails ..." >&2
            h=$(identify $ststack | cut -d " " -f3 | cut -d "x" -f2)
            w=$(identify $ststack | cut -d " " -f3 | cut -d "x" -f1)
            AIpsfmask -q -m $starmask $starpsf $tmpim1 $psfoff
            AIskygen -o $tmpim2 $tmpdat1 $tmpim1 $texp $magzero $scale $w $h $psfoff
            pnmccdred -a $((bgres-psfoff)) -d $tmpim2 $ststack $stsub
            # subtract trails from comet stack -> new cosub
            AIpsfmask -q -m $trailmask $trailpsf $tmpim1 $psfoff
            AIskygen -o $tmpim2 $tmpdat1 $tmpim1 $texp $magzero $scale $w $h $psfoff
            pnmccdred -a $((bgres-psfoff)) -d $tmpim2 $costack $cosub
            
            if [ "$no_trail" ]
            then
                cp $stsub x.resid.$ext
            else
                # create improved comet image
                # comet mask
                if [ "$badreg" ]
                then
                    reg2pbm $cosub $badreg | imcrop -1 - $whxy | convert - -negate $tmpbadmask
                    reg2pbm $cosub $coreg  | imcrop -1 - $whxy | \
                        pnmarith -mul - $tmpbadmask > $tmpmask
                else
                    reg2pbm $cosub $coreg  | imcrop -1 - $whxy > $tmpmask
                fi

                # determine background in $cosub, shift intensity to bg=psfoff
                trailbg=$(regstat -q -a $cosub $bgreg $badreg | cut -d ' ' -f1)
                x=$(echo $trailbg | awk -F ',' -v b=$psfoff '{
                    printf("%.0f", b-$1)
                    if(NF==3) {printf(",%.0f,%.0f", b-$2, b-$3)}
                    }')
                imcrop -1 $cosub $whxy | pnmccdred -a $x - $tmpim1
                AIpsfmask -q -m $tmpmask $tmpim1 $tmpim2 $psfoff

                # smooth cropped costack
                kmedian $tmpim2 $tmpkernel > $tmpim1 2>/dev/null
                test $? -ne 0 &&
                    echo "ERROR: kmedian has failed." >&2 && return 255

                # create artificial comet trail
                mkcotrail -o $tmpim2 $sname $tmpim1 $omove $obsdata $psfoff
                set - $whxy
                pnmccdred -m 0 $ststack - | pnmpaste $tmpim2 $3 $4 - > x.cotrail.$ext

                # create improved residuals image
                pnmccdred -d x.cotrail.$ext $stsub x.resid.$ext
            fi
            
            # create improved contrast enhanced and blured cosub image
            if [ "$bgfit10" ]
            then
                # TODO: move before "--> define polygon region" ...
                # create contrast enhanced images
                pnmccdred -a $((-9*bgres)) -m 10 $cosub - | \
                    pnmccdred -a $psfoff -d $tmpbgcorr - $cosub10
                convert $cosub10 -blur 0x2 $coblur
            else
                pnmccdred -a $((-9*bgres)) -m 10 $cosub - | \
                    convert - -blur 0x2 $coblur
            fi
        fi
    fi


    # ----------------------------------
    #   large aperture comet photometry
    # ----------------------------------

    echo "$(date +'%H:%M:%S') large aperture photometry of comet ..." >&2
    if [ "$bgfit10" ] && [ $comult -gt 1 ]
    then
        # create contrast enhanced cosub image
        echo "using contrast streched image for photometry" >&2
        h=$(identify $ststack | cut -d " " -f3 | cut -d "x" -f2)
        w=$(identify $ststack | cut -d " " -f3 | cut -d "x" -f1)
        x=$(echo "(10/$comult-1)*psfoff" | bc -l)
        y=$(echo "$comult/10" | bc -l)
        convert $bgfit10 -resize $w"x"$h\! $tmpim1
        pnmccdred -m 0.1 $tmpim1 - | pnmccdred -m 10 - - | \
            pnmccdred -a $psfoff -d - $tmpim1 - |
            pnmccdred -a $x - - | pnmccdred -m $y -  $tmpbgcorr
        pnmccdred -a $(((1-$comult)*bgres)) -m $comult $cosub - | \
            pnmccdred -a $psfoff -d $tmpbgcorr - $tmpim1
        cosubimage=comet/$set.cosub$comult.$ext
    else
        if [ $comult -gt 1 ]
        then
            pnmccdred -a $(((1-$comult)*bgres)) -m $comult $cosub $tmpim1
            cosubimage=comet/$set.cosub$comult.$ext
        else
            cp -p $cosub $tmpim1
            cosubimage=comet/$set.cosub.$ext
        fi
    fi
    # update cosubimage if necessary
    if [ -f $cosubimage ]
    then
        x=$(md5sum $tmpim1 $cosubimage | cut -d ' ' -f1 | sort -u | wc -l)
        test "$x" != "1" &&
            cp -p $tmpim1 $cosubimage
    else
        cp -p $tmpim1 $cosubimage
    fi

    # determine background
    echo "$(date +'%H:%M:%S') measure bg" >&2
    false && (
    # old: until 170420
    # measure counts for every single bg region (area at least 10 pix)
    test "$badreg" && reg2pbm $cosubimage $badreg | convert - -negate $tmpbadmask
    grep -iwE "^circle|^polygon|^box" $bgreg | while read
    do
        if [ "$badreg" ]
        then
            echo "$REPLY" | reg2pbm $cosubimage - | pnmarith -mul - $tmpbadmask > $tmpmask
        else
            echo "$REPLY" | reg2pbm $cosubimage - > $tmpmask
        fi

        x=$(imcount $tmpmask)
        (test -z "$x" || test $x -lt 10) && continue 
        pnmarith -mul $cosubimage $tmpmask > $tmpim1 2>/dev/null
        imcount $tmpim1 | tr ',' ' ' | awk -v a=$x -v m=$comult -v b=$bgres '{
            printf("%.1f", ($1/a-b)/m)
            if (NF==3) printf(" %.1f %.1f", ($2/a-b)/m, ($3/a-b)/m)
            printf("\n")
        }'
    done > $tmpdat1
    for i in $(seq 1 $(head -1 $tmpdat1 | wc -w))
    do
        test $i -eq 1 &&
            bgmn=$(mean $tmpdat1 $i | awk '{printf("%.2f", $1)}') &&
            bgsd=$(stddev $tmpdat1 $i | awk '{printf("%.2f", $1)}')
        test $i -gt 1 &&
            bgmn="$bgmn,"$(mean $tmpdat1 $i | awk '{printf("%.2f", $1)}') &&
            bgsd="$bgsd,"$(stddev $tmpdat1 $i | awk '{printf("%.2f", $1)}')
    done
    )
    regstat -q $cosubimage $bgreg $badreg | cut -d ' ' -f1 | \
        awk -F ',' -v m=$comult -v b=$bgres '{
            printf("%.1f", ($1-b)/m)
            if (NF==3) printf(" %.1f %.1f", ($2-b)/m, ($3-b)/m)
            printf("\n")
        }' > $tmpdat1
    x=1; test "$ext" == "ppm" && x=3
    for i in $(seq 1 $x)
    do
        test $i -eq 1 &&
            bgmn=$(mean $tmpdat1 $i | awk '{printf("%.2f", $1)}') &&
            bgsd=$(stddev $tmpdat1 $i | awk '{printf("%.2f", $1)}')
        test $i -gt 1 &&
            bgmn="$bgmn,"$(mean $tmpdat1 $i | awk '{printf("%.2f", $1)}') &&
            bgsd="$bgsd,"$(stddev $tmpdat1 $i | awk '{printf("%.2f", $1)}')
    done
    echo "# bgmn=$bgmn  bgsd=$bgsd  nbg=" $(cat $tmpdat1 | wc -l) >&2

    # mesure comet area
    echo "$(date +'%H:%M:%S') measure comet" >&2
    if [ "$badreg" ]
    then
        reg2pbm $cosubimage $badreg | convert - -negate $tmpbadmask
        reg2pbm $cosubimage $coreg | pnmarith -mul - $tmpbadmask > $tmpmask
    else
        reg2pbm $cosubimage $coreg > $tmpmask
    fi
    test $? -ne 0 && echo "ERROR in AIcomet" >&2 && return 255 
    x=$(imcount $tmpmask)
    pnmarith -mul $cosubimage $tmpmask > $tmpim1 2>/dev/null
    y=$(imcount $tmpim1)
    # TODO: get sum first: y/10-x*(val-bgres)-x*bgres
    sum=$(echo ${y//,/ } ${bgmn//,/ } | awk -v a=$x -v m=$comult -v b=$bgres '{
        if (NF==2) printf("%.0f", ($1-a*b-a*m*$2)/m)
        if (NF==6) printf("%.0f,%.0f,%.0f", ($1-a*b-a*m*$4)/m,
            ($2-a*b-a*m*$5)/m, ($3-a*b-a*m*$6)/m)
    }')
    echo "# comet sum=$sum" >&2
    val=$(echo ${sum//,/ } | awk -v a=$x '{
        if (NF==1) printf("%.2f", $1/a)
        if (NF==3) printf("%.2f,%.2f,%.2f", $1/a, $2/a, $3/a)
    }')
    y=$(echo $x | awk '{x=sqrt($1/3.1415927); printf("%.0f", 2*x)}')

    # write results of aperture counts measurements to header
    # converting strings to arrays first
    OLDIFS=$IFS; IFS=,
    sum=($sum); val=($val); bgmn=($bgmn); bgsd=($bgsd)
    IFS=$OLDIFS
    #sum=$(echo ${sum//,/ }   | awk -v i=$i '{printf("%.0f",$i)}') # sum
    #val=$(echo ${val//,/ }   | awk -v i=$i '{printf("%.2f",$i)}') # mean
    #bgmn=$(echo ${bgmn//,/ } | awk -v i=$i -v b=$bgres '{printf("%.2f",b+$i)}') # bg
    #bgsd=$(echo ${bgsd//,/ } | awk -v i=$i '{printf("%.2f",$i)}') # bgsd
    # add bg offset back to bgmn
    for i in $(seq 1 ${#bgmn[@]})
    do
        bgmn[$((i-1))]=$(echo ${bgmn[i-1]} | awk -v b=$bgres '{printf("%.2f",b+$i)}')
    done
    # get name(s) of color band(s)
    #   TODO: should be read from image
    str=""
    case "${filter,,}" in
        r|red)      str="R";;
        g|green)    str="G";;
        b|blue)     str="B";;
        l|luminance)            str="L";;
        c|clear|"no filter")    str="C";;
    esac
    test -z "$str" && test ${#sum[@]} -eq 3 && str=("R" "G" "B")
    test -z "$str" && str="G"

    if [ "$no_update" ]
    then
        echo "# WARNING: Results are NOT saved to header keywords!"
    else
        for aidx in $(seq 1 ${#sum[@]})
        do
            i=$((aidx-1))
            set_header $hdr \
            AC_VERS$aidx="${AI_VERSION} / airfun version (AIcomet)" \
            AC_ICOL$aidx="${str[i]}     / Instrumental color band" \
            AC_AREA$aidx="$x            / Aperture area in pix" \
            AC_ASUM$aidx="${sum[i]}     / Comets total ADU in aperture" \
            AC_MEAN$aidx="${val[i]}     / Comets mean ADU in aperture" \
            AC_DIAM$aidx="$y            / Equivalent aperture diameter in pix" \
            AC_BCKG$aidx="${bgmn[i]}    / Average background ADU (shifted)" \
            AC_BGER$aidx="${bgsd[i]}    / Background error"
        done
    fi
    unset str   # to change back from array to normal variable
    
    # old format output
    i=1; test ${#sum[@]} -eq 1 && i=0
    echo "# set     mean    area      sum     d    bg-$bgres +- " >&2 
    echo "$sname ${val[i]} $x ${sum[i]} $y ${bgmn[i]} ${bgsd[i]}" | awk -v b=$bgres '{
            printf("%s     %5.2f  %6d  %7d   %3d   %5.2f  %4.2f\n",
                $1, $2, $3, $4, $5, $6-b, $7)
        }'>&2

    echo "$(date +'%H:%M:%S') finished" >&2

    rm -f $tmpim1 $tmpim2 $tmpmask $tmpbadmask $tmpkernel $tmpdat1 $tmpdat2
    rm -f $tmpbgcorr $tmpreg $tmpphot
    return
}


# determine noise per pixel for a given set of DSLR images
# normalization is done by image scaling (factor) against average image
# output images: $sname.{mn,sd}.$ext
AInoise () {
    AIcheck_ok -r || return 255
    local showhelp
    local do_bayer          # if set then keep bayer matrix and create gray
                            # output image instead of rgb
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-b" && do_bayer=1 && shift 1
    done

    local setname=${1:-""}
    local intype=${2:-""}
    local dark=${3:-""}     # pgm file
    #local flat=${4:-""}     # ppm file
    #local do_bgscale=${5:-""}  # change bg corr. from offset to scale factor
    local rdir=${AI_RAWDIR:-"."}
    local bad=${AI_BADPIX:-""}
    local sdat=${AI_SETS:-"set.dat"}
    local ccdregion=${AI_CCDREGION:-""}  # w h xoff yoff
    local tdir=${AI_TMPDIR:-"/tmp"}
    local imlist=$(mktemp "$tdir/tmp_imlist_XXXXXX.dat")
    local wdir=$(mktemp -d "$tdir/tmp_noise_XXXXXX")
    local tmpim=$(mktemp "$tdir/tmp_im1_XXXXXX.pnm")
    local sname
    local type
    local texp
    local n1
    local n2
    local nref
    local num
    local fname
    #local opts
    local ext
    local ilist
    local mxx
    local mrgb
    local xx
    local is_dark_subtracted
    local dcrawopts
    local scale
    local flip
    local opts
    
    test "$showhelp" &&
        echo "usage: AInoise [-b] [set] [intype] [dark]" >&2 &&
        return 1

    # check for presence of dark frame if requested
    test "$dark" && test ! -f "$dark" &&
        echo "ERROR: dark image $dark not found." && return

    while read ltime sname target type texp n1 n2 nref x x x
    do
        (echo "$ltime" | grep -q "^#") && continue
        test "$setname" && test "$setname" != "$sname" && continue
        test -z "$setname" && test "$intype" && test "$type" != "$intype" && continue
        test "$type" == "a" && continue
        (! is_integer "$n1" || ! is_integer "$n2") && continue
        
        # check if output file exists
        ext="ppm"
        (test "$do_bayer" || test "$type" == "d") && ext="pgm"
        test -f $sname.mn.$ext &&
            echo "WARNING: output image $sname.mn.$ext exists, skipping set $sname." >&2 && continue
        test -f $sname.sd.$ext &&
            echo "WARNING: output image $sname.sd.$ext exists, skipping set $sname." >&2 && continue

        is_dark_subtracted=""
        test "$(AIsetinfo $sname | awk '{print $11}')" == "0" &&
            is_dark_subtracted=1 &&
            echo "$sname: in-camera dark subtraction assumed."
        
        # need at least 3 images
        AIimlist $sname "" raw > $imlist
        n=$(cat $imlist | wc -l)
        test $n -lt 3 && echo "ERROR: set $sname has too few images ($n < 3)." &&
            rm $imlist && continue
        echo "processing $n images in set $sname ..."
        
        dcrawopts=""
        is_gacam_raw $(head -1 $imlist | cut -d ' ' -f3) && test "$ccdregion" &&
            dcrawopts="-R $ccdregion"

        # determine intensity scaling factor to stretch to full 16bit range
        # this is used by AIraw2gray in case of FITS images only
        scale=$(get_param camera.dat rawbits $sname | awk '{if ($1!="-" && $1<16) print 2^(16-$1)}')

        # check if top-down image flipping is required
        flip=$(get_param camera.dat flip $sname | awk '{if ($1=="1") print 1}')
        
        # options for raw image conversion
        opts=""
        test "$scale" && opts="-s $scale"
        test "$flip"  && opts=$(echo $opts "-f")

        # ccd reduction (with optional dark subtraction)
        # TODO: deal with in-camera dark subtracted images
        echo "ccd reduction ..."
        ilist=""
        while read x num fname x
        do
            echo "  $num"
            if [ "$do_bayer" ] || [ "$type" == "d" ]
            then
                AI_DCRAWPARAM="$dcrawopts $AI_DCRAWPARAM" \
                AIraw2gray $opts $fname $dark > $wdir/$num.$ext
            else
                AI_DCRAWPARAM="$dcrawopts $AI_DCRAWPARAM" \
                AIraw2rgb  $opts $fname $dark > $wdir/$num.$ext
            fi
            ilist="$ilist $wdir/$num.$ext"
        done < $imlist
        
        # get image dimensions
        num=$(head -1 $imlist | awk '{printf("%s", $2)}')
        w=$(identify $wdir/$num.$ext | cut -d " " -f3 | cut -d "x" -f1)
        h=$(identify $wdir/$num.$ext | cut -d " " -f3 | cut -d "x" -f2)

        # create average image, used as base for individual scaling
        echo "average images ..."
        pnmcombine $ilist $sname.mn.$ext
        
        # statistics for average image
        if [ $do_bayer ] || [ "$type" == "d" ]
        then
            mxx=$(AImstat -b -c $sname.mn.$ext | awk '{
                printf("%.0f %.0f %.0f %.0f", $5, $9, $13, $17)}')
            echo "  mean mxx = $mxx"
        else
            mrgb=$(AImstat -c $sname.mn.$ext | awk '{
                printf("%.0f %.0f %.0f", $5, $9, $13)}')
            echo "  mean rgb = $mrgb"
        fi

        # normalize images (in-place)
        echo "normalize images ..."
        if [ $do_bayer ] || [ "$type" == "d" ]
        then
            while read x num x x
            do
                set - $(AImstat -b -c $wdir/$num.$ext | awk '{
                    printf("%.0f %.0f %.0f %.0f", $5, $9, $13, $17)}')
                xx=$(echo $mxx $1 $2 $3 $4 | awk '{
                    printf("%.4f %.4f %.4f %.4f\n", $1/$5, $2/$6, $3/$7, $4/$8)}')
                echo "$num: $xx"
                xx=$(echo $mxx $1 $2 $3 $4 | awk -v l=20000 '{
                    printf("%.0f %.0f %.0f %.0f\n",
                        l*$5/$1, l*$6/$2, l*$7/$3, l*$8/$4)}')
                echo -e "P2\n2 2\n65535\n$xx" | pnmtile $w $h - | \
                    pnmccdred -m 20000 -s - $wdir/$num.$ext $tmpim &&
                    mv $tmpim $wdir/$num.$ext
            done < $imlist
        else
            while read x num x x
            do
                set - $(AImstat -c $wdir/$num.$ext | awk '{
                    printf("%.0f %.0f %.0f", $5, $9, $13)}')
                xx=$(echo $mrgb $1 $2 $3 | awk '{
                    printf("%.4f %.4f %.4f\n", $1/$4, $2/$5, $3/$6)}')
                echo "  $num: $xx"
                pnmccdred -m ${xx// /,} $wdir/$num.$ext $tmpim &&
                    mv $tmpim $wdir/$num.$ext
            done < $imlist
        fi

        # stddev
        pnmcombine -s $ilist $sname.sd.$ext
        
        # clean up
        rm -f $ilist
    done < $sdat
    rmdir $wdir
    rm -f $imlist $tmpim
}


# find hot/cold bad pixel by analyzing pgm images of a given set
AIfindbad () {
    local showhelp
    local nmax=25       # max. number of images to use
    local margin=0      # number of columns/rows to skip at each image border
    local i
    for i in 1 2 3
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-n" && nmax=$2 && shift 2
        test "$1" == "-m" && margin=$2 && shift 2
    done
    local setname=${1:-""}
    local hotthresh=${2:-15}    # hot pix detection threshold (in rms units of
                                # the median image)
    local coldthresh=${3:-10}    # cold pix detection threshold
    local sdat=${AI_SETS:-"set.dat"}
    local tdir=${AI_TMPDIR:-"/tmp"}
    local wdir=$(mktemp -d "$tdir/tmp_findbad_XXXXXX")
    local imlist=$(mktemp "$tdir/tmp_list_XXXXXX.dat")
    local imlist2=$(mktemp "$tdir/tmp_list2_XXXXXX.dat")
    local tmpim1=$(mktemp "$tdir/tmp_im1_XXXXXX.pnm")
    local mask=$(mktemp "$tdir/tmp_im2_XXXXXX.pgm")
    local kernel=$(mktemp "$tdir/tmp_kernel_XXXXXX.pbm")
    local tmpset=$(mktemp "$tdir/tmp_set_XXXXXX.dat")
    local exifdat="exif.dat"
    local sname
    local type
    local texp
    local nref
    local dark
    local flat
    local black
    local rms
    local high
    local low
    local diff
    local bg
    local thres
    local n
    local geom

    (test "$showhelp" || test $# -lt 1 ) &&
        echo "usage: AIfindbad [-n nmax|$nmax] [-m margin] [-h] <set> [hotthresh|$hotthresh]" \
            "[coldthresh|$coldthresh] [boxwidth|$boxwidth]" >&2 &&
        return 1

    #echo -e "P1\n5 5\n10001\n01010\n00100\n01010\n10001" > $kernel
    echo -e "P1\n3 3\n101\n010\n101" > $kernel
    
    while read ltime sname target type texp n1 n2 nref dark flat x
    do
        (echo "$ltime" | grep -q "^#") && continue
        test "$type" != "o" && continue
        test "$setname" && test "$setname" != "$sname" && continue
        (! is_integer "$n1" || ! is_integer "$n2") && continue

        diff=bad.$sname.diff.pgm
        if [ -f $diff ]
        then
            echo "WARNING: reusing diff image $diff." >&2
        else
            AIimlist $sname "" pgm > $imlist 2>/dev/null
            test ! -s $imlist && AIimlist $sname "" raw > $imlist 2>/dev/null
            n=$(cat $imlist  | wc -l)
            test $n -eq 0 && echo "ERROR: no images found for set $sname." && continue
            test $n -le $nmax && echo "processing $n images in set $sname ..."
            test $n -gt $nmax && echo "processing $nmax out of $n images in set $sname ..."
            cat $imlist | head -$((n-(n-nmax)/2)) | tail -$nmax > $imlist2
            cat $imlist | awk -v n=$n -v nmax=$nmax '{
                if (NR==1) {
                    print $0; i=1
                } else {
                    x=int((nmax-1)/(n-1)*(NR-1)+0.5*nmax/n)
                    if (x>=i) {print $0; i++}
                }
            }' > $imlist2
            i=0; ilist=""
            while read x num fname x
            do
                echo $num
                if is_raw $fname && ! is_fits $fname && ! is_fitzip $fname
                then
                    black=$(grep "^$num" $exifdat | awk '{print $9}')
                    echo $ltime $sname $target $type $texp $num $num $num $dark $flat > $tmpset
                    AI_SETS=$tmpset AIccd -b $sname > /dev/null
                    fname=$tdir/$num.pgm
                    test ! -f $fname &&
                        echo "ERROR: could not create $fname." && i=0 && break
                    mv $fname $tmpim1
                    AIbnorm -k $tmpim1 > $fname
                fi
                i=$((i+1))
                test $i -eq 1 && thres=$(imcrop $fname | AIval -a - | kappasigma - | \
                    awk '{printf("%.0f", 3*$2)}')
                # kernel-median
                kmedian $fname $kernel 2> /dev/null > $tmpim1
                test $? -ne 0 && echo "ERROR: kmedian failed." >&2 && continue
                # mask, intensities above threshold in bg-subtracted median image
                #   are considered as real objects
                AIbgmap -q $tmpim1 "" 1
                pnmccdred -d $(basename ${tmpim1/.pnm/.bg.pgm}) $tmpim1 - | \
                    convert - -threshold $thres $mask
                rm $(basename ${tmpim1/.pnm/.bg.pgm}) $(basename ${tmpim1/.pnm/.bgm1.pgm})
                pnmcomp -alpha $mask $fname $tmpim1 - | \
                    pnmccdred -a 1000 -d - $fname $wdir/$num.pgm
                ilist="$ilist $num.pgm"
            done < $imlist2
            if [ $i -ne 0 ] && [ "$ilist" ]
            then
                (cd $wdir; pnmcombine -d $ilist $tmpim1)
                convert $tmpim1 -median 3 - | pnmccdred -a 1000 -d - $tmpim1 $diff
            fi
        fi
        
        # thresholding
        ! is_pnm $diff && continue
        rms=$(imcrop $diff 10 | AIval -a - | kappasigma - 1 5 3 | awk '{print $2}')
        high=$(echo $rms $hotthresh | awk '{printf("%.0f", $1*$2)}')
        low=$(echo $rms $coldthresh | awk '{printf("%.0f", -1*$1*$2)}')
        echo "thresholds:" $high $low >&2
        
        # apply thresholds, mask out margins at image border
        geom=${margin}x${margin}
        convert $diff -threshold $((1000+high)) \
            -shave $geom -bordercolor black -border $geom bad.$sname.high.png
        convert $diff -threshold $((1000+low)) -negate \
            -shave $geom -bordercolor black -border $geom bad.$sname.low.png
    done < $sdat
    rm -f $kernel $tmpset $imlist $imlist2
    test "$AI_DEBUG" || rm -f $tmpim1 $mask
    test "$AI_DEBUG" || rm -rf $wdir
    return 0
}


AIcosmics () {
    # detect cosmics by applying image filters and thresholds
    # starlike sources (measured by sextractor) are preserved
    # resulting b/w PBM image is written to stdout
    local showhelp
    local nostars
    local i
    for i in 1 2
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-d" && nostars=1 && shift 1
    done
    local img=$1
    local cthres=${2:-"10"}     # threshold/stddev for cosmic pixel candidates
    local bthres=${3:-"4"}      # threshold/stddev for saturated stars
    
    local tdir=${AI_TMPDIR:-"/tmp"}
    local ext
    local size
    local bgsd
    local bgm
    local n
    local fwhm
    local f10
    local thres
    local x
    local bgval=1000
    local scat=x.scat.dat
    local starsreg=x.stars.reg
    local brightmask=x.bright.pbm
    local obmask=x.obmask.pbm
    local cbigmask=x.cbig.pbm
    local csmallmask=x.csmall.pbm
    local kimg=$(mktemp $tdir/tmp_kimg_XXXXXX.pnm)
    local tmpim1=$(mktemp $tdir/tmp_im1_XXXXXX.pnm)
    local tmpim2=$(mktemp $tdir/tmp_im2_XXXXXX.pnm)
    local tmpmask1=$(mktemp $tdir/tmp_tmpmask1_XXXXXX.pbm)
    local tmpmask2=$(mktemp $tdir/tmp_tmpmask2_XXXXXX.pbm)
    local tmpmask3=$(mktemp $tdir/tmp_tmpmask3_XXXXXX.pbm)
    local starmask=$(mktemp $tdir/tmp_starmask_XXXXXX.pbm)
    local tmpdat1=$(mktemp $tdir/tmp_dat1_XXXXXX.dat)
    local tmpdat2=$(mktemp $tdir/tmp_dat2_XXXXXX.dat)
    
    (test "$showhelp" || test $# -lt 1 ) &&
        echo "usage: AIcosmics [-h] [-d] <image> [cthres|$cthres] [bgthres|$bgthres]" >&2 &&
        return 1

    ext=""
    is_pgm $img && ext="pgm"
    #is_ppm $img && ext="ppm"
    test -z "$ext" &&
        echo "ERROR: $img has unsupported image format." >&2 && return 255
    
    # bg subtraction and noise measurement
    size=$(gm identify $img | cut -d " " -f3 | cut -d '+' -f1)
    bgsd=$(AIbgmap -q -sd -m $img 32)
    bgm=$(basename ${img%.*})".bgm1".$ext
    gm convert $bgm -resize ${size}\! - | \
        pnmarith -sub $img - > $tmpim1
    rm -f $bgm

    # extract properties of star profiles, create starmask
    if [ ! "$nostars" ]
    then
        AIsource -q -o $scat $img "" 5 32 2>/dev/null
        sexselect $scat > $tmpdat1
        n=$(grep -v "^#" $tmpdat1 | awk '{if ($8<0.03) print $0}' | wc -l)
        grep -v "^#" $tmpdat1 | awk '{if ($8<0.03) print $0}' | \
            LANG=C sort -n -k7,7 | head -n $((n/2)) > $tmpdat2
        set - $(kappasigma $tmpdat2 4) $(kappasigma $tmpdat2 5) $(kappasigma $tmpdat2 6)
        fwhm=$5    
        LANG=C printf "# a=%.2f +- %.2f  e=%.2f +- %.2f  fwhm=%.2f +- %.2f\n" $1 $2 $3 $4 $5 $6 >&2
        cat $tmpdat1 | awk -v a=$1 -v da=$2 -v e=$3 -v de=$4 -v f=$5 -v df=$6 'BEGIN{
            alim=0.9*a-4.0*da; elim=1.3*e+4.0*de; flim=0.9*f-3.0*df-0.2
            printf("# stars: a>=%.2f  e<=%.2f  fwhm>=%.2f\n", alim, elim, flim)
            }{
                if ($1~/^#/) next
                if ($4 < alim) next
                if ($5 > elim) next
                if ($6 < flim) next
                print $0
            }' > $tmpdat2
        grep "^#" $tmpdat2 >&2
        echo -e "# Region file format: DS9 version 4.1" > $starsreg
        echo -e "global  color=green dashlist=8 3 width=1 font=\"helvetica 10 normal roman\"" \
            "select=1 highlite=1 dash=0 fixed=0 edit=0 move=0 delete=1 include=1 source=1" >> $starsreg
        grep -v "^#" $tmpdat2 | awk -v f=$fwhm '{
            printf("circle(%.2f,%.2f,%.2f)", $2, $3, 2+1.2*f)
            printf(" # text={%s %.1f}\n", $1, $7)}' >> $starsreg
        reg2pbm $img $starsreg > $starmask  # 1=star
        # test "$AI_DEBUG" && echo $tmpdat1 $tmpdat2 >&2

        # identify saturated stars including their spikes
        x=$(echo $fwhm | awk '{printf("%.0f", 1.3+$1/2)}')
        thres=$(echo $bthres $bgsd | awk '{printf("%.0f", $1*$2)}')
        echo "# sd=$bgsd  thres=$thres rad=$x (brightmask)" >&2
        gm convert $tmpim1 -threshold $thres $tmpmask1     # 1=bright
        # large objects
        convert $tmpmask1 -morphology Erode:$x Diamond $tmpmask2   # 1=center of big objects
        convert $tmpmask1 -negate $tmpmask3
        convert $tmpmask2 -mask $tmpmask3 -morphology Dilate:20 Diamond +mask $brightmask
    else
        fwhm=5
    fi


    # build circular kernel image, n=11
    f10=$(echo $fwhm | awk '{printf("%.0f", 10*$1)}')
    echo -e "P1\n7 7" > $kimg
    test $f10 -lt 30 && echo "
0 0 0 0 0 0 0
0 1 0 1 1 1 0
0 1 0 0 0 0 0
0 1 0 0 0 1 0
0 0 0 0 0 1 0
0 1 0 1 0 1 0
0 0 0 0 0 0 0" | tr -d ' ' >> $kimg
    test $f10 -ge 30 && echo "
0 0 1 0 1 0 0
1 0 0 0 0 0 1
0 0 0 0 0 0 1
1 0 0 0 0 0 0
1 0 0 0 0 0 1
0 0 0 0 0 0 0
0 1 0 1 0 1 0" | tr -d ' ' >> $kimg

    # old: version <2.8.1
    #echo -e "P1\n7 7\n0000000\n0010010\n0000000\n0100000\n0000010\n0001000\n0000000" > $kimg
    #test $f10 -ge 24 &&
    #    echo -e "P1\n7 7\n0000100\n0100000\n0000000\n0000001\n1000000\n0000000\n0001000" > $kimg
    #test $f10 -ge 32 &&
    #    echo -e "P1\n9 9\n000000000\n000010000\n001000000\n000000010\n010000000\n000000001\n000000000\n000100000\n000000100" > $kimg
    #test $f10 -ge 40 &&
    #    echo -e "P1\n9 9\n000100000\n000000010\n010000000\n000000000\n000000000\n100000000\n000000001\n001000000\n000000100" > $kimg


    # create and subtract median smoothed image
    kmedian $img $kimg 2>/dev/null > $tmpim2
    pnmccdred -a $bgval -d $tmpim2 $img $tmpim1

    # identify high signal pixels by thresholding tmpim1 (big cosmics)
    # remove protected areas (starmask, brightmask)
    thres=$(echo $cthres $bgsd | awk -v f=$fwhm '{
        m=0.6; if (f<2.8) m=0.7; if (f<2.3) m=0.8
        printf("%.0f", m*$1*$2)}')
    echo "# high signal pixels thres=$thres" >&2
    if [ -s $starmask ] && [ -s $brightmask ]
    then
        gm convert $tmpim1 -threshold $((thres+bgval)) pbm:- | \
            pnmarith -sub - $starmask | pnmarith -sub - $brightmask > $obmask    # 1=high
    else
        gm convert $tmpim1 -threshold $((thres+bgval)) pbm:- > $obmask
    fi
    
    # count object size in a disklike region
    convert $obmask -depth 16 \
        -define convolve:scale=0.00001526 -morphology Convolve Disk:2.5 pgm:- > $tmpim2

    # big cosmics (>4pix)
    # thresholding 16bit pgm uses intensity value, 8bit pgm uses percent
    gm convert $tmpim2 -threshold 4 - | pnmarith -mul - $obmask > $tmpmask2   # 1=center of big objects
    convert $obmask -negate $tmpmask3
    convert $tmpmask2 -mask $tmpmask3 -morphology Dilate:5 Diamond +mask $cbigmask
    
    # identify small objects (<=4pix) where max > cthres*stddev
    thres=$(echo $cthres $bgsd | awk '{printf("%.0f", $1*$2)}')
    echo "# small cosmics thres=$thres" >&2
    if [ -s $starmask ] && [ -s $brightmask ]
    then
        gm convert $tmpim1 -threshold $((thres+bgval)) pbm:- | \
            pnmarith -sub - $starmask | pnmarith -sub - $brightmask | \
            pnmarith -sub - $cbigmask > $tmpmask1    # 1=center of small cosmics
    else
        gm convert $tmpim1 -threshold $((thres+bgval)) pbm:- | \
            pnmarith -sub - $cbigmask > $tmpmask1    # 1=center of small cosmics
    fi
    convert $tmpmask1 -mask $tmpmask3 -morphology Dilate:3 Diamond +mask $csmallmask
   
    pnmarith -max $csmallmask $cbigmask
    
    test "$AI_DEBUG" && echo $tmpim1 $tmpim2 $starmask >&2 && return
    rm -f $kimg $tmpim1 $tmpim2 $starmask
    rm -f $tmpdat1 $tmpdat2 $tmpmask1 $tmpmask2
    return
}


AIgradient () {
    # apply radial gradient filter (Larsen-Sekanina)
    # result is written to stdout
    local showhelp
    (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
    local img=$1
    local center=${2:-""}   # center x,y in image coord or ds9 region file
                            # containing center point
    local rot=${3:-"20"}
    local offset=${4:-""}   # currently unused

    local ext
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmpim1=$(mktemp $tdir/tmp_im1_XXXXXX.pnm)
    local tmpim2=$(mktemp $tdir/tmp_im2_XXXXXX.pnm)
    local tmpim3=$(mktemp $tdir/tmp_im3_XXXXXX.pnm)

    (test "$showhelp" || test $# -lt 1 ) &&
        echo "usage: AIgradient [-h] <image> [center] [rot|$rot]" >&2 &&
        return 1

    ext=""
    is_pgm $img && ext="pgm"
    test -z "$ext" && is_ppm $img && ext="ppm"
    test -z "$ext" &&
        echo "ERROR: $img has unsupported image format." >&2 && return 255
    
    if is_reg $center
    then
        center=$(reg2xy $img $center | awk '{printf("%s,%s", $2, $3)}')
        test "$AI_DEBUG" && echo "# center=$center" >&2
    fi
    
    test "$AI_DEBUG" && echo "convert $img -distort SRT \"$center $rot\" $tmpim1" >&2
    convert $img -distort SRT "$center $rot" $tmpim1
    pnmccdred -a 10000 -d $tmpim1 $img $tmpim2
    rot=$(echo $rot | awk '{print -1*$1}')
    convert $img -distort SRT "$center $rot" $tmpim1
    pnmccdred -a 10000 -d $tmpim1 $img $tmpim3
    pnmarith -add $tmpim2 $tmpim3
    
    rm -f $tmpim1 $tmpim2 $tmpim3
    return
}


# tasks started by ds9 analysis commands
# requires a running instance of ds9 with name $DS9NAME
ds9cmd () {
    cmd=$1
    shift 1
    local tmp1=$(mktemp "/tmp/tmp1_xpa_XXXXXX.dat")
    local tmp2=$(mktemp "/tmp/tmp2_xpa_XXXXXX.dat")
    local tmpreg=$(mktemp "/tmp/tmp1_reg_XXXXXX.reg")
    local tmpmask=$(mktemp "/tmp/tmp1_mask_XXXXXX.pbm")
    local tmpim1=$(mktemp "/tmp/tmp1_im1_XXXXXX.pnm")
    local tmpfits1=$(mktemp "/tmp/tmp1_im1_XXXXXX.fits")
    local tmpfits2=$(mktemp "/tmp/tmp1_im2_XXXXXX.fits")
    local tmpdat1=$(mktemp "/tmp/tmp1_dat1_XXXXXX.dat")
    local ds9name=${DS9NAME:-""}
    local pardir=${UPARM:-"ds9param"}   # directory containing parameter files
    local envfile=$pardir/env.dat       # environment to load at start of any task
    local log=${AI_LOG:-"airtask.log"}
    local sdat=${AI_SETS:-"set.dat"}
    local wdir=$(pwd)
    local set
    local img
    local img2
    local hdr
    local starstack
    local cometstack
    local trail
    local oxy
    local rlim
    local merrlim
    local psfsize
    local ext
    local photcat
    local bgrgb
    local npix
    local narea
    local id
    local cnt
    local bgrgb
    local ddiff
    local line
    local bgfit10
    local comult
    local tel
    local catalog
    local maglim
    local thres
    local angle
    local bgmult
    local mask
    local aprad
    local skip
    local opts
    local topts
    local aopts
    local fname
    local idx
    local mzero
    local mag
    local xlist
    local x
    local y
    local n
    local badreg
    local str
    local north
    local ra
    local dec
    local binning
    local pixscale
    local url
    local object
    local script
    local isok
    local fittype
    local retval
    
    case $cmd in
        setinfo|test|dcontrast|regswitch)
                ;;
        *)      echo ""
                echo "#### AI_VERSION=$AI_VERSION ($(date -I))" >> $log
                ;;
    esac
    
    # load environment
    test -e $envfile &&
        echo "# loading environment ..." >> $log &&
        cat $envfile >> $log &&
        echo "" >> $log &&
        eval $(cat $envfile | grep "=" | sed -e 's/[ ]*=[ ]*/=/')

    test "$AI_DEBUG" && echo "# DEBUG mode is active (ds9name=$ds9name)"
    test "$AI_DEBUG" && (set -o posix; set) > airtask.env
    
    case $cmd in
        project) #echo "running project"
                # get names of all image sets
                test -f $sdat && str=$(grep -v "^#" $sdat | awk '{
                        x=$5""$6""$7; gsub(/[0-9]/,"",x); if($4=="o" && x==""){print $2}}' | \
                    tr '\n' '|' | sed -e 's/.$//')
                echo "# project dir: $(pwd)"
                echo "# image sets:"
                AIsetinfo -b
                echo
                echo "# ICQ records:"
                phot2icq -c
                echo ""
                ;;
        shorthelp)
                x=$(type -p airds9.ana)
                cat $x | awk '{
                    if($1=="help"){p="ok"; print substr($0,6) "\n"; next}
                    if($1=="endhelp") {p=""}
                    if(p!="") print $0
                }'
                echo ""
                ;;
        usermanual)
                x=/usr/share/doc/airtools-doc
                y="manual-"${LANG%_*}".html"
                test ! -e $x/$y && y="manual-en.html"
                test ! -e $x/$y && y=""
                test ! -e $x/$y && x=/usr/share/doc/airtools-core
                xdg-open $x/$y
                ;;
        expert) str=$(yad --title="AIRTOOLS Expert Menu" --borders=10 --width=400 \
                    --text="\n Run AIRTOOLS command:" --entry 2>/dev/null)
                test "$str" && echo "# $str" && $str
                echo ""
                ;;
        test)   img=$1
                echo "running test $img"
                echo "AI_VERSION=$AI_VERSION"
                echo "ds9name=$ds9name"
                echo "PATH=$PATH"
                echo "UPARM=$UPARM"
                echo "pardir=$pardir"
                echo "wdir=$wdir"
                echo "tmp1=$tmp1"
                echo "ana=$(type -p airds9.ana)"
                # cat $pardir/airtools.par
                echo "program sex is:" $(type -t sex)
                echo "running AIcheck_ok"
                AIcheck_ok
                retval=$?
                test $retval -ne 0 && echo "# ERROR: AIcheck failed" >&2

                # get image name
                if [ -z "$img" ]
                then
                    img=$(xpaget $ds9name fits header keyword AI_IMAGE)
                    test "$img" && echo "# img=$img"
                    # TODO: fallback to use currently displayed fits image
                fi
                test ! -e "$img" && echo "ERROR: missing image $img" >&2 &&
                    echo >&2 && return 255

                x=0
                false && while [ $x -lt 30 ] && [ ! -f /tmp/xxx ]
                do x=$((x+1)); echo $x >&2; sleep 1; done
                
                # switching DEBUG mode                
                if [ "$AI_DEBUG" ] && [ -e $envfile ]
                then
                    sed -i '/^AI_DEBUG[ ]*=/d' $envfile &&
                    echo "switching DEBUG mode OFF"
                else
                    touch $envfile
                    set_header $envfile AI_DEBUG=1 &&
                    echo "switching DEBUG mode ON"
                fi
                # opening new window leaves the task open
                # even if starting as background job
                xterm &
                
                echo "# test finished"
                echo ""
                return
                ;;
        dcontrast) # set display contrast using noise statistics
                #echo "running dcontrast"
                xpaget $ds9name imexam data 64 64 > $tmp1
                line=$(cat $tmp1 | tr ' ' '\n' | grep "[0-9]" | kappasigma -)
                test "$AI_DEBUG" && echo "stats: $line"
                set - $line
                test "$2" == "0" && echo "WARNING: constat data, no scaling." &&
                    return
                line=$(echo $1 $2 | awk '{printf("%f %f", $1-10*$2-20*sqrt($2), $1+20*$2+500*sqrt($2))}')
                test "$AI_DEBUG" && echo "limits: $line"
                xpaset -p $ds9name scale limits $line
                #xpaset $ds9name mode region
                ;;
        regswitch) # switch selected region color
                x=$(xpaget $ds9name regions color)
                case "$x" in
                    green)  xpaset -p $ds9name regions color red;;
                    red)    xpaset -p $ds9name regions color green;;
                    *)      ;;
                esac
                ;;
        regstat) img=$1
                echo "running regstat \"$img\""
                
                if [ -z "$img" ]
                then
                    img=$(xpaget $ds9name fits header keyword AI_IMAGE)
                    test -z "$img" && img=$(xpaget $ds9name file)
                    test "$img" && echo "# img=$img"
                fi
                test ! -e "$img" && echo "ERROR: missing image $img" >&2 &&
                    echo >&2 && return 255
                
                # measure stats for every single region
                printf "%6s %-5s  %-6s %-7s %-6s\n" \
                    "#bgmean" "stddev" "area" "sum" "mean"
                xpaset -p $ds9name regions system physical
                xpaset -p $ds9name regions save $tmp1
                xpaset -p $ds9name regions save x.empty.reg
                grep -iwE "^circle|^polygon|^box" $tmp1 | while read
                do
                    set - $(echo "$REPLY" | regstat -g $img -)
                    # bgmean sd   area sum mean reg
                    test "$1" == "${1/,/}" &&
                    LANG=C printf "%6.1f %5.1f  %6.0f %7.0f %6.1f # %s\n" $1 $2 $3 $4 $5 $6
                    test "$1" != "${1/,/}" &&
                    LANG=C printf "%s %s  %6.0f %s %s # %s\n" \
                        "${1//,/ }" "${2//,/ }" "${3//,/ }" "${4//,/ }" "${5//,/ }" "$6"
                done
                echo ""
                ;;
        imload) fname=$(yad --title="Open Image or Region file:" \
                    --borders=10 --width=800 --height=600 --file --multiple \
                    --file-filter="Image files | *.pgm *.ppm *.fits" \
                    --file-filter="Region files | *.reg" 2>/dev/null)
                test "$AI_DEBUG" && echo "files:" && echo "$fname" | tr '|' '\n'
                test "$fname" && AIexamine ${fname//|/ }
                echo ""
                ;;
        imflip) img=$1
                echo "running imflip \"$img\""
                
                # get image name
                if [ -z "$img" ]
                then
                    img=$(xpaget $ds9name fits header keyword AI_IMAGE)
                    test "$img" && echo "# img=$img"
                fi
                test ! -e "$img" && echo "ERROR: missing image $img" >&2 &&
                    echo >&2 && return 255

                # determine input image type
                ext=""
                is_pgm $img && ext="pgm"
                is_ppm $img && ext="ppm"
                    
                # check for cometstack
                cometstack=$(xpaget $ds9name fits header keyword AI_COMST)

                pnmflip -tb $img > x.$ext && mv x.$ext $img
                AIexamine -r $img
                
                test "$cometstack" && test -e "$cometstack" &&
                    test "$img" != "$cometstack" &&
                    echo "# Please run imflip on comet stack as well."
                echo ""
                ;;
        aladindss) img=$1
                test "$AI_DEBUG" && echo "running aladindss \"$img\""
                
                # get image name
                if [ -z "$img" ]
                then
                    img=$(xpaget $ds9name fits header keyword AI_IMAGE)
                    test "$img" && test "$AI_DEBUG" && echo "# img=$img"
                fi
                test ! -e "$img" && echo "ERROR: missing image $img" >&2 &&
                    echo >&2 && return 255
                
                # determine set name
                set=$(basename ${img%%.*})
                test ! -e $set.head &&
                    echo "ERROR: missing $set.head" >&2 && echo >&2 && return 255

                # determine approx. image center
                set - $(imcoord $set) "" ""
                ra=$1; dec=$2
                (test -z "$ra" || test -z "$dec") &&
                    echo "ERROR: missing image center coordinates" >&2 &&
                    echo >&2 && return 255
                
                # determine pixelscale
                binning=$(get_header -q $img BINNING)
                test -z "$binning" && binning=$(get_header -q $img XBINNING)
                test -z "$binning" && binning=1
                pixscale=$(get_param camera.dat pixscale $set | \
                    awk -v b=$binning '{print $1*b}')
                test -z "$pixscale" &&
                    echo "ERROR: cannot determine pixel scale" >&2 &&
                    echo >&2 && return 255

                # determine approx. fov
                x=$(imsize $img | awk -v p=$pixscale '{
                    w=$1*p/3600+0.02
                    h=$2*p/3600+0.02
                    printf("%.2fx%.2f", w, h)}')
                #echo "$ra $dec $x"
                
                if type -p aladin > /dev/null 2>&1
                then
                    # use the full featured desktop version
                    echo "$ra $dec;" > $tmpdat1
                    object=$(get_header -q $img OBJECT)
                    x=$(get_header -q -s $img AI_CORA,AI_CODEC | tr '\n' ',')
                    test "$x" && echo "draw red tag($x $object,60,30,bigcircle,16)" >> $tmpdat1
                    # TODO: check for running aladin instance
                    #ps -C aladin >/dev/null && echo ok
                    echo "# aladin script commands: "
                    cat $tmpdat1 | sed -e 's,^,  ,'
                    cat $tmpdat1 | aladin &
                else
                    # use aladin lite online version
                    # TODO: get displayed image size
                    url="http://aladin.u-strasbg.fr/AladinLite/?target=$ra%20$dec&fov=1"
                    test "$AI_DEBUG" && echo "url=$url"
                    xdg-open "$url" 3>&1 1>&2 2>&3 3>&- | grep -vi "GLib-GObject-CRITICAL **: g_object_.*ref: assertion"
                fi
                echo ""
                ;;
        wcscalib) img=$1
                catalog=$2
                maglim=$3
                thres=$4
                north=$5
                opts=$6     # e.g.: -x '-DISTORT_DEGREES 5'
                echo "running wcscalib \"$img\" $catalog \"$maglim\" \"$thres\" \"$north\" \"$opts\""
                
                # get image name
                if [ -z "$img" ]
                then
                    img=$(xpaget $ds9name fits header keyword AI_IMAGE)
                    test "$img" && echo "# img=$img"
                fi
                test ! -e "$img" && echo "ERROR: missing image $img" >&2 &&
                    echo >&2 && return 255
                
                # determine set name
                set=$(basename ${img%%.*})
                test ! -e $set.head &&
                    echo "ERROR: missing $set.head" >&2 && echo >&2 && return 255
                
                # get initial magzero and saturation
                # TODO: should be implemented by AIsource
                mzero=$(get_header -q $set.head MAGZERO)
                test -z "$mzero" && mzero=$(get_param camera.dat magzero $set AI_MAGZERO)
                x=$(get_header -q $set.head SATURATE)
                test -z "$x" && x=$(get_param camera.dat satur $set AI_SATURATION)
                echo "# magzero=$mzero saturation=$(echo $x | awk '{printf("%.0f", $1)}')"
                
                test "$north" && north="-n $north"
                str="AI_MAGZERO=$mzero AIwcs $opts -q -f $north $set $catalog \"$maglim\" $thres"
                echo "#" $str >&2co01.bgm10res.ppm
                eval $str
                if [ $? -eq 0 ] && [ -s $set.wcs.head ]
                then
                    ls wcs/$set*.png > /dev/null 2>&1 &&
                        display wcs/$set*.png &
                    echo "$cmd finished"
                fi
                echo ""
                ;;
        bggradient) img=$1
                bgmult=$2
                fittype=${3:-"plane"}
                echo "running bggradient \"$img\" $bgmult $fittype"
                
                # fittype option for AIbgmap
                opts="-p"
                test "$fittype" == "surface" && opts="-s"
                
                # get image name
                if [ -z "$img" ]
                then
                    img=$(xpaget $ds9name fits header keyword AI_IMAGE)
                    test "$img" && echo "# img=$img"
                fi
                test ! -e "$img" && echo "ERROR: missing image $img" >&2 &&
                    echo >&2 && return 255

                # determine input image type
                ext=""
                is_pgm $img && ext="pgm"
                is_ppm $img && ext="ppm"
                
                # determine set name
                set=$(basename ${img%%.*})
                test ! "$(AIsetinfo -b $set)" && set=$(basename ${img%.*})
                
                # check for cometstack
                cometstack=$(get_header -q $img AI_COMST)
                #cometstack=$(xpaget $ds9name fits header keyword AI_COMST)
                # fallback for older airfun versions
                test -z "$cometstack" && test -e ${set}_m.$ext &&
                    cometstack=${set}_m.$ext
                test -z "$cometstack" && test -e ${set}_cs.$ext &&
                    cometstack=${set}_cs.$ext
                test "$cometstack" && test ! -e "$cometstack" &&
                    echo "ERROR: missing comet stack $cometstack" >&2 &&
                    echo >&2 && return 255

                # determine badbg region file
                test -d bgcorr || mkdir bgcorr
                badbg=bgcorr/$set.badbg.reg
                
                # info
                test -z "$cometstack" &&
                    echo "WARNING: no comet stack" >&2 &&
                    echo "# using badbg=$badbg"
                test "$cometstack" &&
                    echo "# using badbg=$badbg cometstack=$cometstack"

                # check for existing bg image
                bgimg=""
                test -f bgcorr/$set.bgm${bgmult}.$ext    && bgimg=bgcorr/$set.bgm${bgmult}.$ext
                test -f bgcorr/$set.bgm${bgmult}all.$ext && bgimg=bgcorr/$set.bgm${bgmult}all.$ext
                
                # check if badbg is not empty
                isok=""
                test -s $badbg && grep -q -E "^circle|^polygon|^box|^ellipse" $badbg && isok="has_badbg"
                
                # determine bg mask
                mask=""
                test -s $badbg && test "$isok" && mask=$badbg
                test -z "$mask" && test -f bgcorr/$set.bgmask.png &&
                    mask=bgcorr/$set.bgmask.png &&
                    echo "WARNING: reusing old mask image $mask"
                if [ ! "$mask" ] 
                then
                    # get regions from current frame
                    echo "# saving regions from current frame to $badbg"
                    xpaset -p $ds9name regions system physical
                    xpaset -p $ds9name regions save $badbg
                    mask=$badbg
                fi

                if [ "$bgimg" ] && [ $bgimg -nt $badbg ] && is_pnm $bgimg
                then
                    echo "reusing bg gradient image $bgimg"
                    # show stats only
                    (cd bgcorr
                    AIbgmap -stats -x 75 -q ../$set.$ext 64 1 ../$mask $bgmult)
                else
                    (cd bgcorr
                    AIbgmap $opts -d -m -x 75 -q ../$set.$ext 64 1 ../$mask $bgmult)
                    test $? -ne 0 &&
                        echo "ERROR: bggradient failed" \
                            "(hint: lower bgmult to avoid saturation)" >&2 &&
                        echo >&2 && return 255
                    test -f bgcorr/$set.bgm${bgmult}.$ext && bgimg=bgcorr/$set.bgm${bgmult}.$ext
                fi
                
                # bg corrected images
                if [ "$bgimg" ]
                then
                    echo "creating bg corrected images ..."
                    imbgsub $img   $bgimg "" $bgmult > ${img%.*}.bgs.$ext
                    test ! -e ${img%.*}.bgs.head &&
                        ln -s $set.head ${img%.*}.bgs.head
                    test "$cometstack" &&
                        imbgsub $cometstack  $bgimg "" $bgmult > ${cometstack%.*}.bgs.$ext &&
                        test ! -e ${cometstack%.*}.bgs.head &&
                            ln -s $set.head ${cometstack%.*}.bgs.head
                    #AIexamine ${starstack%.*}.bgs.$ext
                fi
                echo "displaying check images ..."
                #AIexamine $set.bgs.$ext &
                AIexamine -n Backgrounds -s -s -l -p "-zoom to fit -frame last -scale mode minmax \
                    -frame first -scale mode 99.5" bgcorr/$set.bgm${bgmult}{res,n}.$ext &
                # xpaset -p Backgrounds cmap value 1.5 0.3
                echo "$cmd finished"
                echo ""
                ;;
        psfextract) set=$1
                starstack=$2
                rlim=$3
                merrlim=$4
                psfsize=$5
                skip=$6
                ext=""
                echo "running psfextract $set $starstack \"$rlim\" \"$merrlim\" \"$psfsize\""
                test "$skip" && echo "skip=$skip"
                
                test ! -f $set.head &&
                    echo "ERROR: missing header file $set.head." &&
                    echo "" && return 255
                
                # determine input image type
                is_pgm $starstack && ext="pgm"
                is_ppm $starstack && ext="ppm"
                
                # determine cometstack
                cometstack=$(get_header $starstack AI_COMST)
                test "$cometstack" && test ! -e "$cometstack" &&
                    echo "ERROR: image $cometstack not found." >&2 && echo "" && return 255
                
                # check for bg subtracted images
                test -f ${starstack%.*}.bgs.$ext &&
                    starstack=${starstack%.*}.bgs.$ext &&
                    echo "# bg subtracted star stack found: $starstack"
                test "$cometstack" && test -f ${cometstack%.*}.bgs.$ext &&
                    cometstack=${cometstack%.*}.bgs.$ext &&
                    echo "# bg subtracted comet stack found: $cometstack"
                test ! -e ${starstack%.*}".head" && ln -s $set.head ${starstack%.*}".head"
                test "$cometstack" && test ! -e ${cometstack%.*}".head" && ln -s $set.head ${cometstack%.*}".head"
                
                # check for comet position keywords
                oxy=""
                set - $(get_header -s $set.head AI_CORA,AI_CODEC) xx
                test $# -eq 3 &&
                    oxy=$(echo comet $1 $2 | rade2xy - $set.wcs.head | awk '{printf("%.0f,%.0f", $2, $3)}')
                test -z "$oxy" && set - $(get_header -s $set.head AI_OXY) xx &&
                    test $# -eq 2 && echo "# using AI_OXY=$1" >&2 && oxy=$1
                
                if [ "$cometstack" ]
                then
                    test -z "$oxy" && echo "ERROR: missing comet position keywords." &&
                        echo "" && return 255
                    # determine comet motion
                    set - $(get_header $set.head AI_OMOVE) x
                    test $# -ne 2 &&
                        echo "ERROR: missing comet motion keyword." &&
                        echo "" && return 255
                    str=$1
                    
                    # get trail parameters from image header
                    str="${str}@$oxy"
                    echo "# str=$str"
                    trail=$(get_header -q $set.head AI_TRAIL)
                    test -z "$trail" && trail=$(omove2trail $set $str 2>/dev/null)
                    test -z "$trail" && x=$(get_header -q $set.head EXPTIME) &&
                        trail=$(omove2trail -d $(echo $x | awk '{print $1/60}') $set $str)
                    test -z "$trail" &&
                        echo "ERROR: cannot determine comet trail parameters." && echo "" && return 255
                    # if required (AI_TRAIL without angle) append angle to trail
                    test $(echo $trail | tr ',' '\n' | wc -l) -eq 1 &&
                        trail=$trail","$(echo $str | cut -d '@' -f2)
                    echo "# trail=$trail" >&2
                fi
                
                # remove previous psf
                test -d comet || mkdir comet
                rm -f comet/$set.*psf.$ext
                
                # check if psfsize has changed
                x=$(get_header -q $set.head AI_PSFSZ)
                if [ "$x" ]
                then
                    x=$(echo $psfsize $x  | awk -v s=4 '{printf("%d", s*($1-$2)/2)}')
                    if [ $x -ne 0 ]
                    then
                        echo "# detected change of psfsize (shift masks by $x pix)"
                        # shift masks
                        for mask in comet/$set.starmask.reg comet/$set.trailmask.reg
                        do
                            test -s $mask && regshift $mask $x $x > $tmpreg && mv $tmpreg $mask
                        done
                    fi
                fi
                
                # check if rlim has changed
                x=$(get_header -q $set.head AI_PSFRL)
                if [ "$x" ] && ! is_equal $x $rlim
                then
                    rm -f comet/$set.psfphot.dat
                    skip=""
                    echo "# new skip=\"\" (rlim changed)"
                else
                    # add marked bad objects (red) to variable skip
                    xpaset -p $ds9name regions system physical
                    xpaset -p $ds9name regions save $tmp1
                    xpaset -p $ds9name regions save x.empty.reg
                    x=$(grep "^circle(.* color=red text" $tmp1 | tr ' ' '\n' | grep "^text" | \
                        tr '={' ' ' | awk '{printf("%s\n", $2)}')
                    if [ "$x" ]
                    then
                        skip=$(echo $skip $x | tr ' ' '\n' | sort -un | tr '\n' ' ')
                        echo "# new skip=$skip"
                    fi
                fi

                # skip stars from being used in psf extraction
                if [ "$skip" ] && [ -f comet/$set.psfphot.dat ]
                then
                    for id in ${skip//,/ }
                    do
                        sed --follow-symlinks -i 's/^'$id' /#'$id'/' comet/$set.psfphot.dat
                    done
                fi
                
                # extract PSF's
                test ! -e comet/$set.src.dat &&
                    echo "# extract sources ..." &&
                    AIsource -q -o comet/$set.src.dat $set.$ext "" 5 20 64 0.0005
                echo "$(date +'%H:%M:%S')  AIpsfextract on star stack ..."
                test "$AI_DEBUG" &&
                    echo "AIpsfextract $starstack" \
                    "comet/$set.src.dat \"$oxy\" $rlim $merrlim $psfsize" >&2
                AIpsfextract $starstack comet/$set.src.dat "$oxy" $rlim $merrlim $psfsize
                test $? -ne 0 &&
                    echo "ERROR: AIpsfextract has failed." && echo "" && return 255
                #echo "# BREAK"
                #return
                
                if [ "$cometstack" ]
                then
                    echo "$(date +'%H:%M:%S')  AIpsfextract on comet stack ..."
                    test "$AI_DEBUG" &&
                        echo "AIpsfextract -t $trail $cometstack" \
                        "comet/$set.src.dat \"$oxy\" $rlim $merrlim $psfsize" >&2
                    AIpsfextract -t $trail $cometstack comet/$set.src.dat "$oxy" $rlim $merrlim $psfsize
                fi
                
                # star subtracted check image
                echo "# creating check images ..."
                xy2reg $starstack comet/$set.starphot.dat "" "" 4 > x.all.reg
                xy2reg $starstack comet/$set.psfphot.dat "" "" 16 > x.psf.reg
                AIexamine x.stsub.$ext x.psf.reg
                xpaset -p $ds9name scale mode zmax
                xpaset -p $ds9name cmap value 2.5 0.15

                # check if psf stars are free of companions (new ds9 window)
                echo "# display check images ..."
                if [ "$cometstack" ]
                then
                    echo "comet ${oxy/,/ }" | xy2reg $starstack - > x.comet.reg
                    AIexamine -n PSF -s -s -p "-zoom to fit" \
                        comet/$set.starpsf.$ext  comet/$set.starmask.reg \
                        comet/$set.trailpsf.$ext comet/$set.trailmask.reg &
                else
                    AIexamine -n PSF -s -s -p "-zoom to fit" \
                        comet/$set.starpsf.$ext  comet/$set.starmask.reg &
                fi
                echo "$cmd finished"
                echo ""
                ;;
        cometextract) set=$1
                starstack=$2
                bgfit10=$3
                comult=$4
                opts=$5
                ext=""
                echo "running cometextract $set $starstack \"$bgfit10\" \"$comult\" \"$opts\""
                
                # determine input image type
                is_pgm $starstack && ext="pgm"
                is_ppm $starstack && ext="ppm"
                
                # determine cometstack
                cometstack=$(get_header $starstack AI_COMST)
                test -z "$cometstack" &&
                    echo "ERROR: cometstack undefined." >&2 && echo "" && return 255
                test ! -e "$cometstack" &&
                    echo "ERROR: image $cometstack not found." >&2 && echo "" && return 255

                # check for bg subtracted images
                test -f ${starstack%.*}.bgs.$ext &&
                    starstack=${starstack%.*}.bgs.$ext &&
                    echo "# bg subtracted star stack found: $starstack"
                test -f ${cometstack%.*}.bgs.$ext &&
                    cometstack=${cometstack%.*}.bgs.$ext &&
                    echo "# bg subtracted comet stack found: $cometstack"
                test ! -e ${starstack%.*}".head" && ln -s $set.head ${starstack%.*}".head"
                test ! -e ${cometstack%.*}".head" && ln -s $set.head ${cometstack%.*}".head"
                
                # determine comet position
                set - $(get_header -s $set.head AI_CORA,AI_CODEC,AI_OMOVE)
                test $# -ne 3 &&
                    echo "ERROR: missing parameters (comet position or move)." &&
                    echo "" && return 255
                str=$3
                oxy=$(echo comet $1 $2 | rade2xy - $set.wcs.head | awk '{printf("%.0f,%.0f", $2, $3)}')
                
                # get trail parameters from image header
                str="${str}@$oxy"   # omove parameter in AIcomet
                
                get_jd_dmag $set 2>/dev/null > x.obs.dat
                test ! -s x.obs.dat &&
                    echo "# WARNING: time stamp of individual exposures in set $set is unknown." &&
                    get_jd_dmag -g $set 2>/dev/null > x.obs.dat
                test ! -s x.obs.dat &&
                    echo "ERROR: unable to guess time stamp of individual exposures." &&
                    echo "" && return 255
                    
                # comet extraction and photometry
                xy2reg $starstack comet/$set.starphot.dat > x.stars.reg
                test "$bgfit10" && opts="-b $bgfit10 $opts"
                test "$AI_DEBUG" && echo "AIcomet -m $comult $opts $starstack" \
                    "$cometstack $str x.obs.dat" >&2
                AIcomet -m $comult $opts $starstack $cometstack $str x.obs.dat
                x=$(cat comet/$set.*reg | grep -vE "DS9|global|physical" | wc -l)
                y=$(cat comet/$set.*reg | grep -vE "DS9|global|physical" | sort -u | wc -l)
                test $x -ne $y &&
                    echo "WARNING: duplicate regions in comet/*reg"

                # check star removal
                test -s comet/$set.newphot.dat &&
                    xy2reg $starstack comet/$set.newphot.dat > x.newphot.reg
                echo "# display check images ..."
                badreg=comet/$set.bad.reg; test ! -f $badreg && badreg=""
                AIexamine x.cosub.$ext x.$set.blur.$ext comet/$set.comet*.reg $badreg \
                    x.stsub.$ext x.resid.$ext x.newphot.reg
                xpaset -p $ds9name scale mode zmax
                xpaset -p $ds9name cmap value 2.5 0.15
                echo "$cmd finished"
                echo ""
                ;;
        regphot) img=$1
                bgrgb=${2:-1000}
                #ddiff=${5:-""}   # double star with given mag diff
                echo "running: regphot \"$img\" $bgrgb"
                
                # get image name
                if [ -z "$img" ]
                then
                    img=$(xpaget $ds9name fits header keyword AI_IMAGE)
                    test "$img" && echo "# img=$img"
                fi
                test ! -e "$img" && echo "ERROR: missing image $img" >&2 &&
                    echo >&2 && return 255

                # derive set name
                set=$(basename ${img%%.*})

                # check header file name
                if ! is_setname $set
                then
                    test ! -e ${img%.*}.head &&
                        echo "ERROR: missing header file ${img%.*}.head" >&2 &&
                        return 255
                    str=$(basename $(readlink -f ${img%.*}.head))
                    set=${str%%.*}
                fi
                photcat=comet/$set.newphot.dat
                test ! -e $photcat &&
                    echo "WARNING: missing photcat=$photcat" >&2 &&
                    photcat=""
                echo "# set=$set photcat=$photcat"
                
                npix=$(identify $img | cut -d ' ' -f3 | awk -F 'x' '{print $1*$2}')
                xpaset -p $ds9name regions background
                xpaset -p $ds9name regions system physical
                xpaset -p $ds9name regions save $tmp1
                cat $tmp1 | grep "(.*) #.* color=red" > $tmp2
                n=$(cat $tmp2 | wc -l)
                test "$AI_DEBUG" && test $n -gt 0 && echo "# red regions: $n"
                if [ $n -eq 0 ]
                then
                    cat $tmp1 | grep "(.*) #.* background" > $tmp2
                    n=$(cat $tmp2 | wc -l)
                    test "$AI_DEBUG" && test $n -gt 0 && echo "# selected: $n"
                fi
                xpaset -p $ds9name regions source
                xpaset -p $ds9name regions save x.empty.reg
                test $n -eq 0 &&
                    echo "ERROR: no region selected." >&2 &&
                    echo && return 255
                test $n -gt 1 &&
                    echo "measuring $n regions ..."
                
                while read
                do
                    id=$(echo $REPLY | tr ' ' '\n' | tr -d '}' | \
                        grep "^text={" | cut -d '{' -f2)
                    echo -e "# Region file format: DS9 version 4.1
global color=green dashlist=8 3 width=1 font=\"helvetica 10 normal roman\" \
select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1
physical" > $tmpreg
                    echo "$REPLY" >> $tmpreg
                    reg2pbm $img $tmpreg > $tmpmask
                    narea=$(identify -verbose $tmpmask | grep FFFFFF | tr -d ':' |
                        awk '{print $1}')
                    x=$(echo $narea | awk '{printf("%.0f", 2*sqrt($1/3.1416))}')
                    pnmarith -mul $img $tmpmask 2>/dev/null > $tmpim1
                    ! is_pnm $tmpim1 &&
                        echo "ERROR: pnmarith failed." >&2 &&
                        echo && return 255
                    cnt=$(identify -verbose $tmpim1 | grep -i "mean:" | head -3 | \
                        awk -v n=$npix -v a=$narea '{
                            if(NR>1) printf(","); printf("%.1f", $2*n/a)
                        }')
                    test $n -gt 1 && echo ""
                    echo "# id=\""$id"\"  cnt=$cnt  narea=$narea  d=$x"
                    newmag $set "$photcat" "$id" $narea $cnt 1 $bgrgb
                    test $? -ne 0 &&
                        echo "ERROR: in newmag $set \"$photcat\" \"$id\" $narea $cnt 1 $bgrgb" >&2 &&
                        echo
                done < $tmp2
                echo "$cmd finished"
                echo ""
                ;;
        manualdata) set=$1
                idx=$2
                shift 2
                #"$ccorr" "$stlim" "$dtlen" "$dtang" "$ptlen" "$ptang"
                #echo "running manualdata $set $idx \"$1\" \"$2\" \"$3\" \"$4\" \"$5\" \"$6\""
                test ! -f $set.head &&
                    echo "ERROR: file $set.head is missing." >&2 && return 255
                set_header $set.head \
                    AI_ACOR$idx="$1/Manual correction of measured ADU" \
                    AI_ALIM$idx="$2/Limiting star total ADU" \
                    AI_DLEN="$3/Dust tail length in pixel" \
                    AI_DANG="$4/Dust tail angle in image (right=0)" \
                    AI_PLEN="$5/Plasma tail length in pixel" \
                    AI_PANG="$6/Plasma tail angle in image (right=0)"
                echo ""
                ;;
        photcal) set=$1
                idx=$2
                catalog=$3
                color=$4
                aprad=$5
                topts=$6
                aopts=$7
                skip=$8
                echo "running photcal $set $idx $catalog \"$color\" \"$aprad\" \"$topts\" \"$aopts\""
                test "$skip" && echo "skip=$skip"
                test "$color" != "V" && test "$color" != "V+c(B-V)" &&
                    echo "# WARNING: the choosen color function to fit is highly EXPERIMENTAL !!" >&2
                
                # check upper limit on aprad
                test "$aprad" && test "$(echo $aprad | awk -v max=20 '{if($1>max){print "LIMIT"}}')" &&
                    echo "ERROR: exceeding aprad limit of 20pix" >&2 && return 255
                    
                # note aboute already rejected stars
                str=""
                test -e phot/$set.$catalog.xphot.dat &&
                    str=$(grep "^#" phot/$set.$catalog.xphot.dat | sed -e 's/^[# ]*//' | awk '{
                        if($2!~/^[[:digit:]*$]/) next
                        if($3!~/^[[:digit:]*$]/) next
                        if($4!~/^[[:digit:]*$]/) next
                        if($5!~/^[[:digit:]*$]/) next
                        if($6!~/^[[:digit:]*$]/) next
                        printf("%s\n", $1)
                        }' | tr '\n' ' ')
                test "$str" && echo "# old skip=$str"
                
                # add marked bad objects (red) to variable skip
                xpaset -p $ds9name regions system physical
                xpaset -p $ds9name regions save $tmp1
                xpaset -p $ds9name regions save x.empty.reg
                x=$(grep "^circle(.* color=red text" $tmp1 | tr ' ' '\n' | grep "^text" | \
                    tr '={' ' ' | awk '{printf("%s\n", $2)}')
                if [ "$x" ]
                then
                    skip=$(echo $skip $x | tr ' ' '\n' | sort -u | tr '\n' ' ')
                    echo "# new skip=$skip"
                fi

                # color band
                opts="-"$(echo ${color//[+c()]/ } | cut -d ' ' -f1)
                # color index
                x=$(echo ${color//[+c()]/ } | sed -e 's|^.||' | tr -d '\- ' | tr '[A-Z]' '[a-z]')
                test "$x" && opts="$opts -$x"
                test "$catalog" == "tycho2" && opts="$opts $topts"
                test "$catalog" == "apass"  && opts="$opts $aopts"
                test "$AI_DEBUG" && echo "AIphotcal -s \"$skip\" $opts $set" \
                    "$catalog $aprad" >&2
                AIphotcal -s "$skip" $opts $set $catalog $aprad
                test $? -ne 0 && echo && return 255
                
                # show results
                if [ "$(get_header -q $set.head AP_CMAG1)" ]
                then
                    echo ""
                    echo "# ICQ data:"
                    phot2icq -v -c $set $catalog
                fi
                
                # remove some temp files
                if [ -z "$AI_DEBUG" ]
                then
                    x=$(ls x.* 2>/dev/null | \
                        grep -vE "x.psf.reg|x.obs.dat|x.stars.reg|x.$set.$catalog")
                    test "$x" && rm $x
                fi

                echo "$cmd finished"
                echo ""
                ;;
        *)      echo "WARNING: unknown command: $cmd"
                ;;
    esac
    rm -f $tmp1 $tmp2 $tmpreg $tmpim1 $tmpmask $tmpfits1 $tmpfits2 $tmpdat1
}

# collect some information about image sets
# TODO:
#   default: set target type n1 n2 nref texp n flen fr camera iso t ts black
#   long:    day set object ra de jd_ref utdate uttime alt moon(p,d,alt) bgg rmsg fwhm
AIsetinfo () {
    local showhelp
    local otype
    local longinfo
    local baseinfo          # query set.dat only
    local do_skip_header    # if set skip header line
    local do_skip_no_images=1
    local i
    for i in 1 2 3 4 5 6 7
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-o" && otype="o" && shift 1
        test "$1" == "-c" && otype="c" && shift 1
        test "$1" == "-b" && baseinfo=1 && shift 1
        test "$1" == "-l" && longinfo=1 && shift 1
        test "$1" == "-q" && do_skip_header=1 && shift 1
        test "$1" == "-x" && do_skip_no_images="" && shift 1
    done
    local setname=${1:-""}
    local exifdat="exif.dat"
    local rawfilesdat="rawfiles.dat"
    local sdat=${AI_SETS:-"set.dat"}
    local ex=${AI_EXCLUDE:-""}  # space separated list of image numbers
    local tdir=${AI_TMPDIR:-"/tmp"}
    local tmp1=$(mktemp "$tdir/tmp_dat1.XXXXXX.dat")
    local ltime
    local sname
    local target
    local type
    local texp
    local n1
    local n2
    local nref
    local dark
    local flat
    local telid
    local nexp
    local jdref
    local rms
    local bg
    local fwhm
    local flength
    local fratio
    local iso
    local tsens
    local black
    local retval

    test "$showhelp" &&
        echo "usage: AIsetinfo [-o|-c] [-b|-l] [-x] [setname]" >&2 &&
        return 1

    test ! -f $sdat &&
        echo "ERROR: set data file $sdat is missing." >&2 &&
        return 255
    #test ! -f $exifdat &&
    #    echo "ERROR: exif data file $exifdat is missing." >&2 &&
    #    return 255

    test "$setname" && ! is_setname $setname &&
        echo "ERROR: set name $setname is not defined in $sdat." >&2 &&
        return 255

    if [ -z "$setname" ] && [ ! "$do_skip_header" ]
    then
        if [ ! "$baseinfo" ] && [ ! "$longinfo" ]
        then
            echo "#set target type nref flen fr   iso  texp  n  ts black tel"
            #     dk01 bias     d  0011  530 5.0    -   0.0 10 -15    -  T14
        else
            if [ "$baseinfo" ]
            then
                echo "# LT  set  target type texp n1 n2   nref dark flat tel"
            else
                echo "# date  set   object   ra+de     jd_ref     texp n  rms   bg fwhm tel site"
                #     170802m co01  2017O1   0000+000       0.000 120  5  0.0    0 0.0  T14 Mayhill
            fi
        fi
    fi
    
    if [ "$baseinfo" ]
    then
        grep -v "^#" $sdat | sed -e 's|#.*||' | awk -v s="$setname" -v o="$otype" '{
            if ($1!~/^[0-9][0-9]:[0-9][0-9]/) next
            #if ($2!=s) next
            if ($5!~/^[0-9]+$/) next
            if ($6!~/^[0-9]+$/) next
            if ($7!~/^[0-9]+$/) next
            if ($8!~/^[0-9]+$/ && $8!="-") next
            if (NF<10) next

            if (s!="" && s!=$2) next
            if (o!="" && o=="c" && $4!="d" && $4!="f") next
            if (o!="" && o!="c" && $4!=o) next
            gsub(/ $/,"")
            if (NF == 10) {printf("%-50s -\n"), $0} else {print $0}
            }' | tee $tmp1
        retval=255
        test -s $tmp1 && retval=0
        rm -f $tmp1
        return $retval
    fi

    while read ltime sname target type texp n1 n2 nref dark flat telid x
    do
        test "${ltime:0:1}" == "#" && continue
        test "$setname" && test "$sname" != "$setname" && continue
        test "$otype" && test "$otype" != "c" && test "$type" != "$otype" && continue
        test "$otype" && test "$otype" == "c" &&
            test "$type" != "d" && test "$type" != "f" && continue
        test "$longinfo" && test "$type" != "o" && continue
        is_integer $n1 || continue
        is_integer $n2 || continue
        test "$type" == "a" && continue
        
        # evaluate header file
        nexp=0; rms=0; bg=0; fwhm=0; jdref=0 
        if [ -f $sname.head ]
        then
            x=$(get_header -q $sname.head OBJECT | sed -e 's/^ *//; s/ *$//')
            test "$x" && target=$x
            x=$(get_header $sname.head NEXP); test "$x" && nexp=$x
            test $nexp -gt 0 &&
                x=$(get_header $sname.head EXPTIME | awk -v n=$nexp '{print $1/n}') &&
                test "$x" && texp=$x
            x=$(get_header -q $sname.head JD_OBS)
            test -z "$x" && x=$(get_header -q $sname.head MJD_OBS)
            test -z "$x" && x=$(get_header -q $sname.head MJD_REF)
            test -z "$x" && x=$(get_header -q $sname.head JD)
            test "$x" && jdref=$(echo $x | awk '{printf("%.3f\n", $1)}')
            if [ "$longinfo" ]
            then
                x=$(get_header $sname.head AI_RMSG); test "$x" && rms=$x
                x=$(get_header $sname.head AI_BGG);  test "$x" && bg=$x
                x=$(get_header $sname.head AI_FWHM); test "$x" && fwhm=$x
            fi
        fi
        if [ $nexp -eq 0 ]
        then
            test "$type" == "o" && nexp=$(AIimlist -q -f $sname 2>/dev/null | wc -l)
            # if nexp is missing make best guess
            test $nexp -eq 0 && test -d "$tdir" &&
                nexp=$(AIimlist -q -f $sname 2>/dev/null | wc -l)
            test $nexp -eq 0 && test -d "$AI_RAWDIR" && nexp=$(AIimlist -q -f $sname "" raw 2>/dev/null | wc -l)
            # if nexp is still missing evaluate set.dat
            if [ $nexp -eq 0 ]
            then
                nexp=$(seq $n1 $n2 | wc -l)
                # try to find associated images of the same set (splitted sets)
                nexp=$(grep -w $sname $sdat | awk -v e=$texp -v n1=$n1 -v n2=$n2 -v n=$nexp '{
                    if ($1!~/^#/ && $4=="a" && $5==e && $6!=n1 && $7!=n2) {
                        n=n+$7-$6+1
                    }}END{print n}')
            fi
        fi
        
        
        # if $sname.head does not contain jd try to read from measure/$nref.src.head
        if [ "$jdref" == "0" ] && [ -f measure/$nref.src.head ]
        then
            x=$(grep -E "^MJD_OBS|^JD " measure/$nref.src.head | head -1 | \
                awk '{printf("%.3f\n", $3)}'); test "$x" && jdref=$x
        fi
        
        # TODO: determine length from first to last exposure
        # TODO: convert jdref to UT date and time
        
        # try to get ra/de from wcs header file
        ra=""; de=""
        test "$longinfo" &&
        if [ -f $sname.wcs.head ]
        then
            ra=$(dec2sexa -m $(grep "^CRVAL1 " $sname.wcs.head | awk '{print $3}') 15 0)
            de=$(dec2sexa -h $(grep "^CRVAL2 " $sname.wcs.head | awk '{print $3}') 1 1)
        fi
        if [ -z "$ra" ] || [ -z "$de" ]
        then
            hdr=$sname.head
            if [ -f $hdr ]
            then
                x=$(get_header -q $hdr RA);  test "$x" && ra=$(dec2sexa -m $(sexa2dec "$x" 15) 15 0)
                x=$(get_header -q $hdr DEC); test "$x" && de=$(dec2sexa -h $(sexa2dec "$x") 1 1)
            fi
        fi
        if [ -z "$ra" ] || [ -z "$de" ]
        then
            hdr=measure/$nref.src.head
            if [ -f $hdr ]
            then
                x=$(get_header -q $hdr RATEL); test "$x" && ra=$(dec2sexa -m $(sexa2dec "$x" 15) 15 0)
                x=$(get_header -q $hdr DETEL); test "$x" && de=$(dec2sexa -h $(sexa2dec "$x") 1 1)
            fi
        fi
        if [ -z "$ra" ] || [ -z "$de" ]
        then
            ra="0000"; de="+000"
        fi

        # get reference image number of calibration sets
        ! is_integer $nref && test -d "$AI_RAWDIR" &&
            nref=$(AIimlist -q -n $sname "" raw 2>/dev/null | head -$((nexp/2 + 1)) | tail -1)
        ! is_integer $nref && nref=$(printf "%04g" $(echo "($n1+$n2)/2" | bc))
        
        # try to get flength and fratio from camera.dat
        test "$telid" && test "${telid:0:1}" == "#" && telid=""
        test -z "$telid" && telid=$(get_telescope -q $sname)
        if [ "$telid" ]
        then
            flength=$(get_param camera.dat flen $sname 2>/dev/null)
            fratio=$(get_param camera.dat fratio $sname 2>/dev/null)
        else
            flength=""
            fratio=""
        fi

        # extract some exif data
        iso="-"
        tsens="-"
        black="-"
        # TODO: determine mean of all images instead of using values from nref 
        set - $(test -s $exifdat && grep -v "^#" $exifdat | awk -v n=$nref '{
            if($2==n){print $0; exit}}') x
        if [ $# -le 9 ]
        then
            set - $(test -s rawfiles.dat && grep -v "^#" $rawfilesdat | awk -v n=$nref '{
            if($1==n){print $0; exit}}') x
            if [ $# -gt 8 ]
            then
                tsens=$8
            else
                echo "# WARNING: $sname: image $nref has no entry in $exifdat/$rawfilesdat." >&2
            fi
        else
            test -z "$flength" && flength="$7"
            test -z "$fratio"  && fratio="${6/F/}"
            iso=$5
            tsens=$8
            black=$9
        fi

        if [ "$longinfo" ]
        then
            pos=$(echo ${ra/+/}$de | tr -d ':.')
            texp=$(echo $texp | awk '{printf("%.0f", $1)}')
            inst=$telid
            test -z "$inst" && test "$flength" && test "$fratio" && inst="f=$flength,f/$fratio"
            test "$inst $AI_SITE" == "f=0.0,f/0 Weimar" && inst="GSO"
            test -z "$inst" && inst="-"
            LANG=C printf "%-7s %-5s %-8s %s %011.3f %3s %2s %4.1f %4d %3.1f  %s %s\n" \
            $(basename $(pwd)) $sname $target $pos $jdref $texp $nexp $rms $bg $fwhm $inst $AI_SITE
        else
            LANG=C printf "%s %-8s %s  %-4s %4.0f %3.1f %4s %5.1f %2d %2s %4s  %s\n" \
                $sname $target $type $nref "$flength" "$fratio" $iso $texp $nexp $tsens $black $telid
        fi
    done < $sdat
    rm -f $tmp1
    return 0
}

# set image header keywords for image sets from tabular data string
# (first column is set name)
AIsetkeys () {
    local showhelp
    local no_update     # if set then header keywords are not modified/added
    local do_keep_all_values    # if set then a data value of "-" is valid
                        # otherwise it is taken as not-available and keyword
                        # would be ignored
    local i
    for i in 1 2 3
    do
        (test "$1" == "-h" || test "$1" == "--help") && showhelp=1 && shift 1
        test "$1" == "-a" && do_keep_all_values=1 && shift 1
        test "$1" == "-n" && no_update=1 && shift 1
    done
    local data=$1
    local keylist    # comma separated list of keywords assigned to columns
                        # in <data> starting at column 2
    local sname
    local kv
    local key
    local val
    local com
    local str
    local opts
    
    test "$showhelp" &&
        echo "usage: AIsetkeys [-n] <tabdata_string> <keylist2>" >&2 &&
        return 1

    shift 1
    keylist=("$@")
    test "$no_update" && opts="-n"
    
    echo "$data" | while read
    do
        set - $REPLY x
        test $# -lt 2 && continue
        sname=$1
        test "${sname:0:1}" == "#" && continue
        test ! -e $sname.head &&
            echo "WARNING: file $sname.head not found, skipping line" >&2 && continue
        shift 1
        for kv in "${keylist[@]}"
        do
            # conditionally skip all data entries in this column
            key=${kv%%/*}
            (test -z "$key" || test "$key" == "-") && shift 1 && continue

            # conditionally skip single data entry
            test "$1" == "-" && test -z "$do_keep_all_values" && shift 1 && continue

            # valid entry
            val=$1
            com=${kv#*/}
            test "$com" == "$key" && com=""
            str=$val
            test "$com" && str="$val/$com"
            test "$AI_DEBUG" && echo "set_header" "$opts" "$sname.head $key=\"$str\"" >&2
            set_header $opts $sname.head $key="$str"
            shift 1
        done
    done
}



#--------------------
#   main
#--------------------

# load other library functions, show our own environment settings
AIcheck_ok $@
if [ $? -eq 0 ]
then
    AIenv

    # check day
    _aiddir=""
    test -z "$day" &&
        echo "WARNING: day is not defined." &&
        return 255
    test "$day" && echo $(pwd) | grep -q $day
    test $? -ne 0 &&
        echo "WARNING: working dir might not belong to day=$day."
fi
