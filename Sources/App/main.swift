//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 02. 23..
//

import Feather

import FluentSQLiteDriver
import LiquidLocalDriver
import MailAwsDriver

import WebModule
import UserModule

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

    app.mailProviders.use(.ses(credentialProvider: .default, region: .eucentral1), as: .ses)

    try app.feather.start([
        UserBuilder().build(),
        WebBuilder().build(),
    ])
}

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
