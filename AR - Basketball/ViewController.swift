//
//  ViewController.swift
//  AR - Basketball
//
//  Created by Kevin Christopher Darmawan on 04/08/23.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        addBackboard()
        
        registerGestureRecognizer()
    }
    
    func registerGestureRecognizer(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer){
        // scene view to be accessed
        // access the point of view of the scene view. the center point
        guard let sceneView = gestureRecognizer.view as? ARSCNView else {
            return
        }
        
        guard let centerPoint = sceneView.pointOfView else {
            return
        }
        
        let cameraTransfrom = centerPoint.transform
        let cameraLocation = SCNVector3(x: cameraTransfrom.m41,y: cameraTransfrom.m42,z: cameraTransfrom.m43)
        let cameraOrientation = SCNVector3(x: -cameraTransfrom.m31,y: -cameraTransfrom.m32,z: -cameraTransfrom.m33)
        
        let cameraPosition = SCNVector3Make(cameraLocation.x + cameraOrientation.x, cameraLocation.y + cameraOrientation.y, cameraLocation.z + cameraOrientation.z)
        
        let ball = SCNSphere(radius: 0.2)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "basketballSkin.png")
        ball.materials = [material]
        
        let ballNode = SCNNode(geometry: ball)
        ballNode.position = cameraPosition
        
        let physicsShape = SCNPhysicsShape(node: ballNode, options: nil)
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicsShape)
        
        ballNode.physicsBody = physicsBody
        
        let forceVector:Float = 6
        ballNode.physicsBody?.applyForce(SCNVector3(x: cameraOrientation.x * forceVector, y: cameraOrientation.y * forceVector, z: cameraOrientation.z * forceVector), asImpulse: true)
        
        sceneView.scene.rootNode.addChildNode(ballNode)
    }
    
    func addBackboard(){
        guard let backboardScene = SCNScene(named: "art.scnassets/hoop.scn") else {
            return
        }
        
        guard let backboardNode = backboardScene.rootNode.childNode(withName: "backboard", recursively: false) else {
            return
        }
        
        backboardNode.position = SCNVector3(x: 0, y: 0.5, z: -3)
        
        let physicsShape = SCNPhysicsShape(node: backboardNode, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron])
        let physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
        
        backboardNode.physicsBody = physicsBody
        
        sceneView.scene.rootNode.addChildNode(backboardNode)
        roundAction(node: backboardNode)
    }
    
    func horizontalAction(node: SCNNode) {
        let leftAction = SCNAction.move(by: SCNVector3(x: -3, y: 0, z: 0), duration: 5)
        let rightAction = SCNAction.move(by: SCNVector3(x: 3, y: 0, z: 0), duration: 5)

        let actionSequence = SCNAction.sequence([leftAction, rightAction])
        let loopAction = SCNAction.repeatForever(actionSequence)

        node.runAction(loopAction)
    }
    
    func verticalAction(node: SCNNode){
        let upAction = SCNAction.move(by: SCNVector3(x: 0,y: -2,z: 0), duration: 3)
        let downAction = SCNAction.move(by: SCNVector3(x: 0,y: 2,z: 0), duration: 3)
        
        let actionSequence = SCNAction.sequence([upAction, downAction])
        let loopAction = SCNAction.repeatForever(actionSequence)
        
        node.runAction(loopAction)
    }
    
    func roundAction(node: SCNNode){
        let upLeft = SCNAction.move(by: SCNVector3(x: 2,y: 2,z: 0), duration: 5)
        let upRight = SCNAction.move(by: SCNVector3(x: 2,y: -2,z: 0), duration: 5)
        let downRight = SCNAction.move(by: SCNVector3(x: -2,y: -2,z: 0), duration: 5)
        let downLeft = SCNAction.move(by: SCNVector3(x: -2,y: 2,z: 0), duration: 5)
        
        let actionSequence = SCNAction.sequence([upLeft, upRight, downRight, downLeft])
        let loopAction = SCNAction.repeatForever(actionSequence)
        
        node.runAction(loopAction)
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

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
