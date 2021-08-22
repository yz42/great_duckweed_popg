library(Gviz)
library(stringr)
#install.packages(c("foreach","doParallel"))
#install.packages('vcfR')
#BiocManager::install(version = '3.13',"BSgenome")
#BiocManager::install(version = '3.13',"Biostrings")
library(Biostrings)
library(BSgenome)
library(rtracklayer)

library(GenomicRanges)

#parallelization calculations
library(foreach)
library(doParallel)


library(vcfR)
library(ape)

setwd('E:/sciebo/PopulationGenomics_duckweed/alignment_visulization')


#######################################setting ideogramTrack for SP2.0 ref
SP_genome <- read.table("SP_combined.fasta.genome.txt", stringsAsFactors = F)
SP_genome$V3 <- SP_genome$V2
SP_genome$V2 <- 0
SP_genome$V4 <- NA
SP_genome$V5 <- "gneg"
names(SP_genome) <- c("chrom", "chromStart", "chromEnd", "name" ,"gieStain")
options(ucscChromosomeNames=FALSE)

idTrack <- IdeogramTrack(chromosome = "ChrS07", genome="SP2.0", bands=SP_genome)
idTrack <- IdeogramTrack(chromosome = "ChrS20", genome="SP2.0", bands=SP_genome)
idTrack <- IdeogramTrack(chromosome = "JN160603.2", genome="SP2.0", bands=SP_genome)

#######################################test GRanges 
options(ucscChromosomeNames=FALSE) ## very important when using customized ref genome
#gr <- GRanges(seqnames = "JN160603.2", ranges = IRanges(start = c(350,6000,7500), width = c(100,1000, 500)))
gr <- GRanges(seqnames = "JN160603.2", ranges = IRanges(start = 200, width = 101),mcols=test_df$V3)

gr <- makeGRangesFromDataFrame(data.frame(chr=test_df[1,1], start=test_df$V2 -1,end=test_df$V2,score=test_df$V3,GC = seq(1, 0, length=101)),keep.extra.columns=T)


gr <- GRanges(
  seqnames = Rle(c("chr1", "chr2", "chr1", "chr3"), c(1, 3, 2, 4)),
  ranges = IRanges(101:110, end = 111:120, names = head(letters, 10)),
  strand = Rle(strand(c("-", "+", "*", "+", "-")), c(1, 2, 2, 3, 2)),
  score = 1:10,
  GC = seq(1, 0, length=10))


atrack <- AnnotationTrack(gr, name = "test")
gtrack <- GenomeAxisTrack()

#plotTracks(list(idTrack, gtrack, atrack))

data(twoGroups)
dTrack <- DataTrack(gr, name = "depth")
plotTracks(dTrack, type = "a")
plotTracks(dTrack)

#######################################reading clonal family info
raw_clonal_family <- read.table("e:/sciebo/PopulationGenomics_duckweed/alignment_visulization/family_info.txt",comment.char = "")
clonal_family <- raw_clonal_family
colnames(clonal_family) <- as.vector(unlist(raw_clonal_family[1,]))
clonal_family <- clonal_family[-1,]

#######################################dealing with depth file according sample list
genome_len <- read.table("SP_combined.fasta.genome.txt", stringsAsFactors = F)
colnames(genome_len) <- c("chr","size")
sum_l=0
genome_len$sum_line <- NA
for (l in c(2:24)){
  genome_len[l-1,"sum_line"]=sum_l
  sum_l=sum_l + genome_len[l-1,"size"]
}
#sum(genome_len$size) #145661679
rownames(genome_len) <- genome_len$chr

extract_depth <- function(g_l,f_l,smp,chr,c_start,c_end){
  if (c_start >= c_end){
    s=c_end 
    e=c_start
  } else {
    s=c_start
    e=c_end
  }
  file_start=g_l[chr,"sum_line"] + s
  file_end=g_l[chr,"sum_line"] + e
  len=file_end-file_start+1
  #dp_df <- read.table(file, skip = file_start-1, nrow = len, stringsAsFactors = F)
  file <- f_l[toupper(smp),"file"]
  dp_df <- read.table(file, skip = file_start-1, nrow = len, stringsAsFactors = F)
  #print(c(file_start,file_end,len))
  
  return(dp_df)
}

#test_df <- extract_depth(genome_len,file_list,"Sp007.bed.calc_dp.output.dat.fix","ChrS20",1000,2000)

