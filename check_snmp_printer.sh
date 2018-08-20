#!/bin/bash

host="$1"
comunidade="$2"
toner="$3"
warning="$4"
critical="$5"


/usr/lib/zabbix/externalscripts/check_snmp_printer -H $host  -C $comunidade -t "$toner" -w $warning -c $critical | cut -d "=" -f2 | cut -d ";" -f1
