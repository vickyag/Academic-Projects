import pandas as pd
import numpy as np
import math
import matplotlib.pyplot as plt
import argparse as ap
import warnings

warnings.filterwarnings("ignore")

# Defining command line arguements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parser = ap.ArgumentParser()
parser.add_argument('--lr', help="initial learning rate for gradient descent based algorithms", type=float, default=0.01)
parser.add_argument('--momentum', help="momentum to be used by momentum based algorithms", type=float, default=0.5)
parser.add_argument('--num_hidden', help="number of hidden layers - this does not include the 784 dimensional\
											input layer and the 10 dimensional output layer", type=int, default=3)
parser.add_argument('--sizes', help="a comma separated list for the size of each hidden layer", default='100,100,100')
parser.add_argument('--activation', help="the choice of activation function - valid values are tanh/sigmoid", default='sigmoid')
parser.add_argument('--loss', help="possible choices are squared error[sq] or cross entropy loss[ce]", default='ce')
parser.add_argument('--opt', help="the optimization algorithm to be used: gd, momentum, nag, adam - you will be\
									implementing the mini-batch version of these algorithms", default='gd')
parser.add_argument('--batch_size', help="the batch size to be used - valid values are 1 and multiples of 5", type=int, default=20)
parser.add_argument('--anneal', help="if true the algorithm should halve the learning rate if at any epoch the vali-\
										dation loss decreases and then restart that epoch", default='false')
parser.add_argument('--save_dir', help="the directory in which the pickled model should be saved - by model we\
										mean all the weights and biases of the network", default='pa1/')
parser.add_argument('--expt_dir', help="the directory in which the train and validation log files will be saved", default='pa1/exp1/')
parser.add_argument('--train', help="path to the Training dataset", default='train.csv')
parser.add_argument('--test', help="path to the Test dataset", default='test.csv')
parser.add_argument('--val', help="path to the Validation dataset", default='val.csv')
parser.add_argument('--max_epochs', help="epochs specifies number of times to go over whole data during training", type=int, default=20)
parser.add_argument('--pretrain', help="Load and run using pretrain model", default='false')

# Parsing command line arguements/HyperParameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
args = parser.parse_args()
lr = args.lr
momentum = args.momentum
num_hidden = args.num_hidden
size_ip = 784
size_op = 10
sizes = [int(num) for num in args.sizes.split(',')]
sizes.insert(0, 784) #inserting size of input layer at position 0
sizes.insert(len(sizes), 10) #inserting size of output layer at last position
L = num_hidden + 1
activation = args.activation
loss = args.loss
opt = args.opt
batch_size, max_epochs = args.batch_size, args.max_epochs
anneal = args.anneal
save_dir = args.save_dir
expt_dir =  args.expt_dir
train_file_dir = args.train
test_file_dir = args.test
val_file_dir = args.val
pretrain = args.pretrain

# Utility functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
def sigmoid(z):
	return 1.0/(1.0 + np.exp(-z))

def tanh(z):
	return (np.exp(z)-np.exp(-z))/(np.exp(z)+np.exp(-z))

def dsigmoid(z): # Derivative of sigmoid function
	return sigmoid(z)*(1.0 - sigmoid(z))
		
def dtanh(z): # Derivative of tanh function
	return (1.0 - tanh(z)**2)

def softmax(z):
	return np.exp(z)/np.sum(np.exp(z), axis = 0)

def cross_entropy(z):
	return -1*np.log2(z)

def one_hot(label, n_col): # Convert a label to a vector containing all 0's but label row as 1.
	y = np.zeros((size_op, n_col))
	y[label, np.arange(n_col)] = 1
	return y

def normalise_data(ip): # make mean = 0 and variance = 1 of each feature of the data
   ip_std = np.std(ip, axis=0)
   ip_mean = np.mean(ip, axis=0)
   ip = np.divide(np.subtract(ip, ip_mean), ip_std)
   return ip

