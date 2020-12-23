//
//  main.swift
//  Feather
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import FeatherCore
import FluentSQLiteDriver
import LiquidLocalDriver

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

let dbconfig: DatabaseConfigurationFactory
let dbID: DatabaseID
switch Environment.get("DB_TYPE") {
case "mysql":
        dbconfig = .mysql(hostname: Environment.fetch("DB_HOST"),
                                              port: Int(Environment.get("DB_PORT") ?? "3306")!,
                                              username: Environment.fetch("DB_USER"),
                                              password: Environment.fetch("DB_PASS"),
                                              database: Environment.fetch("DB_NAME"),
                                              tlsConfiguration: .forClient(certificateVerification: .none))
        dbID = .mysql
    break
case "postgres":
        dbconfig = .postgres(hostname: Environment.fetch("DB_HOST"),
                              port: Int(Environment.get("DB_PORT") ?? "5432")!,
                              username: Environment.fetch("DB_USER"),
                              password: Environment.fetch("DB_PASS"),
                              database: Environment.fetch("DB_NAME"))
        dbID = .psql
    break
default:
    dbconfig = .sqlite(.file("db.sqlite"))
    dbID     = .sqlite
    break
}

var middleWare = true
if let provideMiddleWare = Environment.get("USE_FILE_MIDDLEWARE") {
    middleWare = Bool(provideMiddleWare) ?? true
}

/// # Required:
/// ~~~
/// BASE_URL="http://127.0.0.1:8080"
/// BASE_PATH="/Repo/feather"
/// ~~~
/// # Optional:
/// ~~~
/// MAX_BODYSIZE="10mb" (default) - Required format: XXmb
/// USE_FILE_MIDDLEWARE="true" (default) - Required format: true/false
///
/// DB_TYPE="mysql" # Available:  sqlite (default) / mysql / postgres
/// DB_HOST="127.0.0.1"
/// DB_USER="feather"
/// DB_PASS="feather"
/// DB_NAME="feather"
///
/// # Optional: For DB_TYPE = "mysql" | "postgres"
/// DB_PORT=3306 #  mysql: 3306 (default) - postgres: 5432(default)
/// ~~~
///

try feather.configure(database: dbconfig,
                      databaseId: dbID,
                      fileStorage: .local(publicUrl: Application.baseUrl, publicPath: Application.Paths.public, workDirectory: "assets"),
                      fileStorageId: .local,
                      maxUploadSize: ByteCount(stringLiteral: Environment.get("MAX_BODYSIZE") ?? "10mb"),
                      modules: [
                        SystemBuilder(),
                        UserBuilder(),
                        ApiBuilder(),
                        AdminBuilder(),
                        FrontendBuilder(),

                        FileBuilder(),
                        RedirectBuilder(),
                        BlogBuilder(),
                        AnalyticsBuilder(),
                        AggregatorBuilder(),
                        SponsorBuilder(),
                        SwiftyBuilder(),
                        MarkdownBuilder(),
                      ],
                      usePublicFileMiddleware: middleWare)

if feather.app.isDebug {
    try feather.reset(resourcesOnly: true)
}
try feather.start()
