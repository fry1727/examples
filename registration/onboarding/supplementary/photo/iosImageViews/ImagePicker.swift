//
//  ImagePicker.swift
//  Meetville
//
//  Created by Egor Yanukovich on 14.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var images: [PhotoModel]
    /// for now, maximum is 6
    let selectionLimit: Int

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = selectionLimit
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_: PHPickerViewController, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if results.isEmpty {
                picker.dismiss(animated: true)
            }
            // unpack the selected items
            for image in results {
                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
                        if let error = error {
                            loge("Can't load image \(error.localizedDescription)")
                        } else if let image = newImage as? UIImage {
                            // Add new image and pass it back to the main view
                            DispatchQueue.main.async {
                                self?.parent.images.append(PhotoModel(image: image, status: .loading))
                            }
                        }
                        if results.last == image {
                            DispatchQueue.main.async {
                                picker.dismiss(animated: true)
                            }
                        }
                    }
                } else {
                    loge("Can't load asset")
                }
            }
        }
    }
}
