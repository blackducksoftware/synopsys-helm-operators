operatorName=$1
appName=$2
kind=$3
chartRepo=$4
chartName=$5
chartVersion=$6

function mergeTempaltes {
    pushd blackduck/helm-charts/blackduck/templates
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
    done
    popd
}

echo "operator-sdk new $operatorName --api-version=$appName-$chartVersion.synopsys.com/v1alpha1 --kind $3 --type helm --helm-chart=$chartRepo/$chartName --helm-chart-version=$chartVersion"
operator-sdk new $operatorName --api-version=$appName-$chartVersion.synopsys.com/v1alpha1 --kind $3 --type helm --helm-chart=$chartRepo/$chartName --helm-chart-version=$chartVersion