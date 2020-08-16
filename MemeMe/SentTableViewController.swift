//
//  SentTableViewController.swift
//  MemeMe
//
//  Created by Márcio Oliveira on 8/15/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class SentTableViewController: UITableViewController, RefreshDataDelegate {

    // MARK: - Outlets and Models

    @IBOutlet weak var sentMemeTableView: UITableView!
    
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
        self.sentMemeTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath)
        let meme = self.memes[indexPath.row]
        
        cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.memes[indexPath.row])
    }
}
