package com.country.service.demo.beans;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
@Table(name="country")
public class Country {
	
	@Id
	@Column(name="id")
	private int idCountry;
	@Column(name="name")
	private String name;
	@Column(name="capital")
	private String Capital;

}
