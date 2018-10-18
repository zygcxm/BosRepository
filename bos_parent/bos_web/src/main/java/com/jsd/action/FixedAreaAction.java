package com.jsd.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.ws.rs.core.MediaType;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.client.WebClient;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Actions;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Controller;

import com.jsd.crm.domain.Customer;
import com.jsd.domain.FixedArea;
import com.jsd.service.IFixedAreaService;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;

@Controller
@Actions
@Scope("prototype")
@ParentPackage("struts-default")
@Namespace("/")
public class FixedAreaAction extends ActionSupport implements ModelDriven<FixedArea>{

	@Autowired
	IFixedAreaService fixedAreaService;
	
	FixedArea model = new FixedArea();
	
	@Override
	public FixedArea getModel() {
		return model;
	}
	
	private Integer page;
	
	private Integer rows;
	
	public Integer getPage() {
		return page;
	}

	public void setPage(Integer page) {
		this.page = page;
	}

	public Integer getRows() {
		return rows;
	}

	public void setRows(Integer rows) {
		this.rows = rows;
	}

	@Action(value="fixedAreaAction_pageQuery")
	public void pageQuery() throws Exception {
		Pageable pageable=new PageRequest(page -1, rows);
		
		Specification<FixedArea> spec = new Specification<FixedArea>() {
			@Override
			public Predicate toPredicate(Root<FixedArea> root,
					CriteriaQuery<?> query, CriteriaBuilder cb) {
				 List<Predicate> predicates = new ArrayList<Predicate>();
				 String fixedAreaName = model.getFixedAreaName();
				 if (StringUtils.isNotBlank(fixedAreaName)) {
					 predicates.add(cb.like(root.get("fixedAreaName").as(String.class),"%"+fixedAreaName+"%"));
				 }
				 String fixedAreaLeader = model.getFixedAreaLeader();
				 if (StringUtils.isNotBlank(fixedAreaLeader)) {
					 predicates.add(cb.like(root.get("fixedAreaLeader").as(String.class),"%"+fixedAreaLeader+"%"));
				 }
				 Predicate[] pre = new Predicate[predicates.size()];
		         return query.where(predicates.toArray(pre)).getRestriction();
			}
		};
		
		Page<FixedArea> pages = fixedAreaService.pageQurey(pageable, spec);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("total", pages.getTotalElements());
		map.put("rows", pages.getContent());
		JsonConfig jsonConfig = new JsonConfig();
		String[] excludes={"subareas","couriers"};
		jsonConfig.setExcludes(excludes);
		JSONObject jsonObject = JSONObject.fromObject(map, jsonConfig);
		String string = jsonObject.toString();
		ServletActionContext.getResponse().setContentType("json/text;charset=utf-8");
		ServletActionContext.getResponse().getWriter().print(string);
	}
	
	@Action(value="fixedAreaAction_save",results={
			@Result(name="success",location="/pages/base/fixed_area.jsp")
	})
	public String saveFixedArea() {
		fixedAreaService.saveFixedArea(model);
		return "success";
	}
	
	private String ids;
	
	
	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	@Action(value="fixedAreaAction_delete",results={
			@Result(name="success",location="/pages/base/fixed_area.jsp")
	})
	public String deleteFixedArea() {
		fixedAreaService.deleteFixedArea(ids);
		return "success";
	}
	
	@Action(value="fixedAreaAction_CustomerNoGuanLian")
	public void CustomerNoGuanLian() throws Exception {
		@SuppressWarnings("unchecked")
		List<Customer> list = (List<Customer>) WebClient.create("http://localhost:8080/")
				 .path("maneger_crm/services/customerservice/customer/fixedAreaCustomerNoGuanLian")
				 .type(MediaType.APPLICATION_JSON)
				 .accept(MediaType.APPLICATION_JSON)
				 .getCollection(Customer.class);
		JsonConfig jsonConfig = new JsonConfig();
		String[] excludes={};
		jsonConfig.setExcludes(excludes);
		JSONArray fromObject = JSONArray.fromObject(list, jsonConfig);
		String string = fromObject.toString();
		ServletActionContext.getResponse().setContentType("json/text;charset=utf-8");
		ServletActionContext.getResponse().getWriter().print(string);
	}
	
	@Action(value="fixedAreaAction_CustomerGuanLian")
	public void CustomerGuanLian() throws Exception {
		@SuppressWarnings("unchecked")
		List<Customer> list = (List<Customer>) WebClient.create("http://localhost:8080/")
				 .path("maneger_crm/services/customerservice/customer/fixedAreaCustomersGuanLian")
				 .type(MediaType.APPLICATION_JSON)
				 .accept(MediaType.APPLICATION_JSON)
				 .getCollection(Customer.class);
		JsonConfig jsonConfig = new JsonConfig();
		String[] excludes={};
		jsonConfig.setExcludes(excludes);
		JSONArray fromObject = JSONArray.fromObject(list, jsonConfig);
		String string = fromObject.toString();
		ServletActionContext.getResponse().setContentType("json/text;charset=utf-8");
		ServletActionContext.getResponse().getWriter().print(string);
	}
}
