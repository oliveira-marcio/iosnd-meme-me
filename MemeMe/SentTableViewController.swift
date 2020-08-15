//
//  SentTableViewController.swift
//  MemeMe
//
//  Created by Márcio Oliveira on 8/15/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class SentTableViewController: UITableViewController {
    
    var memes = [Meme]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        self.memes = appDelegate.memes
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
