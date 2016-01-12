#!/usr/bin/env bash
set -o nounset # exit on use of an uninitialised variable, same as -u
set -o errexit # exit on all and any errors, same as -e

# ==============================================================================
#                              HANDLE PARAMETERS
# ------------------------------------------------------------------------------
if [ $# -lt 2 ];then
    #@TODO: Proper usage description
    echo 'This script expects two parameters: '
    echo '    - The directory where the Svn Repository is located'
    echo '    - The directory where the log file should be written'
    exit 64
fi

# @TODO: Make these *named* parameters
SvnRepoDir="$1"
StatSvnLogDir="$2"

excludeString='**/system/plugins/**;**.git/**;'
title='Docklink - Portaal'
# ==============================================================================


# ==============================================================================
#                               CONFIG VARS
# ------------------------------------------------------------------------------
StatSvnDir='/home/ben/Dropbox/www/3rd-party/statsvn-0.7.0'
StatSvnLogFile="$StatSvnLogDir/statsvn-output.log"
SvnLogFile='logfile.log'

# ==============================================================================


# ==============================================================================
#                            APPLICATION VARS
# ------------------------------------------------------------------------------
EXITCODE=0
JavaPath='/usr/lib/jvm/java-6-sun/bin/java'
# ==============================================================================


# ==============================================================================
#                            FUNCTIONS
# ------------------------------------------------------------------------------
# ==============================================================================
#@FIXME: run `svn up` and `svn log -v --xml > logfile.log`

#echo '' > "$StatSvnLogFile"


#tail -f "$StatSvnLogFile" &&               \
echo $JavaPath                              \
     -mx2048m                               \
    -jar "$StatSvnDir/statsvn.jar"          \
    -verbose                                \
    -disable-twitter-button                 \
    -output-dir "$StatSvnLogDir"            \
    -exclude "$excludeString"               \
    -title "$title"                         \
    -charset UTF-8                          \
    "$SvnRepoDir/$SvnLogFile" $SvnRepoDir 

#    -no-developer clarinus                  \
#    -no-developer tuulia                    \
# 2>&1 > "$StatSvnLogFile"

exit $EXITCODE

# ==============================================================================
#                           COMMENTS
# ------------------------------------------------------------------------------
    Other command line parameters are :

  -output-dir <dir>                         directory where HTML suite will be saved
  -include <pattern>                        include only files matching pattern, e.g. **/*.c;**/*.h
  -exclude <pattern>                        exclude matching files, e.g. tests/**;docs/**
  -tags <regexp>                            show matching tags in lines of code chart, e.g. version-.*
  -title <title>                            Project title to be used in reports

  -username <svnusername>                   username to pass to svn
  -password <svnpassword>                   password to pass to svn
  -verbose                                  print extra progress information
  -charset <charset>                        specify the charset to use for html/xdoc

    -no-developer <login-name>              Excludes a Subversion account name from all developer reports. This is useful to reduce noise from administrative and other non-developer accounts. Multiple accounts can be excluded by adding the option to the command line once for each account.

    -css <stylesheet>                       Optional (default varies for html or xdoc). 
                                            Specify a Cascading Style Sheet for the report. 
                                            This can be a HTTP URL or a local file. 
                                            A URL will simply be linked in every page of the report. 
                                            A local file will be copied into the report directory.
    
    -config-file <path to properties file>  Allows one to replace the source control username with more information such as real name, website, email and avatar icon. See below an example.
    -disable-twitter-button                 if present, exclude the Twitter "Tweet This" buttons from the output.

    -anonymize                              Anonymizes committer names.
# ------------------------------------------------------------------------------





# ------------------------------------------------------------------------------
Examples
# ------------------------------------------------------------------------------

java -jar statsvn.jar -verbose -title jUCMNav 
      -exclude **/src/urncore/**;**/src/grl/**;**/src/ucm/**;**/src/urn/**;**/src/seg/jUCMNav/model/ucm/** \
      -output-dir ./stats c:\eclipse\workspace\seg.jUCMNav\svn.log c:\eclipse\workspace\seg.jUCMNav
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
##
# User Details
# user.[cvsUserName].replacedBy=[new CVS user name] <-- user name that replaces the user (merge!)
#
# user.[cvsUserName].realName=[user real name]
# user.[cvsUserName].url=[user homepage full url]
# user.[cvsUserName].image=[url to user picture]
# user.[cvsUserName].email=[user email]
# user.[cvsUserName].twitterUsername=[Twitter userName]
# user.[cvsUserName].twitterUserId=[user twitter id, an int!] <-- This is more difficult to find, see the Twitter API section
# user.[cvsUserName].twitterIncludeHtml=true/false < -- Typically you'd chose html OR flash
# user.[cvsUserName].twitterIncludeFlash=true/false
##

# Example
user.benoitx.realName=Benoit Xhenseval
user.benoitx.url=http://www.xhenseval.com/benoit
user.benoitx.image=http://www.xhenseval.com/benoit/bx-avatar.jpg
user.benoitx.email=
user.benoitx.twitterUsername=benoitx
user.benoitx.twitterUserId=18722145
user.benoitx.twitterIncludeHtml=true
user.benoitx.twitterIncludeFlash=true

##
# CHART Details
# chart.[chartName].backgroundColor=#AABBCC
# chart.[chartName].plotColor=#AABBCC
# chart.[chartName].lineSize=1
# chart.[chartName].backgroundColor=#AABBCC
# chart.[chartName].width=700
# chart.[chartName].height=500
# chart.[chartName].showShapes=true
# chart.[chartName].filledShapes=true
# chart.[chartName].copyright=[copyright or any other text, placed at the bottom right]
# chart.[chartName].copyrightTextSize=[txt size, default 9]
# chart.[name].chartBackgroundImage.url=[url to an image, eg file:///C:/project/statcvs/site/images/statcvslogo.gif]
# chart.[name].chartBackgroundImage.transparency=[float 0 to 1, defaulted to 0.35]
# chart.[name].plotImage.url=[url to an image, eg file:///C:/project/statcvs/site/images/statcvslogo.gif]
# chart.[name].plotImage.transparency=[float 0 to 1, defaulted to 0.35]
# Chart Names are:
# file_size, file_count, directory_sizes, commitscatterauthors, loc_per_author, directories_loc_timeline, loc_module, loc_small, loc
# activity, activity_time, activity_day, locandchurn
##

# Example
chart.backgroundColor=#FFFFEE
chart.plotColor=#EFEFEF
chart.lineStroke=1.5
chart.width=952
chart.height=596
chart.copyright=(c)StatCVS, 2009+
chart.copyrightTextSize=10
#
chart.activity.height=19

# background image
chart.chartBackgroundImage.url=file:///C:/project/statcvs/site/images/statcvslogo.gif
chart.chartBackgroundImage.transparency=0.40

# background plot
chart.loc.url=file:///C:/project/statcvs/site/images/cervin_zoom.jpg
chart.loc_small.plotImage.url=http://www.appendium.com/openimages/appendium_logo.jpg


##
# CLOUD from Words in Commit comments
#
#cloud.minFrequency=[Min amount of times a word must appear]
#cloud.maxWordNumberInCloud=[Maximum number of words in the cloud, defaulted to 100]
#cloud.maxWordNumberInTable=[Maximum number of words in the table, defaulted to 50]
#cloud.minLengthForWord=[Min number of characters for a word, defaulted to 4]
#cloud.exclusionRegExp=[Regular expression to exclude some words, released with an English version]
##
cloud.minFrequency=5
cloud.maxWordNumberInCloud=100
cloud.minLengthForWord=4
cloud.maxWordNumberInTable=50
cloud.exclusionRegExp=\\d+|an|the|me|my|we|you|he|she|it|are|is|am|will|shall|should|would|had|have|has|was|were|be|been|this|that|there

# ------------------------------------------------------------------------------

		svn log --xml -v > /var/www/code/logs/${i%/}.log 2>$SVNLOGFILE 
		java -jar /home/sander/scripts/statsvn.jar -disable-twitter-button -output-dir /var/www/code/${i%/} /var/www/code/logs/${i%/}.log /home/svn/$i >$LOGFILE 2>&1
		
the  '>LOGFILE 2>&1' at the end of the command stores the output to a file rather than display it on run


# ==============================================================================

    

