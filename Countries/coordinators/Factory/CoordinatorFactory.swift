//
//  CoordinatorFactory.swift
//  Countries
//
//  Created by Александр Марков on 26/05/2019.
//  Copyright © 2019 Александр Марков. All rights reserved.
//

import Foundation
class CoordinatorFactory {
    func cardsFlow(router:Router) -> CountriesCoordinatorProtocol {
        let coord = CountriesCoordinator.init(router: router)
        return coord
    }
}
