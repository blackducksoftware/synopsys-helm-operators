echo "This file is no longer supported"
exit 0 

operatorName=$1
chartRepo=$2
chartName=$3
chartVersion=$4

if [ $operatorName = "blackduck" ]; then 
    echo "cd $operatorName;operator-sdk add api --api-version=blackduck-$chartVersion.synopsys.com/v1alpha1 --kind=BlackDuck-$chartVersion --helm-chart=$chartRepo/$chartName --helm-chart-version=$chartVersion"
    cd $operatorName;operator-sdk add api --api-version=blackduck-$chartVersion.synopsys.com/v1alpha1 --kind=BlackDuck --helm-chart=$chartRepo/$chartName --helm-chart-version=$chartVersion
elif [ $operatorName = "blackduck-connector" ]; then
    echo "cd $operatorName;operator-sdk add api --api-version=blackduck-connector.synopsys.com/v1alpha1 --kind=BlackDuckConnector --helm-chart=$chartRepo/$chartName --helm-chart-version=$chartVersion"
    cd $operatorName;operator-sdk add api --api-version=blackduck-connector.synopsys.com/v1alpha1 --kind=BlackDuckConnector --helm-chart=$chartRepo/$chartName --helm-chart-version=$chartVersion
else
    echo "${operatorName} is not supported"
fi