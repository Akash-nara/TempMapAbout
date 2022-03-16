//
//  JSONhelperClasses.swift
//  MyMapp
//
//  Created by Akash Nara on 11/04/20.
//  Copyright © 2021 Akash. All rights reserved.
//

import Foundation

// MARK: Load JSON
struct JSONLoader {
    static func load(_ filename: String) -> [String: Any]? {
           let data: Data
           
           guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
               else {
                   fatalError("Couldn't find \(filename) in main bundle.")
           }
           
           do {
               data = try Data(contentsOf: file)
           } catch {
               fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
           }
           
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
               return json
           } catch {
               fatalError("Couldn't parse \(filename) as \("Controller"):\n\(error)")
           }
       }
}
