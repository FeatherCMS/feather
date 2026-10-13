//
//  AnalyticsApplicationTestSuite.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 07. 16.

import Testing

@testable import AnalyticsApplication

@Suite
struct AnalyticsApplicationTestSuite {

    @Test
    func moduleIsReadyForApplicationFeatures() {
        _ = LogQueries.self
    }
}
