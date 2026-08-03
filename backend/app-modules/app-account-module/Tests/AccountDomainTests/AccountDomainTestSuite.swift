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
        let settings = try AccountSettings.create(
            id: "settings-1",
            accountID: "account-1",
        )

        #expect(settings.language == AccountSettings.defaultLanguage)
        #expect(settings.timezone == AccountSettings.defaultTimezone)
        #expect(settings.pageSize == AccountSettings.defaultPageSize)
    }

    @Test
    func acceptsOnlySupportedPageSizes() throws {
        for pageSize in [10, 20, 50, 100] {
            _ = try AccountSettings.create(
                id: "settings-\(pageSize)",
                accountID: "account-1",
                timezone: "UTC",
                pageSize: pageSize
            )
        }

        #expect(throws: AccountSettings.Error.self) {
            _ = try AccountSettings.create(
                id: "settings-invalid",
                accountID: "account-1",
                timezone: "UTC",
                pageSize: 25
            )
        }
    }

    @Test
    func rejectsInvalidTimezoneValues() {
        #expect(throws: AccountSettings.Error.self) {
            _ = try AccountSettings.create(
                id: "settings-invalid",
                accountID: "account-1",
                timezone: "Not/A-Timezone"
            )
        }

        #expect(throws: AccountSettings.Error.self) {
            _ = try AccountSettings.create(
                id: "settings-empty-timezone",
                accountID: "account-1",
                timezone: ""
            )
        }

        #expect(throws: AccountSettings.Error.self) {
            _ = try AccountSettings.create(
                id: "settings-long-timezone",
                accountID: "account-1",
                timezone: String(repeating: "A", count: 255)
            )
        }
    }

    @Test
    func rejectsInvalidAccountIDs() {
        #expect(throws: AccountSettings.Error.self) {
            _ = try AccountSettings.create(
                id: "settings-invalid-account",
                accountID: ""
            )
        }
    }

    @Test
    func rejectsInvalidLanguageValues() {
        #expect(throws: AccountSettings.Error.self) {
            _ = try AccountSettings.create(
                id: "settings-empty-language",
                accountID: "account-1",
                language: ""
            )
        }

        #expect(throws: AccountSettings.Error.self) {
            _ = try AccountSettings.create(
                id: "settings-long-language",
                accountID: "account-1",
                language: String(repeating: "A", count: 255)
            )
        }
    }

    @Test
    func updatesSettingsWithValidValues() throws {
        var settings = AccountSettings(
            id: "settings-1",
            accountID: "account-1",
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
        var settings = AccountSettings(
            id: "settings-1",
            accountID: "account-1",
            language: "en",
            timezone: "UTC",
            pageSize: 20,
            createdAt: .now,
            updatedAt: .now
        )

        #expect(throws: AccountSettings.Error.self) {
            try settings.update(
                language: "",
                timezone: "UTC",
                pageSize: 20
            )
        }

        #expect(throws: AccountSettings.Error.self) {
            try settings.update(
                language: "en",
                timezone: "Not/A-Timezone",
                pageSize: 20
            )
        }

        #expect(throws: AccountSettings.Error.self) {
            try settings.update(
                language: "en",
                timezone: "UTC",
                pageSize: 25
            )
        }
    }
}
