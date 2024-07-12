//
//  TodoListData+CoreDataProperties.swift
//  TodoList
//
//  Created by Abhishek on 12/07/24.
//
//

import Foundation
import CoreData


extension TodoListData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoListData> {
        return NSFetchRequest<TodoListData>(entityName: "TodoListData")
    }

    @NSManaged public var todoTitle: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var todoDescription: String?

}

extension TodoListData : Identifiable {

}
