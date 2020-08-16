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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
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
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        computeFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        computeFlowLayout()
    }
    
    // MARK: - Compute correct flow layout span count
        
    func computeFlowLayout() {
        let space: CGFloat = 2.0
        
        let isPortrait = UIDevice.current.orientation.isValidInterfaceOrientation
            ? UIDevice.current.orientation.isPortrait
            : (view.frame.size.width < view.frame.size.height)
        
        let numOfCols: CGFloat = isPortrait ? 3.0 : 5.0
        let spacesBetweenCols = numOfCols - 1
        
        let portraitViewWidth = min(view.frame.size.width, view.frame.size.height)
        let landscapeViewWidth = max(view.frame.size.width, view.frame.size.height)
        let horizontalViewDimension = isPortrait ? portraitViewWidth : landscapeViewWidth

        let dimension = (horizontalViewDimension - (spacesBetweenCols * space)) / numOfCols
        
        self.flowLayout.minimumInteritemSpacing = space
        self.flowLayout.minimumLineSpacing = space
        self.flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    // MARK: Collection View Data Source

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        cell.memeImageView.image = self.memes[indexPath.row].memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
