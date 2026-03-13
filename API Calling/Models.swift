//
//  Models.swift
//  API Calling
//
//  Created by Christian Collins on 3/13/26.
//

import Foundation

// List of Pokémon
struct PokemonListResponse: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable, Identifiable {
    var id: String { name }
    let name: String
    let url: String
}

// Detail of Pokémon (for image)
struct PokemonDetail: Codable {
    let sprites: Sprites
}

struct Sprites: Codable {
    let front_default: String?
}
