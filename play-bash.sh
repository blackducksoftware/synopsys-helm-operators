#!/bin/bash

echo  '
  - apiGroups:
      - "batch"
    resources:
      - jobs
    verbs:
      - "*"
' > a.yaml
 

# cat $val