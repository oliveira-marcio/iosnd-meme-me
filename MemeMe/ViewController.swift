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

    enum DefaultLabels: String {
        case top = "TOP"
        case bottom = "BOTTOM"
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabel(self.topTextField, text: .top)
        setLabel(self.bottomTextField, text: .bottom)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.albumButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    // MARK: Label Appearence and Delegate Methods
    
    private func setLabel(_ textField: UITextField, text: DefaultLabels) {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -2.0
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text.rawValue

        textField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // TODO: keyboard should not overlap textview
        let currentText = textField.text!.uppercased() as String
        if (currentText == DefaultLabels.top.rawValue || currentText == DefaultLabels.bottom.rawValue) {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        textField.text = newText.uppercased
        return false
    }
    
    // MARK: Image Picking and Delegate Methods

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
            self.topTextField.text = DefaultLabels.top.rawValue
            self.bottomTextField.text = DefaultLabels.bottom.rawValue
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