#raw_file_list<- read.table("/scratch/tmp/ywang1/01.duckweed/popgenomics/BAM/calc_dp.callable.split1000/calc_dp.output/228.bed.fix.list", stringsAsFactors = F)
raw_file_list<- read.table("e:/project/02.duckweed_popg/alignment_visulization/228.fix.dp.test.list", stringsAsFactors = F)
file_list <-raw_file_list
colnames(file_list) <- "file"

smp_v <- ""
for (file in raw_file_list[,1]){
  #file <- file_list[1,1]
  smp <- str_match(file, ".+/([^\\.]+)\\.[^/]+$")[[2]]
  smp_v <- c(smp_v,smp)
}

smp_v <- smp_v[-which(smp_v=="")]
smp_v <- gsub("Toronto-", "", smp_v)
smp_v <- toupper(smp_v)
file_list$smp_id <- smp_v


file_v <- ""
for (smp in clonal_family$Sample_ID){
  file_v <- c(file_v, file_list[file_list$smp_id==smp,"file"])
}
file_v <- file_v[-which(file_v=="")]

rownames(file_list) <- file_list$smp_id

file_list$file <- gsub("/home/wangyz","e:",file_list$file) 

#######################################test parallelization of reading in depth files
#test_df <- extract_depth(genome_len,file_list,"Sp004","JN160603.2",200,300)
cl <- makeCluster(6)
registerDoParallel(cl)

smp_list=c("")
# 并行计算方式
x <- foreach(x=1:1000,.combine='rbind') %dopar% func(x)
#别忘了结束并行
stopCluster(cl)


#######################################a glance at VCF file produced by lumpy
vcf <- read.vcfR( "e:/project/02.duckweed_popg/alignment_visulization/228.joint.smoove.square.nuc_nopseudo.vcf", verbose = FALSE )
dna <- ape::read.dna("e:/project/02.duckweed_popg/anno/SP2.0_anno/SP2.0.fa", format = "fasta")
gff <- read.table("e:/project/02.duckweed_popg/anno/SP2.0_anno/SP2.0.gff", sep="\t", quote="")
chrom <- create.chromR(name='chr20_sv', vcf=vcf, seq=dna, ann=gff)
extract.gt(chrom, element="GT", as.numeric=F)[,"Sp014"]
extract.gt(chrom, element="GT", as.numeric=F)["28829",]

# queryMETA(chr20_vcf)
# chr20_vcf@gt[,"Sp014"]
# getFIX(chr20_vcf)[1,]

#######################################build a BSgenome obj for S. polyrhiza
SP_genome_seqs <- Biostrings::readDNAStringSet("e:/project/02.duckweed_popg/anno/SP2.0_anno/SP_combined.fasta")
#rtracklayer::export.2bit(SP_genome_seqs, "e:/project/02.duckweed_popg/anno/SP2.0_anno/SP_combined.2bit")
#forgeBSgenomeDataPkg("e:/project/02.duckweed_popg/anno/SP2.0_anno/for_BSgenome/SP_combined.seed")
options(ucscChromosomeNames=FALSE)
t_chr="ChrS20"
sTrack <- SequenceTrack(SP_genome_seqs,chromosome = t_chr)
plotTracks(sTrack, chromosome = t_chr, from = 20000, to = 20050)

#######################################test visualization of bam file
library(Rsamtools)
indexBam("e:/project/02.duckweed_popg/alignment_visulization/Sp014.rmdp.bam") 

bam_file="e:/project/02.duckweed_popg/alignment_visulization/Sp014.rmdp.bam"
bam_file1="e:/project/02.duckweed_popg/alignment_visulization/Sp004.bam.RMDP.bam"

t_start=28829-500
t_len=1397
t_end=28829+1397+500

t_start=24000
t_end=34000

options(ucscChromosomeNames=FALSE)
alTrack <- AlignmentsTrack(bam_file,isPaired = TRUE)
alTrack1 <- AlignmentsTrack(bam_file1,isPaired = TRUE)

plotTracks(c(alTrack,sTrack,idTrack,alTrack1), chromosome = t_chr, from = t_start,to = t_end)
plotTracks(alTrack, chromosome =t_chr, from = t_start, to = t_end)
# ####test
# BiocManager::install("BSgenome.Hsapiens.UCSC.hg19")
# library(BSgenome.Hsapiens.UCSC.hg19)
# sTrack <- SequenceTrack(Hsapiens)
# afrom <- 44945200
# ato <- 44947200
# alTrack <- AlignmentsTrack(
#   system.file(package = "Gviz", "extdata", "snps.bam"), isPaired = TRUE)
# plotTracks(alTrack, chromosome = "chr21", from = afrom, to = ato)

