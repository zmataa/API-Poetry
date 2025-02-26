//
//  ContentView.swift
//  API Poetry
//
//  Created by Zane Matarieh on 2/26/25.
//

import SwiftUI

struct ContentView: View {
    @State private var authors = [String]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(authors, id: \.self) { author in
                NavigationLink(destination: Text(author)) {
                    Text(author)
                }
            }
            
            .navigationTitle("Poetry Authors")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await getAuthors()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Loading Error"), message: Text("There was a problem loading the poetry authors"), dismissButton: .default(Text("OK")))
        }
    }
    func getAuthors() async {

          let query = "https://poetrydb.org//author"

          if let url = URL(string: query) {

              if let (data, _) = try? await URLSession.shared.data(from: url) {

                  if let decodedResponse = try? JSONDecoder().decode(Authors.self, from: data) {

                      authors = decodedResponse.authors
                    return
                  }

              }

          }
        showingAlert = true
      }
}
struct Authors: Codable {
    var authors: [String]
}
#Preview {
    ContentView()
}
