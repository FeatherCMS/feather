//
//  FrontendModule.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

import Vapor
import Fluent
import ViperKit
import FeatherCore

public final class FrontendModule: ViperModule {

    public static let name = "frontend"
    public var priority: Int { 100 }
    
    public var router: ViperRouter? = FrontendRouter()
    
    public var migrations: [Migration] {
        Metadata.migrations()
    }
    
    public var viewsUrl: URL? {
        nil
//        Bundle.module.bundleURL
//            .appendingPathComponent("Contents")
//            .appendingPathComponent("Resources")
//            .appendingPathComponent("Views")
    }
}

