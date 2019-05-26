//
//  CountriesList+Structures.swift
//  Countries
//
//  Created by adBODKAt on 26.05.2019.
//  Copyright (c) 2019 adBODKAt. All rights reserved.
//

import Foundation
import RxSwift

extension CountriesListViewModel {
    // MARK: - initial module data
    struct ModuleInputData {
        let countriesService: CountriesServiceProtocol
    }
    
    // MARK: - module input structure
    struct ModuleInput {
        
    }
    
    // MARK: - module output structure
    struct ModuleOutput {
        let countryName: Observable<String>
    }
}
