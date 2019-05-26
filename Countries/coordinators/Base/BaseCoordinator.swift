import Foundation
import UIKit

class Coordinator: Coordinatorable {
    
    var childs: [Presentable] = []
    
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {
        
    }
    
    // add only unique object
    func addChild(_ child: Presentable) {
        for element in childs where element.presentId() == child.presentId() {
            return
        }
        
        childs.append(child)
    }
    
    func removeChild(_ child: Presentable?) {
        guard childs.isEmpty == false,
            let child = child
            else {
                return
        }
        
        for (index, element) in childs.enumerated() where element.presentId() == child.presentId() {
            childs.remove(at: index)
            break
        }
    }
    
    func child(presentId: PresentableID) -> Presentable? {
        let items = self.childs.filter { item -> Bool in
            return item.presentId() == presentId
        }
        return items.first
    }
    
    func showAlert(title: String, message: String) {
//        router.presentable().showErrorMessage(errorTitle: title, errorMessage: message)
    }
}

extension Coordinator: Presentable {
    
    func presentable() -> UIViewController {
        return router.presentable()
    }
    
    func presentId() -> PresentableID {
        return String(describing: type(of: self))
    }
    
    static func presentId() -> PresentableID {
        return String(describing: self)
    }
    
}
