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
        ("testLoginView", testLoginView),
        ("testLogout", testLogout),
    ]
    
    fileprivate let htmlMediaType = HTTPMediaType(type: "text", subType: "html")
    fileprivate let loginPath = "login/?redirect=admin"
    
    func testLoginView() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "/login/",
                     afterResponse:  { res in
            guard let contentType = res.content.contentType else {
                XCTFail("Content must have a contentType")
                return
            }
            XCTAssertEqual(contentType, htmlMediaType)
            XCTAssertEqual(res.status, .ok)
        })
    }
    
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
        
        try app.test(.POST, loginPath, beforeRequest: { req in
            try login(&req, username: "feather@binarybirds.com", password: "FeatherCMS")
        }, afterResponse: { res in
            XCTAssertTrue(res.headers.setCookie != nil)
            XCTAssertEqual(res.status, .ok)
        })
    }
    
    func testCaseInsensitveUserLogin() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.test(.POST, loginPath, beforeRequest: { req in
            try login(&req, username: "feAtHeR@BinArYBirDS.Com", password: "FeatherCMS")
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }
    
    func testLogout() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        var sessionCookie = HTTPCookies.Value(stringLiteral: "")
        
        try app.test(.POST, loginPath,
                     beforeRequest: { req in
                        try login(&req, username: "feather@binarybirds.com", password: "FeatherCMS")
                     },
                     afterResponse: { res in
                        guard let firstCookie = res.headers.setCookie?["vapor-session"] else {
                            XCTFail("no Session cookie")
                            return
                        }
                        sessionCookie = firstCookie
                     }
        )
        
        try app.test(.GET, "logout", beforeRequest: { req in
            req.headers.setCookie?["vapor-session"] = sessionCookie
        },
        afterResponse: { res in
            let retrievedCookie = res.headers.setCookie?["vapor-session"]
            XCTAssertNil(retrievedCookie,
                         "No session cookie should exist after logout")
        })
        
        try app.test(.GET, "admin", beforeRequest: { req in
            req.headers.setCookie?["vapor-session"] = sessionCookie
        },
        afterResponse: { res in
            XCTAssertNotEqual(res.status, .ok,
                              "Should not be able to access a secured path after logout")
        })
    }
}

