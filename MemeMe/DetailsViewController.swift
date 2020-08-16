//
//  DetailsViewController.swift
//  MemeMe
//
//  Created by Márcio Oliveira on 8/16/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, MameUpdateDelegate {

    // MARK: Outlets and properties
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    var meme: Meme!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memedImageView.image = meme.memedImage
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(showEditor)
        )
    }
    
    // MARK: Show editor and handle update
    
    @objc func showEditor() {
        performSegue(withIdentifier: "showEditor", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editorController = segue.destination as! EditorViewController
        editorController.memeUpdateDelegate = self
        editorController.memeToEdit = meme
    }
    
    func onMemeUpdated(_ meme: Meme) {
        self.memedImageView.image = meme.memedImage
        self.navigationController?.popToRootViewController(animated: true)
    }
}
