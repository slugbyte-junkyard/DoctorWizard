// WinScene
//  DoctorWizard
//
//  Created by Brian Ledbetter on 1/28/15.
//  Copyright (c) 2015 codefellows. All rights reserved.
//

import SpriteKit

class WinScene: SKScene {
    
    var isDefaultSong = false

    var mainMenuDelegate : MainMenuDelegate?
    
    let retryButton = SKSpriteNode(imageNamed: "Rock")
    var touchLocation :CGPoint = CGPointZero
    
    
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "background4")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -1
        addChild(background)
        
        let retryButton = SKSpriteNode(imageNamed: "Rock")
        retryButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        retryButton.setScale(4.0)
        retryButton.name = "retry"
        retryButton.zPosition = 2
        addChild(retryButton)
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        self.touchLocation = touch.locationInNode(self)
        
        enumerateChildNodesWithName("retry", usingBlock: { (node, _) -> Void in
            let button = node as SKSpriteNode
            
            
            
            if CGRectIntersectsRect(button.frame, CGRect(origin: self.touchLocation, size: CGSize(width: 50, height: 50))) {
                if self.isDefaultSong {
                    self.mainMenuDelegate?.restartWithSameSong(true)
                }else{
                    self.mainMenuDelegate?.restartWithSameSong(false)
                }
                
            }
            
        })
        
        
        
    }
}
