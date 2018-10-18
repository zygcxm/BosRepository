package com.jsd.service;


import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;

import com.jsd.domain.Standard;

public interface IStandardService {

	int addStandard(Standard standard);
	
	Page<Standard> pageQuery(Specification<Standard> spec,Pageable pageable);
	
	List<Standard> findStandards();
	
	void deleteStandard(String ids);

}
