//
//  NotesStorage.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 14.11.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import CoreData

class NotesStorage {
    static let storage : NotesStorage = NotesStorage()
    
    private var noteIndexToIdDict : [Int:UUID] = [:]
    private var currentIndex : Int = 0

    private(set) var managedObjectContext : NSManagedObjectContext
    private var managedContextHasBeenSet : Bool = false
    
    private init() {
        managedObjectContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    }
    
    func setManagedContext(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.managedContextHasBeenSet = true
        let notes = NotesCoreDataHelper.readNotesFromCoreData(fromManagedObjectContext: self.managedObjectContext)
        currentIndex = NotesCoreDataHelper.count
        for (index, note) in notes.enumerated() {
            noteIndexToIdDict[index] = note.noteId
        }
    }
    
    func addNote(noteToBeAdded: NoteClass) {
        if managedContextHasBeenSet {
            noteIndexToIdDict[currentIndex] = noteToBeAdded.noteId
            NotesCoreDataHelper.createNoteInCoreData(
                noteToBeCreated:          noteToBeAdded,
                intoManagedObjectContext: self.managedObjectContext)
            currentIndex += 1
        }
    }
    
    func removeNote(at: Int) {
        if managedContextHasBeenSet {
            if at < 0 || at > currentIndex-1 {
                // TODO error handling
                return
            }

            let noteUUID = noteIndexToIdDict[at]
            NotesCoreDataHelper.deleteNoteFromCoreData(
                noteIdToBeDeleted:        noteUUID!,
                fromManagedObjectContext: self.managedObjectContext)

            if (at < currentIndex - 1) {
                for i in at ... currentIndex - 2 {
                    noteIndexToIdDict[i] = noteIndexToIdDict[i+1]
                }
            }

            noteIndexToIdDict.removeValue(forKey: currentIndex)
            currentIndex -= 1
        }
    }
    
    func readNote(at: Int) -> NoteClass? {
        if managedContextHasBeenSet {
            if at < 0 || at > currentIndex-1 {
                // TODO error handling
                return nil
            }
            let noteUUID = noteIndexToIdDict[at]
            let noteReadFromCoreData: NoteClass?
            noteReadFromCoreData = NotesCoreDataHelper.readNoteFromCoreData(
                noteIdToBeRead:           noteUUID!,
                fromManagedObjectContext: self.managedObjectContext)
            return noteReadFromCoreData
        }
        return nil
    }
    
    func changeNote(noteToBeChanged: NoteClass) {
        if managedContextHasBeenSet {
            var noteToBeChangedIndex : Int?
            noteIndexToIdDict.forEach { (index: Int, noteId: UUID) in
                if noteId == noteToBeChanged.noteId {
                    noteToBeChangedIndex = index
                    return
                }
            }
            if noteToBeChangedIndex != nil {
                NotesCoreDataHelper.changeNoteInCoreData(
                noteToBeChanged: noteToBeChanged,
                inManagedObjectContext: self.managedObjectContext)
            } else {
                // TODO error handling
            }
        }
    }

    
    func count() -> Int {
        return NotesCoreDataHelper.count
    }
}
