package com.wcn.main;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;

import javax.xml.ws.Service;

import com.wcn.entities.MacroBS;
import com.wcn.entities.PicoBS;
import com.wcn.entities.Setup;
import com.wcn.service.ServiceImpl;
import com.wcn.utiliies.NetParameters;
import com.wcn.utiliies.UtilMethods;

public class MainClass {
	
	public static float optABS = 0;
	public static float maxRBS = 0;
	public static float avgRBS = 0;
	public static float minRBS = 0;
	public static float total_RBS = 2000;
	
	public static ArrayList<Integer> blockValue;
	public static ArrayList<Integer> Users_sim;
	public static ArrayList<Double> BlkWstProduct_max;
	public static ArrayList<Double> BlkWstProduct_avg;
	public static ArrayList<Double> BlkWstProduct_opt;
	public static ArrayList<Integer> rb_max_sim;
	public static ArrayList<Integer> rb_opt_sim;
	public static ArrayList<Integer> rb_avg_sim;

	public static void mainOld(String args[]){
		
		Setup s = new Setup();
		s.setUp(850);
		//Interbasedistance/2
		
		ArrayList<MacroBS> MBS= s.MBS;
		ArrayList<PicoBS>	PBS = s.PBS;
		float threshold_distance = 0;
		//System.out.println(PBS.get(1));
		
		for(int i = 0 ; i<7 ; i++){
			
			MacroBS temp = MBS.get(i);
			System.out.println("Macro at position:"+temp.getCenter()+"\n neighbor Macros:");
			for(int j = 0 ; j<temp.getNeighbors().size() ; j++)
			System.out.println(temp.getNeighbors().get(j).getCenter());
			System.out.println();
		}
		System.out.println("Pico placed at");
		for(int i = 0 ; i<PBS.size() ; i++){
			System.out.println(PBS.get(i).getID() + "  "+PBS.get(i).getLoc()+" [EdgeUsers:  "+PBS.get(i).getEdge_users()+"]  [avgSinr : "+PBS.get(i).getAvg_sinr_ue()+"]");
		}
		new ServiceImpl().calculateAvgSINRMAcro(MBS.get(0));
		
		
		new ServiceImpl().calculateRb(MBS.get(0));
		
		System.out.println("rbs of macro0:"+MBS.get(0).getRbS());
		
		
		for(int i = 0 ; i<MBS.size() ; i++){
			
			MBS.get(i).setAvg_sinr(MBS.get(0).getAvg_sinr());
			
			
			new ServiceImpl().calculateRb(MBS.get(i));
			System.out.println("rbs of macro "+i+" :"+MBS.get(i).getRbS());
			
			
		}
		
		

		for(int i = 0 ; i<PBS.size() ; i++){
			
			//PBS.get(i).setAvg_sinr(PBS.get(0).getAvg_sinr());
			
			
			new ServiceImpl().calculateRb(PBS.get(i));
			System.out.println("rbs of pico "+i+" :"+PBS.get(i).getrBs());
			
			
		}
		
		ArrayList<Integer> demands = new ArrayList<Integer>();
		
		for(int i  = 0 ; i<PBS.size(); i++){
			
			demands.add((int) PBS.get(i).getrBs());
			//System.out.println("demands : "+demands.get(i));
			
		}
		
		

		
		
		Collections.sort(demands);

		int K_min = 1;
		int K_opt = PBS.size()/2;
		
		
		int K_max = PBS.size()-1;
		System.out.println("=========================");
		System.out.println("Minimum Algorithm gives:");
		MainClass.minRBS = new ServiceImpl().optimalABSdemand(demands, K_min);
		System.out.println("=========================");
		
		System.out.println("Maximum Algortihm gives");
		 MainClass.maxRBS = new ServiceImpl().optimalABSdemand(demands, K_max);
		System.out.println("=========================");
		System.out.println("Optimal Algorithm gives");
		MainClass.optABS =  new ServiceImpl().optimalABSdemand(demands, K_opt);
		System.out.println("=========================");
		System.out.println("Average Algorithm gives");
		MainClass.avgRBS = new ServiceImpl().optimalABSavg(PBS, K_max);
		
		
		// System throughput calculation
		new ServiceImpl().getBlockedUsers(PBS, MBS, MainClass.optABS);
		System.out.println(new ServiceImpl().getSystemThroughput(PBS, MBS));
		
		
		new ServiceImpl().getBlockedUsers(PBS, MBS, MainClass.maxRBS);
		System.out.println(new ServiceImpl().getSystemThroughput(PBS, MBS));
		
		new ServiceImpl().getBlockedUsers(PBS, MBS, MainClass.avgRBS);
		System.out.println(new ServiceImpl().getSystemThroughput(PBS, MBS));
		
		//
for(int i = 0 ; i<7 ; i++){
			
			MacroBS temp = MBS.get(i);
			System.out.println("Macro at position:"+temp.getCenter()+" with users:"+ temp.getNo_users()+"\n neighbor Macros:");
			System.out.println("macro avg Sinr: "+temp.getAvg_sinr()+" Macro blocked user: "+temp.blockedUsers);
			for(int j = 0 ; j<temp.getNeighbors().size() ; j++)
			System.out.println(temp.getNeighbors().get(j).getCenter());
			System.out.println();
		}
System.out.println("=========================");
//		new ServiceImpl().getBlockedUsersPico(PBS, MainClass.optABS);
//		
//		for(int i = 0 ; i<PBS.size() ; i++){
//			System.out.println(PBS.get(i).getID() + "  [EdgeUsers:  "+PBS.get(i).getEdge_users()+"]  [avgSinr : "+PBS.get(i).getAvg_sinr_ue()+" blocked Users:"+PBS.get(i).blockedUsers+" ]");
//		}
//		
		
		System.out.println("=========================");
		
	new ServiceImpl().getBlockedUsersPico(PBS, MainClass.optABS);
		
		for(int i = 0 ; i<PBS.size() ; i++){
			System.out.println(PBS.get(i).getID() + "  [EdgeUsers:  "+PBS.get(i).getEdge_users()+"]  [avgSinr : "+PBS.get(i).getAvg_sinr_ue()+" blocked Users:"+PBS.get(i).blockedUsers+" ]");
		}
		
		
		System.out.println("=========================");
	new ServiceImpl().getBlockedUsersPico(PBS, MainClass.avgRBS);
		
		for(int i = 0 ; i<PBS.size() ; i++){
			System.out.println(PBS.get(i).getID() + "  [EdgeUsers:  "+PBS.get(i).getEdge_users()+"]  [avgSinr : "+PBS.get(i).getAvg_sinr_ue()+" blocked Users:"+PBS.get(i).blockedUsers+" ]");
		}
		
		System.out.println("=========================");
	new ServiceImpl().getBlockedUsersPico(PBS, MainClass.maxRBS);
		
		for(int i = 0 ; i<PBS.size() ; i++){
			System.out.println(PBS.get(i).getID() + "  [EdgeUsers:  "+PBS.get(i).getEdge_users()+"]  [avgSinr : "+PBS.get(i).getAvg_sinr_ue()+" blocked Users:"+PBS.get(i).blockedUsers+" ]");
		}
	
		
		//System.out.println(MainClass.avgRBS+"  "+MainClass.optABS+"   "+MainClass.maxRBS);
		
		
	
		int no_of_users_macro = 0;
		int no_of_users_pico = 0;
		int blk_macro = 0;
		int blk_pico = 0;
		
		for(int i = 0 ; i<MBS.size() ; i++){
			
		no_of_users_macro = no_of_users_macro + MBS.get(i).getNo_users();
		blk_macro = blk_macro+MBS.get(i).blockedUsers;
		//blk_pico = 0
			
		}
		
	for(int i = 0 ; i<PBS.size() ; i++){
			no_of_users_pico = no_of_users_pico + PBS.get(i).getUsers();
			blk_pico = blk_pico+PBS.get(i).blockedUsers;
		}
		
		
		new ServiceImpl().getBlockedUsers(PBS, MBS, MainClass.optABS);
		System.out.println(new ServiceImpl().getSystemThroughput(PBS, MBS));
		
		
		new ServiceImpl().getBlockedUsers(PBS, MBS, MainClass.maxRBS);
		System.out.println(new ServiceImpl().getSystemThroughput(PBS, MBS));
		
		new ServiceImpl().getBlockedUsers(PBS, MBS, MainClass.avgRBS);
		System.out.println(new ServiceImpl().getSystemThroughput(PBS, MBS));
		
	
		System.out.println("total users:"+(no_of_users_macro+no_of_users_pico));
		System.out.println("blocked users:"+(blk_pico+blk_macro));
		
		System.out.println("block_percentage"+(blk_pico+blk_macro)*100/(no_of_users_macro+no_of_users_pico));
		
		
	}
	
