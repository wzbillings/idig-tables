###
# Load and slightly clean the longwing csv data
# Zane Billings
# 2024-01-22
###

dat <- readr::read_csv(
	here::here("static", "longwing-data.csv"),
	col_types = "dddddddddddfddddc"
) |>
	dplyr::select(-1)
readr::write_rds(dat, here::here("static", "longwing-data.Rds"))
