//
//  uploadAPI.swift
//  Screenshot-upload-tool
//
//  Created by Andreas Jensen Jonassen on 18.02.2019.
//  Copyright © 2019 Andreas Jensen Jonassen. All rights reserved.
//

import Foundation
import AppKit

class UploadAPI {
    
    func uploadImage(rawImage: NSImage, type: String, name: String, url: URL, arguments: [String : String], fileFormName: String) {

        let boundary = generateBoundary()
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = setData(arguments: arguments, type: type, fileName: name,fileFormName: fileFormName, boundary: boundary, img: rawImage)
        
        let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request) {
            (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
            guard let imageURL = response?.url else {
                //TODO??
                print("Something went wrong. No picture link was given in the response.")
                return
            }
            print(imageURL.absoluteString)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(imageURL.absoluteString, forType: NSPasteboard.PasteboardType.string)
        }
        task.resume()
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func setData(arguments: [String: String], type: String, fileName: String, fileFormName: String , boundary: String, img: NSImage) -> Data {
        var data = Data()
        
        for argument in arguments {
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(argument.key)\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(argument.value)".data(using: .utf8)!)
        }
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fileFormName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/\(type)\r\n\r\n".data(using: .utf8)!)
        let cgImgRef = img.cgImage(forProposedRect: nil, context: nil, hints: nil)
        let bmpImgRef = NSBitmapImageRep(cgImage: cgImgRef!)
        var fileType: NSBitmapImageRep.FileType
        switch type {
        case "png":
            fileType = NSBitmapImageRep.FileType.png
            break;
        case "jpg":
            fileType = NSBitmapImageRep.FileType.jpeg
            break;
        case "jpeg":
            fileType = NSBitmapImageRep.FileType.jpeg
            break;
        case "gif":
            fileType = NSBitmapImageRep.FileType.gif
            break;
        case "tiff":
            fileType = NSBitmapImageRep.FileType.tiff
            break;
        default:
            fileType = NSBitmapImageRep.FileType.png
        }
        let pngData = bmpImgRef.representation(using: fileType, properties: [:])
        data.append(pngData!)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        return data
    }

}
