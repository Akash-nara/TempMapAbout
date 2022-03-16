//
//  OperatorOverloading.swift
//  MyMapp
//
//  Created by Akash Nara on 15/04/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import Foundation
import UIKit

func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
    }
}

func + <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>) -> Dictionary<K,V> {
    var map = Dictionary<K,V>()
    for (k, v) in left {
        map[k] = v
    }
    for (k, v) in right {
        map[k] = v
    }
    return map
}
