package com.wcn.service;



import java.util.ArrayList;

import javax.rmi.CORBA.Util;

import com.wcn.entities.BaseStation;
import com.wcn.entities.Location;
import com.wcn.entities.MacroBS;
import com.wcn.entities.PicoBS;
import com.wcn.main.MainClass;
import com.wcn.utiliies.NetParameters;
import com.wcn.utiliies.UtilMethods;

public class ServiceImpl {

	public int getUserDensity( float distance , int users){
		int user_density;
		
		 user_density = (int)((users)*((distance*distance)/(NetParameters.pico_radius*NetParameters.pico_radius)));
		 
		 user_density = users - user_density;
		 
		 
		 return user_density>0?user_density:0;
	}

	
	
	
public float calculateAvgSINRnew( PicoBS pico_bs , MacroBS macro_bs, double distance , double COSTHETA){
		
	
		//double dist = l.distance(l, pico_bs.getLoc());
		
		float numerator = (float) (UtilMethods.dbMtoWatt(NetParameters.pico_power)/Math.pow(distance/1000f, 2));
		//System.out.println("NUMERATOR; "+numerator);
		
		double denominator = 0.0f;
		
		
		double dist_p_to_m = UtilMethods.distance(pico_bs.getLoc(), macro_bs.getCenter());
		
		//System.out.println("distance p to m"+dist_p_to_m);
		
		//double dist = Math.pow(distance, 2 ) + Math.pow(dist_p_to_m, 2) - 2*distance*dist_p_to_m*Math.cos(COSTHETA);
		
		double dist = Math.pow(distance, 2 ) + Math.pow(dist_p_to_m, 2) - 2*distance*dist_p_to_m*Math.cos(COSTHETA);
		//System.out.println("cos value:"+Math.cos(COSTHETA));
		
		dist = Math.sqrt(dist);
		
		
		//System.out.println("distance point to m"+dist);
		
		
		
		denominator = (float) (denominator 
				+ UtilMethods.dbMtoWatt(NetParameters.macro_power)/Math.pow((dist)/1000f,2)); 
		
		
		
			return 10f*(float)Math.log10(numerator/denominator);
		
		
		
	}
	
	



public float calculateAvgSINRMAcro( MacroBS mbs){
	
	Location l = mbs.getCenter();
	
	float x = l.getX()+NetParameters.macro_radius;
	float y = l.getY()+NetParameters.macro_radius;
	
	float avg_sinr = 0;
	int count = 0;
	
	for(int i = 1 ; i < Math.floor(x) ; ){
		
		for(int j = 1 ; j<Math.floor(y) ; j++){
			
			Location temp = new Location(i,j);
			
			float dist = (float) UtilMethods.distance(temp,mbs.getCenter());
			
			float numerator =  (float) (UtilMethods.dbMtoWatt(NetParameters.macro_power)/Math.pow(dist/1000f, 2)); 
					
			
			double denom = 0.0;
			
			for(int k = 0 ; k<mbs.getNeighbors().size() ; k++){
				
				MacroBS nbr = mbs.getNeighbors().get(k);
				
				double dist_nbr = UtilMethods.distance(temp, nbr.getCenter());
				
				denom = denom+ UtilMethods.dbMtoWatt(NetParameters.macro_power)/Math.pow((dist_nbr)/1000f,2);
				
			}
			
			
			avg_sinr = avg_sinr + 10f*(float)Math.log10(numerator/denom);
			
			
			count++;
			
			System.out.println("[BIN SINR:"+10f*(float)Math.log10(numerator/denom) +"] at bin:"+count);
			
			j = j + 100;
			
		}
		i = i+100;
	}

	System.out.println("Average sinr macro :"+avg_sinr/count);
	
	mbs.setAvg_sinr(avg_sinr/count);
	
return avg_sinr/count;
	
}




public float calculateAvgSINR(PicoBS pbs , MacroBS mbs, float threshold_distance){
	
	Location l = new Location();
	float numerator = 
	NetParameters.pico_power - (float) (NetParameters.A_pico_to_UE + NetParameters.B_pico_to_UE * Math.log10(threshold_distance/1000)); 
	
	//System.out.println("NUMERATOR;"+numerator);
	
	float dist = (float)l.distance(pbs.getLoc(), mbs.getCenter()); 
	float denominator;
	System.out.println(dist+ " dist threshold dist "+ threshold_distance );
	if(dist > threshold_distance){
	 denominator = 
			NetParameters.macro_power 
			- (float) (NetParameters.A_macro_to_UE + NetParameters.B_macro_to_UE * Math.log10((dist-threshold_distance)/1000));
	}
	else
		return 0;
	
	//System.out.println("denominator:"+denominator);
	
	
	
	//System.out.println("dbMtoWt NUM"+UtilMethods.dbMtoWatt(numerator));
	//System.out.println("dbMtoWt NUM"+UtilMethods.dbMtoWatt(denominator));
	
	return 10f* (float)Math.log10((float)UtilMethods.dbMtoWatt(numerator) / (float)UtilMethods.dbMtoWatt(denominator)); 
	 
	
	
	
	
}









public double getDistanceThreshold(MacroBS mbs , PicoBS pbs ){
	
	double r,r_;
	
	double p_to_m = UtilMethods.distance(mbs.getCenter(),pbs.getLoc())/1000;
	
	
	double root_pow_mac = Math.sqrt(UtilMethods.dbMtoWatt(NetParameters.macro_power));
	
	r = p_to_m/(1+root_pow_mac);
	r_ = p_to_m/(root_pow_mac -1);
	
	if(r_*1000 >= NetParameters.pico_radius)
		//return NetParameters.pico_radius;
		return r*1000;

//	if(r*1000 >= NetParameters.pico_radius)
//		//return NetParameters.pico_radius;
//	
	if((r+r_)*0.5*1000 >= NetParameters.pico_radius)
		return r*1000;
	
	//return r*1000;
	return (r+r_)*0.5*1000;
}





	

