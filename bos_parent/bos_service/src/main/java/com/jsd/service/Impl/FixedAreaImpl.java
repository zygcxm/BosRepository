package com.jsd.service.Impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jsd.dao.FixedAreaRepository;
import com.jsd.domain.FixedArea;
import com.jsd.service.IFixedAreaService;

@Service
@Transactional
public class FixedAreaImpl implements IFixedAreaService {

	@Autowired
	private FixedAreaRepository fixedAreaRepository;
	
	@Override
	public void saveFixedArea(FixedArea fixedArea) {
		fixedAreaRepository.save(fixedArea);
	}

	@Override
	public void deleteFixedArea(String ids) {
		String[] arrayId = ids.split(",");
		for (String id : arrayId) {
			fixedAreaRepository.delete(Integer.parseInt(id));
		}
	}

	@Override
	public Page<FixedArea> pageQurey(Pageable pageable,
			Specification<FixedArea> spec) {
		return fixedAreaRepository.findAll(spec, pageable);
	}
}
