//
//  CustomOrder.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 11..
//

import Vapor
import Fluent


enum CustomOrder: String, CaseIterable {
    case asc
    case desc
    
    var sortDirection: DatabaseQuery.Sort.Direction {
        switch self {
        case .asc:
            return .ascending
        case .desc:
            return .descending
        }
    }
}
