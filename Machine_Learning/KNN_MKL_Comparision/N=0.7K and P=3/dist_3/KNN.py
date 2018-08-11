import numpy as np
import scipy.io
from sklearn.neighbors import KNeighborsClassifier

K = 3

def calAccuracy(actualLabel, predictedLabel):
    count = 0
    row = len(actualLabel)
    for i in range(0,row):
        if(actualLabel[i] == predictedLabel[i]):
            count += 1
    return count/row


def loadData():
    
    class1_train = scipy.io.loadmat('class1_train.mat')['class1_train']
    class2_train = scipy.io.loadmat('class2_train.mat')['class2_train']
    class1_test = scipy.io.loadmat('class1_test.mat')['class1_test']
    class2_test = scipy.io.loadmat('class2_test.mat')['class2_test']
    size = 500 # training sample size of each class
    trainingSet = np.concatenate((class1_train[0:size,:], class2_train[0:size,:])) #Train Data 
    valSet = np.concatenate((class1_train[size:,:], class2_train[size:,:])) # Validation data 
    testSet = np.concatenate((class1_test[:,:], class2_test[:,:])) # Test Data
    trainingLabel = np.array([0 if i<(trainingSet.shape[0]/2) else 1 for i in range(trainingSet.shape[0])])
    valLabel = np.array([0 if i<(valSet.shape[0]/2) else 1 for i in range(valSet.shape[0])])
    testLabel = np.array([0 if i<(testSet.shape[0]/2) else 1 for i in range(testSet.shape[0])])
    return [trainingSet, trainingLabel, valSet, valLabel, testSet, testLabel]


def doKNN():
    trainingSet, trainingLabel, valSet, valLabel, testSet, testLabel = loadData()
    for K in range(1,40):
        knn = KNeighborsClassifier(n_neighbors=K,algorithm = 'kd_tree')
        knn.fit(trainingSet, trainingLabel)
        predicted_valLabel = knn.predict(valSet)
        predicted_testLabel = knn.predict(testSet)
        val_accuracy = calAccuracy(valLabel, predicted_valLabel)
        test_accuracy = calAccuracy(testLabel, predicted_testLabel)
        #print("Train Size is: ",trainingSet.shape[0])
        #print("Validation Size is: ",valSet.shape[0])
        #print("Validation Accuracy is: ",val_accuracy*100)
        #print("Test Size is: ",testSet.shape[0])
        print("Test Accuracy is: ",test_accuracy*100)
    
doKNN()