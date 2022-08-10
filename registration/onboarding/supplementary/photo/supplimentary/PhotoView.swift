//
//  PhotoView.swift
//  Meetville
//
//  Created by Egor Yanukovich on 13.04.22.
//  Copyright © 2022 Keyou Corp. All rights reserved.
//

import SwiftUI



struct PhotoView: View {
    @ObservedObject var model: PhotoModel
    var deletePhotoAction: () -> Void
    var addPhotoAction: () -> Void

    init(state: PhotoLoadingState = .empty,
         imageUrl: String,
         addAction: @escaping (() -> Void))
    {
        model = PhotoModel(
            image: UIImage(),
            status: state,
            uploadResponse: UploadPhotoResponse(
                photoId: "",
                smallUrl: imageUrl,
                bigUrl: "",
                errors: nil
            )
        )
        deletePhotoAction = {} // unused in this case
        addPhotoAction = addAction
    }

    init(model: PhotoModel,
         deleteAction: @escaping (() -> Void),
         addAction: @escaping (() -> Void))
    {
        self.model = model
        deletePhotoAction = deleteAction
        addPhotoAction = addAction
    }

    var body: some View {
        ZStack {
            addImageView
                .opacity(model.status == .empty ? 1 : 0)
            imageView
                .opacity(model.status != .empty ? 1 : 0)
        }
    }

    private var addImageView: some View {
        Button(action: {
            addPhotoAction()
        }) {
            Image("add_circle")
                .frame(width: 31, height: 31)
                .overlay(RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(.border), lineWidth: 1)
                    .frame(width: 97, height: 97))
        }
    }

    private var imageView: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: model.uploadResponse?.smallUrl ?? "")
                .frame(width: 97, height: 97)
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(.border), lineWidth: 4)
                    .frame(width: 97, height: 97)
                    .opacity(model.status == .loaded ? 0 : 1))
            Image("remove_photo")
                .frame(width: 22, height: 22)
                .offset(x: 6, y: -6)
                .opacity(model.status == .loaded ? 1 : 0)
                .onTapGesture {
                    deletePhotoAction()
                }
        }
    }
}

private struct PhotoViewPreview: View {
    let imageUrl = "https://images.unsplash.com/photo-1519335337423-a3357c2cd12e?ixid=MnwxMjA3fDB8MHx2&q=82220"

    var body: some View {
        HStack(spacing: 10) {
            PhotoView(state: .empty, imageUrl: imageUrl) {}
            PhotoView(state: .loading, imageUrl: "") {}
            PhotoView(state: .loaded, imageUrl: imageUrl) {}
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoViewPreview()
    }
}
