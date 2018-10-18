package com.jsd.service.Impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jsd.dao.VehicleRepository;
import com.jsd.domain.Vehicle;
import com.jsd.service.IVehicleService;

@Service
@Transactional
public class VehicleServiceImpl implements IVehicleService {

	@Autowired
	private VehicleRepository vehicleRepository;
	
	@Override
	public Page<Vehicle> pageQuery(Specification<Vehicle> spec,
			Pageable pageable) {
		
		return vehicleRepository.findAll(spec, pageable);
	}

	@Override
	public void addVehicle(Vehicle model) {
	vehicleRepository.save(model);
	}

	@Override
	public void deleteVehicle(String ids) {
		String[] idsArray = ids.split(",");
		for (String id : idsArray) {
			vehicleRepository.delete(Integer.parseInt(id));
		}
	}
}
