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

for file in $1_search_results/*
do
b=$( cat $file | grep -E "No hits detected" )
echo $file $b | grep -vE "No" | cut -d . -f 1 | cut -d / -f 2 >> candidate_proteomes.txt
done

# The above for-loop identifies all proteomes containing the mcrA protein and
# saves the names of those proteomes to a text file called
# candidate_proteomes.txt.

mkdir $2_search_results
d=$( cat candidate_proteomes.txt )
for file in $d
do
./hmmsearch $2.hmm $3/$file.fasta > $2_search_results/$file.out
done

# The above for-loop takes the proteome files that contain the code for the 
# mcrA protein and searches then for the hsp70 protein. The results are
# saved as .out files in a directory called hsp70_search_results.

echo "hsp70_copies,proteome" >> proteome_hsp70_rankings.txt
for file in $2_search_results/*
do
e=$( cat $file | grep -E ">>" | wc -l )
f=$( echo $file | cut -d . -f 1 | cut -d / -f 2 )
echo "$e,$f" >> proteome_hsp70_counts.txt
done
cat proteome_hsp70_counts.txt | sort -n -r | uniq >> proteome_hsp70_rankings.txt
cat proteome_hsp70_rankings.txt | cut -d , -f 2 | grep -E "_" > proposed_proteomes.txt
cat proteome_hsp70_rankings.txt

# The above for-loop finds the number of hsp70 copies in each mcrA+ proteome
# and lists the proteome and hsp70 copy number in a tabular format with 
# columns separated by columns. This table is then printed to the display.

# The following lines delete all extra files produced by this script
# during its operation. If one desires to keep those files, these lines
# should be removed are marked with # so they are ignored. 

rm -r hsp70*
rm -r mcrA*
rm candidate_proteomes.txt
rm prot*.txt
