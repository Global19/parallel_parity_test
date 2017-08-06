#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

export STARTTIME=$(printf "%x" $(($(date +%s) + 300)))

mini

chmod u+x deploy_*.sh

