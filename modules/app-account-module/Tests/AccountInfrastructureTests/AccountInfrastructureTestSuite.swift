//
//  AccountInfrastructureTestSuite.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AccountDomain
import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDatabasePostgres
import FeatherDomain
import FeatherInfrastructure
import Foundation
import Logging
import NIOSSL
import PostgresNIO
import Testing
import UserApplication

@testable import AccountInfrastructure

@Suite(.serialized)
struct AccountInfrastructureTestSuite {

    @Test
    func accountProfileMigrationAndRepositoryRoundTrip() async throws {
        var tlsConfiguration = TLSConfiguration.makeClientConfiguration()
        tlsConfiguration.certificateVerification = .none

        let client = PostgresClient(
            configuration: .init(
                host: ProcessInfo.processInfo.environment["POSTGRES_HOST"]
                    ?? "127.0.0.1",
                port: Int(
                    ProcessInfo.processInfo.environment["POSTGRES_PORT"]
                        ?? "55435"
                ) ?? 55435,
                username: ProcessInfo.processInfo.environment["POSTGRES_USER"]
                    ?? "postgres",
                password: ProcessInfo.processInfo.environment[
                    "POSTGRES_PASSWORD"
                ] ?? "postgres",
                database: ProcessInfo.processInfo.environment["POSTGRES_DB"]
                    ?? "postgres",
                tls: .require(tlsConfiguration)
            ),
            backgroundLogger: Logger.current
        )
        let database = DatabaseClientPostgres(client: client)
        let clientTask = Task { await client.run() }
        defer { clientTask.cancel() }
        try await Task.sleep(for: .milliseconds(25))

        try await database.withTransaction { connection in
            try await connection.run(
                query: #"DROP SCHEMA IF EXISTS public CASCADE;"#
            ) { _ in }
            try await connection.run(query: #"CREATE SCHEMA public;"#) { _ in }
            try await connection.run(
                query: #"CREATE TABLE user_identity (id TEXT PRIMARY KEY);"#
            ) { _ in }
            try await connection.run(
                query: #"INSERT INTO user_identity (id) VALUES ('account-1');"#
            ) { _ in }

            try await AccountInfrastructure.TableMigration(
                connection: connection
            )
            .apply(on: connection)

            var events = EventRegistry()
            EventHandlers.register(in: &events)
            _ = try await events.trigger(
                event: UserIdentityDidInsert(identityID: "account-1"),
                using: DatabaseTransactionContext(
                    connection: connection,
                    idGenerator: TestIDGenerator()
                )
            )
            _ = try await events.trigger(
                event: UserIdentityDidInsert(identityID: "account-1"),
                using: DatabaseTransactionContext(
                    connection: connection,
                    idGenerator: TestIDGenerator()
                )
            )

            let repository = AccountProfileDatabaseRepository(
                context: .init(
                    connection: connection,
                    idGenerator: TestIDGenerator()
                )
            )

            var profile = try await repository.get(userId: "account-1")
            #expect(profile.firstName == nil)
            #expect(profile.lastName == nil)
            #expect(profile.imageURL == nil)

            try profile.update(
                firstName: "Ada",
                lastName: "Lovelace",
                imageURL: "https://example.com/ada.png"
            )
            let updated = try await repository.update(profile)

            #expect(updated.firstName == "Ada")
            #expect(updated.lastName == "Lovelace")
            #expect(updated.imageURL == "https://example.com/ada.png")
            let persisted = try await repository.get(userId: "account-1")
            #expect(persisted.firstName == "Ada")

            let invitation = try await InvitationTable(connection: connection)
                .save(
                    row: .init(
                        id: "invitation-1",
                        userId: "account-1",
                        email: "invite@example.com",
                        token: "token-123456",
                        roleIDs: ["role-editor", "role-author"],
                        expiresAtInterval: 3600
                    )
                )
            let persistedInvitation = try await InvitationTable(
                connection: connection
            )
            .find(token: invitation.token)
            #expect(
                persistedInvitation?.roleIDs == ["role-editor", "role-author"]
            )

        }

        try await database.withTransaction { connection in
            let repository = AccountProfileDatabaseRepository(
                context: .init(
                    connection: connection,
                    idGenerator: TestIDGenerator()
                )
            )
            await #expect(throws: Error.self) {
                try await repository.create(userId: "account-1")
            }
        }
    }
}

private struct TestIDGenerator: IDGenerator {
    func generate() -> String { "profile-id" }
}
