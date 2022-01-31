##############################################################
##############################################################
## Script to plot bulk RNA-seq data 
##############################################################
##############################################################
#################----------------------------#################
output$plot_rnaseq_1 <- renderPlot({
  # Plot gene1 and gene2 expression with fitted line 
  validate(
    need(input$gene_name_1 != "", message = msg.select.gene)
  )
  
  xy = importRNAseqData()
  
  need(nrow(xy) > 0, message = sprintf(msg.no.data, input$gene_name_1))
  if (input$gene_name_1 != "" & input$gene_name_2 == "") {
    out <- ggplot(xy, aes(x = day, y = gene_1,group=1)) + geom_point() + geom_smooth(method="lm", formula=y~poly(x,3), se = FALSE, color ="#00154f") +
      labs(y = paste0(input$gene_name_1, " (TPM)"), x = "", title=paste0("Gene-level Expression of", input$gene_name_1))+
      theme_classic() + 
      theme(axis.text.x = element_text(angle = 55, hjust = 1), text = element_text(size=16))  
  } else if (input$gene_name_1 != "" & input$gene_name_2 != "") {
    out <- ggplot(xy, aes(x=day,y=TPM,color=gene,group=gene)) + geom_point() + geom_smooth(method = "lm", formula = y~poly(x,3), se= FALSE) + scale_color_manual(values = c("#00154f", "#f4af1b")) +
      labs(x="", title = paste0("Gene-level Expression of ", input$gene_name_1, " and ", input$gene_name_2)) + 
      theme_classic() + 
      theme(axis.text.x = element_text(angle = 55, hjust = 1), text = element_text(size=16))
  }
  out
})
#################----------------------------#################
# heatmap to view mean isoform expression for each sample
output$plot_rnaseq_2 <- renderPlot({
  validate(
    need(input$gene_name_1 != "", message = msg.select.gene)
  )

  xy = importIsoformMeanData()

  need(nrow(xy) > 0, message = sprintf(msg.no.data, input$gene_name_1))

  pal <- colorRampPalette(c("lightgoldenrodyellow", "lightgreen", "green4", "darkgreen"))(300)
  my_sub <- paste0("Transcript with the Highest Expression Level: ", xy$transcript[which.max(xy$tpm)], " on Day ", gsub("day", "", xy$day[which.max(xy$tpm)]))
  out <- ggplot(xy, aes(x = day, y = transcript, fill = tpm))+
    geom_tile() +
    scale_fill_gradientn(colours = pal, name = "log2TPM", trans = "log2")+
    labs(x = "", y = "") +
    theme(axis.text.x = element_text(angle = 55, hjust = 1), panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), text = element_text(size = 16), plot.title=element_text(hjust = 0), plot.subtitle = element_text(hjust=0, size=12))+
    ggtitle(paste0("Mean Transcript-level Expression of ", input$gene_name_1, " by Day"), subtitle = my_sub)
 
  out
})

# build the heatmap with reactive height
output$plot_rnaseq_2.ui <- renderUI({
  plotOutput("plot_rnaseq_2")
})