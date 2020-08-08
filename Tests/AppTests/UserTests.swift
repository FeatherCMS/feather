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
        ("testBadUserLogin", testBadUserLogin),
        ("testUserLogin", testUserLogin),
    ]
    
    fileprivate func login(_ req: inout XCTHTTPRequest, username: String, password: String) throws {
        guard let password = try? Bcrypt.hash(password) else {
            XCTFail("Could not Bcrypt password")
            throw HTTPClientError.cancelled
        }
        try req.content.encode([
            "email" : username,
            "password" : password
        ], as: .formData)
    }
    
    func testBadUserLogin() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.test(.POST, "login", beforeRequest: { req in
            try login(&req, username: "sneakyH4x0r@example.com", password: "supersneaky")
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .seeOther)
        })
    }
    
    func testUserLogin() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.test(.POST, "login/?redirect=admin", beforeRequest: { req in
            try login(&req, username: "feather@binarybirds.com", password: "FeatherCMS")
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }
    
    func testCaseInsensitveUserLogin() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.test(.POST, "login/?redirect=admin", beforeRequest: { req in
            try login(&req, username: "feAtHeR@BinArYBirDS.Com", password: "FeatherCMS")
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }
}