	public static void Simulate(){
		
		
		
		Setup s = new Setup();
		s.setUp(850);
		//Interbasedistance/2
		
		ArrayList<MacroBS> MBS= s.MBS;
		ArrayList<PicoBS>	PBS = s.PBS;
		float threshold_distance = 0;
		//System.out.println(PBS.get(1));
		
		for(int i = 0 ; i<7 ; i++){
			
			MacroBS temp = MBS.get(i);
			System.out.println("Macro at position:"+temp.getCenter()+"\n neighbor Macros:");
			for(int j = 0 ; j<temp.getNeighbors().size() ; j++)
			System.out.println(temp.getNeighbors().get(j).getCenter());
			System.out.println();
		}
		System.out.println("Pico placed at");
		for(int i = 0 ; i<PBS.size() ; i++){
			System.out.println(PBS.get(i).getID() + "  "+PBS.get(i).getLoc()+" [EdgeUsers:  "+PBS.get(i).getEdge_users()+"]  [avgSinr : "+PBS.get(i).getAvg_sinr_ue()+"]");
		}
		new ServiceImpl().calculateAvgSINRMAcro(MBS.get(0));
		
		
		new ServiceImpl().calculateRb(MBS.get(0));
		
		System.out.println("rbs of macro0:"+MBS.get(0).getRbS());
		
		
		for(int i = 0 ; i<MBS.size() ; i++){
			
			MBS.get(i).setAvg_sinr(MBS.get(0).getAvg_sinr());
			
			
			new ServiceImpl().calculateRb(MBS.get(i));
			System.out.println("rbs of macro "+i+" :"+MBS.get(i).getRbS());
			
			
		}
		
		

		for(int i = 0 ; i<PBS.size() ; i++){
			
			//PBS.get(i).setAvg_sinr(PBS.get(0).getAvg_sinr());
			
			
			new ServiceImpl().calculateRb(PBS.get(i));
			System.out.println("rbs of pico "+i+" :"+PBS.get(i).getrBs());
			
			
		}
		
		ArrayList<Integer> demands = new ArrayList<Integer>();
		
		for(int i  = 0 ; i<PBS.size(); i++){
			
			demands.add((int) PBS.get(i).getrBs());
			//System.out.println("demands : "+demands.get(i));
			
		}
		
		

		
		
		Collections.sort(demands);

		int K_min = 1;
		int K_opt = PBS.size()/2;
		
		
		int K_max = PBS.size()-1;
		System.out.println("=========================");
		System.out.println("Minimum Algorithm gives:");
		MainClass.minRBS = new ServiceImpl().optimalABSdemand(demands, K_min );
		System.out.println("=========================");
		
		System.out.println("Maximum Algortihm gives");
		 MainClass.maxRBS = new ServiceImpl().optimalABSdemand(demands, K_max , BlkWstProduct_max);
		System.out.println("=========================");
		System.out.println("Optimal Algorithm gives");
		MainClass.optABS =  new ServiceImpl().optimalABSdemand(demands, K_opt , BlkWstProduct_opt);
		System.out.println("=========================");
		System.out.println("Average Algorithm gives");
		MainClass.avgRBS = new ServiceImpl().optimalABSavg(PBS, K_max , BlkWstProduct_avg);
		
		rb_max_sim.add((int) MainClass.maxRBS);
		rb_opt_sim.add((int) MainClass.optABS);
		rb_avg_sim.add((int) MainClass.avgRBS);
		
		
		// System throughput calculation
		new ServiceImpl().getBlockedUsers(PBS, MBS, MainClass.optABS);
		System.out.println(new ServiceImpl().getSystemThroughput(PBS, MBS));
		
		
		new ServiceImpl().getBlockedUsers(PBS, MBS, MainClass.maxRBS);
		System.out.println(new ServiceImpl().getSystemThroughput(PBS, MBS));
		
		new ServiceImpl().getBlockedUsers(PBS, MBS, MainClass.avgRBS);
		System.out.println(new ServiceImpl().getSystemThroughput(PBS, MBS));
		
		//
for(int i = 0 ; i<7 ; i++){
			
			MacroBS temp = MBS.get(i);
			System.out.println("Macro at position:"+temp.getCenter()+" with users:"+ temp.getNo_users()+"\n neighbor Macros:");
			System.out.println("macro avg Sinr: "+temp.getAvg_sinr()+" Macro blocked user: "+temp.blockedUsers);
			for(int j = 0 ; j<temp.getNeighbors().size() ; j++)
			System.out.println(temp.getNeighbors().get(j).getCenter());
			System.out.println();
		}
System.out.println("=========================");
//		new ServiceImpl().getBlockedUsersPico(PBS, MainClass.optABS);
//		
//		for(int i = 0 ; i<PBS.size() ; i++){
//			System.out.println(PBS.get(i).getID() + "  [EdgeUsers:  "+PBS.get(i).getEdge_users()+"]  [avgSinr : "+PBS.get(i).getAvg_sinr_ue()+" blocked Users:"+PBS.get(i).blockedUsers+" ]");
//		}
//		
		
		System.out.println("=========================");
		
	new ServiceImpl().getBlockedUsersPico(PBS, MainClass.optABS);
		
		for(int i = 0 ; i<PBS.size() ; i++){
			System.out.println(PBS.get(i).getID() + "  [EdgeUsers:  "+PBS.get(i).getEdge_users()+"]  [avgSinr : "+PBS.get(i).getAvg_sinr_ue()+" blocked Users:"+PBS.get(i).blockedUsers+" ]");
		}
		
		
		System.out.println("=========================");
	new ServiceImpl().getBlockedUsersPico(PBS, MainClass.avgRBS);
		
		for(int i = 0 ; i<PBS.size() ; i++){
			System.out.println(PBS.get(i).getID() + "  [EdgeUsers:  "+PBS.get(i).getEdge_users()+"]  [avgSinr : "+PBS.get(i).getAvg_sinr_ue()+" blocked Users:"+PBS.get(i).blockedUsers+" ]");
		}
		
		System.out.println("=========================");
	new ServiceImpl().getBlockedUsersPico(PBS, MainClass.maxRBS);
		
		for(int i = 0 ; i<PBS.size() ; i++){
			System.out.println(PBS.get(i).getID() + "  [EdgeUsers:  "+PBS.get(i).getEdge_users()+"]  [avgSinr : "+PBS.get(i).getAvg_sinr_ue()+" blocked Users:"+PBS.get(i).blockedUsers+" ]");
		}
	
		
		//System.out.println(MainClass.avgRBS+"  "+MainClass.optABS+"   "+MainClass.maxRBS);
		
		
	
		int no_of_users_macro = 0;
		int no_of_users_pico = 0;
		int blk_macro = 0;
		int blk_pico = 0;
		
		for(int i = 0 ; i<MBS.size() ; i++){
			
		no_of_users_macro = no_of_users_macro + MBS.get(i).getNo_users();
		blk_macro = blk_macro+MBS.get(i).blockedUsers;
		//blk_pico = 0
			
		}
		
	for(int i = 0 ; i<PBS.size() ; i++){
			no_of_users_pico = no_of_users_pico + PBS.get(i).getUsers();
			blk_pico = blk_pico+PBS.get(i).blockedUsers;
		}
		
		
		new ServiceImpl().getBlockedUsers(PBS, MBS, MainClass.optABS);
		System.out.println("Proposed Algorithm Throughput in Megabytes/10ms: "+new ServiceImpl().getSystemThroughput(PBS, MBS));
		
		
		new ServiceImpl().getBlockedUsers(PBS, MBS, MainClass.maxRBS);
		System.out.println("Max Algorithm Throughput in Megabytes/10ms: "+new ServiceImpl().getSystemThroughput(PBS, MBS));
		
		new ServiceImpl().getBlockedUsers(PBS, MBS, MainClass.avgRBS);
		System.out.println("Average Algorithm Throughput in Megabytes/10ms: "+new ServiceImpl().getSystemThroughput(PBS, MBS));
		
	
		System.out.println("total users:"+(no_of_users_macro+no_of_users_pico));
		System.out.println("blocked users:"+(blk_pico+blk_macro));
		
		System.out.println("block_percentage"+(blk_pico+blk_macro)*100/(no_of_users_macro+no_of_users_pico));
		
		blockValue.add((blk_pico+blk_macro)*100/(no_of_users_macro+no_of_users_pico));
		Users_sim.add((no_of_users_macro+no_of_users_pico));
		
}
	
