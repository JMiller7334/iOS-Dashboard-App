//
//  DatabaseActions.swift
//  Dashboard-App
//
//  Created by Jacob Miller on 9/4/24.
//

import Foundation

enum DatabaseActions: String, CaseIterable {
    case update = "update"
    case delete = "delete"
    case write = "write"
    
    // Computed property to get the search hint based on the action
    var searchHint: String {
        switch self {
        case .write:
            return "nil"
        case .update:
            return "Enter an id to update"
        case .delete:
            return "Enter an id to delete"
        }
    }
}
