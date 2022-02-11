//
//  UIControl+Extensions.swift
//  MyMapp
//
//  Created by Akash Nara Pro on 28/03/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import UIKit

// extention UIControl addAction function supporter class
class ClosureSleeve {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        self.closure()
    }
    deinit {
        print("Login Closure Released")
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        // https://stackoverflow.com/questions/5909412/what-is-objc-setassociatedobject-and-in-what-cases-should-it-be-used
        // It will associate above sleeve
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
