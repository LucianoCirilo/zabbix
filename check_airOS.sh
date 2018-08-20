#!/bin/bash

if [ $# = 0 ]
then
echo “”
echo “./check_airOS.sh IP” 
echo “”
exit 1

fi


resultado=`(/usr/lib/zabbix/externalscripts/check_by_ssh -H "$1" -C '/usr/www/status.cgi | grep ccq | cut -d":" -f2 | cut -d "," -f1 | cut -c2-4' -l admin -t 15)`

if [ $resultado -eq 100 ]
then
       	echo "1000"
       	exit 0
elif [ $resultado -ge 900 ]
then
	echo "$resultado"
	exit 0
else
	echo "$resultado"
	exit 2
fi

