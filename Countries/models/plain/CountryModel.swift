//
//  CountryModel.swift
//  Countries
//
//  Created by Александр Марков on 26/05/2019.
//  Copyright © 2019 Александр Марков. All rights reserved.
//

import Foundation
import ObjectMapper

public struct CountryModel: Mappable, Equatable {
    
    var name: String = ""
    var population: Int = 0
    var nativeName: String = ""
    
    var borders: [String]?
    var currencies: [CurrencyModel]?

    init() {}
    
    public init?(map: Map){}
    
    mutating public func mapping(map: Map) {
        name <- map["name"]
        population <- map["population"]
        nativeName <- map["nativeName"]
        
        borders <- map["borders"]
        currencies <- map["currencies"]
    }
    
    // MARK: - Equatable
    public static func == (lhs: CountryModel, rhs: CountryModel) -> Bool {
        if lhs.name != rhs.name { return false }
        if lhs.population != rhs.population { return false }
        if lhs.nativeName != rhs.nativeName { return false }
        
        if lhs.borders != rhs.borders { return false }
        if lhs.currencies != rhs.currencies { return false }
        
        return true
    }
}
