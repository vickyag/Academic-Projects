package com.wcn.entities;

public class Location {

	public final float x;
	public final float y ;
	public Location() {
		x = 0;
		y = 0;
	}
	public Location(double x, double y) {
		super();
		this.x = (float) x;
		this.y = (float) y;
	}
	@Override
	public String toString() {
		return "Location [x=" + x + ", y=" + y + "]";
	}
	
	
	public float getX() {
		return x;
	}
	public float getY() {
		return y;
	}
	public double distance(Location loc1,Location loc2){
		//System.out.println(Math.sqrt((loc1.getX() - loc2.getX())*(loc1.getX() - loc2.getX()) + (loc1.getY() - loc2.getY())*(loc1.getY() - loc2.getY())));
		return Math.sqrt((loc1.getX() - loc2.getX())*(loc1.getX() - loc2.getX()) + (loc1.getY() - loc2.getY())*(loc1.getY() - loc2.getY()));
	}
	
	
}
