#!/bin/bash

ipmitool -I lanplus -H 172.22.2.11 -U Administrator -P 1q2w3e4r sensor | grep "01-Inlet" | cut -d "|" -f2 | cut -c 2-3

