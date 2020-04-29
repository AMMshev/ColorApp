//
//  DetailColorViewController.swift
//  CourseProject
//
//  Created by Artem Manyshev on 27.04.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//

import UIKit

class DetailColorViewController: UIViewController {
    
    var color = ColorModel(name: "", r: 0, g: 0, b: 0, hex: "")
    var infoStack = UIStackView(arrangedSubviews: [])
    var HEXRGBLabel: UILabel = {
        let hexLabel = UILabel()
        hexLabel.font = hexLabel.font.withSize(30)
        hexLabel.text = "HEX\nRGB"
        hexLabel.numberOfLines = 2
        return hexLabel
    }()
    var HEXRGBValueLabel: UILabel = {
        let RGBLabel = UILabel()
        RGBLabel.font = RGBLabel.font.withSize(30)
        RGBLabel.numberOfLines = 2
        return RGBLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = color.name
        view.backgroundColor = UIColor(red: color.r, green: color.g, blue: color.b, alpha: 1)
        view.addSubview(infoStack)
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        infoStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        infoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        infoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        infoStack.alignment = .center
        infoStack.axis = .horizontal
        infoStack.distribution = .equalCentering
        if  color.r < 125 &&
            color.r < 125 &&
            color.r < 125 {
            HEXRGBLabel.textColor = .white
            HEXRGBValueLabel.textColor = .white
            navigationController?.navigationBar.tintColor = .white
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        } else {
            HEXRGBLabel.textColor = .black
            HEXRGBValueLabel.textColor = .black
            navigationController?.navigationBar.tintColor = .black
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        }
        HEXRGBValueLabel.text = "\(color.hex)\n\(color.r), \(color.g), \(color.b)"
        infoStack.addArrangedSubview(HEXRGBLabel)
        infoStack.addArrangedSubview(HEXRGBValueLabel)
    }
}
