package com.wcn.entities;

import java.util.ArrayList;

public class MacroBS  {

	
	private final int pico_num;
	private final Location center;
	private  ArrayList<MacroBS> neighbors;
	private  float avg_sinr;
	private final int id;
	private  int no_users;

	private float rbS = 0;
	 public int blockedUsers = 0;
	
	public float getRbS() {
		return rbS;
	}


	public void setRbS(float rbS) {
		this.rbS = rbS;
	}


	public MacroBS(int pico_num, ArrayList<MacroBS> neighbors,Location center, float avg_sinr, int id, int no_users) {
		super();
		this.pico_num = pico_num;
		this.neighbors = neighbors;
		this.avg_sinr = avg_sinr;
		this.id = id;
		this.no_users = no_users;
		this.center = center;
	}
	
		
	public MacroBS() {
		
		pico_num = 0;
		neighbors = null;
		avg_sinr = 0;
		id = 0;
		no_users = 0;
		center = null;
		
	}
	
	MacroBS addNeighbor(MacroBS mbs){
		
		if(this.neighbors == null){
			this.neighbors = new ArrayList<MacroBS>();
			this.neighbors.add(mbs);
		}
		
		else
		this.neighbors.add(mbs);
		
		return this;
		
	}


	@Override
	public String toString() {
		return "MacroBS [pico_num=" + pico_num + ", center=" + center + ", neighbors=" + neighbors + ", avg_sinr="
				+ avg_sinr + ", id=" + id + ", no_users=" + no_users + "]";
	}


	public ArrayList<MacroBS> getNeighbors() {
		return neighbors;
	}


	public void setNeighbors(ArrayList<MacroBS> neighbors) {
		this.neighbors = neighbors;
	}


	public float getAvg_sinr() {
		return avg_sinr;
	}


	public void setAvg_sinr(float avg_sinr) {
		this.avg_sinr = avg_sinr;
	}


	public int getNo_users() {
		return no_users;
	}


	public void setNo_users(int no_users) {
		this.no_users = no_users;
	}


	public int getPico_num() {
		return pico_num;
	}


	public Location getCenter() {
		return center;
	}


	public int getId() {
		return id;
	}
	
	
	
	
	
	
	
}
