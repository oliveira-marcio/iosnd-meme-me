//
//  SentCollectionViewController.swift
//  MemeMe
//
//  Created by Márcio Oliveira on 8/15/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class SentCollectionViewController: UICollectionViewController, RefreshDataDelegate {
    
    // MARK: - Outlets and Models
    
    @IBOutlet weak var sentMemeCollectionView: UICollectionView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    // MARK: - Refresh Data Delegate
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editorController = segue.destination as! EditorViewController
        editorController.refreshDataDelegate = self
    }

    func refreshData() {
        self.sentMemeCollectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshData()
    }
    
    // MARK: Collection View Data Source

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
