#!/bin/bash

##################################################################
##                                              		##
##  Luciano Maia Cirilo                        			##
##  lucianosuper@hotmail.com                   			##
##  Script varre Windows e diz oq precisa ser monitorado        ##                        
##                                              		##      
##################################################################

#### Tratando Falta de Informacao ##############

if [ $# = 0 ]
then
   echo ""
   echo "./check_winz.sh  [IP]" 
   echo ""
   echo "Exemplo:" 
   echo "" 
   echo "./check_winz.sh  192.168.98.63" 
   echo ""
   exit 1
fi

### Variavel IP
IP="$1"

### limpar arquivos
> /tmp/resultadochek.log
> /tmp/templates.log

## para descobrir todos os servicos q estao rodando no windows e seus processos
##zabbix_get -s 172.22.2.20 -k service.discovery


#### verificando servicos do windows
processos () {

#### Testando Processos
for j in MSExchangeServiceHost MSExchangeFastSearch MSExchangeRPC MSExchangeSubmission MSExchangeDelivery MSExchangeMailboxReplication MSExchangeMailboxAssistants MSExchangeIS MSExchangeHM MSExchangeFrontEndTransport MSExchangeEdgeSync MSExchangeDiagnostics MSExchangeDagMgmt MSExchangeAntispamUpdate MSExchangeADTopology TOPdesk Tomcat6 SAPB1iDIProxy B1LicenseService SBOClientAgent nSService nSManager nSLogger DCSServer MySQL56 MSSQLSERVER SQLSERVERAGENT sm940service MSCRMAsyncService MSCRMEmail DHCPServer
do
	zabbix_get -s $IP -k service.info[$j] > /tmp/processos.log | > /dev/null
	cat /tmp/processos.log | grep -v "0" > /dev/null
	if [ $? = 0 ]
	then
		echo "nada a fazer" > /dev/null
	else
		echo "Monitorar Servicos $j" >> /tmp/resultadochek.log
	fi
done

}


############### inicio dos checks de tempĺates

TemplateDHCP () {
cat /tmp/resultadochek.log | grep "DHCPServer" > /dev/null
if [ $? = 0 ]
then
   echo "Template DHCPServer" >> /tmp/templates.log
fi
}

TemplateCRM () {
cat /tmp/resultadochek.log | grep -E "(MSCRMAsyncService|MSCRMEmail)" > /dev/null
if [ $? = 0 ]
then
   echo "Template CRM" >> /tmp/templates.log
fi
}


TemplateNDDigital () {
cat /tmp/resultadochek.log | grep -E "(nSService|nSManager|nSLogger|DCSServer)" > /dev/null
if [ $? = 0 ]
then
   echo "Template NDDigital" >> /tmp/templates.log
fi
}


TemplateSAP () {
cat /tmp/resultadochek.log | grep -E "(SAPB1iDIProxy|B1LicenseService|SBOClientAgent)" > /dev/null
if [ $? = 0 ]
then
   echo "Template SAP"  >> /tmp/templates.log
fi
}


TemplateMSExchange () {
cat /tmp/resultadochek.log | grep -E "(MSExchangeServiceHost|MSExchangeFastSearch|MSExchangeRPC|MSExchangeSubmission|MSExchangeDelivery|MSExchangeMailboxReplication|MSExchangeMailboxAssistants|MSExchangeIS|MSExchangeHM|MSExchangeFrontEndTransport|MSExchangeEdgeSync|MSExchangeDiagnostics|MSExchangeDagMgmt|MSExchangeAntispamUpdate|MSExchangeADTopology)" > /dev/null
if [ $? = 0 ]
then
   echo "Template MS Exchange"  >> /tmp/templates.log
fi
}

TemplateTOPdesk () {
cat /tmp/resultadochek.log | grep TOPdesk > /dev/null
if [ $? = 0 ]
then
   echo "Template TOPdesk"  >> /tmp/templates.log
fi
}


TemplateTomcat6 () {
cat /tmp/resultadochek.log | grep Tomcat6 > /dev/null
if [ $? = 0 ]
then
   echo "Template Tomcat6"  >> /tmp/templates.log
fi
}


TemplateMySQL () {
cat /tmp/resultadochek.log | grep MySQL56 > /dev/null
if [ $? = 0 ]
then
   echo "Template MySQL"  >> /tmp/templates.log
fi
}


TemplateMSSQLSERVER () {
cat /tmp/resultadochek.log | grep MSSQLSERVER > /dev/null
if [ $? = 0 ]
then
   echo "Template MSSQL SERVER"  >> /tmp/templates.log
fi
}


TemplateSQLSERVERAGENT () {
cat /tmp/resultadochek.log | grep SQLSERVERAGENT > /dev/null
if [ $? = 0 ]
then
   echo "Template MSSQL AGENT"  >> /tmp/templates.log
fi
}


TemplateHPSM () {
cat /tmp/resultadochek.log | grep sm940service > /dev/null
if [ $? = 0 ]
then
   echo "Template HPSM Server"  >> /tmp/templates.log
fi
}


############ fim templates ###############################################


final () {

echo ""
echo -e "\033[1;38;5;118mO servidor Windows esta com as seguintes portas abertas\033[0m"

nmap -sT $IP > /tmp/portas.log
nmap -sU -p 161 $IP >> /tmp/portas.log
cat /tmp/portas.log | grep open
echo ""
echo ""
echo -e "\033[1;38;5;118mO servidor Windows tem as seguintes Particoes e Processos \033[0m"

cat /tmp/resultadochek.log 
echo ""
echo ""
echo -e "\033[1;38;5;118mAdicione os Templates Abaixo no Host \033[0m"

cat /tmp/templates.log
echo ""

}




#### Testando Ping
ping -qc5 $IP > /dev/null
a=$?

zabbix_get -s $IP -k agent.version > /dev/null
b=$?

if [ $a -eq 0 -a $b -eq 0 ]
then
	echo "Monitorar P.I.N.G - $IP" >> /tmp/resultadochek.log
	processos
	TemplateDHCP
	TemplateCRM
	TemplateNDDigital
	TemplateSAP
	TemplateMSExchange
	TemplateTOPdesk
	TemplateTomcat6
	TemplateMySQL
	TemplateMSSQLSERVER
	TemplateSQLSERVERAGENT
	TemplateHPSM
	final
else
	echo ""
	echo -e "\033[1;38;5;001m#### --- ATENCAO Verificar se o IP esta Pingando ou Cliente do Zabbix na Porta 10050 TCP Foi instalado --- ####\033[0m"
	echo ""
fi

