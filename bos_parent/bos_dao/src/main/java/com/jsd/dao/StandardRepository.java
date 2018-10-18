package com.jsd.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import com.jsd.domain.Standard;

public interface StandardRepository extends JpaRepository<Standard, Integer>,JpaSpecificationExecutor<Standard>{
/**
 * JpaRepository实现简单的查询
 * JpaSpecificationExecutor实现复杂查询,如:分页
 */
}
