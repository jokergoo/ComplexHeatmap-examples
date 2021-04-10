
parse_script = function(f) {
	text = readLines(f)

	lt = list()

	category = text[1]
	category = gsub("^\\s*#\\s*", "", category)
	category = gsub("category:\\s+", "", category)

	topic = text[2]
	topic = gsub("^\\s*#\\s*", "", topic)
	topic = gsub("topic:\\s+", "", topic)
	
	text = text[-(1:2)]
	lt$category = category
	lt$topic = topic

	text = text[!grepl("^#{10,}$", text)]

	ind = which(grepl("^#+\\s*title:", text))
	ind2 = c(ind[-1] - 1, length(text))

	lt$example = list()
	
	for(i in seq_along(ind)) {

		code = text[seq(ind[i]+1, ind2[i])]

		leading_empty_rows = numeric(0)
		for(k in seq_along(code)) {
			if(grepl("^\\s*$", code[k])) {
				leading_empty_rows = c(leading_empty_rows, k)
			} else {
				break
			}
		}
		if(length(leading_empty_rows)) {
			code = code[-leading_empty_rows]
		}

		if(!any(grepl("(library|require)\\(ComplexHeatmap\\)", code))) {
			code = c("library(ComplexHeatmap)", code)
		}

		for(k in rev(seq_along(code))) {
			if(grepl("^\\s*$", code[k])) {
				code = code[-k]
			} else {
				break
			}
		}
		title = gsub("^#+\\s*title:\\s+", "", text[ind[i]])
		code = gsub("\\t", "    ", code)

		lt$example[[i]] = list(
			title = title, 
			code = code,
			hash = digest(code, "crc32")
		)
	}
	lt
}

write_script = function(lt, output) {
	out = file(output, "w")
	writeLines(qq("# category: @{lt$category}"), out)
	writeLines(qq("# topic: @{lt$topic}"), out)
	writeLines(qq(""), out)

	for(i in seq_along(lt$example)) {
		writeLines(qq("##########################################"), out)
		writeLines(qq("# title: @{lt$example[[i]]$title}"), out)
		writeLines(qq("# hash: @{lt$example[[i]]$hash}"), out)
		writeLines(qq(""), out)
		writeLines(lt$example[[i]]$code, out)
		writeLines(qq(""), out)
	}
	close(out)
}

generate_html_by_topic = function(lt, prefix = getwd()) {
	dir_name = reformat(lt$topic)

	dir.create(qq("@{prefix}/@{dir_name}"), showWarnings = FALSE)

	file.remove(list.files(pattern = "(Rmd|rmd|md)$", path = qq("@{prefix}/@{dir_name}"), full.names = TRUE))

	index = file(qq("@{prefix}/@{dir_name}/index.html"), "w")

	url_base = gsub("^.*?/docs", "", prefix)

	for(i in seq_along(lt$example)) {
		title = lt$example[[i]]$title
		code = lt$example[[i]]$code
		hash = lt$example[[i]]$hash

		code = qq("
```{r, echo = FALSE}
library(knitr)
knitr::opts_chunk$set(
    error = FALSE,
    tidy  = FALSE,
    message = FALSE,
    warning = FALSE,
    fig.retina = 1.5
)
```

[&larr; Go back to the main page](../../index.html)

@{title}

```{r}
@{paste(code, collapse = '\n')}
```

```{r}
sessionInfo()
```
")		
		qqcat("- generating page '@{title}'...\n")
		setwd(qq("@{prefix}/@{dir_name}"))
		temp_rmd = tempfile(fileext = ".Rmd", tmpdir = ".")
		writeLines(code, temp_rmd)
		oe = try(r(function(temp_rmd, output) {
			knitr::knit2html(temp_rmd, output = output, fragment.only = TRUE)
		}, args = list(temp_rmd = temp_rmd, output = GetoptLong::qq("@{hash}.html"))), silent = TRUE)
		file.remove(temp_rmd)
		file.remove(gsub("Rmd$", "md", temp_rmd))
		setwd(wd)

		if(inherits(oe, "try-error")) {
			qqcat("!! There is an error when generting '@{title}'\n")
			stop(oe)
		}
		
		writeLines(qq("<p><a href='#' onclick='open_page(\"@{url_base}/@{dir_name}/@{hash}.html\");false;'>@{title}</a></p>"), con = index)
	}
	close(index)
}

reformat = function(x) {
	x = tolower(x)
	gsub("[^a-zA-Z0-9]", "-", x)
}
