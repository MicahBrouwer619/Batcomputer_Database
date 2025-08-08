//
//  ContentView.swift
//  Batcomputer
//
//  Created by Micah Brouwer on 7/21/25.
//

import SwiftUI

struct ContentView: View {
    @State private var superheroes: [BatcomputerApp.Superhero] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            List {
                if isLoading {
                    ProgressView("Loading Data...")
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    ForEach(superheroes) { hero in
                        VStack(alignment: .leading) {
                            Text(hero.name)
                                .font(.headline)
                            Text("Publisher: \(hero.publisher)")
                            if let fullName = hero.fullName {
                                Text("Full Name: \(fullName)")
                            }
                            if let aliases = hero.aliases, !aliases.isEmpty {
                                Text("Aliases: \(aliases.joined(separator: ", "))")
                            }
                            // Display other properties later
                        }
                    }
                }
            }
            .navigationTitle("Batcomputer Database")
            .onAppear(perform: fetchSuperheroes)
        }
    }

    func fetchSuperheroes() {
        isLoading = true
        errorMessage = nil
        guard let url = URL(string: "http://10.93.0.183:5000/batcomputer_data") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    errorMessage = "No data received"
                    return
                }

                do {
                    let decodedSuperheroes = try JSONDecoder().decode([BatcomputerApp.Superhero].self, from: data)
                    self.superheroes = decodedSuperheroes
                } catch {
                    errorMessage = "Decoding error: \(error.localizedDescription)"
                    print("Decoding error: \(error)")
                    print("Received data: \(String(data: data, encoding: .utf8) ?? "N/A")")
                }
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}

