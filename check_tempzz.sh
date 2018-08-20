#!/bin/bash

#templocal=(`hpasmcli -s 'show temp' | grep AMBIENT | cut -c 32-33`)
#echo "$templocal"
hpasmcli -s 'show temp' | grep AMBIENT | cut -c 32-33



