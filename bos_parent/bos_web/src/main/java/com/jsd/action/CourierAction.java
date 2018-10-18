package com.jsd.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Join;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

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

import com.jsd.domain.Courier;
import com.jsd.domain.Standard;
import com.jsd.service.ICourierService;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;

@ParentPackage("struts-default")
@Namespace("/")
@Controller
@Actions
@Scope("prototype")
public class CourierAction extends ActionSupport implements ModelDriven<Courier>{

	@Autowired
	private ICourierService courierService;
	
	private int page;
	
	private int rows;
	
	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getRows() {
		return rows;
	}

	public void setRows(int rows) {
		this.rows = rows;
	}

	Courier model = new Courier();

	@Override
	public Courier getModel() {
		return model;
	}
	
	@Action(value="courierAction_add",
			results={
				@Result(name="success",location="/pages/base/courier.jsp")
			})
	public String addCourier() {
		model.setDeltag('0');
		courierService.addCourier(model);
		return "success";
	}
	
	@Action(value="courierAction_pageQuery")
	public String pageQuery() throws Exception {
		//1.封装查询参数
		//1.1参数page：当前页-1
		//1.2参数size：每页条数
		Pageable pageable = new PageRequest(page - 1, rows);
		Specification<Courier> spec = new Specification<Courier>() {
		//root:保存的是当前查询对象(Courier)和表结构的映射关系
		//query:可以封装多个查询参数
		//cb:封装一个查询参数
		//predicate:最终的查询条件对象
		@Override
		public Predicate toPredicate(Root<Courier> root,
				CriteriaQuery<?> query, CriteriaBuilder cb) {
			//保存多个查询条件的对象
			List<Predicate> predicates = new ArrayList<Predicate>();
			String name = model.getName();
			if (StringUtils.isNotBlank(name)) {
				predicates.add(cb.like(root.get("name").as(String.class), "%"+name+"%"));
			}
			String courierNum = model.getCourierNum();
			if(StringUtils.isNotBlank(courierNum)){
				predicates.add(cb.equal(root.get("courierNum").as(String.class), courierNum));
			}
			/*Standard standard = model.getStandard();
			if(null!=standard){
				String namee = standard.getName();
				if (StringUtils.isNotBlank(namee)) {
					Join<Courier, Standard> join = root.join(root.getModel().getSingularAttribute("standard",Standard.class));
					predicates.add(cb.like(join.get("namee").as(String.class), "%"+namee+"%"));
				}
			}*/
			String company = model.getCompany();
			if(StringUtils.isNotBlank(company)){
				predicates.add(cb.like(root.get("company").as(String.class), "%"+company+"%"));
			}
			String type = model.getType();
			if(StringUtils.isNotBlank(type)){
				predicates.add(cb.like(root.get("type").as(String.class), "%"+type+"%"));
			}
			//8.组装所有条件，返回
			Predicate[] pre = new Predicate[predicates.size()];
            return query.where(predicates.toArray(pre)).getRestriction();
			}
		};
		//2.调用service执行分页查询：总条数和当前页要显示的数据集合
		Page<Courier> page = courierService.pageQuery(spec,pageable);
		//3.将分页查询数据转换成json对象
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("total", page.getTotalElements());//总条数
		map.put("rows", page.getContent());//当前页要显示的数据集合
		//json-lib：将java数据转换成json数据
		//JSONObject:将java数据转换成json对象
		//JSONArray:将java数据转换成json数组
		JsonConfig jsonConfig = new JsonConfig();
		String[] excludes={"fixedAreas"};
		jsonConfig.setExcludes(excludes);
		JSONObject jsonObject = JSONObject.fromObject(map, jsonConfig);
		String json = jsonObject.toString();
		//4.通过response将json数据返回到界面
		ServletActionContext.getResponse().setContentType("text/json;charset=utf-8");
		ServletActionContext.getResponse().getWriter().print(json);
		//System.out.println(json);
		return NONE;
	}
	
	private String ids;
	
	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	@Action(value="courierAction_delete",results={
			@Result(name="success",location="/pages/base/courier.jsp")
	})
	public String deleteCourier() {
		courierService.deleteCourier(ids);
		return "success";
	}

	@Action(value="courierAction_restore",results={
			@Result(name="success",location="/pages/base/courier.jsp")
	})
	public String restoreCourier() {
		courierService.restoreCourier(ids);
		return "success";
	}
}
