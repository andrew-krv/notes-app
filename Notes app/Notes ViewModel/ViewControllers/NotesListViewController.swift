//
//  NotesListViewController.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 30.11.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import UIKit

class NotesListViewController : UITableViewCell {
    private(set) var Title : String = ""
    private(set) var NoteLabel  : String = ""
    private(set) var Timestamp  : String = ""
 
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var NoteTextLabel: UILabel!
    @IBOutlet weak var TimestampLabel: UILabel!
}
