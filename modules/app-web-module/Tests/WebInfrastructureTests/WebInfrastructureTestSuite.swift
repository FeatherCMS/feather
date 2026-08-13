//
//  WebInfrastructureTestSuite.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 07. 16.

import Testing

@testable import WebInfrastructure

@Suite
struct WebInfrastructureTestSuite {

    @Test
    func moduleIsReadyForInfrastructureFeatures() {
        _ = MetadataDatabaseRepository.self
    }
}
