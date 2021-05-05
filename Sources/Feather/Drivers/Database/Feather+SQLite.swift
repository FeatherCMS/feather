//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 01. 05..
//

import FeatherCore
import FluentSQLiteDriver

extension Feather {

    /// use the sqlite database driver
    static func useSQLiteDatabase(_ app: Application) {
        app.databases.use(.sqlite(.file("Resources/db.sqlite")), as: .sqlite)
    }
}
