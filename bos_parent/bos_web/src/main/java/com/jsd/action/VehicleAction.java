package com.jsd.action;

import java.util.HashMap;
import java.util.Map;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import net.sf.json.JSONObject;

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
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Controller;

import com.jsd.domain.Vehicle;
import com.jsd.service.IVehicleService;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;

@Actions
@Namespace("/")
@Scope("prototype")
@ParentPackage("struts-default")
@Controller
public class VehicleAction extends ActionSupport implements ModelDriven<Vehicle>{

	@Autowired
	private IVehicleService vehicleService;
	
	Vehicle model =  new Vehicle();
	
	@Override
	public Vehicle getModel() {
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

	@Action(value="vehicleAction_pageQuery")
	public void pageQuery() throws Exception {
		//设置分页参数
		PageRequest pageable = new PageRequest(page -1, rows);
		//留着用来做查询
		Specification<Vehicle> spec = new Specification<Vehicle>() {

			@Override
			public Predicate toPredicate(Root<Vehicle> root,
					CriteriaQuery<?> query, CriteriaBuilder cb) {
				// TODO Auto-generated method stub
				return null;
			}
		};
		//实现分页展示的业务
		Page<Vehicle> page = vehicleService.pageQuery(spec , pageable);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("total", page.getTotalElements());
		map.put("rows", page.getContent());
		
		JSONObject jsonObject = JSONObject.fromObject(map);
		String json = jsonObject.toString();
		//设置返回数据的格式为utf-8
		ServletActionContext.getResponse().setContentType("text/json;charset=utf-8");
		//通过response将json数据返回到页面
		ServletActionContext.getResponse().getWriter().print(json);
		
		//System.out.println(json);
	}

	@Action(value="vehicleAction_add",results={
			@Result(name="success",location="/pages/base/vehicle.jsp")
	})
	public String addVehicle() {
		vehicleService.addVehicle(model);
		return "success";
	}
	
	private String ids;
	
	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	@Action(value="vehicleAction_delete",results={
			@Result(name="success",location="/pages/base/vehicle.jsp")
	})
	public String deleteVehicle() {
		vehicleService.deleteVehicle(ids);
		return "success";
	}
}
