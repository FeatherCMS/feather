//
//  AccountDomainTestSuite.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import Foundation
import Testing

@testable import AccountDomain

@Suite
struct AccountDomainTestSuite {

    @Test
    func createsSettingsWithCurrentDefaults() throws {
        let settings = try Settings.create(
            userId: "account-1",
        )

        #expect(settings.language == Settings.defaultLanguage)
        #expect(settings.timezone == Settings.defaultTimezone)
        #expect(settings.pageSize == Settings.defaultPageSize)
    }

    @Test
    func acceptsOnlySupportedPageSizes() throws {
        for pageSize in [10, 20, 50, 100] {
            _ = try Settings.create(
                userId: "account-1",
                timezone: "UTC",
                pageSize: pageSize
            )
        }

        #expect(throws: Settings.Error.self) {
            _ = try Settings.create(
                userId: "account-1",
                timezone: "UTC",
                pageSize: 25
            )
        }
    }

    @Test
    func rejectsInvalidTimezoneValues() {
        #expect(throws: Settings.Error.self) {
            _ = try Settings.create(
                userId: "account-1",
                timezone: "Not/A-Timezone"
            )
        }

        #expect(throws: Settings.Error.self) {
            _ = try Settings.create(
                userId: "account-1",
                timezone: ""
            )
        }

        #expect(throws: Settings.Error.self) {
            _ = try Settings.create(
                userId: "account-1",
                timezone: String(repeating: "A", count: 255)
            )
        }
    }

    @Test
    func rejectsInvalidUserIds() {
        #expect(throws: Settings.Error.self) {
            _ = try Settings.create(
                userId: ""
            )
        }
    }

    @Test
    func rejectsInvalidLanguageValues() {
        #expect(throws: Settings.Error.self) {
            _ = try Settings.create(
                userId: "account-1",
                language: ""
            )
        }

        #expect(throws: Settings.Error.self) {
            _ = try Settings.create(
                userId: "account-1",
                language: String(repeating: "A", count: 255)
            )
        }
    }

    @Test
    func updatesSettingsWithValidValues() throws {
        var settings = Settings(
            userId: "account-1",
            language: "en",
            timezone: "UTC",
            pageSize: 20,
            createdAt: .now,
            updatedAt: .now
        )

        try settings.update(
            language: "de",
            timezone: "Europe/Berlin",
            pageSize: 50
        )

        #expect(settings.language == "de")
        #expect(settings.timezone == "Europe/Berlin")
        #expect(settings.pageSize == 50)
    }

    @Test
    func rejectsInvalidValuesDuringUpdate() throws {
        var settings = Settings(
            userId: "account-1",
            language: "en",
            timezone: "UTC",
            pageSize: 20,
            createdAt: .now,
            updatedAt: .now
        )

        #expect(throws: Settings.Error.self) {
            try settings.update(
                language: "",
                timezone: "UTC",
                pageSize: 20
            )
        }

        #expect(throws: Settings.Error.self) {
            try settings.update(
                language: "en",
                timezone: "Not/A-Timezone",
                pageSize: 20
            )
        }

        #expect(throws: Settings.Error.self) {
            try settings.update(
                language: "en",
                timezone: "UTC",
                pageSize: 25
            )
        }
    }
}
