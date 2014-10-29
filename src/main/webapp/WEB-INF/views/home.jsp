<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" import="java.util.HashMap" import="java.util.ArrayList" import="com.beans.TweetInfo"%>
<html>
<head>
	<% HashMap<String, HashMap<Integer, TweetInfo>> wholeList;
	   wholeList = (HashMap<String, HashMap<Integer, TweetInfo>>)request.getAttribute("wholeList");
	   String filterKey = (String)request.getAttribute("filterKey");
	   int size=0;
	   ArrayList<TweetInfo> listAfterFilter = new ArrayList<TweetInfo>();
	   if(wholeList!=null && filterKey!=null && wholeList.get(filterKey)!=null){
	   		size = wholeList.get(filterKey).size();
	   		for(TweetInfo tweet:wholeList.get(filterKey).values()){
	   			listAfterFilter.add(tweet);
	   		}
	   }
	%>
	<script type="text/javascript" 
     src="http://maps.google.com/maps/api/js?  
                   key=AIzaSyDGOiekhlovikxS8oKxObYbQlrY7GZf1QE&sensor=false">
	</script>
	<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=visualization"></script>
	<title>Home</title>
</head>
<body onload="GetMap()">
<script type="text/javascript">
	var map2;
	var map;
	var heatmap;
	var pointarray;
	var taxiData=[];
	var marker=[];
	var infowindow=[];
	function initialPoints(){
		<%
		if(listAfterFilter.size()!=0){
			for(int index=0;index<size;index++){
				%>
				taxiData[<%=index%>]=new google.maps.LatLng(<%=listAfterFilter.get(index).getLatitude()%>,<%=listAfterFilter.get(index).getLongitude()%>);
				marker[<%=index%>] = new google.maps.Marker({
					map: map,
					position: new google.maps.LatLng(<%=listAfterFilter.get(index).getLatitude()%>,<%=listAfterFilter.get(index).getLongitude()%>)
					});
				infowindow[<%=index%>] = new google.maps.InfoWindow();
				  infowindow[<%=index%>].setContent('<%=listAfterFilter.get(index).getTime()%> : '+'<%=listAfterFilter.get(index).getQueryText()%>');
				  google.maps.event.addListener(marker[<%=index%>], 'click', function() {
					  infowindow[<%=index%>].open(map, marker[<%=index%>]);
				  });
				<%
			}
		}
		%>
		var pointArray = new google.maps.MVCArray(taxiData);
		heatmap = new google.maps.visualization.HeatmapLayer({
		    data: pointArray
		  });
		heatmap.setMap(map2);
	}
	function GetMap(){
		mainMap();
		heatMap();
		initialPoints();
	}
	function mainMap(){
		var latlng= new google.maps.LatLng(0,0);
		var myOptions={
				zoom: 1,
				center: latlng,
				mapTypeId: google.maps.MapTypeId.ROADMAP
		};
		var container = document.getElementById("mapContainer");
		map = new google.maps.Map(container,myOptions);
	}
	function heatMap(){
		var latlng= new google.maps.LatLng(0,0);
		var myOptions={
				zoom: 1,
				center: latlng,
				mapTypeId: google.maps.MapTypeId.SATELLITE
		};
		var container = document.getElementById("mapContainer2");
		map2 = new google.maps.Map(container,myOptions);
	}
</script>
<% 
	ArrayList<String> keyList=(ArrayList<String>)request.getAttribute("keys");
	ArrayList<String> filterList=(ArrayList<String>)request.getAttribute("filterList");
	ArrayList<Integer> numbers = (ArrayList<Integer>)request.getAttribute("number");
	int limit = (Integer)request.getAttribute("limit");
%>
<table>
<tr>
<td>
<form action="" method="get">
Key Words<br>
<input type="text" name="inputKey">
<input type="submit" name="start" value="search for key word!">
</form>
<form>
Number Limit(can only affect current searching)<br>
<input type="text" name="limit" value=<%=limit%>>
<input type="submit" value="OK">
</form>
Current Searching<form action="" method="get">
<select id="keys" name="keys">
	<% 
		for(int i=0;i<keyList.size();i++){
	%>
	<option value="<%=keyList.get(i)%>"><%=keyList.get(i)%></option>
	<% 
		}
	%>
</select>
<input type="submit" name="stop" value="stop">
</form>
Filter Selection<form action="" method="get">
<select id="filter" name="filter">
	<% 
		for(int i=0;i<filterList.size();i++){
	%>
	<option value="<%=filterList.get(i)%>" <% if(filterList.get(i).equals(filterKey)){%>selected="selected"<%}%>><%=filterList.get(i)%></option>
	<% 
		}
	%>
</select>
<input type="submit" name="filter" value="filter"><br>
</form>
<% 
if(filterList!=null){
for(int i=0;i<filterList.size();i++){ %>
	<p>key word: <%=filterList.get(i)%>-------#:<%=numbers.get(i)%></p>
	<%
	}
}%>
</td>
<td valign="top">
<div id="mapContainer" style="width:500px;height:500px">
</div>
</td>
<td valign="top">
<div id="mapContainer2" style="width:500px;height:500px">
</div>
</td>
</tr>
</table>
</body>
</html>
