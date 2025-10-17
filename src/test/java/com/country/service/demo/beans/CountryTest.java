package com.country.service.demo.beans;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class CountryTest {

	@Test
	void testCountryCreation() {
		// Given
		Country country = new Country();
		
		// When
		country.setIdCountry(1);
		country.setName("France");
		country.setCapital("Paris");
		
		// Then
		assertEquals(1, country.getIdCountry());
		assertEquals("France", country.getName());
		assertEquals("Paris", country.getCapital());
	}
	
	@Test
	void testCountryConstructor() {
		// Given & When
		Country country = new Country(2, "Germany", "Berlin");
		
		// Then
		assertEquals(2, country.getIdCountry());
		assertEquals("Germany", country.getName());
		assertEquals("Berlin", country.getCapital());
	}
	
	@Test
	void testCountryEquality() {
		// Given
		Country country1 = new Country(1, "France", "Paris");
		Country country2 = new Country(1, "France", "Paris");
		
		// Then
		assertEquals(country1.getIdCountry(), country2.getIdCountry());
		assertEquals(country1.getName(), country2.getName());
		assertEquals(country1.getCapital(), country2.getCapital());
	}

}
