//
//  MasterViewController.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 02.11.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//
//

import UIKit

class MasterViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    private var notesItems: Array<NoteClass> = Array()
    private var filteredItems: Array<NoteClass> = Array()
    @IBOutlet weak var addNote: UIBarButtonItem!
    @IBOutlet weak var showWeather: UIBarButtonItem!
    
    // MARK: viewDidLoad
    
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

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers.last as! UINavigationController).topViewController as? NoteDetailViewController
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.searchController = searchController

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Notes"
        definesPresentationContext = true
        
        self.fetchNotes()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    // MARK:Search controller
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var isSearchBarEmpty: Bool {

      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    var detailViewController: NoteDetailViewController? = nil
    

   
    // MARK: Core Data
    
    private func fetchNotes() {
        for index in 0...NotesStorage.storage.count() {
            if let object = NotesStorage.storage.readNote(at: index) {
                notesItems.append(object)
            }
        }
        
        self.tableView.reloadData()
    }
    
    private func deleteNote(index: Int) {
        NotesStorage.storage.removeNote(at: index)
        notesItems.remove(at: index)

        self.tableView.reloadData()
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //let object = objects[indexPath.row]
                let notesContainer = isFiltering ? filteredItems : notesItems
                let object = notesContainer[indexPath.row]
                tableView.deselectRow(at: indexPath, animated: true)
                let controller = (segue.destination as! UINavigationController).topViewController as! NoteDetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    @IBAction func showWeather(_ sender: UIBarButtonItem) {
        performSegue(
            withIdentifier: "showWeatherForecast",
            sender: self)
    }
    
    @IBAction func insertNewObject(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showCreateNoteSegue", sender: self)
    }

    // MARK: - Table View
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String) {
        if !isSearchBarEmpty {
            filteredItems = notesItems.filter { (object: NoteClass) -> Bool in
                return object.noteTitle.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return objects.count
        return isFiltering ? filteredItems.count : notesItems.count
    }

    override func tableView(
            _ tableView: UITableView,
            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotesListViewController

        let notesContainer = isFiltering ? filteredItems : notesItems
        
        if notesContainer.indices.contains(indexPath.row) {
            let object = notesContainer[indexPath.row]

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
            self.deleteNote(index: indexPath.row)
        } else if editingStyle == .insert {
            performSegue(withIdentifier: "showCreateNoteSegue", sender: self)
        }
    }
}

