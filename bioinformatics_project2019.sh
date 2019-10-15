# This code determines which proteomes contain a general consensus for the mcrA
# gene. It takes those which contain the gene and then determines which have
# the HSP70 gene, and how many copies of the HSP70 gene each contains. The 
# results are then listed in tabular form and a text document ranking the 
# proteomes by HSP70 content is produced. 

# Adjustments to the code may be necessary depending on the user's 
# file and directory organization.

# Usage: bash bioinformatics_project2019.sh <GENE_1> <GENE_2> <Proteome_Directory>
# Example: bash bioinformatics_project2019.sh mcrA hsp70 proteomes

cat ref_sequences/$1*.fasta >> $1.refs
cat ref_sequences/$2*.fasta >> $2.refs

# The above lines make cumulative .refs files containing all reference
# sequences for the mcrA and hsp70 genes, respectively.

./muscle -in $1.refs -out $1alignment.msa
./muscle -in $2.refs -out $2alignment.msa

# The above two lines generate .msa files with the sequence alignments for the
# mcrA and hsp70 genes, respectively.

./hmmbuild $1.hmm $1alignment.msa
./hmmbuild $2.hmm $2alignment.msa

# The above two lines make hidden Markov models for mcrA and hsp70 in the form
# of .hmm files.

mkdir $1_search_results
for file in $3/*
do
a=$( echo $file | cut -d . -f 1 | cut -d / -f 2 )
./hmmsearch $1.hmm $file > $a.out
mv $a.out $1_search_results
done

# The above for-loop searches each proteome fasta file for the mcrA sequence and
# saves the search results to a uniquely named file in a directory called 
# mcrA_search_results.
