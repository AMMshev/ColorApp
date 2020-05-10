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
    private var parametersNamesStack = UIStackView(arrangedSubviews: [])
    private var parametersValuesStack = UIStackView(arrangedSubviews: [])
    private let copiedView: UIView = {
        let copiedView = UIView()
        copiedView.layer.cornerRadius = 20
        copiedView.backgroundColor = .white
        copiedView.isUserInteractionEnabled = false
        copiedView.layer.shadowColor = UIColor.black.cgColor
        copiedView.layer.shadowOffset = CGSize(width: 3, height: 4)
        copiedView.layer.shadowRadius = 20
        copiedView.layer.shadowOpacity = 1
        copiedView.alpha = 0
        return copiedView
    }()
    private let copiedLabel: UILabel = {
        let copiedLabel = UILabel()
        copiedLabel.text = "Copied to clipboard"
        copiedLabel.textColor = .black
        return copiedLabel
    }()
    private var RGBLabel: UILabel = {
        let RGBLabel = UILabel()
        RGBLabel.font = RGBLabel.font.withSize(30)
        RGBLabel.text = "RGB"
        RGBLabel.numberOfLines = 3
        return RGBLabel
    }()
    private var HSBLabel: UILabel = {
        let HSBLabel = UILabel()
        HSBLabel.font = HSBLabel.font.withSize(30)
        HSBLabel.text = "HSB"
        HSBLabel.numberOfLines = 3
        return HSBLabel
    }()
    private var HEXLabel: UILabel = {
        let hexLabel = UILabel()
        hexLabel.font = hexLabel.font.withSize(30)
        hexLabel.text = "HEX"
        hexLabel.numberOfLines = 3
        return hexLabel
    }()
    private let RGBButton: UIButton = {
        let RGBButton = UIButton()
        RGBButton.addTarget(self, action: #selector(copy(sender:)), for: .touchUpInside)
        RGBButton.titleLabel?.font = RGBButton.titleLabel?.font.withSize(30)
        return RGBButton
    }()
    private let HSBButton: UIButton = {
        let HSBButton = UIButton()
        HSBButton.addTarget(self, action: #selector(copy(sender:)), for: .touchUpInside)
        HSBButton.titleLabel?.font = HSBButton.titleLabel?.font.withSize(30)
        return HSBButton
    }()
    private let HEXButton: UIButton = {
        let HEXButton = UIButton()
        HEXButton.addTarget(self, action: #selector(copy(sender:)), for: .touchUpInside)
        HEXButton.titleLabel?.font = HEXButton.titleLabel?.font.withSize(30)
        return HEXButton
    }()
    private var HEXRGBHSBValueLabel: UILabel = {
        let RGBLabel = UILabel()
        RGBLabel.font = RGBLabel.font.withSize(30)
        RGBLabel.numberOfLines = 3
        return RGBLabel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViews()
    }
}
// MARK: - visual methods
extension DetailColorViewController {
    private func setViews() {
        navigationItem.title = color.name
        view.backgroundColor = UIColor(red: color.r, green: color.g, blue: color.b, alpha: 1)
        setConstraintsOn(view: infoStack, parantView: view, leadingConstant: 20, trailingConstant: -20, centeringyConstant: 0)
        setConstraintsOn(view: copiedView, parantView: view, height: 150, width: 200, centeringxConstant: 0, centeringyConstant: 0)
        setConstraintsOn(view: copiedLabel, parantView: copiedView, centeringxConstant: 0, centeringyConstant: 0)
        guard let hsbColor = UIColor(red: color.r, green: color.g, blue: color.b, alpha: 1).getHSB() else { return }
        if hsbColor.brightness < 0.5 {
            RGBLabel.textColor = .white
            HSBLabel.textColor = .white
            HEXLabel.textColor = .white
            RGBButton.setTitleColor(.white, for: .normal)
            HSBButton.setTitleColor(.white, for: .normal)
            HEXButton.setTitleColor(.white, for: .normal)
            copiedView.layer.shadowColor = UIColor.white.cgColor
            navigationController?.navigationBar.tintColor = .white
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        } else {
            RGBLabel.textColor = .black
            HSBLabel.textColor = .black
            HEXLabel.textColor = .black
            RGBButton.setTitleColor(.black, for: .normal)
            HSBButton.setTitleColor(.black, for: .normal)
            HEXButton.setTitleColor(.black, for: .normal)
            copiedView.layer.shadowColor = UIColor.black.cgColor
            navigationController?.navigationBar.tintColor = .black
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        }
        parametersNamesStack.addArrangedSubview(RGBLabel)
        parametersNamesStack.addArrangedSubview(HSBLabel)
        parametersNamesStack.addArrangedSubview(HEXLabel)
        parametersNamesStack.axis = .vertical
        parametersNamesStack.alignment = .leading
        parametersNamesStack.distribution = .fillProportionally
        infoStack.addArrangedSubview(parametersNamesStack)
        let rgbValue = "\(color.r), \(color.g), \(color.b)"
        RGBButton.setTitle(rgbValue, for: .normal)
        let hsbValue = "\(String(format: "%.2f", hsbColor.hue)), " +
        "\(String(format: "%.2f", hsbColor.saturation)), \(String(format: "%.2f", hsbColor.brightness))"
        HSBButton.setTitle(hsbValue, for: .normal)
        HEXButton.setTitle(color.hex.uppercased(), for: .normal)
        parametersValuesStack.addArrangedSubview(RGBButton)
        parametersValuesStack.addArrangedSubview(HSBButton)
        parametersValuesStack.addArrangedSubview(HEXButton)
        parametersValuesStack.axis = .vertical
        parametersValuesStack.alignment = .trailing
        parametersNamesStack.distribution = .fillProportionally
        infoStack.addArrangedSubview(parametersValuesStack)
        infoStack.axis = .horizontal
        infoStack.alignment = .fill
        infoStack.distribution = .fill
    }
// MARK: - this method copies a value of the color parameter by clicking on the button which shows it
    @objc func copy(sender: UIButton) {
        UIPasteboard.general.string = sender.titleLabel?.text
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return }
            self.copiedView.alpha = 0.8
        }) { _ in
            UIView.animate(withDuration: 1) { [weak self] in
                guard let self = self else { return }
                sleep(UInt32(1))
                self.copiedView.alpha = 0
            }
        }
    }
    @IBAction func addToFavourites(_ sender: Any) {
        
    }
}
