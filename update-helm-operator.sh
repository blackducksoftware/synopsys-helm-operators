#!/bin/bash

set -e

CONFIG=$1

NAME=`jq -r '.name' $CONFIG`
VERSION=`jq -r '.version' $CONFIG`
CHART_PATH=`jq -r '.chartPath' $CONFIG`
REGISTRY=`jq -r '.registry' $CONFIG`

function createHelmOperatorFiles {
    name=$1
    chart_path=$2

    echo "operator-sdk new $name --type=helm --helm-chart $chart_path"
    operator-sdk new $name --type=helm --helm-chart $chart_path 
}

function removeHelmOperatorFiles {
    name=$1

    echo "rm -rf $name"
    rm -rf $name
}

removeHelmOperatorFiles $NAME
createHelmOperatorFiles $NAME $CHART_PATH