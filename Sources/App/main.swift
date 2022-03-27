//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

import Vapor
import Fluent
import FluentSQLiteDriver
import Liquid
import LiquidLocalDriver
import Mail
import MailAwsDriver
import Feather

import WebModule
import UserModule
import RedirectModule


public func configure(_ app: Application) throws {
    app.feather.boot()

    app.databases.use(.sqlite(.file(app.feather.paths.resources.path + "/db.sqlite")), as: .sqlite)
    
    app.fileStorages.use(.local(publicUrl: app.feather.publicUrl,
                                publicPath: app.feather.paths.public.path,
                                workDirectory: Feather.Directories.assets), as: .local)

    app.mailProviders.use(.ses(credentialProvider: .default, region: .eucentral1), as: .ses)

    try app.feather.start([
        UserBuilder().build(template: nil),
        WebBuilder().build(),
        RedirectBuilder().build(),
    ])
}

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
