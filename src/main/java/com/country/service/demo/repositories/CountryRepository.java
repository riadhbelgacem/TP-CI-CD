package com.country.service.demo.repositories;
import org.springframework.data.jpa.repository.JpaRepository;
import com.country.service.demo.beans.Country;

public interface CountryRepository extends JpaRepository<Country,Integer> {

}
