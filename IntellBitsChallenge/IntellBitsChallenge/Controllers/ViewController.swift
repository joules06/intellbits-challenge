//
//  ViewController.swift
//  IntellBitsChallenge
//
//  Created by Julio Rico on 20/10/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchContainerView.layer.borderWidth = 1
        searchContainerView.layer.borderColor = UIColor.black.cgColor
    }


}

