//
//  SimulationViewController+ViewSetup.swift
//  ARTeacher_v3
//
//  Created by Marian Stanciulica on 28/02/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import UIKit
import SceneKit

extension SimulationViewController {
    
    // MARK: - View Setup

    func setupAddForceButton() {
        let image = UIImage(named: "art.scnassets/arrow.png")?.withRenderingMode(.alwaysTemplate)

        addForceButton.setImage(image, for: UIControl.State.normal)
        addForceButton.tintColor = normal
        addForceButton.translatesAutoresizingMaskIntoConstraints = false
        addForceButton.addTarget(self, action: #selector(handleAddForceButtonTapped), for: UIControl.Event.touchUpInside)
        
        self.sceneView.addSubview(addForceButton)
        addForceButton.bottomAnchor.constraint(equalTo: self.sceneView.bottomAnchor, constant: -24).isActive = true
        addForceButton.rightAnchor.constraint(equalTo: self.sceneView.rightAnchor, constant: -24).isActive = true
        addForceButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        addForceButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    func setupAddRopeButton() {
        let image = UIImage(named: "art.scnassets/rope.png")?.withRenderingMode(.alwaysTemplate)
        
        addRopeButton.setImage(image, for: UIControl.State.normal)
        addRopeButton.tintColor = normal
        addRopeButton.translatesAutoresizingMaskIntoConstraints = false
        addRopeButton.addTarget(self, action: #selector(handleAddRopeButtonTapped), for: UIControl.Event.touchUpInside)
        
        self.sceneView.addSubview(addRopeButton)
        addRopeButton.bottomAnchor.constraint(equalTo: self.addForceButton.topAnchor, constant: -8).isActive = true
        addRopeButton.rightAnchor.constraint(equalTo: self.sceneView.rightAnchor, constant: -24).isActive = true
        addRopeButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        addRopeButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    func setupPlayPauseButton() {
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.bounceButtonOnTouch = false
        playPauseButton.style = .play
        playPauseButton.lineWidth = 3
        playPauseButton.strokeColor = normal
        playPauseButton.highlightStokeColor = selected
        playPauseButton.alpha = 0.7
        playPauseButton.layer.borderWidth = 3
        playPauseButton.layer.borderColor = UIColor.white.cgColor
        playPauseButton.layer.cornerRadius = 26
        playPauseButton.clipsToBounds = true
        playPauseButton.addTarget(self, action: #selector(handlePlayPauseButtonTapped), for: UIControl.Event.touchUpInside)
        
        self.sceneView.addSubview(playPauseButton)
        playPauseButton.bottomAnchor.constraint(equalTo: self.sceneView.bottomAnchor, constant: -24).isActive = true
        playPauseButton.leftAnchor.constraint(equalTo: self.sceneView.leftAnchor, constant: 24).isActive = true
        playPauseButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        playPauseButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    func setupRefreshButton() {
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.bounceButtonOnTouch = false
        refreshButton.style = .reload
        refreshButton.lineWidth = 3
        refreshButton.strokeColor = normal
        refreshButton.highlightStokeColor = selected
        refreshButton.alpha = 0.7
        refreshButton.addTarget(self, action: #selector(handleRefreshSceneButtonTapped), for: UIControl.Event.touchUpInside)
        
        self.sceneView.addSubview(refreshButton)
        refreshButton.topAnchor.constraint(equalTo: self.sceneView.topAnchor, constant: 24).isActive = true
        refreshButton.rightAnchor.constraint(equalTo: self.sceneView.rightAnchor, constant: -24).isActive = true
        refreshButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        refreshButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupAddGeometryButton() {
        addGeometryButton.translatesAutoresizingMaskIntoConstraints = false
        addGeometryButton.bounceButtonOnTouch = false
        addGeometryButton.style = .circlePlus
        addGeometryButton.lineWidth = 3
        addGeometryButton.strokeColor = normal
        addGeometryButton.highlightStokeColor = selected
        addGeometryButton.alpha = 0.7
        addGeometryButton.addTarget(self, action: #selector(handleAddGeometryButtonTapped), for: UIControl.Event.touchUpInside)
        
        self.sceneView.addSubview(addGeometryButton)
        addGeometryButton.bottomAnchor.constraint(equalTo: self.sceneView.bottomAnchor, constant: -24).isActive = true
        addGeometryButton.centerXAnchor.constraint(equalTo: self.sceneView.centerXAnchor).isActive = true
        addGeometryButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        addGeometryButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    func setupMessageView() {
        messageView.alpha = 0
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.layer.cornerRadius = 20
        messageView.clipsToBounds = true
        
        self.sceneView.addSubview(messageView)
        
        messageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        messageView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        messageView.centerXAnchor.constraint(equalTo: self.sceneView.centerXAnchor).isActive = true
        messageView.topAnchor.constraint(equalTo: self.sceneView.topAnchor, constant: 8).isActive = true
        
        messageView.queueMessage(message: "Please move device to detect planes")
    }
    
    func setupForceDirectionUI() {
        let arrowSize: CGFloat = 32
        
        forceDirectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.sceneView.addSubview(forceDirectionView)
        forceDirectionView.topAnchor.constraint(equalTo: self.sceneView.topAnchor, constant: 8).isActive = true
        forceDirectionView.leftAnchor.constraint(equalTo: self.sceneView.leftAnchor, constant: 8).isActive = true
        forceDirectionView.heightAnchor.constraint(equalToConstant: 136).isActive = true
        forceDirectionView.widthAnchor.constraint(equalToConstant: 136).isActive = true
        
        let textLabel = UILabel()
        textLabel.text = "Force Direction:"
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = normal
        
        forceDirectionView.addSubview(textLabel)
        textLabel.topAnchor.constraint(equalTo: forceDirectionView.topAnchor).isActive = true
        textLabel.leftAnchor.constraint(equalTo: forceDirectionView.leftAnchor).isActive = true
        textLabel.rightAnchor.constraint(equalTo: forceDirectionView.rightAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let topArrowImage = UIImage(named: "art.scnassets/force_arrow.png")?.withRenderingMode(.alwaysTemplate)
        topArrowImageView = UIImageView(image: topArrowImage)
        topArrowImageView.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        topArrowImageView.tintColor = normal
        topArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        topArrowImageView.isUserInteractionEnabled = true
        topArrowImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTopArrowForceDirectionTapped)))
        
        forceDirectionView.addSubview(topArrowImageView)
        topArrowImageView.topAnchor.constraint(equalTo: textLabel.bottomAnchor).isActive = true
        topArrowImageView.centerXAnchor.constraint(equalTo: textLabel.centerXAnchor).isActive = true
        topArrowImageView.heightAnchor.constraint(equalToConstant: arrowSize).isActive = true
        topArrowImageView.widthAnchor.constraint(equalToConstant: arrowSize).isActive = true
        
        let leftArrowImage = UIImage(named: "art.scnassets/force_arrow.png")?.withRenderingMode(.alwaysTemplate)
        leftArrowImageView = UIImageView(image: leftArrowImage)
        leftArrowImageView.transform = CGAffineTransform(rotationAngle: .pi)
        leftArrowImageView.tintColor = normal
        leftArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        leftArrowImageView.isUserInteractionEnabled = true
        leftArrowImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLeftArrowForceDirectionTapped)))
        
        forceDirectionView.addSubview(leftArrowImageView)
        leftArrowImageView.topAnchor.constraint(equalTo: topArrowImageView.bottomAnchor).isActive = true
        leftArrowImageView.rightAnchor.constraint(equalTo: topArrowImageView.leftAnchor).isActive = true
        leftArrowImageView.heightAnchor.constraint(equalToConstant: arrowSize).isActive = true
        leftArrowImageView.widthAnchor.constraint(equalToConstant: arrowSize).isActive = true
        
        let rightArrowImage = UIImage(named: "art.scnassets/force_arrow.png")?.withRenderingMode(.alwaysTemplate)
        rightArrowImageView = UIImageView(image: rightArrowImage)
        rightArrowImageView.tintColor = normal
        rightArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        rightArrowImageView.isUserInteractionEnabled = true
        rightArrowImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRightArrowForceDirectionTapped)))
        
        forceDirectionView.addSubview(rightArrowImageView)
        rightArrowImageView.topAnchor.constraint(equalTo: topArrowImageView.bottomAnchor).isActive = true
        rightArrowImageView.leftAnchor.constraint(equalTo: topArrowImageView.rightAnchor).isActive = true
        rightArrowImageView.heightAnchor.constraint(equalToConstant: arrowSize).isActive = true
        rightArrowImageView.widthAnchor.constraint(equalToConstant: arrowSize).isActive = true
        
        let bottomArrowImage = UIImage(named: "art.scnassets/force_arrow.png")?.withRenderingMode(.alwaysTemplate)
        bottomArrowImageView = UIImageView(image: bottomArrowImage)
        bottomArrowImageView.transform = CGAffineTransform(rotationAngle: .pi / 2)
        bottomArrowImageView.tintColor = normal
        bottomArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomArrowImageView.isUserInteractionEnabled = true
        bottomArrowImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBottomArrowForceDirectionTapped)))
        
