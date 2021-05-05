//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 01. 05..
//

import FeatherCore
import FluentMySQLDriver

extension Feather {

    /// use the mysql database driver based on the environment
    static func useMySQLDatabase() {
        app.databases.use(.mysql(hostname: Environment.fetch("DB_HOST"),
                                           port: Int(Environment.get("DB_PORT") ?? "3306")!,
                                           username: Environment.fetch("DB_USER"),
                                           password: Environment.fetch("DB_PASS"),
                                           database: Environment.fetch("DB_NAME"),
                                           tlsConfiguration: .forClient(certificateVerification: .none)), as: .mysql)
    }
}
