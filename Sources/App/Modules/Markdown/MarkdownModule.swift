//
//  MarkdownModule.swift
//  FeatherCMS
//
//  Created by Tibor Bödecs on 2020. 06. 17..
//

import FeatherCore

final class MarkdownModule: ViperModule {

    static var name: String = "markdown"

    func boot(_ app: Application) throws {
        app.hooks.register("content-filters", use: contentFiltersHook)
    }

    // MARK: - hooks
    
    func contentFiltersHook(args: HookArguments) -> [ContentFilter] {
        [MarkdownFilter()]
    }
}
