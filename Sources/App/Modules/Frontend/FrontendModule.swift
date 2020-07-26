//
//  FrontendModule.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

import Vapor
import Fluent
import ViperKit

final class FrontendModule: ViperModule {

    static let name = "frontend"
    var priority: Int { 100 }
    
    var router: ViperRouter? = FrontendRouter()
    
    var migrations: [Migration] {
        [
            FrontendMigration_v1_0_0(),
        ]
    }
}

