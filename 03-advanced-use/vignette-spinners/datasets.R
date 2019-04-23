# /*
# file: datasets.R
# author: Peter DeWitt
#
# This file will be sourced and evaluated with data-raw as the working directory
# to build and save the data sets for the R package.  This file will also be
# spun (knitr::spin) to build a .Rmd file which will be used as vignette.
#
# When editing this file it is advisable that your working directory is the
# data-raw directory.
#
# */
#'---
#'title: "Data Set Construction"
#'author: "Peter DeWitt"
#'output:
#'  rmarkdown::html_vignette:
#'    toc: true
#'    number_sections: true
#'vignette: >
#'  %\VignetteIndexEntry{datasets}
#'  %\VignetteEngine{knitr::rmarkdown}
#'  %\VignetteEncoding{UTF-8}
#'---
#'
#+ label = "setup", include = FALSE
knitr::opts_chunk$set(collapse = TRUE)

#'
#' # NCHS - Leading Causes of Death: United States
#'
#' From the data.gov website:
#'
#'> This dataset presents the age-adjusted death rates for the 10 leading causes of death in the United States beginning in 1999. Data are based on information from all resident death certificates filed in the 50 states and the District of Columbia using demographic and medical characteristics. Age-adjusted death rates (per 100,000 population) are based on the 2000 U.S. standard population. Populations used for computing death rates after 2010 are postcensal estimates based on the 2010 census, estimated as of July 1, 2010. Rates for census years are based on populations enumerated in the corresponding censuses. Rates for non-census years before 2010 are revised using updated intercensal population estimates and may differ from rates previously published. Causes of death classified by the International Classification of Diseases, Tenth Revision (ICD–10) are ranked according to the number of deaths assigned to rankable causes. Cause of death statistics are based on the underlying cause of death. SOURCES CDC/NCHS, National Vital Statistics System, mortality data (see http://www.cdc.gov/nchs/deaths.htm); and CDC WONDER (see http://wonder.cdc.gov). REFERENCES
#'>
#'> National Center for Health Statistics. Vital statistics data available. Mortality multiple cause files. Hyattsville, MD: National Center for Health Statistics. Available from: https://www.cdc.gov/nchs/data_access/vitalstatsonline.htm.
#'>
#'> Murphy SL, Xu JQ, Kochanek KD, Curtin SC, and Arias E. Deaths: Final data for 2015. National vital statistics reports; vol 66. no. 6. Hyattsville, MD: National Center for Health Statistics. 2017. Available from: https://www.cdc.gov/nchs/data/nvsr/nvsr66/nvsr66_06.pdf.
#'>
#'> Access & Use Information
#'>
#'> Public: This dataset is intended for public access and use.
#'>
#'> License: No license information was provided. If this work was prepared by an officer or employee of the United States government as part of that person's official duties it is considered a U.S. Government Work.
#'
#'
#' As the end user you can find the original csv via online at
#' https://catalog.data.gov/dataset/age-adjusted-death-rates-for-the-top-10-leading-causes-of-death-united-states-2013
#'
#' The downloaded data is available in the package via
# /*
if (grepl("data-raw$", getwd())) {
  nchscsv <- "../inst/extdata/nchs.csv"
} else {
# */
  nchscsv <- system.file('extdata/nchs.csv', package = 'drug.eg')
# /*
}
# */
#'
#' The checksum for the data set is
tools::md5sum(system.file('extdata/nchs.csv', package = 'drug.eg'))

#+ label = "namespaces"
library(readr)
library(dplyr)
library(magrittr)

#'
#+ label = 'import_data'
nchs <-
  readr::read_csv(file = nchscsv,
                  col_type = cols(Year                      = col_double(),
                                  `113 Cause Name`          = col_character(),
                                  `Cause Name`              = col_character(),
                                  State                     = col_character(),
                                  Deaths                    = col_double(),
                                  `Age-adjusted Death Rate` = col_double()
                                  )
                 )

#'
#' The `113 Cause Name` and `Cause Name` columns are redundant.  There is a
#' one-to-one mapping between the values in these columns:
with(nchs, table(`Cause Name`, `113 Cause Name`)) %>%
  apply(1, `>`, 0) %>%
  rowSums

#'
#' We will omit the `113 Cause Name` from the saved data set.
nchs %<>% dplyr::select(-`113 Cause Name`)
nchs

#'
#' A quick inspection of the data set suggests there are some changes over time
#' or that the reporting is not as expected.  50 States, 10 causes of death, 
{{ dplyr::n_distinct(nchs$Year) }}
#' years of data would suggest
{{ 50 * 10 * dplyr::n_distinct(nchs$Year) }}
#' rows of data, not the 
{{ qwraps2::frmt(nrow(nchs)) }} 
#' in the set.
#'
#' Let's investigate this issue.  First, the State column is not just the 50
#' States of the United States:
table(nchs$State)

#'
#' All 50 states are listed
all(state.name %in% nchs$State)

#'
#' What are the other values for State?
setdiff(nchs$State, state.name)

#'
#' District of Columbia is not that surprising but the value "United States" is.
nchs %>% dplyr::filter(State == "United States")

#'
#' It seems possible that the rows denoted "United States" could be totals for
#' the country.
dplyr::left_join(
                 {
                   nchs %>%
                     dplyr::filter(State != "United States") %>%
                     dplyr::group_by(Year, `Cause Name`) %>%
                     dplyr::summarize(Deaths = sum(Deaths)) %>%
                     dplyr::ungroup(.)
                 }
                ,
                 { 
                   nchs %>%
                     dplyr::filter(State == "United States") %>%
                     dplyr::select(Year, `Cause Name`, Deaths)
                 }
                ,
                by = c("Year", "Cause Name")
                ,
                suffix = c(".state", ".us")) %>%
