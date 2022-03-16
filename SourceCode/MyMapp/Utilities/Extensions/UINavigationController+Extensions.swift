//
//  UINavigationController+Extensions.swift
//  MyMapp
//
//  Created by Akash Nara Pro on 06/05/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import UIKit

extension UINavigationController {
    @discardableResult
    func popToViewControllerCustom<T:UIViewController>(destView:T, animated: Bool = true) -> UIViewController?{
        guard let backToView = self.viewControllers.filter({ (viewController) -> Bool in
            return viewController.classForCoder == T.self
        }).first else { return nil }
        self.popToViewController(backToView, animated: animated)
        return backToView
    }
    
    func getSpecificViewControllerFromPreviousHistory<T:UIViewController>(destView:T) -> UIViewController?{
        guard let backToView = self.viewControllers.filter({ (viewController) -> Bool in
            return viewController.classForCoder == T.self
        }).first else { return nil }
        return backToView
    }
}
