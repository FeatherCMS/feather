//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 01. 05..
//

import FeatherCore
import FluentPostgresDriver

extension Feather {

    /// use the pssql database driver based on the environment
    static func usePostgresDatabase() {
        app.databases.use(.postgres(hostname: Environment.fetch("DB_HOST"),
                                    port: Int(Environment.get("DB_PORT") ?? "5432")!,
                                    username: Environment.fetch("DB_USER"),
                                    password: Environment.fetch("DB_PASS"),
                                    database: Environment.fetch("DB_NAME")), as: .psql)
        
    }
}
