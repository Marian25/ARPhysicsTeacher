//
//  VirtualObjectSelectionCollectionViewController.swift
//  ARTeacher_v3
//
//  Created by Marian Stanciulica on 04/03/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import UIKit

enum VirtualObjectsCategory {
    case RampSimulationPhysics
}

protocol VirtualObjectSelectionCollectionViewDelegate: class {
    func virtualObjectSelectionCollectionView(_ selectionViewController: VirtualObjectSelectionCollectionViewController, didSelectObject objectName: String)
}


private let reuseIdentifier = "virtualObjectCell"

class VirtualObjectSelectionCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var virtualObjectsCategory: VirtualObjectsCategory = .RampSimulationPhysics
    
    /// Virtual objects from collection
    var virtualObjects = [String]()
    
    /// Size of objects cells from collection view
    var width = UIScreen.main.bounds.width * 0.8
    var height = UIScreen.main.bounds.height * 0.5
    
    weak var delegate: VirtualObjectSelectionCollectionViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .white
        
        if virtualObjectsCategory == .RampSimulationPhysics {
            virtualObjects = ["ramp", "cube", "pulley"]
        }
        
        self.preferredContentSize = CGSize(width: width, height: height)
    }

    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return virtualObjects.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VirtualObjectSelectionCollectionViewCell
    
        // Configure the cell
        cell.virtualObjectImageView.image = UIImage(named: "art.scnassets/\(virtualObjects[indexPath.row]).png")
        cell.virtualObjectNameLabel.text = virtualObjects[indexPath.row]
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellLength = collectionView.bounds.height - 8
        return CGSize(width: cellLength, height: cellLength)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        var virtualObject: String
        
        switch virtualObjects[indexPath.row] {
        case "ramp":
            virtualObject = "ramp"
        case "cube":
            virtualObject = "cube"
        case "pulley":
            virtualObject = "pulley"
        default:
            virtualObject = "virtual object"
        }
        
        delegate?.virtualObjectSelectionCollectionView(self, didSelectObject: virtualObject)
        
        dismiss(animated: true, completion: nil)
    }

}
