//
//  AnalyticsInfrastructureTestSuite.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 07. 16.

import Testing

@testable import AnalyticsInfrastructure

@Suite
struct AnalyticsInfrastructureTestSuite {

    @Test
    func moduleIsReadyForInfrastructureFeatures() {
        _ = LogTable.self
    }
}
