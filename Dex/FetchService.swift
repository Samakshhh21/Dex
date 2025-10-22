//
//  FetchService.swift
//  Dex
//
//  Created by Samaksh Sangwan on 22/10/25.
//


import Foundation

struct FetchService{
    enum FetchError: Error{
        case badResponse
    }
    
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    
    func fetchPokemon(_ id : Int) async throws -> FetchedPokemon{
        let endpoint = baseURL.appendingPathComponent("\(id)")
        
        
        let (data, response) = try await URLSession.shared.data(from: endpoint)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
            throw FetchError.badResponse
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let pokemon = try decoder.decode(FetchedPokemon.self, from: data)
     //   print("fetched pokemon: \(pokemon.name)")
        return pokemon
    }
}
