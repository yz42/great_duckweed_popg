module load lang/Python/2.7.18-GCCcore-11.2.0
/home/ywang/software/LASSI/LASSI_program_071019


ml bio/BCFtools/1.14-GCC-11.2.0
bcftools view -S 159_samp.list SP_228.basic_set.snp.recode.rm_cluster3-10.vcf.PASS.vcf -o 159.samp.vcf

ml bio/tabixpp/1.1.0-GCC-11.2.0
bgzip 159.samp.vcf ; tabix -p vcf 159.samp.vcf.gz
gunzip -c 159.samp.vcf.gz > 159.samp.vcf

head -n 400 159.samp.vcf  | grep "#" > 159.samp.vcf.head
bedtools intersect -v -a 159.samp.vcf -b discarded.1KB_5KB.sorted.merged.f.bed -wa > 159.samp.filtered.vcf

cat 159.samp.vcf.head  159.samp.filtered.vcf > 159.samp.filtered.head.vcf

#chr="ChrS20"
#bcftools view -Oz -o $chr.159.samp.vcf.gz -r $chr  159.samp.vcf.gz
bgzip 159.samp.filtered.head.vcf ; tabix -p vcf 159.samp.filtered.head.vcf.gz

############################################00.run lassi at species-wide

cd /lustre/project/m2_jgu-evoltroph/ywang/02.popg_duckweed/selection_scan_LASSI/combine4pop_as_one
 sed 's/AME/Sp/' ../4pop_159samp.tab.txt | sed 's/EUR/Sp/' | sed 's/IND/Sp/' | sed 's/ASIA/Sp/' > species-wide_159samp.tab.txt

for i in $(seq -w 01 20); do chr="ChrS$i" ; mkdir -p ./$chr/; lassip --vcf ../$chr/$chr.159.samp.vcf.gz --calc-spec --hapstats --lassi --winsize 50 --winstep 5 --k 10 --out ./$chr/$chr --unphased --pop species-wide_159samp.tab.txt --threads 4 ; done


rm  02.run_lassi.sh ; r="Sp"; for j in $r; do string=""; for i in $(seq -w 01 20); do chr="ChrS$i"; string+=" ./$chr/$chr.$j.lassip.mlg.spectra.gz "; done; echo "lassip --spectra $string  --lassi --out $j.lassi" >> 02.run_lassi.sh ; done

sh 02.run_lassi.sh

###extract top 0.01 windows for species-wide analysis, merge each bed file
ml bio/BEDTools/2.29.2-iccifort-2020.1.217
th="0.01"
i="Sp"
sh cvt_lassi_bed.sh $i.lassi.lassip.mlg.out.gz $th ;bedtools sort -i top_$th.$i.lassi.lassip.mlg.out.gz.bed > top_$th.$i.lassi.bed ; bedtools merge -d 5000 -i top_$th.$i.lassi.bed -c 4,5 -o min,mean >top_$th.$i.lassi.merged.bed ; rm top_$th.$i.lassi.lassip.mlg.out.gz.bed top_$th.$i.lassi.bed


###to find genes overlapped with the top 5% peaks from LASSI, 1% from each of RAISD and SWEED
cd /lustre/project/m2_jgu-evoltroph/ywang/02.popg_duckweed/selection_scan_LASSI/combine4pop_as_one/check_top0.05_venn_from3selection_methods

ml bio/BEDTools/2.29.2-iccifort-2020.1.217

#bed list:
#RAiSD_top1percent.bed
#SweeD_top1percent.bed
#top_0.05.Sp.lassi.merged.bed

for i in `cat bed.list`; do file=$(basename $i); bedtools intersect -a $i -b SpGA2022.genes.gff3 -wo 1> ${file}_ovlp_with_SpGA2022.genes.out 2> ${file}_ovlp_with_SpGA2022.genes.err ;  grep -oP "SpGA2022_\d+" ${file}_ovlp_with_SpGA2022.genes.out |  sort | uniq | cat > ${file}_ovlp_with_SpGA2022.genes.uniq.list ; done


#################plot venn diagram
ml lang/R/4.2.0-foss-2021b

Rscript /lustre/miifs01/project/m2_jgu-evoltroph/ywang/02.popg_duckweed/selection_scan_LASSI/combine4pop_as_one/plot_VENN.R


################to plot SFS
#http://hawaiireedlab.com/wpress/?p=1115
#https://eriqande.github.io/coalescent-hands-on/004-one-dimensional-SFS.nb.html
#https://github.com/shenglin-liu/vcf2sfs


cd /lustre/project/m2_jgu-evoltroph/ywang/02.popg_duckweed/selection_scan_LASSI/combine4pop_as_one

