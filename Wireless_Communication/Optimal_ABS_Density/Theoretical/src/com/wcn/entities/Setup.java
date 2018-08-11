package com.wcn.entities;



import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;

import javax.rmi.CORBA.Util;

import com.wcn.service.ServiceImpl;
import com.wcn.utiliies.NetParameters;
import com.wcn.utiliies.UtilMethods;

public class Setup {
	
	public static ArrayList<MacroBS> MBS = null;
	public static ArrayList<PicoBS> PBS = null;
	
	
	
	public static void setUp(double R){
	ServiceImpl service = new ServiceImpl();


Location l1 = new Location(0,0);
Location l2 = new Location(Math.pow(3, 0.5)*0.5*R,R*1.5);
Location l3 = new Location(Math.pow(3, 0.5)*R,0);
Location l4 = new Location(Math.pow(3, 0.5)*0.5*R,-R*1.5);
Location l5 = new Location(-Math.pow(3, 0.5)*0.5*R,-R*1.5);
Location l6 = new Location(-Math.pow(3, 0.5)*R,0);
Location l7 = new Location(-Math.pow(3, 0.5)*0.5*R,R*1.5);
Location l8 = new Location(0,3*R);
Location l9 = new Location(Math.pow(3, 0.5)*R,3*R);
Location l10 = new Location(1.5*Math.pow(3, 0.5)*R,1.5*R);
Location l11 = new Location(2*Math.pow(3, 0.5)*R,0);
Location l12 = new Location(1.5*Math.pow(3, 0.5)*R,-1.5*R);
Location l13 = new Location(Math.pow(3, 0.5)*R,-3*R);
Location l14 = new Location(0,-3*R);
Location l15 = new Location(-Math.pow(3, 0.5)*R,-3*R);
Location l16 = new Location(-1.5*Math.pow(3, 0.5)*R,-1.5*R);
Location l17 = new Location(-2*Math.pow(3, 0.5)*R,0);
Location l18 = new Location(-1.5*Math.pow(3, 0.5)*R,1.5*R);
Location l19 = new Location(-Math.pow(3, 0.5)*R,3*R);
	
	
	ArrayList<Location> ls = new ArrayList<Location>();
	{
	ls.add(l1);
	ls.add(l2);
	ls.add(l3);
	ls.add(l4);
	ls.add(l5);
	ls.add(l6);
	ls.add(l7);
	ls.add(l8);
	ls.add(l9);
	ls.add(l10);
	ls.add(l11);
	ls.add(l12);
	ls.add(l13);
	ls.add(l14);
	ls.add(l15);
	ls.add(l16);
	ls.add(l17);
	ls.add(l18);
	ls.add(l19);
	}
	try{
	
	ArrayList<MacroBS> mbs = new ArrayList<MacroBS>();
	ArrayList<PicoBS> picoStation ;
	//constructor public MacroBS(int pico_num, ArrayList<Location> neighbors, float avg_sinr, int id, int no_users) {
	for(int i = 1 ; i<=19 ; i++){	
		int num_pico = 3;
		if(i%2 == 0)
			num_pico = 4;
		
		Random r = new Random();
		//r.setSeed(1234);
		//change load of macro
		int noOfUser  = (int) (55 + (r.nextFloat()*100)*0.25);
		mbs.add(new MacroBS( num_pico , null, ls.get(i-1) , 0f , i , noOfUser));
		
		System.out.println(mbs.get(i-1).getId()+"  "+mbs.get(i-1).getCenter());
	}
	
	//add neighbors
	
	mbs.get(0).addNeighbor(mbs.get(2)).addNeighbor(mbs.get(3)).addNeighbor(mbs.get(4)).addNeighbor(mbs.get(5)).addNeighbor(mbs.get(6)).addNeighbor(mbs.get(1));
	mbs.get(1).addNeighbor(mbs.get(2)).addNeighbor(mbs.get(9)).addNeighbor(mbs.get(8)).addNeighbor(mbs.get(7)).addNeighbor(mbs.get(6)).addNeighbor(mbs.get(0));
	mbs.get(2).addNeighbor(mbs.get(0)).addNeighbor(mbs.get(1)).addNeighbor(mbs.get(3)).addNeighbor(mbs.get(11)).addNeighbor(mbs.get(10)).addNeighbor(mbs.get(9));
	mbs.get(3).addNeighbor(mbs.get(0)).addNeighbor(mbs.get(2)).addNeighbor(mbs.get(4)).addNeighbor(mbs.get(12)).addNeighbor(mbs.get(13)).addNeighbor(mbs.get(11));
	mbs.get(4).addNeighbor(mbs.get(0)).addNeighbor(mbs.get(3)).addNeighbor(mbs.get(5)).addNeighbor(mbs.get(14)).addNeighbor(mbs.get(13)).addNeighbor(mbs.get(15));
	mbs.get(5).addNeighbor(mbs.get(0)).addNeighbor(mbs.get(4)).addNeighbor(mbs.get(6)).addNeighbor(mbs.get(15)).addNeighbor(mbs.get(16)).addNeighbor(mbs.get(17));
	mbs.get(6).addNeighbor(mbs.get(0)).addNeighbor(mbs.get(1)).addNeighbor(mbs.get(7)).addNeighbor(mbs.get(5)).addNeighbor(mbs.get(17)).addNeighbor(mbs.get(18));
	
	
	picoStation = new ArrayList<PicoBS>();
	
	for(int i = 0 ; i<7 ; i++){
		
		//public PicoBS( int ID ,int users, double avg_sinr_ue, double avg_sinr_ce, double rsrp , Location l ,MacroBS parentMbs)
		
		ArrayList<Location> locs = UtilMethods.getPicoLoc(mbs.get(i), 0);
		
		int num_pico = mbs.get(i).getPico_num();
		//System.out.println(num_pico);
		Scanner s = new Scanner(System.in);
		for(int j = 0 ; j<num_pico ; j++){
			
			//change load of pico
			
			int users =(int)Math.ceil( new Random().nextFloat()*50);
			
			float threshold_distance = 0;
			
			
			
			
			
			//threshold_distance = service.getDistanceFromRsRp(NetParameters.gamma_threshold);
			PicoBS pbs  = new PicoBS(i+"m"+j , users , 0, 0, 0,locs.get(j),mbs.get(i));
			
			System.out.println(pbs.getID()+"pico generated at "+pbs.getLoc());
			
			int edge_users = service.getUserDensity((float)service.getDistanceThreshold(mbs.get(i), pbs) , users);
			
			threshold_distance = (float)service.getDistanceThreshold(mbs.get(i), pbs);
			
			
			
			float avgsinr1 = service.calculateAvgSINRnew(pbs, mbs.get(i), threshold_distance, 0);
			float avgsinr2 = service.calculateAvgSINRnew(pbs, mbs.get(i), threshold_distance, 5);
			float avgsinr3 = service.calculateAvgSINRnew(pbs, mbs.get(i), threshold_distance, 7.5);
			float avgsinr4 = service.calculateAvgSINRnew(pbs, mbs.get(i), threshold_distance, 15);
			float avgsinr5 = service.calculateAvgSINRnew(pbs, mbs.get(i), threshold_distance, 20);
			
			double average_over_theta = (avgsinr1+avgsinr2+avgsinr3+avgsinr4+avgsinr5)*0.2;
			
			pbs.setUsers(users);
			pbs.setAvg_sinr_ue(average_over_theta);
			pbs.setEdge_users(edge_users);
			picoStation.add(pbs);
			System.out.println("distance from macro is:"+UtilMethods.distance(pbs.getLoc(), mbs.get(i).getCenter()));
			System.out.println("pico is :"+pbs.getID()+"   "+" users are  "+users+"   "+edge_users + " :edgeusers threshold:  "+threshold_distance +" avg sinr "+average_over_theta);
			
			
			
			
			
		}
		
	}
	
	MBS  = mbs; 
	PBS = picoStation;
	
	}
	catch(Exception e){
		e.printStackTrace();
		
	}
	}
	
	

}
