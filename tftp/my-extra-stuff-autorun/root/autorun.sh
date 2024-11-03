#!/bin/sh

for i in $(seq 10); do
    sleep 10
    ip addr
    ping -c 1 192.168.157.1
done
