//
//  UserInfrastructureTestSuite.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthApplication
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
import SystemInfrastructure
import Testing
import UserDomain
import UserInfrastructure

@testable import AuthInfrastructure

@Suite
struct AuthInfrastructureTestSuite {

    @Test
    func seedsGeneratedRootIdentityAndFiltersMagicLinksByUser() async throws {
        var tlsConfiguration = TLSConfiguration.makeClientConfiguration()
        tlsConfiguration.certificateVerification = .none

        let client = PostgresClient(
            configuration: .init(
                host: ProcessInfo.processInfo.environment["POSTGRES_HOST"]
                    ?? "127.0.0.1",
                port: Int(
                    ProcessInfo.processInfo.environment["POSTGRES_PORT"]
                        ?? "55434"
                ) ?? 55434,
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

        let database = DatabaseClientPostgres(
            client: client
        )
        let clientTask = Task {
            await client.run()
        }
        defer { clientTask.cancel() }
        try await Task.sleep(for: .milliseconds(25))

        try await database.withTransaction { connection in
            try await connection.run(
                query: #"""
                    DROP SCHEMA IF EXISTS public CASCADE;
                    """#
            ) { _ in }
            try await connection.run(
                query: #"""
                    CREATE SCHEMA public;
                    """#
            ) { _ in }

            let events = EventRegistry()
            let idGenerator = TestIDGenerator()
            let migrator = Migrator(
                migrations: [
                    SystemInfrastructure.TableMigration(connection: connection),
                    SystemInfrastructure.TableSeedMigration(
                        connection: connection,
                        events: events,
                        idGenerator: idGenerator
                    ),
                    UserInfrastructure.TableMigration(connection: connection),
                    UserInfrastructure.TableSeedMigration(
                        connection: connection,
                        events: events,
                        idGenerator: idGenerator
                    ),
                    AuthInfrastructure.TableMigration(connection: connection),
                    AuthInfrastructure.TableSeedMigration(
                        connection: connection,
                        idGenerator: idGenerator
                    ),
                ]
            )

            try await migrator.apply(on: connection)
            try await migrator.apply(on: connection)

            let context = DatabaseTransactionContext(
                connection: connection,
                idGenerator: idGenerator
            )

            _ = try await IdentityDatabaseRepository(context: context)
                .insert(
                    id: "user-2",
                    model: Identity.create(status: .active)
                )
            _ = try await CredentialTable(connection: connection)
                .save(
                    row: .init(
                        id: "credential-2",
                        userId: "user-2",
                        email: "user-2@example.com",
                        passwordHash: "hash",
                        createdAt: .distantPast,
                        updatedAt: .distantPast
                    )
                )
            _ = try await MagicLinkTable(connection: connection)
                .save(
                    row: .init(
                        id: "magic-link-2",
                        credentialId: "credential-2",
                        token: "token-user-2",
                        expiresAtInterval: 3600,
                        isPersistent: false,
                        isUsed: false
                    )
                )

            let magicLinks = try await MagicLinkDatabaseQueries(
                context: .init(connection: connection)
            )
            .list(
                query: .init(userId: "user-2")
            )
            #expect(magicLinks.items.map(\.id) == ["magic-link-2"])

            let rootIdentity = try await IdentityDatabaseRepository(
                context: context
            )
            .findRoot()

            #expect(rootIdentity != nil)
            #expect(rootIdentity?.id.isEmpty == false)
            #expect(rootIdentity?.id != "root")

            let rootCredential = try await CredentialDatabaseRepository(
                context: context
            )
            .findBy(userId: rootIdentity?.id ?? "")
            #expect(rootCredential != nil)
        }
    }
}

private struct TestIDGenerator: IDGenerator {
    func generate() -> String {
        "test-id"
    }
}
