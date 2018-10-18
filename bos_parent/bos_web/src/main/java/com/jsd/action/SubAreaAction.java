package com.jsd.action;

import java.util.HashMap;
import java.util.Map;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
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

import com.jsd.domain.SubArea;
import com.jsd.service.ISubAreaService;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;

@ParentPackage("struts-default")
@Namespace("/")
@Controller
@Action
@Scope("prototype")
public class SubAreaAction extends ActionSupport implements ModelDriven<SubArea>{

	@Autowired
	ISubAreaService subAreaService;

	SubArea model = new SubArea();
	
	@Override
	public SubArea getModel() {
		return model;
	}
	
	@Action(value="subareaAction_save",results={
			@Result(name="success",location="/pages/base/sub_area.jsp")
	})
	public String saveSubAree() {
		subAreaService.saveSubArea(model);
		return "success";
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

	@Action(value="subAreaAction_pageQuery")
	public void pageQuery() throws Exception {
		Pageable pageable = new PageRequest(page -1, rows);
		Specification<SubArea> spec = new Specification<SubArea>() {
			@Override
			public Predicate toPredicate(Root<SubArea> root, CriteriaQuery<?> query,
					CriteriaBuilder cb) {
				// TODO Auto-generated method stub
				return null;
			}
		};
		Page<SubArea> page = subAreaService.pageQuery(pageable, spec);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("total", page.getTotalElements());
		map.put("rows", page.getContent());
		
		JsonConfig jsonConfig = new JsonConfig();
		String[] excludes={"subareas","fixedArea"};
		jsonConfig.setExcludes(excludes);
		JSONObject jsonObject = JSONObject.fromObject(map, jsonConfig );
		String json = jsonObject.toString();
		ServletActionContext.getResponse().setContentType("json/text;charset=utf-8");
		ServletActionContext.getResponse().getWriter().print(json);
	}
	
	private String ids;

	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	@Action(value="subAreaAction_delete",results={
			@Result(name="success",location="/pages/base/sub_area.jsp")
	})
	public String deleteSubArea() {
		subAreaService.deleteSubArea(ids);
		return "success";
	}
}