# Training the Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
def cal_loss(data, labels, weights, biases): 
	"""This func calculates cross entropy loss and squared error loss as specified in loss parameter"""
	a, h = forward(weights, biases, data, isVector = 0)
	y_hat = h[L]
	y = one_hot(labels, data.shape[1])
	# Calculating Avg. Loss
	if(loss == 'ce'):
		total_loss = np.multiply(y, y_hat)
		total_loss = np.sum(total_loss, axis = 0)
		total_loss = cross_entropy(total_loss)
		total_loss = np.sum(total_loss)
	elif(loss == 'sq'):
		total_loss = y_hat-y
		total_loss = total_loss**2
		total_loss = np.sum(total_loss, axis = 0)
		total_loss = np.sum(total_loss)
	return total_loss/data.shape[1]

def cal_error(data, labels, weights, biases): 
	"""This func computes ratio of number of points getting misclassified to total number of points"""
	a, h = forward(weights, biases, data, isVector = 0)
	y_hat = h[L]
	predicted_labels = np.argmax(y_hat, axis = 0).T
	error = np.subtract(labels, predicted_labels)
	error = np.count_nonzero(error)/labels.size
	return error*100

def load_data(train_file_dir):
	"""This function loads data from .csv file stored on hard drive"""	
	train = pd.read_csv(train_file_dir)
	train_ip = np.array(train)
	actual_op = train_ip[:,-1].T
	train_ip = normalise_data(train_ip[:,1:-1]).T 
	return [train_ip, actual_op]

def initialize_wts():
	"""This fun intializes the weights and biases used for training the model"""
	np.random.seed(1234)
	biases = [np.random.rand(y, 1)*2-1 for y in sizes[1:]]
	weights = [np.random.rand(x, y)*2-1 for x, y in zip(sizes[1:], sizes[:-1])]
	biases.insert(0, 0) # inserting 0 at 0th position as there is no weights biase at input layer(the 0th layer)
	weights.insert(0, 0)
	return [biases, weights]

def backprop(a, h, weights, y):
	""" This function calculate gradient for updating weights and biases at each layer wrt to given input to decrease final error.
	It calculates the gradients wrt to last layer first and then moves furthur layers in same order"""
	d_nabla_w = []
	d_nabla_b = []
	y_hat = h[L]
	if(loss == 'ce'): # gradient of loss(cross entropy) wrt to activation then pre-activation at output layer
		nabla_a = -1*np.subtract(y, y_hat) 
	elif(loss == 'sq'): # gradient of loss(squared error) wrt to activation then pre-activation at output layer
		nabla_a = [[np.sum(((y_hat-y)*y_hat)*(one_hot(j,1)-y_hat[j]))] for j in range(10)]
		nabla_a = 2*np.array(nabla_a)
	for k in range(L,0,-1):
		d_nabla_w.append(np.matmul(nabla_a, h[k-1].T)) # gradient wrt to weights at each layer
		d_nabla_b.append(nabla_a) # gradient wrt to biases at each layer
		nabla_h = np.matmul(weights[k].T, nabla_a) # gradient wrt to activation function at each hidden layer
		if(activation == 'sigmoid'): # gradient wrt to pre-activation function at each hidden layer
			nabla_a = np.multiply(nabla_h, dsigmoid(a[k-1]))
		elif(activation == 'tanh'):
			nabla_a = np.multiply(nabla_h, dtanh(a[k-1]))

	d_nabla_w.reverse()
	d_nabla_b.reverse()
	d_nabla_w.insert(0, 0)
	d_nabla_b.insert(0, 0)
	return [d_nabla_w, d_nabla_b]


def forward(weights, biases, h_initial, isVector = 1):
	"""This functons feeds weights and biases and propogate forward to calculate outputs corresponding to given input"""
	h = []
	a = []
	if(isVector):
		h_initial = np.array([[i] for i in h_initial])	
	a.append(0)
	h.append(h_initial)
	for k in range(1,L,1):
		a.append(np.matmul(weights[k], h[k-1]) + biases[k])
		if(activation == 'sigmoid'): # if sigmoid activation is used in hidden layers 
			h.append(sigmoid(a[k]))
		elif(activation == 'tanh'): # if tanh activation is used in hidden layers
			h.append(tanh(a[k]))

	a.append(np.matmul(weights[L], h[L-1]) + biases[L]) 
	h.append(softmax(a[L]))
	return [a, h]

