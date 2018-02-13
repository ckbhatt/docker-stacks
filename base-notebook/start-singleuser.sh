#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

# set default ip to 0.0.0.0
if [[ "$NOTEBOOK_ARGS $@" != *"--ip="* ]]; then
  NOTEBOOK_ARGS="--ip=0.0.0.0 --port=8888 --allow-root --no-browser --config=/etc/jupyter/jupyter_notebook_config.py $NOTEBOOK_ARGS"
fi

# handle some deprecated environment variables
# from DockerSpawner < 0.8.
# These won't be passed from DockerSpawner 0.9,
# so avoid specifying --arg=empty-string
if [ ! -z "$NOTEBOOK_DIR" ]; then
  NOTEBOOK_ARGS="--notebook-dir='$NOTEBOOK_DIR' $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_PORT" ]; then
  NOTEBOOK_ARGS="--port=$JPY_PORT $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_USER" ]; then
  NOTEBOOK_ARGS="--user=$JPY_USER $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_COOKIE_NAME" ]; then
  NOTEBOOK_ARGS="--cookie-name=$JPY_COOKIE_NAME $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_BASE_URL" ]; then
  NOTEBOOK_ARGS="--base-url=$JPY_BASE_URL $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_HUB_PREFIX" ]; then
  NOTEBOOK_ARGS="--hub-prefix=$JPY_HUB_PREFIX $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_HUB_API_URL" ]; then
  NOTEBOOK_ARGS="--hub-api-url=$JPY_HUB_API_URL $NOTEBOOK_ARGS"
fi


# If ABS_CONTAINER NAME is defined -
#     it means Jupyter is being run in standalone mode, so we use the specified container name.
# Else -
#   Either we don't want to use Azure or we're using Jupyter with JupyterHub.
#   In either case, it is ok to use JPY_USER to form the container name.
if [[ -z "${ABS_CONTAINER_NAME}" ]]; then
  # Azure does not like '_' in container names, so replace it with '-'
  ABS_CONTAINER_NAME=`echo ${JPY_USER} | awk '{ gsub("_", "-"); print }'`
fi

if [[ -n "${ABS_ACCOUNT_NAME}" ]]; then
  NOTEBOOK_ARGS="${NOTEBOOK_ARGS} --AzureContentsManager.account_name=${ABS_ACCOUNT_NAME}"
  NOTEBOOK_ARGS="${NOTEBOOK_ARGS} --AzureContentsManager.access_key=${ABS_ACCESS_KEY}"
  NOTEBOOK_ARGS="${NOTEBOOK_ARGS} --AzureContentsManager.container_name=${ABS_CONTAINER_NAME}"
  NOTEBOOK_ARGS="${NOTEBOOK_ARGS} --AzureContentsManager.templates_store_account_name=${TEMPLATES_STORE_ACCOUNT_NAME}"
  NOTEBOOK_ARGS="${NOTEBOOK_ARGS} --AzureContentsManager.templates_store_sas_token='${TEMPLATES_STORE_SAS_TOKEN}'"
  NOTEBOOK_ARGS="${NOTEBOOK_ARGS} --AzureContentsManager.templates_store_container_name=${TEMPLATES_STORE_CONTAINER_NAME}"
  NOTEBOOK_ARGS="${NOTEBOOK_ARGS} --AzureContentsManager.templates_path_prefix=${TEMPLATES_PATH_PREFIX}"

  NOTEBOOK_ARGS="${NOTEBOOK_ARGS} --NotebookApp.contents_manager_class='azurecontents.azuremanager.AzureContentsManager'"
fi

# Remove these so they don't leak out and become accessible to the user.
# If these are not set in the first place, this is a no-op.
unset ABS_ACCOUNT_NAME
unset ABS_ACCESS_KEY
unset TEMPLATES_STORE_ACCOUNT_NAME
unset TEMPLATES_STORE_SAS_TOKEN
unset TEMPLATES_STORE_CONTAINER_NAME
unset TEMPLATES_PATH_PREFIX


. /usr/local/bin/start.sh jupyterhub-singleuser $NOTEBOOK_ARGS $@
