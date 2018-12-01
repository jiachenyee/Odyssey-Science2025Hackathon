//
//  ViewController.swift
//  SCS hackathon
//
//  Created by JiaChen(: on 24/11/18.
//  Copyright © 2018 SST Inc. All rights reserved.
//

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
    @IBOutlet var sceneView: ARSCNView!
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
        switch somewonk {
        case 0:
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
            print("5555")
            break
            
        case 1:
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
            print("5555")
            break
            
        default:
            break
        }
        node.addChildNode(ArrowNode)
        return node
        
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
// MARK: - Data Helpers
@available(iOS 11.0, *)
private extension ViewController {
    func buildDemoData() -> [LocationAnnotationNode] {
        var nodes: [LocationAnnotationNode] = []
        
        // TODO: add a few more demo points of interest.
        // TODO: use more varied imagery.
        
        let spaceNeedle = buildNode(latitude: 47.6205, longitude: -122.3493, altitude: 225, imageName: "pin")
        nodes.append(spaceNeedle)
        
        let empireStateBuilding = buildNode(latitude: 40.7484, longitude: -73.9857, altitude: 14.3, imageName: "pin")
        nodes.append(empireStateBuilding)
        
        let canaryWharf = buildNode(latitude: 51.504607, longitude: -0.019592, altitude: 236, imageName: "pin")
        nodes.append(canaryWharf)
        
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


