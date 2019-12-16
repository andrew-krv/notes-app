//
//  Notes_appTests.swift
//  Notes appTests
//
//  Created by Andrii Kryvytskyi on 02.11.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import XCTest
import CoreData
@testable import Notes_app

class Notes_app_CoreData_appTests: XCTestCase {
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NotesDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    override func setUp() {
        NotesStorage.storage.setManagedContext(managedObjectContext: persistentContainer.viewContext)
        continueAfterFailure = false
    }

    override func tearDown() {
        for i in (0...NotesStorage.storage.count()).reversed() {
            NotesStorage.storage.removeNote(at: i)
        }
    }

    func testAddSingleNote() {
        let noteCreationTimeStamp : Int64 = Date().toSeconds()
        
        let newNote = NoteClass(noteTitle: "My great note",
                  noteText: "Greatest text in history",
                  noteTimeStamp: noteCreationTimeStamp,
                  noteImage: nil)
        
        NotesStorage.storage.addNote(noteToBeAdded: newNote)
        
        XCTAssert(NotesStorage.storage.count() == 1)
    }
    
    func testAddAndReadSingleNote() {
        let noteCreationTimeStamp : Int64 = Date().toSeconds()
        
        let newNote = NoteClass(noteTitle: "My great note",
                  noteText: "Greatest text in history",
                  noteTimeStamp: noteCreationTimeStamp,
                  noteImage: nil)
        
        NotesStorage.storage.addNote(noteToBeAdded: newNote)
        
        XCTAssert(NotesStorage.storage.count() == 1)
        
        let noteFromStorage = NotesStorage.storage.readNote(at: 0)!
        
        XCTAssert(newNote.noteId        == noteFromStorage.noteId)
        XCTAssert(newNote.noteText      == noteFromStorage.noteText)
        XCTAssert(newNote.noteTitle     == noteFromStorage.noteTitle)
        XCTAssert(newNote.noteTimeStamp == noteFromStorage.noteTimeStamp)
    }
    
    func testAddAnChangeSingleNote() {
        let noteCreationTimeStamp : Int64 = Date().toSeconds()
        
        let newNote = NoteClass(noteTitle: "My great note",
                  noteText: "Greatest text in history",
                  noteTimeStamp: noteCreationTimeStamp,
                  noteImage: nil)
        
        NotesStorage.storage.addNote(noteToBeAdded: newNote)
        XCTAssert(NotesStorage.storage.count() == 1)
        
        let sourceNoteFromStorage = NotesStorage.storage.readNote(at: 0)!
        
        XCTAssert(newNote.noteId        == sourceNoteFromStorage.noteId)
        XCTAssert(newNote.noteText      == sourceNoteFromStorage.noteText)
        XCTAssert(newNote.noteTitle     == sourceNoteFromStorage.noteTitle)
        XCTAssert(newNote.noteTimeStamp == sourceNoteFromStorage.noteTimeStamp)
        
        let newNoteText = "Changed greatest text"
        let changedNote = NoteClass(noteId: newNote.noteId,
                                    noteTitle: newNote.noteTitle,
                                    noteText: newNoteText,
                                    noteTimeStamp: newNote.noteTimeStamp,
                                    noteImage: nil)
        
        NotesStorage.storage.changeNote(noteToBeChanged: changedNote)
        
        XCTAssert(NotesStorage.storage.count() == 1)
        
        let changedNoteFromStorage = NotesStorage.storage.readNote(at: 0)!
        
        XCTAssert(changedNote.noteId        == changedNoteFromStorage.noteId)
        XCTAssert(changedNote.noteText      == newNoteText)
        XCTAssert(changedNote.noteTitle     == changedNoteFromStorage.noteTitle)
        XCTAssert(changedNote.noteTimeStamp == changedNoteFromStorage.noteTimeStamp)
    }
    
    func testAddMultipleNotesAndReadSecondOne() {
    
        let firstNoteTimeStamp : Int64 = Date().toSeconds()
        let firstNewNote = NoteClass(noteTitle: "My great note 1",
                  noteText: "Greatest text in history 1",
                  noteTimeStamp: firstNoteTimeStamp,
                  noteImage: nil)
        
        sleep(2)
        
        let secondNoteTimeStamp : Int64 = Date().toSeconds()
        let secondNewNote = NoteClass(noteTitle: "My great note 2",
                  noteText: "Greatest text in history 2",
                  noteTimeStamp: secondNoteTimeStamp,
                  noteImage: nil)
        
        NotesStorage.storage.addNote(noteToBeAdded: firstNewNote)
        NotesStorage.storage.addNote(noteToBeAdded: secondNewNote)
        
        XCTAssert(NotesStorage.storage.count() == 2)
        
        let noteFromStorage = NotesStorage.storage.readNote(at: 1)!
        
        XCTAssert(secondNewNote.noteId        == noteFromStorage.noteId)
        XCTAssert(secondNewNote.noteText      == noteFromStorage.noteText)
        XCTAssert(secondNewNote.noteTitle     == noteFromStorage.noteTitle)
        XCTAssert(secondNewNote.noteTimeStamp == noteFromStorage.noteTimeStamp)
    }
    
    func testAddMultipleNotesDeleteAndRead() {
    
        let firstNoteTimeStamp : Int64 = Date().toSeconds()
        let firstNewNote = NoteClass(noteTitle: "My great note 1",
                  noteText: "Greatest text in history 1",
                  noteTimeStamp: firstNoteTimeStamp,
                  noteImage: nil)
        
        sleep(2)
        
        let secondNoteTimeStamp : Int64 = Date().toSeconds()
        let secondNewNote = NoteClass(noteTitle: "My great note 2",
                  noteText: "Greatest text in history 2",
                  noteTimeStamp: secondNoteTimeStamp,
                  noteImage: nil)
        
        NotesStorage.storage.addNote(noteToBeAdded: firstNewNote)
        NotesStorage.storage.addNote(noteToBeAdded: secondNewNote)
        
        XCTAssert(NotesStorage.storage.count() == 2)
        
        let firstNoteFromStorage = NotesStorage.storage.readNote(at: 1)!
        
        XCTAssert(secondNewNote.noteId        == firstNoteFromStorage.noteId)
        XCTAssert(secondNewNote.noteText      == firstNoteFromStorage.noteText)
        XCTAssert(secondNewNote.noteTitle     == firstNoteFromStorage.noteTitle)
        XCTAssert(secondNewNote.noteTimeStamp == firstNoteFromStorage.noteTimeStamp)
        
        NotesStorage.storage.removeNote(at: 1)
        
        XCTAssert(NotesStorage.storage.count() == 1)
        
        let secondNoteFromStorage = NotesStorage.storage.readNote(at: 0)!
               
        XCTAssert(firstNewNote.noteId        == secondNoteFromStorage.noteId)
        XCTAssert(firstNewNote.noteText      == secondNoteFromStorage.noteText)
        XCTAssert(firstNewNote.noteTitle     == secondNoteFromStorage.noteTitle)
        XCTAssert(firstNewNote.noteTimeStamp == secondNoteFromStorage.noteTimeStamp)
    }
    
}
