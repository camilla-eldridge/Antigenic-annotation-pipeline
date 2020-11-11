#!/bin/bash
# set -e


# Notes on usage #
if [ "$1" == "-h" ]; then
  echo "Usage:  ./Antigenic_annotation.sh  /path/to/genomes/ protein_query best_n  gene_id  translation_table"
  exit 0
fi

path_to_genomes="$1"
protein_query="$2"
best_n="$3"
ID="$4"
trans_table="$5"

# Gets path of current working dir for directing output dirs #
start_path=$(pwd)

# Define id variable, e.g gene name, entered by user #
id="${ID}"

# Makes output dir #
mkdir "$id"_results

# just for fun #
cowsay -f moose Started prediction...

# Change into directory containing target genomes #

cd "$path_to_genomes"

# Check if genomes are zipped or not, will gunzip if they are #
# Then calls exonerate to predict coding-exons and openreading frames #
# from target genome based on a protein query using the protein2genome model #
# A subdir is made in the results dir for each genome #

for f in *.fna*;do
	if [[ "$f" == "*.gz" ]];then
		gunzip "$f"
		g="${f%.*}"
	else
		g="$f"
	fi
	name="${g%.*}"
	nameb="${name##*/}"

	mkdir -p "$start_path"/"$id"_results/"$id"_"$nameb"
	cd "$start_path"/"$id"_results/"$id"_"$nameb"

	exonerate --model protein2genome --query "$start_path"/"$protein_query" \
	--target "$path_to_genomes"/"$g" --showtargetgff yes --showalignment no --showvulgar no --showquerygff no --bestn "$best_n" \
	--ryo "%qi(%qab - %qae)\n%qas\n >%ti:%s(%tab - %tae)\n%tas\n >%ti:%s\n%tcs\n" > "$start_path"/"$id"_results/"$id"_"$nameb"/"$id"_"$nameb".exonerate

	extract_exonerate.py "$start_path"/"$id"_results/"$id"_"$nameb"/"$id"_"$nameb".exonerate "$id"_"$nameb"

	cat *cds.fasta > "$start_path"/"$id"_results/"$id"_"$nameb"/"$id".fasta

	cat "$id".fasta >> "$start_path"/"$id"_results/"$id"_all_cds.fa

	cd .. ;done



# Change into to results dir #
cd "$start_path"/"$id"_results

# !!!!!!  to test below:
#rm -rf "$id"_all_cds.fa
#touch "$id"_all_cds.fa

# If no coding-exons were predicetd from any genomes, exit the script and tell the user, else continue
if [ -s "$id"_all_cds.fa ];
then
	echo "Predicted coding-exons"
else
	echo "No coding-exons predicted in any target genome"
	echo "Exiting..."
	exit
	cowsay -f moose Sorry...

fi


# Removes stops and underscores for Transeq (doesn't like them) #
cat "$id"_all_cds.fa | tr _ . | tr . - | sed 's/-.*//' > "$id"_all_cds_new.fa

# Make a dir for protein annotation results #
mkdir -p "$id"_protein_annotation

# Change to it #
cd "$id"_protein_annotation

# Separate out each predicted coding-exon sequence #
multif_tosinglef.py  "$start_path"/"$id"_results/"$id"_all_cds_new.fa

# For each coding-exon sequence translate all 6
# reading frames and then find the longest orf (most likely transcript)

for x in *.fasta;do
	x1="${x%.*}"
	transeq -sequence "$x" -outseq "$x1"_frames  -frame 6 -table "$trans_table"
	longest_orf.py "$x1"_frames "$x1" > "$x1"_prot.fa
	cat "$x1"_prot.fa >> "$id"_all_prot.fa;done

# To keep the headers the same in Bepipred output as the alignment, pre-emp remove the last characters from headers (Bepipred cuts them off) #
cat "$id"_all_prot.fa | tr _ . | tr . - | sed 's/-.*//' > "$id"_final_prot.fa


# If analysis is being run with best_n >1, i.e looking for multiple hits #
# from each target genome, need to add unique headers, as otherwise headers will be the same #
# and the plot script will become confused #
if [ "$best_n" -eq 1 ]
then
	echo "Predicting single best hit"
else
	echo "Predicting multiple hits"
	unique_headers.py "$id"_final_prot.fa "$id"_final_prot_edited.fa
	mv "$id"_final_prot_edited.fa "$id"_final_prot.fa
fi

# Run tmhmm on protein sequences to find transmembrane regions #
tmhmm "$id"_final_prot.fa > "$id"_prots.tmhmm

# Align predicted proteins #
clustalo -i "$id"_final_prot.fa -o "$id"_aligned_prot.fa

# Run Bepipred on alignment, indexeds by alignment and gaps replaced by A's  #
bepipred "$id"_aligned_prot.fa > "$id".bepipred

# Indexes Bepipred scores to alignment and removes lines representing gaps and formats output for ggplot #
align_bepipred_scores.py  "$id".bepipred "$id"_aligned_prot.fa "$id"_for_ggplot.csv

# Plots aligned antigenic scores #
Ag_plot.R "$id"_for_ggplot.csv "$id".png "$id"

# Queries the CDD database to predict conserved domains #
cdd_search.sh "$id"_final_prot.fa > "$id"_cdd_search.txt

# Tells you it's done #
cowsay -f dragon FINISHED



