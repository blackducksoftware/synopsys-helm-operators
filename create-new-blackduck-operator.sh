operatorName=$1
appName=$2
kind=$3
chartRepo=$4
chartName=$5
chartVersion=$6

function mergeTempaltes {
    operatorName=$1
    chartName=$2
    pushd $operatorName/helm-charts/$chartName/templates
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




chartVersion=$1

chartRepo=https://sig-repo.synopsys.com/sig-cloudnative
chartName=blackduck

operatorName=blackduck-operator
appName=blackduck
kind=BlackDuck

# Create the Operator Directory and Initial files
echo "operator-sdk new $operatorName --api-version=$appName-$chartVersion.synopsys.com/v1alpha1 --kind $3 --type helm --helm-chart=$chartRepo/$chartName --helm-chart-version=$chartVersion"
operator-sdk new $operatorName --api-version=$appName-$chartVersion.synopsys.com/v1alpha1 --kind $3 --type helm --helm-chart=$chartRepo/$chartName --helm-chart-version=$chartVersion

# Patch the Role.yaml so the Operator can manage Jobs
echo  '
  - apiGroups:
      - "batch"
    resources:
      - jobs
    verbs:
      - "*"
' > $op
cat val

# Merge templates into one file (resolves issue where Operator cannot support empty template files)
mergeTempaltes $operatorName $chartName

