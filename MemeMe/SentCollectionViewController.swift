//
//  SentCollectionViewController.swift
//  MemeMe
//
//  Created by Márcio Oliveira on 8/15/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class SentCollectionViewController: UICollectionViewController {
    
    var memes = [Meme]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        self.memes = appDelegate.memes
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        print(self.memes[indexPath.row])
    }
}
