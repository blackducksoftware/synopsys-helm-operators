# Synopsys Helm Operators

## Supported Applications

* Black Duck
* Black Duck Connector

## Requirements

* operatorsdk
  * https://github.com/operator-framework/operator-sdk/releases
  * https://sdk.operatorframework.io/docs/install-operator-sdk/
  * version 1.3.0 is required
* Helm 3
* Docker

## Overview

* Each application has an associated operator
* You can create a new operator by running create-[product]-operator.sh
* Each operator has a Custom Resource Definition (CRD) for each version of the Application that it supports