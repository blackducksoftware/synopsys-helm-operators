# Synopsys Helm Operators

### Supported Applications
* Black Duck
* Black Duck Connector

## Requirements
* operatorsdk
  *  https://github.com/operator-framework/operator-sdk/releases
  * https://sdk.operatorframework.io/docs/install-operator-sdk/
* Helm 3
* Docker

## Overview
* Each application has an associated operator
  * You can create a new operator by running create-new-operator.sh
* Each operator has a Custom Resource Definition (CRD) for each version of the Application that it supports
  * You can add new versions by running add-chart-to-operator.sh and/or list-available-charts.sh

## Overview of Scripts

**create-new-operator.sh**  
This script uses operatorsdk to create a an operator for a new Application using a Helm Chart.

**add-chart-to-operator.sh**  
This script uses the operatorsdk add new Application versions to an existing operator. It takes in the Helm Chart for that Application version.

**list-available-charts.sh**  
This script uses Helm to list the available Applications and their versions. You can run this command to see what Application versions that you can add to an operator. 

**download-helm-chart.sh**  
This script uses Helm to download a specified chart if you would like to inspect it before adding it to an operator. 

**build-push-operator.sh**  
This script uses Docker and operatorsdk to build the operator image and push the image to a image repository (ex: Docker Hub)

# Testing

## Testing With Operator Running on Local Machine
1. Update the config.json for the application
  1. You can ignore the registry
2. Run `./update-helm-operator.sh <config>`
3. Run `oc create -f deploy/crds/charts.helm.k8s.io_blackducks_crd.yaml`
4. Run `operator-sdk run --local`
5. Make changes to the CRD (like namespace)
6. Ensure the namespace exists
7. Run `oc create -f deploy/crds/charts.helm.k8s.io_v1alpha1_blackduck_cr.yaml`

## Testing With Operator Running in a Pod
1. Update the config.json for the application
  1. Set the registry to your development regsitry for testing
2. Run `./update-helm-operator.sh <config>`
3. Run `./build-push-operator.sh <config>`
4. Run `oc create -f deploy/`

