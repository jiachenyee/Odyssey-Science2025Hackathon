//
//  NavigationView.swift
//  SCS hackathon
//
//  Created by JiaChen(: on 1/12/18.
//  Copyright © 2018 SST Inc. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 12.0, *)
extension ARViewController {
    
    func navigationViewSetup() {
        navigationView.layer.cornerRadius = 20
        arrowImageView.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(Double.pi/180))
    }
    
    func changeNavigationState() {
        if isDrawerOpen {
            // Close drawer
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: 0 * CGFloat(Double.pi/180))

                self.navigationView.frame.origin.y = UIScreen.main.bounds.height - self.navigationView.frame.height + 200
                
            }) { (_) in
                
            }
        } else {
            // Open drawer
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(Double.pi/180))
                self.navigationView.frame.origin.y = UIScreen.main.bounds.height - self.navigationView.frame.height + 20
            }) { (_) in
                
            }
        }
        
        isDrawerOpen = !isDrawerOpen
    }
}
