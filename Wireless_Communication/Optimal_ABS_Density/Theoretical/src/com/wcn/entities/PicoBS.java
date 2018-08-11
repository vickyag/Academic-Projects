package com.wcn.entities;

public class PicoBS {

	private  int edge_users;
	private  int users;
	private float rBs = 0;
	public int blockedUsers = 0;
	public float getrBs() {
		return rBs;
	}


	public void setrBs(float rBs) {
		this.rBs = rBs;
	}


	public void setUsers(int users) {
		this.users = users;
	}


	private  double avg_sinr_ue;
	private  double avg_sinr_ce;
	public void setEdge_users(int edge_users) {
		this.edge_users = edge_users;
	}


	public void setAvg_sinr_ue(double avg_sinr_ue) {
		this.avg_sinr_ue = avg_sinr_ue;
	}


	public void setAvg_sinr_ce(double avg_sinr_ce) {
		this.avg_sinr_ce = avg_sinr_ce;
	}


	public void setRsrp(double rsrp) {
		this.rsrp = rsrp;
	}


	private  double rsrp;
	private final Location loc ;
	private final MacroBS parentMbs ; 
	private final String ID ;
	public PicoBS( String ID ,int users, double avg_sinr_ue, double avg_sinr_ce, double rsrp , Location l ) {
		super();
		this.ID = ID;
		this.users = users;
		this.avg_sinr_ue = avg_sinr_ue;
		this.avg_sinr_ce = avg_sinr_ce;
		this.loc  = l;
		this.rsrp = rsrp;
		this.parentMbs = null;
		this.edge_users = 0;
	}
	
	
	public PicoBS( String ID ,int users, double avg_sinr_ue, double avg_sinr_ce, double rsrp , Location l ,MacroBS parentMbs) {
		super();
		this.ID = ID;
		this.users = users;
		this.avg_sinr_ue = avg_sinr_ue;
		this.avg_sinr_ce = avg_sinr_ce;
		this.loc  = l;
		this.rsrp = rsrp;
		this.parentMbs = parentMbs;
		this.edge_users = 0;
	}
	
	public PicoBS() {
		this.users = 0;
		this.edge_users = 0;
		this.avg_sinr_ce = 0;
		this.avg_sinr_ue = 0;
		this.rsrp = 0;
		loc = null;
		ID = "";
		this.parentMbs = null;
	}


	@Override
	public String toString() {
		return "PicoBS [edge_users=" + edge_users + ", avg_sinr_ue=" + avg_sinr_ue + ", avg_sinr_ce=" + avg_sinr_ce
				+ ", rsrp=" + rsrp + ", loc=" + loc + ", parentMbs=" + parentMbs + ", ID=" + ID + "]";
	}


	public int getEdge_users() {
		return edge_users;
	}


	public int getUsers() {
		return users;
	}


	public double getAvg_sinr_ue() {
		return avg_sinr_ue;
	}


	public double getAvg_sinr_ce() {
		return avg_sinr_ce;
	}


	public double getRsrp() {
		return rsrp;
	}


	public Location getLoc() {
		return loc;
	}


	public MacroBS getParentMbs() {
		return parentMbs;
	}


	public String getID() {
		return ID;
	}


	
	
	
}
