package com.wcn.utiliies;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import com.wcn.entities.Location;
import com.wcn.entities.MacroBS;

public class UtilMethods {

public static ArrayList<Location> getPicoLoc(MacroBS mbs , float dist ){
	
	ArrayList<Location> loc_list = new ArrayList<Location>();
	
	
	int count = 0;
	while(loc_list.size()!=mbs.getPico_num() && count <20){
		 count++;
		Random m = new Random();
		float f1 = m.nextFloat();
		float f2 = m.nextFloat();
		//System.out.println(f1+"rand num"+f2);
		float x = mbs.getCenter().x + (NetParameters.macro_radius - NetParameters.pico_radius)*f1  + NetParameters.macro_radius/10;
		float y = mbs.getCenter().y + (NetParameters.macro_radius - NetParameters.pico_radius)*f2 + NetParameters.macro_radius/10;
		
		float xneg = mbs.getCenter().x - (NetParameters.macro_radius - NetParameters.pico_radius)*f1 - NetParameters.macro_radius/10;
		float yneg = mbs.getCenter().y - (NetParameters.macro_radius - NetParameters.pico_radius)*f2 - NetParameters.macro_radius/10;
		
		
		
		
		
		if(checkPico(loc_list , new Location(x,y))){
			//System.out.println("valid");
			loc_list.add(new Location(x,y));
			
		}
		 if(checkPico(loc_list , new Location(xneg,yneg))){
			//System.out.println("valid");
			loc_list.add(new Location(xneg,yneg));
			
		}
		
		
		
		
		
	}
	
	
	return loc_list;
	
}
	
public static boolean checkPico(List<Location> l_list, Location l){
	
	//return true;
	if (l_list.size() == 0)
		return true;
	for(int i= 0 ; i < l_list.size() ; i++){
		Location temp = l_list.get(i);
		if(l.distance(temp,l) < Math.pow(3, 0.5)*NetParameters.macro_radius/4){
			return false;
		}
		
 		
	}
	return true;
	
}




public static float dbMtoWatt(float dbM){
	return (float)Math.pow(10,(dbM/10f))/1000f;
}

	

public static double distance(Location loc1,Location loc2){
	return Math.sqrt((loc1.getX() - loc2.getX())*(loc1.getX() - loc2.getX()) + (loc1.getY() - loc2.getY())*(loc1.getY() - loc2.getY()));
}



public static int binSearch( float val , float[] arr , int start , int end ){	
	
	
	while(start<=end)		
	{
    int mid = (start + end)/2;
	if (mid == 0 || (arr[mid] >= val && arr[mid-1] < val)) return mid;
	else if(arr[mid] < val) start = mid+1;
	else end = mid-1;
	}		
	return -1;
}


	
}