rm 69_genes.SpGA2022.genes.gff3; for i in `cat overlap_among_three.005L001SR.list`; do grep $i SpGA2022.genes.gff3 >> 69_genes.SpGA2022.genes.gff3 ; done

cd /lustre/project/m2_jgu-evoltroph/ywang/02.popg_duckweed/selection_scan_LASSI/combine4pop_as_one/to_find_69_Genes_peaks

ml bio/BEDTools/2.29.2-iccifort-2020.1.217
bedtools intersect -a top_0.05.Sp.lassi.merged.bed -b 69_genes.SpGA2022.genes.gff3 -wa | uniq  > 69_genes.top_0.05.Sp.lassi.merged.bed

######index each VCF
cd /lustre/project/m2_jgu-evoltroph/ywang/02.popg_duckweed/selection_scan_LASSI
dir="/lustre/project/m2_jgu-evoltroph/ywang/02.popg_duckweed/selection_scan_LASSI" ;  for i in `seq -w 01 20` ; do j="ChrS$i"; echo $j ; cd "$dir/$j/"; tabix -p vcf $j.159.samp.vcf.gz ; done

######extract SNPs from 69 gene peaks
cd /lustre/project/m2_jgu-evoltroph/ywang/02.popg_duckweed/selection_scan_LASSI/combine4pop_as_one/to_find_69_Genes_peaks
ml bio/BCFtools/1.14-GCC-11.2.0

for i in `awk '{print $1}' 69_genes.top_0.05.Sp.lassi.merged.bed | uniq` ; do grep  $i 69_genes.top_0.05.Sp.lassi.merged.bed > $i.69_genes.top_0.05.Sp.lassi.merged.bed ; bcftools view -R $i.69_genes.top_0.05.Sp.lassi.merged.bed ../../$i/$i.159.samp.vcf.gz >  $i.69_genes.top_0.05.Sp.lassi.merged.vcf ; done

ls *.vcf > vcf.list ; bcftools concat -f vcf.list -Ov -o all_chr.69_genes.top_0.05.Sp.lassi.merged.vcf


#########to exlude selection peaks from genome-wide
cd /lustre/project/m2_jgu-evoltroph/ywang/02.popg_duckweed/selection_scan_LASSI/combine4pop_as_one/to_exclude_selection_peaks_from_genome-wide

awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$5}' top_0.05.Sp.lassi.merged.bed > top_0.05.Sp.lassi.merged.fixed.bed
cat SweeD_top1percent.bed RAiSD_top1percent.bed top_0.05.Sp.lassi.merged.fixed.bed | sort -k1,1 -k2,2n > L005SR001_combined.bed

bedtools merge -i L005SR001_combined.bed > L005SR001_combined.merged.bed

awk 'BEGIN{OFS="\t"}{print $1,0,$2}' SP_combined.fasta.gz.fai.fixed > SP_combined.fasta.gz.fai.fixed.bed

bedtools subtract  -a SP_combined.fasta.gz.fai.fixed.bed -b L005SR001_combined.merged.bed > no_selection_reiongs.L005SR001_combined.merged.bed


ml bio/BCFtools/1.14-GCC-11.2.0

bcftools view -Ov -R no_selection_reiongs.L005SR001_combined.merged.bed /lustre/miifs01/project/m2_jgu-evoltroph/ywang/02.popg_duckweed/selection_scan_LASSI/159.samp.filtered.head.vcf.gz >  no_selection_reiongs.159.samp.filtered.head.vcf







#############################################01.run lassi at population level

ml bio/BCFtools/1.14-GCC-11.2.0
for i in $(seq -w 1 20); do
  chr="ChrS$i"
  echo $chr
  mkdir -p ./$chr/
  bcftools view -Oz -o ./$chr/$chr.159.samp.vcf.gz -r $chr   159.samp.filtered.head.vcf.gz
done


###run lassi selection scan
for i in $(seq -w 01 20); do chr="ChrS$i" ; lassip --vcf ./$chr/$chr.159.samp.vcf.gz --calc-spec --hapstats --lassi --winsize 50 --winstep 5 --k 10 --out ./$chr/$chr --unphased --pop 4pop_159samp.tab.txt --threads 4 ; done


rm  02.run_lassi.sh ; r="AME IND ASIA EUR"; for j in $r; do string=""; for i in $(seq -w 01 20); do chr="ChrS$i"; string+=" ./$chr/$chr.$j.lassip.mlg.spectra.gz "; done; echo "lassip --spectra $string  --lassi --out $j.lassi" >> 02.run_lassi.sh ; done