	public float getDistanceFromRsRp(float threshold){
		float distance = 0.0f;
		try{
		
		distance = (float)Math.pow(10,
				((NetParameters.pico_power - NetParameters.gamma_threshold - NetParameters.A_pico_to_UE)/NetParameters.B_pico_to_UE))*1000;
		
		//multiplication for converting into meters;
		
	}
		catch(Exception e){
			e.printStackTrace();
		}
	finally{
		
		return distance;
	}
		
	}
	
	
	public void calculateRb(MacroBS mbs){
		float avg_sinr = mbs.getAvg_sinr();
		int users = mbs.getNo_users();
		//System.out.println(users);
		float bps = (float) NetParameters.bps[UtilMethods.binSearch(avg_sinr, NetParameters.sinr_tab, 0, NetParameters.sinr_tab.length)];
		//System.out.println(bps);
		int sum = 0;
		float rbs = 0;
		for(int i = 0 ; i<NetParameters.data_rate.length ; i++){
			sum = sum+NetParameters.ratio_users[i];
			
		}
		//System.err.println(sum);
		for(int i = 0 ; i<NetParameters.data_rate.length ; i++){
			//rbs = rbs+ 
				rbs = rbs+(NetParameters.data_rate[i]*(10/(75f*bps)))*(NetParameters.ratio_users[i]*users*(1/(1.0f*sum)));
		}
		
		mbs.setRbS(rbs);
		
	}
	
	
	public void calculateRb(PicoBS pbs){
		float avg_sinr = (float) pbs.getAvg_sinr_ue();
		int users = pbs.getEdge_users();
		System.out.println(users);
		float bps = (float) NetParameters.bps[UtilMethods.binSearch(avg_sinr, NetParameters.sinr_tab, 0, NetParameters.sinr_tab.length)];
		System.out.println(bps);
		int sum = 0;
		float rbs = 0;
		for(int i = 0 ; i<NetParameters.data_rate.length ; i++){
			sum = sum+NetParameters.ratio_users[i];
			
		}
		//System.err.println(sum);
		for(int i = 0 ; i<NetParameters.data_rate.length ; i++){
			//rbs = rbs+ 
				rbs = rbs+(NetParameters.data_rate[i]*(10/(75f*bps)))*(NetParameters.ratio_users[i]*users*(1/(1.0f*sum)));
		}
		
		pbs.setrBs((float) Math.ceil(rbs));
		
	}
	
	
	public int getLoadSystem(ArrayList<PicoBS> pbs){
		int load = 0 ; 
		
		for(int i = 0 ; i <pbs.size() ; i++){
			
			
			load = load+ pbs.get(i).getUsers();
			
			
		}
		
		
		return load;
	}
	
	
	
public int optimalABSdemand(ArrayList<Integer> PBS , int K){
		
		int sumDemd = 0; //T 1 to K
		float reciDemd = 0; //reciprocal sum k+1 to N
		int diff =  PBS.size() - K;  
		float ABS = 0 ;
		
		for(int i = 0 ; i<K && i<PBS.size(); i++){
			sumDemd = (int) (sumDemd + PBS.get(i));
		}
		//System.out.println(sumDemd+"sumdemd");
		
		for(int i = K ; i<PBS.size() ; i++){
			
			if(PBS.get(i)!=0)
			reciDemd = reciDemd + 1/(1f*PBS.get(i));
			
		}
		
		
		if(reciDemd == 0){
			
			ABS = 1f*PBS.get(PBS.size()-1);
			System.out.println("ABS cycle "+((int) Math.ceil(ABS)<=0?1:(int) Math.ceil(ABS)));
			
			
			ABS = ((int) Math.ceil(ABS)<=0?1:(int) Math.ceil(ABS));
			float Y = K*diff + sumDemd*reciDemd -K*ABS - diff*sumDemd/ABS;
			
			System.out.println("Blocakge * wastage :"+(-Y));
			
			
			return (int) Math.ceil(ABS)<=0?1:(int) Math.ceil(ABS);
			
		}
		
		//System.out.println(reciDemd+"recidmd");
		
		ABS = (float) Math.sqrt((diff*sumDemd)/(K*reciDemd));
		
		//ABS = ((int) Math.ceil(ABS)<=0?1:(int) Math.ceil(ABS));
		
		System.out.println("ABS cycle "+((int) Math.ceil(ABS)<=0?1:(int) Math.ceil(ABS)));
		
		float Y = K*diff + sumDemd*reciDemd -K*ABS - diff*sumDemd/ABS;
		
		System.out.println("Blocakge * wastage :"+(-Y));
		
		//ABS = ((int) Math.ceil(ABS)<=0?1:(int) Math.ceil(ABS));
		
		return (int) Math.ceil(ABS)<=0?1:(int) Math.ceil(ABS);
		
	}
	
	



public int optimalABSdemand(ArrayList<Integer> PBS , int K , ArrayList<Double> blkwstProduct){
		
		int sumDemd = 0; //T 1 to K
		float reciDemd = 0; //reciprocal sum k+1 to N
		int diff =  PBS.size() - K;  
		float ABS = 0 ;
		
		for(int i = 0 ; i<K && i<PBS.size(); i++){
			sumDemd = (int) (sumDemd + PBS.get(i));
		}
		//System.out.println(sumDemd+"sumdemd");
		
		for(int i = K ; i<PBS.size() ; i++){
			
			if(PBS.get(i)!=0)
			reciDemd = reciDemd + 1/(1f*PBS.get(i));
			
		}
		
		
		if(reciDemd == 0){
			
			ABS = 1f*PBS.get(PBS.size()-1);
			System.out.println("ABS cycle "+((int) Math.ceil(ABS)<=0?1:(int) Math.ceil(ABS)));
			
			
			ABS = ((int) Math.ceil(ABS)<=0?1:(int) Math.ceil(ABS));
			float Y = K*diff + sumDemd*reciDemd -K*ABS - diff*sumDemd/ABS;
			
			System.out.println("Blocakge * wastage :"+(-Y));
			
			
			return (int) Math.ceil(ABS)<=0?1:(int) Math.ceil(ABS);
			
		}
		
		//System.out.println(reciDemd+"recidmd");
		
		ABS = (float) Math.sqrt((diff*sumDemd)/(K*reciDemd));
		
		//ABS = ((int) Math.ceil(ABS)<=0?1:(int) Math.ceil(ABS));
		
		System.out.println("ABS cycle "+((int) Math.ceil(ABS)<=0?1:(int) Math.ceil(ABS)));
		
		float Y = K*diff + sumDemd*reciDemd -K*ABS - diff*sumDemd/ABS;
		
		System.out.println("Blocakge * wastage :"+(-Y));
		blkwstProduct.add((double) -Y);
		
		//ABS = ((int) Math.ceil(ABS)<=0?1:(int) Math.ceil(ABS));
		
		return (int) Math.ceil(ABS)<=0?1:(int) Math.ceil(ABS);
		
	}
	
	
	

	
	
	
	
	
	public int optimalABS(ArrayList<PicoBS> PBS , int K){
		
		int sumDemd = 0; //T 1 to K
		float reciDemd = 0; //reciprocal sum k+1 to N
		int diff =  PBS.size() - K;  
		float ABS = 0 ;
		
		for(int i = 0 ; i<K && i<PBS.size(); i++){
			sumDemd = (int) (sumDemd + PBS.get(i).getrBs());
		}
	//	System.out.println(sumDemd+"sumdemd");
		
		for(int i = K ; i<PBS.size() ; i++){
			
			if(PBS.get(i).getrBs()!=0)
			reciDemd = reciDemd + 1/(1f*PBS.get(i).getrBs());
			
		}
		
		
		if(reciDemd == 0){
			
			ABS = 1f*PBS.get(PBS.size()-1).getrBs();
			System.out.println("optimal ABS cycle "+ABS);
			return  (int) ABS;
			
		}
		
		//System.out.println(reciDemd+"recidmd");
		
		ABS = (float) Math.sqrt((diff*sumDemd)/(K*reciDemd));
		
		System.out.println(" optimal ABS cycle : "+ABS);
		return (int)ABS;
	}
	
	
	
public int optimalABSavg(ArrayList<PicoBS> PBS , int K){
		
		int sumDemd = 0; //T 1 to K
		float reciDemd = 0; //reciprocal sum k+1 to N
		int diff =  PBS.size() - K;  
		float ABS = 0 ;
		
		for(int i = 0 ; i<K && i<PBS.size(); i++){
			sumDemd = (int) (sumDemd + PBS.get(i).getrBs());
		}
		//System.out.println(sumDemd+"sumdemd");
		
		ABS = sumDemd/PBS.size();
		//MainClass.optABS = ABS;
		
		System.out.println("average optimal ABS cycle "+ABS);
		
		float Y = K*diff + sumDemd*reciDemd -K*ABS - diff*sumDemd/ABS;
		
		System.out.println("Blocakge * wastage :"+(-Y));
		
		return (int) ABS;
		
	}
	
	

public int optimalABSavg(ArrayList<PicoBS> PBS , int K , ArrayList<Double> blkWstProd){
	
	int sumDemd = 0; //T 1 to K
	float reciDemd = 0; //reciprocal sum k+1 to N
	int diff =  PBS.size() - K;  
	float ABS = 0 ;
	
	for(int i = 0 ; i<K && i<PBS.size(); i++){
		sumDemd = (int) (sumDemd + PBS.get(i).getrBs());
	}
	//System.out.println(sumDemd+"sumdemd");
	
	ABS = sumDemd/PBS.size();
	//MainClass.optABS = ABS;
	
	System.out.println("average optimal ABS cycle "+ABS);
	
	float Y = K*diff + sumDemd*reciDemd -K*ABS - diff*sumDemd/ABS;
	
	System.out.println("Blocakge * wastage :"+(-Y));
	blkWstProd.add((double) -Y);
	
	return (int) ABS;
	
}

	

public void getBlockedUsers(ArrayList<PicoBS> pbs , ArrayList<MacroBS> mbs , float optABS){
	for(int i = 0 ; i<mbs.size() ; i++){
		MacroBS mb = mbs.get(i);
		int noOfUsers = mb.getNo_users();
		int ratioSum = 0;
		int rb_given = (int) (MainClass.total_RBS - optABS);
		for(int x = 0 ; x<NetParameters.data_rate.length ; x++){
			ratioSum = ratioSum+NetParameters.ratio_users[x];
		}
		
		
		//System.out.println("rbs given:"+rb_given);
		
		int blocked_user = 0;
		float avgSinr = mb.getAvg_sinr();
		float bps = (float) NetParameters.bps[UtilMethods.binSearch(avgSinr, NetParameters.sinr_tab, 0, NetParameters.sinr_tab.length)];
		for(int u  = 0 ; u< noOfUsers ; u++){
			int flag = 0;
			for(int rate = 0 ;rate< NetParameters.data_rate.length ; rate++){
				u++;
			int temp = 	(int) (NetParameters.data_rate[rate]*10/(bps*75));
			//System.out.println("user requires:"+temp+" rb's left:"+rb_given);
				rb_given = rb_given - temp;
				
				if(rb_given<0){
					flag = 1;
					blocked_user = noOfUsers - u;
					mbs.get(i).blockedUsers = blocked_user>0?blocked_user:0;
					//System.out.println("blocked user :"+blocked_user);
				break;	
				}
			}
			if(flag == 1){
				break;
			}
			
		}
		
		
		
		
	}
}



public void getBlockedUsersPico(ArrayList<PicoBS> mbs , float optABS){
	for(int i = 0 ; i<mbs.size() ; i++){
		PicoBS mb = mbs.get(i);
		int noOfUsers = mb.getEdge_users();
		int ratioSum = 0;
		int rb_given =(int) (optABS);
		for(int x = 0 ; x<NetParameters.data_rate.length ; x++){
			ratioSum = ratioSum+NetParameters.ratio_users[x];
		}
		
		
		//System.out.println("rbs given:"+rb_given);
		
		int blocked_user = 0;
		float avgSinr = (float) mb.getAvg_sinr_ue();
		float bps = (float) NetParameters.bps[UtilMethods.binSearch(avgSinr, NetParameters.sinr_tab, 0, NetParameters.sinr_tab.length)];
		for(int u  = 0 ; u< noOfUsers ; u++){
			int flag = 0;
			for(int rate = 0 ;rate< NetParameters.data_rate.length ; rate++){
				u++;
			int temp = 	(int) (NetParameters.data_rate[rate]*10/(bps*75));
			//System.out.println("user requires:"+temp+" rb's left:"+rb_given);
				rb_given = rb_given - temp;
				
				if(rb_given<0){
					flag = 1;
					blocked_user = noOfUsers - u;
					mbs.get(i).blockedUsers = blocked_user>0?blocked_user:0;
					//System.out.println("blocked user :"+blocked_user);
				break;	
				}
			}
			if(flag == 1){
				break;
			}
			
		}
		
		
		
		
	}
}
	
public float getSystemThroughput(ArrayList<PicoBS> pbs , ArrayList<MacroBS> mbs ){
	
	float tput = 0.0f;
	
	for(int i = 0 ; i<mbs.size() ; i++){
		
		MacroBS temp = mbs.get(i);
		int users = temp.getNo_users() - temp.blockedUsers;
		float bps = (float) NetParameters.bps[UtilMethods.binSearch(temp.getAvg_sinr(), NetParameters.sinr_tab, 0, NetParameters.sinr_tab.length)];
		tput = tput+ users*bps*70*20*50;
		
	}
	
for(int i = 0 ; i<pbs.size() ; i++){
		
		PicoBS temp = pbs.get(i);
		int users = temp.getEdge_users() - temp.blockedUsers;
		float bps = (float) NetParameters.bps[UtilMethods.binSearch((float) temp.getAvg_sinr_ue(), NetParameters.sinr_tab, 0, NetParameters.sinr_tab.length)];
		tput = tput+ users*bps*70*20*50;
		
	}
	
	
	
	
	return tput/(1024*1024*8);
}



		
}
