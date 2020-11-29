#!/bin/sh

ssm_path=$1

test -z $ssm_path \
  && echo "[error] missing path." \
  && exit 1

which aws > /dev/null \
  || (echo "[error] 'aws-cli' is not installed." && exit 1)

which jq > /dev/null \
  || (echo "[error] 'jq' is not installed." && exit 1)

aws ssm get-parameters-by-path --with-decryption --path $ssm_path |
  jq --raw-output '
    [(
      .Parameters[]
        | del(.Type, .Version, .LastModifiedDate, .ARN, .DataType)
        | to_entries
        | map_values(.key = (.key | ascii_downcase))
        | map_values(.value = if .key == "name" then (.value | split("/"))[-1] else .value end)
        | from_entries
    )]
  '
