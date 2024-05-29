//
//  Employee+CoreDataProperties.swift
//  SciflareTask
//
//  Created by Chandru on 28/05/24.
//

import Foundation
import CoreData


extension Employee {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }
    
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var gender: String?
    @NSManaged public var mobile: String?
}

extension Employee : Identifiable {
    
}
