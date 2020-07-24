//
//  Pokemon.swift
//  Pokedex
//
//  Created by Kevin Guitron on 7/21/20.
//  Copyright © 2020 flashwingfelix. All rights reserved.
//

import Foundation

struct PokemonList: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String
}

//-----------------------------

struct PokemonData: Codable {
    let id: Int
    let types: [PokemonTypeEntry]
    let sprites: PokemonSprites
}

//-----------------------------

// Pokemon types
struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

//-----------------------------

// Pokemon sprites
struct PokemonSprites: Codable {
    let front_default: String
}

//-----------------------------

// Flavor entries
struct PokemonSpecies: Codable {
    let flavor_text_entries: [PokemonFlavorTextEntry]
}

struct PokemonFlavorTextEntry: Codable {
    let flavor_text: String
}
