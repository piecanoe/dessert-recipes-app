//
//  ContentView.swift
//  dessert-recipes-app
//
//  Created by Karen Du on 7/13/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Wrapper: Codable {
    let meals: [DessertItem]
}

struct DessertItem: Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}
