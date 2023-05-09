//
//  ContentView.swift
//  MOBA2_Lab_iTunes
//
//  Created by Tony Mamaril on 09.05.23.
//

import SwiftUI

struct ContentView: View {
    @State var stonesList = [StonesItem] ()
    
    var body: some View {
        List(stonesList) { song in
            
            VStack(alignment: .leading) {
                
                Text(song.collectionName!)
                Text(song.artistName!).font(.footnote)
            }
        }.onAppear() {
            DispatchQueue.main.async {
                self.stonesList = loadJSON()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct StonesItem: Identifiable, Decodable {
    var artistName : String?
    var collectionName : String?
    var collectionType : String?
    var collectionId : Int?
    var id: Int {
        get {
            return collectionId ?? 0
        }
    }
}

struct StonesWrapper: Decodable {
    // needs to be named results, because check json file!
    // "results": [...
    var results : [StonesItem]
}

func loadJSON() -> [StonesItem] {
    do {
        let file = Bundle.main.url(forResource: "stones", withExtension: "json")
        let data = try Data(contentsOf: file!)
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(StonesWrapper.self, from: data)
        
        return decodedData.results.filter({
            return $0.collectionType != nil
        })
    } catch {
        fatalError("json not loaded\n\(error)")
    }
}


