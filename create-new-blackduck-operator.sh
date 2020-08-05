#!/bin/bash

function mergeTempaltes {
    operatorName=$1
    chartName=$2
    pushd $operatorName/helm-charts/$chartName/templates
    echo "$operatorName/helm-charts/$chartName/templates"
    for f in *
    do
        touch amegafile.yaml
        if [ $f = "_helpers.tpl" ]; then
            continue
        fi
        start=`head -1 $f`
        if [[ ${start} != "---" ]]; then 
            echo -e "\n---" >> amegafile.yaml    
        fi
        cat $f >> amegafile.yaml
        rm $f
    done
    popd
}

set -e

chartVersion=$1

chartRepo=https://sig-repo.synopsys.com/sig-cloudnative
chartName=blackduck

operatorName=blackduck-operator
appName=blackduck
kind=BlackDuck

# Create the Operator Directory and Initial files
echo "Creating Operator:"
echo "operator-sdk new $operatorName --api-version=$appName-$chartVersion.synopsys.com/v1alpha1 --kind $kind --type helm --helm-chart=$chartName --helm-chart-repo=\"$chartRepo\" --helm-chart-version=$chartVersion"
operator-sdk new $operatorName --api-version=$appName-$chartVersion.synopsys.com/v1alpha1 --kind $kind --type helm --helm-chart=$chartName --helm-chart-repo="$chartRepo" --helm-chart-version=$chartVersion

# Patch the Role.yaml so the Operator can manage Jobs
echo "Patching Role.yaml:"
echo  '
- apiGroups:
  - "batch"
  resources:
  - jobs
  verbs:
  - "*"
' >> $operatorName/deploy/role.yaml

# Merge templates into one file (resolves issue where Operator cannot support empty template files)
echo "Merging Template Files:"
mergeTempaltes $operatorName $chartName

echo "BlackDuck Operator Complete!"

