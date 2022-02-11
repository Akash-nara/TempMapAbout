//
//  DispatchQueue+Extensions.swift
//  MyMapp
//
//  Created by Akash Nara on 08/04/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import Foundation

// MARK: DispatchQueue
extension DispatchQueue {
    static func getMainWithoutDelay(completion: @escaping ()->()) {
        DispatchQueue.main.async {
            completion()
        }
    }
    static func getMain(delay: Double = 0.1, completion: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion()
        }
    }
}
