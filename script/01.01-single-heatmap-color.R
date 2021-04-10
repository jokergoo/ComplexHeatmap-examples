# category: A single heatmap
# topic: Colors

###################################################################
# title: Self-define a color mapping function for continous values.

mat = readRDS(system.file("extdata", "rand_mat.rds", package = "ComplexHeatmap"))
library(circlize)
col_fun = colorRamp2(c(-2, 0, 2), c("green", "white", "red"))
Heatmap(mat, name = "mat", col = col_fun)

###################################################################
# title: Define the same color mapping for multiple heatmaps so that the color interpolations are comparable between heatmaps.

mat = readRDS(system.file("extdata", "rand_mat.rds", package = "ComplexHeatmap"))
library(circlize)
col_fun = colorRamp2(c(-2, 0, 2), c("green", "white", "red"))
Heatmap(mat, name = "mat", col = col_fun, column_title = "mat")
Heatmap(mat/4, name = "mat", col = col_fun, column_title = "mat/4")
Heatmap(abs(mat), name = "mat", col = col_fun, column_title = "abs(mat)")

###################################################################
# title: Define a vector of colors for continous matrix

mat = readRDS(system.file("extdata", "rand_mat.rds", package = "ComplexHeatmap"))
Heatmap(mat, name = "mat", col = rev(rainbow(10)), 
    column_title = "set a color vector for a continuous matrix")

###################################################################
# title: Assign discrete color mapping for a numeric matrix.

discrete_mat = matrix(sample(1:4, 100, replace = TRUE), 10, 10)
colors = structure(1:4, names = c("1", "2", "3", "4")) # black, red, green, blue
Heatmap(discrete_mat, name = "mat", col = colors,
    column_title = "a discrete numeric matrix")

###################################################################
# title: Set color for character matrix
discrete_mat = matrix(sample(letters[1:4], 100, replace = TRUE), 10, 10)
colors = structure(1:4, names = letters[1:4])
Heatmap(discrete_mat, name = "mat", col = colors,
    column_title = "a discrete character matrix")

###################################################################
# title: A heatmap with NA values
mat = readRDS(system.file("extdata", "rand_mat.rds", package = "ComplexHeatmap"))
mat_with_na = mat
na_index = sample(c(TRUE, FALSE), nrow(mat)*ncol(mat), replace = TRUE, prob = c(1, 9))
mat_with_na[na_index] = NA
Heatmap(mat_with_na, name = "mat", na_col = "black",
    column_title = "a matrix with NA values")

###################################################################
# title: Set colors for heatmap borders and cell orders. 
mat = readRDS(system.file("extdata", "rand_mat.rds", package = "ComplexHeatmap"))
Heatmap(mat, name = "mat", border_gp = gpar(col = "black", lty = 2),
    column_title = "set heatmap borders")
Heatmap(mat, name = "mat", rect_gp = gpar(col = "white", lwd = 2),
    column_title = "set cell borders")
