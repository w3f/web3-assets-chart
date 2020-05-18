#!/bin/bash

source /scripts/common.sh
source /scripts/bootstrap-helm.sh
set -ex


run_tests() {
  echo Running tests...
  wait_pod_ready assets default 1/1
}

teardown() {
  helm delete assets
}

main(){
  if [ -z "$KEEP_W3F_ASSETS" ]; then
      trap teardown EXIT
  fi
  echo Installing...
  helm install --set environment="ci" --set rclone.config.driveName="${DRIVE_NAME}" --set rclone.config.scope="${DRIVE_SCOPE}" --set rclone.config.rootFolderID="1VBlL-00d-EA1xTkgQgFP0tmitg6qJKth" --set rclone.config.token="${TOKEN}" --set rclone.config.token="${GITHUB_BOT_TOKEN}" assets ./charts/assets

  run_tests

}

main
set +x
