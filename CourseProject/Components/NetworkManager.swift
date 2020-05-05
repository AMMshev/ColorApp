//
//  NetworkManager.swift
//  CourseProject
//
//  Created by Artem Manyshev on 30.03.2020.
//  Copyright © 2020 Артем Манышев. All rights reserved.
//
//swiftlint:disable identifier_name

import UIKit

class Networking {
    static let shared = Networking()
//    let ClientID = "97fb096aa24f64d"
    
    func getBase64Image(image: UIImage) -> String {
        let imageData = image.jpegData(compressionQuality: 0.0)
        guard let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters) else { return "" }
        return base64Image
    }
    // MARK: - upload image to imgur.com
    func uploadData(image: UIImage, completion: @escaping (String?) -> Void) {
        let base64Image = getBase64Image(image: image)
        let boundary = "Boundary-\(UUID().uuidString)"
        guard let url = URL(string: NetworkParameters.uploadURL.rawValue) else {return}
        var request = URLRequest(url: url)
        request.addValue("Client-ID \(NetworkParameters.clientID.rawValue)", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        var body = ""
        body += "--\(boundary)\r\n"
        body += "Content-Disposition:form-data; name=\"image\""
        body += "\r\n\r\n\(base64Image )\r\n"
        body += "--\(boundary)--\r\n"
        let postData = body.data(using: .utf8)
        
        request.httpBody = postData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print("server error")
                    return
            }
            guard let data = data else {return}
            do {
                let json = try JSONDecoder().decode(AnswerJson.self, from: data)
                
                completion(json.data.link)
            } catch {
                print(error)
            }
        }.resume()
    }
    // MARK: - sending a link of image on imgur.com to imagga.com and receiving colors
    func getData(imageLink: String, completion: @escaping (Data) -> Void) {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization": NetworkParameters.downloadAuthorisation.rawValue]
        let session = URLSession(configuration: config)
        guard let url = URL(string: NetworkParameters.downloadURL.rawValue + imageLink) else {return}
        session.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            completion(data)
            guard let response = response as? HTTPURLResponse else {
                print("server error")
                return
            }
            print(response.statusCode)
        }.resume()
    }
}
// MARK: - json structure of response from imgur.com
struct AnswerJson: Codable {
    let data: LinkToImage
}
struct LinkToImage: Codable {
    let link: String
}
// MARK: - json structure of response from imagga.com
struct JSONAnswer: Codable {
    let result: Result
}
struct Result: Codable {
    let colors: ColorsList
}
struct ColorsList: Codable {
    let background_colors: [ColorData]
    let foreground_colors: [ColorData]
    let image_colors: [ColorData]
}
struct ColorData: Codable {
    let b: Int
    let g: Int
    let r: Int
    let html_code: String
}
