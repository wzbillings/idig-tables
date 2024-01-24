###
# Table examples for IDIG presentation
# Zane Billings
# 2024-01-22
###

# Setup ####
# Declare dependencies
box::use(
	readr,
	here,
	gt,
	gtExtras,
	gtsummary,
	modelsummary,
	dplyr,
	webshot2,
	tidyr,
	ggplot2,
	Hmisc
)

# Read in the data file
dat <- readr::read_rds(here::here("static", "longwing-data.Rds"))

# Make the collector variable
dat2 <-
	dat |>
	tidyr::separate_wider_delim(
		cols = sample_id,
		names = c(NA, "id", "collector"),
		delim = "_"
	)

# Example 1 ####
# Suppose we want to make a table of the first the butterflies and show their
# exact measurements, not any summary statistics.
t1 <-
	dat |>
	# Get the first three rows
	head(n = 3) |>
	# Select the columns we want to show
	dplyr::select(
		sample_id, wing_length, wing_width, antenna_length, body_length
	) |>
	dplyr::rename_with(
		.fn = stringr::str_to_title
	) |>
	gt::gt()

gt::gtsave(
	data = t1,
	filename = here::here("results", "t1.png"),
	vwidth = 2400,
	vheight = 1350
)

readr::write_rds(t1, here::here("results", "t1.rds"))

# Example 2 ####
# Adding some basic customizations
	
t2 <- 
	dat |>
	# Get the first three rows
	head(n = 3) |>
	# Select the columns we want to show
	dplyr::select(
		sample_id, wing_length, wing_width, antenna_length, body_length
	) |>
	gt::gt(rowname_col = "sample_id") |>
	gt::cols_label(
		wing_length = "Wing Length",
		wing_width = "Wing Width",
		antenna_length = "Antenna Length",
		body_length = "Body Length"
	) |>
	gt::tab_caption(paste(
		"Anatomical measurements (in centimeters) for the first",
		"three samples from the Longwing study."
	))

gt::gtsave(
	data = t2,
	filename = here::here("results", "t2.png"),
	vwidth = 2400,
	vheight = 1350
)

# Add the image column with gtextras
t2b <-
	t2 |>
	gt::cols_add(image = list.files(
		here::here("static"),
		pattern = "longwing.*\\.jpg",
		full.names = TRUE
	)) |>
	gtExtras::gt_img_rows(columns = image, img_source = "local", height = 45) |>
	gtExtras::gt_theme_nytimes()

gt::gtsave(
	data = t2b,
	filename = here::here("results", "t2b.png"),
	vwidth = 2400,
	vheight = 1350
)

# Example 3 ####
# Calculating summary statistics by hand and making a table

# Contingency table by hand
t3 <- table(
	dat2$population, dat2$collector,
	dnn = c("Population", "Collector")
) |>
	addmargins(FUN = list(Overall = sum)) |>
	as.data.frame() |>
	tidyr::pivot_wider(
		names_from = Collector, values_from = Freq
	) |>
	gt::gt(rowname_col = "Population") |>
	gt::tab_stubhead(label = "Population") |>
	gt::tab_spanner(
		label = "Collector",
		columns = -1
	) |>
	gt::tab_style(
		gt::cell_borders(
			sides = c("right", "bottom"),
			color = "lightgray",
			weight = gt::px(2)
		),
		gt::cells_stubhead()
	) |>
	gt::tab_caption(paste(
		"A 2x2 contigency table showing the cell count for all combinations of",
		"butterfly population and collector values, along with marginal counts."
	))

gt::gtsave(
	data = t3,
	filename = here::here("results", "t3.png"),
	vwidth = 2400,
	vheight = 2400
)

# Summary stats by hand
format_ci <- function(df, d = 2) {
	fmt_str <- paste0("%.", d, "f")
	out <- paste0(
		sprintf(fmt_str, df$y), " (",
		sprintf(fmt_str, df$ymin), ", ",
		sprintf(fmt_str, df$ymax), ")"
	)
	
	return(out)
}


t3b <-
	dat2 |>
	dplyr::group_by(population) |>
	dplyr::summarise(
		n = dplyr::n(),
		w = ggplot2::mean_cl_boot(wing_width) |> format_ci(),
		l = ggplot2::mean_cl_boot(wing_length) |> format_ci()
	) |>
	gt::gt(rowname_col = "population") |>
	gt::cols_label(
		w = "Wing width",
		l = "Width length"
	) |>
	gt::tab_footnote(
		footnote = "Mean (95% bootstrap CI; 1000 resamples)",
		locations = gt::cells_column_labels(columns = c(w, l))
	) |>
	gt::tab_caption("Descriptive statistics for wing width and width length.")

gt::gtsave(
	data = t3b,
	filename = here::here("results", "t3b.png"),
	vwidth = 2400,
	vheight = 1350
)

