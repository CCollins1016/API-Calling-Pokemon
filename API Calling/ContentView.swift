//
//  ContentView.swift
//  API Calling
//
//  Created by Christian Collins on 3/13/26.
//

import SwiftUI

struct ContentView: View {
    @State private var pokemonList: [Pokemon] = []
    @State private var pokemonImages: [String: String] = [:] // [pokemon name: image URL]
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            List(pokemonList) { p in
                NavigationLink(destination: DetailView(pokemon: p)) {
                    HStack {
                        if let imageURL = pokemonImages[p.name], let url = URL(string: imageURL) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        Text(p.name.capitalized)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Pokémon")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { fetchPokemon() }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .onAppear { fetchPokemon() }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .background(Color(red: 0.9, green: 0.95, blue: 1.0)) // light blue background
        }
    }
    
    // MARK: - Fetch Pokémon List
    func fetchPokemon() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=20") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
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
                // Fetch images for each Pokémon
                for pokemon in decoded.results {
                    fetchPokemonImage(for: pokemon)
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = "Failed to decode JSON"
                    showError = true
                }
            }
        }.resume()
    }
    
    // MARK: - Fetch Pokémon Image for List
    func fetchPokemonImage(for pokemon: Pokemon) {
        guard let url = URL(string: pokemon.url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let decoded = try? JSONDecoder().decode(PokemonDetail.self, from: data) {
                DispatchQueue.main.async {
                    self.pokemonImages[pokemon.name] = decoded.sprites.front_default
                }
            }
        }.resume()
    }
}
