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

final class FeatherApiTests: XCTestCase {

    func testApiStatus() async throws {
        let feather = TestApp()
        try feather.setUp()
        defer { feather.tearDown() }

        try feather.app.describe("API status should work")
            .get("/api/status/")
            .expect { res in
                XCTAssertEqual(res.status, .ok)
                XCTAssertEqual(res.body.string, "ok")
            }
            .test()

    }
}
