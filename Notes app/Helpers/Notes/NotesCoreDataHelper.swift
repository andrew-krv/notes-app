//
//  NotesCoreDataHelper.swift
//  Notes app
//
//  Created by Andrii Kryvytskyi on 14.11.2019.
//  Copyright © 2019 Andrii Kryvytskyi. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class NotesCoreDataHelper {
    
    private(set) static var count: Int = 0
    
    static func createNoteInCoreData(
        noteToBeCreated:          NoteClass,
        intoManagedObjectContext: NSManagedObjectContext) {
        
        // Let’s create an entity and new note record
        let noteEntity = NSEntityDescription.entity(
            forEntityName: "Note",
            in:            intoManagedObjectContext)!
        
        let newNoteToBeCreated = NSManagedObject(
            entity:     noteEntity,
            insertInto: intoManagedObjectContext)

        newNoteToBeCreated.setValue(
            noteToBeCreated.noteId,
            forKey: "noteId")
        
        newNoteToBeCreated.setValue(
            noteToBeCreated.noteTitle,
            forKey: "noteTitle")
        
        newNoteToBeCreated.setValue(
            noteToBeCreated.noteText,
            forKey: "noteText")
        
        newNoteToBeCreated.setValue(
            noteToBeCreated.noteTimeStamp,
            forKey: "noteTimeStamp")
        
        newNoteToBeCreated.setValue(
            (noteToBeCreated.noteImage)?.pngData(),
            forKey: "noteImage")
        
        do {
            try intoManagedObjectContext.save()
            count += 1
        } catch let error as NSError {
            // TODO error handling
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func changeNoteInCoreData(
        noteToBeChanged:        NoteClass,
        inManagedObjectContext: NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let noteIdPredicate = NSPredicate(format: "noteId = %@", noteToBeChanged.noteId as CVarArg)
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try inManagedObjectContext.fetch(fetchRequest)
            let noteManagedObjectToBeChanged = fetchedNotesFromCoreData[0] as! NSManagedObject
            
            // make the changes
            noteManagedObjectToBeChanged.setValue(
                noteToBeChanged.noteTitle,
                forKey: "noteTitle")

            noteManagedObjectToBeChanged.setValue(
                noteToBeChanged.noteText,
                forKey: "noteText")

            noteManagedObjectToBeChanged.setValue(
                noteToBeChanged.noteTimeStamp,
                forKey: "noteTimeStamp")
            
            noteManagedObjectToBeChanged.setValue(
                (noteToBeChanged.noteImage)?.pngData(),
                forKey: "noteImage")

            // save
            try inManagedObjectContext.save()

        } catch let error as NSError {
            // TODO error handling
            print("Could not change. \(error), \(error.userInfo)")
        }
    }
    
    static func readNotesFromCoreData(fromManagedObjectContext: NSManagedObjectContext) -> [NoteClass] {

        var returnedNotes = [NoteClass]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        fetchRequest.predicate = nil
        
        do {
            let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            fetchedNotesFromCoreData.forEach { (fetchRequestResult) in
                let noteManagedObjectRead = fetchRequestResult as! NSManagedObject
                
                var image = UIImage()
                if let Data = (noteManagedObjectRead.value(forKey: "noteImage")as? Data) {
                    image = UIImage(data:Data) ?? UIImage()
                }
                returnedNotes.append(NoteClass.init(
                    noteId:        noteManagedObjectRead.value(forKey: "noteId")        as! UUID,
                    noteTitle:     noteManagedObjectRead.value(forKey: "noteTitle")     as! String,
                    noteText:      noteManagedObjectRead.value(forKey: "noteText")      as! String,
                    noteTimeStamp: noteManagedObjectRead.value(forKey: "noteTimeStamp") as! Int64,
                    noteImage:     image))
            }
        } catch let error as NSError {
            // TODO error handling
            print("Could not read. \(error), \(error.userInfo)")
        }

        self.count = returnedNotes.count
        
        return returnedNotes
    }
    
    static func readNoteFromCoreData(
        noteIdToBeRead:           UUID,
        fromManagedObjectContext: NSManagedObjectContext) -> NoteClass? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        let noteIdPredicate = NSPredicate(format: "noteId = %@", noteIdToBeRead as CVarArg)
        
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            let noteManagedObjectToBeRead = fetchedNotesFromCoreData[0] as! NSManagedObject
            
            var image = UIImage()
            if let Data = (noteManagedObjectToBeRead.value(forKey: "noteImage")as? Data) {
                image = UIImage(data:Data) ?? UIImage()
            }

            return NoteClass.init(
                noteId:        noteManagedObjectToBeRead.value(forKey: "noteId")        as! UUID,
                noteTitle:     noteManagedObjectToBeRead.value(forKey: "noteTitle")     as! String,
                noteText:      noteManagedObjectToBeRead.value(forKey: "noteText")      as! String,
                noteTimeStamp: noteManagedObjectToBeRead.value(forKey: "noteTimeStamp") as! Int64,
                noteImage:     image)
        } catch let error as NSError {
            // TODO error handling
            print("Could not read. \(error), \(error.userInfo)")
            return nil
        }
    }

    static func deleteNoteFromCoreData(
        noteIdToBeDeleted:        UUID,
        fromManagedObjectContext: NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let noteIdAsCVarArg: CVarArg = noteIdToBeDeleted as CVarArg
        let noteIdPredicate = NSPredicate(format: "noteId == %@", noteIdAsCVarArg)
        
        fetchRequest.predicate = noteIdPredicate
        
        do {
            let fetchedNotesFromCoreData = try fromManagedObjectContext.fetch(fetchRequest)
            let noteManagedObjectToBeDeleted = fetchedNotesFromCoreData[0] as! NSManagedObject
            fromManagedObjectContext.delete(noteManagedObjectToBeDeleted)
            
            do {
                try fromManagedObjectContext.save()
                self.count -= 1
            } catch let error as NSError {
                // TODO error handling
                print("Could not save. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            // TODO error handling
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
    }

}