        forceDirectionView.addSubview(bottomArrowImageView)
        bottomArrowImageView.topAnchor.constraint(equalTo: leftArrowImageView.bottomAnchor).isActive = true
        bottomArrowImageView.centerXAnchor.constraint(equalTo: forceDirectionView.centerXAnchor).isActive = true
        bottomArrowImageView.heightAnchor.constraint(equalToConstant: arrowSize).isActive = true
        bottomArrowImageView.widthAnchor.constraint(equalToConstant: arrowSize).isActive = true
    }
    
    @objc func handleLeftArrowForceDirectionTapped() {
        print("handleLeftArrowForceDirectionTapped")
        
        if leftArrowImageView.tintColor == normal {
            virtualObjectInteraction.updateForceDirection(direction: .LEFT)
            leftArrowImageView.tintColor = selected
        } else {
            virtualObjectInteraction.updateForceDirection(direction: .NONE)
            leftArrowImageView.tintColor = normal
        }
        rightArrowImageView.tintColor = normal
        topArrowImageView.tintColor = normal
        bottomArrowImageView.tintColor = normal
        
    }
    
    @objc func handleTopArrowForceDirectionTapped() {
        print("handleTopArrowForceDirectionTapped")
        
        if topArrowImageView.tintColor == normal {
            virtualObjectInteraction.updateForceDirection(direction: .UP)
            topArrowImageView.tintColor = selected
        } else {
            virtualObjectInteraction.updateForceDirection(direction: .NONE)
            topArrowImageView.tintColor = normal
        }
        
        leftArrowImageView.tintColor = normal
        rightArrowImageView.tintColor = normal
        bottomArrowImageView.tintColor = normal
    }
    
    @objc func handleRightArrowForceDirectionTapped() {
        print("handleRightArrowForceDirectionTapped")
        
        if rightArrowImageView.tintColor == normal {
            virtualObjectInteraction.updateForceDirection(direction: .RIGHT)
            rightArrowImageView.tintColor = selected
        } else {
            virtualObjectInteraction.updateForceDirection(direction: .NONE)
            rightArrowImageView.tintColor = normal
        }

        leftArrowImageView.tintColor = normal
        topArrowImageView.tintColor = normal
        bottomArrowImageView.tintColor = normal
    }
    
    @objc func handleBottomArrowForceDirectionTapped() {
        print("handleBottomArrowForceDirectionTapped")
        
        if bottomArrowImageView.tintColor == normal {
            virtualObjectInteraction.updateForceDirection(direction: .DOWN)
            bottomArrowImageView.tintColor = selected
        } else {
            virtualObjectInteraction.updateForceDirection(direction: .NONE)
            bottomArrowImageView.tintColor = normal
        }

        topArrowImageView.tintColor = normal
        leftArrowImageView.tintColor = normal
        rightArrowImageView.tintColor = normal
    }
    
    // MARK: - Methods to handle button user interaction
    
    @objc func handleAddForceButtonTapped() {
        if tappingVirtualObjectsMode != .AddingForceToObject {
            tappingVirtualObjectsMode = .AddingForceToObject
            addForceButton.tintColor = selected
        } else if tappingVirtualObjectsMode == .AddingForceToObject {
            tappingVirtualObjectsMode = .SelectObjectForInteraction
            addForceButton.tintColor = normal
        }
    }
    
    @objc func handleAddRopeButtonTapped() {
        if tappingVirtualObjectsMode != .AddingRopeBetweenObjects {
            tappingVirtualObjectsMode = .AddingRopeBetweenObjects
            addRopeButton.tintColor = selected
        } else if tappingVirtualObjectsMode == .AddingRopeBetweenObjects {
            tappingVirtualObjectsMode = .SelectObjectForInteraction
            addRopeButton.tintColor = normal
        }
    }
    
    @objc func handlePlayPauseButtonTapped() {
        isPLaying = !isPLaying
        
        if isPLaying {
            playPauseButton.setStyle(.pause, animated: true)
            sceneView.scene.physicsWorld.speed = 1
            tappingVirtualObjectsMode = .SimulationMode
            
            self.addGeometryButton.isHidden = true
            self.addForceButton.isHidden = true
            self.addRopeButton.isHidden = true
            self.refreshButton.isHidden = true
            
            for child in self.sceneView.scene.rootNode.childNodes {
                if let virtualObject = child as? VirtualObject {
                     self.backupNodesPositionsDictionary[virtualObject.identifier] = virtualObject.position
                }
            }
            
        } else {
            playPauseButton.setStyle(.play, animated: true)
            sceneView.scene.physicsWorld.speed = 0
            tappingVirtualObjectsMode = .SelectObjectForInteraction
            addForceButton.tintColor = normal
            
            self.addGeometryButton.isHidden = false
            self.addForceButton.isHidden = false
            self.addRopeButton.isHidden = false
            self.refreshButton.isHidden = false
        }
        
        applyForcesInEnvironment(root: sceneView.scene.rootNode)
    }
    
    func applyForcesInEnvironment(root: SCNNode) {
        
        for child in root.childNodes {
            if child.name == "force" {
                let parentNode = child.parent as! Cube
                
                switch parentNode.forceDirection {
                case .RIGHT:
                    parentNode.physicsBody?.applyForce(SCNVector3(Float(parentNode.force), 0, 0), asImpulse: false)
                case .LEFT:
                    parentNode.physicsBody?.applyForce(SCNVector3(-Float(parentNode.force), 0, 0), asImpulse: false)
                case .UP:
                    parentNode.physicsBody?.applyForce(SCNVector3(0, Float(parentNode.force), 0), asImpulse: false)
                case .DOWN:
                    parentNode.physicsBody?.applyForce(SCNVector3(0, -Float(parentNode.force), 0), asImpulse: false)
                default:
                    break
                }
                
            }
            applyForcesInEnvironment(root: child)
        }
        
    }
    
    @objc func handleRefreshSceneButtonTapped() {
        print("handleRefreshSceneButtonTapped")
        
        for child in self.sceneView.scene.rootNode.childNodes {
            if let virtualObject = child as? VirtualObject {
                virtualObject.position = self.backupNodesPositionsDictionary[virtualObject.identifier]!
            }
        }
        
    }
    
    @objc func handleAddGeometryButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "fromSimulationToVirtualObjectsSelection", sender: sender)
    }
    
}
