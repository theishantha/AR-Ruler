//
//  ViewController.swift
//  AR Ruler
//
//  Created by IS on 6/23/18.
//  Copyright © 2018 IS. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    
    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchLocation = touches.first?.location(in: sceneView){
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResults.first{
                addDot(at: hitResult)
            }
        }
    }
        
    
    func addDot(at hitResult : ARHitTestResult ){
        
            let dotGeometry = SCNSphere(radius: 0.005)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.red
            
            dotGeometry.materials = [material]
            
            let dotNode = SCNNode(geometry: dotGeometry)
            
            dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
            
            sceneView.scene.rootNode.addChildNode(dotNode)
     
          dotNodes.append(dotNode)
     
     if dotNodes.count >= 2 {
            calculate()
        }
     
}
     func calculate(){
          let start = dotNodes[0]
          let end = dotNodes[1]
          
          print(start.position)
          print(end.position)
          
          
          let distance = sqrt(pow(end.position.x - start.position.x, 2) + pow(end.position.y - start.position.y, 2) + pow(end.position.z - start.position.z, 2))
          
          
          updateText(text: "\(abs(distance))")
          
          
//          distance = √ ((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
          
     }
     
     func updateText(text: String) {
          let textGeomaetry = SCNText(string: text, extrusionDepth: 1.0)
          
          textGeomaetry.firstMaterial?.diffuse.contents = UIColor.red
          
          let textNode = SCNNode(geometry: textGeomaetry)
          
          textNode.position = SCNVector3(0, 0.01, -0.1)
          
          textNode.scale = SCNVector3(0.01, 0.01, 0.01)
          
          sceneView.scene
          
          
     }
          
     
        
}

