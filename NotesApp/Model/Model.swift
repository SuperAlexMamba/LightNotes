//
//  Model.swift
//  NotesApp
//
//  Created by Слава Орлов on 19.01.2023.
//

import Foundation
import UIKit
import RealmSwift

class Note: Object {
    
    @Persisted var title: String!
    @Persisted var descriptionText: String?
    @Persisted var date: Date?
    @Persisted var notification = false
    
    convenience init(title: String!, descriptionText: String?, date: Date?, notification: Bool = false) {
        self.init()
        
        self.title = title
        self.descriptionText = descriptionText
        self.date = date
        self.notification = notification
    }
}

