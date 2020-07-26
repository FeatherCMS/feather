//
//  AdminModule.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 03. 28..
//

import Vapor
import Fluent
import ViperKit

final class AdminModule: ViperModule {

    static let name = "admin"
    var priority: Int { 100 }
    
    var router: ViperRouter? = AdminRouter()
}
