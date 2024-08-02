VCF_url = "https://raw.githubusercontent.com/caravagnalab/CNAqc_datasets/main/MSeq_Set06/Mutations/Set.06.WGS.merged_filtered.vcf"

download.file(VCF_url, "Set.06.WGS.merged_filtered.vcf",)

set6 = vcfR::read.vcfR("Set.06.WGS.merged_filtered.vcf")

file.remove("Set.06.WGS.merged_filtered.vcf")

print(set6)

# INFO fields 
info_tidy = vcfR::extract_info_tidy(set6)
allFields<-vcf_field_names(set6,tag = "INFO")
print(n=25,allFields)

# Fixed fields (genomic coordinates)
fix_tidy = set6@fix %>%
  as_tibble %>%
  rename(
    chr = CHROM,
    from = POS,
    ref = REF,
    alt = ALT
  ) %>%
  mutate(from = as.numeric(from), to = from + nchar(alt))

# Genotypes
geno_tidy = vcfR::extract_gt_tidy(set6) %>%
  group_split(Indiv)

# A list for all samples available
# join genotypes, infofields and fixed part
# 1 df per sample
# with 1 line per variant
# 46 columns in eachsample
sample_mutations = lapply(geno_tidy, function(x) {
  bind_cols(info_tidy, fix_tidy) %>%
    full_join(x, by = "Key") %>%
    mutate(DP = as.numeric(gt_NR), NV = as.numeric(gt_NV)) %>%
    mutate(VAF = NV / DP) %>%
    dplyr::select(chr, from, to, ref, alt, NV, DP, VAF, everything()) %>%
    filter(!is.na(VAF), VAF > 0)
})

# vector with sample names
names(sample_mutations) = sapply(sample_mutations, function(x) x$Indiv[1])
sample_mutations = sample_mutations[!is.na(names(sample_mutations))]
