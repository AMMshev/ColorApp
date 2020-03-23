//
//  MainViewController.swift
//  CourseProject
//
//  Created by Артем Манышев on 23.03.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.

import UIKit

class MainViewController: UIViewController {
    
    let backgroundColorArray: [UIColor] =
            [UIColor(red: 24, green: 119, blue: 242, alpha: 1),
            UIColor(red: 29, green: 161, blue: 242, alpha: 1),
            UIColor(red: 255, green: 0, blue: 0, alpha: 1),
            UIColor(red: 195, green: 42, blue: 163, alpha: 1),
            UIColor(red: 189, green: 8, blue: 28, alpha: 1),
            UIColor(red: 0, green: 119, blue: 181, alpha: 1),
            UIColor(red: 52, green: 168, blue: 83, alpha: 1),
            UIColor(red: 251, green: 188, blue: 5, alpha: 1),
            UIColor(red: 18, green: 140, blue: 126, alpha: 1),
            UIColor(red: 24, green: 69, blue: 0, alpha: 1)]
    let backgroundColorNumber: Int = {
        let number = Int(arc4random_uniform(9))
        return number
    }()
    
    let appLogo: UIImageView = {
        let appLogo = UIImageView()
        guard let appLogoImage = UIImage(named: "logo2") else {fatalError("No such logo image")}
        appLogo.image = appLogoImage
        appLogo.translatesAutoresizingMaskIntoConstraints = false
        appLogo.widthAnchor.constraint(equalToConstant: 150).isActive = true
        appLogo.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return appLogo
    }()
    
    let color: UIButton = {
        let color = UIButton()
        color.setTitle("Colors", for: .normal)
        color.setTitleColor(.white, for: .normal)
        color.titleLabel?.font = color.titleLabel?.font.withSize(CGFloat(30))
        color.translatesAutoresizingMaskIntoConstraints = false
        return color
    }()
    
    let images: UIButton = {
        let images = UIButton()
        images.setTitle("Images", for: .normal)
        images.setTitleColor(.white, for: .normal)
        images.titleLabel?.font = images.titleLabel?.font.withSize(CGFloat(30))
        images.translatesAutoresizingMaskIntoConstraints = false
        return images
    }()
    
    let colorCircle: UIButton = {
        let colorCircle = UIButton()
        colorCircle.setTitle("Color circle", for: .normal)
        colorCircle.setTitleColor(.white, for: .normal)
        colorCircle.titleLabel?.font = colorCircle.titleLabel?.font.withSize(CGFloat(30))
        colorCircle.translatesAutoresizingMaskIntoConstraints = false
        return colorCircle
    }()
    
    let userProfile: UIButton = {
        let userProfile = UIButton()
        userProfile.setBackgroundImage(UIImage(named: "userProfile"), for: .normal)
        userProfile.translatesAutoresizingMaskIntoConstraints = false
        userProfile.heightAnchor.constraint(equalToConstant: 30).isActive = true
        userProfile.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return userProfile
    }()
    
    var colorCenterConstraint = NSLayoutConstraint()
    var imagesCenterConstraint = NSLayoutConstraint()
    var colorCircleCenterConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColorArray[backgroundColorNumber]
        view.addSubview(appLogo)
        view.addSubview(color)
        view.addSubview(images)
        view.addSubview(colorCircle)
        view.addSubview(userProfile)
        appLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        appLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        colorCenterConstraint = color.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        colorCenterConstraint.isActive = true
        color.topAnchor.constraint(equalTo: appLogo.bottomAnchor, constant: 50).isActive = true
        imagesCenterConstraint = images.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50)
        imagesCenterConstraint.isActive = true
        images.topAnchor.constraint(equalTo: color.bottomAnchor, constant: 20).isActive = true
        colorCircleCenterConstraint = colorCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100)
        colorCircleCenterConstraint.isActive = true
        colorCircle.topAnchor.constraint(equalTo: images.bottomAnchor, constant: 20).isActive = true
        userProfile.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        userProfile.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        colorCenterConstraint.isActive = false
        imagesCenterConstraint.isActive = false
        colorCircleCenterConstraint.isActive = false
        color.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        images.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        colorCircle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else {return}
            self.view.layoutIfNeeded()
        })
    }
}

extension UIColor {
    convenience init(red: Int = 0, green: Int = 0, blue: Int = 0, alpha: Int = 1) {
        precondition(0...255 ~= red   &&
            0...255 ~= green &&
            0...255 ~= blue  &&
            0...1 ~= alpha, "input range is out of range")
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha))
    }
}