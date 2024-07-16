//
//  fetchDessert.swift
//  dessert-recipes-app
//
//  Created by Karen Du on 7/14/24.
//

import Foundation

enum GetDessertError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

func fetchDessert() async throws -> [DessertItem] {
    let apiKey = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    
    guard let url = URL(string: apiKey) else {
        throw GetDessertError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw GetDessertError.invalidResponse
    }
    
    let decoder = JSONDecoder()
    let wrapper = try decoder.decode(DessertsWrapper.self, from: data)
    
    return wrapper.meals
}
