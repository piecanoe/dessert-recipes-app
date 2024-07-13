//
//  ContentView.swift
//  dessert-recipes-app
//
//  Created by Karen Du on 7/13/24.
//

import SwiftUI

struct ContentView: View {
    @State private var dessertItem: DessertItem?
    
    var body: some View {
        HStack{
            
            AsyncImage(url: URL(string: dessertItem?.strMealThumb ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundColor(.secondary)
            }
            .frame(width:120, height: 120)
            
            Spacer()
            
            Text(dessertItem?.strMeal ?? "placeholder")
            
        }
        .padding(10)
        .task {
            do {
                dessertItem = try await getDessert()
            } catch GetDessertError.invalidURL {
                print("invalid URL")
            } catch GetDessertError.invalidResponse {
                print("invalid response")
            } catch GetDessertError.invalidData {
                print("invalid data")
            } catch {
                print ("unexpected error")
            }
        }
    }
}
    
    func getDessert() async throws -> DessertItem {
        let endpoint = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        
        guard let url = URL(string: endpoint) else {
            throw GetDessertError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GetDessertError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let wrapper = try decoder.decode(Wrapper.self, from: data)
            guard let firstDessert = wrapper.meals.first else {
                throw GetDessertError.invalidData
            }
            return firstDessert
        } catch {
            throw GetDessertError.invalidData
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }



