//
//  DetailsViewController.swift
//  MemeMe
//
//  Created by Márcio Oliveira on 8/16/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var memedImageView: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memedImageView.image = meme.memedImage
    }

}
