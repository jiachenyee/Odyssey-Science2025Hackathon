//
//  ARViewController.swift
//  SCS hackathon
//
//  Created by JiaChen(: on 24/11/18.
//  Copyright © 2018 SST Inc. All rights reserved.
//

/*
import UIKit
import SceneKit
import ARKit
import ARCL
import MapKit

@available(iOS 12.0, *)
class ARViewController: UIViewController {
    
    var isDrawerOpen = true

    var ArrowNode: SCNNode!
    var DirArrow: SCNNode!
    
    
    #warning("Add data when available")
    
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var sceneLocationView: SceneLocationView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var bottomSpaceDrawer: NSLayoutConstraint!
    @IBOutlet weak var exhibitName: UILabel!
    @IBOutlet weak var directions: UILabel!

    let mapView = MKMapView()
    var userAnnotation: MKPointAnnotation?
    var locationEstimateAnnotation: MKPointAnnotation?
    
    var updateUserLocationTimer: Timer?
    
    ///Whether to show a map view
    ///The initial value is respected
    var showMapView: Bool = false
    
    var centerMapOnUserLocation: Bool = true
    
    ///Whether to display some debugging data
    ///This currently displays the coordinate of the best location estimate
    ///The initial value is respected
    var displayDebugging = false
    
    var infoLabel = UILabel()
    
    var updateInfoLabelTimer: Timer?
    
    var adjustNorthByTappingSidesOfScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.font = UIFont.systemFont(ofSize: 10)
        infoLabel.textAlignment = .left
        infoLabel.textColor = UIColor.white
        infoLabel.numberOfLines = 0
        sceneLocationView.addSubview(infoLabel)
        
        updateInfoLabelTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(ARViewController.updateInfoLabel),
            userInfo: nil,
            repeats: true)
        
        // Set to true to display an arrow which points north.
        //Checkout the comments in the property description and on the readme on this.
        //        sceneLocationView.orientToTrueNorth = false
        
        //        sceneLocationView.locationEstimateMethod = .coreLocationDataOnly
        sceneLocationView.showAxesNode = true
        sceneLocationView.locationDelegate = self
        
        if displayDebugging {
            sceneLocationView.showFeaturePoints = true
        }
        
        buildDemoData().forEach { sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: $0) }
        
        if showMapView {
            mapView.delegate = self
            mapView.showsUserLocation = true
            mapView.alpha = 0.8
            view.addSubview(mapView)
            
            updateUserLocationTimer = Timer.scheduledTimer(
                timeInterval: 0.5,
                target: self,
                selector: #selector(ARViewController.updateUserLocation),
                userInfo: nil,
                repeats: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("run")
        sceneLocationView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("pause")
        // Pause the view's session
        sceneLocationView.pause()
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
        
        infoLabel.frame = CGRect(x: 6, y: 0, width: self.view.frame.size.width - 12, height: 14 * 4)
        
        if showMapView {
            infoLabel.frame.origin.y = (self.view.frame.size.height / 2) - infoLabel.frame.size.height
        } else {
            infoLabel.frame.origin.y = self.view.frame.size.height - infoLabel.frame.size.height
        }
        
        mapView.frame = CGRect(
            x: 0,
            y: self.view.frame.size.height / 2,
            width: self.view.frame.size.width,
            height: self.view.frame.size.height / 2)
    }
    
    @objc func updateUserLocation() {
        guard let currentLocation = sceneLocationView.currentLocation() else {
            return
        }
        
        DispatchQueue.main.async {
            if let bestEstimate = self.sceneLocationView.bestLocationEstimate(),
                let position = self.sceneLocationView.currentScenePosition() {
                print("")
                print("Fetch current location")
                print("best location estimate, position: \(bestEstimate.position), location: \(bestEstimate.location.coordinate), accuracy: \(bestEstimate.location.horizontalAccuracy), date: \(bestEstimate.location.timestamp)")
                print("current position: \(position)")
                
                let translation = bestEstimate.translatedLocation(to: position)
                
                print("translation: \(translation)")
                print("translated location: \(currentLocation)")
                print("")
            }
            
            if self.userAnnotation == nil {
                self.userAnnotation = MKPointAnnotation()
                self.mapView.addAnnotation(self.userAnnotation!)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.userAnnotation?.coordinate = currentLocation.coordinate
            }, completion: nil)
            
            if self.centerMapOnUserLocation {
                UIView.animate(withDuration: 0.45, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    self.mapView.setCenter(self.userAnnotation!.coordinate, animated: false)
                }, completion: { _ in
                    self.mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
                })
            }
            
            if self.displayDebugging {
                let bestLocationEstimate = self.sceneLocationView.bestLocationEstimate()
                
                if bestLocationEstimate != nil {
                    if self.locationEstimateAnnotation == nil {
                        self.locationEstimateAnnotation = MKPointAnnotation()
                        self.mapView.addAnnotation(self.locationEstimateAnnotation!)
                    }
                    
                    self.locationEstimateAnnotation!.coordinate = bestLocationEstimate!.location.coordinate
                } else {
                    if self.locationEstimateAnnotation != nil {
                        self.mapView.removeAnnotation(self.locationEstimateAnnotation!)
                        self.locationEstimateAnnotation = nil
                    }
                }
            }
        }
    }
    
    @objc func updateInfoLabel() {
        if let position = sceneLocationView.currentScenePosition() {
            infoLabel.text = "x: \(String(format: "%.2f", position.x)), y: \(String(format: "%.2f", position.y)), z: \(String(format: "%.2f", position.z))\n"
        }
        
        if let eulerAngles = sceneLocationView.currentEulerAngles() {
            infoLabel.text!.append("Euler x: \(String(format: "%.2f", eulerAngles.x)), y: \(String(format: "%.2f", eulerAngles.y)), z: \(String(format: "%.2f", eulerAngles.z))\n")
        }
        
        if let heading = sceneLocationView.locationManager.heading,
            let accuracy = sceneLocationView.locationManager.headingAccuracy {
            infoLabel.text!.append("Heading: \(heading)º, accuracy: \(Int(round(accuracy)))º\n")
        }
        
        let date = Date()
        let comp = Calendar.current.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
        
        if let hour = comp.hour, let minute = comp.minute, let second = comp.second, let nanosecond = comp.nanosecond {
            infoLabel.text!.append("\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second)):\(String(format: "%03d", nanosecond / 1000000))")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard
            let touch = touches.first,
            let touchView = touch.view
            else {
                return
        }
        
        if mapView == touchView || mapView.recursiveSubviews().contains(touchView) {
            centerMapOnUserLocation = false
        } else {
            let location = touch.location(in: self.view)
            
            if location.x <= 40 && adjustNorthByTappingSidesOfScreen {
                print("left side of the screen")
                sceneLocationView.moveSceneHeadingAntiClockwise()
            } else if location.x >= view.frame.size.width - 40 && adjustNorthByTappingSidesOfScreen {
                print("right side of the screen")
                sceneLocationView.moveSceneHeadingClockwise()
            } else {
                let image = UIImage(named: "test")!
                let annotationNode = LocationAnnotationNode(location: nil, image: image)
                annotationNode.scaleRelativeToDistance = true
                sceneLocationView.addLocationNodeForCurrentPosition(locationNode: annotationNode)
            }
        }
        
    }
}

// MARK: - MKMapViewDelegate
@available(iOS 12.0, *)
extension ARViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        guard let pointAnnotation = annotation as? MKPointAnnotation else {
            return nil
        }
        
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        marker.displayPriority = .required
        
        if pointAnnotation == self.userAnnotation {
            marker.glyphImage = UIImage(named: "user")
        } else {
            marker.markerTintColor = UIColor(hue: 0.267, saturation: 0.67, brightness: 0.77, alpha: 1.0)
            marker.glyphImage = UIImage(named: "compass")
        }
        
        return marker
    }
}

// MARK: - SceneLocationViewDelegate
@available(iOS 12.0, *)
extension ARViewController: SceneLocationViewDelegate {
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        print("add scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
        
        /*
        var addnodes = UserDefaults.standard.array(forKey: "dataNodes") as! [[Double]]
        let new:[Double] = [Double(location.coordinate.latitude), Double(location.coordinate.longitude)]
        addnodes.append(new)
        // print(addnodes)
        UserDefaults.standard.set(addnodes, forKey: "dataNodes")
        */
    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        print("remove scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
    }
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
        
    }
    
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
        
    }
}

