//
//  MainViewController.swift
//  CourseProject
//
//  Created by Артем Манышев on 23.03.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
import UIKit

class MainViewController: UIViewController {
    
    static let backgroundColorArray: [UIColor] =
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
    static let backgroundColorNumber: Int = {
        let number = Int(arc4random_uniform(9))
        return number
    }()
    private let appLogo: UIImageView = {
        let appLogo = UIImageView()
        guard let appLogoImage = UIImage(named: "logo2") else {fatalError("No such logo image")}
        appLogo.image = appLogoImage
        return appLogo
    }()
    private let color: UIButton = {
        let color = UIButton()
        color.setTitle("Colors", for: .normal)
        color.setTitleColor(UIColor(named: DarkModeColors.blackWhiteBackColor.rawValue), for: .normal)
        color.titleLabel?.font = color.titleLabel?.font.withSize(CGFloat(30))
        color.addTarget(self, action: #selector(showColorList), for: .touchUpInside)
        return color
    }()
    private let images: UIButton = {
        let images = UIButton()
        images.setTitle("Images", for: .normal)
        images.setTitleColor(UIColor(named: DarkModeColors.blackWhiteBackColor.rawValue), for: .normal)
        images.titleLabel?.font = images.titleLabel?.font.withSize(CGFloat(30))
        images.addTarget(self, action: #selector(openPhotoLibrary), for: .touchUpInside)
        return images
    }()
    private let colorCircle: UIButton = {
        let colorCircle = UIButton()
        colorCircle.setTitle("Color circle", for: .normal)
        colorCircle.setTitleColor(UIColor(named: DarkModeColors.blackWhiteBackColor.rawValue), for: .normal)
        colorCircle.titleLabel?.font = colorCircle.titleLabel?.font.withSize(CGFloat(30))
        colorCircle.addTarget(self, action: #selector(showColorCircle), for: .touchUpInside)
        return colorCircle
    }()
    private let userProfile: UIButton = {
        let userProfile = UIButton()
        userProfile.setBackgroundImage(UIImage(named: "userProfile"), for: .normal)
        userProfile.heightAnchor.constraint(equalToConstant: 30).isActive = true
        userProfile.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return userProfile
    }()
    private let camera: UIButton = {
        let camera = UIButton()
        camera.setBackgroundImage(UIImage(named: "camera"), for: .normal)
        camera.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        return camera
    }()
    private var colorCenterConstraint = NSLayoutConstraint()
    private var imagesCenterConstraint = NSLayoutConstraint()
    private var colorCircleCenterConstraint = NSLayoutConstraint()
    private var imageFromPicker: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupViews()
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
    @objc func showColorList() {
        self.performSegue(withIdentifier: SegueIdentificators.colorList.rawValue, sender: nil)
    }
    @objc func showColorCircle() {
        self.performSegue(withIdentifier: SegueIdentificators.colorCircle.rawValue, sender: nil)
    }
}
// MARK: - UIImagePickerController
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func openCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.modalPresentationStyle = .fullScreen
        self.present(cameraPicker, animated: true, completion: nil)
    }
    @objc func openPhotoLibrary() {
        let galeryPicker = UIImagePickerController()
        galeryPicker.delegate = self
        galeryPicker.sourceType = .photoLibrary
        galeryPicker.modalPresentationStyle = .fullScreen
        self.present(galeryPicker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        DispatchQueue.global(qos: .utility).async {        
            guard let imageFromCamera = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
            self.imageFromPicker = imageFromCamera
        }
        picker.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: SegueIdentificators.threeColors.rawValue, sender: nil)
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? ThreeColorsViewController
        guard let imageFromPicker = imageFromPicker else { return }
        destinationVC?.sourceImage = imageFromPicker
    }
}
// MARK: - visual methods
extension MainViewController {
    private func setupViews() {
        view.backgroundColor = MainViewController.backgroundColorArray[MainViewController.backgroundColorNumber]
        setConstraintsOn(view: appLogo, parantView: view, leadingConstant: 20, centeringyConstant: 0)
        setConstraintsOn(view: color, parantView: view)
        setConstraintsOn(view: images, parantView: view)
        setConstraintsOn(view: colorCircle, parantView: view)
        setConstraintsOn(view: userProfile, parantView: view, topConstant: 80, trailingConstant: -50)
        setConstraintsOn(view: camera, parantView: view, leadingConstant: 20)
        colorCenterConstraint = color.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        colorCenterConstraint.isActive = true
        color.topAnchor.constraint(equalTo: appLogo.bottomAnchor, constant: 40).isActive = true
        imagesCenterConstraint = images.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50)
        imagesCenterConstraint.isActive = true
        images.topAnchor.constraint(equalTo: color.bottomAnchor, constant: 10).isActive = true
        colorCircleCenterConstraint = colorCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100)
        colorCircleCenterConstraint.isActive = true
        colorCircle.topAnchor.constraint(equalTo: images.bottomAnchor, constant: 10).isActive = true
        camera.topAnchor.constraint(equalTo: colorCircle.bottomAnchor, constant: 20).isActive = true
    }
}
