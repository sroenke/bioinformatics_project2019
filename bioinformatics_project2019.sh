# This code determines which proteomes contain a general consensus for the mcrA
# gene. It takes those which contain the gene and then determines which have
# the HSP70 gene, and how many copies of the HSP70 gene each contains. The 
# results are then listed in tabular form and a text document ranking the 
# proteomes by HSP70 content is produced. 

# Adjustments to the code may be necessary depending on the user's 
# file and directory organization.

# Usage: bash bioinformatics_project2019.sh <GENE_1> <GENE_2>
# Example: bash bioinformatics_project2019.sh mcrA hsp70

cat ref_sequences/$1*.fasta >> $1.refs
cat ref_sequences/$2*.fasta >> $2.refs

# The above lines make cumulative .refs files containing all reference
# sequences for the mcrA and hsp70 genes, respectively.


