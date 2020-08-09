//
//  EnvironmentTests.swift
//  
//
//  Created by Michael Critz on 8/9/20.
//

import XCTVapor
@testable import App

final class EnvironmentTests: XCTestCase {

    static var allTests = [
        ("testFetchEnvironmentValue", testFetchEnvironmentValue),
    ]
    
    func testFetchEnvironmentValue() throws {
        let key = "HOME"
        let value = Environment.get(key)
        XCTAssertEqual(value, Environment.fetch(key))
    }
}

