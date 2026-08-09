#!/bin/bash

# usage: ./show_block.sh linux

TAG="$1"
awk -v tag="# \$${TAG}" '
    $0==tag {flag=1; next}
    /^# \$/{flag=0}
    flag
' ~/Documents/manual
