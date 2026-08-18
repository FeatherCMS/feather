//
//  BlogApplicationTestSuite.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 07. 16.

import Testing

@testable import BlogApplication

@Suite
struct BlogApplicationTestSuite {

    @Test
    func moduleIsReadyForApplicationFeatures() {
        _ = GetPost.self
    }
}
