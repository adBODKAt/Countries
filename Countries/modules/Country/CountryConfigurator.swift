//
//  CountryConfigurator.swift
//  Countries
//
//  Created by Александр Марков on 26/05/2019.
//  Copyright © 2019 Александр Марков. All rights reserved.
//

import UIKit

class CountryConfigurator {
    class func configure(data:CountryViewModel.ModuleInputData) throws
        -> (viewController: UIViewController, moduleOutput:CountryViewModel.ModuleOutput) {
            return try CountryConfigurator.configure(moduleInput: nil, data: data)
    }
    
    class func configure(moduleInput: CountryViewModel.ModuleInput?,
                         data:CountryViewModel.ModuleInputData) throws
        -> (viewController: UIViewController, moduleOutput:CountryViewModel.ModuleOutput) {
            // View controller
            let viewController = createViewController()
            
            // Dependencies
            let dependencies = try createDependencies()
            
            // View model
            let viewModel = CountryViewModel(dependencies: dependencies, moduleInputData: data)
            let moduleOutput = viewModel.configureModule(input: moduleInput)
            
            viewController.viewModel = viewModel
            
            return (viewController, moduleOutput)
    }
    
    private class func createViewController() -> CountryViewController {
        return CountryViewController()
    }
    
    private class func createDependencies() throws -> CountryViewModel.InputDependencies {
        let dependencies =
            CountryViewModel.InputDependencies()
        return dependencies
    }
    
}
