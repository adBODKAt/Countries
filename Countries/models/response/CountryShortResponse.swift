//
//  CountryShortResponse.swift
//  Countries
//
//  Created by Александр Марков on 26/05/2019.
//  Copyright © 2019 Александр Марков. All rights reserved.
//

import Foundation
import ObjectMapper

class CountryShortResponse: CountriesApiResponse {
    
    var countries: [CountryModel] = []
    
    required init?(map: Map){
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        countries <- map[""]
    }
}
