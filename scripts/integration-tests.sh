#!/bin/bash

source /scripts/common.sh
source /scripts/bootstrap-helm.sh
set -ex


run_tests() {
  echo Running tests...
  wait_pod_ready assets assets 1/1
}

teardown() {
  helm delete --namespace=assets assets
}

main(){
  if [ -z "$KEEP_W3F_ASSETS" ]; then
      trap teardown EXIT
  fi
  export ENCODED_TOKEN=$(echo -n "$TOKEN" | base64 -w0 );
  echo Installing...
  kubectl create namespace assets
  /scripts/build-helmfile.sh

  run_tests

}

main
set +x
