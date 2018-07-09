# CS529 Machine Learning: Project 3: Music Classification

### Author: Jenniffer Estrada
### Professor: Dr. Trilce Estrada-Piedra
### University of New Mexico, Fall 2017

Website: https://www.kaggle.com/c/cs529-project3

## Description:
This program is used to 

## Required Software:
- 

## To run:

## Report:
https://www.sharelatex.com/read/jjgdcqhbkqsw




### Assignment Instructions:
Your task is to classify music files into 10 predetermined genres such as jazz, classical, country, pop, rock, and metal.
We will use the GTZAN dataset, which is frequently used to benchmark music genre classification tasks. It is organized into 10 distinct genres: blues, classical, country, disco, hiphop, jazz, metal, pop, reggae, and rock. The dataset contains the first 30 seconds of 100 songs per genre. You can download the dataset from UNM Learn. In the folder genres you will find 10 folders, one per genre and 90 songs per folder. Additionally, you’ll find a validation folder with 100 unlabeled songs. The tracks are recorded at 22,050 Hz (22,050 readings per second) mono in the au format.
Design a learning experiment capable of predicting music genres given their audio.


#### Acknowledgements: 
We thank the MARSYAS project for the GTZAN dataset http://marsyasweb.appspot.com/download/data_sets/


#### Data: 
Use GTZAN dataset and the attached validation files


#### Evaluation:
The evaluation metric for this competition is the accuracy classification score. It is the number of correct predictions made divided by the total number of predictions. Upload in the competition your predictions that reach the best accuracy and specify the parameters that you used. 

##### Submission File
For each ID in the test set, you must predict the class variable. The file should contain a header and have the following format:

id,class
validation.73749.au,disco

validation.76427.au,blues

validation.76541.au,rock

validation.77219.au,jazz

validation.79401.au,classical
