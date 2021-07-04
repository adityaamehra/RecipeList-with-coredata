//
//  ImagePicker.swift
//  Recipe List App
//
//  Created by Adityaa Mehra on 03/07/21.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var selectedSource:UIImagePickerController.SourceType
    
    @Binding var recipeImage:UIImage?
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        
        if UIImagePickerController.isSourceTypeAvailable(selectedSource){
        
        imagePickerController.sourceType = selectedSource
        }
        return imagePickerController
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Update
    }
    func makeCoordinator() -> Coordinator {
        // Make coordinator
        Coordinator(parent: self)
    }
    class Coordinator:NSObject, UINavigationControllerDelegate , UIImagePickerControllerDelegate{
        var parent: ImagePicker
        init(parent:ImagePicker){
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                // We were able to get the UIImage ito the image constant , pass it back to the add recipe view
            parent.recipeImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
