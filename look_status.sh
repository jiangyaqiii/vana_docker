#!/bin/bash

if [[ $(docker ps -qf name=dlp-validator-container) ]]; then
    echo "vana正在运行"
else
    echo "停止"
fi
