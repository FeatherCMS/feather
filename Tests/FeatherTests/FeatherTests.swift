//
//  File.swift
//
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

import XCTest
import XCTVapor
import Spec
import FluentSQLiteDriver
import LiquidLocalDriver
import FeatherCore
@testable import Feather


final class FeatherTests: XCTestCase {

    private func featherInstall() throws -> Feather {
        let feather = try Feather(env: .testing)
        try feather.configure(database: .sqlite(.memory),
                              databaseId: .sqlite,
                              fileStorage: .local(publicUrl: Application.baseUrl, publicPath: Application.Paths.public, workDirectory: "assets"),
                              fileStorageId: .local,
                              modules: [])

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
