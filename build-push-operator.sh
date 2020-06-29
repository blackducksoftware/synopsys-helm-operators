#!/bin/bash

set -e

CONFIG=$1

NAME=`jq -r '.name' $CONFIG`
VERSION=`jq -r '.version' $CONFIG`
CHART_PATH=`jq -r '.chartPath' $CONFIG`
REGISTRY=`jq -r '.registry' $CONFIG`

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
    
    echo "cd $name;docker push $registry/$name"
    cd $name;docker push $registry/$name
}

buildOperatorImage $NAME $VERSION $REGISTRY
pushOperatorImage $NAME $REGISTRY