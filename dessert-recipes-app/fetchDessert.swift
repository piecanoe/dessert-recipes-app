//
//  fetchDessert.swift
//  dessert-recipes-app
//
//  Created by Karen Du on 7/14/24.
//

import Foundation

func fetchDessert() async throws -> [DessertItem] {
    let endpoint = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    
    guard let url = URL(string: endpoint) else {
        throw GetDessertError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw GetDessertError.invalidResponse
    }
    
    let decoder = JSONDecoder()
    let wrapper = try decoder.decode(Wrapper.self, from: data)
    
    return wrapper.meals
}
