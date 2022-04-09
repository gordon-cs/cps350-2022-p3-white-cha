//
//  ImageSelect.swift
//  P3
//
//  Created by Amos Cha on 4/2/22.
//

import Foundation
import SwiftUI

struct ImageSelect: UIViewControllerRepresentable {

    /*
     using @Binding tag to allow for reference to be based in photo library
     */
    @Binding var image: UIImage?

    private let controller = UIImagePickerController()

    
    
    /*
     Coordinator class allows for object to be monitored
     Utilizes Controller and Cancel sub functions
     */
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        let parent: ImageSelect

        init(parent: ImageSelect) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }

    }

    func makeUIViewController(context: Context) -> some UIViewController {
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }

}
