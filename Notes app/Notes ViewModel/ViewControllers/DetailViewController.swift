//
//  DetailViewController.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 02.11.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var TimestampLabel: UILabel!
    @IBOutlet weak var NoteTextView: UITextView!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let topicLabel = TitleLabel,
               let dateLabel = NoteTextView,
               let textView = TimestampLabel {
                topicLabel.text = detail.noteTitle
                dateLabel.text = NotesAppDateHelper.convertDate(date: Date.init(seconds: detail.noteTimeStamp))
                textView.text = detail.noteText
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
}

