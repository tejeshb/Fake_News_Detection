######## I used code snippets from lab and https://rstudio-pubs-static.s3.amazonaws.com/236125_e0423e328e4b437888423d3821626d92.html
######## to run this code

#install.packages("drat", repos="https://cran.rstudio.com")
drat:::addRepo("dmlc")
#install.packages("mxnet")

source("https://bioconductor.org/biocLite.R")
#biocLite("EBImage")
library(EBImage)
image_dir <- getwd()


width <- 28
height <- 28
## pbapply is a library to add progress bar *apply functions
## pblapply will replace lapply
library(pbapply)
extract_feature <- function(dir_path, width, height, is_rl = TRUE, add_label = TRUE) {
  img_size <- width*height
  ## List images in path
  images_names <- list.files(dir_path)
  if (add_label) {
    ## Select only cats or dogs images
    images_names <- images_names[grepl(ifelse(is_rl, "rl", "fk"), images_names)]
    ## Set label, cat = 0, dog = 1
    label <- ifelse(is_rl, 0, 1)
  }
  print(paste("Start processing", length(images_names), "images"))
  ## This function will resize an image, turn it into greyscale
  feature_list <- pblapply(images_names, function(imgname) {
    ## Read image
    img <- readImage(file.path(dir_path, imgname))
    ## Resize image
    img_resized <- resize(img, w = width, h = height)
    ## Set to grayscale
    grayimg <- channel(img_resized, "gray")
    ## Get the image as a matrix
    img_matrix <- grayimg@.Data
    ## Coerce to a vector
    img_vector <- as.vector(t(img_matrix))
    return(img_vector)
  })
  ## bind the list of vector into matrix
  feature_matrix <- do.call(rbind, feature_list)
  feature_matrix <- as.data.frame(feature_matrix)
  ## Set names
  names(feature_matrix) <- paste0("pixel", c(1:img_size))
  if (add_label) {
    ## Add label
    feature_matrix <- cbind(label = label, feature_matrix)
  }
  return(feature_matrix)
}
#real_data <- extract_feature(dir_path = image_dir, width = width, height = height)
#fake_data <- extract_feature(dir_path = image_dir, width = width, height = height, is_rl = FALSE)
#awesome_test <- extract_feature(dir_path = image_dir, width = width, height = height)
real_data <- readRDS(file="real.rds")
fake_data <- readRDS(file="fake.rds")
dim(real_data)
dim(fake_data)
#saveRDS(real_data, "real.rds")
#saveRDS(fake_data, "fake.rds")

library(caret)
## Bind rows in a single dataset
complete_set <- rbind(real_data, fake_data)
## test/training partitions
training_index <- createDataPartition(complete_set$label, p = .8, times = 1)
training_index <- unlist(training_index)
train_set <- complete_set[training_index,]
dim(train_set)
test_set <- complete_set[-training_index,]
dim(test_set)
#####svm
columsKeep <- names(which(colSums(complete_set[, -1]) > 0))
fnd <- complete_set[c("label", columsKeep)]
fnd$label <- factor(complete_set$label)
table(fnd$label)
library(e1071) 
library(ggfortify)
set.seed(1)
index <- createDataPartition(fnd$label, p = .20, list = FALSE)
pca <- prcomp(fnd[index, -1], scale. = F, center = F) 
autoplot(pca, data=fnd[index,], colour='label')
screeplot(pca, type="lines", npcs = 50)
var.pca <- pca$sdev ^ 2
x.var.pca <- var.pca / sum(var.pca) 
cum.var.pca <- cumsum(x.var.pca)
plot(cum.var.pca[1:200],xlab="No. of principal components",
     ylab="Cumulative Proportion of variance explained", ylim=c(0,1), type='b')
performanceSVM <- function(model, test, isTest) {
  results <- predict(model, test)
  if (isTest) {
    cm <- confusionMatrix(results, fnd[-index, 1]) } 
  
  else {
    cm <- confusionMatrix(results, fnd[index, 1]) }
return(cm$overall[c(1:2)]) }
pcs <- 30
train <- as.matrix(fnd[-index,-1]) %*% pca$rotation[,1:pcs] 
test <- as.matrix(fnd[index,-1]) %*% pca$rotation[,1:pcs]
model <- svm(train, fnd[-index, 1], kernel="polynomial")
#prediction <- predict(model, fnd[index,1])
(performanceSVM(model, test, FALSE))

library(randomForest)
forest <- randomForest(fnd[-index,]$label ~ ., data=fnd[-index,], importance=TRUE, ntree=10)
rf <- predict(forest, fnd[index,], type = "class") 
confusionMatrix(rf, fnd[index,]$label)

forest20 <- randomForest(fnd[-index,]$label ~ ., data=fnd[-index,], importance=TRUE, ntree=20)
rf20 <- predict(forest20, fnd[index,], type = "class") 
confusionMatrix(rf20, fnd[index,]$label)

forest50 <- randomForest(fnd[-index,]$label ~ ., data=fnd[-index,], importance=TRUE, ntree=50)
rf50 <- predict(forest50, fnd[index,], type = "class") 
confusionMatrix(rf50, fnd[index,]$label)

forest200 <- randomForest(fnd[-index,]$label ~ ., data=fnd[-index,], importance=TRUE, ntree=200)
rf200 <- predict(forest200, fnd[index,], type = "class") 
confusionMatrix(rf200, fnd[index,]$label)

forest400 <- randomForest(fnd[-index,]$label ~ ., data=fnd[-index,], importance=TRUE, ntree=400)
rf400 <- predict(forest400, fnd[index,], type = "class") 
confusionMatrix(rf400, fnd[index,]$label)

columsKeep <- names(which(colSums(complete_set_a[, -1]) > 0))
fnd_a <- complete_set_a[c("label", columsKeep)]
fnd_a$label <- factor(complete_set_a$label)
table(fnd_a$label)
pca_a <- prcomp(fnd_a[,-1], scale. = F, center = F) 
awe_test <- as.matrix(fnd_a[,-1]) %*% pca_a$rotation[,1:4]
(performanceSVM(model, awe_test, FALSE))

###########
rfawe<- predict(forest200, fnd_a[,], type = "class") 
confusionMatrix(rfawe, fnd_a[,]$label)
