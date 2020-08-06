//
//  ViewController.swift
//  MemeMe
//
//  Created by Márcio Oliveira on 8/6/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        // TODO: Text should approximate the "Impact" font, all caps, white with a black outline.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.albumButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        self.pickAnImage(from: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                self.pickAnImage(from: .camera)
                
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.pickAnImage(from: .camera)
                    }
                }
                
            case .denied:
                return
                
            case .restricted:
                return
                
            @unknown default:
                return
        }
    }
    
    private func pickAnImage(from sourceType: UIImagePickerController.SourceType) {
        let pickController = UIImagePickerController()
        pickController.delegate = self
        pickController.sourceType = sourceType
        present(pickController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // TODO: keyboard should not overlap textview
        // TODO: should remove only default values
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

