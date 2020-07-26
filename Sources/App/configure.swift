//
//  configure.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import Vapor
import Leaf
import Fluent
//import FluentPostgresDriver
import FluentSQLiteDriver
import Liquid
import LiquidLocalDriver
import ViperKit
import ViewKit

public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    
    //try app.databases.use(.postgres(url: Application.databaseUrl), as: .psql)
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    
    app.fileStorages.use(.local(publicUrl: Application.baseUrl,
                                publicPath: app.directory.publicDirectory,
                                workDirectory: "assets"), as: .local)

    app.routes.defaultMaxBodySize = "10mb"

    app.sessions.use(.fluent)
    app.migrations.add(SessionRecord.migration)
    app.middleware.use(SlashMiddleware())
    app.middleware.use(app.sessions.middleware)

    app.views.use(.leaf)
    app.leaf.tags[IsDebugTag.name] = IsDebugTag()
    app.leaf.tags[PathTag.name] = PathTag()
    app.leaf.tags[PathDropLastTag.name] = PathDropLastTag()
    app.leaf.tags[ParameterTag.name] = ParameterTag()
    app.leaf.tags[PermalinkTag.name] = PermalinkTag()
    app.leaf.tags[QueryTag.name] = QueryTag()
    app.leaf.tags[SetQueryTag.name] = SetQueryTag()
    app.leaf.tags[SortQueryTag.name] = SortQueryTag()
    app.leaf.tags[SortIndicatorTag.name] = SortIndicatorTag()
    app.leaf.tags[ResolveTag.name] = ResolveTag()
    app.leaf.tags[YearTag.name] = YearTag()
    app.leaf.tags[DateFormatterTag.name] = DateFormatterTag()
    app.leaf.tags[CountTag.name] = CountTag()
    app.leaf.tags[IsEmptyTag.name] = IsEmptyTag()
    app.leaf.tags[ContainsTag.name] = ContainsTag()

    if !app.environment.isRelease && app.environment != .production {
        app.leaf.cache.isEnabled = false
        app.leaf.useViperViews(fileExtension: "html")
    }
    
    let modules: [ViperModule] = [
        // core modules
        SystemModule(),
        UserModule(),
        ApiModule(),
        AdminModule(),
        FrontendModule(),

        //user modules
        RedirectModule(),
        BlogModule(),
        StaticModule(),
        SponsorModule(),
        MarkdownModule(),
        SplashModule(),
    ]

    try app.viper.use(modules)

    try app.autoMigrate().wait()
}
