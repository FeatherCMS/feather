//
//  Feather+DataBases.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 13..
//

import FeatherCore
import LiquidLocalDriver
import FluentMySQLDriver
import FluentPostgresDriver
import FluentSQLiteDriver

extension Feather {
    
    ///
    /// This function will autoconfigure  the instance using system environment  variables
    ///
    ///  Using this fonction require the system `ENVIRONEMENT variables` to be set OR an env.`<environement>` file.
    /// # Reference:
    /// For more details on how to use env.`<environement>` file, refer to the [Vapor 4 documentation](https://docs.vapor.codes/4.0/environment)
    ///
    /// # Required:
    /// ~~~
    /// BASE_URL="http://127.0.0.1:8080"
    /// BASE_PATH="/Repo/feather"
    /// ~~~
    /// # Optional:
    /// ~~~
    /// MAX_BODYSIZE="10mb" (default) - Required format: XXmb
    /// PROVIDE_MIDDLEWARE="true" (default) - Required format: true/false
    ///
    /// DBTYPE="mysql" # Available:  sqlite (default) / mysql / postgres
    /// SQL_HOST="127.0.0.1"
    /// SQL_USER="feather"
    /// SQL_PASSWORD="feather"
    /// SQL_DATABASE="feather"
    ///
    /// # Optional: For DBTYPE = "mysql" | "postgres"
    /// SQL_PORT=3306 #  mysql: 3306 (default) - postgres: 5432(default)
    /// ~~~
    ///

    /// - Throws: `Error` due to `modules` registration
    ///
    /// - parameters:
    ///     - modules: An Array containing intances of type [ViperBuilder](https://github.com/BinaryBirds/viper-kit)
    ///
    public func configureWithEnv(modules userModules: [ViperBuilder] = []) throws {
        
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
        
        var middleWare = true
        if let provideMiddleWare = Environment.get("PROVIDE_MIDDLEWARE") {
            middleWare = Bool(provideMiddleWare) ?? true
        }
        try feather.configure(database: dbconfig,
                              databaseId: dbID,
                              fileStorage: .local(publicUrl: Application.baseUrl, publicPath: Application.Paths.public, workDirectory: "assets"),
                              fileStorageId: .local,
                              maxUploadSize: ByteCount(stringLiteral: Environment.get("MAX_BODYSIZE") ?? "10mb"),
                              modules: userModules,
                              usePublicFileMiddleware: middleWare
                              )
    }
    
}
