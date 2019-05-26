//
//  CountriesCoordinator.swift
//  Countries
//
//  Created by Александр Марков on 26/05/2019.
//  Copyright © 2019 Александр Марков. All rights reserved.
//

import Foundation
import RxSwift

protocol CountriesCoordinatorProtocol: Coordinatorable {
}

class CountriesCoordinator: Coordinator, CountriesCoordinatorProtocol {
    
    // Private
    var bag: DisposeBag = DisposeBag()
    let countriesService = CountriesService()
    
    override func start() {
        do {
            let moduleInput = CountriesListViewModel.ModuleInputData(
                countriesService: countriesService
            )
            let module = try CountriesListConfigurator.configure(data: moduleInput)
            
            module.moduleOutput.countryName.subscribe(onNext: { [weak self] (name) in
                self?.showCountryWith(name: name, animated: true)
            }).disposed(by: bag)
            
            self.router.setModules( [module.viewController] )
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func showCountryWith(name: String, animated: Bool) {
        do {
            let moduleInput = CountryViewModel.ModuleInputData(
                countryService: countriesService,
                countryName: name
            )
            let module = try CountryConfigurator.configure(data: moduleInput)
            self.router.push(module.viewController, animated: animated)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}
