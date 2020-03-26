//
//  LoginRegisterViewController.swift
//  CourseProject
//
//  Created by Артем Манышев on 26.03.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//

import UIKit

class LoginRegisterViewController: UIViewController {
    
    static let defaultsKey = "isRememberChoosen"
    
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var performButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switcher.onTintColor = MainViewController.backgroundColorArray[MainViewController.backgroundColorNumber]
        performButton.backgroundColor = MainViewController.backgroundColorArray[MainViewController.backgroundColorNumber]
        performButton.layer.cornerRadius = 5
    }
    @IBAction func performLogin(_ sender: Any) {
        performSegue(withIdentifier: "mainScreen", sender: nil)
    }
    @IBAction func remberOnThisDeviceSwitched(_ sender: UISwitch) {
        UserDefaults.standard.setValue(sender.isOn, forKey: LoginRegisterViewController.defaultsKey)
    }
}
