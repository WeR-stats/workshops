################################################
# SHINYAPP TEMPLATE * MULTIPLE DIRS * server.R #
################################################

shinyServer(function(input, output, session) {

	# HOME (hme) -------------------------------------------------------
	# source(file.path("server", "srv_hme.R"),  local = TRUE)$value

	# LOGIN (lgn) ------------------------------------------------------
	# source(file.path("server", "srv_lgn.R"),  local = TRUE)$value

	# TABLES (tbl) -----------------------------------------------------
	source(file.path("server", "srv_tbl.R"),  local = TRUE)$value

	# CHARTS (plt) -----------------------------------------------------
	source(file.path("server", "srv_plt.R"),  local = TRUE)$value

	# MAPS (mps) -------------------------------------------------------
	source(file.path("server", "srv_mps.R"),  local = TRUE)$value

	# MODELS (mdl) -----------------------------------------------------
	# source(file.path("server", "srv_mdl.R"),  local = TRUE)$value

	# PREDICTION / FORECAST (prd) --------------------------------------
	# source(file.path("server", "srv_prd.R"),  local = TRUE)$value

	# HELP () ----------------------------------------------------------
	# source(file.path("server", "srv_hlp.R"),  local = TRUE)$value

	# ABOUT / CREDITS () -----------------------------------------------
	# source(file.path("server", "srv_crd.R"),  local = TRUE)$value

})
