//
//  PrescriptionViewController.swift
//  DoctorApp
//
//  Created by Edward Nguyen on 5/7/16.
//  Copyright © 2016 Salm. All rights reserved.
//

import UIKit

class ContainerView: UIView {
    @IBOutlet var ownerController: UIViewController!
    private(set) var embededController: UIViewController?
    
    func unembedViewController() -> UIViewController? {
        assert(self.subviews.count <= 1, "Container can only have at most one subview!")
        
        if let vc = self.embededController {
            let subView = self.subviews.first!
            assert(subView == vc.view, "Invalid subview")
            
            vc.willMoveToParentViewController(nil)
            subView.removeFromSuperview()
            vc.didMoveToParentViewController(nil)
            
            self.embededController = nil
            
            return vc
        }
        
        return nil
    }
    
    func embedViewController(viewController: UIViewController?) -> UIViewController? {
        assert(self.subviews.count <= 1, "Container can only have at most one subview!")
        if (viewController == self.embededController) {
            return nil
        }
        
        let oldVC = self.unembedViewController()
        
        // Add view to placeholder view
        if let vc = viewController {
            self.embededController = vc
            let view = vc.view
            
            vc.willMoveToParentViewController(self.ownerController)
            self.addSubview(view)
            
            self.translatesAutoresizingMaskIntoConstraints = false
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[v1]-0-|", options: .AlignAllTop, metrics: nil, views: ["v1": view])
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[v1]-0-|", options: .AlignAllTop, metrics: nil, views: ["v1": view])
            
            self.addConstraints(horizontalConstraints)
            self.addConstraints(verticalConstraints)
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
            vc.didMoveToParentViewController(self.ownerController)
        }
        
        return oldVC
    }
}
