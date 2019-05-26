//
//  CountriesListConfigurator.swift
//  Countries
//
//  Created by adBODKAt on 26.05.2019.
//  Copyright (c) 2019 adBODKAt. All rights reserved.
//

import UIKit

class CountriesListConfigurator {
    class func configure(data:CountriesListViewModel.ModuleInputData) throws
        -> (viewController: UIViewController, moduleOutput:CountriesListViewModel.ModuleOutput) {
            return try CountriesListConfigurator.configure(moduleInput: nil, data: data)
    }
    
    class func configure(moduleInput: CountriesListViewModel.ModuleInput?,
                         data:CountriesListViewModel.ModuleInputData) throws
        -> (viewController: UIViewController, moduleOutput:CountriesListViewModel.ModuleOutput) {
            // View controller
            let viewController = createViewController()
            
            // Dependencies
            let dependencies = try createDependencies()
            
            // View model
            let viewModel = CountriesListViewModel(dependencies: dependencies, moduleInputData: data)
            let moduleOutput = viewModel.configureModule(input: moduleInput)
            
            viewController.viewModel = viewModel
            
            return (viewController, moduleOutput)
    }
    
    private class func createViewController() -> CountriesListViewController {
        return CountriesListViewController()
    }
    
    private class func createDependencies() throws -> CountriesListViewModel.InputDependencies {
        let dependencies =
            CountriesListViewModel.InputDependencies()
        return dependencies
    }
    
}
