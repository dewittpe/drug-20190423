#'---
#'title: "knitr::spin -- A more dynamic approach to dynamic documents"
#'subtitle: "Denver R Users Group<br>Meet and Greet from now to ~ 7:30pm<br>Talk to start ~7:30pm"
#'author: "Peter E. DeWitt, Ph.D.<br><peter.dewitt@ucdenver.edu>"
#'date: 23 April 2019
#'output:
#'  ioslides_presentation:
#'    keep_md: false
#'    template: template.html
#'    css: style.css
#'    widescreen: true
#'    self_contained: true
#'---
#'
#+ label = "setup", include = FALSE
knitr::opts_chunk$set(collapse = TRUE)

#'
#' # Announcements
#'
#' ## Denver R User Group | Administrative Items
#'
#' * Ryan Elmore, original organizer for the Meetup, as stepped aside.
#' * Peter DeWitt has taken the title of Organizer
#' * Matt Pocernich: Co-Organizer and the one who does most of the work
#' *Thank you, Matt!*
#'
#' ## Denver R User Group | Administrative Items
#'
#' * **Speakers Wanted**
#'
#'   * Talks at any level, novice to expert
#'   * Any topic: sports, data mining, IDE integration, regression tools,
#'   graphics, interactive web development, integration into pipelines, ...
#'   if you use R in the work it is fair game for this Meetup.
#'
#' * **Topics of Interest**
#'   * Volunteer you co-worker to give a talk
#'   * Is there a topic you would like to see a discussed at a meet up?  Let the
#'   organizers know.
#'
#' ## Denver R User Group | Other Announcements
#'
#' <div class="row">
#' <div class = "column">
#' * Spring ASA COWY Meeting:
#'   * Friday 26 April 2019
#'   * 8:30 am to 4:00 pm
#'   * **NCAR's Foothills Campus** *not the Mesa Lab*
#'   * Ample time for lunch at the NCAR Foothills Campus or elsewhere
#'   * All are welcome to attend
#' </div>
#' <div class = "column">
#' <img src="bouldermap8_0.jpg" height="500">
#' </div>
#' </div>
#'
#' # knitr::spin -- Part I: The Basics
#'
#' ## Dynamic Documents
#'
#' * Common Workflows:
#'   * .Rnw --> .tex --> .pdf
#'   * .Rmd --> .(md|tex) --> .(html|pdf|docx)
#'
#' * These workflows are very good and should be used as much as possible.
#'
#' * These workflows:
#'   1. Write a document in a markup language, e.g., LaTeX, markdown, ...
#'   2. Weave into the markup language an analysis language, e.g., R
#'   3. Create a deliverable dynamic and reproducible report
#'
#' * Simple Example: 00-flights.Rmd to 00-flights.html
#'
#' ## Let's think about the paradigm
#'
#' * Analysis language is weaved *into* a markup language
#'
#' * The markup language is the *primary* language for the file
#'
#' * I am a coder:
#' 
#'   * My primary language is the analysis language
#'   * The markup language is for extremely detailed comments.
#'   
#' * What happens if you tried: `source("00-fligths.Rmd")`?
#'
#' ## knitr::spin - Reverse the paradigm
#'
#' * `knitr::spin`
#' 
#'   * R is the primary language
#'   * A markup language is the guest language
#'
#' * Example: 01-flights.R
#'
#' * Build the .html via: `knitr::spin("01-flights.R")`
#'
#' # knitr::spin -- Part II:
#'
#' # knitr::spin -- Part III: An Advanced Use

# /* end of file */
