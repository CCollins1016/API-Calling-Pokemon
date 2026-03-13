//
//  Models.swift
//  API Calling
//
//  Created by Christian Collins on 3/13/26.
//

import Foundation

struct PokemonDetail: Codable {
    let sprites: Sprites
    let types: [PokemonTypeEntry]
    let abilities: [AbilityEntry]
}

struct Sprites: Codable {
    let front_default: String?
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: TypeInfo
}

struct TypeInfo: Codable {
    let name: String
}

struct AbilityEntry: Codable {
    let ability: AbilityInfo
}

struct AbilityInfo: Codable {
    let name: String
}
