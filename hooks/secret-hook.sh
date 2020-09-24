#!/usr/bin/env bash

source /hooks/common/functions.sh

hook::config() {
  cat <<EOF
{
  "configVersion":"v1",
  "kubernetes": [
    {
      "apiVersion": "v1",
      "kind": "Secret",
      "executeHookOnEvent": [
        "Added",
        "Modified"
      ],
      "namespace": {
        "nameSelector": {
          "matchNames": [
            "dev"
          ]
        }
      }
    }
  ]
}
EOF
}

hook::trigger() {
  # ignore Synchronization for simplicity
  type=$(jq -r '.[0].type' $BINDING_CONTEXT_PATH)
  if [[ $type == "Synchronization" ]] ; then
    echo Got Synchronization event
    exit 0
  fi

  for secret in $(jq -r '.[] | .object.metadata.name' $BINDING_CONTEXT_PATH)
  do
    # do stuff
    echo Secret $secret created or changed!!
  done
}

common::run_hook "$@"