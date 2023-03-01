//
//  StorageManager.swift
//  NotesApp
//
//  Created by Слава Орлов on 25.02.2023.
//
import Foundation
import RealmSwift

let realm = try! Realm()
let localNotification = UNUserNotificationCenter.current()

class StorageManager {
    
    static func saveObject(_ note: Note, swither: UISwitch) {
        
        try! realm.write {
            realm.add(note)
            if swither.isOn == true{
                note.notification = true
            }
            else{
                note.notification = false
            }
        }
    }
    
    static func deleteNote(_ note: Note) {
        
        try! realm.write{
            realm.delete(note)
        }
    }
}
