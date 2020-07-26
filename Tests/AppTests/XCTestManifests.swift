//
//  XCTestManifests.swift
//  theswiftdev.com
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AppTests.allTests),
        testCase(UserTests.allTests),
    ]
}
#endif
