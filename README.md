
Pipeline to predict and annotate proteins from a draft genome<br /> <br /> <br /> 

- genome_scan.sh predicts best scoring coding-exon sequences from target genome/s using exonerate protein2genome model
- Translates and finds the longest open reading frame 
- Uses longest_orf.py, multif_to_singlef.py and align_bepipred.py from Sequence-tools
- Uses Ag_plots.R from R-plots.<br /> <br /> <br /> 


      Usage:  ./genome_scan.sh /path/to/genomes/ protein_query best_n

<br /> <br /> <br /> 
<br /> <br /> <br /> 

![alt text] (Antigenic-annotation-pipeline/blob/main/PIPELINE_FINAL_DIAGRAM.png)
