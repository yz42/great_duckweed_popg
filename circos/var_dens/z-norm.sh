awk 'BEGIN {
   FS=OFS="\t"
}
NR == FNR {
   ++n
   for(i=4;i<=NF;i++) {
      sum[i] += $i
      sumsq[i] += ($i)^2
   }
   next
}
FNR == 1 { # compute mean and std values here
   for (i=4;i<=NF;i++) {
      mean[i] = sum[i]/n
      std[i] = sqrt( (sumsq[i] - sum[i]^2/n) / (n-1) )
   }
}
{
   printf "%s", $1 OFS
   for (i=4;i<=NF;i++)
      printf "%f%s", ($i - mean[i]) / std[i], (i < NF ? OFS : ORS)
}' $1 $1 | column -t > $1.z-norm