---
  title: "Assigment - kNN DIY"
author:
  - Joel van Bragt - Author
- Lars Bunnik - Reviewer
date: "`r format(Sys.time(), '%d %B, %Y')`"
output:
  html_notebook:
  toc: true
toc_depth: 2
---

##Loading packages
  
```{r}
library(tidyverse)
library(googlesheets4)
library(class)
library(caret)
```

---

  
  
## Business Understanding
By determining what factors a room is occupied a prediction can be made for the future. This can also be used to see what the perfect circumstances are for a room to be occupied.



## Data Understanding
First we need to import the dataset for usage in R.

```{r}
RawDF <- read.csv("https://raw.githubusercontent.com/HAN-M3DM-Data-Mining/assignments/master/datasets/KNN-occupancy.csv")
```
To get a grasp of what the set entails we summarise it.

```{r}
summary(RawDF)
```
There are 8143 entries and 7 columns. Occupancy is the variable to be determined.



## Data Preparation
Since the dates are all unique this is more akin to a identifier than a usable independant variable so that one will be removed from the dataset.

```{r}
PreppedDF <- RawDF[-1]
Summarize(PreppedDF)
```

As we could see before and now the columns each have a very wide range of values in them. To make the different values usable for training they need to standardised.

The normalised dataset will be called PrepNormDF.

```{r}
normalize <- function(x){return((x - min(x))/ (max(x) - min(x)))}
nCols <- dim(PreppedDF)[6]
PrepNormDF <- sapply(1:5,
                    function(x) {
                      normalize(PreppedDF[,x])
                    }) %>% as.data.frame()

view(PrepNormDF)
summary(PrepNormDF)
```
We can see that all values now max out at 1.


The dataset can be split in to two different ones: one for training and one for testing the accuracy. this is done in a 80:20 split.

```{r}
trainDF_feat <- PrepNormDF[1:6514,  ]
testDF_feat <- PrepNormDF[6515:8143,  ]

trainDF_labels <- PreppedDF[1:6514,  ]
testDF_labels <- PreppedDF[6515:8143, ]

```



## Modeling
Now the model can be trained. Band (2020) suggest using the square root of the number of rows. This would be 90, but to avoid ties this will be the odd number 91.

```{r}
PredictedOccupancy <- knn(train = as.matrix(trainDF_feat), test = as.matrix(testDF_feat), cl = as.matrix(trainDF_labels, k= 101)) 
head(PredictedOccupancy)
```



## Evaluation and Deployment
To see the outcomes we make a confusion matrix. This shows the performance of the model.

```{r}
confusionMatrix(PredictedOccupancy, testDF_labels)
```
This shows an accuracy of 85,7%. Fairly useful in a business environment where no model was used before in such situation.



##Sources
A. Band (2020) https://towardsdatascience.com/how-to-find-the-optimal-value-of-k-in-knn-35d936e554eb





##Review

row 50 
PreppedDF <- RawDF[-1]
Summarize(PreppedDF)
Here the function is misspelled and should be summary instead of Summarize.


row78 and 79
trainDF_labels <- PreppedDF[1:6514,  ]
testDF_labels <- PreppedDF[6515:8143, ]
the third variable between the brackets of both rows is missing which should be the number 6.

row 99
confusionMatrix(PredictedOccupancy, testDF_labels)
Here the table function is missing and should be added within brackets like this: confusionMatrix(table(PredictedOccupancy, testDF_labels))

