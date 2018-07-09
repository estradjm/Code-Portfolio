#!/usr/bin/python3
# vim: expandtab softtabstop=4 shiftwidth=4 foldmethod=marker
# --------------------------------------------------------------------------------------------------
# * @file:      tree.py
# * @authors:    George Sparrow and Jenniffer Estrada  
# * @date:      
# *  Created:       Sunday, September 17, 2017
# *  Last Update:   Tuesday, September 28, 2017
# * Language:       Python
# * Course:         Machine Learning
# * Assignment:     Project 1
# * Description:    Contains the implementation of the Tree class
# --------------------------------------------------------------------------------------------------

import sys
import csv
import random
import pdb #for debugging
import math
import random

class Tree(object):
    """ Docstring Placeholder """
    def __init__(self):
        self.left = None
        self.right = None
        self.data = []
        self.headers = []
        self.chi_squared_headers = []
        self.chi_squared_data = []
        self.comparator = []

    def copy_tree(self, copy_from):
        self.headers=copy_from.headers
        self.chi_squared_headers=copy_from.chi_squared_headers
        self.chi_squared_data=copy_from.chi_squared_data

    def file_read(self, filename, header): #{{{
        """ reads in a csv file and parses it according to Kaggle data format or other data used for algorithm validation """
        with open(filename) as csvfile: # Contains a header (test datasets we created for validation)
            if (header == 1):
                reader = csv.DictReader(csvfile)
            else: # Doesn't have a header and using the data on Kaggle
                reader = csv.DictReader(csvfile, fieldnames=("ID","Sequence","Class"))
            self.headers = reader.fieldnames
            forma = 1
            for row in reader:
                if (forma == 1):
                # DNSR values their own attribute
                # Pick up sequence value and parse it for each occurance of each field
                    sequence = row['Sequence']
                    sdata = list(sequence)
                    sequence_set = {"A","G","T","C","D","N","S","R"}
                    sequence_counts = dict.fromkeys(sequence_set, 0)
                    for items in sequence:
                        sequence_counts[items] = sequence_counts.get(items) + 1
                    row = dict(list(row.items()) + list(sequence_counts.items()))
                    row.pop('Sequence',None)
                    self.data.append(row)
                    self.headers = "ID","A","G","T","C","D","N","S","R","Class"
                elif (forma == 2):
                    # Replacing D=T;N=A;S=C;R=G;
                    sequence = row['Sequence']
                    sdata = list(sequence)
                    sequence_set = {"A","G","T","C"}
                    sequence_counts = dict.fromkeys(sequence_set, 0)
                    for items in sequence:
                        if (items == 'D'):
                            items = 'T'
                        elif (items == 'N'):
                            items = 'A'
                        elif (items == 'S'):
                            items = 'C'
                        elif (items == 'R'):
                            items = 'G'
                        sequence_counts[items] = sequence_counts.get(items) + 1
                    row = dict(list(row.items()) + list(sequence_counts.items()))
                    row.pop('Sequence',None)
                    self.data.append(row)
                    self.headers = "ID","A","G","T","C","Class"
                elif (forma == 3):
                # Randomly replacing based on possible values per each ambiguous value
                    sequence = row['Sequence']
                    sdata = list(sequence)
                    sequence_set = {"A","G","T","C"}
                    sequence_counts = dict.fromkeys(sequence_set, 0)
                    for items in sequence:
                        if (items == 'D'):
                            n = random.randint(0,2)
                            if (n == 0):
                                items = 'A'
                            elif (n == 1):
                                items = 'G'
                            else:
                                items = 'T'
                        elif (items == 'N'):
                            n = random.randint(0,3)
                            if (n == 0):
                                items = 'A'
                            elif (n == 1):
                                items = 'G'
                            elif (n == 2):
                                items = 'C'
                            else:
                                items = 'T'
                        elif (items == 'S'):
                            n = random.randint(0,1)
                            if (n == 0):
                                items = 'C'
                            else:
                                items = 'G'
                        elif (items == 'R'):
                            n = random.randint(0,1)
                            if (n == 0):
                                items = 'A'
                            else:
                                items = 'G'
                        sequence_counts[items] = sequence_counts.get(items) + 1
                    row = dict(list(row.items()) + list(sequence_counts.items()))
                    row.pop('Sequence',None)
                    self.data.append(row)
                    self.headers = "ID","A","G","T","C","Class"
                elif (forma == 4):
                # Replacing possible values for each ambigious value based on gaussian distribution
                    sequence = row['Sequence']
                    sdata = list(sequence)
                    sequence_set = {"A","G","T","C"}
                    sequence_counts = dict.fromkeys(sequence_set, 0)
                    for items in sequence:
                        sequence_counts[items] = sequence_counts.get(items) + 1
                    row = dict(list(row.items()) + list(sequence_counts.items()))
                    row.pop('Sequence',None)
                    self.data.append(row)
                    self.headers = "ID","A","G","T","C","Class"
        return
        #}}} 

    def chi_squared_read(self, filename): #{{{
        """ Docstring Placeholder """
        with open(filename) as csvfile:
            reader = csv.DictReader(csvfile)
            self.chi_squared_headers = reader.fieldnames
            for row in reader:
                self.chi_squared_data.append(row)
        for row in self.chi_squared_data:
            for column in row:
                row[column] = float(row.get(column))
    # }}}

    # Write File Output functions {{{
    def file_write_inorder(self, filename):
        """ Docstring Placeholder """
        if (self.left):
            self.left.file_write_inorder(filename)
        with open(filename, 'a') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=self.headers)
            writer.writeheader()
            for datum in self.data:
                writer.writerow(datum)
            csvfile.write( "\n" )
        if (self.right):
            self.right.file_write_inorder(filename)

    def file_write_preorder(self, filename):
        """ Docstring Placeholder """
        with open(filename, 'a') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=self.headers)
            writer.writeheader()
            for datum in self.data:
                writer.writerow(datum)
            csvfile.write("\n" )
        if (self.left):
            self.left.file_write_preorder(filename)
        if (self.right):
            self.right.file_write_preorder(filename)

    def file_write_postorder(self, filename):
        """ Docstring Placeholder """
        if (self.left):
            self.left.file_write_postorder(filename)
        if (self.right):
            self.right.file_write_postorder(filename)
        with open(filename, 'a') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=self.headers)
            writer.writeheader()
            for datum in self.data:
                writer.writerow(datum)
            csvfile.write("\n" )

    def file_write(self, filename):
        """ Docstring Placeholder """
        self.file_write_inorder(filename)
    # }}}

    # Write stdout Output functions {{{
    def write_inorder(self):
        """ Docstring Placeholder """
        if (self.left):
            self.left.write()
        sys.stdout.write(str(self.comparator) + "\n")
        for datum in self.data:
            sys.stdout.write(str(datum) + "\n")
        print
        if (self.right):
            self.right.write()

    def write_preorder(self):
        """ Docstring Placeholder """
        for datum in self.data:
            sys.stdout.write(str(datum) + "\n")
        print
        if (self.left):
            self.left.write()
        if (self.right):
            self.right.write()

    def write_postorder(self):
        """ Docstring Placeholder """
        if (self.left):
            self.left.write()
        if (self.right):
            self.right.write()
        for datum in self.data:
            sys.stdout.write(str(datum) + "\n")
        print

    def write(self):
        """ Docstring Placeholder """
        self.write_inorder()
    # }}}

    def add_data(self, datum): #{{{
        """ Docstring Placeholder """
        self.data.append(datum)
    # }}}

    def compute_max_information_gain(self, classifier): # {{{
        data_matrix_dictionary={}
        data_matrix=[]
        temp_list=[]
        attribute_values_set = set()
        attribute_split_values_set = set()
        max_information_gain = 0.0
        temp_split=0.0
        temp_maximum=0.0
        temp_attribute = ""
        if (self.data):
            temp_attribute_list = self.data[0].keys()
            temp_attribute_list.remove(classifier) #list of all attributes except the classifier
            temp_attribute_list.remove('ID') #list of all attributes except the classifier and the unique identifier
            data_matrix_dictionary=dict.fromkeys(temp_attribute_list)
            for key in data_matrix_dictionary.keys():
                attribute_values_set=0.0
                attribute_split_values_set=0.0
                attribute_values_set = set()
                attribute_split_values_set = set()
                for datum in self.data:
                    attribute_values_set.add(datum.get(key))
                for i in range(1, len(attribute_values_set)):
                    attribute_split_values_set.add(float(float(abs(float(sorted(attribute_values_set)[i-1])+(float(sorted(attribute_values_set)[i]))))/2.0))
                data_matrix_dictionary[key]=dict.fromkeys(attribute_split_values_set, 0.0)
            #print data_matrix_dictionary
            for attribute in data_matrix_dictionary.keys():
                for key in data_matrix_dictionary[attribute].keys():
                    data_matrix_dictionary[attribute][key]=self.compute_information_gain(classifier, attribute, key)
            #print data_matrix_dictionary
            for attribute in data_matrix_dictionary.keys():
                for key in data_matrix_dictionary[attribute].keys():
                    if (data_matrix_dictionary[attribute][key] > temp_maximum):
                        temp_maximum = data_matrix_dictionary[attribute][key]
                        temp_split = key
                        temp_attribute = attribute
            #print {temp_attribute: temp_split}
            return {temp_attribute: temp_split}
    #}}}
            
    def compute_information_gain(self, classifier, attribute, split): #{{{
        attribute_values_count = {} #counts of the classification values
        attribute_values_set = set()
        forest =[]
        forest.append(Tree())
        forest.append(Tree())
        entropy_summation = 0.0
        for datum in self.data:                                             #from the values of the classifier, create a set
            attribute_values_set.add(datum.get(attribute)) 
        attribute_values_count = dict.fromkeys(attribute_values_set, 0)   #from the set of classifier values, create a dictionary for counting them
        #for tree in forest:
        #    forest[tree] = Tree()
        #print forest.keys()
        #print forest.values()
        for datum in self.data:
            #print datum.get(attribute)
            if (datum.get(attribute) < split):
                forest[0].add_data(datum)
            else:
                forest[1].add_data(datum) 
            attribute_values_count[datum.get(attribute)] += 1
        for tree in forest:
            #forest[tree].write()
            #print forest[tree]
            #print "tree subset base entropy"
            #print forest[tree].base_entropy(classifier)
            entropy_summation += (float(float(len(tree.data))/(float(len(self.data)))))*tree.base_entropy(classifier)
        #print "entropy_summation"
        #print entropy_summation
        #return entropy_summation
        return ((self.base_entropy(classifier))-entropy_summation)
    #}}}

    def base_entropy(self, classifier): #evaluates the base information gain, from which other values are subtracted #{{{
        """ Docstring Placeholder """
        classifier_values_count = {} #counts of the classification values
        classifier_values_set = set()
        information_gain=0.0
        for datum in self.data:                                             #from the values of the classifier, create a set
            classifier_values_set.add(datum.get(classifier))
        classifier_values_count = dict.fromkeys(classifier_values_set, 0)   #from the set of classifier values, create a dictionary for counting them
        for datum in self.data:
            classifier_values_count[datum.get(classifier)] += 1
        #print classifier_values_count
        for key in classifier_values_count.keys():
            temp_information_gain = 0.0
            temp_information_gain_2 = 0.0
            temp_information_gain = float((float(classifier_values_count.get(key)))/(float(len(self.data))))
            #print temp_information_gain
            temp_information_gain_2 = -math.log(temp_information_gain,2)
            #print "temp_information_gain_2"
            #print temp_information_gain_2
            temp_information_gain = temp_information_gain*temp_information_gain_2
            #print "temp_information_gain"
            #print temp_information_gain
            information_gain += temp_information_gain
        return information_gain
    # }}} 

    def chi_squared(self, attribute, probability): #{{{
        """ Docstring Placeholder """
        attribute_values_count = {} #counts of the attribute values
        attribute_values_set = set() #holds both the degrees of freedom, and helps calculate the expected value
        degrees_of_freedom = 0
        expected_value = 0.0
        critical_value = 0.0 #from the chi_squared csv
        temp_value = 0.0
        chi_squared_value = 0.0
        if (len(self.data) < 2):
            return True
        for datum in self.data:
            attribute_values_set.add(datum.get(attribute))
        attribute_values_count = dict.fromkeys(attribute_values_set, 0)
        #print attribute_values_set
        for datum in self.data:
            attribute_values_count[datum.get(attribute)] += 1
        degrees_of_freedom = ((len(attribute_values_set))-1)
        # Large if statement to prevent going out of bounds of the array for large degrees of freedom {{{ {{{
        #   If more accuracy is needed, a replacement of the csv containing the chi squared table with
        #   a more fine-grained chi squared table with more values and more degrees of freedom
        #   Because we do not have an infinitely defined chi squared table and are not allowed functions
        #   to calculate such a thing from mathematicians who knew what they were doing, the simplest
        #   solution is to simply use rounding. This should produce a good enough approximation. }}}
        if (degrees_of_freedom <= 0): 
            degrees_of_freedom = 1
        elif ((degrees_of_freedom > 30) and (degrees_of_freedom <= 35)): 
            degrees_of_freedom = 30
        elif ((degrees_of_freedom > 35) and (degrees_of_freedom <= 45)):
            degrees_of_freedom = 31
        elif ((degrees_of_freedom > 45) and (degrees_of_freedom <= 55)):
            degrees_of_freedom = 32
        elif ((degrees_of_freedom > 55) and (degrees_of_freedom <= 65)):
            degrees_of_freedom = 33
        elif ((degrees_of_freedom > 65) and (degrees_of_freedom <= 75)):
            degrees_of_freedom = 34
        elif ((degrees_of_freedom > 75) and (degrees_of_freedom <= 85)):
            degrees_of_freedom = 35
        elif ((degrees_of_freedom > 85) and (degrees_of_freedom <= 95)):
            degrees_of_freedom = 36
        elif (degrees_of_freedom > 95):
            degrees_of_freedom = 37
        # }}}
        #print degrees_of_freedom
        expected_value = float(float(len(self.data))/float(len(attribute_values_set)))
        #print expected_value
        for key in attribute_values_count.keys():
            temp_value = float(expected_value) - float(attribute_values_count.get(key))
            #print "Expected value"
            #print expected_value
            #print "actual value"
            #print float(attribute_values_count.get(key))
            #print "Temp value"
            #print temp_value
            temp_value = float(temp_value * temp_value)
            #print "Temp value"
            #print temp_value
            temp_value = float(temp_value/expected_value)
            #print "Temp value"
            #print temp_value
            chi_squared_value += temp_value
        #degrees_of_freedom = 20
        #print degrees_of_freedom
        if (degrees_of_freedom-1) < len(self.chi_squared_data):
            if (degrees_of_freedom-1)>= 0:
                critical_value = self.chi_squared_data[(degrees_of_freedom-1)].get(probability)
                print critical_value
            else:
                return true
        else:
            #print degrees_of_freedom
            return True
        #print critical_value
        #print chi_squared_value
        if (critical_value >= chi_squared_value):
            print "True"
            return True #Null hypothesis is correct
        else:
            print "False"
            return False #Null hypothesis is rejected
    #}}}

    def choose_comparator(self, classifier): #{{{
        """ Docstring Placeholder """
        same = True
        temp_headers = []
        classifier_values_set = set()
        for datum in self.data:
            classifier_values_set.add(datum.get(classifier))
        if (self.data):
            for datum in self.data:
                classifier_values_set.add(datum.get(classifier))
            if (self.chi_squared(classifier, '0.050')):
                self.comparator = 'True'
                return
            else:
                self.comparator = self.compute_max_information_gain(classifier) #this will compute the information gain and use its attribute as its comparator
                #print str(self.compute_max_information_gain(classifier))
                #temp_headers=self.data[0].keys()
                #temp_headers.remove(classifier)
                #self.comparator=random.choice(temp_headers) #this is what chooses the comparator of the node, in this case psuedorandomness
                self.left = Tree()
                self.left.copy_tree(self)
                self.right = Tree()
                self.right.copy_tree(self)
                while (self.data):
                    if (self.data[0].get(self.comparator.keys()[0]) < self.comparator.values()[0]):
                        self.left.add_data(self.data[0])
                        self.data.remove(self.data[0])
                    else:
                        self.right.add_data(self.data[0])
                        self.data.remove(self.data[0])
                self.left.choose_comparator(classifier)
                self.right.choose_comparator(classifier)
        else: #an error has occured, there is no data in this leaf
            return
