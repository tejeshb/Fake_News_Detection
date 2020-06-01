# Fake News Detection
This project is a part of Data Science hobby projects of mine.

#### -- Project Status: [Completed]

## Project Intro/Objective
The purpose of this project is to use the Natural Language Processing techniques to find predict any given news snippet or headline as True or Fake. Multiple sources of data are considered for this project that has labeled fake/real news texts such as Buzzfeed, Politifact, Kaggle, BSDetector. The hypothesis for the project is - To what extent credibility and robustness of a model in detecting fake/real news can be increased by using multiple sources of data?


### Methods Used
* Inferential Statistics
* Machine Learning
* Data Visualization
* Natural Language Processing
* Data Cleaning


### Technologies
* Python
* Json
* Pandas, jupyter
* HTML

* PLease look at requirements file [here](https://github.com/tejeshb/deploy_fnd/blob/master/code/requirements.txt)


## Project Description
All the data sets pertaining to textual features have been transformed in to fields of title, label, and transform. Though few data sources contain a text field which basically contains the whole news I choose to ignore it over title because in twitter the limit per tweet is restricted to 280 characters.As, I choose to detect the credibility of news by training models separately based on each platform or data source over combining all the sources and running one model. To analyze and find if this really makes any difference I compared the feature weights of text for both real and fake news for each data source. 

## The deployed code can be found here (https://github.com/tejeshb/deploy_fnd)

## Deployed app - https://fakenews-detector-tejeshai.herokuapp.com/


## Getting Started

1. Clone this repo (for help see this [tutorial](https://help.github.com/articles/cloning-a-repository/))
2. Buzz feed source data clean and transform can be found [here](https://github.com/tejeshb/Fake_News_Detection/blob/master/textFND-buzzfeed.ipynb)
3. Politifact sourcedata clean and transform [here](https://github.com/tejeshb/Fake_News_Detection/blob/master/textFND-politifact.ipynb)
4.Kaggle sourcedata clean and transform [here](https://github.com/tejeshb/Fake_News_Detection/blob/master/textFND_kaggle.ipynb)
5. Joining all sources cleaned data and training of models [here](https://github.com/tejeshb/Fake_News_Detection/blob/master/textFND-all.ipynb)



#### My Details:

|Name     |  Git Hub Handle   | Website  |
|---------|-----------------|--------------|
|[Tejesh Batapati]| https://github.com/tejeshb   | https://tejesh-ai.webflow.io/|

Feel free to look at my personal projects website here [tejesh.AI] (https://tejesh-ai.webflow.io/)

