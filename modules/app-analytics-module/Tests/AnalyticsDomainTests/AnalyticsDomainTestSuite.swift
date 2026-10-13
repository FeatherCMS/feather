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

    @Test
    func logRejectsInvalidResponseCode() {
        #expect(throws: Log.Error.invalidResponseCode) {
            try Log.create(
                accountId: nil,
                source: .backendAPI,
                method: "GET",
                url: "/health",
                headers: "{}",
                ip: nil,
                path: "/health",
                referer: nil,
                origin: nil,
                acceptLanguage: nil,
                userAgent: nil,
                language: nil,
                region: nil,
                osName: nil,
                osVersion: nil,
                browserName: nil,
                browserVersion: nil,
                engineName: nil,
                engineVersion: nil,
                deviceVendor: nil,
                deviceType: nil,
                deviceModel: nil,
                cpu: nil,
                responseCode: 600
            )
        }
    }
}
