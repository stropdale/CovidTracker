//
//  LocalAuthDetailsViewController.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 07/10/2020.
//

import UIKit

class LocalAuthDetailsViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    
    var model: LocalAuthorityModel? {
        didSet {
            
            populate()
        }
    }
    
    private func populate() {
        navBar.topItem?.title = model?.localAuthorityName
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
