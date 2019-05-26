//
//  AppCoordinator.swift
//  Countries
//
//  Created by Александр Марков on 26/05/2019.
//  Copyright © 2019 Александр Марков. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

fileprivate enum AppState {
    case main
}

protocol AppCoordinatorProtocol: class {
}

class AppCoordinator: Coordinator, AppCoordinatorProtocol {
    struct Dependencies {
        let coordinatorFactory: CoordinatorFactory
    }
    
    private let dp: Dependencies
    private let bag = DisposeBag()
    
    init(router: Router, dependencies: Dependencies) {
        self.dp = dependencies
        super.init(router: router)
    }
    
    override func start() {
        startMain()
    }
    
    func startMain() {
        let coordinator = dp.coordinatorFactory.cardsFlow(router: router)
        self.addChild(coordinator)
        coordinator.start()
    }
}
