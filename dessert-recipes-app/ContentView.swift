import SwiftUI

struct ContentView: View {
    @State private var dessertItems: [DessertItem] = []
    @State private var recipes: [Recipe] = []
    @State private var selectedItem: DessertItem?
    @State private var recipesByDessertItem: [String: [Recipe]] = [:]
    
    
    
    var body: some View {
        NavigationStack{
            List {
                Section("Desserts"){
                    ForEach (dessertItems, id: \.idMeal) {item in
                        NavigationLink(value: item){
                            HStack{
                                Text(item.strMeal)
                                    .foregroundColor(Color.red)
                                Spacer()
                                AsyncImage(url: URL(string: item.strMealThumb)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    Rectangle()
                                        .foregroundColor(.gray)
                                        .frame(width: 50, height: 50)
                                }
                                .frame(width: 50, height: 50)
                            }
                        }
                    }
                }
                
            }
            .navigationTitle("Recipe App")
            .navigationDestination(for: DessertItem.self) {item in
                VStack{
                    Section() {
                        if let recipes = recipesByDessertItem[item.idMeal] {
                            ForEach(recipes, id: \.idMeal) { recipe in
                                VStack(alignment: .leading) {
                                    Text("Ingredients: \(recipe.strIngredient1 ?? "")")
                                        .font(.body)
                                    Text("Instructions: \(recipe.strInstructions)")
                                        .font(.body)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .padding(.vertical, 5)
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
                .navigationTitle(item.strMeal)
                
                
            }
            .onAppear {
                Task {
                    do {
                        dessertItems = try await fetchDessert()
                    } catch GetDessertError.invalidURL {
                        print("Invalid URL")
                    } catch GetDessertError.invalidResponse {
                        print("Invalid response")
                    } catch GetDessertError.invalidData {
                        print("Invalid data")
                    } catch {
                        print("Unexpected error: \(error.localizedDescription)")
                    }
                }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

