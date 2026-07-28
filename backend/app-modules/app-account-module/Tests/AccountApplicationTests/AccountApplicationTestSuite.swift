//
//  AccountApplicationTestSuite.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AccountDomain
import Application
import Foundation
import Testing

@testable import AccountApplication

@Suite
struct AccountApplicationTestSuite {

    @Test
    func exposesAllAccountSettingsPermissions() {
        let settingsPermissions = AccountSettingsPermissions.Settings
            .allPermissions()
        let allPermissions = AccountSettingsPermissions.allPermissions()

        #expect(
            settingsPermissions == [
                AccountSettingsPermissions.Settings.read,
                AccountSettingsPermissions.Settings.update,
            ]
        )
        #expect(allPermissions == settingsPermissions)
    }

    @Test
    func getSettingsReturnsMappedDetailForAuthorizedSubject() async throws {
        let settings = makeSettings()
        let queries = MockAccountSettingsQueries(result: settings)
        let query = MockQueryExecutor(
            context: ReadAccountSettings(settings: queries)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountSettingsPermissions.Settings.read]
        )
        let useCase = GetAccountSettings(
            authorizer: authorizer,
            query: query
        )

        let result = try await useCase.execute(
            subject: Subject(id: settings.accountID),
            input: .init()
        )

        #expect(result.id == settings.id)
        #expect(result.accountID == settings.accountID)
        #expect(result.language == settings.language)
        #expect(result.timezone == settings.timezone)
        #expect(result.pageSize == settings.pageSize)
        #expect(await queries.getCallCount == 1)
        #expect(await query.runCallCount == 1)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func getSettingsDoesNotQueryForForbiddenSubject() async throws {
        let queries = MockAccountSettingsQueries(result: makeSettings())
        let query = MockQueryExecutor(
            context: ReadAccountSettings(settings: queries)
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountSettingsPermissions.Settings.update]
        )
        let useCase = GetAccountSettings(
            authorizer: authorizer,
            query: query
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "account-1"),
                input: .init()
            )
        }

        #expect(await queries.getCallCount == 0)
        #expect(await query.runCallCount == 0)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func editSettingsUpdatesAndReturnsMappedDetailForAuthorizedSubject()
        async throws
    {
        let settings = makeSettings()
        let queries = MockAccountSettingsQueries(result: settings)
        let repository = MockAccountSettingsRepository(result: settings)
        let transaction = MockTransactionExecutor(
            context: WriteAccountSettings(
                queries: queries,
                settings: repository
            )
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountSettingsPermissions.Settings.update]
        )
        let useCase = EditAccountSettings(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: settings.accountID),
            input: .init(
                language: "de",
                timezone: "Europe/Berlin",
                pageSize: 50
            )
        )

        #expect(result.language == "de")
        #expect(result.timezone == "Europe/Berlin")
        #expect(result.pageSize == 50)
        #expect(await queries.getCallCount == 1)
        #expect(await repository.updateCallCount == 1)
        #expect(await repository.updatedModel?.language == "de")
        #expect(await repository.updatedModel?.timezone == "Europe/Berlin")
        #expect(await repository.updatedModel?.pageSize == 50)
        #expect(await transaction.runCallCount == 1)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func editSettingsDoesNotWriteForForbiddenSubject() async throws {
        let queries = MockAccountSettingsQueries(result: makeSettings())
        let repository = MockAccountSettingsRepository(result: makeSettings())
        let transaction = MockTransactionExecutor(
            context: WriteAccountSettings(
                queries: queries,
                settings: repository
            )
        )
        let authorizer = MockPermissionAuthorizer(
            permissions: [AccountSettingsPermissions.Settings.read]
        )
        let useCase = EditAccountSettings(
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

    private func makeSettings() -> AccountSettings {
        AccountSettings(
            id: "settings-1",
            accountID: "account-1",
            language: "en",
            timezone: "UTC",
            pageSize: 20,
            createdAt: Date(timeIntervalSince1970: 1),
            updatedAt: Date(timeIntervalSince1970: 2)
        )
    }
}
