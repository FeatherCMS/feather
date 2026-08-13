//
//  BlogDomainTestSuite.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 07. 16.

import Testing

@testable import BlogDomain

@Suite
struct BlogDomainTestSuite {

    @Test
    func moduleIsReadyForDomainFeatures() {
        _ = Author.self
    }
}
