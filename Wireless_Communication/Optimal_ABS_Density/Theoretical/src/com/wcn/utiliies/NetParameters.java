package com.wcn.utiliies;

import java.util.ArrayList;
import java.util.List;

public class NetParameters {

	

	//macro based statio transmit power = 46dbM(40 Watt)
	///pico base station power = 30dbM (1 Watt)
	// range of rsrp values -140 -44
	public static final int seed_users = 17;
	public static final int seed_location = 17;
	public static final int pico_users = 60;
	public static final int macro_users = 100;
	
	public static  final int macro_stations = 7;
	public static final int pico_stations = 3;
	List<Integer> data_rates =new ArrayList<Integer>();
	public static final float gamma_threshold = -72;//-78.7629f;  //-120 paper reference
	public static final float pico_power = 30;  //dbM
	public static final float A_pico_to_UE = 140.1f;  
	public static final float B_pico_to_UE = 36.7f;
	
	public static final float[] sinr_tab = {-6.50f , -4 , -2.60f , - 1, 1 , 3 , 6.60f , 10 , 11.40f ,11.80f , 13 ,13.80f, 15.60f , 16.80f , 17.60f} ;
	public static final double[] bps = {0.23 , 0.38 , 0.60 , 0.88 , 1.18 , 1.48 , 1.91 , 2.41 , 2.73 , 3.32 , 3.90 , 4.52 , 552 , 5.15} ;
	public static final int data_rate[] = {128 , 256 , 512 , 1024};
	public static final int ratio_users[] = {4 , 3 , 2 , 1};
	//public static final float[] data_rate = {256 , 512 , 1024 , 2048};
	
	public static final float macro_power = 46; //dbM
	public static final float A_macro_to_UE = 128.1f;
	public static final float B_macro_to_UE = 37.6f;
	
	public static final float pi = 3.14f;
	public static final float pico_radius = 100;  
	public static final float macro_radius = 750;
	public static final float default_syms = 70;		//70 symbols are used from 84 symbols
	
	
}
