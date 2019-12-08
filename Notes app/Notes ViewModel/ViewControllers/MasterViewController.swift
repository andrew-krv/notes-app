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
    private var searchController = UISearchController(searchResultsController: nil)
    private var isSearching = false

    var detailViewController: NoteDetailViewController? = nil
    
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
        
//        self.tableView.tableHeaderView = searchController.searchBar

        let managedContext = appDelegate.persistentContainer.viewContext
        NotesStorage.storage.setManagedContext(managedObjectContext: managedContext)

        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(insertNewObject(_:)))
        let showWeatherButton = UIBarButtonItem(
            image: UIImage(systemName: "sun.min"),
            style: .plain,
            target: self,
            action: #selector(weatherButtonClicked))
        let searchButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(searchButtonClicked))

        navigationItem.rightBarButtonItems = [addButton, showWeatherButton]
        navigationItem.leftBarButtonItems = [editButtonItem, searchButton]

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers.last as! UINavigationController).topViewController as? NoteDetailViewController
        }
        
        self.fetchNotes()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

   
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
    
    @IBAction func searchButtonClicked(_ sender: UIBarButtonItem, forEvent event:UIEvent) {
        // Create the search controller and specify that it should present its results in this same view
        searchController = UISearchController(searchResultsController: nil)

        // Set any properties (in this case, don't hide the nav bar and don't show the emoji keyboard option)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self

        // Make this class the delegate and present the search
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "showCreateNoteSegue", sender: self)
    }

    // MARK: - Table View
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String) {
        if !searchText.isEmpty {
            isSearching = true
            filteredItems = notesItems.filter { (object: NoteClass) -> Bool in
                return object.noteTitle.lowercased().contains(searchText.lowercased())
            }
        } else {
            isSearching = false
        }
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return objects.count
        return isSearching ? filteredItems.count : notesItems.count
    }

    override func tableView(
            _ tableView: UITableView,
            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotesListViewController

        let notesContainer = isSearching ? filteredItems : notesItems
        
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

