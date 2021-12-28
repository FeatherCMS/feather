//
//  main.swift
//  Feather
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import FeatherCore
import FluentSQLiteDriver
import LiquidLocalDriver
import AnalyticsModule
import AggregatorModule
import BlogModule
import MarkdownModule
import RedirectModule
import SwiftyModule

public func configure(_ app: Application) throws {

    app.databases.use(.sqlite(.file(Feather.Directories.resources + "/db.sqlite")), as: .sqlite)
    
    app.fileStorages.use(.local(publicUrl: Feather.baseUrl,
                                publicPath: Feather.Paths.public.path,
                                workDirectory: Feather.Directories.assets), as: .local)
    
    let modules: [FeatherModule] = [
        AnalyticsBuilder().build(),
        AggregatorBuilder().build(),
        BlogBuilder().build(),
        MarkdownBuilder().build(),
        RedirectBuilder().build(),
        SwiftyBuilder().build(),
    ]
    
    try app.feather.start(modules)
}

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
