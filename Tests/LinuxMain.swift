//
//  LinuxMain.swift
//  theswiftdev.com
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

import XCTest
@testable import App

var tests = [XCTestCaseEntry]()
tests += AppTests.allTests()
XCTMain(tests)
