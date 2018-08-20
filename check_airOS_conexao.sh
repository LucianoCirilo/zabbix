#!/bin/bash

if [ $# = 0 ]
then
echo “”
echo “./check_airOS_conexao.sh IP” 
echo “”
exit 1

fi


### testando se deu pau no ssh

/usr/lib/zabbix/externalscripts/check_by_ssh -H "$1" -C 'date' -l admin -t 15 > /dev/null
sshteste="$?"

if [ $sshteste -eq 0 ]
then
	echo "1"
else
	echo "0"
fi

