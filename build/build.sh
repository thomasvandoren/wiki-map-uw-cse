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
b='dev'
if  $1 = 'release' 
then
  b='release'
fi

BUILD_DIR=build-wiki-map-uw-cse
BUILD_OUT=build
CLIENT_NAME=$BUILD_OUT/$b/WikiGraph-Flash-Client.tar.gz
SERVICES_NAME=$BUILD_OUT/$b/WikiGraph-Services.tar.gz

# Create the build output directory.
mkdir $BUILD_OUT &> /dev/null
mkdir $BUILD_OUT/$b &> /dev/null

# Clone and checkout the appropriate branch
hg clone https://wiki-map-uw-cse.googlecode.com/hg/ $BUILD_DIR
cd $BUILD_DIR
hg checkout $b

# Zip up the client and services into the build output
tar -czvf ../$CLIENT_NAME client/*
tar -czvf ../$SERVICES_NAME services/*

# Remove the clone.
cd ..
rm -rf $BUILD_DIR

exit 0
