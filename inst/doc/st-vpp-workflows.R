## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(TSGenerator)

## ----st-preview, eval=FALSE---------------------------------------------------
# st_preview <- download_st(
#   start = "2020-04-01",
#   end = "2020-06-30",
#   tile_id = "30TXM",
#   product = c("PPI", "QFLAG"),
#   download = FALSE
# )

## ----st-download, eval=FALSE--------------------------------------------------
# st_download <- download_st(
#   start = "2020-04-01",
#   end = "2020-06-30",
#   tile_id = "30TXM",
#   product = c("PPI", "QFLAG"),
#   output_dir = file.path(tempdir(), "HRVPP_ST"),
#   overwrite = FALSE,
#   prompt = TRUE
# )

## ----st-extract, eval=FALSE---------------------------------------------------
# st_ts <- extract_ts(
#   x = file.path(tempdir(), "HRVPP_ST", "PPI"),
#   polygons = parcels,
#   id_col = "Parcel_ID",
#   fun = "median"
# )

## -----------------------------------------------------------------------------
st_example <- data.frame(
  ID = rep(c("parcel_1", "parcel_2"), each = 4),
  Date = rep(as.Date("2020-04-01") + c(0, 10, 20, 30), 2),
  Value = c(0.20, 0.31, NA, 0.58, 0.18, 0.29, 0.43, 0.55)
)
plan <- temporal_plan(st_example, expected_step = 10)
missingness <- summarize_missingness(plan)
completeness <- assess_ts_quality(plan)
missingness
completeness

## -----------------------------------------------------------------------------
st_qflag_classes <- quality_info("ST")
st_qflag_classes

## ----st-mask, eval=FALSE------------------------------------------------------
# st_clean <- mask_quality(
#   x = st_raster,
#   quality = st_qflag_raster,
#   type = "ST",
#   min_quality = 4
# )

## ----vpp-preview, eval=FALSE--------------------------------------------------
# vpp_preview <- download_vpp(
#   start = "2020-01-01",
#   end = "2020-12-31",
#   tile_id = "30TXM",
#   product = c("SOSD", "MAXD", "EOSD", "LENGTH", "MAXV", "AMPL"),
#   season = "s1",
#   download = FALSE
# )

## ----vpp-extract, eval=FALSE--------------------------------------------------
# vpp <- extract_vpp(
#   x = file.path(tempdir(), "HRVPP_VPP"),
#   polygons = parcels,
#   id_col = "Parcel_ID",
#   fun = "median"
# )

## -----------------------------------------------------------------------------
quality_info("VPP")

## ----vpp-mask, eval=FALSE-----------------------------------------------------
# vpp_clean <- mask_quality(
#   x = vpp_raster,
#   quality = vpp_qflag,
#   type = "VPP"
# )

## -----------------------------------------------------------------------------
missingness_data <- expand.grid(
  Year = 2020:2021,
  DOY = seq(20, 340, by = 40),
  Replicate = 1:3
)
missingness_data$Value <- seq_len(nrow(missingness_data)) / nrow(missingness_data)
missingness_data$Value[seq(3, nrow(missingness_data), by = 7)] <- NA_real_

fit <- model_missingness(
  missingness_data,
  year_col = "Year",
  doy_col = "DOY",
  value_col = "Value",
  k = 5
)

plot_missingness(fit, sos = 85, max_doy = 160, eos = 280)

