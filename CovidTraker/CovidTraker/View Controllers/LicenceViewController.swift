//
//  LicenceViewController.swift
//  CovidTraker
//
//  Created by Richard Stockdale on 12/10/2020.
//

import UIKit

class LicenceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func doneTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sourceDataTapped(_ sender: Any) {
        guard let url = URL(string: "https://www.gov.uk/government/publications/national-covid-19-surveillance-reports") else { return }
        UIApplication.shared.open(url)
    }
}