print %>%
dplyr::summarize(all(Deaths.state == Deaths.us))

#'
#' After verifying that the `State == "United States"` is the total for the
#' country it seems reasonable to seperate these rows into a seperate data set.
#' Further, the `All causes` option for `Cause Name` suggests yet another data
#' set sould be extracted from the source data.  We will have four data sets:
#'
#' 1. All Causes United States
#' 2. All Causes by State
#' 3. By Cause United States
#' 4. By Cause by State

all_cause_us <-
  nchs %>%
  dplyr::filter(State == "United States", `Cause Name` == "All causes") %>%
  dplyr::arrange(Year) %>%
  print

all_cause_states <-
  nchs %>%
  dplyr::filter(State != "United States", `Cause Name` == "All causes") %>%
  dplyr::arrange(Year) %>%
  print

# /* expect all_cause_states to have 51 * 18 rows:
if ( 51 * 18 != nrow(all_cause_states)) stop("unexpeted number of rows in the all_cause_states construction.")
# */

by_cause_us <-
  nchs %>%
  dplyr::filter(State == "United States", `Cause Name` != "All causes") %>%
  dplyr::arrange(Year) %>%
  print

by_cause_states <-
  nchs %>%
  dplyr::filter(State != "United States", `Cause Name` != "All causes") %>%
  dplyr::arrange(Year) %>%
  print


# /* last chunk for the vignette, only if the package is installed
if ("drug.eg" %in% installed.packages()[, 1]) {
# */
#'
#' The data sets are aviable in this R package:
data(package = "drug.eg")$results[, c("Item", "Title")]
# /*
}
# */

# /*
# Save the data set and create the documentation file for the data set
save(all_cause_us,     file = "../data/all_cause_us.rda")
save(all_cause_states, file = "../data/all_cause_states.rda")
save(by_cause_us,      file = "../data/by_cause_us.rda")
save(by_cause_states,  file = "../data/by_cause_states.rda")


cat(
"
# This file was generated by data-raw/datasets.R
# DO NOT EDIT BY HAND

#' All Cause Deaths in the United States from",
min(all_cause_us$Year), "to", max(all_cause_us$Year), "
#'
#' @format a data.frame with",
qwraps2::frmt(nrow(all_cause_us)), "rows and", qwraps2::frmt(ncol(all_cause_us)),
"columns.  Note that non-syntacticaly valid names are used for some of the
#' columns.  You will need to use backticks to refernce the columns by name.
#'
#' \\describe{
#'   \\item{Year}{The calendar year}
#'   \\item{Cause Name}{Cause of Death}
#'   \\item{State}{Reporting State or Region}
#'   \\item{Deaths}{Reported number of deaths}
#'   \\item{Age-adjusted Death Rate}{No specifics on the method for this
#'   adjustment, but it is provided by NCHS}
#' }
#'
#' @seealso vignette(\"datasets\", package = \"drug.eg\")
#'
\"all_cause_us\"

#' All Cause Deaths within the United States by State from",
min(all_cause_states$Year), "to", max(all_cause_states$Year), "
#'
#' @format a data.frame with",
qwraps2::frmt(nrow(all_cause_states)), "rows and", qwraps2::frmt(ncol(all_cause_states)),
"columns.  Note that non-syntacticaly valid names are used for some of the
#' columns.  You will need to use backticks to refernce the columns by name.
#'
#' \\describe{
#'   \\item{Year}{The calendar year}
#'   \\item{Cause Name}{Cause of Death}
#'   \\item{State}{Reporting State or Region}
#'   \\item{Deaths}{Reported number of deaths}
#'   \\item{Age-adjusted Death Rate}{No specifics on the method for this
#'   adjustment, but it is provided by NCHS}
#' }
#'
#' @seealso vignette(\"datasets\", package = \"drug.eg\")
#'
\"all_cause_states\"

#' Top 10 Causes of Deaths in the United States from",
min(by_cause_us$Year), "to", max(by_cause_us$Year), "
#'
#' @format a data.frame with",
qwraps2::frmt(nrow(by_cause_us)), "rows and", qwraps2::frmt(ncol(by_cause_us)),
"columns.  Note that non-syntacticaly valid names are used for some of the
#' columns.  You will need to use backticks to refernce the columns by name.
#'
#' \\describe{
#'   \\item{Year}{The calendar year}
#'   \\item{Cause Name}{Cause of Death}
#'   \\item{State}{Reporting State or Region}
#'   \\item{Deaths}{Reported number of deaths}
#'   \\item{Age-adjusted Death Rate}{No specifics on the method for this
#'   adjustment, but it is provided by NCHS}
#' }
#'
#' @seealso vignette(\"datasets\", package = \"drug.eg\")
#'
\"by_cause_us\"

#' Top 10 Causes of Deaths within the United States by State from",
min(by_cause_states$Year), "to", max(by_cause_states$Year), "
#'
#' @format a data.frame with",
qwraps2::frmt(nrow(by_cause_states)), "rows and", qwraps2::frmt(ncol(by_cause_states)),
"columns.  Note that non-syntacticaly valid names are used for some of the
#' columns.  You will need to use backticks to refernce the columns by name.
#'
#' \\describe{
#'   \\item{Year}{The calendar year}
#'   \\item{Cause Name}{Cause of Death}
#'   \\item{State}{Reporting State or Region}
#'   \\item{Deaths}{Reported number of deaths}
#'   \\item{Age-adjusted Death Rate}{No specifics on the method for this
#'   adjustment, but it is provided by NCHS}
#' }
#'
#' @seealso vignette(\"datasets\", package = \"drug.eg\")
#'
\"by_cause_states\"

",
file = "../R/datasets.R"
)

# */

# /* end of file */