	public static void main(String... args){
		
		blockValue = new ArrayList<Integer>();
		Users_sim = new ArrayList<Integer>();
		BlkWstProduct_max = new ArrayList<Double>();
		BlkWstProduct_opt = new ArrayList<Double>();
		BlkWstProduct_avg = new ArrayList<Double>();
		rb_avg_sim = new ArrayList<Integer>();
		rb_max_sim = new ArrayList<Integer>();
		rb_opt_sim = new ArrayList<Integer>();
		for(int i = 0 ; i<100 ; i++){
			
			Simulate();
			
		
		}
		
		for(int i = 0 ; i<blockValue.size() ; i++){
			
			System.out.print(blockValue.get(i)+";");
			
			
		}
		
		System.out.println("\n\n\n\n\n");

		for(int i = 0 ; i<BlkWstProduct_avg.size() ; i++){
			
			System.out.print(BlkWstProduct_avg.get(i)+";");
			
			
		}
		System.out.println();
		
for(int i = 0 ; i<rb_avg_sim.size() ; i++){
			
			System.out.print(rb_avg_sim.get(i)+";");
			
			
		}
		
		
System.out.println("\n\n\n\n\n");
		
		
for(int i = 0 ; i<BlkWstProduct_max.size() ; i++){
			
			System.out.print(BlkWstProduct_max.get(i)+";");
			
			
		}
System.out.println();

for(int i = 0 ; i<rb_max_sim.size() ; i++){
		
		System.out.print(rb_max_sim.get(i)+";");
		
		
	}
	

System.out.println("\n\n\n\n\n");

for(int i = 0 ; i<BlkWstProduct_opt.size() ; i++){
	
	System.out.print(BlkWstProduct_opt.get(i)+";");
	
	
}

System.out.println();

for(int i = 0 ; i<rb_opt_sim.size() ; i++){
		
		System.out.print(rb_opt_sim.get(i)+";");
		
		
	}
	
		
		
	}
	
	
	
	
}
