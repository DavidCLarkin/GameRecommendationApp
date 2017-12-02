
//
//  Game.swift
//  GameRecommender
//
//  Created by David on 16/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation

struct Game : Codable, Comparable, Hashable
{
    var name: String
    var genres: [String]
    var rating: Int
    
    var hashValue: Int
    {
        return name.hashValue
    }
    
    mutating func addGenres(genre: String)
    {
        genres.append(genre)
    }
    
    //MARK: initiaizer
    init?(name:String, genres:[String], rating:Int)
    {
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || genres.isEmpty
        {
            return nil
        }
        
        self.name = name
        self.genres = genres
        self.rating = rating
    }
    
    static func <(lhs: Game, rhs: Game) -> Bool
    {
        if lhs.rating < rhs.rating
        {
            return true
        }
        return false
    }
    
    static func >(lhs: Game, rhs: Game) -> Bool
    {
        if lhs.rating > rhs.rating
        {
            return true
        }
        return false
    }
    
    static func ==(lhs: Game, rhs: Game) -> Bool
    {
        if lhs.name == rhs.name && lhs.genres == rhs.genres && lhs.rating == rhs.rating
        {
            return true
        }
        return false
    }
}
