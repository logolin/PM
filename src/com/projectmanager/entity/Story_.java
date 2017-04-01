package com.projectmanager.entity;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(Story.class)
public class Story_ extends BaseBean_{

	 public static volatile SingularAttribute<Story, Product> product;
	 public static volatile SingularAttribute<Story, Integer> branch_id;
}