def updates_from_batch(batch, biases, weights, label):
	"""This function returns gradients of entire batch to update actual baises and weights"""
	nabla_w = [np.zeros(element.shape) for element in weights[1:]]
	nabla_b = [np.zeros(element.shape) for element in biases[1:]]
	nabla_w.insert(0, 0)
	nabla_b.insert(0, 0)
	for col in range(batch.shape[1]):
	    # making 1-hot vector for each actual label
		y = one_hot(label[col], 1)
		# forward and backward propogation
		a, h = forward(weights, biases, batch[:,col])
		d_nabla_w, d_nabla_b = backprop(a, h, weights, y) # getting gradient wrt to each input vectors of entire batch
		# updating weights wrt each coloumn of current batch
		nabla_w = [i + j for i, j in zip(nabla_w, d_nabla_w)] # accumulating gradients wrt to each inputs to get gradient of entire batch
		nabla_b = [i + j for i, j in zip(nabla_b, d_nabla_b)]

	return [nabla_w, nabla_b] 


def batch_grad_desc():
	"""Batch Gradient Descent"""
	previous_val_error = 100
	lr = args.lr
	[biases, weights] = initialize_wts()
	[data, labels] = load_data(train_file_dir) # loading training data
	[val_data, val_labels] = load_data(val_file_dir) #loading validation data
	batches = [data[:, i:i+batch_size] for i in range(0,data.shape[1],batch_size)] # dividing data into batches
	labels_batches = [labels[i:i+batch_size] for i in range(0,labels.shape[0],batch_size)] # dividing labels into resp. batches as data
	log_train = open(expt_dir+'log_train.txt', 'w') # opening training log text file
	log_val = open(expt_dir+'log_val.txt', 'w') # opening validation log text file
	#epoch_val_file = open(expt_dir+'epoch_val_file.txt', 'w') # for epoch vs validation loss graph 
	#epoch_train_file = open(expt_dir+'epoch_train_file.txt', 'w') # for epoch vs train loss graph 
	epoch = 0
	while (epoch < max_epochs):
		step = 0
		history_anneal_params = [weights, biases]
		for batch, label in zip(batches, labels_batches):
			nabla_w, nabla_b = updates_from_batch(batch, biases, weights, label)
			#updating weights wrt to each batch
			weights = [i - (lr / batch.shape[1])*j for i,j in zip(weights, nabla_w)]
			biases = [i - (lr / batch.shape[1])*j for i,j in zip(biases, nabla_b)]
			step += 1
			# Printing/Writing Training logs after 100 steps(or batches) in each epoch
			if(step % 100 == 0):
				training_loss = round(cal_loss(data, labels, weights, biases),2)
				training_error = round(cal_error(data, labels, weights, biases),2)
				train_log_line = "Epoch "+str(epoch)+", Step "+str(step)+", Loss: "+str(training_loss)+", Error: "+str(training_error)+", lr: "+str(lr)
				log_train.write("%s\n"%train_log_line) # writng train log to file
				print("Train: "+train_log_line)
		# Printing/Writing Validation logs after each epoch
		validation_loss = round(cal_loss(val_data, val_labels, weights, biases),2)
		validation_error = round(cal_error(val_data, val_labels, weights, biases),2)
		val_log_line = "Epoch "+str(epoch)+", Loss: "+str(validation_loss)+", Error: "+str(validation_error)+", lr: "+str(lr)
		log_val.write("%s\n"%val_log_line) # writng validation log to file
		#epoch_val_file.write("%f %f\n"%(epoch, validation_loss))
		print("--------------------------------------------------------------------------------------------------------------------")
		print("Validation: "+val_log_line)	
		print("--------------------------------------------------------------------------------------------------------------------")	
		if(validation_error < 15.0):
			# Saving model as a pickle when val error is less than
			model = {'weights': weights, 'biases': biases}
			model = pd.DataFrame(model)
			model.to_pickle(save_dir + "model")
			run_test()
		# Going back and running again the same epoch if validation loss decreases ,done to avoid overfitting
		if(anneal == 'true'):
			if(validation_error > previous_val_error):
				epoch -= 1
				lr /= 2
				weights, biases = history_anneal_params[0],history_anneal_params[1]
				print("Running annealed epoch with halved learning rate")
		if(validation_error < previous_val_error):
			previous_val_error = validation_error

		#epoch_train_file.write("%f %f\n"%(epoch, round(cal_loss(data, labels, weights, biases),2)))
		epoch += 1
	log_train.close() # closing training log text file
	log_val.close() # closing validation log text file
	#epoch_val_file.close()
	#epoch_train_file.close()  

