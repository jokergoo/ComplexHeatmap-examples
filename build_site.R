
library(digest)

wd = getwd()

source("lib.R")

scripts = list.files(qq("@{wd}/script/"), full.names = TRUE)


lt = list()
for(i in seq_along(scripts)) {
	lt = c(lt, list(parse_script(scripts[i])))
}


meta = data.frame(category = sapply(lt, function(x) x$category),
	              topic = sapply(lt, function(x) x$topic))


# generate page for each example
for(i in seq_len(nrow(meta))) {
	prefix = qq("@{wd}/docs/@{reformat(meta[i, 1])}")
	dir.create(prefix, showWarnings = FALSE, recursive = TRUE)
	generate_html_by_topic(lt[[i]], prefix)
}

# generate page for each category

#### sidebar ####
menu_list = tapply(seq_len(nrow(meta)), meta[, 1], function(ind) {
	topic = meta[ind, 2]
	category = meta[ind[1], 1]

	sub_menu_list = lapply(topic, function(x) {
		menuSubItem(x, tabName = paste0(reformat(category), "-", reformat(x)))
	})

	arg_lt = list(text = category, startExpanded = TRUE)
	arg_lt = c(arg_lt, sub_menu_list)
	do.call("menuItem", arg_lt)

}, simplify = FALSE)
menu_list = unname(menu_list)

sidebar = dashboardSidebar(
	do.call("sidebarMenu", menu_list)
)

#### body ####

tab_list = lapply(seq_len(nrow(meta)), function(i) {
	category = meta[i, 1]
	topic = meta[i, 2]

	lines = readLines(qq("@{wd}/docs/@{reformat(category)}/@{reformat(topic)}/index.html"))
	html = paste(lines, collapse = "\n")

	tabItem(tabName = paste0(reformat(category), "-", reformat(topic)),
		box(
			HTML(html)
		)
	)
})
tab_list = unname(tab_list)

body = dashboardBody(
	do.call("tabItems", tab_list)
)

ui = dashboardPage(
	dashboardHeader(title = "ComplexHeatmap\nExamples"),
	sidebar,
	body
)

html = qq('
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<script src="www/shared/jquery.min.js"></script>
<link href="www/shared/fontawesome/css/all.min.css" rel="stylesheet" />
<link href="www/shared/fontawesome/css/v4-shims.min.css" rel="stylesheet" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link href="www/shared/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="www/shared/bootstrap/accessibility/css/bootstrap-accessibility.min.css" rel="stylesheet" />
<script src="www/shared/bootstrap/js/bootstrap.min.js"></script>
<script src="www/shared/bootstrap/accessibility/js/bootstrap-accessibility.min.js"></script>
<link href="www/shared/AdminLTE/AdminLTE.min.css" rel="stylesheet" />
<link href="www/shared/AdminLTE/_all-skins.min.css" rel="stylesheet" />
<script src="www/shared/AdminLTE/app.min.js"></script>
<link href="www/shared/shinydashboard.css" rel="stylesheet" />
<script src="www/main.js"></script>
</head>
@{as.character(ui)}
</html>
')

writeLines(html, qq("@{wd}/docs/index.html"))


