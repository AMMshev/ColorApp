//
//  ViewController.swift
//  CourseProject
//
//  Created by Артем Манышев on 26.03.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.backgroundColor = MainViewController.backgroundColorArray[MainViewController.backgroundColorNumber]
        loginButton.backgroundColor = MainViewController.backgroundColorArray[MainViewController.backgroundColorNumber]
        registerButton.layer.cornerRadius = 5
        loginButton.layer.cornerRadius = 5
    }
    @IBAction func registerButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "registerScreen", sender: nil)
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "loginScreen", sender: nil)
    }
}
