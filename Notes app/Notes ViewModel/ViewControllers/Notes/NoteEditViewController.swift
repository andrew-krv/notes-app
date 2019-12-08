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
    @IBOutlet weak var Timestamp: UILabel!
    @IBOutlet weak var NoteImageView: UIImageView!

    // MARK: imagePicker init
    
    var imagePicker: ImagePicker!
    private let noteCreationTimeStamp : Int64 = Date().toSeconds()
    private(set) var changingReallySimpleNote : NoteClass?
    private let DoneButton = UIBarButtonItem(
        title: "Done",
        style: .plain,
        target: self,
        action: #selector(doneButtonClicked))
    private let AttachImageButton = UIBarButtonItem(
        image: UIImage(systemName: "paperclip"),
        style: .plain,
        target: self,
        action: #selector(showImagePicker))
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NoteTextView.delegate = self
        
        if let changingReallySimpleNote = self.changingReallySimpleNote {
            Timestamp.text = NotesAppDateHelper.convertDate(
                date: Date.init(seconds: noteCreationTimeStamp),
                dateFormat: "EEEE, MMM d, yyyy, hh:mm:ss")
            NoteTextView.text = changingReallySimpleNote.noteText
            TitleTextField.text = changingReallySimpleNote.noteTitle
            NoteImageView.image = changingReallySimpleNote.noteImage
        } else {
            Timestamp.text = NotesAppDateHelper.convertDate(
                date: Date.init(seconds: noteCreationTimeStamp),
                dateFormat: "EEEE, MMM d, yyyy, hh:mm:ss")
        }

        DoneButton.isEnabled = false
        
        NoteTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        NoteTextView.layer.borderWidth = 1.0
        NoteTextView.layer.cornerRadius = 5

        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [DoneButton, AttachImageButton]

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }

    // MARK: Content change
    
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
    
    func textViewDidChange(_ textView: UITextView) {
        if self.changingReallySimpleNote != nil {
            DoneButton.isEnabled = true
        } else {
            if ( TitleTextField.text?.isEmpty ?? true ) || ( textView.text?.isEmpty ?? true ) {
                DoneButton.isEnabled = false
            } else {
                DoneButton.isEnabled = true
            }
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: UIBarButtonItem, forEvent event:UIEvent) {
        if self.changingReallySimpleNote != nil {
            changeItem()
        } else {
            addItem()
        }
    }
    
    @IBAction func showImagePicker(_ sender: UIBarButtonItem, forEvent event:UIEvent) {
        self.imagePicker.present(from: self.NoteImageView)
    }
    
    func setChangingReallySimpleNote(changingReallySimpleNote : NoteClass) {
        self.changingReallySimpleNote = changingReallySimpleNote
    }
    
    private func addItem() -> Void {
        var image : UIImage
        if NoteImageView.image != nil {
            image = NoteImageView.image!
        } else {
            image = UIImage()
        }

        let note = NoteClass(
            noteTitle:     TitleTextField.text!,
            noteText:      NoteTextView.text,
            noteTimeStamp: noteCreationTimeStamp,
            noteImage:     image)

        NotesStorage.storage.addNote(noteToBeAdded: note)
        
        performSegue(
            withIdentifier: "backToMasterView",
            sender: self)
    }

    private func changeItem() -> Void {

        if let changingReallySimpleNote = self.changingReallySimpleNote {
            var image : UIImage
            if NoteImageView.image != nil {
                image = NoteImageView.image!
            } else {
                image = UIImage()
            }

            NotesStorage.storage.changeNote(
                noteToBeChanged: NoteClass(
                    noteId:        changingReallySimpleNote.noteId,
                    noteTitle:     TitleTextField.text!,
                    noteText:      NoteTextView.text,
                    noteTimeStamp: noteCreationTimeStamp,
                    noteImage:     image)
            )
            
            performSegue(
                withIdentifier: "backToMasterView",
                sender: self)
        } else {

            let alert = UIAlertController(
                title: "Unexpected error",
                message: "Cannot change the note, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Done",
                                          style: .default ) { (_) in self.performSegue(
                                              withIdentifier: "backToMasterView",
                                              sender: self)})

            self.present(alert, animated: true)
        }
    }
}

// MARK: imagePicker extension

extension NoteEditViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.NoteImageView.image = image
    }
}
