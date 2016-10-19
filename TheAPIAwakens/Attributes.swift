//
//  Attributes.swift
//  TheAPIAwakens
//
//  Created by Safwat Shenouda on 15/10/16.
//  Copyright © 2016 Safwat Shenouda. All rights reserved.
//

import Foundation
import UIKit



enum ObjectType: String {
    case people
    case vehicles
    case starships
    
    var fields: [Field]  {
        switch self {
        case .people: return [.name,.birthYear,.homeWorld, .height, .eyeColor,.hairColor]
        case .vehicles: return[.name, .make,.cost,.length,.vehicleClass,.crew]
        case .starships: return [.name, .make,.cost,.length,.starshipClass,.crew]
        }
        
    }
    
}

enum Field: String {
    case name
    case height
    case hairColor = "hair_color"
    case skinColor = "skin_color"
    case eyeColor = "eye_color"
    case birthYear = "birth_year"
    case films
    case homeWorld = "homeworld"
    case make = "manufacturer"
    case cost = "cost_in_credits"
    case length
    case starshipClass = "starship_class"
    case crew
    case vehicleClass = "vehicle_class"
    case vehicles
    case starships
}


