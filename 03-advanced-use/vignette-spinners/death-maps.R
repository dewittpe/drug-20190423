#'---
#'title: "Death Maps"
#'author: "Peter DeWitt"
#'package: drug.eg
#'output:
#'  BiocStyle::html_document:
#'     toc_float: true
#'vignette: >
#'  %\VignetteIndexEntry{Death Maps}
#'  %\VignetteEngine{knitr::rmarkdown}
#'  %\VignetteEncoding{UTF-8}
#'---
#'
#+ label = "setup", include = FALSE
knitr::opts_chunk$set(collapse = TRUE)

#'
#' This is a proof of concept vignette.  This document has been written to show
#' that knitr::spin can be used to build vignettes.
#'
#' # Deaths in the United States
#'
#' This is a brief exploration of the top 10 causes of death in the United
#' States over the past several years.
#'
library(drug.eg)
library(ggplot2)
library(maps)
library(mapproj)
library(dplyr)

data(all_cause_states, by_cause_states)

# map data
us_states <- map_data("state") %>% dplyr::as_tibble(.)

#'
#' # All Cause Deaths
#'

dplyr::left_join(us_states,
                 {
                 all_cause_states %>%
                   dplyr::mutate(State = tolower(State))
                 },
                 by = c("region" = "State")) %>% 
ggplot(.) +
  theme_bw() +
  aes(x = long, y = lat, group = group, fill = `Age-adjusted Death Rate`) +
  geom_polygon() +
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  theme(
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        legend.position = "bottom",
        legend.key.width = grid::unit(0.5, "in")) +
  facet_wrap( ~ Year)


#'
#' # By Cause Deaths
#'
#' Cancer and Heart Disease are the two most common causes of death.

#+ fig.width = 12, fig.height = 6
by_cause_us %>%
  dplyr::group_by(Year) %>%
  dplyr::mutate(Rank = rank(-`Age-adjusted Death Rate`)) %>%
  dplyr::filter(Rank <= 3) %>%
ggplot(.) +
  theme_bw() +
  geom_bar(aes(x = Year, y = `Age-adjusted Death Rate`, fill = `Cause Name`),
           position = position_dodge(),
           stat = "identity") +
  theme(legend.position = "bottom")

#'
#' ## Heart Disease
#' 
#' The graphics below show the map of the United states and the age adjusted
#' death rate for cancer and heart disease over the years of interest.
dplyr::left_join(us_states,
                 {
                   by_cause_states %>%
                     dplyr::filter(`Cause Name` %in% c("Cancer", "Heart disease")) %>%
                     dplyr::mutate(State = tolower(State))
                 },
                 by = c("region" = "State")) %>%
ggplot(.) +
theme_bw() +
aes(x = long, y = lat, group = group, fill = `Age-adjusted Death Rate`) +
geom_polygon() +
coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
theme(
      axis.title = element_blank(),
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      legend.position = "bottom",
      legend.key.width = grid::unit(0.5, "in")) +
facet_wrap( ~ Year + `Cause Name`)


# /* end of file */
