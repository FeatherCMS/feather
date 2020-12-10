//
//  main.swift
//  Feather
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import FeatherCore
import FluentSQLiteDriver
import FluentPostgresDriver
import FluentMySQLDriver
import LiquidLocalDriver

import FileModule
import RedirectModule
import BlogModule
//import AnalyticsModule
//import AggregatorModule
import SponsorModule
import SwiftyModule
import MarkdownModule

let feather = try Feather()
defer { feather.stop() }

let dbconfig: DatabaseConfigurationFactory
let dbID: DatabaseID
switch Environment.get("DBTYPE") {
case "mysql":
        dbconfig = .mysql(hostname: Environment.fetch("SQL_HOST"),
                                             port: Int(Environment.get("SQL_PORT") ?? "3306")!,
                                             username: Environment.fetch("SQL_USER"),
                                             password: Environment.fetch("SQL_PASSWORD"),
                                             database: Environment.fetch("SQL_DATABASE"),
                                             tlsConfiguration: .forClient(certificateVerification: .none))
        dbID = .mysql
    break
case "postgres":
        dbconfig = .postgres(hostname: Environment.fetch("SQL_HOST"),
                             port: Int(Environment.get("SQL_PORT") ?? "5432")!,
                             username: Environment.fetch("SQL_USER"),
                             password: Environment.fetch("SQL_PASSWORD"),
                             database: Environment.fetch("SQL_DATABASE"))
        dbID = .psql
    break
default:
    dbconfig = .sqlite(.file("db.sqlite"))
    dbID     = .sqlite
    break
}

try feather.configure(database: dbconfig,
                      databaseId: dbID,
                      fileStorage: .local(publicUrl: Application.baseUrl, publicPath: Application.Paths.public, workDirectory: "assets"),
                      fileStorageId: .local,
                      modules: [
                        FileBuilder(),
                        RedirectBuilder(),
                        BlogBuilder(),
//                        AnalyticsBuilder(),
//                        AggregatorBuilder(),
                        SponsorBuilder(),
                        SwiftyBuilder(),
                        MarkdownBuilder(),
                      ])
try feather.start()
