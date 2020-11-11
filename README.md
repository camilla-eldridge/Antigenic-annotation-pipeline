
# Antigenic annotation pipeline<br /> <br /> <br /> 

Created to predict and annotate potential vaccine candidate proteins from draft genomes.
<br /> <br /> <br /> 
Problem: Some genomes of medically important parasites are in draft form and lack functional annotation.

Solution: `Antigenic_annotation.sh` predicts and annotates single protein queries from draft genomes and provides protein annotation of transmembrane regions, conserved domains and antigenic regions.<br /> <br /> <br /> 


      Usage:  ./Antigenic_annotation.sh  /path/to/genomes/ protein_query best_n  gene_id  translation_table

<br /> <br /> <br /> 
<br /> <br /> <br /> 
<br /> <br /> <br /> 

## Part I
- Predicts best scoring coding-exon sequences from target genome/s using exonerate protein2genome model
- Extracts coding-exon sequence from exonerate output using extract_exonerate.py (see Sequence-tools repository)
- Gets the highest scoring coding-exon alignment and translates it using Transeq (EMBOSS) (highest scoring is predicted using best_n 1 in exonerate)
- Uses longest_orf.py (see Sequence-tools) to predict the longest open reading frame.
- Stores the prediction from each species/genome in a single mf file.<br /> <br /> <br /> 

![alt text](https://github.com/camilla-eldridge/Antigenic-annotation-pipeline/blob/main/diagram/part_I.png)

<br /> <br /> <br /> 

## Part II
- Aligns all proteins from the mf file (Output of Part I).
- Runs Bepipred, Tmhmm and a CDD search on each protein (after separating the mf file using mulif_to_singlef.py, see Sequence-tools) 
- Aligns antigenicity predition scores to the sequence alignment using align_bepipred_scores.py (see Sequence-tools)
- Plots aligned antigenic scores in R (see R-plots repository).<br /> <br /> <br /> 


![alt text](https://github.com/camilla-eldridge/Antigenic-annotation-pipeline/blob/main/diagram/part_II.png)


<br /> <br /> <br /> 

Required in PATH$: 
- exonerate
- cowsay (for fun)
- Transeq (EMBOSS)
- Clustalo
- Bepipred
- extract_exonerate.py
- longest_orf.py
- multif_to_singlef.py
- align_bepipred_scores.py
- cdd_search.sh
- Ag_plot.R

<br /> <br /> <br /> 

Notes:
#enter full path to genome directory
#genomes need to have .fna extension (or edit Antigenic_annotation.sh )










