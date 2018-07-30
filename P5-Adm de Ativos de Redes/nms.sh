#!/bin/bash
# Autor: Miguel Cabral (miguel.rb.cabral@gmail.com)
# Descrição:
#	Solicita, a cada 3 segundos, o valor das variáveis SNMP ifInOctets e ifOutOctets da interface de saída (bridge/externa) da rede, por 10 minutos.
#	Tem como saída Tempo decorrido do script, Entrada e Saída em Bytes e a taxa total em kbps, separados por tabulação num arquivo teste.txt, além da saída padrão.
# leitura => Comunidade SNMP
# router  => IP do ativo que será consultado.

echo -e "Tempo (s)\tEntrada (B)\tSaida (B)\tTaxa (B/s)" | tee  teste.txt
anterior=0
atual=0
for ((t=0; t<601; t+=3)); do
	entrada=`snmpget -v2c -c leitura router ifInOctets.2 | cut -d: -f4`
	saida=`snmpget -v2c -c leitura router ifOutOctets.2 | cut -d: -f4`
	# Transformar Byte pra bits (*8)
	# Transformar bit para kbit (/1000)
	# Tempo atual - Tempo anterior (/3)
	# Logo 8/3000 = 1/375
	atual=$(($entrada+$saida))
	taxa_kbps=$((($atual-$anterior)/375))
	echo -e "$t\t$entrada\t$saida\t$taxa_kbps"
	sleep 3 # as variáveis são atualizadas a cada 3 segundos
	anterior=$atual
done | tee -a teste.txt
