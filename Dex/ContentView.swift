//
//  ContentView.swift
//  Dex
//
//  Created by Samaksh Sangwan on 13/10/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
    private var pokedex: FetchedResults<Pokemon>
    let fetcher = FetchService()
    @State private var searchText: String = ""
    @State private var filterByFavorite = false
    
    private var dynamicPredicate: NSPredicate? {
        var predicates : [NSPredicate] = []
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "name CONTAINS[c] %@", searchText))
        }
        
        if filterByFavorite{
            predicates.append(NSPredicate(format: "favourite == %d",true))
        }
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(pokedex) { pokemon in
                    NavigationLink {
                        Text(pokemon.name ?? "Unknown")
                    } label: {
                        AsyncImage(url: pokemon.sprite){image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        VStack(alignment: .leading){
                            HStack{
                                Text(pokemon.name!.capitalized)
                                    .fontWeight(.bold)
                                if(pokemon.favourite){
                                    Image(systemName:"star.fill")
                                        .foregroundStyle(.yellow)
                                }
                            }
                            HStack{
                                ForEach(pokemon.types!, id:\.self){type in
                                    Text(type.capitalized)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.black)
                                        .padding(.horizontal , 13)
                                        .padding(.vertical , 5)
                                        .background(Color(type.capitalized))
                                        .clipShape(.capsule)
                               }
                            }
                        }
                    }
                }
                
            }
            .navigationTitle("Pokedex")
            .searchable(text: $searchText , prompt:"Find a Pokemon")
            .autocorrectionDisabled()
            .onChange(of: searchText){
                pokedex.nsPredicate = dynamicPredicate
            }
            .onChange(of: filterByFavorite){
                pokedex.nsPredicate = dynamicPredicate
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        filterByFavorite.toggle()
                    }label:{
                        Label("Filter by Favourite", systemImage: filterByFavorite ? "star.fill" : "star")
                    }
                    .tint(.yellow)
                }
            }
            Text("Select an item")
        }
    }
    
    private func getPokemon(){
        Task{
            for id in 1...151{
                do{
                    let fetchedPokemon = try await fetcher.fetchPokemon(id)
                    let pokemon = Pokemon(context: viewContext)
                    pokemon.id = fetchedPokemon.id
                    pokemon.name = fetchedPokemon.name
                    pokemon.hp = fetchedPokemon.hp
                    pokemon.attack = fetchedPokemon.attack
                    pokemon.defence = fetchedPokemon.defense
                    pokemon.specialAttack = fetchedPokemon.specialAttack
                    pokemon.specialDefence = fetchedPokemon.specialDefense
                    pokemon.speed = fetchedPokemon.speed
                    pokemon.sprite = fetchedPokemon.sprite
                    pokemon.shiny = fetchedPokemon.shiny
                    pokemon.types = fetchedPokemon.types
                    try viewContext.save()
                }catch {
                    print(error)
                }
            }
        }
    }
    
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
