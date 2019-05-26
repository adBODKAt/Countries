//
//  ViewModelState.swift
//  Puls
//
//  Created by Lobanov Aleksey on 06/08/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Enum Values
public enum LoadingState: Equatable {
    /// Content is available and not loading any content
    case normal
    /// No Content is available
    case empty
    /// Got an error loading content
    case error
    /// Is loading content
    case loading
    // Prepearing state
    case unknown
    
    // MARK: Properties
    var description: String {
        switch self {
        case .normal: return "Loading success"
        /// No Content is available
        case .empty: return "Empty results"
        /// Got an error loading content
        case .error: return "Loading failure"
        /// Is loading content
        case .loading: return "Loading in process..."
        // Prepearing state
        case .unknown: return "Not defined loading state"
        }
    }
}

// MARK: - Equatable
public func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
    switch (lhs, rhs) {
    case (.normal, .normal):
        return true
    case (.empty, .empty):
        return true
    case (.error, .error):
        return true
    case (.loading, .loading):
        return true
    default:
        return false
    }
}

protocol RxViewModelStateProtocol {
    var state: Observable<LoadingState> { get }
    var error: Observable<NSError> { get }
    
    func isRequestInProcess() -> Bool
    func change(state: LoadingState)
    func show(error: NSError?)
    
    static func viewModelError() -> NSError
}

class RxViewModelState: RxViewModelStateProtocol {
    var state: Observable<LoadingState> {
        return _state.asObservable()
    }
    
    var error: Observable<NSError> {
        return _error.asObservable().filterNil()
    }
    
    private var _state = BehaviorRelay<LoadingState>(value: .unknown)
    private var _error = BehaviorRelay<NSError?>(value: nil)
    
    func isRequestInProcess() -> Bool {
        guard _state.value != .loading else {
            return true
        }
        
        return false
    }
    
    func change(state: LoadingState) {
        _state.accept(state)
    }
    
    func show(error: NSError?) {
        if let err = error {
            _error.accept(err)
        }
        do {
            _state.accept(.error)
        }
    }
    
    static func viewModelError() -> NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: "Please, set ViewModel as dependency for \(#file)",
            NSLocalizedFailureReasonErrorKey: "View model is not define."
        ]
        
        let code = -1
        
        return NSError(domain: "ru.alobanov", code: code, userInfo: userInfo)
    }
}
