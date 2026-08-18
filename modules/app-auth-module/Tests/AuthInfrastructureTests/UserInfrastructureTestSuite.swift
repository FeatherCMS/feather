//
//  UserInfrastructureTestSuite.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherDatabasePostgres
import FeatherApplication
import FeatherContracts
import FeatherDomain
import FeatherInfrastructure
import Foundation
import Logging
import NIOSSL
import PostgresNIO
import SystemInfrastructure
import Testing
import UserInfrastructure

@testable import AuthInfrastructure

@Suite
struct AuthInfrastructureTestSuite {

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

            let permissionIds = try await connection.run(
                query: #"""
                    SELECT id
                    FROM system_permission
                    ORDER BY id;
                    """#
            ) { sequence in
                try await sequence.collect()
                    .map {
                        try $0.decode(column: "id", as: String.self)
                    }
            }

            let rootPermissionIds = try await connection.run(
                query: #"""
                    SELECT permission_id
                    FROM auth_role_permission
                    WHERE role_id = 'root'
                    ORDER BY permission_id;
                    """#
            ) { sequence in
                try await sequence.collect()
                    .map {
                        try $0.decode(column: "permission_id", as: String.self)
                    }
            }

            #expect(Set(rootPermissionIds) == Set(permissionIds))
        }
    }
}

private struct TestIDGenerator: IDGenerator {
    func generate() -> String {
        "test-id"
    }
}
