#!/bin/sh

is_value_from=0

for argument in $@
do
  if [ $argument = "--value-from" ]
  then
    is_value_from=1
  else
    ssm_path=$argument
  fi
done

if [ -z $ssm_path ]
then
  echo "[error] Missing path."
  echo "Usage:"
  echo "  --value-from  Get the ARN to use with valueFrom."
  exit 1
fi

which aws > /dev/null \
  || (echo "[error] 'aws-cli' is not installed." && exit 1)

which jq > /dev/null \
  || (echo "[error] 'jq' is not installed." && exit 1)

output=$(aws ssm get-parameters-by-path --with-decryption --path $ssm_path | jq --raw-output -M '
  [(
    .Parameters[]
      | del(.Type, .Version, .LastModifiedDate, .DataType)
      | to_entries
      | map_values(.key = (.key | ascii_downcase))
      | map_values(.key = if .key == "arn" then "valueFrom" else .key end)
      | map_values(.value = if .key == "name" then (.value | split("/"))[-1] else .value end)
      | from_entries
  )]
')

if [ $is_value_from = "1" ]
then
  echo $output | jq -M '[.[] | del(.value)]'
else
  echo $output | jq -M '[.[] | del(.valueFrom)]'
fi
