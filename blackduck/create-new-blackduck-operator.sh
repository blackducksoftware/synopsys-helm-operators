#!/bin/bash

function mergeTempaltes {
    operatorName=$1
    chartName=$2
    pushd $operatorName/helm-charts/$chartName/templates

    # append bianry-scanner.yaml, rabbitmq.yaml -> uploadcache.yaml    
    echo -e "\n---" >> uploadcache.yaml   
    cat binary-scanner.yaml >> uploadcache.yaml
    rm binary-scanner.yaml
    echo -e "\n---" >> uploadcache.yaml   
    cat rabbitmq.yaml >> uploadcache.yaml
    rm rabbitmq.yaml

    # append onprem-postgres.yaml -> postgres-init.yaml
    echo -e "\n---" >> postgres-init.yaml   
    cat onprem-postgres.yaml >> postgres-init.yaml
    rm onprem-postgres.yaml
    
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
echo "Generating BlackDuck Operator with operator-sdk..."
echo "operator-sdk new $operatorName --api-version=$appName-$chartVersion.synopsys.com/v1alpha1 --kind $kind --type helm --helm-chart=$chartName --helm-chart-repo=\"$chartRepo\" --helm-chart-version=$chartVersion"
operator-sdk new $operatorName --api-version=$appName-$chartVersion.synopsys.com/v1alpha1 --kind $kind --type helm --helm-chart=$chartName --helm-chart-repo="$chartRepo" --helm-chart-version=$chartVersion
echo ""

# Patch the Role.yaml so the Operator can manage Jobs
echo "Patching Role.yaml..."
echo  '
- apiGroups:
  - "batch"
  resources:
  - jobs
  verbs:
  - "*"
' >> $operatorName/deploy/role.yaml
echo ""

# Merge templates into one file (resolves issue where Operator cannot support empty template files)
echo "Merging Template Files..."
mergeTempaltes $operatorName $chartName
echo ""

echo "BlackDuck Operator is created!"

