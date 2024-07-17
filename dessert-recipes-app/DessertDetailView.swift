//
//  DessertDetailView.swift
//  dessert-recipes-app
//
//  Created by Karen Du on 7/17/24.
//

import SwiftUI


struct DessertDetailView: View {
    @State private var recipesByDessertItem: [String: [Recipe]] = [:]
    let item: DessertItem
    
    var body: some View {
        ZStack{
            Color(.systemMint)
                .ignoresSafeArea()
            ScrollView{
                VStack{
                    Text(item.strMeal)
                        .font(.title).bold()
                        .multilineTextAlignment(.center)
                    
                    AsyncImage(url: URL(string: item.strMealThumb)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Rectangle()
                            .foregroundColor(.gray)
                    }
                    .padding([.bottom],20)
                    
                    Section() {
                        if let recipes = recipesByDessertItem[item.idMeal] {
                            ForEach(recipes, id: \.idMeal) { recipe in
                                VStack {
                                    Text("Ingredients:")
                                        .font(.title3)
                                        .padding([.bottom],20)
                                    VStack {
                                        ForEach(Array(zip(recipe.measures, recipe.ingredients)), id: \.0) { (measure, ingredient) in
                                            HStack{
                                                Text(measure)
                                                    .font(.body)
                                                    .lineLimit(1)
                                                Spacer()
                                                Text(ingredient)
                                                    .font(.body)
                                                    .lineLimit(1)
                                            }
                                        }
                                    }
                                    .padding([.bottom],20)
                                    
                                    Text("Instructions:")
                                        .font(.title3)
                                        .padding([.bottom],20)
                                    Text(recipe.strInstructions)
                                        .font(.body)
                                }
                                
                            }
                        } else {
                            ProgressView()
                                .onAppear {
                                    Task {
                                        await loadRecipes(for: item)
                                    }
                                }
                        }
                    }
                    .font(.largeTitle).bold()
                }
                .padding()
                .background(Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(radius:15))
                .padding()
            }
        }
    }
    private func loadRecipes(for item: DessertItem) async {
        do {
            let fetchedRecipes = try await fetchRecipe(for: item.idMeal)
            DispatchQueue.main.async {
                recipesByDessertItem[item.idMeal] = fetchedRecipes
            }
        } catch {
            print("Failed to fetch recipes: \(error)")
        }
    }
}


