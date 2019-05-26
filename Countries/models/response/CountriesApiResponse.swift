//
//  CountriesApiResponse.swift
//  Countries
//
//  Created by adBODKAt on 26.05.2019.
//  Copyright © 2019 adBODKAt. All rights reserved.
//

import Foundation
import ObjectMapper

class CountriesApiResponse: Mappable {
    
    let apiDomain = "ru.countries"
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
    }
    
    var isSuccess:Bool {
        return true
    }
    
    func error() -> Error? {
        if isSuccess == true { return nil }
        
        let userInfo = [
            NSLocalizedDescriptionKey: "Unknow error occure"
        ]
        let error = NSError(domain: apiDomain, code: 0, userInfo: userInfo)
        
        return error as Error
    }
    
}

