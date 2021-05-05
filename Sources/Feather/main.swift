//
//  main.swift
//  Feather
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import FeatherCore

import RedirectModule
import BlogModule
//import AnalyticsModule
//import AggregatorModule
import SponsorModule
import SwiftyModule
import MarkdownModule


import FeatherCore

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }

/// use the right database driver based on the environment
switch Environment.get("DB_TYPE") {
case "mysql": Feather.useMySQLDatabase()
case "postgres": Feather.usePostgresDatabase()
default: Feather.useSQLiteDatabase(app)
}

Feather.useLocalFileStorage(app)

/// set max upload size
//feather.setMaxUploadSize(ByteCount(stringLiteral: Environment.get("MAX_UPLOAD_SIZE") ?? "10mb"))
//
//if Bool(Environment.get("USE_FILES_MIDDLEWARE") ?? "true")! {
//    feather.usePublicFileMiddleware()
//}
//
//if let hostname = Environment.get("SERVER_HOSTNAME") {
//    feather.app.http.server.configuration.hostname = hostname
//}

app.feather.use([
    RedirectBuilder().build(),
    BlogBuilder().build(),
//    AnalyticsBuilder().build(),
//    AggregatorBuilder().build(),
    SponsorBuilder().build(),
    SwiftyBuilder().build(),
    MarkdownBuilder().build(),
])

if app.isDebug {
    try Feather.resetPublicFiles(app)
    try Feather.copyTemplatesIfNeeded(app)
}

try Feather.boot(app)

try app.run()
