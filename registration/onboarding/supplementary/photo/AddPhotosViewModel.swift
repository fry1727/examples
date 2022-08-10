//
//  AddPhotosViewModel.swift
//  Meetville
//
//  Created by Egor Yanukovich on 14.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

final class AddPhotosViewModel: ObservableObject {
    var onPhotoAdded: (() -> Void)?
    var cancellables = [AnyCancellable]()
    @Published var photoModel: [PhotoModel] = [] {
        didSet {
            if !startedSelection {
                startedSelection = true
            }
        }
    }

    @Published var startedSelection = false

    private let photoQueue: DispatchQueue = .init(label: "PhotoQueue", attributes: .concurrent)
    private let semaphore = DispatchSemaphore(value: 1)

    init() {
        $photoModel.sink { photoModel in
            for model in photoModel where model.uploadResponse == nil && model.status == .loading && !model.startedLoading {
                self.photoQueue.async {
                    self.semaphore.wait()
                    guard let photo = photoModel.first(where: { $0.uploadResponse == nil && model.status == .loading && !model.startedLoading }) else { self.semaphore.signal()
                        return
                    }
                    self.uploadPhoto(photoModel: photo) {
                        self.semaphore.signal()
                    }
                }
            }
        }.store(in: &cancellables)
    }

    private func uploadPhoto(photoModel: PhotoModel, _ callback: @escaping () -> Void) {
        photoModel.startedLoading = true
        let resizedImage = photoModel.image.resizeImage()
        guard let imageData = resizedImage.compressImage() else {
            callback()
            return
        }
        HTTPClient.shared.uploadPhoto(
            named: photoModel.image.description,
            data: imageData,
            mimeType: "image/jpeg"
        ) { [weak self] result in
            switch result {
            case let .success(response):
                DispatchQueue.main.async {
                    if let error = response.errors?.first,
                       let index = self?.photoModel.firstIndex(where: { $0.image === photoModel.image })
                    {
                        self?.photoModel.remove(at: index)
                        loge("\(error.key ?? "") \(error.msg)")
                    } else {
                        photoModel.status = .loaded
                        photoModel.uploadResponse = response
                        self?.onPhotoAdded?()
                    }
                    callback()
                }
            case let .failure(error):
                loge(error)
                callback()
            }
        }
    }

    func deletePhoto(photoID: String) {
        guard let index = photoModel.firstIndex(where: { $0.uploadResponse?.photoId ?? "" == photoID }) else { return }
        HTTPClient.shared.request(query: RemovePhotoQuery(request: .init(photoId: photoID))) { [weak self] result in
            switch result {
            case let .success(response):
                guard response.errorMessage == nil else { return }
                self?.photoModel.remove(at: index)
            case let .failure(error):
                loge(error.localizedDescription)
            }
        }
    }
}

enum PhotoRuleType {
    case accepted
    case declined

    var color: Color {
        switch self {
        case .accepted:
            return Color(.acceptedGreen)
        case .declined:
            return Color(.declinedRed)
        }
    }

    var imageMark: String {
        switch self {
        case .accepted:
            return "photoAccepted"
        case .declined:
            return "photoDeclined"
        }
    }
}

enum PhotoLoadingState {
    case loading
    case loaded
    case empty
}

final class PhotoModel: ObservableObject {
    var image: UIImage
    @Published var status: PhotoLoadingState = .empty
    @Published var uploadResponse: UploadPhotoResponse?
    var startedLoading = false

    init(image: UIImage,
         status: PhotoLoadingState = .empty,
         uploadResponse: UploadPhotoResponse? = nil)
    {
        self.image = image
        self.status = status
        self.uploadResponse = uploadResponse
    }
}
