# Black Duck Helm Operator

## Requirements
* operatorsdk
  *  https://github.com/operator-framework/operator-sdk/releases
  * https://sdk.operatorframework.io/docs/install-operator-sdk/
* Helm 3
* Docker

## Overview of Scripts

### create-blackduck-operator.sh <chart_version>
* Uses the operatorsdk to create an operator for BlackDuck with the specified version


### build-push-operator.sh <operator_name> <chart_version> <image_repo>
* Pushes the operator in directory <operator_name> to the <image_repo>. The image is tagged with version <chart_version>
* Uses operatorsdk to build the image and docker to push it

### list-available-charts.sh <chart_repo_alias>
This script uses Helm to list the available Applications and their versions. You can run this command to see what Application versions that you can add to an operator.
* To see your <chart_repo_alias> options run `helm repo list`

### download-helm-chart.sh <chart_repo_alias> <chart_name> <chart_version>
This script uses Helm to download a specified chart if you would like to inspect it before adding it to an operator. 
* To see your <chart_repo_alias> options run `helm repo list`

# Quick Start Example

## New Black Duck Operator and Test
* `./create-new-blackduck-operator.sh 2020.6.0`
* `cd blackduck-operator`
* `kc create -f deploy/crds/blackduck-2020.6.0.synopsys.com_blackducks_crd.yaml`
* Deploy the Operator - Local or Build+Push
  * Local: `operator-sdk run local`
  * Build+Push Image: `./build-push-operator.sh blackduck 2020.6.0 docker.io/mikephammer`
    - Change `REPLACE_IMAGE` in deploy/operator.yaml to `docker.io/mikephammer/blackduck:v2020.6.0`
    - `kc create -f deploy/`
* Deploy BlackDuck
  - Set postgres.isExternal to true
  - `kc create -f deploy/crds/blackduck-2020.6.0.synopsys.com_v1alpha1_blackduck_cr.yaml`
* `kc delete -f deploy/crds/blackduck-2020.6.0.synopsys.com_v1alpha1_blackduck_cr.yaml`
* Delete the Operator - Local or Build+Push
  - Local: `ctrl-C` to kill `operator-sdk run local`
  - Build+Push: `kc delete -f deploy/`
* `kc delete -f deploy/crds/blackduck-2020.6.0.synopsys.com_blackducks_crd.yaml`
