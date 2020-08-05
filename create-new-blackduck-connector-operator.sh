#!/bin/bash

function mergeTempaltes {
    operatorName=$1
    chartName=$2
    pushd $operatorName/helm-charts/$chartName/templates

    # append processors to the core
    echo -e "\n---" >> opssight-core.yaml   
    cat opssight-artifactory-processor.yaml >> opssight-core.yaml
    rm opssight-artifactory-processor.yaml
    echo -e "\n---" >> opssight-core.yaml   
    cat opssight-image-processor.yaml >> opssight-core.yaml
    rm opssight-image-processor.yaml
    echo -e "\n---" >> opssight-core.yaml   
    cat opssight-pod-processor.yaml >> opssight-core.yaml
    rm opssight-pod-processor.yaml
    echo -e "\n---" >> opssight-core.yaml   
    cat opssight-quay-processor.yaml >> opssight-core.yaml
    rm opssight-quay-processor.yaml

    # Append prometheus to the core
    echo -e "\n---" >> opssight-core.yaml   
    cat opssight-prometheus.yaml >> opssight-core.yaml
    rm opssight-prometheus.yaml
    
    popd
}

set -e

chartVersion=$1

chartRepo=https://sig-repo.synopsys.com/sig-cloudnative
chartName=blackduck-connector

operatorName=blackduck-connector-operator
appName=blackduck-connector
kind=BlackDuckConnector

# Create the Operator Directory and Initial files
echo "Creating Operator:"
echo "operator-sdk new $operatorName --api-version=$appName-$chartVersion.synopsys.com/v1alpha1 --kind $kind --type helm --helm-chart=$chartName --helm-chart-repo=\"$chartRepo\" --helm-chart-version=$chartVersion"
operator-sdk new $operatorName --api-version=$appName-$chartVersion.synopsys.com/v1alpha1 --kind $kind --type helm --helm-chart=$chartName --helm-chart-repo="$chartRepo" --helm-chart-version=$chartVersion

# Merge templates into one file (resolves issue where Operator cannot support empty template files)
echo "Merging Template Files:"
mergeTempaltes $operatorName $chartName

echo "BlackDuck-Connector Operator Complete!"

