//
//  ViewController.swift
//  MemeMe
//
//  Created by Márcio Oliveira on 8/6/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imagePickerView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pickAnImage(_ sender: Any) {
        let pickController = UIImagePickerController()
        present(pickController, animated: true, completion: nil)
    }
    
}

