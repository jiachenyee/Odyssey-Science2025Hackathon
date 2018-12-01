//
//  beaconConnectionAR.swift
//  SCS hackathon
//
//  Created by JiaChen(: on 1/12/18.
//  Copyright © 2018 SST Inc. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

@available(iOS 12.0, *)
extension ARViewController {
    
    func rangeBeacons() {
        
        let uuid = UUID(uuidString: "F34A1A1F-500F-48FB-AFAA-9584D641D7B1")
        let identifier = "com.test.ben"
        
        let region = CLBeaconRegion(proximityUUID: uuid!, identifier: identifier)
        
        locationManager.startRangingBeacons(in: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            rangeBeacons()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        discoveredBeacons = beacons
        
        if discoveredBeacons.count > 0 {
            print("yayy")
            print(discoveredBeacons)
            for beacon in discoveredBeacons {
                if beacon.major == 1 {
                    // IS EXHIBIT
                    
                    // Minor 1 = iPhone XR, Minor 2 = MacBook Pro
                    if beacon.proximity == .immediate {
                        minorValue = Int(truncating: beacon.minor)
                        blurView.frame = self.view.frame
                        blurView.alpha = 0
                        view.addSubview(blurView)
                        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                            
//                            self.blurView.alpha = 1
                            
                        }) { (_) in
                            self.performSegue(withIdentifier: "Exhibit", sender: self)
                        }
                        
                        
                    } else {
                        print("too far from exhibit")
                    }
                } else {
                    // Guide beacon
                }
            }
        } else {
            print("no beacons")
        }
        
    }
}
