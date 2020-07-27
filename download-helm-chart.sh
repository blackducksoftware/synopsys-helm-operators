repoName=$1
chartName=$2
version=$3

echo "helm fetch --untar --untardir . ${repoName}/${chartName} --version ${version}"
helm fetch --untar --untardir . $repoName/$chartName --version $version

