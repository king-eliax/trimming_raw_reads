# Trimming Raw Reads Worksheet

<!--- Write name below --->
## Name:Seun Onileowo 

<!--- For this worksheet, answer the following questions--->

## Q1: What does "cleaning" your reads mean?
Answer:Removing low quality bases or bases that don't meet a set parameter

### Q2: Open the script called "trim_raw_reads.sh". For every line that says ```insert description here```, replace that text with a description of what the line will do

### Q4: Attach an image of the plot from fastqc showing the average base quality from your reads files
![before-trimming-PHRED-plot-1](./images/<plot-for-reads1>)
![before-trimming-PHRED-plot-1](./images/<plot-for-reads2>)

---

## The following questions pertain to your first fastp run (without altering the parameters)
### Q5: How many reads were there in the R1 file before filtering?
Answer:33967298
### Q6: How many bases were there in the R1 file before filtering?
Answer:3430697098
### Q7: What proportion of bases were above PHRED score of 20 before filtering?
Answer: 96.2516%
### Q8: What proportion of bases were above PHRED score of 30 before filtering?
Answer: 91.5904%

### Q13: How many reads were there in the R2 file before filtering?
Answer: 33967298
### Q14: How many bases were there in the R2 file before filtering?
Answer:  3430697098
### Q15: What proportion of bases were above PHRED score of 20 before filtering?
Answer: 95.0005%
### Q16: What proportion of bases were above PHRED score of 30 before filtering?
Answer: 90.0214%

### Q17: How many reads were there in the merged file after filtering?
Answer:  12295196
### Q18: How many bases were there in the merged file after filtering?
Answer: 1750796378
### Q19: What proportion of bases in the merged file were above PHRED score of 20 after filtering?
Answer: 98.9275%
### Q20: What proportion of bases in the merged file were above PHRED score of 30 after filtering?
Answer: 95.3968%

### Q21: What is the difference between the merged and unmerged files (in principle, not quantitatively)?
Answer: Merged files may contain overlaps and merged files contain multiple samples. Unmerged files do not contain overlaps and are usually individually files.
### Q22: Why are the unmerged files for R1 and R2 different lengths?
Answer: Quality trimming. If R1 and R2 have different levels of quality, one file may be trimmed more aggressively than the other

---

## The following questions pertain to Remix 1 (the first time you change fastp parameters)
### Q23: What parameters did you change?
Answer: u = 35
### Q24: How did you expect this to change the filtering results (be specific)?
Answer: More bases, since the percentage threshold was decreased
### Q25: Explain the results. Did the change cause an effect that matched your expectations? Use information from the fastp output to explain.
Answer: The files were more or less the same. The changed parameter did not have much of an effect in the analysis of the read

---

## The following questions pertain to Remix 2 (the first time you change fastp parameters)
### Q26: What parameters did you change?
Answer: e = 20, u = 30
### Q27: How did you expect this to change the filtering results (be specific)?
Answer: More bases, since the percentage threshold was decreases
### Q28: Explain the results. Did the change cause an effect that matched your expectations? Use information from the fastp output to explain.
Answer: As predicted, there were more bases after filtering in the merged reads.

