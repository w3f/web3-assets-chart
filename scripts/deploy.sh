#!/bin/sh

set -ex
cat > $VALUES_FILE <<EOF
environment: production
rclone:
  config: |
    $RECORDER_CONFIG
EOF

cat ${VALUES_FILE}

/scripts/deploy.sh -t helm -c engineering -a "assets w3f/assets --namespace=assets -f ${VALUES_FILE}"
