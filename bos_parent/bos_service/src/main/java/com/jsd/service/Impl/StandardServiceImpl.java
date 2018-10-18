package com.jsd.service.Impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jsd.dao.StandardRepository;
import com.jsd.domain.Standard;
import com.jsd.service.IStandardService;

@Service
@Transactional
public class StandardServiceImpl implements IStandardService {

	@Autowired
	private StandardRepository standardRepository;
	
	@Override
	public int addStandard(Standard model) {
		Standard standard = standardRepository.save(model);
		System.out.println(standard);
		return 1;
	}

	@Override
	public Page<Standard> pageQuery(Specification<Standard> spec,Pageable pageable) {
		
		return standardRepository.findAll(spec,pageable);
	}

	@Override
	public void deleteStandard(String  ids) {
		String[] Arrids = ids.split(",");
		
		for (String id : Arrids) {
			standardRepository.delete(Integer.parseInt(id));
		}
	}

	@Override
	public List<Standard> findStandards() {
		
		return standardRepository.findAll();
	}

}