def momentum_batch_grad_desc():
	"""Momentum based Batch Gradient Descent"""
	previous_val_error = 100	
	lr = args.lr
	[biases, weights] = initialize_wts()
	prev_v_w = [np.zeros(element.shape) for element in weights[1:]]
	prev_v_b = [np.zeros(element.shape) for element in biases[1:]]
	prev_v_w.insert(0, 0)
	prev_v_b.insert(0, 0)
	[data, labels] = load_data(train_file_dir) # loading training data
	[val_data, val_labels] = load_data(val_file_dir) #loading validation data
	batches = [data[:, i:i+batch_size] for i in range(0,data.shape[1],batch_size)] # dividing data into batches
	labels_batches = [labels[i:i+batch_size] for i in range(0,labels.shape[0],batch_size)] # dividing labels into resp. batches as data
	log_train = open(expt_dir+'log_train.txt', 'w') # opening training log text file
	log_val = open(expt_dir+'log_val.txt', 'w') # opening validation log text file
	#epoch_val_file = open(expt_dir+'epoch_val_file.txt', 'w') # for epoch vs validation loss graph 
	#epoch_train_file = open(expt_dir+'epoch_train_file.txt', 'w') # for epoch vs train loss graph 
	epoch = 0
	while (epoch < max_epochs):
		step = 0
		history_anneal_params = [prev_v_w, prev_v_b, weights, biases]
		for batch, label in zip(batches, labels_batches):
			nabla_w, nabla_b = updates_from_batch(batch, biases, weights, label)
			#updating weights wrt to each batch
			v_w = [momentum*i + lr*j for i,j in zip(prev_v_w, nabla_w)]
			v_b = [momentum*i + lr*j for i,j in zip(prev_v_b, nabla_b)]
			weights = [i - j for i,j in zip(weights, v_w)]
			biases = [i - j for i,j in zip(biases, v_b)]
			prev_v_w = v_w[:]
			prev_v_b = v_b[:]
			step += 1
			# Printing/Writing Training logs after 100 steps(or batches) in each epoch
			if(step % 100 == 0):
				training_loss = round(cal_loss(data, labels, weights, biases),2)
				training_error = round(cal_error(data, labels, weights, biases),2)
				train_log_line = "Epoch "+str(epoch)+", Step "+str(step)+", Loss: "+str(training_loss)+", Error: "+str(training_error)+", lr: "+str(lr)
				log_train.write("%s\n"%train_log_line)
				print("Train: "+train_log_line)
		# Printing/Writing Validation logs after each epoch
		validation_loss = round(cal_loss(val_data, val_labels, weights, biases),2)
		validation_error = round(cal_error(val_data, val_labels, weights, biases),2)
		val_log_line = "Epoch "+str(epoch)+", Loss: "+str(validation_loss)+", Error: "+str(validation_error)+", lr: "+str(lr)
		log_val.write("%s\n"%val_log_line)
		#epoch_val_file.write("%f %f\n"%(epoch, validation_loss))
		print("--------------------------------------------------------------------------------------------------------------------")
		print("Validation: "+val_log_line)	
		print("--------------------------------------------------------------------------------------------------------------------")	
		if(validation_error < 15.0 ):
			# Saving model as a pickle
			model = {'weights': weights, 'biases': biases}
			model = pd.DataFrame(model)
			model.to_pickle(save_dir + "model")
			run_test()
		# Going back and running again the same epoch if validation loss decreases,done to avoid overfitting	
		if(anneal == 'true'):
			if(validation_error > previous_val_error):
				epoch -= 1
				lr /= 2
				prev_v_w, prev_v_b, weights, biases = history_anneal_params[0],history_anneal_params[1],history_anneal_params[2],history_anneal_params[3]
				print("Running annealed epoch with halved learning rate")
		if(validation_error < previous_val_error):
			previous_val_error = validation_error
		#epoch_train_file.write("%f %f\n"%(epoch, round(cal_loss(data, labels, weights, biases),2)))
		epoch += 1
	log_train.close() # closing training log text file
	log_val.close()	# closing validation log text file	
	#epoch_val_file.close()
	#epoch_train_file.close()	


