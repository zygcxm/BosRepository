package com.jsd.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;

import com.jsd.domain.SubArea;

public interface ISubAreaService {

	void saveSubArea(SubArea subArea);
	
	Page<SubArea> pageQuery(Pageable pageable,Specification<SubArea> spec);
	
	void deleteSubArea(String ids);
}
