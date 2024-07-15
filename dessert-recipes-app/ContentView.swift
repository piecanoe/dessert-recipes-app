import SwiftUI

struct ContentView: View {
    @State private var dessertItems: [DessertItem] = []

    var body: some View {
        NavigationView {
            List(dessertItems, id: \.idMeal) { item in
                    HStack {
                        Text(item.strMeal)
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
            .navigationTitle("Desserts")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

