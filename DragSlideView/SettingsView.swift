//
//  SettingsView.swift
//  DragSlideView
//
//  Created by Jackal Cooper on 11/4/15.
//  Copyright © 2015 Jackal Cooper. All rights reserved.
//

import UIKit

class SettingsView: FXBlurView {
    //MARK: Properties
    var animator : UIDynamicAnimator!
    var container : UICollisionBehavior!
        var slidingAttachment : UIAttachmentBehavior! //Or say container
    var snap : UISnapBehavior!
    var dynamicItem : UIDynamicItemBehavior!
    var gravity : UIGravityBehavior!
    var panGestureReconizer : UIPanGestureRecognizer!
     //MARK: Functions
    func setup () {
        self.panGestureReconizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGestureReconizer.cancelsTouchesInView = false
        
        self.addGestureRecognizer(panGestureReconizer)
        
        self.animator = UIDynamicAnimator(referenceView: self.superview!)
        
        self.dynamicItem = UIDynamicItemBehavior(items:  [self])
        self.dynamicItem.allowsRotation = false
        self.dynamicItem.elasticity = 0
        snap = UISnapBehavior(item: self, snapToPoint: CGPoint(x: self.superview!.frame.size.width / 2, y: self.superview!.frame.size.height))
        animator.addBehavior(snap)
        self.gravity = UIGravityBehavior(items: [self])
        self.gravity.gravityDirection = CGVectorMake(0, -1)
        
        let heightOfSubview = self.superview?.frame.size.height
        let widthOfSubView = self.superview?.frame.size.width
        self.slidingAttachment = UIAttachmentBehavior.slidingAttachmentWithItem(self, attachmentAnchor: CGPointMake(0, -self.frame.size.height / 2 + 66), axisOfTranslation: CGVectorMake(0, 1))
        self.slidingAttachment.attachmentRange = UIFloatRange(minimum:  heightOfSubview!, maximum: heightOfSubview! / 2)
        //animator.addBehavior(self.slidingAttachment)
        
        self.container = UICollisionBehavior(items: [self])
        
        configureContainer()
        //container.translatesReferenceBoundsIntoBoundary = true
        
        animator.addBehavior(gravity)
        animator.addBehavior(dynamicItem)
        animator.addBehavior(container)
        //self.animator.setValue(true, forKey: "debugEnabled")
        
    }
    func configureContainer(){
        let boundaryWidth = UIScreen.mainScreen().bounds.size.width
        container.addBoundaryWithIdentifier("upper", fromPoint: CGPointMake(0, -self.frame.size.height + 66), toPoint: CGPointMake(boundaryWidth, -self.frame.size.height + 66))
        let boundaryHeight = UIScreen.mainScreen().bounds.size.height
        container.addBoundaryWithIdentifier("lower", fromPoint: CGPointMake(0, boundaryHeight ), toPoint: CGPointMake(boundaryWidth, boundaryHeight))
    }
    func handlePan(pan : UIPanGestureRecognizer) {
        let velocity = pan.velocityInView(self.superview).y
        
        var movement = self.frame
        movement.origin.x = 0
        movement.origin.y = movement.origin.y + (velocity * 0.05)
//        snap = UISnapBehavior(item: self, snapToPoint: CGPointMake(CGRectGetMidX(movement), CGRectGetMidY(movement)))
//        animator.addBehavior(snap)
        if pan.state == .Ended{
            panGestureEnded()
        }else if pan.state == .Began {
            snapToBottom()
        }else{
            animator.removeBehavior(snap)
            snap = UISnapBehavior(item: self, snapToPoint: CGPointMake(CGRectGetMidX(movement), CGRectGetMidY(movement)))
            animator.addBehavior(snap)
        }
        
    }
    func panGestureEnded(){
        animator.removeBehavior(snap)
        
        let velocity = dynamicItem.linearVelocityForItem(self)
        
        if fabsf(Float(velocity.y)) > 250 {
            if velocity.y < 0{
                snapToTop()
            }else{
                snapToBottom()
            }
        }else{
            if let superViewHeight = self.superview?.bounds.size.height{
                if self.frame.origin.y > superViewHeight / 2{
                    snapToBottom()
                }else{
                    snapToTop()
                }
            }
        }
    }
    func snapToBottom(){
        gravity.gravityDirection  = CGVectorMake(0, 2.5)
        
    }
    func snapToTop(){
         gravity.gravityDirection  = CGVectorMake(0, -2.5)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tintColor = UIColor.clearColor()
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
