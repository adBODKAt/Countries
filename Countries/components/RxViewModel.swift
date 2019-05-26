//
//  RxViewModel.swift
//  Creditclub
//
//  Created by Lobanov Aleksey on 08.09.16.
//  Copyright © 2016 Soft Media Lab. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RxViewModelType {
  associatedtype InputDependencies
  associatedtype Input
  associatedtype Output
  
  func configure(input: Input) -> Output
}

protocol RxViewModelModuleType {
  associatedtype ModuleInput
  associatedtype ModuleOutput
  
  func configureModule(input: ModuleInput?) -> ModuleOutput
}

protocol RxModelOutput {
  var modelState: Observable<LoadingState> {get}
  var modelError: Observable<NSError> {get}
}

protocol ViewModelType {
    associatedtype InputDependencies
}

class RxViewModel {
    let bag = DisposeBag()
    
    var displayError: Observable<NSError> {
        return _displayError.asObservable().skip(1)
    }
    
    var loadingState: Observable<LoadingState> {
        return _loadingState.asObservable()
    }
    
    internal var _loadingState = BehaviorRelay<LoadingState>(value: .unknown)
    internal var _displayError = BehaviorRelay<NSError>(value: NSError(domain: "", code: 0, userInfo: nil))
    
    init() {
        
    }
    
    func isRequestInProcess() -> Bool {
        guard _loadingState.value != .loading else { return true }
        _loadingState.accept(.loading)
        
        return false
    }
}
