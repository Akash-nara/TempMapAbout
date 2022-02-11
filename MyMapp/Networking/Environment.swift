//
//  Environment.swift
//  BaseProject
//
//  Created by MAC240 on 04/06/18.
//  Copyright © 2018 MAC240. All rights reserved.
//

import Foundation

enum Server {
    case developement
    case staging
    case demo
    case production
}

class Environment {
    
    static let server: Server = .developement
    
    // To print the log set true.
    static let debug: Bool = true
    
    class func APIBasePath() -> String {
        switch self.server {
        case .developement:
            return "http://54.160.11.28:8081/"
        case .staging:
            return "http://54.160.11.28:8081/"
        case .demo:
            return "http://54.160.11.28:8081/"
        case .production:
            return "http://54.160.11.28:8081/"
        }
    }
    
    
    class func getVersionAndEnvironmentOfRelease() -> String {
        if let info = Bundle.main.infoDictionary {
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
            
            switch self.server {
            case .developement:
                return "Development - \(appVersion) (\(appBuild))"
            case .staging:
                return "QA - \(appVersion) (\(appBuild))"
            case .demo:
                return "Demo - \(appVersion) (\(appBuild))"
            case .production:
                return ""
            }
        }
        return ""
    }
    
    static var getEnvironmentName: String {
        switch self.server {
        case .developement:
            return "dev"
        case .staging:
            return "qa"
        case .demo:
            return "demo"
        case .production:
            return "prod"
        }
    }
}
