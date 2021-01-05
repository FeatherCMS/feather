//
//  main.swift
//  Feather
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import FeatherCore

import SystemModule
import UserModule
import ApiModule
import AdminModule
import FrontendModule

import FileModule
import RedirectModule
import BlogModule
import AnalyticsModule
import AggregatorModule
import SponsorModule
import SwiftyModule
import MarkdownModule

/// setup metadata delegate object
Feather.metadataDelegate = FrontendMetadataDelegate()

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let feather = try Feather(env: env)
defer { feather.stop() }

/// use the right database driver based on the environment
switch Environment.get("DB_TYPE") {
case "mysql": feather.useMySQLDatabase()
case "postgres": feather.usePostgresDatabase()
default: feather.useSQLiteDatabase()
}

/// use local file storage driver
feather.useLocalFileStorage()

/// set max upload size
feather.setMaxUploadSize(ByteCount(stringLiteral: Environment.get("MAX_UPLOAD_SIZE") ?? "10mb"))

if Bool(Environment.get("USE_FILES_MIDDLEWARE") ?? "true")! {
    feather.usePublicFileMiddleware()
}

try feather.configure([
    /// core
    SystemBuilder(),
    UserBuilder(),
    ApiBuilder(),
    AdminBuilder(),
    FrontendBuilder(),
    /// other
    FileBuilder(),
    RedirectBuilder(),
    BlogBuilder(),
    AnalyticsBuilder(),
    AggregatorBuilder(),
    SponsorBuilder(),
    SwiftyBuilder(),
    MarkdownBuilder(),
])

/// reset resources folder if we're in debug mode
if feather.app.isDebug {
    try feather.reset(resourcesOnly: true)
}

try feather.start()
