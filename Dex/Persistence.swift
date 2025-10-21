//
//  Persistence.swift
//  Dex
//
//  Created by Samaksh Sangwan on 13/10/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let newPokemon = Pokemon(context: viewContext)
        newPokemon.name = "Bulbasaur"
        newPokemon.id = 1
        newPokemon.types = ["Grass", "Poison"]
        newPokemon.hp = 45
        newPokemon.attack = 49
        newPokemon.defence = 49
        newPokemon.specialAttack = 65
        newPokemon.specialDefence = 65
        newPokemon.speed = 45
        newPokemon.sprite = URL(string:  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
        newPokemon.shiny = URL(string:  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png")
        
        do {
            try viewContext.save()
        } catch {
            
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Dex")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
