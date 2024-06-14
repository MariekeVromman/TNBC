# open Docker image with bedtools
docker pull pegi3s/bedtools

docker run -v ${PWD}:/usr/exp -it --entrypoint /bin/bash pegi3s/bedtools

# get exons, first in R

bedtools sort -i 01_exons.bed > 02_exons.sorted.bed
bedtools merge -c 4,5,6 -o collapse -s -i 02_exons.sorted.bed > 03_exons.sorted.merged.bed

# get introns with R

bedtools sort -i 04_introns.bed > 05_introns.sorted.bed
bedtools merge -c 4,5,6 -o collapse -s -i 05_introns.sorted.bed > 06_introns.sorted.merged.bed

# clean with R

# remove exons from introns
bedtools intersect -s -v -a 06_introns.cleaned.bed -b 03_exons.cleaned.bed > 07_introns.filtered.bed


# intergenics
# follow https://www.biostars.org/p/112251/#314840

cat gencode.v44.chr_patch_hapl_scaff.annotation.chr.gtf | awk '$1 ~ /^#/ {print $0;next} {print $0 | "sort -k1,1 -k4,4n -k5,5n"}' > 09_in_sorted.gff


grep -v '+' 09_in_sorted.gff | bedtools complement -i stdin -g 08_chromSizes.txt | sed 's/$/\t-/' > 11_intergenic.bed
grep '+' 09_in_sorted.gff | bedtools complement -i stdin -g 08_chromSizes.txt | sed 's/$/\t+/' >> 11_intergenic.bed

bedtools sort -i 11_intergenic.bed > 12_intergenic.sorted.bed

# clean up in R and merge

bedtools merge -c 4,5,6 -o collapse -s -i 12_intergenic.cleaned.bed > 13_intergenic.sorted.merged.bed

remove intron and exons!!
bedtools intersect -s -v -a 13_intergenic.sorted.merged.bed -b 03_exons.cleaned.bed > 14_intergenic.filtered1.bed
bedtools intersect -s -v -a 14_intergenic.filtered1.bed -b 07_introns.filtered.bed > 15_intergenic.filtered.bed



# finish
cat 03_exons.cleaned.bed 07_introns.filtered.bed 15_intergenic.filtered.bed > 16_all.bed
bedtools sort -i 16_all.bed > 17_all.sorted.bed

# bed to gtf