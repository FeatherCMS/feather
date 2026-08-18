//
//  AccountApplicationTestSuite.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AccountDomain
import FeatherApplication
import FeatherContracts
import Foundation
import Testing

@testable import AccountApplication

@Suite
struct AccountApplicationTestSuite {

    @Test
    func exposesAllSettingsPermissions() {
        let settingsPermissions = SettingsPermissions.Settings
            .allPermissions()
        let allPermissions = SettingsPermissions.allPermissions()

        #expect(
            settingsPermissions == [
                SettingsPermissions.Settings.read,
                SettingsPermissions.Settings.update,
            ]
        )
        #expect(allPermissions == settingsPermissions)
    }

    @Test
    func getSettingsReturnsMappedDetailForAuthorizedSubject() async throws {
        let settings = makeSettings()
        let repository = MockSettingsRepository(result: settings)
        let query = MockTransactionExecutor(
            context: WriteSettings(settings: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [SettingsPermissions.Settings.read]
        )
        let useCase = GetSettings(
            authorizer: authorizer,
            query: query
        )

        let result = try await useCase.execute(
            subject: Subject(id: settings.userId),
            input: .init()
        )

        #expect(result.userId == settings.userId)
        #expect(result.language == settings.language)
        #expect(result.timezone == settings.timezone)
        #expect(result.pageSize == settings.pageSize)
        #expect(await repository.getCallCount == 1)
        #expect(await query.runCallCount == 1)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func getSettingsDoesNotQueryForForbiddenSubject() async throws {
        let repository = MockSettingsRepository(result: makeSettings())
        let query = MockTransactionExecutor(
            context: WriteSettings(settings: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [SettingsPermissions.Settings.update]
        )
        let useCase = GetSettings(
            authorizer: authorizer,
            query: query
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "account-1"),
                input: .init()
            )
        }

        #expect(await repository.getCallCount == 0)
        #expect(await query.runCallCount == 0)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func editSettingsUpdatesAndReturnsMappedDetailForAuthorizedSubject()
        async throws
    {
        let settings = makeSettings()
        let repository = MockSettingsRepository(result: settings)
        let transaction = MockTransactionExecutor(
            context: WriteSettings(settings: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [SettingsPermissions.Settings.update]
        )
        let useCase = EditSettings(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: settings.userId),
            input: .init(
                language: "de",
                timezone: "Europe/Berlin",
                pageSize: 50
            )
        )

        #expect(result.language == "de")
        #expect(result.timezone == "Europe/Berlin")
        #expect(result.pageSize == 50)
        #expect(await repository.getCallCount == 1)
        #expect(await repository.updateCallCount == 1)
        #expect(await repository.updatedModel?.language == "de")
        #expect(await repository.updatedModel?.timezone == "Europe/Berlin")
        #expect(await repository.updatedModel?.pageSize == 50)
        #expect(await transaction.runCallCount == 1)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func editSettingsDoesNotWriteForForbiddenSubject() async throws {
        let repository = MockSettingsRepository(result: makeSettings())
        let transaction = MockTransactionExecutor(
            context: WriteSettings(settings: repository)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [SettingsPermissions.Settings.read]
        )
        let useCase = EditSettings(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "account-1"),
                input: .init(
                    language: "de",
                    timezone: "Europe/Berlin",
                    pageSize: 50
                )
            )
        }

        #expect(await transaction.runCallCount == 0)
        #expect(await repository.updateCallCount == 0)
        #expect(await authorizer.canCallCount == 1)
    }

    private func makeSettings() -> Settings {
        Settings(
            userId: "account-1",
            language: "en",
            timezone: "UTC",
            pageSize: 20,
            createdAt: Date(timeIntervalSince1970: 1),
            updatedAt: Date(timeIntervalSince1970: 2)
        )
    }
}
