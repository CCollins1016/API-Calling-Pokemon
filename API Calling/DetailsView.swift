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
    
    var body: some View {
        VStack(spacing: 20) {
            if let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty: ProgressView()
                    case .success(let image): image.resizable().scaledToFit().frame(width: 150, height: 150)
                    case .failure: Image(systemName: "photo")
                    @unknown default: EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
            }
            
            Text(pokemon.name.capitalized)
                .font(.largeTitle)
                .bold()
        }
        .padding()
        .onAppear { fetchDetails() }
    }
    
    func fetchDetails() {
        guard let url = URL(string: pokemon.url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let decoded = try? JSONDecoder().decode(PokemonDetail.self, from: data) {
                DispatchQueue.main.async {
                    imageURL = decoded.sprites.front_default ?? ""
                }
            }
        }.resume()
    }
}
