//
//  BlogInfrastructureTestSuite.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 07. 16.

import Testing

@testable import BlogInfrastructure

@Suite
struct BlogInfrastructureTestSuite {

    @Test
    func moduleIsReadyForInfrastructureFeatures() {
        _ = PostDatabaseRepository.self
    }
}
