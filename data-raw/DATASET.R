# Code to create example data -------------------------------------------------------------

# Load example data from Bouzid et al. 2022 (DOI: 10.1111/mec.15836)
liz_coords <- read_tsv("inst/extdata/coords.txt", col_names = c("x", "y"))
liz_vcf <- read.vcfR("inst/extdata/populations_r20.haplotypes.filtered_m70_randomSNP.vcf")

# Create data objects
usethis::use_data(liz_coords, overwrite = TRUE)
usethis::use_data(liz_vcf, overwrite = TRUE)
