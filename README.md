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

### create-new-operator.sh <operator_name> <app_name> <kind> <chart_repo> <chart_name> <chart_version>
This script uses operatorsdk to create a an operator for a new Application using a Helm Chart.

### add-chart-to-operator.sh <operator_name> <chart_repo> <chart_name> <chart_version>
This script uses the operatorsdk add new Application versions to an existing operator. It takes in the Helm Chart for that Application version.
* This script contains custom logic for each operator. You must manually add the logic after running create-new-operator.sh

### list-available-charts.sh <chart_repo_alias>
This script uses Helm to list the available Applications and their versions. You can run this command to see what Application versions that you can add to an operator. 
* To see your <chart_repo_alias> terms run `helm repo list`

### download-helm-chart.sh <chart_repo> <chart_name> <chart_version>
This script uses Helm to download a specified chart if you would like to inspect it before adding it to an operator. 

### build-push-operator.sh
This script uses Docker and operatorsdk to build the operator image and push the image to a image repository (ex: Docker Hub)

# Quick Start

## New Black Duck Connector Operator and Test
* `./create-new-operator.sh blackduck-connector blackduck-connector BlackDuckConnector cloud blackduck-connector 2.2.5`
* `cd blackduck-connector`
* `kc create -f deploy/crds/blackduck-connector-2.2.5.synopsys.com_blackduckconnectors_crd.yaml`
* Deploy the Operator - Local or Build+Push
  * Local: `operator-sdk run local`
  * Build+Push Image: `./build-push-operator.sh blackduck-connector 2020.6.0 docker.io/mikephammer`
    - Change `REPLACE_IMAGE` in deply/operator.yaml to `docker.io/mikephammer/blackduck:v2020.6.0`
    - Give operator permission to delete jobs (see below)
    - `kc create -f deploy/`
* `kc create -f deploy/crds/blackduck-connector-2.2.5.synopsys.com_v1alpha1_blackduckconnector_cr.yaml`
* `kc delete -f deploy/crds/blackduck-connector-2.2.5.synopsys.com_v1alpha1_blackduckconnector_cr.yaml`
* Delete the Operator - Local or Build+Push
  - Local: `ctrl-C` to kill `operator-sdk run local`
  - Build+Push: `kc delete -f deploy/`
* `kc create -f deploy/crds/blackduck-connector-2.2.5.synopsys.com_blackduckconnectors_crd.yaml`

## New Black Duck Operator and Test
* `./create-new-operator.sh blackduck blackduck BlackDuck cloud blackduck 2020.6.0`
* `cd blackduck`
* `kc create -f deploy/crds/blackduck-2020.6.0.synopsys.com_blackducks_crd.yaml`
* Deploy the Operator - Local or Build+Push
  * Local: `operator-sdk run local`
  * Build+Push Image: `./build-push-operator.sh blackduck 2020.6.0 docker.io/mikephammer`
    - Give operator permission to delete jobs (see below)
    - Change `REPLACE_IMAGE` in deply/operator.yaml to `docker.io/mikephammer/blackduck:v2020.6.0`
    - `kc create -f deploy/`
* Deploy BlackDuck
  - Set postgres.isExternal to true
  - `kc create -f deploy/crds/blackduck-2020.6.0.synopsys.com_v1alpha1_blackduck_cr.yaml`
* `kc delete -f deploy/crds/blackduck-2020.6.0.synopsys.com_v1alpha1_blackduck_cr.yaml`
* Delete the Operator - Local or Build+Push
  - Local: `ctrl-C` to kill `operator-sdk run local`
  - Build+Push: `kc delete -f deploy/`
* `kc delete -f deploy/crds/blackduck-2020.6.0.synopsys.com_blackducks_crd.yaml`

## New Operator and Test (generid)
* `./create-new-operator.sh blackduck-connector blackduck-connector BlackDuckConnector cloud blackduck-connector 2.2.5`
* `cd blackduck-connector`
* `kc create -f deploy/crds/blackduck-connector-2.2.5.synopsys.com_blackduckconnectors_crd.yaml`
* Deploy the Operator - Local or Build+Push
  * Local: `operator-sdk run local`
  * Build+Push Image: `./build-push-operator.sh blackduck-connec 2020.6.0 docker.io/mikephammer`
    - Change `REPLACE_IMAGE` in deply/operator.yaml to `docker.io/mikephammer/blackduck:v2020.6.0`
    - Give operator permission to delete jobs (see below)
    - `kc create -f deploy/`
* `kc create -f deploy/crds/blackduck-connector-2.2.5.synopsys.com_v1alpha1_blackduckconnector_cr.yaml`
* `kc delete -f deploy/crds/blackduck-connector-2.2.5.synopsys.com_v1alpha1_blackduckconnector_cr.yaml`
* Delete the Operator - Local or Build+Push
  - Local: `ctrl-C` to kill `operator-sdk run local`
  - Build+Push: `kc delete -f deploy/`
* `kc create -f deploy/crds/blackduck-connector-2.2.5.synopsys.com_blackduckconnectors_crd.yaml`

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

