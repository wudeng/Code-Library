#!/bin/bash

sed '
    /skynet_stat_switch/s/true/false/
    /metrics_bucket/s/".*"/""/
    /battle[0-9]_public_ip/s/".*"/"192.168.56.10"/
    /rank_svr_ip/s/".*"/"127.0.0.1"/
    /mongo/s/27019/27017/
' ./etc/cfg.template > ./etc/cfg.lua
