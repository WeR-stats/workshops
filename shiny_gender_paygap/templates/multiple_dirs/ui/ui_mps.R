#######################################################
# SHINYAPP TEMPLATE * MULTIPLE DIRS * MAPS - ui_mps.R #
#######################################################

tabPanel('MAPS', icon = icon('globe'),

# SIDEBAR PANEL -----------------------------------------------------
	sidebarPanel(


	    
		width = 2

	),
# 
# # MAIN PANEL --------------------------------------------------------------------------------------------------------------------
	mainPanel(
	    
        tabsetPanel(id = 'tabs_mps',

            tabPanel('dotmap', icon = icon('map-marked-alt'),
                htmlOutput('out_mps_dmp'), 
                withSpinner( leafletOutput('out_mps_dmp') )
            ),
            
            tabPanel('choroplet', icon = icon('draw-polygon'),
                htmlOutput('out_mps_thm'), 
                withSpinner( leafletOutput('out_mps_thm') )
            ),
            
            tabPanel('hexgrid', icon = icon('first-order'),
                htmlOutput('out_mps_hgd'), 
                withSpinner( leafletOutput('out_mps_hgd') )
            )

        )
        
	)

)