def NAG_grad_desc():
	"""NAG based Batch Gradient Descent"""
	previous_val_error = 100	
	lr = args.lr
	[biases, weights] = initialize_wts()
	prev_v_w = [np.zeros(element.shape) for element in weights[1:]]
	prev_v_b = [np.zeros(element.shape) for element in biases[1:]]
	prev_v_w.insert(0, 0)
	prev_v_b.insert(0, 0)
	[data, labels] = load_data(train_file_dir) # loading training data
	[val_data, val_labels] = load_data(val_file_dir) #loading validation data
	batches = [data[:, i:i+batch_size] for i in range(0,data.shape[1],batch_size)] # dividing data into batches
	labels_batches = [labels[i:i+batch_size] for i in range(0,labels.shape[0],batch_size)] # dividing labels into resp. batches as data
	log_train = open(expt_dir+'log_train.txt', 'w') #opening training log text file
	log_val = open(expt_dir+'log_val.txt', 'w') #opening validation log text file
	#epoch_val_file = open(expt_dir+'epoch_val_file.txt', 'w') # for epoch vs validation loss graph 
	#epoch_train_file = open(expt_dir+'epoch_train_file.txt', 'w') # for epoch vs train loss graph 
	epoch = 0
	while (epoch < max_epochs):
		step = 0
		history_anneal_params = [prev_v_w, prev_v_b, weights, biases]
		for batch, label in zip(batches, labels_batches):
			weights = [i - momentum*j for i,j in zip(weights, prev_v_w)]
			biases = [i - momentum*j for i,j in zip(biases, prev_v_b)]
			nabla_w, nabla_b = updates_from_batch(batch, biases, weights, label)
			#updating weights wrt to each batch
			v_w = [momentum*i + lr*j for i,j in zip(prev_v_w, nabla_w)]
			v_b = [momentum*i + lr*j for i,j in zip(prev_v_b, nabla_b)]
			weights = [i - j for i,j in zip(weights, v_w)]
			biases = [i - j for i,j in zip(biases, v_b)]
			prev_v_w = v_w[:]
			prev_v_b = v_b[:]
			step += 1
			# Printing/Writing Training logs after 100 steps(or batches) in each epoch
			if(step % 100 == 0):
				training_loss = round(cal_loss(data, labels, weights, biases),2)
				training_error = round(cal_error(data, labels, weights, biases),2)
				train_log_line = "Epoch "+str(epoch)+", Step "+str(step)+", Loss: "+str(training_loss)+", Error: "+str(training_error)+", lr: "+str(lr)
				log_train.write("%s\n"%train_log_line)
				print("Train: "+train_log_line)
		# Printing/Writing Validation logs after each epoch
		validation_loss = round(cal_loss(val_data, val_labels, weights, biases),2)
		validation_error = round(cal_error(val_data, val_labels, weights, biases),2)
		val_log_line = "Epoch "+str(epoch)+", Loss: "+str(validation_loss)+", Error: "+str(validation_error)+", lr: "+str(lr)
		log_val.write("%s\n"%val_log_line)
		#epoch_val_file.write("%f %f\n"%(epoch, validation_loss))
		print("--------------------------------------------------------------------------------------------------------------------")
		print("Validation: "+val_log_line)	
		print("--------------------------------------------------------------------------------------------------------------------")	
		if(validation_error < 15.0):
			# Saving model as a pickle
			model = {'weights': weights, 'biases': biases}
			model = pd.DataFrame(model)
			model.to_pickle(save_dir + "model")
			run_test()
		# Going back and running again the same epoch if validation loss decreases,done to avoid overfitting	
		if(anneal == 'true'):
			if(validation_error > previous_val_error):
				epoch -= 1
				lr /= 2
				prev_v_w, prev_v_b, weights, biases = history_anneal_params[0],history_anneal_params[1],\
													  history_anneal_params[2],history_anneal_params[3]
				print("Running annealed epoch with halved learning rate")
		if(validation_error < previous_val_error):
			previous_val_error = validation_error
		#epoch_train_file.write("%f %f\n"%(epoch, round(cal_loss(data, labels, weights, biases),2)))
		epoch += 1
	log_train.close() #closing training log text file
	log_val.close()	 # closing validation log text file
	#epoch_val_file.close()
	#epoch_train_file.close()

