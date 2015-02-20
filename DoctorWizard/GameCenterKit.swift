//
//  GameCenterKit.swift
//  DoctorWizard
//
//  Created by Brian Ledbetter on 2/19/15.
//  Copyright (c) 2015 codefellows. All rights reserved.
//

import GameKit
import Foundation

class GameCenterKit: NSObject {
    // game center properties
    var authenticationViewController: UIViewController?
    var lastError: NSError?
    var gameCenterEnabled: Bool
    let PresentAuthenticationViewController = "PresentAuthenticationViewController"
    
    
    // gamecenter singleton
    class var sharedGameCenter : GameCenterKit {
        struct Static {
            static let instance : GameCenterKit = GameCenterKit()
        }
        return Static.instance
    }
    
    override init(){
        gameCenterEnabled = true
        super.init()
    }
    
    func authenticateLocalPlayer(){
        let localPlayer = GKLocalPlayer.localPlayer()
    
        localPlayer.authenticateHandler = {(viewController, error) in
            self.lastError = error

            if viewController != nil {
                self.authenticationViewController = viewController
                NSNotificationCenter.defaultCenter().postNotificationName(self.PresentAuthenticationViewController, object: self)
                
            }else if localPlayer.authenticated == true { //eo: if we got a viewController back from authenticateHandler
                self.gameCenterEnabled = true
            }else{
                self.gameCenterEnabled = false
            }//eo: checking authentication
        }//eo: authenticate handler completion block
    }
}