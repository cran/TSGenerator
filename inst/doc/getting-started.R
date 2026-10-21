## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(TSGenerator)

## -----------------------------------------------------------------------------
check_wekeo()

## ----wekeo-online, eval=FALSE-------------------------------------------------
# check_wekeo(online = TRUE)

## ----st-preview, eval=FALSE---------------------------------------------------
# st <- download_st(
#   start = "2020-04-01",
#   end = "2020-04-30",
#   tile_id = "30TXM",
#   product = c("PPI", "QFLAG"),
#   download = FALSE
# )

## ----st-extraction, eval=FALSE------------------------------------------------
# st_ts <- extract_ts(
#   x = "HRVPP_ST/PPI",
#   polygons = parcels,
#   id_col = "Parcel_ID",
#   fun = "median"
# )

## ----vpp-preview, eval=FALSE--------------------------------------------------
# vpp <- download_vpp(
#   start = "2020-01-01",
#   end = "2020-12-31",
#   tile_id = "30TXM",
#   product = c("SOSD", "MAXD", "EOSD", "LENGTH", "MAXV"),
#   season = "s1",
#   download = FALSE
# )

## ----vpp-extraction, eval=FALSE-----------------------------------------------
# vpp_values <- extract_vpp(
#   x = "HRVPP_VPP",
#   polygons = parcels,
#   id_col = "Parcel_ID",
#   fun = "median"
# )

## -----------------------------------------------------------------------------
quality_info("ST")
quality_info("VPP")

## -----------------------------------------------------------------------------
example_ts <- data.frame(
  ID = c("A", "A", "A", "B", "B", "B"),
  Date = as.Date(c(
    "2020-04-01", "2020-04-11", "2020-05-01",
    "2020-04-01", "2020-04-11", "2020-04-21"
  )),
  Value = c(0.22, NA, 0.61, 0.18, 0.35, 0.52)
)

plan <- temporal_plan(example_ts, expected_step = 10)
summarize_missingness(plan)
assess_ts_quality(plan)

## -----------------------------------------------------------------------------
imputed <- impute_ts(
  example_ts,
  method = "linear",
  series_type = "user",
  complete_grid = TRUE,
  expected_step = 10,
  max_gap = 2
)
imputed

## ----live-integration, eval=FALSE---------------------------------------------
# z <- check_wekeo_integration(download = FALSE)
# print(z)
# stopifnot(z$ok)

