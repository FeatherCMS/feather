//
//  main.swift
//  Feather
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

@_exported import FeatherCore
import FluentSQLiteDriver
import LiquidLocalDriver
import AnalyticsModule
import AggregatorModule
import BlogModule
import MarkdownModule
import RedirectModule
import SwiftyModule

/// https://github.com/vapor/fluent/blob/main/Sources/Fluent/Exports.swift
infix operator ~~
infix operator =~
infix operator !~
infix operator !=~
infix operator !~=


public func configure(_ app: Application) throws {
    app.feather.boot()

    app.databases.use(.sqlite(.file(app.feather.paths.resources.path + "/db.sqlite")), as: .sqlite)
    
    app.fileStorages.use(.local(publicUrl: app.feather.baseUrl,
                                publicPath: app.feather.paths.public.path,
                                workDirectory: Feather.Directories.assets), as: .local)
    
    let modules: [FeatherModule] = [
        AnalyticsBuilder(),
        AggregatorBuilder(),
        BlogBuilder(),
        MarkdownBuilder(),
        RedirectBuilder(),
        SwiftyBuilder(),
    ].map { $0.build() }
    
    try app.feather.start(modules)
}

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
