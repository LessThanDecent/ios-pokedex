//
//  ViewController.swift
//  Pokedex
//
//  Created by Kevin Guitron on 7/21/20.
//  Copyright © 2020 flashwingfelix. All rights reserved.
//

import UIKit

class PokemonListViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    
    // create an empty list to hold the complete list of pokemon
    var pokemon: [Pokemon] = []
    // create an empty list to hold the search results
    var searchResults: [Pokemon] = []
    
    // function to capitalize a string
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // to make the search bar work or something
        searchBar.delegate = self
        
        // url time for list of pokemon let's go babyyyyy
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")
        guard let u = url else {
            return
        }
        // get data from url or something i think
        URLSession.shared.dataTask(with: u) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            // try catch to decode json
            do {
                // decode the json into a list of pokemon of type PokemonList (see Pokemon.swift)
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                // store the list of pokemon in the pokemon list
                self.pokemon = pokemonList.results
                // store it in the list of search results so that all the pokemon display without anything being searched on startup
                self.searchResults = pokemonList.results
                
                // reload the tableView's data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let error {
                // print out any errors that occur while decoding the data
                print("\(error)")
            }
        }.resume()
    }
    
    // 1 section, no need to worry
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // one row for each pokemon
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    // display each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        // set the text for the row to the corresponding pokemon's name
        cell.textLabel?.text = capitalize(text: searchResults[indexPath.row].name)
        return cell
    }
    
    // pass the selected pokemon to the PokemonViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonSegue" {
            if let destination = segue.destination as? PokemonViewController {
                destination.pokemon = searchResults[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    // search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // empty the search results
        searchResults = []
        // if nothing is typed in, return a list of all of the pokemon
        if searchText == "" {
            searchResults = pokemon
        }
        else {
            // check to see if the searched term is a substring of each pokemon name
            for current in pokemon {
                if current.name.lowercased().contains(searchText.lowercased()) {
                    // if it is, add it to the list of pokemon to be displayed
                    searchResults.append(current)
                }
            }
        }
        // reload the table view
        tableView.reloadData()
    }
}

