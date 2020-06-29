# Synopsys Helm Operators

### Applications
* Black Duck
* Black Duck Connector

## Requirements
* operatorsdk - https://docs.openshift.com/container-platform/4.3/operators/operator_sdk/osdk-getting-started.html#osdk-installing-cli_osdk-getting-started

# Bsic Steps
1. Update the config.json for the application
2. Run `./update-helm-operator.sh <config>`
3. Run `./build-push-operator.sh <config>`

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

