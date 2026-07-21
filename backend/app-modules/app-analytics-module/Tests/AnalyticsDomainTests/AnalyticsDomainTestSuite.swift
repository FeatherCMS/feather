//
//  AnalyticsDomainTestSuite.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 07. 16.

import Testing

@testable import AnalyticsDomain

@Suite
struct AnalyticsDomainTestSuite {

    @Test
    func moduleIsReadyForDomainFeatures() {
        _ = Log.self
    }
}
