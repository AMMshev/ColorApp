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
    
    var allColors: [ColorList] = []
    var sourceImage: UIImage?
    
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
                    var rForRGB: [Int] = []
                    var bForRGB: [Int] = []
                    var gForRGB: [Int] = []
                    json.result.colors.image_colors.forEach({rForRGB.append($0.r)})
                    json.result.colors.image_colors.forEach({gForRGB.append($0.g)})
                    json.result.colors.image_colors.forEach({bForRGB.append($0.b)})
                    DispatchQueue.main.sync {
                        self.mainColor.backgroundColor = UIColor(red: rForRGB[0],
                                                                 green: gForRGB[0],
                                                                 blue: bForRGB[0],
                                                                 alpha: 1)
                        self.secondaryColor.backgroundColor = UIColor(red: rForRGB[1],
                                                                      green: gForRGB[1],
                                                                      blue: bForRGB[1],
                                                                      alpha: 1)
                        self.additionalColor.backgroundColor = UIColor(red: rForRGB[2],
                                                                       green: gForRGB[2],
                                                                       blue: bForRGB[2],
                                                                       alpha: 1)
                        self.mainColor.setNeedsDisplay()
                        self.secondaryColor.setNeedsDisplay()
                        self.additionalColor.setNeedsDisplay()
                        
                        self.mainColorNameLabel.text = self.searchColorName(rForRGB[0], gForRGB[0], bForRGB[0])
//                        self.secondaryColorName.text = self.searchColorName(rForRGB[1], gForRGB[1], bForRGB[1])
//                        self.additionalColorName.text = self.searchColorName(rForRGB[2], gForRGB[2], bForRGB[2])
                    }
                } catch {
                    print("JSON error")
                }
            })
        })
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
        return colorFromList.first?.name
    }
}
