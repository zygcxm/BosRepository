package com.jsd.service.Impl;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jsd.dao.CourierRepository;
import com.jsd.domain.Courier;
import com.jsd.service.ICourierService;

@Service
@Transactional
public class CourierServiceImpl implements ICourierService {

	@Autowired
	private CourierRepository courierRepository;
	
	@Override
	public int addCourier(Courier model) {
		courierRepository.save(model);
		//System.out.println(courier);
		return 0;
	}

	@Override
	public Page<Courier> pageQuery(Specification<Courier> spec,Pageable pageable) {
		
		return courierRepository.findAll(spec, pageable);
	}

	@Override
	public void deleteCourier(String ids) {
		String[] arrayIds = ids.split(",");
		for (String id : arrayIds) {
			courierRepository.deleteCourier(Integer.parseInt(id));
		}
	}

	@Override
	public void restoreCourier(String ids) {
		String[] arrayIds = ids.split(",");
		for (String id : arrayIds) {
			courierRepository.restoreCourier(Integer.parseInt(id));
		}
	}

	/*@Override
	public List<Courier> findCouriers() {
		
		return courierRepository.findAll();
	}*/

}
