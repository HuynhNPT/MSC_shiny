server <-	function(input, output, session) {
  updateSelectizeInput(session, inputId = "gene_name_1", choices = name2id$gene_name,
                       selected = "COL2A1", server = TRUE)
  updateSelectizeInput(session, inputId = "gene_name_2", choices = name2id$gene_name,
                       selected = "ACAN", server = TRUE)
  source("./R/load_data.R", local = TRUE)
  source("./R/plot_rnaseq.R", local = TRUE)
}
