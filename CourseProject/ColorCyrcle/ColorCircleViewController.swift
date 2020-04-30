//
//  ColorCyrcleViewController.swift
//  CourseProject
//
//  Created by Artem Manyshev on 30.04.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//

import UIKit

class ColorCircleViewController: UIViewController {
    
    let tapGesture = UITapGestureRecognizer()
    let colorCircleView: ChoosingColorImageView = {
        let colorCircleView = ChoosingColorImageView()
        colorCircleView.translatesAutoresizingMaskIntoConstraints = false
        colorCircleView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        colorCircleView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        colorCircleView.image = UIImage(named: "colorCircle")?.resizedImage(for:
            CGSize(width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.width))
        return colorCircleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        view.addSubview(colorCircleView)
        colorCircleView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        colorCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        colorCircleView.isUserInteractionEnabled = true
        tapGesture.addTarget(self, action: #selector(chosenColorTapped))
        colorCircleView.chosingColorView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor(named: "navBarColor")
    }
    
    @objc func chosenColorTapped() {
        colorCircleView.chosingColorImageView.isHidden = true
        self.performSegue(withIdentifier: "showColorDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? DetailColorViewController
        destinationVC?.color = colorCircleView.chosenColor
    }
}

class ChoosingColorImageView: UIImageView {
    
    var chosingColorView: UIView = {
        let chosingColorView = UIView()
        chosingColorView.translatesAutoresizingMaskIntoConstraints = false
        chosingColorView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        chosingColorView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        chosingColorView.layer.cornerRadius = 30
        chosingColorView.isUserInteractionEnabled = true
        return chosingColorView
    }()
    
    var chosingColorImageView: UIImageView = {
        let chosingColorImageView = UIImageView()
        chosingColorImageView.isUserInteractionEnabled = true
        chosingColorImageView.image = UIImage(named: "loop")
        chosingColorImageView.layer.shadowColor = UIColor.gray.cgColor
        chosingColorImageView.layer.shadowOffset = CGSize(width: 2, height: 3)
        chosingColorImageView.layer.shadowOpacity = 0.5
        return chosingColorImageView
    }()
    var chosenColor: ColorModel = ColorModel(name: "", r: 0, g: 0, b: 0, hex: "")
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let originalTouch = touches.first?.location(in: self) else { return }
        chosingColorImageView.isHidden = false
        self.bringSubviewToFront(chosingColorImageView)
        chosingColorImageView.bringSubviewToFront(chosingColorView)
        chosingColorImageView.frame = CGRect(x: originalTouch.x - 39,
                                             y: originalTouch.y - 110,
                                             width: 78,
                                             height: 110)
        chosingColorImageView.addSubview(chosingColorView)
        chosingColorView.centerYAnchor.constraint(equalTo: chosingColorImageView.centerYAnchor, constant: -16).isActive = true
        chosingColorView.centerXAnchor.constraint(equalTo: chosingColorImageView.centerXAnchor).isActive = true
        chosingColorView.backgroundColor = self.image?.getPixelColor(pos: originalTouch)
        self.addSubview(chosingColorImageView)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let destinationLocation = touches.first?.location(in: self) else { return }
        if destinationLocation.x / UIScreen.main.bounds.width < 1 &&
            destinationLocation.y / UIScreen.main.bounds.width < 1 &&
            destinationLocation.x / UIScreen.main.bounds.width > 0 &&
            destinationLocation.y / UIScreen.main.bounds.width > 0 {
            chosingColorImageView.frame = CGRect(x: destinationLocation.x - 39,
                                                 y: destinationLocation.y - 110,
                                                 width: 78,
                                                 height: 110)
            chosingColorView.backgroundColor = self.image?.getPixelColor(pos: destinationLocation) ?? UIColor.white
        } else {
            chosingColorImageView.isHidden = true
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let lastLocation = touches.first?.location(in: self),
            let color = self.image?.getPixelColor(pos: lastLocation).cgColor.components else { return }
        chosenColor = ColorsFromFileData.shared.makeModelOfColor(Int(color[0] * 255),
                                                                 Int(color[1] * 255),
                                                                 Int(color[2] * 255)) ?? ColorModel(name: "",
                                                                                                    r: 0,
                                                                                                    g: 0,
                                                                                                    b: 0,
                                                                                                    hex: "")
    }
}
