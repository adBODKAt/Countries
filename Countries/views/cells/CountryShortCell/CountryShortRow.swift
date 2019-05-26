//
//  CountryShortRow.swift
//  Countries
//
//  Created by Александр Марков on 26/05/2019.
//  Copyright © 2019 Александр Марков. All rights reserved.
//

import UIKit

class CountryShortRow: TableRow {
    
    typealias Identity = String
    
    var name: String = ""
    var nativeName: String = ""
    private var population: Int = 0
    var populationText: String {
        return "Население(людей): " + String(population)
    }
    
    override var cellIdentifier: String {
        return "CountryShortCell"
    }
    
    override var identity: String {
        return name
    }
    
    override func equalTo(other: TableRow) -> Bool {
        if let rhs = other as? CountryShortRow {
            let lhs = self
            if lhs.name != rhs.name { return false }
            if lhs.nativeName != rhs.nativeName { return false }
            if lhs.population != rhs.population { return false }
            
            return true
        }
        return false
    }
    
    func configureWith(country: CountryModel) {
        name = country.name
        nativeName = country.nativeName
        population = country.population
    }
}
