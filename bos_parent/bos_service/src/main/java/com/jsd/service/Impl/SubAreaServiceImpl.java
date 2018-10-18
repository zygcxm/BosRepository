package com.jsd.service.Impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jsd.dao.SubAreaRepository;
import com.jsd.domain.SubArea;
import com.jsd.service.ISubAreaService;

@Service
@Transactional
public class SubAreaServiceImpl implements ISubAreaService {

	@Autowired
	private SubAreaRepository subAreaRepository;
	
	@Override
	public void saveSubArea(SubArea subArea) {
		subAreaRepository.save(subArea);
	}

	@Override
	public Page<SubArea> pageQuery(Pageable pageable,
			Specification<SubArea> spec) {
		return subAreaRepository.findAll(spec, pageable);
	}

	@Override
	public void deleteSubArea(String ids) {
		String[] arryId = ids.split(",");
		for (String id : arryId) {
			subAreaRepository.delete(Integer.parseInt(id));
		}
	}

}
