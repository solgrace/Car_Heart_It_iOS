//
//  User.swift
//  Car_Heart_It_iOS
//
//  Created by Grace Rufina Solibun on 23/9/2023.
//

import Foundation
import CoreData

//public class CoreDataUser: NSManagedObject {
//    @NSManaged public var firstName: String
//    @NSManaged public var lastName: String
//    @NSManaged public var email: String
//    @NSManaged public var password: String
//}

public class CDUser: NSManagedObject {
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var email: String
    @NSManaged public var password: String
}
