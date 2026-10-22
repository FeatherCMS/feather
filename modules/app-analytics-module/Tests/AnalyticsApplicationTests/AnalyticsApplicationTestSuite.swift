//
//  AnalyticsApplicationTestSuite.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 07. 16.

import Testing
import AnalyticsModule

@testable import AnalyticsApplication

@Suite
struct AnalyticsApplicationTestSuite {

    @Test
    func moduleIsReadyForApplicationFeatures() {
        _ = (any Log.Detail.Query.Interface).self
        _ = (any Log.List.Query.Interface).self
        _ = (any Log.Overview.Query.Interface).self
        _ = (any Log.Search.Query.Interface).self
    }
}
