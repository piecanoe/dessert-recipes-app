//
//  DessertItem.swift
//  dessert-recipes-app
//
//  Created by Karen Du on 7/13/24.
//

import Foundation

struct Wrapper: Codable {
    let meals: [DessertItem]
}

struct DessertItem: Codable, Identifiable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    var id: String { idMeal }
}
