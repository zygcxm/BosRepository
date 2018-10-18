package com.jsd.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Actions;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.annotation.Scope;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;

import com.jsd.domain.Area;
import com.jsd.service.IAreaService;
import com.jsd.utils.PinYin4jUtils;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;

@ParentPackage("struts-default")
@Namespace("/")
@Actions
@Controller
@Scope("prototype")
public class AreaAction extends ActionSupport implements ModelDriven<Area> {

	@Autowired
	IAreaService areaService;

	private File areaFile;

	public File getAreaFile() {
		return areaFile;
	}

	public void setAreaFile(File areaFile) {
		this.areaFile = areaFile;
	}

	Area model = new Area();

	@Override
	public Area getModel() {
		return model;
	}

	@Action(value = "areaAction_import")
	public void importArea() throws Exception {
		String flag = "1";
		try {
			HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(areaFile));
			// 表示获取第一sheet页中的数据 Java中的索引从0开始
			HSSFSheet sheet = wb.getSheetAt(0);
			// 新建一个集合用来保存区域
			List<Area> list = new ArrayList<Area>();
			// 遍历sheet页中的数据
			for (Row row : sheet) {
				int rowNum = row.getRowNum();
				if (rowNum == 0) {
					continue;
				}
				String areanumber = row.getCell(0).getStringCellValue();
				String province = row.getCell(1).getStringCellValue();
				String city = row.getCell(2).getStringCellValue();
				String district = row.getCell(3).getStringCellValue();
				String postcode = row.getCell(4).getStringCellValue();
				Area area = new Area();
				area.setProvince(province);
				area.setCity(city);
				area.setDistrict(district);
				area.setAreanumber(areanumber);
				area.setPostcode(postcode);
				province.substring(0, province.length() - 1);
				city.substring(0, city.length() - 1);
				district.substring(0, district.length() - 1);
				// 新建一个临时字符串拼接省,市,区 用来生成简码
				String temp = province + city + district;
				String[] headByString = PinYin4jUtils.getHeadByString(temp);
				String shortcode = StringUtils.join(headByString, "");
				area.setShortcode(shortcode);
				String citycode = PinYin4jUtils.hanziToPinyin(city, "");
				area.setCitycode(citycode);
				list.add(area);
			}
			areaService.importArea(list);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			flag = "0";
			e.printStackTrace();
		}
		ServletActionContext.getResponse().setContentType(
				"text/html;setchar=utf-8");
		ServletActionContext.getResponse().getWriter().print(flag);

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

	@Action(value = "areaAction_pageQuery")
	public void pageQuery() throws Exception {
		Pageable pageable = new PageRequest(page - 1, rows);
		Specification<Area> spec = new Specification<Area>() {
			@Override
			public Predicate toPredicate(Root<Area> root,
					CriteriaQuery<?> query, CriteriaBuilder cb) {
				List<Predicate> predicates = new ArrayList<Predicate>();
				String province = model.getProvince();
				if (null != province) {
					predicates.add(cb.like(root.get("province")
							.as(String.class), "%" + province + "%"));
				}
				String city = model.getCity();
				if (null != province) {
					predicates.add(cb.like(root.get("city").as(String.class),
							"%" + city + "%"));
				}
				String district = model.getDistrict();
				if (null != province) {
					predicates.add(cb.like(root.get("district")
							.as(String.class), "%" + district + "%"));
				}
				Predicate[] pre = new Predicate[predicates.size()];
				return query.where(predicates.toArray(pre)).getRestriction();
			}
		};
		Page<Area> page = areaService.pageQuery(pageable, spec);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("total", page.getTotalElements());
		map.put("rows", page.getContent());
		JsonConfig jsonConfig = new JsonConfig();
		String[] excludes = { "subareas" };
		jsonConfig.setExcludes(excludes);
		JSONObject jsonObject = JSONObject.fromObject(map, jsonConfig);
		String json = jsonObject.toString();
		ServletActionContext.getResponse().setContentType(
				"json/text;charset=utf-8");
		ServletActionContext.getResponse().getWriter().print(json);

	}

	@Action(value = "areaAction_save", results = { @Result(name = "success", location = "/pages/base/area.jsp") })
	public String saveArea() {
		areaService.saveArea(model);
		return "success";
	}

	private String ids;

	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	@Action(value = "areaAction_delete", results = { @Result(name = "success", location = "/pages/base/area.jsp") })
	public String deleteArea() {
		areaService.deleteArea(ids);
		return "success";
	}

	@Action(value = "areaAction_findAll")
	public void areaFindAll() throws Exception {
		List<Area> list = areaService.findAll();
		JsonConfig jsonConfig = new JsonConfig();
		String[] excludes = { "subareas" };
		jsonConfig.setExcludes(excludes);
		JSONArray fromObject = JSONArray.fromObject(list, jsonConfig);
		String string = fromObject.toString();
		ServletActionContext.getResponse().setContentType(
				"json/text;charset=utf-8");
		ServletActionContext.getResponse().getWriter().print(string);
	}

}
