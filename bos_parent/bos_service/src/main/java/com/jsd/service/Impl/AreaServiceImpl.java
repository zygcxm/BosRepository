package com.jsd.service.Impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jsd.dao.AreaRepository;
import com.jsd.domain.Area;
import com.jsd.service.IAreaService;

@Service
@Transactional
public class AreaServiceImpl implements IAreaService {

	@Autowired
	private AreaRepository areaRepository; 
	
	@Override
	public void importArea(List<Area> list) {
		for (Area area : list) {
			areaRepository.save(area);
		}
	}

	@Override
	public Page<Area> pageQuery(Pageable pageable, Specification<Area> spec) {
		
		return areaRepository.findAll(spec, pageable);
	}

	@Override
	public void saveArea(Area model) {
		areaRepository.save(model);
	}

	@Override
	public void deleteArea(String ids) {
		String[] sid = ids.split(",");
		for (String id : sid) {
			areaRepository.delete(Integer.parseInt(id));
		}
	}

	@Override
	public List<Area> findAll() {
		return areaRepository.findAll();
	}

}
