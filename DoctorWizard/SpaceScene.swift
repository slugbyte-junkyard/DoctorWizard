//
//  SpaceScene.swift
//  DoctorWizard
//
//  Created by drwizzard on 2/9/15.
//  Copyright (c) 2015 codefellows. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion


class SpaceScene: SKScene, SKPhysicsContactDelegate {
    
    
    var timeController = GameTime.sharedTameControler;
    
    
    //MARK: setup time propertys
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    var ellapsedTime: NSTimeInterval = 0


    
    //setup screen frame propertys
    let playableRect:CGRect
    let centerScreen:CGPoint
    
    // setup controlls
    let motionManager = CMMotionManager()
    
    //setup layers
    let backgroundLayer:BackgroundLayer = BackgroundLayer(backgroundImageName: "background0", backgroundIdentifier: "background", movePointsPerSec: 60)
    var backgroundDirection = CGPoint(x: 1.0 , y: 1.0)
    
    let starLayer:BackgroundLayer = BackgroundLayer(backgroundImageName: "starsFinal", backgroundIdentifier: "stars", movePointsPerSec: 100)
    
    //setup dude and dudes enemys
    let dude:Player = Player()
    var colisionBitMaskDude :UInt32 = 0x1
    var colisionBitMaskRock :UInt32 = 0x10

    
    
    override init(size: CGSize) {
        self.playableRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.centerScreen = CGPoint(x: playableRect.width/2, y: playableRect.height/2)
       
        super.init(size: size)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // 6
    }
    
    override func didMoveToView(view: SKView) {
        dude.position = centerScreen
        
        addChild(backgroundLayer)
        self.addChild(self.dude)
        self.dude.position = self.centerScreen
        addChild(starLayer)
        
//        self.spawnPinkRocks()

        self.timeController.startTime = CACurrentMediaTime()
        
//        self.runAction(SKAction.repeatActionForever( SKAction.sequence([SKAction.waitForDuration(1), SKAction.runBlock({ () -> Void in
//            if self.paused == false {
//                self.ellapsedTime += 1
//                println(self.ellapsedTime)
//            }
//        })])))
        
        if motionManager.accelerometerAvailable {
            self.motionManager.accelerometerUpdateInterval = 0.1
            self.motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data, error) -> Void in
                if error == nil {
                    let verticalData = data.acceleration.x
                    let horizontalData = data.acceleration.y
                    self.backgroundDirection.y = CGFloat(verticalData * 50.0)
                    self.backgroundDirection.x = CGFloat(horizontalData * 50.0)
                    self.dude.animateDude(self.backgroundDirection)

                    //  println("we got acceleromiter data : \(verticleData)")
                }
            })
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        
        if UIApplication.sharedApplication().applicationState != UIApplicationState.Background {
            self.timeController.currentTime = currentTime;
//            self.timeController.ellapsedTime += self.timeController.currentTime - self.timeController.startTime;
            self.timeController.ellapsedTime += 0.01
            println(self.timeController.ellapsedTime)
        }
        
        println("children: \(self.children.count)")
        if (round(self.timeController.ellapsedTime * 100) % 500 == 0 ) && self.children.count < 13 {
            println("lalal")
            spawnPinkRock()
        }

        starLayer.moveBackground(currentScene: self, direction: self.backgroundDirection, deltaTime: self.dt)
        backgroundLayer.moveBackground(currentScene: self, direction: self.backgroundDirection, deltaTime: self.dt)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody :SKPhysicsBody!
        var secondBody :SKPhysicsBody!
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        switch firstBody.collisionBitMask {
        case colisionBitMaskDude:
            println("firstBody is dude")
        default:
            secondBody.velocity = CGVectorMake(-self.backgroundLayer.horizontalDirection * 100, -self.backgroundLayer.verticalDirection * 100)
            println("firstBody is rock")
        }
        
        
    }
    

    
    func spawnPinkRock(){
        let spawnRockAction = SKAction.runBlock { () -> Void in
            if UIApplication.sharedApplication().applicationState != UIApplicationState.Background{
                let rock = PinkRock(rockImageName: "pinkRock1", initialPosition: self.pinkRockSpawnPoint())
                self.backgroundLayer.addChild(rock)
                rock.fadeInFadeOut()
            }
            
        }
        self.backgroundLayer.runAction(SKAction.repeatActionForever( SKAction.sequence([spawnRockAction, SKAction.waitForDuration(0.7)])))
    }
    
    func pinkRockSpawnPoint() -> CGPoint {
        let posX : CGFloat = CGFloat.random(min: 0, max: 4096) - 1024
        let posY : CGFloat = CGFloat.random(min: 0, max: 3072) - 767
        let positionToConvert = CGPoint(x: posX, y: posY)
        let position = self.backgroundLayer.convertPoint(positionToConvert, fromNode: self)
        return position
    }

    override func willMoveFromView(view: SKView) {
        self.paused = true
        println("pause game")
    }
    

    
    

    
}