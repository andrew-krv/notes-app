//
//  MasterViewController.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 02.11.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: NoteDetailViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            let alert = UIAlertController(
                title: "Could note get app delegate",
                message: "Could note get app delegate, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default))
            self.present(alert, animated: true)

            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        NotesStorage.storage.setManagedContext(managedObjectContext: managedContext)
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(insertNewObject(_:)))
        let showWeatherButton = UIBarButtonItem(
            image: UIImage(systemName: "sun.min"),
            style: .plain,
            target: self,
            action: #selector(weatherButtonClicked))
        navigationItem.rightBarButtonItems = [addButton, showWeatherButton]

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers.last as! UINavigationController).topViewController as? NoteDetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //let object = objects[indexPath.row]
                let object = NotesStorage.storage.readNote(at: indexPath.row)
                let controller = (segue.destination as! UINavigationController).topViewController as! NoteDetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    @IBAction func weatherButtonClicked(_ sender: UIBarButtonItem, forEvent event:UIEvent) {
        performSegue(
            withIdentifier: "showWeatherForecast",
            sender: self)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "showCreateNoteSegue", sender: self)
    }

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

        if let object = NotesStorage.storage.readNote(at: indexPath.row) {
        cell.TitleLabel!.text = object.noteTitle
        cell.NoteTextLabel!.text = object.noteText
            cell.TimestampLabel!.text = NotesAppDateHelper.convertDate(
                date: Date.init(seconds: object.noteTimeStamp),
                dateFormat: "EEEE, MMM d, yyyy, hh:mm:ss")
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

