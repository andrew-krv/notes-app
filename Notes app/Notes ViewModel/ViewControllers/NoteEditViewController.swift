//
//  NoteEditViewController.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 30.11.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import UIKit

class NoteEditViewController : UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var NoteTextView: UITextView!
    @IBOutlet weak var DoneButton: UIButton!
    @IBOutlet weak var Timestamp: UILabel!
    
    private let noteCreationTimeStamp : Int64 = Date().toSeconds()
    private(set) var changingReallySimpleNote : NoteClass?

    @IBAction func noteTitleChange(_ sender: UITextField, forEvent event:UIEvent) {
           if self.changingReallySimpleNote != nil {
               // change mode
            DoneButton.isEnabled = true
        } else {
            // create mode
            if ( sender.text?.isEmpty ?? true ) || ( NoteTextView.text?.isEmpty ?? true ) {
                DoneButton.isEnabled = false
            } else {
                DoneButton.isEnabled = true
            }
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton, forEvent event:UIEvent) {
        // distinguish change mode and create mode
        if self.changingReallySimpleNote != nil {
            // change mode - change the item
            changeItem()
        } else {
            // create mode - create the item
            addItem()
        }
    }
    
    func setChangingReallySimpleNote(changingReallySimpleNote : NoteClass) {
        self.changingReallySimpleNote = changingReallySimpleNote
    }
    
    private func addItem() -> Void {
        let note = NoteClass(
            noteTitle:     TitleTextField.text!,
            noteText:      NoteTextView.text,
            noteTimeStamp: noteCreationTimeStamp)

        NotesStorage.storage.addNote(noteToBeAdded: note)
        
        performSegue(
            withIdentifier: "backToMasterView",
            sender: self)
    }

    private func changeItem() -> Void {
        // get changed note instance
        if let changingReallySimpleNote = self.changingReallySimpleNote {
            // change the note through note storage
            NotesStorage.storage.changeNote(
                noteToBeChanged: NoteClass(
                    noteId:        changingReallySimpleNote.noteId,
                    noteTitle:     TitleTextField.text!,
                    noteText:      NoteTextView.text,
                    noteTimeStamp: noteCreationTimeStamp)
            )
            // navigate back to list of notes
            performSegue(
                withIdentifier: "backToMasterView",
                sender: self)
        } else {
            // create alert
            let alert = UIAlertController(
                title: "Unexpected error",
                message: "Cannot change the note, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            // add OK action
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default ) { (_) in self.performSegue(
                                              withIdentifier: "backToMasterView",
                                              sender: self)})
            // show alert
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set text view delegate so that we can react on text change
        NoteTextView.delegate = self
        
        // check if we are in create mode or in change mode
        if let changingReallySimpleNote = self.changingReallySimpleNote {
            // in change mode: initialize for fields with data coming from note to be changed
            Timestamp.text = NotesAppDateHelper.convertDate(date: Date.init(seconds: noteCreationTimeStamp))
            NoteTextView.text = changingReallySimpleNote.noteText
            TitleTextField.text = changingReallySimpleNote.noteTitle
            // enable done button by default
            DoneButton.isEnabled = true
        } else {
            // in create mode: set initial time stamp label
            Timestamp.text = NotesAppDateHelper.convertDate(date: Date.init(seconds: noteCreationTimeStamp))
        }
        
        // initialize text view UI - border width, radius and color
        NoteTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        NoteTextView.layer.borderWidth = 1.0
        NoteTextView.layer.cornerRadius = 5

        // For back button in navigation bar, change text
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    //Handle the text changes here
    func textViewDidChange(_ textView: UITextView) {
        if self.changingReallySimpleNote != nil {
            // change mode
            DoneButton.isEnabled = true
        } else {
            // create mode
            if ( TitleTextField.text?.isEmpty ?? true ) || ( textView.text?.isEmpty ?? true ) {
                DoneButton.isEnabled = false
            } else {
                DoneButton.isEnabled = true
            }
        }
    }

}
