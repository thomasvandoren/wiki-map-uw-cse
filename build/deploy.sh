#!/bin/bash -x
#
# WikiGraph
# Copyright (c) 2011
#
# This is the 'one-step' build script. It will later be ported to make or ant, 
# but this will suffice for now.
#
#

# Check for parameters, first parameter is the branch to checkout
b='dev'
if  $1 = 'release' 
then
  b='release'
fi

TMP=tmp
TMP_CLIENT=$TMP/client
TMP_SERVICES=$TMP/services

# Make the tmp directory
mkdir $TMP &> /dev/null

# Unzip the client and services into tmp directories
find ./build/$b -name "*.tar.gz" -exec tar -xzvf {} -C `pwd`/tmp ';'

exit 0

# Copy the files over...
echo -n "Enter your CSEID: "
read USER
cd tmp
scp -r client $USER@cubist.cs.washington.edu:/projects/instr/cubist/11wi/cse403/WikiMap-M/proj/test
scp -r services $USER@cubist.cs.washington.edu:/projects/instr/cubist/11wi/cse403/WikiMap-M/proj/test-api

# Remove the tmps.
rm -rf $TMP_CLIENT $TMP_SERVICES

exit 0
