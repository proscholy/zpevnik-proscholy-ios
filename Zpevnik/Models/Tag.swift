//
//  Tag.swift
//  Zpevnik
//
//  Created by Patrik Dobiáš on 06/08/2019.
//  Copyright © 2019 Patrik Dobiáš. All rights reserved.
//

import CoreData

extension Tag {
    
    static func createFromDict(_ data: [String: Any], _ context: NSManagedObjectContext) -> Tag? {
        guard let id = data["id"] as? String else { return nil }
        
        guard let tag: Tag = CoreDataService.createOrGetObject(id: id, context: context) else { return nil }
        
        tag.id = id
        tag.name = data["name"] as? String
        
        return tag
    }
}

extension Tag: FilterTag {
    
    var title: String {
        get {
            return self.name!.capitalizingFirstLetter()
        }
    }
    
    var elements: [FilterAble] {
        get {
            if let children = children?.allObjects as? [Tag] {
                return children.sorted{ $0.id!.localizedStandardCompare($1.id!) == .orderedAscending }
            }
            
            return []
        }
    }
}

extension Tag: FilterAble {
    
    static var predicateFormat: String {
        get {
            return "ANY tags.name IN %@"
        }
    }
}