# }}}

    def base_gini_index(self, classifier): # Evaluates the system gini index #{{{
        """ Docstring Placeholder """
        classifier_values_count = {} # Counts of the classification values
        classifier_values_set = set()
        system_gini_value = 0.0
        for datum in self.data:                                             # From the values of the classifier, create a set
            classifier_values_set.add(datum.get(classifier))
        classifier_values_count = dict.fromkeys(classifier_values_set, 0)   # From the set of classifier values, create a dictionary for counting them
        for datum in self.data:
            classifier_values_count[datum.get(classifier)] += 1
        for key in classifier_values_count.keys():
            temp_gini_value = 0.0
            temp_system_value = 0.0
            temp_system_value = float((float(classifier_values_count.get(key)))/(float(len(self.data))))
            temp_gini_value += float(float(temp_system_value) ** float(2.0))
        system_gini_value = float(float(1.0) - float(temp_gini_value))
        return system_gini_value
    # }}}

    def attribute_impurity(self, classifier, attribute): # Calculates the gini index value for a particular attribute #{{{
        """ Calculates the Gini Index for an attribute """
        attribute_values_count = {} # Counts of the classification values
        attribute_values_set = set()
        attr_class_values_count = {} # Counts of the class values
        attr_class_values_set = set()
        forest = {}
        gini_summation = 0.0
        for datum in self.data:                                             # From the values of the classifier, create a set
            attribute_values_set.add(datum.get(attribute))
            attr_class_values_set.add(datum.get(classifier))
        print "Attribute value set"
        print attribute_values_set
        print "class Attribute value set"
        print attr_class_values_set

        attribute_values_count = dict.fromkeys(attribute_values_set, 0)   # From the set of classifier values, create a dictionary for counting them
        attr_class_values_count = dict.fromkeys(attr_class_values_set, 0)   # From the set of classifier values, create a dictionary for counting them
        for datum in self.data:
            attribute_values_count[datum.get(attribute)] += 1
            attr_class_values_count[datum.get(classifier)] += 1
        print "Attribute value counts"
        print attribute_values_count
        print "class Attribute value counts"
        print attr_class_values_count
        print "length of data"
        print float(len(self.data))
        temp_gini_index = 0.0
        for key in attribute_values_count.keys():
            print "Key"
            print key
            print "counts"
            print attr_class_values_count.get(key)
            temp_gini_index += float(((float(attr_class_values_count.get(key)))/(float(len(self.data)))))**2.0
            gini_summation = temp_gini_index
        gini_index = 1-gini_summation
        print gini_index
        return gini_index
        # }}}

    def predict(self, classifier, datum): #Predicts the classifier of a datum {{{
        if (self.left):
            if (int(datum.get(self.comparator)) == 1):
                return self.left.predict(datum)
            else:
                return self.right.predict(datum)
        else:
            classifier_values_count = {} #counts of the classification values
            classifier_values_set = set()
            data_value =0
            for datum in self.data:                                             #from the values of the classifier, create a set
                classifier_values_set.add(datum.get(classifier))
            classifier_values_count = dict.fromkeys(classifier_values_set, 0)   #from the set of classifier values, create a dictionary for counting them
            for datum in self.data:
                classifier_values_count[datum.get(classifier)] += 1
            for key in classifier_values_set.keys():
                if (classifier_values_set.get(key) > data_value):
                    data_value = classifier_values_set.get(key)
                    data_attribute = key
            return data_attribute
    # }}}

