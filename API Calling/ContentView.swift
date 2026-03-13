//
//  ContentView.swift
//  API Calling
//
//  Created by Christian Collins on 3/13/26.
//

import SwiftUI

struct ContentView: View {
    @State private var pokemonList: [Pokemon] = []
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            List(pokemonList) { p in
                NavigationLink(destination: DetailView(pokemon: p)) {
                    Text(p.name.capitalized)
                        .font(.headline)
                }
            }
            .navigationTitle("Pokémon")
            .onAppear { fetchPokemon() }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func fetchPokemon() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    showError = true
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data returned"
                    showError = true
                }
                return
            }
            
            if let decoded = try? JSONDecoder().decode(PokemonListResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.pokemonList = decoded.results
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = "Failed to decode JSON"
                    showError = true
                }
            }
        }.resume()
    }
}
