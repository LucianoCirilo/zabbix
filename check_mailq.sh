#!/bin/sh

###############################################
##     Luciano Maia Cirilo                   ##
##     lucianosuper at hotmail.com           ##
##     http://www.nagiosnapratica.com.br     ##
###############################################

## Criando os arquivos temporarios
mailq > /tmp/fila.log
mailq > /tmp/fila-vazia.log

## Realizando as consultas
tail -n 1 /tmp/fila.log | cut -d " " -f 5 > /tmp/nfila.txt
cat /tmp/fila-vazia.log | grep "Mail queue is empty" > /dev/null

## Testando a ultima consulta para verificar se a fila esta vazia
if [ $? = 0 ]
then
#echo "OK - A fila de E-mail esta vazia"
### zabbix trabalha melhor com numero
echo "0"
exit 0

         ## Fila menor ou igual a 50
         elif [ `cat /tmp/nfila.txt` -lt 50 ]
         then
               echo "`cat /tmp/nfila.txt`"
 exit 0

          ## Fila menor ou igual a 80
          elif [ `cat /tmp/nfila.txt` -lt 80 ]
          then
               echo "`cat /tmp/nfila.txt`"
 exit 1

          ## Fila maior que 80
          elif [ `cat /tmp/nfila.txt` -gt 80 ]
          then
                echo "`cat /tmp/nfila.txt`"
                exit 2
          else
                echo "UNKNOWN - Erro ao tentar ler a fila de e-mail"
                exit 3
fi
