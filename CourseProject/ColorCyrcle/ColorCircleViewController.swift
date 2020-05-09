//
//  ColorCyrcleViewController.swift
//  CourseProject
//
//  Created by Artem Manyshev on 30.04.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//

import UIKit

class ColorCircleViewController: UIViewController {
    
    private let tapGesture = UITapGestureRecognizer()
    private var tintGradientLayer = CAGradientLayer()
    private var colorCircleGradientLayer = CAGradientLayer()
    var chosenColor: ColorModel = ColorModel(name: "green", r: 0, g: 255, b: 0, hex: "#00FF00")
    private var colorOnTap = UIColor()
    private let tintColorCircleView = UIView()
    private var combinationMethod: CombinationMethods = .complementary
    private let colorCircleView: UIView = {
        let colorCircleView = UIView()
        return colorCircleView
    }()
    private let loupeView: UIImageView = {
        let loupeView = UIImageView()
        loupeView.image = UIImage(named: "loop")
        loupeView.layer.shadowColor = UIColor.gray.cgColor
        loupeView.layer.shadowOffset = CGSize(width: 2, height: 3)
        loupeView.layer.shadowOpacity = 0.5
        return loupeView
    }()
    private let loupeColorView: UIView = {
        let loopColorView = UIView()
        loopColorView.layer.cornerRadius = 30
        return loopColorView
    }()
    private let backView: UIView = {
        let backView = UIView()
        backView.layer.cornerRadius = 20
        backView.layer.shadowColor = UIColor.gray.cgColor
        backView.layer.shadowOpacity = 1
        backView.layer.shadowRadius = 10
        backView.layer.shadowOffset = CGSize(width: 0, height: 5)
        backView.backgroundColor = UIColor(named: DarkModeColors.blackWhiteBackColor.rawValue)
        return backView
    }()
    private var backViewHeightAnchor = NSLayoutConstraint()
    private var backViewbottomAnchor = NSLayoutConstraint()
    private let colorHexNumberLabel: UILabel = {
        let colorHexNumberLabel = UILabel()
        colorHexNumberLabel.layer.borderWidth = 1
        colorHexNumberLabel.layer.borderColor = UIColor.gray.cgColor
        colorHexNumberLabel.layer.cornerRadius = 5
        colorHexNumberLabel.textAlignment = .center
        return colorHexNumberLabel
    }()
    private let firstColorView: UIView = {
        let firstColorView = UIView()
        firstColorView.translatesAutoresizingMaskIntoConstraints = false
        return firstColorView
    }()
    private let secondColorView: UIView = {
        let secondColorView = UIView()
        secondColorView.translatesAutoresizingMaskIntoConstraints = false
        return secondColorView
    }()
    private let thirdColorView: UIView = {
        let thirdColorView = UIView()
        thirdColorView.translatesAutoresizingMaskIntoConstraints = false
        thirdColorView.isHidden = true
        return thirdColorView
    }()
    private let fourthColorView: UIView = {
        let fourthColorView = UIView()
        fourthColorView.translatesAutoresizingMaskIntoConstraints = false
        fourthColorView.isHidden = true
        return fourthColorView
    }()
    private var combinationsStack = UIStackView(arrangedSubviews: [])
    private let combinations = ["complementary", "analogous", "triadic", "tetradic"]
    private var combinationPicker = UIPickerView()
    private var pickerView: UIView = {
        let pickerView = UIView()
        pickerView.backgroundColor = UIColor(named: DarkModeColors.blackWhiteBackColor.rawValue)
        return pickerView
    }()
    private var pickerViewHeightAnchor = NSLayoutConstraint()
    private var isPickerCalled = true
    var gradientColors: [CGColor] = [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor,
                                     UIColor.green.cgColor, UIColor.cyan.cgColor, UIColor.blue.cgColor,
                                     UIColor.purple.cgColor, UIColor.systemPink.cgColor]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCombinationColorViewsGestures()
        setViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor(named:
            DarkModeColors.blackWhiteElementColor.rawValue)
    }
    @IBAction func showcombinationPicker(_ sender: Any) {
        if isPickerCalled == true {
            self.backViewbottomAnchor.constant = -200
            self.pickerViewHeightAnchor.constant = 250
        } else {
            self.backViewbottomAnchor.constant = 0
            self.pickerViewHeightAnchor.constant = 50
        }
        isPickerCalled = !isPickerCalled
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
// MARK: - segue methods
extension ColorCircleViewController {
    @objc private func colorTapped(sender: UITapGestureRecognizer) {
        guard let colorParamenters = sender.view?.backgroundColor?.cgColor.components else { return }
        chosenColor = ColorsFromFileData.shared.makeModelOfColor(Int(colorParamenters[0] * 255),
                                                                 Int(colorParamenters[1] * 255),
                                                                 Int(colorParamenters[2] * 255))
            ?? ColorModel(name: "", r: 0, g: 0, b: 0, hex: "")
        if sender.view == firstColorView {
            chosenColor.hex = colorHexNumberLabel.text ?? "" }
        performSegue(withIdentifier: SegueIdentificators.colorDetail.rawValue, sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentificators.colorDetail.rawValue {
            let destinationVC = segue.destination as? DetailColorViewController
            destinationVC?.color = chosenColor
        }
    }
}
// MARK: - UIPickerViewDelegate
extension ColorCircleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        combinations.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        combinations[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            combinationMethod = .complementary
        case 1:
            combinationMethod = .analogous
        case 2:
            combinationMethod = .triadic
        case 3:
            combinationMethod = .tetradic
        default:
            combinationMethod = .analogous
        }
        changeCombinationsColor(combinationMethod: combinationMethod, color: colorOnTap)
    }
    func changeCombination(colors: [CombinationColor]) {
        firstColorView.backgroundColor = colorOnTap
        switch colors.count {
        case 1:
            secondColorView.backgroundColor = UIColor(hue: CGFloat(colors[0].colorHue),
                                                      saturation: CGFloat(colors[0].colorSaturation),
                                                      brightness: CGFloat(colors[0].colorBrightness),
                                                      alpha: 1)
            thirdColorView.isHidden = true
            fourthColorView.isHidden = true
        case 2:
            secondColorView.backgroundColor = UIColor(hue: CGFloat(colors[0].colorHue),
                                                      saturation: CGFloat(colors[0].colorSaturation),
                                                      brightness: CGFloat(colors[0].colorBrightness),
                                                      alpha: 1)
            thirdColorView.backgroundColor = UIColor(hue: CGFloat(colors[1].colorHue),
                                                     saturation: CGFloat(colors[1].colorSaturation),
                                                     brightness: CGFloat(colors[1].colorBrightness),
                                                     alpha: 1)
            fourthColorView.isHidden = true
        case 3:
            secondColorView.backgroundColor = UIColor(hue: CGFloat(colors[0].colorHue),
                                                      saturation: CGFloat(colors[0].colorSaturation),
                                                      brightness: CGFloat(colors[0].colorBrightness),
                                                      alpha: 1)
            thirdColorView.backgroundColor = UIColor(hue: CGFloat(colors[1].colorHue),
                                                     saturation: CGFloat(colors[1].colorSaturation),
                                                     brightness: CGFloat(colors[1].colorBrightness),
                                                     alpha: 1)
            fourthColorView.backgroundColor = UIColor(hue: CGFloat(colors[2].colorHue),
                                                      saturation: CGFloat(colors[2].colorSaturation),
                                                      brightness: CGFloat(colors[2].colorBrightness),
                                                      alpha: 1)
        default:
            combinationsStack.arrangedSubviews.forEach({$0.isHidden = true})
        }
    }
    func changeCombinationsColor(combinationMethod: CombinationMethods?, color: UIColor) {
        guard let combinationMethod = combinationMethod,
            let hsb = color.getHSB() else {
                combinationsStack.arrangedSubviews.forEach({$0.isHidden = true}); return }
        combinationsStack.arrangedSubviews.forEach({$0.isHidden = false})
        let colorCombinations = Combinations(originalColorHue: hsb.hue,
                                             originalColorSaturation: hsb.saturation,
                                             originslColorBrightness: hsb.brightness)
        switch combinationMethod {
        case .complementary:
            changeCombination(colors: colorCombinations.combination(type: .complementary))
        case .triadic:
            changeCombination(colors: colorCombinations.combination(type: .triadic))
        case .tetradic:
            changeCombination(colors: colorCombinations.combination(type: .tetradic))
        case .analogous:
            changeCombination(colors: colorCombinations.combination(type: .analogous))
        }
    }
}
// MARK: - visual methods
extension ColorCircleViewController {
    private func setViews() {
        setViewsLayouts()
        navigationController?.navigationBar.isHidden = false
        colorOnTap = UIColor(red: chosenColor.r, green: chosenColor.g, blue: chosenColor.b, alpha: 1)
        colorHexNumberLabel.text = chosenColor.hex
        colorHexNumberLabel.textColor = colorOnTap
        view.backgroundColor = colorOnTap
        changeCombinationsColor(combinationMethod: combinationMethod, color: colorOnTap)
        tapGesture.addTarget(self, action: #selector(colorTapped(sender:)))
        tintGradientLayer = makeGradientLayerWith(width: UIScreen.main.bounds.width * 0.8,
                                                  height: UIScreen.main.bounds.width * 0.8,
                                                  colors: [UIColor.black.cgColor,
                                                           UIColor(red: chosenColor.r,
                                                                   green: chosenColor.g,
                                                                   blue: chosenColor.b,
                                                                   alpha: 1).cgColor, UIColor.white.cgColor],
                                                  cornerRadius: UIScreen.main.bounds.width * 0.4)
        tintColorCircleView.layer.insertSublayer(tintGradientLayer, at: 0)
        colorCircleGradientLayer = makeGradientLayerWith(width: UIScreen.main.bounds.width * 0.8 - 30,
                                                         height: UIScreen.main.bounds.width * 0.8 - 30,
                                                         colors: gradientColors,
                                                         gradientType: .conic,
                                                         cornerRadius: (UIScreen.main.bounds.width * 0.4 - 15),
                                                         borderWidth: 10, borderColor: UIColor.white.cgColor)
        colorCircleView.layer.insertSublayer(colorCircleGradientLayer, at: 0)
        combinationsStack.addArrangedSubview(firstColorView)
        combinationsStack.addArrangedSubview(secondColorView)
        combinationsStack.addArrangedSubview(thirdColorView)
        combinationsStack.addArrangedSubview(fourthColorView)
        combinationsStack.axis = .horizontal
        combinationsStack.alignment = .fill
        combinationsStack.distribution = .fillEqually
        combinationsStack.spacing = 5
        combinationPicker.delegate = self
        combinationPicker.dataSource = self
    }
    private func setViewsLayouts() {
        setConstraintsOn(view: pickerView, parantView: view, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0)
        pickerViewHeightAnchor = pickerView.heightAnchor.constraint(equalToConstant: 50)
        pickerViewHeightAnchor.isActive = true
        setConstraintsOn(view: backView, parantView: view,
                         height: UIScreen.main.bounds.height * 0.85, leadingConstant: 0,
                         bottomConstant: 0,
                         trailingConstant: 0)
        backViewbottomAnchor = backView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        backViewbottomAnchor.isActive = true
        setConstraintsOn(view: tintColorCircleView, parantView: backView,
                         height: UIScreen.main.bounds.width * 0.8,
                         width: UIScreen.main.bounds.width * 0.8,
                         topConstant: 30, centeringxConstant: 0)
        setConstraintsOn(view: colorCircleView,
                         parantView: tintColorCircleView,
                         height: UIScreen.main.bounds.width * 0.8 - 30,
                         width: UIScreen.main.bounds.width * 0.8 - 30, centeringxConstant: 0,
                         centeringyConstant: 0)
        setConstraintsOn(view: colorHexNumberLabel, parantView: backView, height: 50, leadingConstant: 30, trailingConstant: -30)
        colorHexNumberLabel.topAnchor.constraint(equalTo: tintColorCircleView.bottomAnchor,
                                                 constant: 10).isActive = true
        setConstraintsOn(view: loupeView, parantView: view, manualConstraints: false)
        setConstraintsOn(view: loupeColorView, parantView: loupeView,
                         height: 60, width: 60, centeringxConstant: 0, centeringyConstant: -16)
        setConstraintsOn(view: combinationsStack, parantView: backView, height: 30,
                         leadingConstant: 30, trailingConstant: -30)
        combinationsStack.topAnchor.constraint(equalTo: colorHexNumberLabel.bottomAnchor,
                                               constant: 10).isActive = true
        setConstraintsOn(view: combinationPicker, parantView: pickerView, leadingConstant: 30,
                         trailingConstant: -30, centeringxConstant: 0)
    }
}
// MARK: - gestures methods
extension ColorCircleViewController {
    private func setCombinationColorViewsGestures() {
        setTapGestureFor(colorView: firstColorView)
        setTapGestureFor(colorView: secondColorView)
        setTapGestureFor(colorView: thirdColorView)
        setTapGestureFor(colorView: fourthColorView)
    }
    private func setTapGestureFor(colorView: UIView) {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(colorTapped(sender:)))
        colorView.addGestureRecognizer(gesture)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let firstLocation = touches.first?.location(in: self.view),
            let colorCircleLocation = touches.first?.location(in: colorCircleView),
            let tintColorCircleLocation = touches.first?.location(in: tintColorCircleView) else { return }
        selectColorOn(locationOnMainView: firstLocation,
                      locationOnColorCircle: colorCircleLocation,
                      locationOnTintLine: tintColorCircleLocation)
        changeCombinationsColor(combinationMethod: combinationMethod, color: colorOnTap)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let destinationLocation = touches.first?.location(in: self.view),
            let colorLocation = touches.first?.location(in: colorCircleView),
            let tintColorCircleLocation = touches.first?.location(in: tintColorCircleView) else { return }
        selectColorOn(locationOnMainView: destinationLocation,
                      locationOnColorCircle: colorLocation,
                      locationOnTintLine: tintColorCircleLocation)
        changeCombinationsColor(combinationMethod: combinationMethod, color: colorOnTap)
    }
    private func selectColorOn(locationOnMainView: CGPoint,
                               locationOnColorCircle: CGPoint,
                               locationOnTintLine: CGPoint) {
        loupeView.isHidden = false
        if !outOfColor(location: locationOnColorCircle, view: colorCircleView, borderSize: 10) {
            setViewsColor(mainLocation: locationOnMainView,
                          secondaryLocation: locationOnColorCircle,
                          isOnColorCircle: true)
            colorHexNumberLabel.text = setHexLabelValue(from: colorCircleView, at: locationOnColorCircle)?.uppercased()
        }
        if !outOfColor(location: locationOnTintLine, view: tintColorCircleView, borderSize: 0) {
            setViewsColor(mainLocation: locationOnMainView,
                          secondaryLocation: locationOnTintLine,
                          isOnColorCircle: false)
            colorHexNumberLabel.text = setHexLabelValue(from: tintColorCircleView, at: locationOnTintLine)?.uppercased()
        } else {
            loupeView.isHidden = true
        }
    }
    private func outOfColor(location: CGPoint, view: UIView, borderSize: CGFloat) -> Bool {
        pow((location.x / (view.bounds.width - (2 * borderSize))) - 0.5, 2) + pow((location.y / (view.bounds.width - (borderSize))) - 0.5, 2) >= 0.25
    }
    private func setViewsColor(mainLocation: CGPoint,
                               secondaryLocation: CGPoint,
                               isOnColorCircle: Bool) {
        loupeView.frame = CGRect(x: mainLocation.x - 39,
                                 y: mainLocation.y - 110,
                                 width: 78, height: 110)
        self.colorOnTap = self.tintColorCircleView.getPixelColorAt(point: secondaryLocation)
        loupeColorView.backgroundColor = colorOnTap
        view.backgroundColor = colorOnTap
        colorHexNumberLabel.textColor = colorOnTap
        if isOnColorCircle { tintGradientLayer.colors = [UIColor.black.cgColor,
                                                         colorOnTap.cgColor,
                                                         UIColor.white.cgColor] }
    }
    private func setHexLabelValue(from view: UIView, at point: CGPoint) -> String? {
        view.getPixelColorAt(point: point).getHEX()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.loupeView.isHidden = true
        guard let lastColorCircleLocation = touches.first?.location(in: colorCircleView),
            let lastColorTintLocation = touches.first?.location(in: tintColorCircleView) else { return }
        if !outOfColor(location: lastColorCircleLocation, view: colorCircleView, borderSize: 10) {
            colorHexNumberLabel.text = setHexLabelValue(from: colorCircleView, at: lastColorCircleLocation)?.uppercased()
        } else {
            if !outOfColor(location: lastColorTintLocation, view: tintColorCircleView, borderSize: 0) {
                colorHexNumberLabel.text = setHexLabelValue(from: tintColorCircleView, at: lastColorTintLocation)?.uppercased()
            }
        }
    }
}
