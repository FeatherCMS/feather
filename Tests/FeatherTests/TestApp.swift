//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 15..
//

import XCTest
import XCTFeather
import FeatherCore
@testable import Feather

open class TestApp: FeatherTestApp {

    open override func configure() throws {
        try super.configure()

        app.databases.use(.sqlite(.file(app.feather.paths.resources.path + "/db.sqlite")), as: .sqlite)
//        app.databases.use(.sqlite(.memory), as: .sqlite)
        
        app.fileStorages.use(.local(publicUrl: app.feather.baseUrl,
                                    publicPath: app.feather.paths.public.path,
                                    workDirectory: Feather.Directories.assets), as: .local)
    }
}
