//
//  ThreeColorsViewController.swift
//  CourseProject
//
//  Created by Артем Манышев on 26.03.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//

import UIKit

class ThreeColorsViewController: UIViewController {
    
    @IBOutlet weak var sourceImageView: UIImageView!
    @IBOutlet weak var mainColor: UIView!
    @IBOutlet weak var secondaryColor: UIView!
    @IBOutlet weak var additionalColor: UIView!
    @IBOutlet weak var gradientColorsView: UIView!
    @IBOutlet weak var mainColorNameLabel: UILabel!
    @IBOutlet weak var secondaryColorNameLabel: UILabel!
    @IBOutlet weak var additionalColorNameLabel: UILabel!
    @IBOutlet weak var gradientColorsLabel: UILabel!
    @IBOutlet weak var colorsStack: UIStackView!
    
    private var colorsOnPage: [ColorModel] = []
    private var gradientColors: [CGColor] = []
    private var colorNumber = 0
    var sourceImage: UIImage?
    private let mainTapGesture = UITapGestureRecognizer()
    private let secondaryTapGesture = UITapGestureRecognizer()
    private let additionalTapGesture = UITapGestureRecognizer()
    private let gradientTapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        setConstraintsOn(view: sourceImageView, parantView: view, height: UIScreen.main.bounds.width,
                         width: UIScreen.main.bounds.width,
                         topConstant: 0 - (navigationController?.navigationBar.bounds.height ?? 0))
        guard let sourceImage = sourceImage else { return }
        sourceImageView.image = sourceImage
        Networking.shared.uploadData(image: sourceImage, completion: { imageLink in
            guard let imageLink = imageLink else { return }
            Networking.shared.getData(imageLink: imageLink, completion: { [weak self] data in
                guard let self = self else { return }
                do {
                    let json = try JSONDecoder().decode(JSONAnswer.self, from: data )
                    let RGBColors = json.result.colors.image_colors
                    self.gradientColors = self.makeGradientArray(colors: json.result.colors)
                    DispatchQueue.main.async {
                        if RGBColors.count >= 1 {
                            self.setColor(colorView: self.mainColor,
                                          colorNameLabel: self.mainColorNameLabel,
                                          tapGesture: self.mainTapGesture,
                                          rParameter: RGBColors[0].r,
                                          gParameter: RGBColors[0].g,
                                          bParameter: RGBColors[0].b)
                        }
                        if RGBColors.count >= 2 {
                            self.setColor(colorView: self.secondaryColor,
                                          colorNameLabel: self.secondaryColorNameLabel,
                                          tapGesture: self.secondaryTapGesture,
                                          rParameter: RGBColors[1].r,
                                          gParameter: RGBColors[1].g,
                                          bParameter: RGBColors[1].b)
                        }
                        if RGBColors.count >= 3 {
                            self.setColor(colorView: self.additionalColor,
                                          colorNameLabel: self.additionalColorNameLabel,
                                          tapGesture: self.additionalTapGesture,
                                          rParameter: RGBColors[2].r,
                                          gParameter: RGBColors[2].g,
                                          bParameter: RGBColors[2].b)
                        }
                        self.setColor(colorView: self.gradientColorsView,
                                      colorNameLabel: self.gradientColorsLabel,
                                      tapGesture: self.gradientTapGesture,
                                      gradientColors: self.gradientColors)
                        self.colorsStack.arrangedSubviews.forEach({$0.isUserInteractionEnabled = true})
                    }
                } catch {
                    print("JSON error")
                }
            })
        })
    }
    
    private func setColor(colorView: UIView,
                          colorNameLabel: UILabel,
                          tapGesture: UITapGestureRecognizer,
                          gradientColors: [CGColor]? = nil,
                          rParameter: Int? = nil,
                          gParameter: Int? = nil,
                          bParameter: Int? = nil) {
        colorView.isHidden = false
        colorNameLabel.isHidden = false
        if let rParameter = rParameter,
            let gParameter = gParameter,
            let bParameter = bParameter {
            colorView.backgroundColor = UIColor(red: rParameter, green: gParameter, blue: bParameter, alpha: 1)
            guard let colorModel = ColorsFromFileData.shared.makeModelOfColor(rParameter, gParameter, bParameter) else { return }
            colorNameLabel.text = colorModel.name
            colorsOnPage.append(colorModel)
            tapGesture.addTarget(self, action: #selector(colorTapped(sender:)))
            colorView.layer.cornerRadius = colorView.bounds.height / 2
        } else {
            if let gradientColors = gradientColors {
                let gradientLayer = makeGradientLayerWith(width: 80, height: 80, colors: gradientColors, gradientType: .conic, cornerRadius: 40)
                colorView.layer.insertSublayer(gradientLayer, at: 0)
                colorNameLabel.text = "all colors"
                tapGesture.addTarget(self, action: #selector(gradientTapped))
            }
        }
        colorView.isUserInteractionEnabled = true
        colorView.addGestureRecognizer(tapGesture)
        colorView.setNeedsDisplay()
    }
    
    private func makeGradientArray(colors: ColorsList) -> [CGColor] {
        var gradientColors: [CGColor] = []
        colors.background_colors.forEach({
            let color = UIColor(red: $0.r, green: $0.g, blue: $0.b, alpha: 1)
            gradientColors.append(color.cgColor)
        })
        colors.foreground_colors.forEach({
            let color = UIColor(red: $0.r, green: $0.g, blue: $0.b, alpha: 1)
            gradientColors.append(color.cgColor)
        })
        colors.image_colors.forEach({
            let color = UIColor(red: $0.r, green: $0.g, blue: $0.b, alpha: 1)
            gradientColors.append(color.cgColor)
        })
        print(gradientColors.count)
        return gradientColors
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor(named: "navBarColor")
    }
    
    @objc private func colorTapped(sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        switch view {
        case mainColor:
            colorNumber = 0
        case secondaryColor:
            colorNumber = 1
        case additionalColor:
            colorNumber = 2
        default:
            colorNumber = 0
        }
        self.performSegue(withIdentifier: "detailScreen", sender: nil)
    }
    @objc private func gradientTapped() {
        self.performSegue(withIdentifier: "gradientCircle", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailScreen" {
            let destinationVC = segue.destination as? DetailColorViewController
            destinationVC?.color = colorsOnPage[colorNumber]
        }
        if segue.identifier == "gradientCircle" {
            let destinationVC = segue.destination as? ColorCircleViewController
            destinationVC?.gradientColors = gradientColors
        }
    }
}
