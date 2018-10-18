package com.jsd.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;

import com.jsd.domain.FixedArea;

public interface IFixedAreaService {

	void saveFixedArea(FixedArea fixedArea);
	
	void deleteFixedArea(String ids);
	
	Page<FixedArea> pageQurey(Pageable pageable,Specification<FixedArea> spec);
	
}
