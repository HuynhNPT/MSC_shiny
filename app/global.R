library(shiny)
library(ggplot2)
library(RColorBrewer)
library(Matrix)
library(shinythemes)
library(cowplot)
library(plyr)

options(shiny.port = 1222)
options(stringsAsFactors = FALSE)
# new app title
app.title <- "Chondrogenesis Expression Database"

# Messages
msg.no.data <- "No data for gene %s"
msg.select.gene <- "Please select a gene."
msg.select.isoform <- "Please select an isoform."

# Import necessary data for the UI to work.
# contains:
#  - name2id: Convert betweeng gene name and gene ID 
#  - tpm_: TPM on the gene and transcript level 
#  - sampleTable: to help with ggplot plotting 
load("./database/preload.RData")

