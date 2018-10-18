package com.jsd.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;

import com.jsd.domain.Area;

public interface IAreaService {

	void importArea(List<Area> list);
	
	Page<Area> pageQuery(Pageable pageable,Specification<Area> spec);
	
	void saveArea(Area area);
	
	void deleteArea(String ids);
	
	List<Area> findAll();
	
	//void updateAreaById(String id);
}
