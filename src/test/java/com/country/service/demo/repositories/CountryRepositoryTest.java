package com.country.service.demo.repositories;

import static org.junit.jupiter.api.Assertions.*;

import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;

import com.country.service.demo.beans.Country;

@DataJpaTest
class CountryRepositoryTest {

	@Autowired
	private TestEntityManager entityManager;
	
	@Autowired
	private CountryRepository countryRepository;

	@Test
	void testSaveAndFindCountry() {
		// Given
		Country country = new Country(1, "France", "Paris");
		
		// When
		entityManager.persistAndFlush(country);
		Optional<Country> found = countryRepository.findById(1);
		
		// Then
		assertTrue(found.isPresent());
		assertEquals("France", found.get().getName());
		assertEquals("Paris", found.get().getCapital());
	}
	
	@Test
	void testFindAllCountries() {
		// Given
		Country country1 = new Country(1, "France", "Paris");
		Country country2 = new Country(2, "Germany", "Berlin");
		entityManager.persist(country1);
		entityManager.persist(country2);
		entityManager.flush();
		
		// When
		var countries = countryRepository.findAll();
		
		// Then
		assertEquals(2, countries.size());
	}
	
	@Test
	void testDeleteCountry() {
		// Given
		Country country = new Country(1, "France", "Paris");
		entityManager.persistAndFlush(country);
		
		// When
		countryRepository.deleteById(1);
		Optional<Country> found = countryRepository.findById(1);
		
		// Then
		assertFalse(found.isPresent());
	}

}
