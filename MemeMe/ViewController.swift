//
//  ViewController.swift
//  MemeMe
//
//  Created by Márcio Oliveira on 8/6/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var albumItem: UIBarButtonItem!
    @IBOutlet weak var cameraItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.albumItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        self.cameraItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
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
    
}

