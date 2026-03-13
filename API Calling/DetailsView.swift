//
//  DetailsView.swift
//  API Calling
//
//  Created by Christian Collins on 3/13/26.
//

import SwiftUI

struct DetailView: View {
    let pokemon: Pokemon
    @State private var imageURL: String = ""
    @State private var types: [String] = []
    @State private var abilities: [String] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Pokémon Image
                if let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty: ProgressView()
                        case .success(let image): image.resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        case .failure: Image(systemName: "photo")
                        @unknown default: EmptyView()
                        }
                    }
                }
                
                // Name
                Text(pokemon.name.capitalized)
                    .font(.largeTitle)
                    .bold()
                
                // Types
                VStack(alignment: .leading, spacing: 5) {
                    Text("Type(s):")
                        .font(.headline)
                    ForEach(types, id: \.self) { type in
                        Text(type.capitalized)
                    }
                }
                
                // Abilities
                VStack(alignment: .leading, spacing: 5) {
                    Text("Abilities:")
                        .font(.headline)
                    ForEach(abilities, id: \.self) { ability in
                        Text(ability.capitalized)
                    }
                }
            }
            .padding()
        }
        .onAppear { fetchDetails() }
    }
    
    func fetchDetails() {
        guard let url = URL(string: pokemon.url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data,
               let decoded = try? JSONDecoder().decode(PokemonDetail.self, from: data) {
                DispatchQueue.main.async {
                    imageURL = decoded.sprites.front_default ?? ""
                    types = decoded.types.map { $0.type.name }
                    abilities = decoded.abilities.map { $0.ability.name }
                }
            }
        }.resume()
    }
}
