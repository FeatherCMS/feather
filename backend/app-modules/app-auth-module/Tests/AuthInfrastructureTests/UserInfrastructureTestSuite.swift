import Testing
import Logging
import Infrastructure
import FeatherDatabase
import FeatherDatabasePostgres
import Foundation
import NIOSSL
import PostgresNIO
import SystemInfrastructure
import UserInfrastructure

@testable import AuthInfrastructure

@Suite
struct AuthInfrastructureTestSuite {

    @Test
    func example() async throws {
        var logger = Logger(label: "test")
        logger.logLevel = .info

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
            backgroundLogger: logger
        )

        let database = DatabaseClientPostgres(
            client: client,
            logger: logger
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

            let migrator = Migrator(
                migrations: [
                    SystemInfrastructure.TableMigration(connection: connection),
                    SystemInfrastructure.TableSeedMigration(
                        connection: connection
                    ),
                    UserInfrastructure.TableMigration(connection: connection),
                    UserInfrastructure.TableSeedMigration(
                        connection: connection
                    ),
                    AuthInfrastructure.TableMigration(connection: connection),
                    AuthInfrastructure.TableSeedMigration(
                        connection: connection
                    ),
                ],
                logger: logger
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
