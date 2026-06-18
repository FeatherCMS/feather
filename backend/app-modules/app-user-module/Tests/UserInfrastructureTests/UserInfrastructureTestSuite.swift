import Testing
import Logging
import Infrastructure
import FeatherDatabase
import FeatherDatabasePostgres
import Foundation
import NIOSSL
import PostgresNIO

@testable import UserInfrastructure

@Suite
struct UserInfrastructureTestSuite {

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
                    UserInfrastructure.TableMigration(connection: connection),
                    UserInfrastructure.TableSeedMigration(
                        connection: connection
                    ),
                ],
                logger: logger
            )

            try await migrator.apply(on: connection)
        }
    }
}
