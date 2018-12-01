//
//  EmbededMapViewController.swift
//  SCS hackathon
//
//  Created by JiaChen(: on 1/12/18.
//  Copyright © 2018 SST Inc. All rights reserved.
//

import UIKit
import CoreLocation

var minorValue = 0

class EmbededMapViewController: UIViewController, CLLocationManagerDelegate, UIScrollViewDelegate {
    
    var locationManager:CLLocationManager = CLLocationManager()
    var discoveredBeacons:[CLBeacon] = []
    
    let exhibitBeacon1 = UIView()
    let exhibitBeacon2 = UIView()
    
    let userNode = UIView()
    
    let guideBeacon1 = UIView()
    let guideBeacon2 = UIView()
    let guideBeacon3 = UIView()
    let guideBeacon4 = UIView()
    let guideBeacon5 = UIView()
    let guideBeacon6 = UIView()
    let guideBeacon7 = UIView()
    let guideBeacon8 = UIView()

    @IBOutlet weak var mapScrollView: UIScrollView!
    @IBOutlet weak var zoomView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        zoomView.addSubview(exhibitBeacon1)
        zoomView.addSubview(exhibitBeacon2)
        zoomView.addSubview(guideBeacon1)
        zoomView.addSubview(guideBeacon2)
        zoomView.addSubview(guideBeacon3)
        zoomView.addSubview(guideBeacon4)
        zoomView.addSubview(guideBeacon5)
        zoomView.addSubview(guideBeacon6)
        zoomView.addSubview(guideBeacon7)
        zoomView.addSubview(guideBeacon8)
        zoomView.addSubview(userNode)
        
