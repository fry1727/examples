//
//  TakePhotoView.swift
//  Meetville
//
//  Created by Egor Yanukovich on 14.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI
import UIKit

struct TakePhotoView: UIViewControllerRepresentable {
    @Binding var images: [PhotoModel]

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var picker: TakePhotoView

        init(picker: TakePhotoView) {
            self.picker = picker
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            picker.dismiss(animated: true)
            guard let image = info[.originalImage] as? UIImage else { return }
            self.picker.images.append(PhotoModel(image: image, status: .loading))
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_: UIImagePickerController, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}
