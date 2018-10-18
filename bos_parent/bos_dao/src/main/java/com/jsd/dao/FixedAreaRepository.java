package com.jsd.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import com.jsd.domain.FixedArea;

public interface FixedAreaRepository extends JpaRepository<FixedArea, Integer>,JpaSpecificationExecutor<FixedArea>{

}
