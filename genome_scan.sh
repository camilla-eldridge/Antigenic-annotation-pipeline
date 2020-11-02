#!/bin/bash
# set -e

if [ "$1" == "-h" ]; then
  echo "Usage: ./genome_scan.sh /path/to/genomes/ protein_query best_n"
  exit 0
fi


# Notes on usage #
#all accessory scripts are in $PATH  (home path)
#enter full path to genome directory
#genomes need to have .fa extension

path_to_genomes="$1"
protein_query="$2"
best_n="$3"

# create id and path variables #
id="${protein_query%.*}"
start_path=$(pwd) #specifies where you are running the script and where you want the output dirs to be made

#just for fun
cowsay -f moose Predicting...

#checks if genomes zipped or not, will unzip if they are
#after each genome is scanned using exonerate for the
#protein query and a new directory made for the results

for f in "$path_to_genomes"*fa*;do
	if [[ "$f" == "*.gz" ]];then
		gunzip "$f"
		g="${f%.*}"
	else
		#echo "not gzipped"
		g="$f"
	fi
	name="${g%.*}"
	nameb="${name##*/}"
	mkdir -p "$id"_"$nameb"
	exonerate --model protein2genome --query "$protein_query" \
	--target "$g" --showtargetgff yes --showalignment no --showvulgar no --showquerygff no --bestn "$best_n" \
	--ryo "%qi(%qab - %qae)\n%qas\n >%ti:%s(%tab - %tae)\n%tas\n >%ti:%s\n%tcs\n" > "$id"_"$nameb"/"$id".exonerate
	cd "$id"_"$nameb"
	extract_exonerate.py "$id" "$id".exonerate
	cat *cds.fasta > "$id".fasta
	exonerate_highest_score.py "$id".fasta > "$id"_final.fasta
	cat "$id"_final.fasta >> "$start_path"/"$id"_all_cds.fa
	cd ..
done

# go back to start directory and make directory for translated sequences #
cd "$start_path"

# transeq doesnt like these characters in the headers so this removes stops and underscores #
cat "$id"_all_cds.fa | tr _ . | tr . - | sed 's/-.*//' > "$id"_all_cds_new.fa

mkdir -p "$id"_translated

cd "$id"_translated

multif_tosinglef.py  "$start_path"/"$id"_all_cds_new.fa

for x in *.fasta;do
	transeq -sequence "$x" -outseq "$x"_frames  -frame 6
	longest_orf.py "$x"_frames  > "$x"_prot.fa
	cat "$x"_prot.fa >> "$id"_all_prot.fa;done

# bepipred seems to change headers at the end so removing the last two characters #
#ensures that bepipred and alignment output have same headers#
sed '/^>/ s/..$//' "$id"_all_prot.fa > "$id"_final_prot.fa

bepipred "$id"_final_prot.fa > "$id".bepipred

clustalo -i "$id"_final_prot.fa -o "$id"_aligned_prot.fa

align_bepipred_score.py "$id".bepipred "$id"_aligned_prot.fa "$id"_for_ggplot.txt

Antigenic_plot.R "$id"_for_ggplot.txt "$id".png "$id"


cowsay -f dragon FINISHED
echo "\_(ツ)_/¯"



