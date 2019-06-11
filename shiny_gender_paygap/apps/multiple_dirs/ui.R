############################################
# SHINYAPP TEMPLATE * MULTIPLE DIRS * ui.R #
############################################

shinyUI(fluidPage(
    
    includeCSS('www/styles.css'),
#    includeScript('wer.js'),
    tags$head(
        tags$link(rel="shortcut icon", href="favicon.ico")
    ),
    
    navbarPageWithText(
        header = '',
        title = HTML('
            <div>
                <img src="logo_white.png" class="logo">
                <span class = "title">UK Gender Pay Gap</span>
            </div>
        '),
        windowTitle = 'UK Gender Pay Gap', 
        id = 'mainNav',
        theme = shinytheme('united'), inverse = TRUE,
        
        # HOME (hme) ------------------------------------------------
        source(file.path("ui", "ui_hme.R"),  local = TRUE)$value,
        
        # LOG IN (lgn) ----------------------------------------------
        source(file.path("ui", "ui_lgn.R"),  local = TRUE)$value,
        
        # TABLES (tbl) ----------------------------------------------
        source(file.path("ui", "ui_tbl.R"),  local = TRUE)$value,

        # CHARTS (plt) ----------------------------------------------
        source(file.path("ui", "ui_plt.R"),  local = TRUE)$value,

        # MAPS (mps) ------------------------------------------------
        source(file.path("ui", "ui_mps.R"),  local = TRUE)$value,

        # MODELS (mdl) ----------------------------------------------
        # source(file.path("ui", "ui_mdl.R"),  local = TRUE)$value,

        # PREDICTION / FORECAST (prd) -------------------------------
        # source(file.path("ui", "ui_prd.R"),  local = TRUE)$value,

        # HELP ------------------------------------------------------
        # source(file.path("ui", "ui_hlp.R"),  local = TRUE)$value,

        # ABOUT / CREDITS--------------------------------------------
#        source(file.path("ui", "ui_crd.R"),  local = TRUE)$value,

        # COPYRIGHT / LAST UPDATED AT -------------------------------
        text = '@2019 WeR meetup'  # paste('Last updated:', format(last_updated, '%d %b %Y') )

    ),

    useShinyjs()

))
