//
//  LoginRegisterViewController.swift
//  CourseProject
//
//  Created by Артем Манышев on 26.03.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//

import UIKit

class LoginRegisterViewController: UIViewController {
    
    static var isRegisterScreen = true
    static let defaultsKey = "isRememberChoosen"
    
    @IBOutlet weak var registerNameTextField: UITextField!
    @IBOutlet weak var registerSurnameTextField: UITextField!
    @IBOutlet weak var registerLoginTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    @IBOutlet weak var registerConfirmPasswordTextField: UITextField!
    @IBOutlet weak var registerStack: UIStackView!
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginStack: UIStackView!
    
    @IBOutlet weak var loginSwitcher: UISwitch!
    
    @IBOutlet weak var registerSwitcher: UISwitch!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginSwitcher.onTintColor = MainViewController.backgroundColorArray[MainViewController.backgroundColorNumber]
        registerSwitcher.onTintColor = MainViewController.backgroundColorArray[MainViewController.backgroundColorNumber]
        registerButton.backgroundColor = MainViewController.backgroundColorArray[MainViewController.backgroundColorNumber]
        registerButton.layer.cornerRadius = 5
        loginButton.backgroundColor = MainViewController.backgroundColorArray[MainViewController.backgroundColorNumber]
        loginButton.layer.cornerRadius = 5
        switch LoginRegisterViewController.isRegisterScreen {
        case true:
            loginStack.isHidden = true
        case false:
            registerStack.isHidden = true
        }
    }
    
    @IBAction func performLogin(_ sender: Any) {
        performSegue(withIdentifier: "mainScreen", sender: nil)
    }
    @IBAction func remberOnThisDeviceSwitched(_ sender: UISwitch) {
        UserDefaults.standard.setValue(sender.isOn, forKey: LoginRegisterViewController.defaultsKey)
    }
}
