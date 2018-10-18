package com.jsd.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import com.jsd.domain.Courier;

public interface CourierRepository extends JpaRepository<Courier, Integer>,JpaSpecificationExecutor<Courier>{

	@Query("update Courier set deltag=1 where id=?1")
	@Modifying
	void deleteCourier(Integer id);
	
	@Query("update Courier set deltag=0 where id=?1")
	@Modifying
	void restoreCourier(Integer id);
	
}
