import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import matplotlib.pyplot as plt2
from scipy.interpolate import *
from pylab import *
from sklearn.model_selection import train_test_split
from termcolor import colored

X=[]
Y=[]
count = 0
print colored("Do you want to test the data","red")
print "============================"
print colored("If you want to test give input as number 1 or else give 0","green")
print "====================================="
print colored("Exampl==>Enter input::1","yellow")
test = input(colored("Enter input::","green"))
print colored("============================================","red")
num = int(raw_input(colored("Enter number to genrate the polynomial::","green")))
print colored("=========================================================","red")
print colored("Give labda as one (0) to perform simple linear regression ","blue")
print colored("==========================================================","green")
print colored("Give Lambda as other than one to perform ridge regression","red")
print "==========================================================="
lamda = input("Enter the Regularization Parameter::")

print "********************************************************"
print colored("Example Absolute Path /home/machine/Videos/Assignment-1/q16_1.txt","red")
print "================================================================="

file_path = raw_input("Enter file path::")
for line in open(file_path):
	#print line
	x1,y = line.split()
	x1=float(x1)
	z=[]
	for i in range(0,num+1):
		z.append(x1**i)
	X.append(z)
	Y.append(float(y))
	count+=1
#print count

X=np.array(X)
#print X
Y=np.array(Y)


X_train_V, X_test, y_train_V, y_test = train_test_split(X, Y, test_size=0.1, random_state=42)
X_train, X_validate, y_train, y_validate = train_test_split(X_train_V, y_train_V, test_size=0.22, random_state=42)
#print X[1:100:,1]
#print Y[1:100]

x_t_x_train = np.dot(X_train.T,X_train) 
dime = x_t_x_train.shape
I = np.identity(dime[0])




#sort the arrays according to the first column
X1_train =  X_train[np.argsort(X_train[:,1])];
X1_test =  X_test[np.argsort(X_test[:,1])];
X1_validate =  X_validate[np.argsort(X_validate[:,1])];

#calculating the weight matrix
w = np.linalg.solve((np.dot(X_train.T, X_train)+lamda*I), np.dot(X_train.T, y_train))
#save it into file
np.savetxt('1d_'+str(num)+'_weights.txt', w) 



Yhat_without_sort = np.dot(X_train, w)
Yhat = np.dot(X1_train, w)
#fo.close()
#print y_prediction

#predict the data for test data
Yhat_test = np.dot(X1_test,w)
Yhat_test_without_sorted = np.dot(X_test,w)

Yhat_valid = np.dot(X1_validate,w)
Yhat_valid_without_sorted = np.dot(X_validate,w)

if(test!=1):

	d1 = y_train - Yhat_without_sort
	d2 = y_train - y_train.mean()
	r2 = 1 - d1.dot(d1) / d2.dot(d2)
	print "the r-squared for training data is:", r2

	d1_test = y_test - Yhat_test_without_sorted
	d2_test = y_test - y_test.mean()
	r2_test = 1 - d1_test.dot(d1_test) / d2_test.dot(d2_test)
	print "the r-squared for test data is:", r2_test


	d1_valid = y_validate - Yhat_valid_without_sorted
	d2_valid = y_validate - y_validate.mean()
	r2_valid = 1 - d1_valid.dot(d1_valid) / d2_valid.dot(d2_valid)
	print "the r-squared for validation data is:", r2_valid



	#print d1[1:5]

	#d1 = d1**2
	#print d1[1:5]
	d1_valid = d1_valid.dot(d1_valid)
	#d1_valid=np.sum(d1_valid)
	shape= y_validate.shape
	error=d1_valid/2
	print "error in validation is::",error
	#print shape[0]
	d1_valid=d1_valid/shape[0]
	#print d1_valid
	rmsd = sqrt(d1_valid)
	print "root mean squared error for Validation Data",rmsd
	
	
	plt2.scatter(X_train[:,1],y_train)
	plt2.plot(sorted(X_train[:,1]),sorted(Yhat),'--r',label="Trained Model" )
	plt2.title("Model fitting")
	plt2.xlabel("Input Feature X")
	plt2.ylabel("Output Y")
	plt2.legend()
	plt2.show()
	

	plt.scatter(X_test[:,1],y_test)
	plt.plot(sorted(X_test[:,1]), (y_test) , '-g' , label = "TestData")  # solid green
	plt.plot(sorted(X_test[:,1]), (Yhat_test_without_sorted), '--r',label="Predicted Data")
	plt.title("Test Data vs Predicted Data")
	plt.xlabel("Input Feature X")
	plt.ylabel("Output Y")
	plt.legend()
	plt.show()

	
else:
	X_T=X
	Y_T=Y
	w_t = []
	for line in open('2d_4_weights.txt'):
		w_t.append(float(line))
	w_t = np.array(w_t)
	X1_test =  X_T[np.argsort(X_T[:,1])];
	Yhat_custom_test = np.dot(X1_test,w_t)
	Yhat_custom_test_without_sorted = np.dot(X_T,w_t)
	plt.scatter(X_T[:,1],Y_T)
	plt.plot(sorted(X_T[:,1]), sorted(Y_T) , '-g' , label = "TestData")  # solid green
	plt.plot(sorted(X_T[:,1]), sorted(Yhat_custom_test_without_sorted), '--r',label="Predicted Data")
	plt.title("Test Data vs Predicted Data")
	plt.xlabel("Input Feature")
	plt.ylabel("Output")
	plt.legend()
	plt.show()