//
//  PokemonDetail.swift
//  Dex3
//
//  Created by Marc Cruz on 8/4/23.
//

import SwiftUI
import CoreData

struct PokemonDetail: View {
    @EnvironmentObject var pokemon: Pokemon
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

//#Preview {
//    PokemonDetail()
//}
struct PokemonDetail_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetail()
            .environmentObject(SamplePokemon.samplePokemon)
    }
}
