package com.projectmanager.repository;

import org.springframework.data.repository.CrudRepository;

import com.projectmanager.entity.Company;

public interface CompanyRepository extends CrudRepository<Company, Integer> {

}
