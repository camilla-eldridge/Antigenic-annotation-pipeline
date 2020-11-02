#!/bin/bash
coding_sequence="$1"
name="${coding_sequence%.*}"

#post query sequence to cdd database
A=$(curl -F queries=@"$coding_sequence" "http://www.ncbi.nlm.nih.gov/Structure/bwrpsb/bwrpsb.cgi?queries="$name"&db=all&smode=auto&qdefl=FALSE&cddefl=FALSE&dmode=full&tdata=hits&evalue=0.05&dmode=rep&clonely=false&filter=true&useid1=true&maxhit=250")
B=$(echo "$A"| grep "cdsid" | cut -f2)

#echo "$B"

sleep 10s

C=$(curl "http://www.ncbi.nlm.nih.gov/Structure/bwrpsb/bwrpsb.cgi?cdsid="$B"")

D=$(echo "$C" | grep "Job")

if [ -z "$D" ]
then
	curl "http://www.ncbi.nlm.nih.gov/Structure/bwrpsb/bwrpsb.cgi?cdsid="$B""
else
	sleep 1m
	curl "http://www.ncbi.nlm.nih.gov/Structure/bwrpsb/bwrpsb.cgi?cdsid="$B""
fi


