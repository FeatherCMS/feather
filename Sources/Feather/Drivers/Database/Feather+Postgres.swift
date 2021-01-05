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
    func usePostgresDatabase() {
        use(database: .postgres(hostname: Environment.fetch("DB_HOST"),
                                port: Int(Environment.get("DB_PORT") ?? "5432")!,
                                username: Environment.fetch("DB_USER"),
                                password: Environment.fetch("DB_PASS"),
                                database: Environment.fetch("DB_NAME")),
            databaseId: .psql)
        
    }
}
