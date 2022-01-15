//
//  File.swift
//
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

import XCTest
import XCTFeather
import FeatherCore
@testable import Feather

final class FeatherTests: XCTestCase {

    func testHomeScreen() async throws {
        let feather = TestApp()
        try feather.setUp()
        defer { feather.tearDown() }

        try feather.app.describe("Home screen should work")
            .get("/")
            .expect { res in
                XCTAssertEqual(res.status, .ok)
            }
            .test()

    }
    
    func testAuthentication() async throws {
        let feather = TestApp()
        try feather.setUp()
        defer { feather.tearDown() }

        try feather.authenticate()
        try feather.app.describe("Admin screen should work")
            .get("/admin/")
            .cookie(feather.cookies)
            .expect { res in
                XCTAssertEqual(res.status, .ok)
            }
            .test()

    }
}
