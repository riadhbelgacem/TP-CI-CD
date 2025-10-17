package com.country.service.demo.controllers;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import com.country.service.demo.beans.Country;
import com.country.service.demo.services.CountryService;
import com.fasterxml.jackson.databind.ObjectMapper;


@WebMvcTest(CountryController.class)
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class ControllerMockMvcTests {
	
	@Autowired
	MockMvc mockMvc;
	
	@MockitoBean
	CountryService countryService;
	
	public List<Country> mycountries;
	Country country;
	
	@Test
	@Order(1)
	public void test_getAllCountries() throws Exception {
		mycountries = new ArrayList<Country>();
		mycountries.add(new Country(1,"India","Delhi"));
		mycountries.add(new Country(2,"USA","Washington"));		
		
		when(countryService.getAllCountries()).thenReturn(mycountries);//Mocking
		
		this.mockMvc.perform(get("/getcountries"))
			.andExpect(status().isFound())
			.andDo(print());
	}
	
	@Test
	@Order(2)
	public void test_getCountryByID() throws Exception {
		country = new Country(1,"India","Delhi");
		
		int countryID=1;
		when(countryService.getCountryById(countryID)).thenReturn(country);//Mocking
		
		this.mockMvc.perform(get("/getcountries/{id}", countryID))
		.andExpect(status().isFound())
		.andExpect(MockMvcResultMatchers.jsonPath(".idCountry").value(1)) //private names attributes of country
		.andExpect(MockMvcResultMatchers.jsonPath(".name").value("India"))
		.andExpect(MockMvcResultMatchers.jsonPath(".capital").value("Delhi"))
		.andDo(print());
	}
	
	@Test
	@Order(3)
	public void test_getCountryByName() throws Exception {
		country = new Country(1,"India","Delhi");
		
		String countryName="India";
		when(countryService.getCountryByName(countryName)).thenReturn(country);//Mocking
		
		this.mockMvc.perform(get("/getcountries/countryname").param("name","India"))
		.andExpect(status().isFound())
		.andExpect(MockMvcResultMatchers.jsonPath(".idCountry").value(1)) //private names attributes of country
		.andExpect(MockMvcResultMatchers.jsonPath(".name").value("India"))
		.andExpect(MockMvcResultMatchers.jsonPath(".capital").value("Delhi"))
		.andDo(print());
	}	
	
	@Test
	@Order(4)
	public void test_addCountry() throws Exception {
		country = new Country(3,"Germany","Berlin");
		
		when(countryService.addCountry(country)).thenReturn(country);//Mocking
		
		ObjectMapper mapper = new ObjectMapper();
		String jsonbody = mapper.writeValueAsString(country);
		
		this.mockMvc.perform(post("/addcountry")
					.content(jsonbody)
					.contentType(MediaType.APPLICATION_JSON)
					)
		.andExpect(status().isCreated())
		.andDo(print());
	}
	
	@Test
	@Order(5)
	public void test_updateCountry() throws Exception {
		country = new Country(3,"Japan","Tokyo");
		int countryID = 3;
		
		when(countryService.getCountryById(countryID)).thenReturn(country);//Mocking
		when(countryService.updateCountry(country)).thenReturn(country);//Mocking

		ObjectMapper mapper = new ObjectMapper();
		String jsonbody = mapper.writeValueAsString(country);
		
		this.mockMvc.perform(put("/updatecountry/{id}", countryID)
					.content(jsonbody)
					.contentType(MediaType.APPLICATION_JSON)
					)
		.andExpect(status().isOk())
		.andExpect(MockMvcResultMatchers.jsonPath(".name").value("Japan"))
		.andExpect(MockMvcResultMatchers.jsonPath(".capital").value("Tokyo"))
		.andDo(print());

	}
	
	@Test
	@Order(6)
	public void test_deleteCountry() throws Exception {
		country = new Country(3,"Japan","Tokyo");
		int countryID = 3;
		
		when(countryService.getCountryById(countryID)).thenReturn(country);//Mocking
		
		this.mockMvc.perform(delete("/deletecountry/{id}", countryID))				
		.andExpect(status().isOk());
		
	}
	
}
