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

### create-blackduck-operator.sh <chart_version>
* Uses the operatorsdk to create an operator for BlackDuck with the specified version

### create-blackduck-connector-operator.sh <chart_version>
* Uses the operatorsdk to create an operator for BlackDuck-Connector with the specified version

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

## New Black Duck Connector Operator and Test
* `./create-new-operator.sh blackduck-connector blackduck-connector BlackDuckConnector cloud blackduck-connector 2.2.5`
* `cd blackduck-connector-operator`
* `kc create -f deploy/crds/blackduck-connector-2.2.5.synopsys.com_blackduckconnectors_crd.yaml`
* Deploy the Operator - Local or Build+Push
  * Local: `operator-sdk run local`
  * Build+Push Image: `./build-push-operator.sh blackduck-connector 2020.6.0 docker.io/mikephammer`
    - Change `REPLACE_IMAGE` in deply/operator.yaml to `docker.io/mikephammer/blackduck:v2020.6.0`
    - Change `REPLACE_NAMESPACE` in deploy/role_binding.yaml to `default` 
    - Give operator permission to delete jobs (see below)
    - `kc create -f deploy/`
* `kc create -f deploy/crds/blackduck-connector-2.2.5.synopsys.com_v1alpha1_blackduckconnector_cr.yaml`
* `kc delete -f deploy/crds/blackduck-connector-2.2.5.synopsys.com_v1alpha1_blackduckconnector_cr.yaml`
* Delete the Operator - Local or Build+Push
  - Local: `ctrl-C` to kill `operator-sdk run local`
  - Build+Push: `kc delete -f deploy/`
* `kc create -f deploy/crds/blackduck-connector-2.2.5.synopsys.com_blackduckconnectors_crd.yaml`

## New Black Duck Operator and Test
* `./create-new-blackduck-operator.sh 2020.6.0`
* `cd blackduck-operator`
* `kc create -f deploy/crds/blackduck-2020.6.0.synopsys.com_blackducks_crd.yaml`
* Deploy the Operator - Local or Build+Push
  * Local: `operator-sdk run local`
  * Build+Push Image: `./build-push-operator.sh blackduck 2020.6.0 docker.io/mikephammer`
    - Change `REPLACE_IMAGE` in deploy/operator.yaml to `docker.io/mikephammer/blackduck:v2020.6.0`
    - Change `REPLACE_NAMESPACE` in deploy/role_binding.yaml to `default` 
    - `kc create -f deploy/`
* Deploy BlackDuck
  - Set postgres.isExternal to true
  - `kc create -f deploy/crds/blackduck-2020.6.0.synopsys.com_v1alpha1_blackduck_cr.yaml`
* `kc delete -f deploy/crds/blackduck-2020.6.0.synopsys.com_v1alpha1_blackduck_cr.yaml`
* Delete the Operator - Local or Build+Push
  - Local: `ctrl-C` to kill `operator-sdk run local`
  - Build+Push: `kc delete -f deploy/`
* `kc delete -f deploy/crds/blackduck-2020.6.0.synopsys.com_blackducks_crd.yaml`

**Adding the Job to deploy/role.yaml:**
```
  - apiGroups:
      - "batch"
    resources:
      - jobs
    verbs:
      - "*"
```

# Testing

## Testing With Operator Running on Local Machine
1. Run `oc create -f deploy/crds/charts.helm.k8s.io_blackducks_crd.yaml`
2. `cd <operator_directory>`
3. Run `operator-sdk run local`
4. Make changes to the CRD (like namespace)
5. Ensure the namespace exists
6. Run `oc create -f deploy/crds/charts.helm.k8s.io_v1alpha1_blackduck_cr.yaml`

## Testing With Operator Running in a Pod
1. Build and push the operator image
2. Run `oc create -f deploy/`

