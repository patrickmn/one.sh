#!/bin/sh
# one.sh -- Singleton command execution for Linux/BSD
#
# Makes sure only one instance of the same process is running at once. This
# script does nothing if it was previously used to launch the same command
# and that instance is still running.
#
# /tmp/one-<md5sum of the arguments>.pid is used as the lock file. This file
# is removed if the process it refers to isn't actually running.
#
# Usage:   ./one.sh <command> <arguments>
# Example: ./one.sh wget --mirror http://mysite.com
#
# See http://patrickmylund.com/projects/one/ for more information.

# Switch out LFILE for something static to avoid running md5sum and cut, e.g.
# LFILE=/tmp/one.pid
LFILE=/tmp/one-`echo "$@" | md5sum | cut -d\  -f1`.pid
if [ -e ${LFILE} ] && kill -0 `cat ${LFILE}`; then
   exit
fi

trap "rm -f ${LFILE}; exit" INT TERM EXIT
echo $$ > ${LFILE}

$@

rm -f ${LFILE}
