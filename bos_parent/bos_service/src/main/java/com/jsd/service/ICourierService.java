package com.jsd.service;



import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;

import com.jsd.domain.Courier;

public interface ICourierService {

	int addCourier(Courier courier);
	
	Page<Courier> pageQuery(Specification<Courier> spec,Pageable pageable);
	
	//List<Courier> findCouriers();
	
	void deleteCourier(String ids);

	void restoreCourier(String ids);
	
}
