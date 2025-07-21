#!/bin/bash
set -euo pipefail

DATA_PATH=${1}
COPY_CONFIG=${2:-false}
SOURCE_PATH=${3:-.}

#region global configuration
S3_ASSETS_BUCKET_BACKUP_PATH="${S3_ASSETS_BUCKET}/${S3_ASSETS_BUCKET_PATH}/ring-mqtt"
#endregion

#region functions
function check() {
  DATA_EXISTS="true"

  test_file='config.json'
  if ! test -f ${DATA_PATH}/${test_file}; then
    DATA_EXISTS="false"
  fi
}

function backup() {
  echo "backing up..."
  
  # uploading backup from S3
  echo "uploading storage..."
  s3cmd --access_key=${GCS_ACCESS_KEY_ID} --secret_key="${GCS_SECRET_ACCESS_KEY}" --host="https://storage.googleapis.com" --host-bucket="https://storage.googleapis.com" --force put ${DATA_PATH}/ring-state.json s3://${S3_ASSETS_BUCKET_BACKUP_PATH}/

  if [[ "${COPY_CONFIG}" == "true" ]]; then
    copy_configuration
  fi
}

function restore() {
  echo "restoring..."

  echo "wiping data..."
  rm -rf ${DATA_PATH}/*

  # download backup from S3
  echo "downloading and restoring storage..."
  s3cmd --access_key=${GCS_ACCESS_KEY_ID} --secret_key="${GCS_SECRET_ACCESS_KEY}" --host="https://storage.googleapis.com" --host-bucket="https://storage.googleapis.com" --recursive --force get s3://${S3_ASSETS_BUCKET_BACKUP_PATH}/ ${DATA_PATH}/

  copy_configuration
}

function copy_configuration() {
  echo "wiping current configuration data..."
  files=$(find ${SOURCE_PATH}/configuration -maxdepth 1 -exec basename -a {} +)
  for file in ${files[@]}; do
    rm -rf ${DATA_PATH}/${file}
  done

  echo "copying configuration..."
  cp -rf ${SOURCE_PATH}/configuration/* ${DATA_PATH}/
}
#endregion

#region log configuration
echo "using S3 bucket and path: ${S3_ASSETS_BUCKET_BACKUP_PATH}"
#endregion

#region data check
check
#endregion

#region backup or restore
# if check returns true, we need to perform a backup
# otherwise, we have a new (empty) setup and can restore
if [[ "${DATA_EXISTS}" == "true" ]]; then
  backup
else
  restore
fi
#endregion
