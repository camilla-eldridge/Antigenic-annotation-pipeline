#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys

bepipred=sys.argv[1] #"AG_test_clustalo.bepipred"
alignment=sys.argv[2] #"AG_test_clustalo.fasta"
outfile=sys.argv[3] #"for_ggplot.csv"


out=open(outfile, "w")

# save split bepipred scores and remove unwanted lines
zz=[]
with open(bepipred,"rt") as ag_scores:
    t="".join(ag_scores).split("\n") #split by lines 
    for line in t[1:]:
        if "bepipred" in line and "source" not in line:
            zz.append(line)

# get headers info 
headers=""
with open(alignment, "rt") as prots_aligned:
    g="".join(prots_aligned).split(">")[1:]
    for n in g:
        n=n.split()
        headers=headers + (n[0]) + "\n"
        
Heads=[f for f in headers.split("\n")] # for headers more than one letter...

testM=""
with open(alignment, "rt") as prots_aligned:
    g="".join(prots_aligned).split(">")[1:]
    for n in g:
        n=n.split()
        head=n[0]
        sequence="".join(n[1:])
        for gg in Heads:
            if gg == head:
                testM = testM + sequence
            
# list of strings, stays in same order so can add to Bepipred
# as long as alignment is in same order as was input to bepipred.

allM=[]
for i in zz:
    k=i.split()
    jj=[v for v in k]
    jl=jj[0] + " " + jj[4] + " " + jj[5]
    allM.append(jl)
            

res1=[l for l in testM]   
out1 = '\n'.join(map(' '.join, zip(allM,res1))) 

#print(out1)

removed_gaps=[]
for h in out1.split("\n"):
    h=h.split()
    if "-" in h[3]:
        pass
    else:
        removed_gaps.append(h)
        

final=[",".join(p) for p in removed_gaps]       
out.write("Sequence" + "," + "AA" + "," + "Ag" + "," + "code" + "\n" + "\n".join(final))
        
                
                    
                                        
## NOTES ##

#separate out only ag_score lines (score lines have bepipred and 
#one line has source that isnt a score line
#function to perform alternate line merging of strings
#In1="acegi"
#In2="bdfhj"
#out1 = ''.join(map(''.join, zip(In1, In2))) 


# bepipred 1 replaces gaps and stops with A so cant use replace! :(
# best bet is to index gaps and results...ad cut the lines relating to sequence and not inserted A's

# bepipred remove ##Type Protein A
# seqname            source        feature      start   end   score  N/A   ?



#Manual option
#1. Replace all gaps with X  sed -i 's/-/X/g' AG_test_proteins.fasta 
#2. Run Bepipred2 on online server
#3. edit csv output by removing lines with X's.
#4.plot as usual