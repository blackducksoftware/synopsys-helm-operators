#!/bin/bash

set -e

NAME=$1
VERSION=$2
REGISTRY=$3

function buildOperatorImage {
    name=$1
    version=$2
    registry=$3
    
    echo "cd $name;operator-sdk build $registry/$name:v$version"
    cd $name;operator-sdk build $registry/$name:v$version
}

function pushOperatorImage {
    name=$1
    registry=$2
    
    echo "docker push $registry/$name"
    docker push $registry/$name
}

# Patch REPLACE_IMAGE
# sed -i 's/REPLACE_IMAGE/${REGISTRY}/${NAME}:v${VERSION}/g' input.txt

# Build the image
echo "Building Image"
buildOperatorImage $NAME $VERSION $REGISTRY

# Push the image
echo "Pushing Image"
pushOperatorImage $NAME $REGISTRY