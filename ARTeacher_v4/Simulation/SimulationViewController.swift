//
//  ViewController.swift
//  ARTeacher_v3
//
//  Created by Marian Stanciulica on 22/02/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import DynamicButton

class SimulationViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var virtualObjectsCollectionView: UICollectionView!
    
    /// View to select a virtual object
    var virtualObjectsSelectionViewController: VirtualObjectSelectionCollectionViewController?
    
    /// Collection of all virtual objects
    var virtualObjects = [VirtualObject]()
    
    /// View to show messages for instruct user
    var messageView = MessageView(effect: UIBlurEffect(style: .light))
    
    /// Node for plane detected
    var planeNode: Plane?
    
    /// A type which manages gesture manipulation if virtual content in the scene.
    lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView)
    
    /// A serial queue used to coordinate adding or removing nodes from the scene.
    let updateQueue = DispatchQueue(label: "serialSceneKitQueue")
    
    /// Current configuration for scene
    let configuration = ARWorldTrackingConfiguration()
    
    /// Variable to determine if simulation is currently playing
    var isPLaying = false
    
    /// Variable to determine if plane detection is enabled
    var trackingDisabled = false
    
    
    // MARK: - UI Elements
    
    /// Square to detect planes
    let focusSquare = FocusSquare()
    
    var screenCenter: CGPoint {
        let bounds = self.sceneView.bounds
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    let playPauseButton = DynamicButton()
    let addGeometryButton = DynamicButton()
    let refreshButton = DynamicButton()
    let addForceButton = UIButton()
    let addRopeButton = UIButton()
    
    /// Enable digit input text field for variables
    var enableDigitInputTextField = true
    
    /// UI components for choose force direction
    var forceDirectionView = UIView()
    var topArrowImageView = UIImageView()
    var leftArrowImageView = UIImageView()
    var rightArrowImageView = UIImageView()
    var bottomArrowImageView = UIImageView()
    
    var lastForceDirection: Direction = .NONE
    
    var backupNodesPositionsDictionary = [Int: SCNVector3]()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        self.sceneView.scene.physicsWorld.speed = 0
        
        self.playPauseButton.isHidden = true
        self.addGeometryButton.isHidden = true
        self.addForceButton.isHidden = true
        self.forceDirectionView.isHidden = true
        
        self.setupMessageView()
        self.setupRefreshButton()
        self.setupPlayPauseButton()
        self.setupAddGeometryButton()
        self.setupAddForceButton()
        self.setupAddRopeButton()
        self.setupLights()
        self.setupForceDirectionUI()
        
        self.sceneView.antialiasingMode = .multisampling4X
        self.sceneView.scene.rootNode.addChildNode(focusSquare)
        
//        sceneView.debugOptions = [.showPhysicsShapes]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.isLightEstimationEnabled = true
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    
    // MARK:  - Lighting
    
    func setupLights() {
        self.sceneView.autoenablesDefaultLighting = false
        self.sceneView.automaticallyUpdatesLighting = false
        
        let env = UIImage(named: "art.scnassets/Environment/spherical.jpg")
        self.sceneView.scene.lightingEnvironment.contents = env
    }
    
    
    // MARK: - Update UI
    
    func updateFocusSquare() {
        
        if !focusSquare.isOpen {
            self.addGeometryButton.isHidden = false
            self.playPauseButton.isHidden = false
            self.addForceButton.isHidden = false
            self.addRopeButton.isHidden = false
            self.refreshButton.isHidden = false
        } else {
            self.addGeometryButton.isHidden = true
            self.playPauseButton.isHidden = true
            self.addForceButton.isHidden = true
            self.addRopeButton.isHidden = true
            self.refreshButton.isHidden = true
            focusSquare.unhide()            
        }
        
        if let result = self.sceneView.smartHitTest(screenCenter) {
            updateQueue.async {
                self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
                let camera = self.sceneView.session.currentFrame?.camera
                self.focusSquare.state = .detecting(hitTestResult: result, camera: camera)
            }
        } else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
        }
    }
    
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.virtualObjectsSelectionViewController = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let popoverController = segue.destination.popoverPresentationController,
            let button = sender as? UIButton {
            
            popoverController.delegate = self
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
        }
        
        let virtualObjectsSelectionViewController = segue.destination as! VirtualObjectSelectionCollectionViewController
        
        virtualObjectsSelectionViewController.delegate = self
        
        self.virtualObjectsSelectionViewController = virtualObjectsSelectionViewController
    }
    

    
}