        setupMapZoom()
        setupBeacon()
        // Do any additional setup after loading the view.
    }
    
    func setupBeacon() {
        exhibitBeacon1.frame.size = CGSize(width: 2, height: 2)
        exhibitBeacon2.frame.size = CGSize(width: 2, height: 2)
        guideBeacon1.frame.size = CGSize(width: 2, height: 2)
        guideBeacon2.frame.size = CGSize(width: 2, height: 2)
        guideBeacon3.frame.size = CGSize(width: 2, height: 2)
        guideBeacon4.frame.size = CGSize(width: 2, height: 2)
        guideBeacon5.frame.size = CGSize(width: 2, height: 2)
        guideBeacon6.frame.size = CGSize(width: 2, height: 2)
        guideBeacon7.frame.size = CGSize(width: 2, height: 2)
        guideBeacon8.frame.size = CGSize(width: 2, height: 2)
        userNode.frame.size = CGSize(width: 5, height: 5)
        
        exhibitBeacon1.backgroundColor = UIColor.red
        exhibitBeacon2.backgroundColor = UIColor.red
        guideBeacon1.backgroundColor = UIColor.green
        guideBeacon2.backgroundColor = UIColor.green
        guideBeacon3.backgroundColor = UIColor.green
        guideBeacon4.backgroundColor = UIColor.green
        guideBeacon5.backgroundColor = UIColor.green
        guideBeacon6.backgroundColor = UIColor.green
        guideBeacon7.backgroundColor = UIColor.green
        guideBeacon8.backgroundColor = UIColor.green
        userNode.backgroundColor = UIColor.blue
        
        exhibitBeacon1.layer.cornerRadius = 1
        exhibitBeacon1.clipsToBounds = true
        exhibitBeacon2.layer.cornerRadius = 1
        exhibitBeacon2.clipsToBounds = true
        guideBeacon1.layer.cornerRadius = 1
        guideBeacon1.clipsToBounds = true
        guideBeacon2.layer.cornerRadius = 1
        guideBeacon2.clipsToBounds = true
        guideBeacon3.layer.cornerRadius = 1
        guideBeacon3.clipsToBounds = true
        guideBeacon4.layer.cornerRadius = 1
        guideBeacon4.clipsToBounds = true
        guideBeacon5.layer.cornerRadius = 1
        guideBeacon5.clipsToBounds = true
        guideBeacon6.layer.cornerRadius = 1
        guideBeacon6.clipsToBounds = true
        guideBeacon7.layer.cornerRadius = 1
        guideBeacon7.clipsToBounds = true
        guideBeacon8.layer.cornerRadius = 1
        guideBeacon8.clipsToBounds = true
        userNode.layer.cornerRadius = 2.5
        userNode.clipsToBounds = true
        
        // Dalton Audi locations
        exhibitBeacon1.frame.origin = CGPoint(x: 280, y: 276)
        exhibitBeacon2.frame.origin = CGPoint(x: 300, y: 246)
    }
    func setupBeaconPoints(location: CGPoint) {
        
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
            var immediateBeacons: [CLBeacon] = []
            var nearBeacons: [CLBeacon] = []
            
            for beacon in discoveredBeacons {
                if beacon.major == 1 {
                    // IS EXHIBIT
                    
                    // Minor 1 = iPhone XR, Minor 2 = MacBook Pro
                    if beacon.proximity == .immediate {
                        minorValue = Int(truncating: beacon.minor)
                        performSegue(withIdentifier: "Exhibit", sender: nil)

                    } else {
                        print("too far from exhibit")
                    }
                } else {
                    // Guide beacon
                }
                if beacon.proximity == .immediate {
                    immediateBeacons.append(beacon)
                } else if beacon.proximity == .near {
                    nearBeacons.append(beacon)
                }
            }
            selectUserLocation(immediateBeacons: immediateBeacons, nearBeacons: nearBeacons)
        } else {
            print("no beacons")
        }
        
    }
    
    func selectUserLocation(immediateBeacons: [CLBeacon], nearBeacons: [CLBeacon]) {
        if immediateBeacons != [] {
            if immediateBeacons[0].major == 1 {
                if immediateBeacons[0].minor == 1 {
                    userNode.frame.origin = CGPoint(x: exhibitBeacon1.frame.origin.x + 5, y: exhibitBeacon1.frame.origin.y - 5)
                } else {
                    userNode.frame.origin = CGPoint(x: exhibitBeacon2.frame.origin.x + 5, y: exhibitBeacon2.frame.origin.y - 5)
                }
            } else {
                switch immediateBeacons[0].minor {
                case 1:
                    userNode.frame.origin = CGPoint(x: guideBeacon1.frame.origin.x + 5, y: guideBeacon1.frame.origin.y - 5)
                case 2:
                    userNode.frame.origin = CGPoint(x: guideBeacon2.frame.origin.x + 5, y: guideBeacon2.frame.origin.y - 5)
                case 3:
                    userNode.frame.origin = CGPoint(x: guideBeacon3.frame.origin.x + 5, y: guideBeacon3.frame.origin.y - 5)
                case 4:
                    userNode.frame.origin = CGPoint(x: guideBeacon4.frame.origin.x + 5, y: guideBeacon4.frame.origin.y - 5)
                case 5:
                    userNode.frame.origin = CGPoint(x: guideBeacon5.frame.origin.x + 5, y: guideBeacon5.frame.origin.y - 5)
                case 6:
                    userNode.frame.origin = CGPoint(x: guideBeacon6.frame.origin.x + 5, y: guideBeacon6.frame.origin.y - 5)
                case 7:
                    userNode.frame.origin = CGPoint(x: guideBeacon7.frame.origin.x + 5, y: guideBeacon7.frame.origin.y - 5)
                case 8:
                    userNode.frame.origin = CGPoint(x: guideBeacon8.frame.origin.x + 5, y: guideBeacon8.frame.origin.y - 5)
                default: break
                }
            }
            
        } else {
            if nearBeacons.count > 0 {
                if nearBeacons[0].major == 1 {
                    if nearBeacons[0].minor == 1 {
                        userNode.frame.origin = CGPoint(x: exhibitBeacon1.frame.origin.x + 5, y: exhibitBeacon1.frame.origin.y - 5)
                    } else {
                        userNode.frame.origin = CGPoint(x: exhibitBeacon2.frame.origin.x + 5, y: exhibitBeacon2.frame.origin.y - 5)
                    }
                } else {
                    switch nearBeacons[0].minor {
                    case 1:
                        userNode.frame.origin = CGPoint(x: guideBeacon1.frame.origin.x + 10, y: guideBeacon1.frame.origin.y - 10)
                    case 2:
                        userNode.frame.origin = CGPoint(x: guideBeacon2.frame.origin.x + 10, y: guideBeacon2.frame.origin.y - 10)
                    case 3:
                        userNode.frame.origin = CGPoint(x: guideBeacon3.frame.origin.x + 10, y: guideBeacon3.frame.origin.y - 10)
                    case 4:
                        userNode.frame.origin = CGPoint(x: guideBeacon4.frame.origin.x + 10, y: guideBeacon4.frame.origin.y - 10)
                    case 5:
                        userNode.frame.origin = CGPoint(x: guideBeacon5.frame.origin.x + 10, y: guideBeacon5.frame.origin.y - 10)
                    case 6:
                        userNode.frame.origin = CGPoint(x: guideBeacon6.frame.origin.x + 10, y: guideBeacon6.frame.origin.y - 10)
                    case 7:
                        userNode.frame.origin = CGPoint(x: guideBeacon7.frame.origin.x + 10, y: guideBeacon7.frame.origin.y - 10)
                    case 8:
                        userNode.frame.origin = CGPoint(x: guideBeacon8.frame.origin.x + 10, y: guideBeacon8.frame.origin.y - 10)
                    default: break
                    }
                }
            }
            
        }
    }
    @IBAction func showGuides(_ sender: UIButton) {
        if sender.titleLabel?.text == "Hide guide beacons" {
            sender.setTitle("Show guide beacons", for: .normal)
            guideBeacon1.alpha = 0
            guideBeacon2.alpha = 0
            guideBeacon3.alpha = 0
            guideBeacon4.alpha = 0
            guideBeacon5.alpha = 0
            guideBeacon6.alpha = 0
            guideBeacon7.alpha = 0
            guideBeacon8.alpha = 0
            
        } else {
            sender.setTitle("Hide guide beacons", for: .normal)
            guideBeacon1.alpha = 1
            guideBeacon2.alpha = 1
            guideBeacon3.alpha = 1
            guideBeacon4.alpha = 1
            guideBeacon5.alpha = 1
            guideBeacon6.alpha = 1
            guideBeacon7.alpha = 1
            guideBeacon8.alpha = 1
            
        }
    }
    
    @IBAction func showExhibits(_ sender: UIButton) {
        if sender.titleLabel?.text == "Hide exhibits" {
            sender.setTitle("Show exhibits", for: .normal)
            exhibitBeacon1.alpha = 0
            exhibitBeacon2.alpha = 0
        } else {
            sender.setTitle("Hide exhibits", for: .normal)
            exhibitBeacon1.alpha = 1
            exhibitBeacon2.alpha = 1
        }
    }
    
}
