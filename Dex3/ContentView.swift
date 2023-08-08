//
//  ContentView.swift
//  Dex3
//
//  Created by Marc Cruz on 8/2/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @State var filterByFavorites = false
    @State var sortByName = false
    @StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default
    ) private var pokedexByIdOnly: FetchedResults<Pokemon>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.name, ascending: true)],
        animation: .default
    ) private var pokedexByNameOnly: FetchedResults<Pokemon>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate:  NSPredicate(format: "favorite = %d", true),
        animation: .default
    ) private var favoritesById: FetchedResults<Pokemon>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.name, ascending: true)],
        predicate:  NSPredicate(format: "favorite = %d", true),
        animation: .default
    ) private var favoritesByName: FetchedResults<Pokemon>
    
    private func setResultsList() -> FetchedResults<Pokemon> {
        if sortByName {
            if filterByFavorites {
                return favoritesByName
            } else {
                return pokedexByNameOnly
            }
        } else {
            if filterByFavorites {
                return favoritesById
            } else {
                return pokedexByIdOnly
            }
        }
    }
    
    var body: some View {
        switch pokemonVM.status {
        case .success:
            NavigationStack {
                List(setResultsList()) { pokemon in
                    NavigationLink(value: pokemon) {
                        AsyncImage(url: pokemon.sprite) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)

                        Text(pokemon.name!.capitalized)
                        
                        if pokemon.favorite {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        } else {
                            Image(systemName: "star")
                                .foregroundColor(.yellow)
                        }
                    }
                }
                .navigationTitle("Pokedex")
                .navigationDestination(for: Pokemon.self, destination: { pokemon in
                    PokemonDetail()
                        .environmentObject(pokemon)
                })
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button {
                            sortByName.toggle()
                        } label: {
                            Label("Filter By Name",
                                  systemImage: sortByName ? "arrow.up.and.down.text.horizontal" : "text.justify.left")
                        }
                        .font(.title)
                        .tint(.green)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            filterByFavorites.toggle()
                        } label: {
                            Label("Filter By Favorites", systemImage: filterByFavorites ? "star.fill" : "star")
                        }
                        .font(.title)
                        .tint(.yellow)
                    }
                }
            }
        default:
            ProgressView()
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
