
Antigenic annotation pipeline<br /> <br /> <br /> 

Problem: Many draft genomes are yet to be annotated with proteins lacking functional annotation, to include some species in functional analyses researchers need to wait for genome annotation. 

Solution: genome_scan.sh is a pipeline that predicts and annotates specific proteins from draft genomes to predict transmembrane regions,conserved domains and antigenic regions.<br /> <br /> <br /> 

Part I
- Predicts best scoring coding-exon sequences from target genome/s using exonerate protein2genome model
- Extracts coding-exon sequence from exonerate output using extract_exonerate.py (see Sequence-tools repository)
- Gets the highest scoring coding-exon alignment and translates it using Transeq (EMBOSS) (highest scoring is predicted using best_n 1 in exonerate)
- Uses longest_orf.py (see Sequence-tools) to predict the longest open reading frame.
- Stores the prediction from each species/genome in a single mf file.<br /> <br /> <br /> 

Part II
- Aligns all proteins from the mf file (Output of Part I).
- Runs Bepipred, Tmhmm and a CDD search on each protein (after separating the mf file using mulif_to_singlef.py, see Sequence-tools) 
- Aligns antigenicity predition scores to the sequence alignment using align_bepipred_scores.py (see Sequence-tools)
- Plots aligned antigenic scores in R (see R-plots repository).<br /> <br /> <br /> 


      Usage:  ./genome_scan.sh /path/to/genomes/ protein_query best_n

<br /> <br /> <br /> 
<br /> <br /> <br /> 

![alt text](https://github.com/camilla-eldridge/Antigenic-annotation-pipeline/blob/main/diagram/pipeline_diagram.png)
