//
//  EmbededMapViewController.swift
//  SCS hackathon
//
//  Created by JiaChen(: on 1/12/18.
//  Copyright © 2018 SST Inc. All rights reserved.
//

import UIKit
import CoreLocation

class EmbededMapViewController: UIViewController, CLLocationManagerDelegate, UIScrollViewDelegate {
    
    var locationManager:CLLocationManager = CLLocationManager()
    var discoveredBeacons:[CLBeacon] = []

    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var mapScrollView: UIScrollView!
    @IBOutlet weak var zoomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        setupMapZoom()
        // Do any additional setup after loading the view.
    }
    
    func setupMapZoom() {
        mapScrollView.maximumZoomScale = 10
        mapScrollView.minimumZoomScale = 1
        mapScrollView.zoomScale = 1
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomView
    }
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
                    if beacon.minor == 1 {
                        // iPhone XR
                        let desc = "All-new Liquid Retina display — the most advanced LCD in the industry. Even faster Face ID. The smartest, most powerful chip in a smartphone. And a breakthrough camera system with Depth Control. iPhone XR. It’s beautiful any way you look at it."
                    } else {
                        // MacBook Pro
                        let desc = "MacBook Pro elevates the notebook to a whole new level of performance and portability. Wherever your ideas take you, you’ll get there faster than ever with high‑performance processors and memory, advanced graphics, blazing‑fast storage, and more."
                    }
                } else {
                    // Guide beacon
                }
            }
        } else {
            print("no beacons")
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