def adam():
	"""Adam's Batch Gradient Descent"""
	previous_val_error = 100	
	lr = args.lr
	[biases, weights] = initialize_wts()
	v_w = [np.zeros(element.shape) for element in weights[1:]]
	v_b = [np.zeros(element.shape) for element in biases[1:]]
	v_w.insert(0, 0)
	v_b.insert(0, 0)
	m_w = [np.zeros(element.shape) for element in weights[1:]]
	m_b = [np.zeros(element.shape) for element in biases[1:]]
	m_w.insert(0, 0)
	m_b.insert(0, 0)
	eps, beta1, beta2 = 1e-2, 0.9, 0.999
	[data, labels] = load_data(train_file_dir) # loading training data
	[val_data, val_labels] = load_data(val_file_dir) #loading validation data
	batches = [data[:, i:i+batch_size] for i in range(0,data.shape[1],batch_size)] # dividing data into batches
	labels_batches = [labels[i:i+batch_size] for i in range(0,labels.shape[0],batch_size)] # dividing labels into resp. batches as data
	log_train = open(expt_dir+'log_train.txt', 'w') # opening training log text file
	log_val = open(expt_dir+'log_val.txt', 'w') # opening validation log text file
	#epoch_val_file = open(expt_dir+'epoch_val_file.txt', 'w') # for epoch vs validation loss graph 
	#epoch_train_file = open(expt_dir+'epoch_train_file.txt', 'w') # for epoch vs train loss graph 
	epoch, count_updates = 0, 0
	while (epoch < max_epochs):
		step = 0
		history_anneal_params = [v_w, v_b, m_w, m_b, weights, biases]
		for batch, label in zip(batches, labels_batches):
			nabla_w, nabla_b = updates_from_batch(batch, biases, weights, label)
			count_updates += 1
			#updating weights wrt to each batch
			m_w = [beta1*i + (1 - beta1)*j for i,j in zip(m_w, nabla_w)]
			m_b = [beta1*i + (1 - beta1)*j for i,j in zip(m_b, nabla_b)]
			v_w = [beta2*i + (1 - beta2)*j**2 for i,j in zip(v_w, nabla_w)]
			v_b = [beta2*i + (1 - beta2)*j**2 for i,j in zip(v_b, nabla_b)]
			m_w_hat = [i/(1 - math.pow(beta1,count_updates)) for i in m_w]
			m_b_hat = [i/(1 - math.pow(beta1,count_updates)) for i in m_b]
			v_w_hat = [i/(1 - math.pow(beta2,count_updates)) for i in v_w]
			v_b_hat = [i/(1 - math.pow(beta2,count_updates)) for i in v_b]
			weights = [i - (lr/np.sqrt(j + eps))*k for i,j,k in zip(weights, v_w_hat, m_w_hat)]
			biases = [i - (lr/np.sqrt(j + eps))*k for i,j,k in zip(biases, v_b_hat, m_b_hat)]
			step += 1
			# Printing/Writing Training logs after 100 steps(or batches) in each epoch
			if(step % 100 == 0):
				training_loss = round(cal_loss(data, labels, weights, biases),2)
				training_error = round(cal_error(data, labels, weights, biases),2)
				train_log_line = "Epoch "+str(epoch)+", Step "+str(step)+", Loss: "+str(training_loss)+", Error: "+str(training_error)+", lr: "+str(lr)
				log_train.write("%s\n"%train_log_line)
				print("Train: "+train_log_line)
		# Printing/Writing Validation logs after each epoch
		validation_loss = round(cal_loss(val_data, val_labels, weights, biases),2)
		validation_error = round(cal_error(val_data, val_labels, weights, biases),2)
		val_log_line = "Epoch "+str(epoch)+", Loss: "+str(validation_loss)+", Error: "+str(validation_error)+", lr: "+str(lr)
		log_val.write("%s\n"%val_log_line)
		#epoch_val_file.write("%f %f\n"%(epoch, validation_loss))
		print("--------------------------------------------------------------------------------------------------------------------")
		print("Validation: "+val_log_line)	
		print("--------------------------------------------------------------------------------------------------------------------")	
		if(validation_error < 15.0):
			# Saving model as a pickle
			model = {'weights': weights, 'biases': biases}
			model = pd.DataFrame(model)
			model.to_pickle(save_dir + "model")
			run_test()
		# Going back and running again the same epoch if validation loss decreases,done to avoid overfitting	
		if(anneal == 'true'):
			if(validation_error > previous_val_error):
				epoch -= 1
				lr /= 2
				v_w, v_b, m_w, m_b, weights, biases = history_anneal_params[0],history_anneal_params[1],history_anneal_params[2],\
				                                      history_anneal_params[3],history_anneal_params[4],history_anneal_params[5]
				print("Running annealed epoch with halved learning rate")
		if(validation_error < previous_val_error):
			previous_val_error = validation_error
		#epoch_train_file.write("%f %f\n"%(epoch, round(cal_loss(data, labels, weights, biases),2)))
		epoch += 1
	log_train.close() # closing training log text file
	log_val.close()	# closing validation log text file
	#epoch_val_file.close()
	#epoch_train_file.close()


