//
//  SocketIOManager.swift
//  CallStatusDashboard
//
//  Created by Akash Nara on 22/07/17.
//  Copyright © 2017 Sam Agnew. All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON

struct kSocketEvents {
    static let Online = "connect"
    static let Offline = "disconnect"
//    static let joinUser = "joinUser"
    static let receiveMSG = "receiveMSG"
}

class SocketIOManager: NSObject {
    
    //MARK:- Variables
    //    var socket = SocketIOClient(socketURL: URL(string: kUrlApi.BaseUrl)!, config: [.log(false),.reconnects(false),.forcePolling(true),.forceWebsockets(true),.forceNew(true)])
    
    static var sharedInstance = SocketIOManager()
    var socketManager = SocketManager(socketURL: URL(string: Environment.socketURL)!, config: [.log(true)])
    var socket:SocketIOClient!
    
    //MARK:- Init
    override init() {
        super.init()
        socket = socketManager.defaultSocket
    }
    
    //MARK:- Connection Methods
    func connect() {
        guard socket.status == .disconnected || socket.status == .notConnected else {
            return
        }
        socket.connect()
    }
    
    func disconnect() {
        guard socket.status == .connected else {
            return
        }
        socket.disconnect()
    }
    
    func isConnected() -> Bool {
        return SocketIOManager.sharedInstance.socket.status == .connected
    }
}

//MARK:- Handlers
extension SocketIOManager{
    func addConnectHandler() {
        socket.on(clientEvent: .connect) { (dataArray, ack) in
            print("connect dataArray---- : \(dataArray)")
            print("Socket Connected Successfully !!! SocketSid : \(String(describing: self.socket.sid)) Time : \(Date())")
            
            //            if kStorage.isNetworkIssue{
            //                kStorage.isNetworkIssue = false
            //                Utility.hideProgressHUD()
            //                Utility.showToastMessage(kToast.General.NetworkConnection)
            //            }
            
            self.addBasicHandlers()
            self.joinUserEmit()
        }
    }
    
    func addBasicHandlers() {
        socket.removeAllHandlers()
        addConnectHandler()
        addDisconnectHandler()
        addReconnectHandler()
        addReconnectAttemptHandler()
        addStatusChangeHandler()
        addErrorHandler()
        
        addOnFeedHandler()
    }
    
    // diconnet socket handler
    func addDisconnectHandler() {
        socket.on(clientEvent: .disconnect) { (dataArray, ack) in
            print("Socket Disconnected !!! SocketSid : \(String(describing: self.socket.sid)) Time : \(Date())")
        }
    }
    
    // re connect socket handler
    func addReconnectHandler() {
        socket.on(clientEvent: .reconnect) { (dataArray, ack) in
            print("Socket Reconnected !!! SocketSid : \(String(describing: self.socket.sid))")
        }
    }
    
    // re connect attemp socket handler
    func addReconnectAttemptHandler() {
        socket.on(clientEvent: .reconnectAttempt) { (dataArray, ack) in
            print("Socket Reconnect Attempt !!! SocketSid : \(String(describing: self.socket.sid))")
        }
    }
    
    
    // status change handler
    func addStatusChangeHandler() {
        socket.on(clientEvent: .statusChange) { (dataArray, ack) in
            print("Socket statusChange !!! SocketSid : \(String(describing: self.socket.sid))")
        }
    }
    
    // errror handler
    func addErrorHandler() {
        socket.on(clientEvent: .error) { (dataArray, ack) in
            print("Socket Error !!! SocketSid : \(String(describing: self.socket.sid))")
        }
    }
    
    
    // feed handler
    func addOnFeedHandler() {
        socket.on(kSocketEvents.receiveMSG) { (dataArray, ack) in
            //            kStorage.socketID = self.socket.sid
            print("Socket feed !!! SocketSid : \(String(describing: self.socket.sid))")
            self.handleSuccessEvent(eventName: kSocketEvents.receiveMSG, dataArray: dataArray)
        }
    }
    
    func removeAllHandlers() {
        socket.removeAllHandlers()
    }
}

//MARK:- Emit Method
extension SocketIOManager{
    func joinUserEmit() {
        guard let userId = APP_USER?.userId, userId != 0 else{
            print("User ID Empty On joinUser")
            return
        }
//        SocketIOManager.sharedInstance.emiting(eventName: kSocketEvents.joinUser, requestData: userId, showHud: false, timeOut: false)
    }
    
    func emiting(eventName:String, requestData:Any, showHud:Bool = false, timeOut:Bool = false) {
        
        if !SSReachabilityManager.shared.isNetworkAvailable {
            //            Utility.showToastMessage(kToast.General.CheckInternetConnection)
            return
        }
        
        guard SocketIOManager.sharedInstance.socket.status == .connected else {
            //            Utility.showToastMessage(kToast.General.SocketConnection)
            return
        }
        
        //        if showHud{ Utility.showProgressHUD()   }
        print("Emit \(eventName) On SocketSid : \(String(describing: self.socket.sid))")
        print("requestData \(requestData)")
        socket.emit(eventName, [requestData])
    }
}

//MARK:- Handle response of socket
extension SocketIOManager{
    func handleSuccessEvent(eventName:String, dataArray:[Any]) {
        guard let response = dataArray.first else{
            return
        }
        let responseDict = JSON.init(response)
        switch eventName {
        case kSocketEvents.receiveMSG:
            guard let _ = APP_USER else {
                return
            }
            
            debugPrint(responseDict)
            switch UIApplication.shared.applicationState {
            case .background, .inactive:
                // background
                break
            case .active:
                // foreground
                break
            default:
                break
            }
        case kSocketEvents.Online:
            break
        case kSocketEvents.Offline:
            break
        default:
            print("Invalid Event Received!!!")
        }
    }
}
