package com.database;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;

import javax.sql.DataSource;

import org.springframework.context.annotation.Scope;

import com.beans.TweetInfo;

@Scope("singleton")
public class DB
{
	private DataSource dataSource;
	private String databaseName;
	private Statement stmt;
	private Connection conn;
	private Query query;
	public void setDatabaseName(String name){
		databaseName=name;
	}
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	public DataSource getDataSource(){
		return dataSource;
	}
	public void connect(){
		try {
			conn = dataSource.getConnection();
			stmt = conn.createStatement();
			if(databaseName!=null){
			stmt.execute("use "+databaseName);
			query=new Query(conn);
			stmt.close();
			}
		} catch (SQLException e) {
			throw new RuntimeException(e);
 
		}
	}
	public void close(){
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {}
		}
	}
	public ArrayList<String> test(){
		try {
			ArrayList<String> result = new ArrayList<String>();
			ResultSet rset = stmt.executeQuery("select * from rome");
			while(rset.next()){
				result.add(rset.getString(1));
			}
			return result;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	public void fetchPosition(long id, String key, String Text, double Lat, double Long, String time){
		query.insert(id, key, Text, Lat, Long, time);
	}
	public void readPosition(HashMap<String,HashMap<Long, TweetInfo>> list, String key){
		query.read(list, key);
	}
	public ArrayList<String> filterList(ArrayList<Integer> numbers, ArrayList<String> addition){
		ArrayList<String> result = new ArrayList<String>();
		HashSet<String> tmp = new HashSet<String>();
		tmp.addAll(query.filterList());
		tmp.addAll(addition);
		for(String tmpString:tmp){
			result.add(tmpString);
		}
		numbers.clear();
		for(int i=0;i<result.size();i++){
			numbers.add(query.getNumber(result.get(i)));
		}
		return result;
	}
	public void setLimit(int limit){
		query.setLimit(limit);
	}
}
