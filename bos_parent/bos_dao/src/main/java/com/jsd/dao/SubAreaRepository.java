package com.jsd.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import com.jsd.domain.SubArea;

public interface SubAreaRepository extends JpaRepository<SubArea, Integer>,JpaSpecificationExecutor<SubArea>{

}
