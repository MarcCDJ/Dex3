//
//  ContentView.swift
//  Dex3
//
//  Created by Marc Cruz on 8/2/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
    private var pokedex: FetchedResults<Pokemon>

    var body: some View {
        NavigationStack {
            List(pokedex) { pokemon in
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
                }
            }
            .navigationTitle("Pokedex")
            .navigationDestination(for: Pokemon.self, destination: { pokemon in
                PokemonDetail()
                    .environmentObject(pokemon)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
