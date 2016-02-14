//
//  Album.swift
//  HelloWorld
//
//  Created by Laagad El Mehdi on 13/02/2016.
//  Copyright © 2016 Laagad El Mehdi. All rights reserved.
//

import Foundation


struct Album {
    let title: String
    let price: String
    let thumbnailImageURL: String
    let largeImageURL: String
    let itemURL: String
    let artistURL: String
    let collectionId: Int
    
    init(name: String, price: String, thumbnailImageURL: String, largeImageURL: String, itemURL: String, artistURL: String, collectionId: Int) {
        self.title = name
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
        self.collectionId = collectionId
    }
    
    static func albumsWithJSON(results: NSArray) -> [Album] {
        // Notre tableau d'albums
        var albums = [Album]()
        
        // Store the results in our table data array
        if results.count>0 {
            
            // Parfois iTunes renvoie une collection, pas un TrackName, alors on vérifie
            for result in results {
                
                var name = result["trackName"] as? String
                if name == nil {
                    name = result["collectionName"] as? String
                }
                
                // Parfois le prix vient en tant que formattedPrice, parfois collectionPrice .. et il est parfois un flotteur à la place d'une chaîne, Meeeerde 
                var price = result["formattedPrice"] as? String
                if price == nil {
                    price = result["collectionPrice"] as? String
                    if price == nil {
                        let priceFloat: Float? = result["collectionPrice"] as? Float
                        let nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2
                        if priceFloat != nil {
                            price = "$\(nf.stringFromNumber(priceFloat!)!)"
                        }
                    }
                }
                
                let thumbnailURL = result["artworkUrl60"] as? String ?? ""
                let imageURL = result["artworkUrl100"] as? String ?? ""
                let artistURL = result["artistViewUrl"] as? String ?? ""
                
                var itemURL = result["collectionViewUrl"] as? String
                if itemURL == nil {
                    itemURL = result["trackViewUrl"] as? String
                }
                if let collectionId = result["collectionId"] as? Int {
                    let newAlbum = Album(name: name!, price: price!, thumbnailImageURL: thumbnailURL, largeImageURL: imageURL, itemURL: itemURL!, artistURL: artistURL, collectionId: collectionId)
                albums.append(newAlbum)
                }
            }
        }
        return albums
    }
}