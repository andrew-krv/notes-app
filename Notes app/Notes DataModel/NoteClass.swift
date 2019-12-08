//
//  NoteClass.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 14.11.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import Foundation
import UIKit

class NoteClass {
    private(set) var noteId        : UUID
    private(set) var noteTitle     : String
    private(set) var noteText      : String
    private(set) var noteTimeStamp : Int64
    private(set) var noteImage     : UIImage?
    
    init(
        noteTitle:String,
        noteText:String,
        noteTimeStamp:Int64,
        noteImage:UIImage?) {
        self.noteId        = UUID()
        self.noteTitle     = noteTitle
        self.noteText      = noteText
        self.noteTimeStamp = noteTimeStamp
        self.noteImage     = noteImage
    }

    init(
        noteId: UUID,
        noteTitle:String,
        noteText:String,
        noteTimeStamp:Int64,
        noteImage:UIImage?) {
        self.noteId        = noteId
        self.noteTitle     = noteTitle
        self.noteText      = noteText
        self.noteTimeStamp = noteTimeStamp
        self.noteImage     = noteImage
    }
}
