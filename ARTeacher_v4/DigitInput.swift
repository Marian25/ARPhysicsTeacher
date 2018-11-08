//
//  DigitInput.swift
//  ARTeacher_v3
//
//  Created by Marian Stanciulica on 07/06/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import UIKit
import ARKit
import DigitInputView

class DigitInput {
    
    var sceneView: ARSCNView
    var digitInput: DigitInputView!
    var measureUnitLabel: UILabel!
    var tapGesture: UITapGestureRecognizer!
    var currentMeasureUnit: String?
    var virtualObjectInteraction: VirtualObjectInteraction
    var parentNode: VirtualObject?
    var endEditing = true
    
    var enableDigitInputForRamp = false
    var digitInputForRampStillRunning = false
    var digitInputForRampVariables = 0
    
    static var messageToSend: String?
    
    init(sceneView: ARSCNView, virtualObjectInteraction: VirtualObjectInteraction) {
        self.sceneView = sceneView
        self.virtualObjectInteraction = virtualObjectInteraction
    }
    
    func showDigitInput(measureUnit: String, parentNode: VirtualObject) {
        endEditing = false
        
        digitInput = DigitInputView()
        measureUnitLabel = UILabel()
        self.currentMeasureUnit = measureUnit
        self.parentNode = parentNode
        
        digitInput.numberOfDigits = 4
        digitInput.bottomBorderColor = .white
        digitInput.nextDigitBottomBorderColor = UIColor(red: 70/255, green: 178/255, blue: 240/255, alpha: 1)
        digitInput.textColor = .white
        digitInput.acceptableCharacters = "0123456789,"
        digitInput.keyboardType = .decimalPad
        digitInput.font = UIFont.monospacedDigitSystemFont(ofSize: 10, weight: UIFont.Weight(rawValue: 1))
        digitInput.animationType = .spring
        
        measureUnitLabel.text = measureUnit
        measureUnitLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 60, weight: UIFont.Weight(rawValue: 1))
        measureUnitLabel.textColor = .white
        
        digitInput.translatesAutoresizingMaskIntoConstraints = false
        measureUnitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sceneView.addSubview(digitInput)
        sceneView.addSubview(measureUnitLabel)
        
        digitInput.topAnchor.constraint(equalTo: sceneView.topAnchor, constant: 120).isActive = true
        digitInput.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor).isActive = true
        digitInput.widthAnchor.constraint(equalToConstant: 288).isActive = true
        digitInput.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        measureUnitLabel.topAnchor.constraint(equalTo: sceneView.topAnchor, constant: 126).isActive = true
        measureUnitLabel.leftAnchor.constraint(equalTo: digitInput.rightAnchor, constant: 8).isActive = true
        measureUnitLabel.heightAnchor.constraint(equalToConstant: 68).isActive = true
        measureUnitLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        for gesture in sceneView.gestureRecognizers! {
            gesture.isEnabled = false
        }
        
        // Let editing end when the view is tapped
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        _ = digitInput.becomeFirstResponder()
    }
    
    @objc func endEditing(_ sender: UITapGestureRecognizer) {
        if digitInput.text.count > 0 {
            if currentMeasureUnit != "N" || (currentMeasureUnit == "N" && virtualObjectInteraction.currentForceDirection != .NONE) {
                _ = digitInput?.resignFirstResponder()
                
                digitInput.removeFromSuperview()
                measureUnitLabel.removeFromSuperview()
                sceneView.removeGestureRecognizer(tapGesture)
                
                for gesture in sceneView.gestureRecognizers! {
                    gesture.isEnabled = true
                }
                
                if let floatNumber = NumberFormatter().number(from: digitInput.text) {
                    if currentMeasureUnit == "°" && Double(truncating: floatNumber) >= 90.0 {
                        DigitInput.messageToSend = "Value for slope must be less than 90!"
                        self.showDigitInput(measureUnit: currentMeasureUnit!, parentNode: self.parentNode!)
                    } else if currentMeasureUnit == "" && Double(truncating: floatNumber) >= 1 {
                        DigitInput.messageToSend = "Value for friction must be less than 1.0!"
                        self.showDigitInput(measureUnit: currentMeasureUnit!, parentNode: self.parentNode!)
                    } else if Double(truncating: floatNumber) == 0 {
                        DigitInput.messageToSend = "Please insert nonzero value!"
                        self.showDigitInput(measureUnit: currentMeasureUnit!, parentNode: self.parentNode!)
                    } else {
                        
                        self.addTextNode()
                        parentNode?.updateVariables(value: CGFloat(truncating: floatNumber), measureUnit: currentMeasureUnit!)
                        
                        if self.digitInputForRampStillRunning == true {
                            self.digitInputForRampVariables += 1
                            self.enableDigitInputForRamp = true
                        }
                    }
                }
                
                endEditing = true
                
            } else {
                DigitInput.messageToSend = "You need to select a direction for force!"
            }
        } else {
            DigitInput.messageToSend = "Please, input a value for variable!"
        }
        
    }
    
    func showDigitInputForRamp(parentNode: VirtualObject) {
        self.enableDigitInputForRamp = true
        self.digitInputForRampStillRunning = true
        self.parentNode = parentNode
    }
    
    func checkIfDigitInputIsEnabled(messageView: MessageView) {
        
        if self.enableDigitInputForRamp == true && self.digitInputForRampStillRunning == true {
            
            if self.digitInputForRampVariables == 0 {
                DigitInput.messageToSend = "Insert value for plan slope!"
                self.showDigitInput(measureUnit: "°", parentNode: self.parentNode!)
            } else if digitInputForRampVariables == 1 {
                DigitInput.messageToSend = "Insert value for plan height!"
                self.showDigitInput(measureUnit: "m", parentNode: self.parentNode!)
            } else if digitInputForRampVariables == 2 {
                DigitInput.messageToSend = "Insert value for plan friction!"
                self.showDigitInput(measureUnit: "", parentNode: self.parentNode!)
            } else {
                self.digitInputForRampStillRunning = false
                self.digitInputForRampVariables = 0
            }
            
            self.enableDigitInputForRamp = false
        }
    }
    
    func addTextNode() {
        let textNode = Text(text: digitInput.text, currentMeasureUnit: currentMeasureUnit!, tappedObject: parentNode!)
        switch currentMeasureUnit {
        case "N":
            if let childNode = parentNode!.childNode(withName: "force", recursively: true) {
                print("adauga text node la force node in end editing")
                if let textToRemove = childNode.childNode(withName: "text", recursively: true) {
                    textToRemove.removeFromParentNode()
                }
                
                childNode.addChildNode(textNode)
            }
        case "Kg":
            parentNode!.addChildNode(textNode)
        case "°":
            parentNode!.addChildNode(textNode)
        default:
            break
        }
    }
    
    func getText() -> String {
        return digitInput.text
    }
    
}
