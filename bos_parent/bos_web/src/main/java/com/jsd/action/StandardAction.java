package com.jsd.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
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

import com.jsd.domain.Standard;
import com.jsd.service.IStandardService;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;

@ParentPackage("struts-default")
@Namespace("/")
@Controller
@Actions
@Scope("prototype")
public class StandardAction extends ActionSupport implements ModelDriven<Standard>{

	@Autowired
	private IStandardService standardService;
	
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

	Standard model =  new Standard();
	
	@Override
	public Standard getModel() {
		
		return model;
	}
	
	@Action(value="standardAction_add",results={
			@Result(name="success",location="/pages/base/standard.jsp")
	})
	public String addStandard() {
		standardService.addStandard(model);
		//System.out.println(num);
		return "success";
	}
	
	@Action(value="standardAction_pageQuery")
	public String pageQuery() throws Exception {
		//1.封装查询参数
		//1.1参数page：当前页-1
		//1.2参数size：每页条数
		Pageable pageable = new PageRequest(page - 1, rows);
		Specification<Standard> spec = new Specification<Standard>() {

			@Override
			public Predicate toPredicate(Root<Standard> root,
					CriteriaQuery<?> query, CriteriaBuilder cb) {
				List<Predicate> predicates= new ArrayList<Predicate>();
				String operator = model.getOperator();
				if (StringUtils.isNotBlank(operator)) {
					predicates.add(cb.like(root.get("operator").as(String.class), "%"+operator+"%"));
				}
				String operatingCompany = model.getOperatingCompany();
				if (StringUtils.isNotBlank(operatingCompany)) {
					predicates.add(cb.like(root.get("operatingCompany").as(String.class), operatingCompany));
				}
				String name = model.getName();
				if (StringUtils.isNotBlank(name)) {
					predicates.add(cb.like(root.get("name").as(String.class), "%"+name+"%"));
				}
				Predicate[] pre = new Predicate[predicates.size()];
	            return query.where(predicates.toArray(pre)).getRestriction();
			}
		};
		//2.调用service执行分页查询：总条数和当前页要显示的数据集合
		Page<Standard> page = standardService.pageQuery(spec ,pageable);
		//3.将分页查询数据转换成json对象
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("total", page.getTotalElements());//总条数
		map.put("rows", page.getContent());//当前页要显示的数据集合
		//json-lib：将java数据转换成json数据
		//JSONObject:将java数据转换成json对象
		//JSONArray:将java数据转换成json数组
		JSONObject jsonObject = JSONObject.fromObject(map);
		String json = jsonObject.toString();
		//4.通过response将json数据返回到界面
		ServletActionContext.getResponse().setContentType("text/json;charset=utf-8");
		ServletActionContext.getResponse().getWriter().print(json);
		//Page<Standard> standards = standardService.pageQuery(pageable);
		//String jsonString = JSON.toJSONString(page);
		
		//System.out.println(jsonString);
		return NONE;
	}
	
	private String ids;
	
	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	@Action(value="standardAction_delete",results={
			@Result(name="success",location="/pages/base/standard.jsp")
	})
	public String deleteStandard() {
		
		standardService.deleteStandard(ids);
		
		return "success";
	}
	
	@Action(value="standardAction_findAll")
	public void findStandards() throws Exception {
		List<Standard> list = standardService.findStandards();
		JSONArray jsonArray = JSONArray.fromObject(list);
		String json = jsonArray.toString();
		ServletActionContext.getResponse().setContentType("text/json;charset=utf-8");
		ServletActionContext.getResponse().getWriter().print(json);
		
		//System.out.println(json);
	}
}
