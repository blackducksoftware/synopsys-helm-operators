operatorName=$1
appName=$2
kind=$3
chartRepo=$4
chartName=$5
chartVersion=$6

echo "operator-sdk new $operatorName --api-version=$appName.synopsys.com/v1alpha1 --kind $3 --type helm --helm-chart=$chartRepo/$chartName --helm-chart-version=$chartVersion"
operator-sdk new $operatorName --api-version=$appName.synopsys.com/v1alpha1 --kind $3 --type helm --helm-chart=$chartRepo/$chartName --helm-chart-version=$chartVersion