// MARK: - Data Helpers
@available(iOS 12.0, *)
extension ARViewController {
    func buildDemoData() -> [LocationAnnotationNode] {
        var nodes: [LocationAnnotationNode] = []
        
        // TODO: add a few more demo points of interest.
        // TODO: use more varied imagery.
        /*
        if (UserDefaults.standard.array(forKey: "dataNodes") as? [[Double]] != nil)  {
            
            let dataNodes = UserDefaults.standard.array(forKey: "dataNodes") as! [[Double]]
            print("aujewhfgbwejfrbjuqwbefjkaujewhfgbwejfrbjuqwbefjkaujewhfgbwejfrbjuqwbefjkaujewhfgbwejfrbjuqwbefjkaujewhfgbwejfrbjuqwbefjk")
            print(dataNodes)
            for node in dataNodes {
                let new = buildNode(latitude: CLLocationDegrees(node[0]), longitude: CLLocationDegrees(node[1]), altitude: 0, imageName: "test")
                nodes.append(new)
                // print(node)
            }
            
            
        } else {
            let test = buildNode(latitude: 0, longitude: 0, altitude: 100, imageName: "test")
            nodes.append(test)
            
            UserDefaults.standard.set([[0, 0]], forKey: "dataNodes")
        }
        */
        let test = buildNode(latitude: 1.3577477018387103, longitude: 103.74993368812734, altitude: 100, imageName: "test")
        nodes.append(test)
        
        return nodes
    }
    
