//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

import XCTVapor
@testable import App

final class UserTests: XCTestCase {

    static var allTests = [
        ("testUsers", testUsers),
    ]
    
    func testUsers() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "users") { res in
            XCTAssertContent([UserModel].self, res) {
                XCTAssertEqual($0.count, 0)
            }
        }
//            .test(.POST, "todos", json: Todo(title: "Test My App")) { res in
//            XCTAssertContent(Todo.self, res) {
//                XCTAssertNotNil($0.id)
//                XCTAssertEqual($0.title, "Test My App")
//            }
//        }.test(.GET, "todos") { res in
//            XCTAssertContent([Todo].self, res) {
//                XCTAssertEqual($0.count, 1)
//            }
//        }
    }
}

