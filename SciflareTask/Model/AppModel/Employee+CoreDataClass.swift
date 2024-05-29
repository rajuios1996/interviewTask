//
//  Employee+CoreDataClass.swift
//  SciflareTask
//
//  Created by Chandru on 28/05/24.
//

import Foundation
import CoreData


@objc(Employee)
public class Employee: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case _id, name, email, gender, mobile
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: ._id)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.mobile = try container.decode(String.self, forKey: .mobile)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: ._id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(gender, forKey: .gender)
        try container.encode(mobile, forKey: .mobile)
      }
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}
