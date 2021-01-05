//
//  File.swift
//
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

import XCTest
import XCTVapor
import Spec
import FeatherCore
import FluentSQLiteDriver
import LiquidLocalDriver
import SystemModule
import UserModule
import ApiModule
import AdminModule
import FrontendModule

final class FeatherTests: XCTestCase {

    private func featherInstall() throws -> Feather {
        let feather = try Feather(env: .testing)
        feather.setMaxUploadSize("10mb")
        feather.usePublicFileMiddleware()
        feather.use(database: .sqlite(.memory), databaseId: .sqlite)
        feather.use(fileStorage: .local(publicUrl: Application.baseUrl,
                                        publicPath: Application.Paths.public,
                                        workDirectory: "assets"),
                    fileStorageId: .local)

        try feather.configure([
            SystemBuilder(),
            UserBuilder(),
            ApiBuilder(),
            AdminBuilder(),
            FrontendBuilder(),
        ])
        try feather.app.describe("System install must succeed")
            .get("/system/install/")
            .expect(.ok)
            .expect(.html)
            .test(.inMemory)

        return feather
    }
    
    func testSystemInstall() throws {
        let feather = try featherInstall()
        defer { feather.stop() }

        try feather.app.describe("Welcome page must present after install")
            .get("/")
            .expect(.ok)
            .expect(.html)
            .expect { value in
                XCTAssertTrue(value.body.string.contains("Welcome"))
            }
            .test(.inMemory)
    }
}
