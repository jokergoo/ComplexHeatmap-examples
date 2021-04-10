# category: A single heatmap
# topic: Title

###################################################################
# title: Set both row title and column title

mat = readRDS(system.file("extdata", "rand_mat.rds", package = "ComplexHeatmap"))
Heatmap(mat, name = "mat", column_title = "I am a column title", 
    row_title = "I am a row title")


##################################################################
# title: Put column title to the bottom of the heatmap and put the row title to the right of the heatmap.

mat = readRDS(system.file("extdata", "rand_mat.rds", package = "ComplexHeatmap"))
ht = Heatmap(mat, name = "mat", 
	column_title = "I am a column title at the bottom", column_title_side = "bottom",
	row_title = "I am a row title", row_title_side = "right")
draw(ht, heatmap_legend_side = "left")

##################################################################
# title: Set horizontal row title

mat = readRDS(system.file("extdata", "rand_mat.rds", package = "ComplexHeatmap"))
Heatmap(mat, name = "mat", row_title = "row title", row_title_rot = 0)


##################################################################
# title: Set graphics parameters for title

ht_opt$TITLE_PADDING = unit(c(8.5, 8.5), "points")
mat = readRDS(system.file("extdata", "rand_mat.rds", package = "ComplexHeatmap"))
Heatmap(mat, name = "mat", column_title = "I am a column title", 
    column_title_gp = gpar(fill = "red", col = "white", border = "blue"))


##################################################################
# title: Set title as a math formula

mat = readRDS(system.file("extdata", "rand_mat.rds", package = "ComplexHeatmap"))
Heatmap(mat, name = "mat", 
    column_title = expression(hat(beta) == (X^t * X)^{-1} * X^t * y)) 

##################################################################
# title: Set customized title with gridtext package

set.seed(123)
mat = matrix(rnorm(100), 10)
rownames(mat) = letters[1:10]
Heatmap(mat, 
    column_title = gt_render("Some <span style='color:blue'>blue text **in bold.**</span><br>And *italics text.*<br>And some <span style='font-size:18pt; color:black'>large</span> text.", 
        r = unit(2, "pt"), 
        padding = unit(c(2, 2, 2, 2), "pt")),
    column_title_gp = gpar(box_fill = "orange"))