    func buildNode(latitude: CLLocationDegrees, longitude: CLLocationDegrees, altitude: CLLocationDistance, imageName: String) -> LocationAnnotationNode {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude)
        let image = UIImage(named: imageName)!
        return LocationAnnotationNode(location: location, image: image)
    }
}

extension DispatchQueue {
    func asyncAfter(timeInterval: TimeInterval, execute: @escaping () -> Void) {
        self.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(timeInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: execute)
    }
}

extension UIView {
    func recursiveSubviews() -> [UIView] {
        var recursiveSubviews = self.subviews
        
        for subview in subviews {
            recursiveSubviews.append(contentsOf: subview.recursiveSubviews())
        }
        
        return recursiveSubviews
    }
}
*/

import UIKit
import SceneKit
import ARKit
import ARCL

@available(iOS 12.0, *)
class ARViewController: UIViewController, ARSCNViewDelegate {
    
    var isDrawerOpen = true
    var somewonk: Int = 1
    var ArrowNode: SCNNode!
    var DirArrow: SCNNode!
    
    
    #warning("Add data when available")
    
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var bottomSpaceDrawer: NSLayoutConstraint!
    @IBOutlet weak var exhibitName: UILabel!
    @IBOutlet weak var directions: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/Scene.scn")!
        // Set the scene to the view
        sceneView.scene = scene
        
        // drawer item
        navigationViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        //object detect
        if #available(iOS 12.0, *) {
            configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "Chair", bundle: Bundle.main)!
        } else {
            // Fallback on earlier versions
        }
        configuration.worldAlignment = .gravityAndHeading
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        print("00000000000000")
        if let objectAnchor = anchor as? ARObjectAnchor{
            ArrowNode = nil
            print("1111111111111111")
            if ArrowNode == nil{
                print("2222222222")
                if let ArrowScene = SCNScene(named: "art.scnassets/Arrow.dae"){
                    print("333333333333")
                    ArrowNode = ArrowScene.rootNode.childNode(withName: "SketchUp", recursively: true)
                    
                    ArrowNode.scale = SCNVector3Make(0.01, 0.01, 0.01)
                    ArrowNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x, Float(0), objectAnchor.referenceObject.center.z)
                    ArrowNode.eulerAngles = SCNVector3Make(0, (sceneView.session.currentFrame?.camera.eulerAngles.y)!,0)
                    print(ArrowNode.transform)
                    print("44444444444")
                    
                }
                
            }
            
        }
        
        node.addChildNode(ArrowNode)
        return node
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        let node = SCNNode()
        
        print("test")
        
        if let objectAnchor = anchor as? ARObjectAnchor{
            ArrowNode = nil
            if ArrowNode == nil{
                if let ArrowScene = SCNScene(named: "art.scnassets/Arrow.dae"){
                    ArrowNode = ArrowScene.rootNode.childNode(withName: "SketchUp", recursively: true)
                    
                    ArrowNode.scale = SCNVector3Make(0.01, 0.01, 0.01)
                    ArrowNode.position = SCNVector3Make(objectAnchor.referenceObject.center.x, Float(0), objectAnchor.referenceObject.center.z)
                    ArrowNode.eulerAngles = SCNVector3Make(0, (sceneView.session.currentFrame?.camera.eulerAngles.y)!,0)
                    print(ArrowNode.transform)
                    
                }
                
            }
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    @IBAction func tappedArrow(_ sender: Any) {
        changeNavigationState()
    }
    


    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
