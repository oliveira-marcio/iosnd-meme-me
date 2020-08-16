//
//  ViewController.swift
//  MemeMe
//
//  Created by Márcio Oliveira on 8/6/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit
import AVFoundation

protocol RefreshDataDelegate {
    func refreshData()
}

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    enum DefaultLabels: String {
        case top = "TOP"
        case bottom = "BOTTOM"
    }
    
    var refreshDataDelegate: RefreshDataDelegate?
    
    // MARK: Outlets
    
    @IBOutlet weak var shareToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var photoToolbar: UIToolbar!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shareButton.isEnabled = false
        setLabel(self.topTextField, text: .top)
        setLabel(self.bottomTextField, text: .bottom)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.albumButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyboardNotifications()
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
        textField.adjustsFontSizeToFitWidth = true
        textField.text = text.rawValue

        textField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
            self.shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Keyboard events subscription
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if self.bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Meme Generation

    private func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return cropMemedImage(memedImage)
    }
    
    private func cropMemedImage(_ image: UIImage) -> UIImage {
        var topbarHeight: CGFloat {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
               
        let cropRect = CGRect(
            x: 0.0,
            y: shareToolbar.frame.height + topbarHeight,
            width: self.view.frame.width,
            height: self.view.frame.height - shareToolbar.frame.height - photoToolbar.frame.height - topbarHeight
        )
       
        let croppedCGImage:CGImage = (image.cgImage?.cropping(to: cropRect))!
        return UIImage(cgImage: croppedCGImage)
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Meme Sharing
    
    @IBAction func shareMeme(_ sender: Any) {
        if let originalImage = imagePickerView.image {
            let memedImage = self.generateMemedImage()
            
            let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            activityController.completionWithItemsHandler = { (_, completed, _, _) in
                if (completed) {
                    self.saveMeme(
                        topLabel: self.topTextField.text ?? "",
                        bottomLabel: self.bottomTextField.text ?? "",
                        originalImage: originalImage,
                        memedImage: memedImage
                    )
                }
            }
            
            self.present(activityController, animated: true, completion: nil)
        } else {
            showAlert("Oops", message: "Something went wrong. Please try again.")
        }
    }
    
    private func saveMeme(topLabel: String, bottomLabel: String, originalImage: UIImage, memedImage: UIImage) {
        let savedMeme = Meme(
            topText: topLabel,
            bottomText: bottomLabel,
            originalImage: originalImage,
            memedImage: memedImage
        )
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(savedMeme)
        
        refreshDataDelegate?.refreshData()
        print("Memes saved: \(appDelegate.memes)")
    }
    
    private func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
