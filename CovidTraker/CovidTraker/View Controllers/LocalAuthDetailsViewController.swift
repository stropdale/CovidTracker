//
//  LocalAuthDetailsViewController.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 07/10/2020.
//

import UIKit

class LocalAuthDetailsViewController: UIViewController {
    
    var localAuthModel: LocalAuthorityModel? {
        didSet {
            populate()
        }
    }
    
    private func populate() {
        title = localAuthModel?.localAuthorityName
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
