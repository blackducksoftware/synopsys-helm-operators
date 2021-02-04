helmRepo=$1

echo "helm search repo --versions | grep \"${helmRepo}/\""
helm search repo --versions | grep "${helmRepo}/"

