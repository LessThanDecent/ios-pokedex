//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Kevin Guitron on 7/22/20.
//  Copyright © 2020 flashwingfelix. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var catchButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    var pokemon: Pokemon!
    // used to keep track if a pokemon is caught or not
    var caught: Bool!
    // ID used for second API call
    var id: Int!
    
    // called whenever catchButton is pressed
    @IBAction func toggleCatch() {
        // invert the caught boolean
        caught = !caught
        // change the button's text
        changeTitleText()
        // update the userdefaults
        UserDefaults.standard.set(caught, forKey: pokemon.name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get caught from userdefaults
        caught = UserDefaults.standard.bool(forKey: pokemon.name)
        // update the button's text
        changeTitleText()
        
        // clear both type label texts just in case a pokemon only has one type
        type1Label.text = ""
        type2Label.text = ""
        
        // get url from the given pokemon
        let url = URL(string: pokemon.url)
        guard let u = url else {
            return
        }
        // get data from the url
        URLSession.shared.dataTask(with: u) { (data, response, error) in
            // make sure the data is not nil
            guard let data = data else {
                return
            }
            
            // try catch to decode the json
            do {
                // decode the json into a variable of type PokemonData (see Pokemon.swift)
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                
                DispatchQueue.main.async {
                    // set the nameLabel's text
                    self.nameLabel.text = self.pokemon.name
                    // set the numberLabel's text padded with zeros for three digits
                    self.numberLabel.text = String(format: "#%03d", pokemonData.id)
                    self.id = pokemonData.id
                    
                    // get the url for the pokemon's image
                    let url: URL? = URL(string: pokemonData.sprites.front_default)
                    guard let u = url else {
                        print("fart???? url is nil!!!! uh oh!!!!")
                        return
                    }
                    // try to set imageView's image to the image from url
                    do {
                        self.imageView.image = try UIImage(data: Data(contentsOf: u))
                    }
                    catch let error {
                        // print out any errors that occur while getting the image
                        print("\(error)")
                    }
                    
                    // for each type in the pokemon's list of types
                    for typeEntry in pokemonData.types {
                        // depending on which slot the type is in, set the corresponding type label's text
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                    
                    self.loadDescription()
                }
            }
            catch let error {
                // print out any errors that occur while decoding the data
                print("\(error)")
            }
        }.resume()
    }
    
    // updates catchButton's text based on if the pokemon is caught or not
    func changeTitleText() {
        if caught {
            catchButton.setTitle("Release", for: .normal)
        }
        else {
            catchButton.setTitle("Catch", for: .normal)
        }
    }
    
    // load the pokemon's description
    func loadDescription() {
        // using the id from the first API call, create a new URL to get data from
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon-species/" + String(id))
        // make sure that the url is not null
        guard let u = url else {
            return
        }
        // get data from the url
        URLSession.shared.dataTask(with: u) { (data, response, error) in
            // make sure the data is not nil
            guard let data = data else {
                return
            }
            
            // try catch to decode the json
            do {
                // decode the json into a variable of type PokemonSpecies (see Pokemon.swift)
                let pokemonSpecies = try JSONDecoder().decode(PokemonSpecies.self, from: data)
                
                DispatchQueue.main.async {
                    // set the description label to the pokemon's first flavor text entry
                    self.descriptionLabel.text = pokemonSpecies.flavor_text_entries[0].flavor_text
                }
                
            }
            catch let error {
                // print out any errors that occur while decoding the data
                print("\(error)")
            }
        }.resume()
    }
}
