#!/bin/bash

function mergeTempaltes {
    operatorName=$1
    chartName=$2
    pushd $operatorName/helm-charts/$chartName/templates
    # for f in *
    # do
    #     touch merged-tempaltes.yaml
    #     if [[ ($f = "_helpers.tpl") || ($f = "configmap.yaml") || ($f = "postgres-config.yaml") || ($f = "seal-key.yaml") ]]; then
    #         continue
    #     fi
    #     start=`head -1 $f`
    #     if [[ ${start} != "---" ]]; then 
    #         echo -e "\n---" >> merged-tempaltes.yaml    
    #     fi
    #     cat $f >> merged-tempaltes.yaml
    #     # rm $f
    # done

    # bianry-scanner.yaml, rabbitmq.yaml -> uploadcache.yaml
    touch merged-tempaltes.yaml

    echo -e "\n---" >> uploadcache.yaml   
    cat bianry-scanner.yaml >> uploadcache.yaml
    echo -e "\n---" >> uploadcache.yaml   
    cat rabbitmq.yaml >> uploadcache.yaml

    # onprem-postgres.yaml -> postgres-init.yaml
    echo -e "\n---" >> postgres-init.yaml   
    cat onprem-postgres.yaml >> postgres-init.yaml
    

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

# Patch the CR so it can deploy by default
# sed -i 's/isExternal\: true:isExternal\: false/g' $operatorName/helm-charts/$chartName/values.yaml

# Merge templates into one file (resolves issue where Operator cannot support empty template files)
echo "Merging Template Files:"
mergeTempaltes $operatorName $chartName

echo "BlackDuck Operator Complete!"

