library(data.table)
options(jupyter.rich_display = F)
options(repr.matrix.max.cols = 30, repr.matrix.max.rows = 200)
orders <- fread("/anvil/projects/tdm/data/icecream/combined/products.csv")
aggregate<- aggregate(rating_count ~ brand, data = orders, FUN = sum)
dotchart(aggregate$rating_count, main="Total Ratings by Ice Cream Brand", labels = aggregate$brand)

mybrands <- c("bj", "breyers", "talenti")
myfiles <- paste0("/anvil/projects/tdm/data/icecream/", mybrands, "/reviews.csv")
bigDF <- do.call(rbind, lapply(myfiles, fread))

head(bigDF)
sort(table(format(bigDF$date, "%m-%Y")),decreasing= TRUE)
aggregate_2 <- aggregate(stars ~ year(date), data = bigDF, mean) 
aggregate_2
barplot(height=aggregate_2$stars, names= aggregate_2$year, main= "Average Stars per Year")

aggregate_3 <- aggregate(stars ~ key, data = bigDF, mean) 
aggregate_3 <- aggregate_3[order(aggregate_3$stars, decreasing = FALSE),]
head(aggregate_3)
bigDF[nchar(as.character(bigDF$text))>= 2500,]

head(sort(table(bigDF$author), decreasing = TRUE))
badReview <- subset(bigDF, author== "FuzzyGut" & stars == 1)
badReview$text