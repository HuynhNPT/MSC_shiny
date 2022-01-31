ui <- fluidPage(
  theme = shinytheme("superhero"),
  titlePanel(title = div(h1(app.title, h5("Tweet ", a(h5("@Guilak_Lab"), href="https://twitter.com/Guilak_Lab")))
  ),
  windowTitle = app.title
  ),
  sidebarPanel(
    width = 3,
    # select gene dropdown
    selectizeInput(inputId = "gene_name_1", label = "Choose a gene", choices = NULL),
    selectizeInput(inputId = "gene_name_2", label = "Choose another gene", choices = NULL),
    # select transcript dropdown
    conditionalPanel(condition = "input.tabselected == 'rnaseq'",
                     br(),
                     p(h6("This dataset records the transcriptomic changes of human mesenchymal stem cells as they undergo chondrogenesis")),
                     br(), 
                     p(h6(strong("Citation:"))),
                     tags$li(a(h6("MSC Chondrogenesis"), 
                                   href = "https://pubmed.ncbi.nlm.nih.gov/29985644/"), 
                                 h6(" from Huynh et al., FASEB, 2019")),
                     br(),
                     p(h6("Created and maintained by "), a("@HuynhNPT", href="https://github.com/HuynhNPT")),
                     br(), 
                     p(a("Send feedback by creating an issue on github here", href="https://github.com/HuynhNPT/MSC_shiny"))
                     
    )
  ),
  mainPanel(
    width = 9,
    tabsetPanel(
      # UI for RNA seq tab
      tabPanel("Bulk RNA-Seq", value = 'rnaseq',
               # gene/sample plot
               plotOutput(outputId = "plot_rnaseq_1"),
               br(),
               p(h6("Transcript details are helpful in molecular cloning design:")),
               # mean isoform value heatmap
               uiOutput("plot_rnaseq_2.ui")
      ),
      # UI for sc tab
      tabPanel("scRNA-Seq", value = 'scrnaseq',
               h5("Coming soon...")
      ),
      type = "tabs", id = "tabselected")
  ),
  fluidRow(),
  fluidRow(),
  fluidRow(p(h6("Updated on 2021-11-03")), align="center")
)
