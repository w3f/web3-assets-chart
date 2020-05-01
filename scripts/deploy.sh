#!/bin/sh

set -ex
cat > $VALUES_FILE <<EOF
environment: production
rclone:
  config: |
    $RECORDER_CONFIG
EOF

cat ${VALUES_FILE}

/scripts/deploy.sh -t helm -c engineering -a "web3-assets w3f/web3-assets -f ${VALUES_FILE}"
