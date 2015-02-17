//
//  FireBall.swift
//  DoctorWizard
//
//  Created by Rodrigo Carballo on 2/16/15.
//  Copyright (c) 2015 codefellows. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


class FireBall: SKSpriteNode {
    
    init(fireBallImageName : String, initialPosition: CGPoint) {
        let fireBallTexture = SKTexture(imageNamed: fireBallImageName)
        super.init(texture: fireBallTexture, color: nil, size: fireBallTexture.size())
        self.position = initialPosition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func spawnFireBall(layer : BackgroundLayer) {
        let warning = SKSpriteNode(imageNamed: "Rock")
        var warnignPosition =  self.convertPoint(self.position, fromNode: layer)
        warnignPosition = CGPoint(x: self.size.width - (self.size.width/8), y: warnignPosition.y)
        warning.position = warnignPosition
        warning.alpha = 0
        
        addChild(warning)
        self.setScale(1)
        self.zPosition = 0
        let remove = SKAction.removeFromParent()
        let warningApear = SKAction.fadeAlphaTo(1, duration: 0.1)
        let warningDisopear = SKAction.fadeAlphaTo(0, duration: 0.2)
        let displayWarning = SKAction.sequence([SKAction.repeatAction(SKAction.sequence([warningApear,warningDisopear ]), count: 4), remove])
        warning.runAction(displayWarning)
        
        let moveUp = SKAction.moveToY(self.position.y + 20, duration: 0.5)
        let moveDown = SKAction.moveToY(self.position.y - 20, duration: 0.5)
        var speed :CGFloat = 0.0
        
        let wiggle = SKAction.repeatActionForever(SKAction.sequence([moveDown,moveUp]))
        
        //let moveAcross = SKAction.moveToX(-1024, duration: NSTimeInterval(CGFloat.random(min: 1, max: 2)))
        var moveTO = layer.convertPoint(CGPoint(
            x: -1024, y: 0), fromNode: self)
        moveTO.y = self.position.y
        let moveAcross = SKAction.sequence([SKAction.moveTo(moveTO, duration: 1.3), remove])
        
        let move = SKAction.group([wiggle, moveAcross])
        self.runAction(move)

    }
}
