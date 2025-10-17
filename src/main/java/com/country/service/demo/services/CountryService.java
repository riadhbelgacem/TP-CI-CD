package com.country.service.demo.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import com.country.service.demo.beans.Country;
import com.country.service.demo.repositories.CountryRepository;

@Service
@Component
public class CountryService {
	
	@Autowired
	CountryRepository countryRep;
	
	public List <Country> getAllCountries() {
		List <Country> countries = countryRep.findAll();
		return countries;		
	}
	
	public Country getCountryById(int id) {
		List <Country> countries = countryRep.findAll();
		Country country = null;
		
		for (Country con:countries) {
			if (con.getIdCountry()==id)
				country = con;			
		}
		
		return country;
	}
	
	public Country getCountryByName (String name) {
		List <Country> countries = countryRep.findAll();
		Country country = null;
		
		for (Country con:countries) {
			if (con.getName().equalsIgnoreCase(name))
				country = con;			
		}
		
		return country;
	}
	
	public Country addCountry(Country country) {
		return countryRep.save(country);
	}
	
	public Country updateCountry(Country country) {
		return countryRep.save(country);
	}
	
	public void deleteCountry (Country country) {
		countryRep.delete(country);
	}

	
}
