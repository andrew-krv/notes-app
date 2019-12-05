//
//  WeatherTableViewController.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 06.12.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import Foundation
import UIKit

class WeatherTableViewController : UITableViewController {
    var weatherItems: Array<WeatherClass> = Array()
    
    
//    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//
//    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//    loadingIndicator.hidesWhenStopped = true
//    loadingIndicator.style = UIActivityIndicatorView.Style.gray
//    loadingIndicator.startAnimating();
//
//    alert.view.addSubview(loadingIndicator)
//    present(alert, animated: true, completion: nil)
    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return objects.count
        return NotesStorage.storage.count()
    }

    override func tableView(
            _ tableView: UITableView,
            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotesListViewController

        if weatherItems.indices.contains(indexPath.row) {
            let object = weatherItems[indexPath.row]
            cell.TitleLabel!.text = object.noteTitle
            cell.NoteTextLabel!.text = object.noteText
            cell.TimestampLabel!.text = NotesAppDateHelper.convertDate(date: Date.init(seconds: object.noteTimeStamp))
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NotesStorage.storage.removeNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            performSegue(withIdentifier: "showCreateNoteSegue", sender: self)
        }
    }
}

