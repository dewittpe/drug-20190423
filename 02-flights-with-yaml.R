# /*
# file:   02-flights-with-yaml.R
# author: Peter DeWitt <peter.dewitt@ucdenver.edu>
# date:   April 2019
#
# Purpose: an example of a fully working data analysis report with multiple
# outputs.
#
# The template.docx file uses some really bad options for a real report.  These
# options are used in the example to make it very clear that the template
# document is being used as expected.
#
# */
#'---
#'title: "Flights from New York City to Denver Colorado during 2013"
#'subtitle: "Example report for Denver R User Group"
#'author:
#'  -name: Peter DeWitt
#'  -email: peter.dewitt@ucdenver.edu
#'output:
#'  BiocStyle::html_document:
#'     toc_float: true
#'     css: biocstyle.css
#'  rmarkdown::word_document:
#'     reference_docx: template.docx
#'bibliography: references.bib
#'---
#'
#'
#+ label = "setup", include = FALSE
library(nycflights13)
library(ggplot2)
library(dplyr)
library(qwraps2)
options(qwraps2_markup = "markdown")
knitr::opts_chunk$set(echo = FALSE, results = "hide")

#'
#' We are interested in looking at the flights from departing NYC in 2013 and
#' arriving in Denver Colorado.  For this work we will use the data provided in the
#' R package [nycflights13](https://cran.r-project.org/package=nycflights13).
#' [@r-nycflights13]
#'

# /*
# There are several data sets we could use.
# (This comment will not be in the .Rmd)
data(package = "nycflights13")$results
# */
#'
#' ## Fights To Denver
#'
#+ label = "define_flights_to_denver"
flights_to_den <-
  flights %>%
  dplyr::filter(dest == "DEN") %>%
  left_join(airlines, by = "carrier")

dplyr::filter(airports, faa %in% unique(flights_to_den$origin))

#'
#'
#' There were
{{ frmt(nrow(flights_to_den)) }}
#' flights from NYC to Denver during 2013.
{{ n_perc(flights_to_den$origin == "EWR") }}
#' of the flights originated from
{{ airports[airports$faa == "EWR", ][["name"]] }}
#',
{{ n_perc(flights_to_den$origin == "JFK") }}
#' originated from
{{ airports[airports$faa == "JFK", ][["name"]] }}
#', and the last
{{ n_perc(flights_to_den$origin == "LGA") }}
#' of flights originated from
{{ airports[airports$faa == "LGA", ][["name"]] }}
#'.
#'
#' A summary of the flights are provided in the table below:
#'
#+ label = "setup_summary_table", include = FALSE
with(flights_to_den, table(carrier, name))

smmry <-
  list("Departure Delay (minutes)" =
       list("minimum"      = ~ qwraps2::frmt(min(na.omit(.data[["dep_delay"]]))),
            "median (IQR)" = ~ qwraps2::median_iqr(na.omit(.data[["dep_delay"]])),
            "mean (sd)"    = ~ qwraps2::mean_sd(na.omit(.data[["dep_delay"]])),
            "maximum"      = ~ qwraps2::frmt(max(na.omit(.data[["dep_delay"]]))),
            "Unknown (%)"  = ~ qwraps2::n_perc(is.na(.data[["dep_delay"]]), digits = 0, show_symbol = FALSE, show_denom = "always")
            ),
       "Arrival Delay (minutes)" =
       list("minimum"      = ~ qwraps2::frmt(min(na.omit(.data[["arr_delay"]]))),
            "median (IQR)" = ~ qwraps2::median_iqr(na.omit(.data[["arr_delay"]])),
            "mean (sd)"    = ~ qwraps2::mean_sd(na.omit(.data[["arr_delay"]])),
            "maximum"      = ~ qwraps2::frmt(max(na.omit(.data[["arr_delay"]]))),
            "Unknown (%)"  = ~ qwraps2::n_perc(is.na(.data[["arr_delay"]]), digits = 0, show_symbol = FALSE, show_denom = "always")
            ),
       "Carrier" =
       list("JetBlue Airways"        = ~ qwraps2::n_perc(.data[["carrier"]] == "B6", digits = 0, show_symbol = FALSE),
            "Delta Air Lines Inc."   = ~ qwraps2::n_perc(.data[["carrier"]] == "DL", digits = 0, show_symbol = FALSE),
            "Frontier Airlines Inc." = ~ qwraps2::n_perc(.data[["carrier"]] == "F9", digits = 0, show_symbol = FALSE),
            "United Air Lines Inc."  = ~ qwraps2::n_perc(.data[["carrier"]] == "UA", digits = 0, show_symbol = FALSE),
            "Southwest Airlines CO." = ~ qwraps2::n_perc(.data[["carrier"]] == "WN", digits = 0, show_symbol = FALSE)
            )
  )

#+ results = "asis"
cbind(
      summary_table(flights_to_den, smmry),
      summary_table(dplyr::group_by(flights_to_den, origin), smmry)
     )

#'
#' A graphic for the flight times...
#'
#+ label = "plot", warning = FALSE, fig.width = 15, fig.height = 7
ggplot(flights_to_den) +
  aes(x = time_hour, y = air_time, color = carrier) +
  geom_point() +
  geom_line() +
  facet_grid( ~ origin)

#'
#' # References
#'
# /* End of File */