sh 02.run_lassi.sh


###extract top 0.01 windows, merge each bed file
ml bio/BEDTools/2.29.2-iccifort-2020.1.217
th="0.01"
for i in "AME" "ASIA" "EUR" "IND"; do sh cvt_lassi_bed.sh $i.lassi.lassip.mlg.out.gz $th ;bedtools sort -i top_$th.$i.lassi.lassip.mlg.out.gz.bed > top_$th.$i.lassi.bed ; bedtools merge  -d 5000 -i top_$th.$i.lassi.bed -c 4,5 -o min,mean >top_$th.$i.lassi.merged.bed ; rm top_$th.$i.lassi.lassip.mlg.out.gz.bed top_$th.$i.lassi.bed ; done

###extract top 0.001 windows, merge each bed file
ml bio/BEDTools/2.29.2-iccifort-2020.1.217
th="0.001"
for i in "AME" "ASIA" "EUR" "IND"; do sh cvt_lassi_bed.sh $i.lassi.lassip.mlg.out.gz $th ;bedtools sort -i top_$th.$i.lassi.lassip.mlg.out.gz.bed > top_$th.$i.lassi.bed ; bedtools merge -d 5000 -i top_$th.$i.lassi.bed -c 4,5 -o min,mean >top_$th.$i.lassi.merged.bed ; rm top_$th.$i.lassi.lassip.mlg.out.gz.bed top_$th.$i.lassi.bed ; done

###extract top 0.05 windows for species-wide analysis, merge each bed file
ml bio/BEDTools/2.29.2-iccifort-2020.1.217
th="0.05"
i="Sp"
sh cvt_lassi_bed.sh $i.lassi.lassip.mlg.out.gz $th ;bedtools sort -i top_$th.$i.lassi.lassip.mlg.out.gz.bed > top_$th.$i.lassi.bed ; bedtools merge -d 5000 -i top_$th.$i.lassi.bed -c 4,5 -o min,mean >top_$th.$i.lassi.merged.bed ; rm top_$th.$i.lassi.lassip.mlg.out.gz.bed top_$th.$i.lassi.bed

##############dealing with pair-wise comprisons

strings=("AME" "ASIA" "EUR" "IND")
th="0.01"
for ((i=0; i<${#strings[@]}-1; i++)); do for ((j=i+1; j<${#strings[@]}; j++)); do  bedtools intersect -a top_$th.${strings[i]}.lassi.merged.bed -b top_$th.${strings[j]}.lassi.merged.bed -wo > top_$th.${strings[i]}_${strings[j]}.intsect.out  ;done ; done

th="0.001"
for ((i=0; i<${#strings[@]}-1; i++)); do for ((j=i+1; j<${#strings[@]}; j++)); do  bedtools intersect -a top_$th.${strings[i]}.lassi.merged.bed -b top_$th.${strings[j]}.lassi.merged.bed -wo > top_$th.${strings[i]}_${strings[j]}.intsect.out  ;done ; done

##############for comparison between LASSI and RAISD or SWEED
cd /lustre/project/m2_jgu-evoltroph/ywang/02.popg_duckweed/selection_scan_LASSI/comp_RAISD_LASSI
tail -n +2 RAiSD_Report.allChroms_AME_forR_top01percent | awk 'BEGIN{OFS="\t"}{print $1, $3,$4,$8}' | cat > RAiSD_Report.allChroms_AME_forR_top01percent.bed

bedtools merge -i RAiSD_Report.allChroms_AME_forR_top01percent.bed -c 4 -o mean > RAiSD_Report.allChroms_AME_forR_top01percent.merged.bed

wc -l RAiSD_Report.allChroms_AME_forR_top01percent.merged.bed
wc -l ../top_0.01.AME.lassi.merged.bed

#bedtools intersect -a RAiSD_Report.allChroms_AME_forR_top01percent.merged.bed -b ../top_0.001.AME.lassi.merged.bed -wo > comp_LASSI_RAISD_AME.txt

#sort ../top_0.05.Sp.lassi.gene.list | uniq | cat > top_0.05.Sp.lassi.gene.uniq.list 







#################remove missing data and generate per chromosome VCF (for input of SWEED)

module load bio/VCFtools/0.1.16-GCC-11.2.0
for i in $(seq -w 1 20); do
  chr="ChrS$i"
  echo $chr
  vcftools --gzvcf ./$chr/$chr.159.samp.vcf.gz --max-missing 1.0  --remove-filtered-all --recode --stdout | gzip -c > ./CHR_VCF_without_MISSING/$chr.159.samp.0missing.vcf.gz
done