# Black Duck Connector Helm Operator

## Requirements

* operatorsdk
  * operator-sdk [https://github.com/operator-framework/operator-sdk/releases]
  * installation docs [https://sdk.operatorframework.io/docs/install-operator-sdk/]
  * version 1.3.0 is required
* Helm 3
* Docker

## Overview

### Step 1: Intialize the operator files

Operator creation process (for operator-sdk v1.3.0):

```shell
operator-sdk init --plugins=helm --helm-chart blackduck-connector --helm-chart-repo https://sig-repo.synopsys.com/artifactory/sig-cloudnative --helm-chart-version 2.2.5-1 --domain synopsys.com --project-name=blackduck-connector-operator --kind=BlackduckConnector --version=v1alpha1
```

### Step 2: Make Manual changes to some files

The command above will initialize all the files although some info would need to be updated manually:

* Change the following in Makefile
  * Version of the operator
  * BUNDLE_IMG to appropriate image name w/ repo: this is for storing operator metadata for OpenShift OLM marketplace.
  * IMG to appropriate image name w/ repo: this is for storing the operator image.
  
* **operator-sdk has a bug in 1.3.0** that prevents the file in config/samples/kustomization.yaml to appropriately name the sample chart. Change `"_v1alpha1_blackduckconnector.yaml" -> "charts_v1alpha1_blackduckconnector.yaml"`

### Step 3: Test the operator

Configure a cluster with appropriate size to test out the operator and connect to it.

#### Testing the operator w/o OLM

1. Build & Push Operator image
  
  ```shell
    make docker-build
    make docker-push
  ```

2. Install the CRD in the cluster

  ```shell
    make install
  ```

3. Deploy the workloads to the cluster

  ```shell
    make deploy
  ```

4. Test out the operator by deploying connector sample chart

  ```shell
    kubectl apply -f config/samples/charts_v1alpha1_blackduckconnector.yaml
  ```

5. This is should deploy the connector containers, check out the logs to make sure connector is working properly.

#### Testing the operator w/ OLM

1. Create the bundle & validate to make sure bundle was created properly 

  ```shell
    make bundle
    operator-sdk bundle validate ./bundle --verbose
  ```

Sometimes validation might seem successful but it should create 3 folders like this:

  ```shell
  ├── bundle
  │   ├── manifests
  │   │   ├── blackduck-connector-operator-controller-manager-metrics-service_v1_service.yaml
  │   │   ├── blackduck-connector-operator-metrics-reader_rbac.authorization.k8s.io_v1_clusterrole.yaml
  │   │   ├── blackduck-connector-operator.clusterserviceversion.yaml
  │   │   └── charts.synopsys.com_blackduckconnectors.yaml
  │   ├── metadata
  │   │   └── annotations.yaml
  │   └── tests
  │       └── scorecard

  ```

2. Build & push the bundle image

  ```shell
    make bundle-build
    make bundle-push
  ```

3. Run the bundle image

  ```shell
    operator-sdk run bundle $(BUNDLE_IMG)
  ```

This will create a catalog for you and install the operator in the cluster

4. Go into the OpenShift UI and look for installed operators, create the BlackDuckConnector object by passing the variables.

### Step 4: Fine tune the metadata in bundle

The bundle/manifests/ folder has charts file which enables us to define the required component for UI:

This should match the templating or format of metadata/annotations/alm-examples notation in

`/bundle/manifests/blackduck-connector-operator.clusterserviceversion.yaml`

* For a simple value the notation can be:
  
```yaml
 spec:
    description: BlackDuckConnectorSpec defines the desired state of BlackduckConnector
    properties:
      logLevel:
        type: string
      type: object
```

* For a required object the notation can be:

```yaml
  spec:
    description: BlackDuckConnectorSpec defines the desired state of BlackduckConnector
    properties:
      podProcessor:
        properties:
          nameSpaceFilter:
            type: string
        type: object
      required:
        - podProcessor
      type: object

```

* For a required array of objects the notation can be:

```yaml
  spec:
    description: BlackDuckConnectorSpec defines the desired state of BlackduckConnector
    properties:
      externalBlackDuck:
        items:
          description: This object stores the Black Duck information to connect & perform the scans. (Black Duck can be deployed in or out of the Cluster)
          properties:
            concurrentScanLimit:
              type: integer
            domain:
              type: string
            password:
              type: string
            port:
              type: integer
            scheme:
              type: string
            user:
              type: string
          required:
          - domain
          - user
          - password
          type: object
        type: array
      required:
        - externalBlackDuck
      type: object
```
