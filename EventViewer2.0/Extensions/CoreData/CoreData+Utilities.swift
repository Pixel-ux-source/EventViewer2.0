//
//  CoreData+Utilities.swift
//  EventViewer
//
//  Created by Ilya Kharlamov on 1/26/23.
//

import CoreData

public enum RelationshipType {
    case oneToMany
    case oneToOne
}

public extension NSAttributeDescription {
    convenience init(
        name: String,
        type: NSAttributeType,
        isOptional: Bool = false,
        _ configure: (NSAttributeDescription) -> Void = { _ in }
    ) {
        self.init()
        self.name = name
        self.attributeType = type
        self.isOptional = isOptional

        switch type {
        case .stringAttributeType:
            self.attributeValueClassName = NSStringFromClass(NSString.self)
        case .integer32AttributeType:
            self.attributeValueClassName = NSStringFromClass(NSNumber.self)
        case .booleanAttributeType:
            self.attributeValueClassName = NSStringFromClass(NSNumber.self)
        case .dateAttributeType:
            self.attributeValueClassName = NSStringFromClass(NSDate.self)
        default:
            break
        }

        if type == .integer16AttributeType ||
            type == .integer32AttributeType ||
            type == .integer64AttributeType ||
            type == .doubleAttributeType
        {
            self.defaultValue = 0
        }

        configure(self)
    }
}

public extension NSEntityDescription {
    convenience init<T>(class customClass: T.Type) where T: NSManagedObject {
        self.init()
        self.name = String(String(describing: customClass).dropFirst(2))
        self.managedObjectClassName = T.self.description()
    }
}

public extension NSRelationshipDescription {
    convenience init(
        name: String,
        type: RelationshipType,
        deleteRule: NSDeleteRule = .nullifyDeleteRule,
        destinationEntity: NSEntityDescription,
        isOptional: Bool = false
    ) {
        self.init()
        self.name = name
        self.deleteRule = deleteRule
        self.destinationEntity = destinationEntity
        switch type {
        case .oneToMany:
            self.maxCount = 0
        case .oneToOne:
            self.maxCount = 1
        }
        self.isOptional = isOptional
    }
}
