##############################################################
##############################################################
## Script to load specific data into R
##############################################################
##############################################################
#################----------------------------#################
importRNAseqData <- reactive({
  if (input$gene_name_1 == "") {
    if (input$gene_name_2 == "") {
      return(NULL)
    } else {
      message("Must select gene from 'Choose a gene'")
    }
  }
  
  if (input$gene_name_1 != "" & input$gene_name_2 == "") {
    # First scenario, only the first gene is selected 
    gid <- name2id$gene_id[which(name2id$gene_name == input$gene_name_1)]
    gn <- tpm_gene[gid, ,drop=FALSE]
    gn <- as(gn, "matrix")
    genes_to_plot <- cbind(sampleTable, t(gn))
    # Rename column names 
    colnames(genes_to_plot)[3:ncol(genes_to_plot)] <- paste0("gene_", 1:(ncol(genes_to_plot)-2))
  } else if (input$gene_name_1 != "" & input$gene_name_2 != "") {
    # When both genes are selected
    gid <- c(name2id$gene_id[which(name2id$gene_name == input$gene_name_1)],
             name2id$gene_id[which(name2id$gene_name == input$gene_name_2)]) # Do this to keep them in order
    gn <- tpm_gene[gid, ,drop=FALSE]
    gn <- as(gn, "matrix")
    genes_to_plot <- cbind(sampleTable, t(gn))
    genes_to_plot <- tidyr::gather(genes_to_plot, gene, TPM, 3:4)
    # map back to gene name 
    genes_to_plot$gene <- mapvalues(genes_to_plot$gene, name2id$gene_id, name2id$gene_name, warn_missing = FALSE)
  }
  
  return(genes_to_plot)
})
#################----------------------------#################
# for plot to view details by isoform
importIsoformMeanData <- reactive({
  if(input$gene_name_1 == ""){
    return(NULL)
  }
  # transcripts that map to gene of interest 
  tid <- tx2gene$transcript_id[tx2gene$gene_name == input$gene_name_1]
  tn  <- tpm_tx[tid,,drop=FALSE]
  # remove tx with 0 counts
  to_remove <- apply(tn, 1, sum)
  to_remove <- names(to_remove)[which(to_remove == 0)]
  tid <- tid[!tid %in% to_remove]
  tn  <- tpm_tx[tid,,drop=FALSE]
  tn <- as(tn, "matrix")
  # mean expression by group 
  # add 1e-6 to avoid inf when log2 transformed 
  tn_by_day <- sapply(unique(sampleTable$day), function(lvl) rowMeans(tn[,row.names(sampleTable)[which(sampleTable$day == lvl)]])+1e-6)
  tn_by_day <- tidyr::gather(as.data.frame(tn_by_day), day, tpm, 1:6)
  tn_by_day$transcript <- rep(tid, times = 6)
  return(tn_by_day)
})
