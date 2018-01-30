#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

# Exec the specified command or fall back on bash
if [ $# -eq 0 ]; then
    cmd=bash
else
    cmd=$*
fi

#if [ ! -z "$INSTALL_TF" ]; then
#    echo "Installing tensorflow." 
#    pip install tensorflow-gpu
#fi
    
# Execute the command
echo "Executing the command: $cmd"
exec $cmd
