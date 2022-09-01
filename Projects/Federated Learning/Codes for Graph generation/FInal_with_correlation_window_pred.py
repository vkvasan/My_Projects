#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 17 18:50:27 2021

@author: v
"""

import pandas as pd
import numpy as np
import torch.nn as nn
import torch 
import torch.nn.functional as F
import pylab as plt
import numpy as np 
from torch.utils.data import DataLoader
from torch.utils.data import TensorDataset
import math
from math import sqrt 
import csv
import copy 
from fitter import Fitter
def transpose(l1, l2):

    # iterate over list l1 to the length of an item
    
    for k in range(len(l1[0])):
        # print(i)
        row =[]
        for item in l1:
            # appending to new list with values and index positions
            # i contains index position and item contains values
            row.append(item[k])
        l2.append(row)
    return l2

def FedAvg(w,n):
    SUM = 0;    
    for i in range(0, len(n)):    
        SUM = SUM + n[i];    
    w_avg = copy.deepcopy(w[0])
    for k in w_avg.keys():
        for i in range(1, len(w)):
            w_avg[k] += ( w[i][k] * n[i] )
        w_avg[k] = torch.div(w_avg[k], SUM)
    return w_avg


def FedAvgLoss(Losses):
    SUM = 0.0
    for i in range(0,len(Losses)):
        SUM = SUM + Losses[i] 
    return ( SUM/len(Losses) ) 


def Local_fn(x,y,global_model,round_no,worker_no, window_size, pred_size):
        #x=np.load("train_new_x1.npy")         
        #y=np.load("train_new_y1.npy") 
        device = torch.device('cuda:3' if torch.cuda.is_available() else 'cpu')
        x_train_tensor = torch.from_numpy(x).float()
        y_train_tensor = torch.from_numpy(y).float()
        
        train_data = TensorDataset(x_train_tensor, y_train_tensor)
        
        train_loader = DataLoader(dataset = train_data, batch_size=bat, shuffle=True)
        
        No_of_batches = len(train_loader)
        
        
        class LSTM_net(nn.Module):
            def __init__(self):
                """
                In the constructor we instantiate two nn.Linear modules and assign them as
                member variables.
        
                D_in: input dimension
                H: dimension of hidden layergf8
                D_out: output dimension
                """
                super(LSTM_net, self).__init__()
                self.conv1 = nn.Conv1d(7,32 ,kernel_size=5,stride=1) 
                self.conv2 = nn.Conv1d(32, 32,kernel_size=3,stride=1) 
                self.maxp=nn.MaxPool1d(2, stride=None, padding=0, dilation=1, return_indices=False, ceil_mode=False)
                self.lstm1=nn.LSTM(input_size= ( int( (window_size)*0.5 ) -3 ),hidden_size=30,bias=False)
                self.lstm2=nn.LSTM(input_size=30,hidden_size=30,bias=False)
                self.linear1=nn.Linear(960,pred_size)
                self.linear2=nn.Linear(pred_size,pred_size)
            def lamdalayer(self, input, scale):
                return input*scale
        
            def forward(self, x):
                    """
                    In the forward function we accept a Variable of input data and we must 
                    return a Variable of output data. We can use Modules defined in the 
                    constructor as well as arbitrary operators on Variables.
                    """
                    x = F.tanh(self.conv1(x))
                    x=F.tanh(self.conv2(x))
                    x=self.maxp(x)
                    x,_=(self.lstm1(x))
                    x=F.tanh(x)
                    x,_=self.lstm2(x)
                    x=F.tanh(x)
                    x = x.view(x.size(0), -1) 
                    x=F.tanh(self.linear2(F.tanh(self.linear1(x))))
                    y_pred = self.lamdalayer(x,200)
                    return y_pred
        
        
        if global_model == 0:
            model = LSTM_net()
        else:
            model = LSTM_net()
            model.load_state_dict(global_model)
        
        model.to(device)
        learning_rate = 1e-3
        optimizer = torch.optim.Adam(model.parameters(), lr=learning_rate)
        loss_fn = torch.nn.MSELoss()
        
        
        sum_running_loss = 0.0
        
        for i in range(0,num_epochs):
            running_loss = 0.0
            for j in range(0,No_of_batches):
                x_batch,y_batch = next(iter(train_loader))
                
                x_batch = x_batch.to(device)
                y_batch = y_batch.to(device)
                
                y_pred=model.forward(x_batch)
                loss=loss_fn(y_pred,y_batch)
                optimizer.zero_grad()
                loss.backward()
                optimizer.step()     
                running_loss += sqrt(loss.item())         
                sum_running_loss += sqrt(loss.item())
            print("Round No : %d , Worker No: %d , Epoch: %d , Losses :%f " %( round_no,worker_no,i,(running_loss/No_of_batches)))    
            #losses.append(running_loss/No_of_batches )
        avg_loss = sum_running_loss/ ( No_of_batches * num_epochs )
        return model,avg_loss 

def evision( Distributions,  Dataset ):
    
    No_of_nodes = len(Dataset)
    
    No_of_features = len(Distributions[0])     #including output 
    
    count = 0 
    threshold = 2 
    I=[] # Array containing i's of Distribution that do not correlate well with any Data set's Distribtution Statistics 
    
    New_Dataset =[]
    
    for i in range(0,No_of_nodes):
        for j in range(i+1, No_of_nodes):
            count = 0
            found = 0
            for s in range(0,No_of_features):
                if Distributions[i][s] ==  Distributions[j][s]:
                    count = count+ 1
            if count>= threshold:
                count = 0
                found =1 
                break      
        if found != 1:
            I.append(i)
        else: 
            I.append(No_of_nodes)
                
    for i in  range(0,No_of_nodes):
        if I[i] != i :
            New_Dataset.append(Dataset[i]) 

    
    return New_Dataset

No_comm_rounds = 25  
       #fixed forecast size everytime
num_epochs=20      #training epochs
bat=10 

Distribution_statistics = [[['rdist'], ['powerlaw'], ['powerlaw'], ['loglaplace'], ['dgamma'], ['gausshyper'], ['exponnorm']], [['alpha'], ['powerlaw'], ['dgamma'], ['kstwobign'], ['beta'], ['weibull_max'], ['gausshyper']], [['johnsonsb'], ['johnsonsb'], ['johnsonsu'], ['dweibull'], ['powerlaw'], ['gausshyper'], ['johnsonsb']], [['levy'], ['laplace'], ['dgamma'], ['exponnorm'], ['dweibull'], ['gausshyper'], ['johnsonsb']], [['arcsine'], ['chi2'], ['genextreme'], ['gennorm'], ['tukeylambda'], ['levy_l'], ['gausshyper']], [['johnsonsb'], ['johnsonsb'], ['dweibull'], ['gausshyper'], ['dgamma'], ['genpareto'], ['gennorm']], [['johnsonsu'], ['johnsonsu'], ['exponnorm'], ['cauchy'], ['genextreme'], ['genpareto'], ['genlogistic']], [['johnsonsu'], ['johnsonsu'], ['gennorm'], ['johnsonsb'], ['dgamma'], ['johnsonsu'], ['johnsonsb']], [['johnsonsb'], ['beta'], ['vonmises_line'], ['dgamma'], ['dgamma'], ['johnsonsb'], ['genlogistic']], [['johnsonsb'], ['genextreme'], ['gennorm'], ['triang'], ['johnsonsb'], ['gausshyper'], ['exponnorm']], [['powernorm'], ['powernorm'], ['powernorm'], ['gennorm'], ['dgamma'], ['dgamma'], ['dweibull']], [['dgamma'], ['cauchy'], ['gennorm'], ['exponnorm'], ['dgamma'], ['johnsonsu'], ['triang']], [['burr12'], ['dweibull'], ['gennorm'], ['genlogistic'], ['dgamma'], ['weibull_max'], ['gumbel_r']], [['genpareto'], ['johnsonsb'], ['triang'], ['triang'], ['dgamma'], ['johnsonsb'], ['dgamma']], [['powerlaw'], ['nakagami'], ['genlogistic'], ['burr'], ['dgamma'], ['genpareto'], ['dweibull']], [['cauchy'], ['dgamma'], ['foldcauchy'], ['gennorm'], ['loggamma'], ['beta'], ['genextreme']], [['gennorm'], ['beta'], ['gennorm'], ['dweibull'], ['dgamma'], ['gausshyper'], ['powerlognorm']], [['chi'], ['erlang'], ['dgamma'], ['dgamma'], ['dgamma'], ['genpareto'], ['mielke']], [['ncx2'], ['powernorm'], ['powerlaw'], ['dgamma'], ['dweibull'], ['burr12'], ['gennorm']], [['genlogistic'], ['genlogistic'], ['betaprime'], ['gennorm'], ['dgamma'], ['dgamma'], ['genlogistic']], [['gennorm'], ['beta'], ['burr12'], ['genlogistic'], ['loggamma'], ['johnsonsu'], ['dweibull']], [['gennorm'], ['johnsonsu'], ['gennorm'], ['burr12'], ['dgamma'], ['gausshyper'], ['exponnorm']], [['johnsonsb'], ['nakagami'], ['dgamma'], ['triang'], ['triang'], ['genpareto'], ['johnsonsb']], [['halflogistic'], ['halflogistic'], ['loggamma'], ['dgamma'], ['dgamma'], ['gausshyper'], ['dweibull']], [['johnsonsb'], ['johnsonsb'], ['dweibull'], ['gennorm'], ['dgamma'], ['gausshyper'], ['genlogistic']], [['gennorm'], ['gennorm'], ['dweibull'], ['mielke'], ['johnsonsb'], ['pearson3'], ['genextreme']], [['gennorm'], ['beta'], ['dweibull'], ['gennorm'], ['dgamma'], ['johnsonsb'], ['mielke']], [['fatiguelife'], ['johnsonsb'], ['laplace'], ['dgamma'], ['dgamma'], ['johnsonsb'], ['johnsonsb']], [['betaprime'], ['pareto'], ['betaprime'], ['gennorm'], ['triang'], ['dgamma'], ['burr']], [['t'], ['powernorm'], ['powernorm'], ['dweibull'], ['dgamma'], ['rdist'], ['kstwobign']], [['arcsine'], ['tukeylambda'], ['genlogistic'], ['dgamma'], ['dweibull'], ['weibull_max'], ['johnsonsb']], [['gennorm'], ['levy_l'], ['gengamma'], ['mielke'], ['dgamma'], ['gennorm'], ['dweibull']], [['johnsonsb'], ['dgamma'], ['dgamma'], ['kstwobign'], ['laplace'], ['gausshyper'], ['dweibull']], [['johnsonsb'], ['levy'], ['dweibull'], ['laplace'], ['dgamma'], ['triang'], ['johnsonsu']], [['gennorm'], ['johnsonsu'], ['dgamma'], ['triang'], ['dgamma'], ['beta'], ['johnsonsb']], [['johnsonsb'], ['powerlaw'], ['johnsonsb'], ['triang'], ['laplace'], ['johnsonsu'], ['dweibull']], [['levy_l'], ['johnsonsb'], ['johnsonsb'], ['dweibull'], ['dweibull'], ['genpareto'], ['gausshyper']], [['johnsonsu'], ['gennorm'], ['gennorm'], ['johnsonsu'], ['dgamma'], ['johnsonsu'], ['dweibull']], [['johnsonsu'], ['cauchy'], ['rdist'], ['dweibull'], ['gennorm'], ['johnsonsu'], ['johnsonsb']], [['johnsonsb'], ['dweibull'], ['exponpow'], ['gausshyper'], ['arcsine'], ['dweibull'], ['foldnorm']], [['dgamma'], ['gennorm'], ['gausshyper'], ['dweibull'], ['dweibull'], ['gausshyper'], ['gennorm']], [['chi2'], ['pareto'], ['betaprime'], ['gennorm'], ['mielke'], ['rdist'], ['dweibull']], [['chi'], ['pareto'], ['betaprime'], ['burr'], ['gennorm'], ['weibull_max'], ['dgamma']], [['johnsonsu'], ['gennorm'], ['gennorm'], ['exponnorm'], ['dgamma'], ['beta'], ['dgamma']], [['cauchy'], ['lognorm'], ['dweibull'], ['loglaplace'], ['dgamma'], ['beta'], ['johnsonsb']], [['loglaplace'], ['johnsonsb'], ['dweibull'], ['gennorm'], ['dgamma'], ['genpareto'], ['exponnorm']], [['johnsonsb'], ['johnsonsb'], ['triang'], ['gennorm'], ['ncf'], ['gausshyper'], ['dgamma']], [['powernorm'], ['powernorm'], ['frechet_l'], ['dweibull'], ['dgamma'], ['beta'], ['dgamma']], [['dgamma'], ['gennorm'], ['burr12'], ['dgamma'], ['dgamma'], ['gausshyper'], ['johnsonsb']], [['arcsine'], ['dweibull'], ['dgamma'], ['johnsonsb'], ['dgamma'], ['johnsonsb'], ['exponnorm']], [['exponnorm'], ['beta'], ['foldcauchy'], ['triang'], ['dweibull'], ['beta'], ['dweibull']], [['halfnorm'], ['halfgennorm'], ['betaprime'], ['dgamma'], ['dgamma'], ['dgamma'], ['gennorm']], [['johnsonsb'], ['dweibull'], ['dgamma'], ['rice'], ['dgamma'], ['gausshyper'], ['exponnorm']], [['johnsonsb'], ['johnsonsb'], ['dweibull'], ['beta'], ['dgamma'], ['gausshyper'], ['dweibull']], [['johnsonsb'], ['chi'], ['triang'], ['dweibull'], ['exponpow'], ['beta'], ['invweibull']], [['cauchy'], ['powerlognorm'], ['dgamma'], ['beta'], ['beta'], ['exponpow'], ['cauchy']], [['chi'], ['pareto'], ['betaprime'], ['dgamma'], ['dgamma'], ['rdist'], ['genlogistic']], [['kstwobign'], ['powernorm'], ['betaprime'], ['gennorm'], ['dgamma'], ['dweibull'], ['dgamma']], [['nakagami'], ['exponnorm'], ['dweibull'], ['gennorm'], ['triang'], ['johnsonsb'], ['johnsonsb']], [['gennorm'], ['gennorm'], ['gennorm'], ['dweibull'], ['dweibull'], ['johnsonsb'], ['exponnorm']], [['gennorm'], ['johnsonsb'], ['dweibull'], ['powerlognorm'], ['tukeylambda'], ['genhalflogistic'], ['gumbel_r']], [['halfnorm'], ['powernorm'], ['betaprime'], ['dgamma'], ['tukeylambda'], ['johnsonsb'], ['dgamma']], [['halfnorm'], ['halfcauchy'], ['frechet_r'], ['dgamma'], ['tukeylambda'], ['johnsonsb'], ['burr']], [['gengamma'], ['halfgennorm'], ['betaprime'], ['gennorm'], ['gennorm'], ['dgamma'], ['invgamma']], [['beta'], ['halfgennorm'], ['betaprime'], ['dgamma'], ['dweibull'], ['dgamma'], ['dgamma']], [['chi'], ['pareto'], ['betaprime'], ['laplace'], ['burr12'], ['laplace'], ['pearson3']], [['chi2'], ['pareto'], ['betaprime'], ['burr'], ['genlogistic'], ['logistic'], ['expon']], [['pearson3'], ['pearson3'], ['betaprime'], ['loggamma'], ['pearson3'], ['hypsecant'], ['wald']], [['halfnorm'], ['pareto'], ['betaprime'], ['gennorm'], ['gennorm'], ['gennorm'], ['gennorm']], [['gilbrat'], ['powerlaw'], ['dweibull'], ['exponnorm'], ['gengamma'], ['genpareto'], ['triang']]]


Dataset = []
New_Dataset = []


for i in range ( 1, 55 ):
    s = "d"+str(i)+".csv"
    df = pd.read_csv( s )
    Dataset.append(df)


New_Dataset =  evision( Distribution_statistics, Dataset )   
  

'''
window_size=50       #required time steps for prediction
pred_size=5  
global_loss =[]

for n in range (0,No_comm_rounds):
    if n ==0 :
        w_locals=[]
        Losses =[]
        N=[]
        for i in range(0,len(New_Dataset)):          
            xs1=[]
            ys1=[]
            df = New_Dataset[i]
            N.append( df.shape[0] )
            data1=[]
            data1 = df.values.tolist()
            l=0
            for j in data1:
                if l+window_size+6>=len(data1):
                    break
                data_temp=data1[l:l+window_size]
                temp =[]
                temp = transpose(data_temp , temp )
                xs1.append(temp)
                temp1=[]
                for c in range(1,pred_size+1):
                    temp1.append(data1[l+window_size+c][6])
                l=l+1
                ys1.append(temp1)   
            x_numpy=np.asarray(xs1,dtype="float64")
            y_numpy=np.asarray(ys1,dtype="float64")
            
            
            model,avg_loss = Local_fn(x_numpy,y_numpy,0,n,i,window_size, pred_size)

            temp_model= model.state_dict()
            w_locals.append(copy.deepcopy(temp_model)) 
            Losses.append(avg_loss)
        global_model = FedAvg(w_locals,N)    
        global_loss.append(FedAvgLoss(Losses))
        
        
        
        
    else:
        w_locals=[]
        Losses =[]
        N=[]
        for i in range(0,len(New_Dataset)):          
            xs1=[]
            ys1=[]
            df = New_Dataset[i]
            N.append( df.shape[0] )
            data1=[]   
            data1 = df.values.tolist()
            l=0
            for j in data1:
                if l+window_size+6>=len(data1):
                    break
                data_temp=data1[l:l+window_size]
                temp =[]
                temp = transpose(data_temp , temp )
                xs1.append(temp)
                temp1=[]
                for c in range(1,pred_size+1):
                    temp1.append(data1[l+window_size+c][6])
                l=l+1
                ys1.append(temp1)     
            x_numpy=np.asarray(xs1,dtype="float64")
            y_numpy=np.asarray(ys1,dtype="float64")
            model,avg_loss = Local_fn(x_numpy,y_numpy,global_model,n,i,window_size, pred_size)
            temp_model= model.state_dict()
            w_locals.append(copy.deepcopy(temp_model)) 
            Losses.append(avg_loss)
        global_model = FedAvg(w_locals,N)       
        global_loss.append(FedAvgLoss(Losses))


plt.plot(global_loss , color = 'b', label ='window = 50 , prediction = 5 ')     
np.savetxt("global_loss_withcorrelation_window_50_prediction_5.csv", global_loss)  
torch.save(global_model,"GLOBALMODELNEWONE_withCorrelationwindow_50_prediction_5.pt" ) 

window_size=60       #required time steps for prediction
pred_size=4  
global_loss =[]
for n in range (0,No_comm_rounds):
    if n ==0 :
        w_locals=[]
        Losses =[]
        N=[]
        for i in range(0,len(New_Dataset)):          
            xs1=[]
            ys1=[]
            df = New_Dataset[i]
            N.append( df.shape[0] )
            data1=[]
            data1 = df.values.tolist()
            l=0
            for j in data1:
                if l+window_size+6>=len(data1):
                    break
                data_temp=data1[l:l+window_size]
                temp =[]
                temp = transpose(data_temp , temp )
                xs1.append(temp)
                temp1=[]
                for c in range(1,pred_size+1):
                    temp1.append(data1[l+window_size+c][6])
                l=l+1
                ys1.append(temp1)   
            x_numpy=np.asarray(xs1,dtype="float64")
            y_numpy=np.asarray(ys1,dtype="float64")
            
            
            model,avg_loss = Local_fn(x_numpy,y_numpy,0,n,i,window_size, pred_size)

            temp_model= model.state_dict()
            w_locals.append(copy.deepcopy(temp_model)) 
            Losses.append(avg_loss)
        global_model = FedAvg(w_locals,N)    
        global_loss.append(FedAvgLoss(Losses))
        
        
        
        
    else:
        w_locals=[]
        Losses =[]
        N=[]
        for i in range(0,len(New_Dataset)):          
            xs1=[]
            ys1=[]
            df = New_Dataset[i]
            N.append( df.shape[0] )
            data1=[]   
            data1 = df.values.tolist()
            l=0
            for j in data1:
                if l+window_size+6>=len(data1):
                    break
                data_temp=data1[l:l+window_size]
                temp =[]
                temp = transpose(data_temp , temp )
                xs1.append(temp)
                temp1=[]
                for c in range(1,pred_size+1):
                    temp1.append(data1[l+window_size+c][6])
                l=l+1
                ys1.append(temp1)     
            x_numpy=np.asarray(xs1,dtype="float64")
            y_numpy=np.asarray(ys1,dtype="float64")
            model,avg_loss = Local_fn(x_numpy,y_numpy,global_model,n,i,window_size, pred_size)
            temp_model= model.state_dict()
            w_locals.append(copy.deepcopy(temp_model)) 
            Losses.append(avg_loss)
        global_model = FedAvg(w_locals,N)       
        global_loss.append(FedAvgLoss(Losses))
        

plt.plot(global_loss , color = 'r', label ='window = 60 , prediction = 4 ')     
np.savetxt("global_loss_withcorrelation_window_60_prediction_4.csv", global_loss)  
torch.save(global_model,"GLOBALMODELNEWONE_withCorrelationwindow_60_prediction_4.pt" ) 
'''
window_size=65       #required time steps for prediction
pred_size=6 
global_loss =[]

for n in range (0,No_comm_rounds):
    if n ==0 :
        w_locals=[]
        Losses =[]
        N=[]
        for i in range(0,len(New_Dataset)):          
            xs1=[]
            ys1=[]
            df = New_Dataset[i]
            N.append( df.shape[0] )
            data1=[]
            data1 = df.values.tolist()
            l=0
            for j in data1:
                if l+window_size+6>=len(data1):
                    break
                data_temp=data1[l:l+window_size]
                temp =[]
                temp = transpose(data_temp , temp )
                xs1.append(temp)
                temp1=[]
                for c in range(1,pred_size+1):
                    temp1.append(data1[l+window_size+c][6])
                l=l+1
                ys1.append(temp1)   
            x_numpy=np.asarray(xs1,dtype="float64")
            y_numpy=np.asarray(ys1,dtype="float64")
            
            
            model,avg_loss = Local_fn(x_numpy,y_numpy,0,n,i,window_size, pred_size)

            temp_model= model.state_dict()
            w_locals.append(copy.deepcopy(temp_model)) 
            Losses.append(avg_loss)
        global_model = FedAvg(w_locals,N)    
        global_loss.append(FedAvgLoss(Losses))
        
        
        
        
    else:
        w_locals=[]
        Losses =[]
        N=[]
        for i in range(0,len(New_Dataset)):          
            xs1=[]
            ys1=[]
            df = New_Dataset[i]
            N.append( df.shape[0] )
            data1=[]   
            data1 = df.values.tolist()
            l=0
            for j in data1:
                if l+window_size+6>=len(data1):
                    break
                data_temp=data1[l:l+window_size]
                temp =[]
                temp = transpose(data_temp , temp )
                xs1.append(temp)
                temp1=[]
                for c in range(1,pred_size+1):
                    temp1.append(data1[l+window_size+c][6])
                l=l+1
                ys1.append(temp1)     
            x_numpy=np.asarray(xs1,dtype="float64")
            y_numpy=np.asarray(ys1,dtype="float64")
            model,avg_loss = Local_fn(x_numpy,y_numpy,global_model,n,i,window_size, pred_size)
            temp_model= model.state_dict()
            w_locals.append(copy.deepcopy(temp_model)) 
            Losses.append(avg_loss)
        global_model = FedAvg(w_locals,N)       
        global_loss.append(FedAvgLoss(Losses))


plt.plot(global_loss , color = 'g', label ='window = 65 , prediction = 6 ')     
np.savetxt("global_loss_withcorrelation_window_65_prediction_6.csv", global_loss)  
torch.save(global_model,"GLOBALMODELNEWONE_withCorrelationwindow_65_prediction_6.pt" ) 


window_size=80       #required time steps for prediction
pred_size=5 
global_loss =[]

for n in range (0,No_comm_rounds):
    if n ==0 :
        w_locals=[]
        Losses =[]
        N=[]
        for i in range(0,len(New_Dataset)):          
            xs1=[]
            ys1=[]
            df = New_Dataset[i]
            N.append( df.shape[0] )
            data1=[]
            data1 = df.values.tolist()
            l=0
            for j in data1:
                if l+window_size+6>=len(data1):
                    break
                data_temp=data1[l:l+window_size]
                temp =[]
                temp = transpose(data_temp , temp )
                xs1.append(temp)
                temp1=[]
                for c in range(1,pred_size+1):
                    temp1.append(data1[l+window_size+c][6])
                l=l+1
                ys1.append(temp1)   
            x_numpy=np.asarray(xs1,dtype="float64")
            y_numpy=np.asarray(ys1,dtype="float64")
            
            
            model,avg_loss = Local_fn(x_numpy,y_numpy,0,n,i,window_size, pred_size)

            temp_model= model.state_dict()
            w_locals.append(copy.deepcopy(temp_model)) 
            Losses.append(avg_loss)
        global_model = FedAvg(w_locals,N)    
        global_loss.append(FedAvgLoss(Losses))
        
        
        
        
    else:
        w_locals=[]
        Losses =[]
        N=[]
        for i in range(0,len(New_Dataset)):          
            xs1=[]
            ys1=[]
            df = New_Dataset[i]
            N.append( df.shape[0] )
            data1=[]   
            data1 = df.values.tolist()
            l=0
            for j in data1:
                if l+window_size+6>=len(data1):
                    break
                data_temp=data1[l:l+window_size]
                temp =[]
                temp = transpose(data_temp , temp )
                xs1.append(temp)
                temp1=[]
                for c in range(1,pred_size+1):
                    temp1.append(data1[l+window_size+c][6])
                l=l+1
                ys1.append(temp1)     
            x_numpy=np.asarray(xs1,dtype="float64")
            y_numpy=np.asarray(ys1,dtype="float64")
            model,avg_loss = Local_fn(x_numpy,y_numpy,global_model,n,i,window_size, pred_size)
            temp_model= model.state_dict()
            w_locals.append(copy.deepcopy(temp_model)) 
            Losses.append(avg_loss)
        global_model = FedAvg(w_locals,N)       
        global_loss.append(FedAvgLoss(Losses))


plt.plot(global_loss , color = 'y', label ='window = 80 , prediction = 5 ')     
np.savetxt("global_loss_withcorrelation_window_80_prediction_5.csv", global_loss)  
torch.save(global_model,"GLOBALMODELNEWONE_withCorrelationwindow_80_prediction_5.pt" ) 




plt.xlabel("Communication rounds")
plt.ylabel("Loss in dB ")
plt.legend()
plt.show()
''' 
plt.savefig('FedAvgCorr_Loss_vs_Communicationrounds_withcorrelation_window_pred_NEWONE.png') 
'''