#########################################################
# SHINYAPP TEMPLATE * MULTIPLE DIRS * CHARTS - ui_plt.R #
#########################################################

tabPanel('CHARTS', icon = icon('palette'),

# SIDEBAR PANEL -----------------------------------------------------
	sidebarPanel(


	    
		width = 2

	),
# 
# # MAIN PANEL --------------------------------------------------------------------------------------------------------------------
	mainPanel(
	    
        tabsetPanel(id = 'tabs_plt',

            # UNI-VARIATE
            tabPanel('barplot', icon = icon('bar-chart'),
                htmlOutput('out_plt_brx'), 
                withSpinner( ggiraphOutput('out_plt_brp', width = "100%", height = "600px") )
            ),
            tabPanel('boxplot', icon = icon('object-align-vertical', lib = 'glyphicon'),
                htmlOutput('out_plt_bxx'), 
                withSpinner( bpexploderOutput('out_plt_bxp') )
            ),
            tabPanel('histogram', icon = icon('area-chart'),
                htmlOutput('out_plt_hsx'), 
                withSpinner( ggiraphOutput('out_plt_hst') )
            ),
            tabPanel('ridges', icon = icon('water'),
                htmlOutput('out_plt_rdx'), 
                withSpinner( ggiraphOutput('out_plt_rdg') )
            ),
            tabPanel('time', icon = icon('chart-line'),
                htmlOutput('out_plt_tmx'), 
                withSpinner( ggiraphOutput('out_plt_tms') )
            ),

            # BI-VARIATE
            tabPanel('scatterplot', icon = icon('braille'),
                htmlOutput('out_plt_scx'), 
                withSpinner( ggiraphOutput('out_plt_scp', width = "100%", height = "800px") )
            ),
            tabPanel('hexbin', icon = icon('connectdevelop'),
                htmlOutput('out_plt_hxx'), 
                withSpinner( ggiraphOutput('out_plt_hxb', width = "100%", height = "800px") )
            ),
            tabPanel('pyramid', icon = icon('align-center'),
                htmlOutput('out_plt_pyx'), 
                withSpinner( ggiraphOutput('out_plt_pyr') )
            ),

            # ADVANCED
            tabPanel('parallel', icon = icon('outdent'),  # sliders-h
                htmlOutput('out_plt_prx'), 
                withSpinner( ggiraphOutput('out_plt_prl') )
            )

        )
        
	)

)
