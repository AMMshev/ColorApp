//
//  ViewController.swift
//  CourseProject
//
//  Created by Артем Манышев on 26.03.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.backgroundColor = MainViewController.backgroundColorArray[MainViewController.backgroundColorNumber]
        registerButton.backgroundColor = MainViewController.backgroundColorArray[MainViewController.backgroundColorNumber]
        loginButton.layer.cornerRadius = 5
        registerButton.layer.cornerRadius = 5
    }
    @IBAction func registerButtonTapped(_ sender: Any) {
        LoginRegisterViewController.isRegisterScreen = true
        performSegue(withIdentifier: "loginRegisterScreen", sender: nil)
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        LoginRegisterViewController.isRegisterScreen = false
        performSegue(withIdentifier: "loginRegisterScreen", sender: nil)
    }
}
