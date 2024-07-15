//
//  fetchRecipe.swift
//  dessert-recipes-app
//
//  Created by Karen Du on 7/14/24.
//

import Foundation

enum GetRecipeError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

func fetchRecipe(for idMeal:String) async throws -> [Recipe] {
    let endpoint = "https://themealdb.com/api/json/v1/1/lookup.php?i\(idMeal)"
    
    guard let url = URL(string: endpoint) else {
        throw GetRecipeError.invalidURL
    }
    
    let (data, response ) = try await
    URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw GetDessertError.invalidResponse
    }
    
    let decoder = JSONDecoder()
    let wrapper = try decoder.decode(RecipeWrapper.self, from: data)
    
    return wrapper.meals
    
}
