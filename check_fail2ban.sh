#!/bin/bash

### logica invertida, executa o comando se avalia a variavel de retorno
# se for 0 entao ta ok e retorna 1 para o zabbix q tem uma trigger para alarmar se for diferente de 1

fail2ban-client status sshd | grep -i "Currently banned" | cut -d":" -f2 | grep 0 > /dev/null
fail="$?"

if [ $fail -eq 0 ]
then
	## up - nenhum IP bloqueado no fail2ban
	echo -n "1"
else
	## down - tem ip bloqueado no fail2ban
	echo -n "0"
fi


