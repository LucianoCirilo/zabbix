#!/bin/bash

### logica invertida, executa o comando se avalia a variavel de retorno
# se for 0 entao ta ok e retorna 1 para o zabbix q tem uma trigger para alarmar se for diferente de 1

/usr/local/bin/cdcc info | grep "requests ok" > /dev/null
cdcc="$?"

if [ $cdcc -eq 0 ]
then
	## up - conectou nos servers
	echo -n "1"
else
	## down - erro ao conectar nos servers
	echo -n "0"
fi


