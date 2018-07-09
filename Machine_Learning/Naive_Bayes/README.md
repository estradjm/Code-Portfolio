# CS529 Machine Learning: Project 2: Document Classification with Naive Bayes

### Author: Jenniffer Estrada
### Professor: Dr. Trilce Estrada-Piedra
### University of New Mexico, Fall 2017

Website: https://www.kaggle.com/c/cs529-project2

## Description:
This program is used to contruct an Naive Bayes classifier 

## Required Software:
- 

## To run:

## Report:
https://www.sharelatex.com/read/yjmcrngpwgvw


### Assignment Instructions:
Your task is to implement Naive Bayes for document classification as specified in your project description. The 20 Newsgroups dataset is a collection of approximately 20,000 newsgroup documents, partitioned (nearly) evenly across 20 different newsgroups. The 20 newsgroups collection has become a popular dataset for experiments in text applications of machine learning techniques, such as text classification and text clustering.

#### Turn in the following:

Your code. Submit your file through UNM Learn. The due date is Midnight (+ 3 hrs buffer) contingent to the late policy stated in the syllabus. Your code should contain appropriate comments to facilitate understanding. If needed, your code must contain a Makefile or an executable script that receives the paths to the training and testing files

A report of about 4 to 10 pages that includes: 
- A high-level description of how your code works.
- The accuracies you obtain under various settings.
- Explain which options work well and why.
- Answers to questions 1 to 7 

#### Rubric:
- Your code is thoroughly commented (10 pts)
- You provided a README file (5 pts)
- Your code executes correctly and is platform independent and you provided a Makefile or script for execution and clear instructions for execution are provided in the README file (20 pts)
- Implementation of NB is correct (15 pts)
- Your report is clear, concise and well organized (10 pts)
- Your answers to questions 1 to 7 (40 pts)
- TOTAL: 100 pts (10 pts of your final grade)

#### Acknowledgments:
Dataset obtained from 20Newsgroups http://qwone.com/~jason/20Newsgroups/

#### Data:
The data ﬁle (available on UNM Learn and the Kaggle competition) contains four ﬁles:

##### vocabulary.txt 
a list of the words that may appear in documents. The line number is word’s d in other ﬁles. That is, the ﬁrst word (’archive’) has wordId 1, the second (’name’) has wordId 2, etc.

##### newsgrouplabels.txt
a list of newsgroups from which a document may have come. Again, the line number corresponds to the label’s id, which is used in the .label ﬁles. The ﬁrst line (’alt.atheism’) has id 1, etc.

##### training.csv 
Speciﬁes the counts for each of the words used in each of the documents. Each line contains 61190 elements. The first element is the document id, the elements 2 to 61189 are word counts for a vectorized representation of words (refer to the vocabulary for a mapping). The last element is the class of the document (20 different classes). All word/document pairs that do not appear in the ﬁle have count 0.

##### testing.csv 
The same as training.csv except that it does not contain the last element.

##### sample_solution.csv 
Contains a dummy solution file in the correct format

#### Data fields:

*position 1 * _- document_id

*position 2 to position 61189 *_ - count for word xi

*position 61190 *_- class


#### Evaluation:
The evaluation metric for this competition is the accuracy classification score. It is the number of correct predictions made divided by the total number of predictions. Upload in the competition your predictions that reach the best accuracy and specify the parameters that you used. 

#### Submission File:
For each ID in the test set, you must predict a probability for the class variable. The file should contain a header and have the following format:
id,class

12001,1

12002,1

12003,1

12004,1

12005,1
