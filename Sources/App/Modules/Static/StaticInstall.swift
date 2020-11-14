//
//  StaticInstaller.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 07. 12..
//

import Vapor
import Fluent

/// installer component for the static module
struct StaticInstaller: ViperInstaller {

    /// we create the sample static page models & publish their metadata objects
    func createModels(_ req: Request) -> EventLoopFuture<Void>? {
        /// NOTE: blog related pages should provided via a hook, but we're good for now...
        let homePage = StaticPageModel(title: "Home", content: "[home-page]")
        let pages = [
            StaticPageModel(title: "Posts", content: "[posts-page]"),
            StaticPageModel(title: "Categories", content: "[categories-page]"),
            StaticPageModel(title: "Authors", content: "[authors-page]"),
            StaticPageModel(title: "About", content: "about this page"),
        ]

        /// we persist the pages to the database
        return req.eventLoop.flatten([
            /// save home page and set it as a published root page by altering the metadata
            homePage.create(on: req.db)
                .flatMap { homePage.updateMetadata(on: req.db, { $0.slug = ""; $0.status = .published }) },
            /// save pages, then we publish the associated metadatas
            pages.create(on: req.db).flatMap { _ in
                req.eventLoop.flatten(pages.map { $0.publishMetadata(on: req.db) })
            }
        ])
    }
}
