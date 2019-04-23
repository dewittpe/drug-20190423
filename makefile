all : slides.html 00-flights.html 01-flights.html

slides.html : slides.R
	R --vanilla -e "knitr::spin('$<', knit = FALSE); rmarkdown::render('$(basename $<).Rmd')"

00-flights.html : 00-flights.Rmd
	R --vanilla -e "rmarkdown::render('$<')"

01-flights.html : 01-flights.R
	R --vanilla -e "knitr::spin('$<', knit = FALSE); rmarkdown::render('$(basename $<).Rmd')"
