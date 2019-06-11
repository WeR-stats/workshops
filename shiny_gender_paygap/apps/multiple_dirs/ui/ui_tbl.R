#########################################################
# SHINYAPP TEMPLATE * MULTIPLE DIRS * TABLES - ui_tbl.R #
#########################################################

tabPanel('TABLES', icon = icon('table'),

# SIDEBAR PANEL -----------------------------------------------------
	sidebarPanel(


	    
		width = 2

	),
# 
# # MAIN PANEL --------------------------------------------------------------------------------------------------------------------
	mainPanel(
	    
        tabsetPanel(id = 'tabs_tbl',

            tabPanel('tbl_uni', icon = icon('th-list'),
                htmlOutput('out_tbl_brx'), 
                withSpinner( ggiraphOutput('out_tbl_brp', width = "100%", height = "600px") )
            ),
            
            tabPanel('mosaic', icon = icon('th'),
                htmlOutput('out_tbl_msx'), 
                withSpinner( ggiraphOutput('out_tbl_msc') )
            ),

            tabPanel('pivot', icon = icon('cubes'),
                htmlOutput('out_tbl_pvx'), 
                withSpinner( ggiraphOutput('out_tbl_pvt') )
            )

        )
        
	)

)
