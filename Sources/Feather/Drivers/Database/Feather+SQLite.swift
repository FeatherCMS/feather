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
    func useSQLiteDatabase() {
        use(database: .sqlite(.file("db.sqlite")), databaseId: .sqlite)
    }
}
