# Covariate plot
rm(list=ls())
suppressPackageStartupMessages(library(here))
suppressPackageStartupMessages(library(factoextra))
suppressPackageStartupMessages(library(ade4))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

dir.create("supp_tables")

mod <- read.table("processing_wgcna/SME_Significant_Genes.txt",header=T,sep="\t")

wgcna <- list(WGCNA = mod)
# Load data for Data Base
CerCort <- load(here("rawdata","geneset", "GeneSets_CerCort.RData")) %>%
            get()

psydge <- load(here("rawdata","geneset","PsychENCODE_DEGs.RData")) %>%
            get()
new_names <- names(psydge)
psydge <- map2(psydge, new_names, ~setnames(.x, 'Class', .y))

psymod <- load(here("rawdata","geneset", "PsychEncode_Modules.RData")) %>%
            get()
new_names <- names(psymod)
psymod <- map2(psymod, new_names, ~setnames(.x, 'Mod', .y))

sfari <- load(here("rawdata","geneset","ASD_SFARI.RData")) %>%
            get()
new_names <- names(sfari)
sfari <- map2(sfari, new_names, ~setnames(.x, 'Class', .y))

smegenes <- load(here("rawdata","geneset","Genes_SMEws.RData")) %>%
            get()
new_names <- names(smegenes)
smegenes <- map2(smegenes, new_names, ~setnames(.x, 'Waves', .y))


l <- c(wgcna,smegenes,CerCort,sfari,psydge,psymod)
res <- Reduce(function(x, y) {
    merge(x, y, all=TRUE, by="Gene")
}, l)

database=res[!(is.na(res$ModuleName)),]
database <- database[!(duplicated(database)),]
xlsx::write.xlsx(database, file="supp_tables/Table_S2.xlsx",sheetName = "WGCNA DB",row.names=FALSE, showNA=FALSE)

# SME genes
mod <- read.table("processing_memory/SME_Significant_Genes.txt",header=T,sep="\t")

wgcna <- list(WGCNA = mod)
# Load data for Data Base
CerCort <- load(here("rawdata","geneset", "GeneSets_CerCort.RData")) %>%
            get()

psydge <- load(here("rawdata","geneset","PsychENCODE_DEGs.RData")) %>%
            get()
new_names <- names(psydge)
psydge <- map2(psydge, new_names, ~setnames(.x, 'Class', .y))

psymod <- load(here("rawdata","geneset", "PsychEncode_Modules.RData")) %>%
            get()
new_names <- names(psymod)
psymod <- map2(psymod, new_names, ~setnames(.x, 'Mod', .y))

sfari <- load(here("rawdata","geneset","ASD_SFARI.RData")) %>%
            get()
new_names <- names(sfari)
sfari <- map2(sfari, new_names, ~setnames(.x, 'Class', .y))


l <- c(wgcna,CerCort,sfari,psydge,psymod)
res <- Reduce(function(x, y) {
    merge(x, y, all=TRUE, by="Gene")
}, l)

database=res[!(is.na(res$Waves)),]
database <- database[!(duplicated(database)),]
xlsx::write.xlsx(database, file="supp_tables/Table_S1.xlsx",sheetName = "SME DB",row.names=FALSE, showNA=FALSE)





