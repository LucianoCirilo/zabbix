#!/bin/bash

DATE=`date +%d-%m-%y`
hostname=`hostname -s`


> /tmp/bkp172.log
> /tmp/bkp200.log


## verificando se o backup esta ok
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 bkpcentral@172.22.0.43 "ls -lt /backup/ssh/$hostname/$DATE-* | wc -l" > /tmp/bkp172.log 2>&1
result1=$?

#### se o comando rodou com sucesso, isso e, nao teve erro de ssh
if [ $result1 = 0 ]
then
	### entao mostra o numero 2 no arquivo
	tail -1 /tmp/bkp172.log
	
else
	## senao tenta com outro ip
	ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 bkpcentral@200.150.208.19 "ls -lt /backup/ssh/$hostname/$DATE-* | wc -l" > /tmp/bkp200.log 2>&1
	tail -1 /tmp/bkp200.log
fi

### se o zabbix executar esse plugin e nao retornar o numero 2 .. vai alarmar a trigger simples assim

