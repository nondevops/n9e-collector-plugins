#!/bin/bash

# TCP: 360 (estab 272, closed 71, orphaned 0, synrecv 0, timewait 71/0), ports 0
output=$(ss -s | grep TCP:)

ss_estab=$(echo $output | grep -Po "estab (\d+)" | awk '{print $2}')
ss_closed=$(echo $output | grep -Po "closed (\d+)" | awk '{print $2}')
ss_orphaned=$(echo $output | grep -Po "orphaned (\d+)" | awk '{print $2}')
ss_synrecv=$(echo $output | grep -Po "synrecv (\d+)" | awk '{print $2}')
ss_timewait=$(echo $output | grep -Po "timewait (\d+)" | awk '{print $2}')

localip=$(ifconfig `route|grep '^default'|awk '{print $NF}'`|grep inet|awk '{print $2}'|head -n 1)
step=$(basename $0|awk -F'_' '{print $1}')
timestamp=$(date +%s)

echo '[
    {
        "endpoint": "'${localip}'",
        "tags": "",
        "timestamp": '${timestamp}',
        "metric": "net.ss.estab",
        "value": '${ss_estab}',
        "step": '${step}'
    },
    {
        "endpoint": "'${localip}'",
        "tags": "",
        "timestamp": '${timestamp}',
        "metric": "net.ss.closed",
        "value": '${ss_closed}',
        "step": '${step}'
    },
    {
        "endpoint": "'${localip}'",
        "tags": "",
        "timestamp": '${timestamp}',
        "metric": "net.ss.orphaned",
        "value": '${ss_orphaned}',
        "step": '${step}'
    },
    {
        "endpoint": "'${localip}'",
        "tags": "",
        "timestamp": '${timestamp}',
        "metric": "net.ss.synrecv",
        "value": '${ss_synrecv}',
        "step": '${step}'
    },
    {
        "endpoint": "'${localip}'",
        "tags": "",
        "timestamp": '${timestamp}',
        "metric": "net.ss.timewait",
        "value": '${ss_timewait}',
        "step": '${step}'
    }
]'