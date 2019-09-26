//
//  AddPostVC.swift
//  grio-test
//
//  Created by Glauco Valdes on 9/26/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//

import UIKit
import Photos

class AddPostVC: UIViewController {
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var messageText: UITextView!
    
    let placeHolderText = "Add message ..."
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.messageText.delegate = self
        self.messageText.text = placeHolderText
        self.messageText.textColor = UIColor.lightGray
        
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem  = saveButton
        
        self.title = "Add a posts"
        
        self.selectedImage.image = self.selectedImage.image?.withRenderingMode(.alwaysTemplate)
        self.selectedImage.tintColor = UIColor.gray
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(clickImage))
        self.selectedImage.isUserInteractionEnabled = true
        self.selectedImage.addGestureRecognizer(tapImage)
    }
    
    @objc func clickImage() {
        self.showImageSelector()
    }
    
    @IBAction func chooseClicked(_ sender: Any) {
        
        self.showImageSelector()
    }
    @objc func save(){
        self.navigationController?.popViewController(animated: true)
    }
    
    var imagePicker : UIImagePickerController = UIImagePickerController()
    func showImageSelector(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch status {
            case .authorized:
                self.showCamera()
            case .denied, .restricted : self.openSettings()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        self.showCamera()
                    case .denied, .restricted: self.openSettings()
                    case .notDetermined: self.openSettings()
                    @unknown default:
                        self.openSettings()
                    }
                    
                }
            @unknown default:
                self.openSettings()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                self.showGallery()
            case .denied, .restricted : self.openSettings()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        self.showGallery()
                    case .denied, .restricted: self.openSettings()
                    case .notDetermined: self.openSettings()
                    @unknown default:
                        self.openSettings()
                    }
                    
                }
            @unknown default:
                self.openSettings()
            }
            
        }
            )
        )
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }
   
    func showCamera(){
        self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
        self.imagePicker.allowsEditing = true
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    func showGallery(){
        self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.imagePicker.allowsEditing = true
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func openSettings()
    {
        
        let alert = UIAlertController(title: "Grio needs permissions", message: "Open settings", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {_ in
            if let url = URL(string:UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension AddPostVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.selectedImage.image = editedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddPostVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if self.messageText.textColor == UIColor.lightGray {
            self.messageText.text = ""
            self.messageText.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if self.messageText.text == "" {
            
            self.messageText.text = placeHolderText
            self.messageText.textColor = UIColor.lightGray
        }
    }
}