def main(): # Main function call #{{{
    """ Main Function call for testing Tree class
    my_file='altitude.csv'
    header = 1 # Turn this option on if there is a header in the csv being read!!!!
    class_label = 'Class'
    attribute = 'Direction'
"""

    my_file = 'training.csv'
    chi_squared_file='chisquared.csv'
    header = 0 # Turn this option on if there is a header in the csv being read!!!!
    class_label = 'Class'
    root = Tree()
    root.file_read(my_file, header)
    root.chi_squared_read(chi_squared_file)
    root.choose_comparator(class_label)
    root.file_write("output.dict")
  # 
   #my_file='training.csv'
    #my_file='photos.csv'
    #classifier='Class'
    #PROBABILITY='0.050'
    #root = Tree()
    #print root.chi_squared_headers
    #print root.chi_squared_data
    #root.write()
    #print root.chi_squared(classifier, PROBABILITY)
    #temp_classifier='Family'
    #print root.compute_max_information_gain(temp_classifier)
    #information_gain=root.information_gain(temp_classifier, 'Cartoon')
    #print (information_gain)
    #temp_classifier='Cartoon'
    #information_gain-=root.entropy(temp_classifier)
    #print (information_gain)
    #root.file_write("output.dict")
    #my_file='altitude.csv'
    #my_file = 'photos.csv'
    #classifier='Family'
    #root.choose_comparator(class_label)
    #root.write()
    #temp_classifier = 'Family'
    #class_label = 'Class'
    #attribute = 'Direction'
    #print root.compute_max_information_gain(class_label)
    #print information_gain=root.information_gain(classifier, attribute)
    #print (information_gain)
    #temp_classifier='Cartoon'
    #information_gain-=root.entropy(temp_classifier)
    #print (information_gain)
    #root.file_write("output.dict")
    #print '========================================'
    #print root.base_gini_index(class_label)
    print '========================================'
    #print root.attribute_impurity(class_label, attribute)
    #datum = {'key':'20000', 'value':'GCTGGGCCCTGGGCTTCTACCCTGCGGAGATCACACTGACCTGGCAGCGGGATGGCGAGG'}
    #print root.predict(class_label, datum)

if __name__ == "__main__":
    main()

