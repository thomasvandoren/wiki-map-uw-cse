#!/bin/bash
#
# WikiGraph
# Copyright (c) 2011
#
# This is the 'one-step' build script. It will later be ported to make or ant, 
# but this will suffice for now.
#
#

# Check for parameters, first parameter is the branch to checkout
PRE=/projects/instr/cubist/11wi/cse403/WikiMap-M/proj
SERVICES_OUT=$PRE/test-api
CLIENT_OUT=$PRE/test

b='dev'
if [ "$1" == "release" ] 
then
  b='release'
  SERVICES_OUT=$PRE/api
  CLIENT_OUT=$PRE/graph
fi

TMP=tmp
TMP_CLIENT=$TMP/client
TMP_SERVICES=$TMP/services

# Make the tmp directory
mkdir $TMP &> /dev/null

# Unzip the client and services into tmp directories
find ./build/$b -name "*.tar.gz" -exec tar -xzvf {} -C `pwd`/tmp ';'

# Copy the files over to cubist...
echo -n "Enter your CSEID: "
read USER

# This is incredibly inefficient, but there are really only two files...
find tmp/client -regextype posix-egrep -regex ".*\.(swf|html)" -exec scp {} $USER@cubist.cs.washington.edu:$CLIENT_OUT ';'
find tmp/services -regextype posix-egrep -regex ".*\.(php)" -exec scp {} $USER@cubist.cs.washington.edu:$SERVICES_OUT ';'

# Remove the tmps.
rm -rf $TMP

exit 0
