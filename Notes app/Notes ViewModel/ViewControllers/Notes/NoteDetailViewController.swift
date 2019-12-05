//
//  DetailViewController.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 02.11.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var TimestampLabel: UILabel!
    @IBOutlet weak var NoteTextView: UITextView!
    
    func configureView() {
        if let detail = detailItem {
            if let topicLabel = TitleLabel,
               let dateLabel = TimestampLabel,
               let textView = NoteTextView {
                topicLabel.text = detail.noteTitle
                dateLabel.text = NotesAppDateHelper.convertDate(date: Date.init(seconds: detail.noteTimeStamp))
                textView.text = detail.noteText
            }
        }

        let EditButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonClicked))
        navigationItem.rightBarButtonItem = EditButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    var detailItem: NoteClass? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChangeNoteSegue" {
            let changeNoteViewController = segue.destination as! NoteEditViewController
            if let detail = detailItem {
                changeNoteViewController.setChangingReallySimpleNote(
                    changingReallySimpleNote: detail)
            }
        }
    }

    @IBAction func editButtonClicked(_ sender: UIBarButtonItem, forEvent event:UIEvent) {
        performSegue(
            withIdentifier: "showChangeNoteSegue",
            sender: self)
    }
}

