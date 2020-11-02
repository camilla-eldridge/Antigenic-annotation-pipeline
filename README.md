
Pipeline to predict and annotate proteins from a draft genome

- genome_scan.sh predicts best scoring coding-exon sequences from target genome/s using exonerate protein2genome model
- Translates and finds the longest open reading frame 
- Uses longest_orf.py, multif_to_singlef.py and align_bepipred.py from Sequence-tools
- Uses Ag_plots.R from R-plots.


      Usage:  ./genome_scan.sh /path/to/genomes/ protein_query best_n
