package com.jsd.dao;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import com.jsd.domain.Area;

public interface AreaRepository extends JpaRepository<Area, Integer>,JpaSpecificationExecutor<Area>{

}
