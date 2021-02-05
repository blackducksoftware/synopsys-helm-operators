# Build the manager binary
FROM quay.io/operator-framework/helm-operator:v1.3.0

LABEL name="Black Duck connector operator" \
      vendor="Synopsys" \
      release.version="1.0.0" \
      summary="Black Duck connector Operator" \
      description="This container is used to deploy Black Duck Connector Operator" \
      license="apache" \
      release="1.0.0" \
      version="1.0.0"

ENV HOME=/opt/helm
COPY watches.yaml ${HOME}/watches.yaml
COPY helm-charts  ${HOME}/helm-charts
COPY licenses /licenses
WORKDIR ${HOME}