# Example 4 ####
# gtsummary for automatic summary statistics

# Contigency table
t4a <- dat2 |>
	gtsummary::tbl_cross(
		row = population,
		col = collector
	) |>
	gtsummary::modify_caption(paste(
		"A 2x2 contigency table showing the cell count for all combinations of",
		"butterfly population and collector values, along with marginal counts."
	)) |>
	gtsummary::as_gt()

gt::gtsave(
	data = t4a,
	filename = here::here("results", "t4a.png"),
	vwidth = 2400,
	vheight = 2400
)

t4b <-
	dat2 |>
	gtsummary::tbl_summary(
		by = population,
		include = c(wing_length, wing_width, antenna_length, body_length, num_spots,
								age, num_offspring, collector),
		label = list(
			wing_length ~ "Wing length (cm)",
			wing_width ~ "Wing width (cm)",
			antenna_length ~ "Antenna length (cm)",
			body_length ~ "Body length (cm)",
			num_spots ~ "Number of spots",
			age ~ "Age",
			num_offspring ~ "Number of offspring",
			collector ~ "Collector"
		),
		type = list(num_spots ~ "continuous"),
		digits = list(num_spots ~ 0)
	) |>
	gtsummary::add_p() |>
	gtsummary::separate_p_footnotes() |>
	gtsummary::modify_caption(
		"Descriptive statistics for the longwing study."
	) |>
	gtsummary::add_significance_stars() |>
	gtsummary::as_gt()

gt::gtsave(
	data = t4b,
	filename = here::here("results", "t4b.png"),
	vwidth = 2400,
	vheight = 1350
)

t4b |>
	gt::rm_caption() |>
	gt::gtsave(
		filename = here::here("results", "paper-t1.png"),
		vwidth = 2400,
		vheight = 1350
	)

# Example 5: Automatic regression tables ####
dat_reg <- dat2 |>
	dplyr::select(
		wing_length,
		wing_width,
		age,
		antenna_length,
		body_length,
		population,
		id
	)

label_list <- list(
	wing_length ~ "Wing length (cm)",
	wing_width ~ "Wing width (cm)",
	antenna_length ~ "Antenna length (cm)",
	body_length ~ "Body length (cm)",
	age ~ "Age",
	population ~ "Population"
)

# First univariable
t5_uv <- dat_reg |>
	gtsummary::tbl_uvregression(
		method = lm,
		y = wing_length,
		label = label_list,
		include = -id,
		hide_n = TRUE
	) |>
	gtsummary::modify_caption("Crude regression estimates.")

gt::gtsave(
	data = t5_uv |> gtsummary::as_gt(),
	filename = here::here("results", "t5_uv.png"),
	vwidth = 2400,
	vheight = 2400
)

# Now multivariable
t5_mv <-
	lm(
		formula = wing_length ~ wing_width + age + antenna_length + body_length +
			population + age:population,
		data = dat_reg
	) |>
	gtsummary::tbl_regression(
		label = list(
			wing_width ~ "Wing width (cm)",
			antenna_length ~ "Antenna length (cm)",
			body_length ~ "Body length (cm)",
			age ~ "Age",
			population ~ "Population"
		)
	) |>
	gtsummary::modify_caption("Adjusted regression estimates.")
	

gt::gtsave(
	data = t5_mv |> gtsummary::as_gt(),
	filename = here::here("results", "t5_mv.png"),
	vwidth = 2400,
	vheight = 2400
)

# Stick them together to make table two
t5_merged <-
	gtsummary::tbl_merge(
		list(t5_uv, t5_mv),
		tab_spanner = c("Crude", "Adjusted")
	) |>
	gtsummary::modify_caption(
		"Crude and adjusted regression estimates where wing length (cm) is
		the outcome variable."
	)

gt::gtsave(
	data = t5_merged |> gtsummary::as_gt(),
	filename = here::here("results", "t5.png"),
	vwidth = 2400,
	vheight = 1350
)

t5_merged |>
	gtsummary::as_gt() |>
	gt::rm_caption() |>
	gt::gtsave(
		filename = here::here("results", "paper-t2.png"),
		vwidth = 2400,
		vheight = 1350
	)

# Table 6: modelsummary example ####
reg <- lm(
	formula = wing_length ~ 1 + age + antenna_length + population,
	data = dat_reg
)

int <- lm(
	formula = wing_length ~ 1 + age + antenna_length * population,
	data = dat_reg
)

mlm <- lme4::lmer(
	formula = wing_length ~ 1 + age + (1 + antenna_length | population),
	data = dat_reg
)

modelsummary::modelsummary(models = list(
	"No interaction" = reg,
	"Interaction" = int,
	"Multilevel" = mlm
))

# End of file ####
