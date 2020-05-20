#!/bin/bash

source /scripts/common.sh
source /scripts/bootstrap-helm.sh
set -ex


run_tests() {
  echo Running tests...
  wait_pod_ready assets assets 1/1
}

teardown() {
  helmfile destroy
}

main(){
  if [ -z "$KEEP_W3F_ASSETS" ]; then
      trap teardown EXIT
  fi
  echo Installing...
  kubectl create namespace assets
  /scripts/build-helmfile.sh

  run_tests

}

main
set +x
