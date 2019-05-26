//
//  Country+Structures.swift
//  Countries
//
//  Created by Александр Марков on 26/05/2019.
//  Copyright © 2019 Александр Марков. All rights reserved.
//

import Foundation
import RxSwift

extension CountryViewModel {
    // MARK: - initial module data
    struct ModuleInputData {
        let countryService: CountryServiceProtocol
        let countryName: String
    }
    
    // MARK: - module input structure
    struct ModuleInput {
        
    }
    
    // MARK: - module output structure
    struct ModuleOutput {
    }
}
