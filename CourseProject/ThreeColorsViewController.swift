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
    @IBOutlet weak var mainColorNameLabel: UILabel!
    @IBOutlet weak var secondaryColorName: UILabel!
    @IBOutlet weak var additionalColorName: UILabel!
    @IBOutlet weak var colorsStack: UIStackView!
    
    private var allColors: [ColorList] = []
    private var recognizedColor: [ColorModel] = []
    private var colorNumber = 0
    var sourceImage: UIImage?
    let mainTapGesture = UITapGestureRecognizer()
    let secondaryTapGesture = UITapGestureRecognizer()
    let additionalTapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        guard let colors = ColorsFromFileData.shared.takeColorsFromFile() else { return }
        allColors = colors
        guard let sourceImage = sourceImage else { return }
        sourceImageView.image = sourceImage
        Networking.shared.uploadData(image: sourceImage, completion: { imageLink in
            guard let imageLink = imageLink else { return }
            Networking.shared.getData(imageLink: imageLink, completion: { [weak self] data in
                guard let self = self else { return }
                do {
                    let json = try JSONDecoder().decode(JSONAnswer.self, from: data )
                    let RGBColors = json.result.colors.image_colors
                    DispatchQueue.main.async {
                        self.setColor(self.mainColor,
                                      self.mainColorNameLabel,
                                      self.mainTapGesture,
                                      RGBColors[0].r,
                                      RGBColors[0].g,
                                      RGBColors[0].b)
                        self.setColor(self.secondaryColor,
                                      self.secondaryColorName,
                                      self.secondaryTapGesture,
                                      RGBColors[1].r,
                                      RGBColors[1].g,
                                      RGBColors[1].b)
                        self.setColor(self.additionalColor,
                                      self.additionalColorName,
                                      self.additionalTapGesture,
                                      RGBColors[2].r,
                                      RGBColors[2].g,
                                      RGBColors[2].b)
                        self.colorsStack.arrangedSubviews.forEach({$0.isUserInteractionEnabled = true})
                    }
                } catch {
                    print("JSON error")
                }
            })
        })
    }
    
    private func setColor(_ colorView: UIView,
                          _ colorNameLabel: UILabel,
                          _ tapGesture: UITapGestureRecognizer,
                          _ rParameter: Int,
                          _ gParameter: Int,
                          _ bParameter: Int) {
        colorView.backgroundColor = UIColor(red: rParameter, green: gParameter, blue: bParameter, alpha: 1)
        colorView.setNeedsDisplay()
        colorNameLabel.text = searchColorName(rParameter, gParameter, bParameter)
        tapGesture.addTarget(self, action: #selector(colorTapped(sender:)))
        colorView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor(named: "Color")
    }
    
    @objc func colorTapped(sender: UITapGestureRecognizer) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailScreen" {
            let destinationVC = segue.destination as? DetailColorViewController
            destinationVC?.color = recognizedColor[colorNumber]
        }
    }
    
    private func searchColorName(_ rColor: Int, _ gColor: Int, _ bColor: Int) -> String? {
        var colorFromList: [ColorList] = []
        var error: Int = 0
        while colorFromList.isEmpty {
            colorFromList = allColors.filter({(
                (rColor - error)...(rColor + error)).contains($0.rgb.r) &&
                ((gColor - error)...(gColor + error)).contains($0.rgb.g) &&
                ((bColor - error)...(bColor + error)).contains($0.rgb.b)})
            error += 1
        }
        if colorFromList.first != nil {
            let model = ColorModel(name: colorFromList.first!.name,
                                   r: colorFromList.first!.rgb.r,
                                   g: colorFromList.first!.rgb.g,
                                   b: colorFromList.first!.rgb.b,
                                   hex: colorFromList.first!.hex)
            recognizedColor.append(model)
        }
        return colorFromList.first?.name
    }
}