# Testing Model on Test Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
def load_test_data(test_file_dir): # test file doesn't contain actual labels, it has just data 
	"""This function loads test data"""	
	ip = pd.read_csv(test_file_dir)
	test_ip = np.array(ip)
	test_ip = normalise_data(test_ip[:,1:]).T 
	return test_ip

def load_pickled_model():
	"""This fun loads pickled model containing the weights and biases"""
	model = pd.read_pickle(save_dir + "model")
	weights = list(model['weights'])
	biases = list(model['biases'])
	return [biases, weights]

def run_test():	
	print("Testing the model ###############################################################")
	[biases, weights] = load_pickled_model()
	data = load_test_data(test_file_dir)
	a, h = forward(weights, biases, data, isVector = 0)
	# Saving predicted test labels in csv file
	y_hat = h[L]
	predicted_labels = np.argmax(y_hat, axis = 0).T
	predicted_labels = {'label':predicted_labels}
	predicted_df = pd.DataFrame(predicted_labels)
	predicted_df.to_csv("./test_submission.csv", sep=',',index=True, index_label='id')

# Starting point of execution of this program (i.e., train.py)
if(pretrain == 'true'):
	run_test()
else:
	print("Training the model using '"+opt+"' #############################################################")
	if(opt == 'gd'):
		batch_grad_desc()
	elif(opt == 'momentum'):
		momentum_batch_grad_desc()
	elif(opt == 'nag'):
		NAG_grad_desc()
	elif(opt == 'adam'):
		adam()