//
//  FrontendContentModel+Filter.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import Vapor
import Fluent
import ViperKit

extension FrontendContentModel {

    func filter(_ input: String, req: Request) -> String {
        req.application.viper.invokeAllSyncHooks(name: "content-filter",
                                                 req: req,
                                                 type: [ContentFilter].self)
            .flatMap { $0 }
            .filter { self.filters.contains($0.key) }
            .reduce(input) { $1.filter($0) }
    }
}
