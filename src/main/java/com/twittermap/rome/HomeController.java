package com.twittermap.rome;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import UserApplication.UserApplication;

import com.beans.TweetInfo;
import com.database.DB;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	ApplicationContext context;
	DB database;
	UserApplication ua;
	HashMap<String,HashMap<Long, TweetInfo>> wholeList = new HashMap<String,HashMap<Long, TweetInfo>>();
	ArrayList<String> filterList;
	ArrayList<Integer> numberInFilterList = new ArrayList<Integer>();
	String currentKey;
	int currentLimit=200;
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	public HomeController(){
		context =  new ClassPathXmlApplicationContext("classpath:META-INF/my_context.xml");
		database = (DB)context.getBean("database");
		database.connect();
		ua = new UserApplication(database);
	}
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(HttpServletRequest request, Model model) {
		//Date date = new Date();
		//String formattedDate = dateFormat.format(date);
		String keys = request.getParameter("keys");
		filterList = database.filterList(numberInFilterList, ua.getStream());
		String filter = request.getParameter("filter");
		String startStream = request.getParameter("inputKey");
		String limit = request.getParameter("limit");
		if(limit!=null){
			database.setLimit(Integer.parseInt(limit));
			currentLimit=Integer.parseInt(limit);
		}
		if(keys!=null){
			ua.endStream(keys);
		}
		if(startStream!=null){
			ua.startStream(startStream);
		}
		if(filter!=null){
			currentKey = filter;
		}
		wholeList.clear();
		database.readPosition(wholeList, currentKey);
		model.addAttribute("wholeList",wholeList);
		model.addAttribute("filterKey",currentKey);
		model.addAttribute("filterList",filterList);
		model.addAttribute("number",numberInFilterList);
		model.addAttribute("keys",ua.getStream());
		model.addAttribute("limit",currentLimit);
		//model.addAttribute("serverTime", database.test().get(0));
		return "home";
	}
}
