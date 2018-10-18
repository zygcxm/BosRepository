package com.jsd.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;

import com.jsd.domain.Vehicle;

public interface IVehicleService {

	Page<Vehicle> pageQuery(Specification<Vehicle> spec, Pageable pageable);
	
	void addVehicle(Vehicle vehicle);
	
	void deleteVehicle(String ids);
}
