//
//  UserInfrastructureTestSuite.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

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

@testable import UserInfrastructure

@Suite
struct UserInfrastructureTestSuite {

    @Test
    func example() async throws {
        var tlsConfiguration = TLSConfiguration.makeClientConfiguration()
        tlsConfiguration.certificateVerification = .none

        let client = PostgresClient(
            configuration: .init(
                host: ProcessInfo.processInfo.environment["POSTGRES_HOST"]
                    ?? "127.0.0.1",
                port: Int(
                    ProcessInfo.processInfo.environment["POSTGRES_PORT"]
                        ?? "55433"
                ) ?? 55433,
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

            var events = EventRegistry()
            UserEventHandlers.register(in: &events)

            let migrator = Migrator(
                migrations: [
                    UserInfrastructure.TableMigration(connection: connection),
                    UserInfrastructure.TableSeedMigration(
                        connection: connection,
                        events: events,
                        idGenerator: TestIDGenerator()
                    ),
                ]
            )

            try await migrator.apply(on: connection)
        }
    }
}

private struct TestIDGenerator: IDGenerator {
    func generate() -> String {
        "test-id"
    }
}
