//
//  HTTPClient+Binary.swift
//  Meetville
//
//  Created by Pavel Pokalnis on 10.03.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Foundation

extension HTTPClient {
    func uploadPhoto(named _: String,
                     data: Data,
                     mimeType: String,
                     completion: @escaping (Result<UploadPhotoResponse, Error>) -> Void)
    {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "\(Constants.Transport.httpsBaseUrl)/photoupload")!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        let httpBody = NSMutableData()
        httpBody.append(convertFileData(fieldName: "file",
                                        fileName: "image",
                                        mimeType: mimeType,
                                        fileData: data,
                                        using: boundary))
        httpBody.appendString("--\(boundary)--")
        request.httpBody = httpBody as Data
        request.addValue(clientHeader, forHTTPHeaderField: "CLIENT")
        request.addValue(accessToken, forHTTPHeaderField: "ACCESSTOKEN")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                print("error. data in response is nil for type: \(UploadPhotoResponse.self)")
                completion(.failure(error!))
                return
            }
            if let error = error {
                completion(.failure(error))
                return
            }
            let dataObject = try! JSONDecoder().decode(UploadPhotoResponse.self, from: data)
            completion(.success(dataObject))
        }.resume()
    }

    private func convertFileData(fieldName: String,
                                 fileName: String,
                                 mimeType: String,
                                 fileData: Data,
                                 using boundary: String) -> Data
    {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        return data as Data
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
