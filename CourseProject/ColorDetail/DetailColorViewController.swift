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
    private var infoStack = UIStackView(arrangedSubviews: [])
    private var HEXRGBLabel: UILabel = {
        let hexLabel = UILabel()
        hexLabel.font = hexLabel.font.withSize(30)
        hexLabel.text = "HEX\nRGB\nHSB"
        hexLabel.numberOfLines = 3
        return hexLabel
    }()
    private var HEXRGBHSBValueLabel: UILabel = {
        let RGBLabel = UILabel()
        RGBLabel.font = RGBLabel.font.withSize(30)
        RGBLabel.numberOfLines = 3
        return RGBLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
}
// MARK: - visual methods
extension DetailColorViewController {
    private func setViews() {
        navigationItem.title = color.name
        view.backgroundColor = UIColor(red: color.r, green: color.g, blue: color.b, alpha: 1)
        setConstraintsOn(view: infoStack, parantView: view, centeringxConstant: 0, centeringyConstant: 0)
        if  color.r < 125 &&
            color.r < 125 &&
            color.r < 125 {
            HEXRGBLabel.textColor = .white
            HEXRGBHSBValueLabel.textColor = .white
            navigationController?.navigationBar.tintColor = .white
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        } else {
            HEXRGBLabel.textColor = .black
            HEXRGBHSBValueLabel.textColor = .black
            navigationController?.navigationBar.tintColor = .black
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        }
        guard let hsbColor = UIColor(red: color.r, green: color.g, blue: color.b, alpha: 1).getHSB() else { return }
        HEXRGBHSBValueLabel.text = "\(color.hex)" +
        "\n\(color.r), \(color.g), \(color.b)" +
        "\n\(String(format: "%.2f", hsbColor.hue))," +
        "\(String(format: "%.2f", hsbColor.saturation)), \(String(format: "%.2f", hsbColor.brightness))"
        infoStack.addArrangedSubview(HEXRGBLabel)
        infoStack.addArrangedSubview(HEXRGBHSBValueLabel)
        infoStack.axis = .horizontal
        infoStack.alignment = .fill
        infoStack.distribution = .fill
    }
}
