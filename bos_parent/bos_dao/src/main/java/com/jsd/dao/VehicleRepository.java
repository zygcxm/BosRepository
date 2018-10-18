package com.jsd.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.jsd.domain.Vehicle;


public interface VehicleRepository extends JpaRepository<Vehicle, Integer>,JpaSpecificationExecutor<Vehicle>{

}
