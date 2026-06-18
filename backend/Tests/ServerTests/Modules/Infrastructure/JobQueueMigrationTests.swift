import FeatherDatabase
import FeatherDatabasePostgres
import Environment
import JobsPostgres
import Logging
import Foundation
import NIOSSL
import PostgresNIO
import PostgresMigrations
import Testing

@Suite
struct JobQueueMigrationTests {

    @Test
    func jobQueueTablesAreMigrated() async throws {
        let databaseName = uniqueDatabaseName()
        try await createDatabase(named: databaseName)

        defer {
            Task {
                try? await dropDatabase(named: databaseName)
            }
        }

        try await withPostgresClient(database: databaseName) {
            client,
            database in
            let logger = Logger(label: "worker-tests")
            let migrations = DatabaseMigrations()

            _ = await PostgresJobQueue(
                client: client,
                migrations: migrations,
                configuration: .init(queueName: "worker-tests"),
                logger: logger
            )
            try await migrations.apply(
                client: client,
                groups: [.jobQueue],
                logger: logger,
                dryRun: false
            )

            try await database.withConnection { connection in
                let jobs = try await connection.run(
                    query: #"""
                        SELECT
                            to_regclass('swift_jobs.jobs')::text AS jobs_table,
                            to_regclass('swift_jobs.queues')::text AS queues_table,
                            to_regclass('swift_jobs.metadata')::text AS metadata_table;
                        """#
                ) { sequence in
                    guard let row = try await sequence.collect().first else {
                        throw TestError.missingRows
                    }

                    return (
                        jobs: try row.decode(
                            column: "jobs_table",
                            as: String?.self
                        ),
                        queues: try row.decode(
                            column: "queues_table",
                            as: String?.self
                        ),
                        metadata: try row.decode(
                            column: "metadata_table",
                            as: String?.self
                        )
                    )
                }

                #expect(jobs.jobs == "swift_jobs.jobs")
                #expect(jobs.queues == "swift_jobs.queues")
                #expect(jobs.metadata == "swift_jobs.metadata")
            }
        }
    }

    @Test
    func resetDropsWorkerSchemaAndMigrationState() async throws {
        let databaseName = uniqueDatabaseName()
        try await createDatabase(named: databaseName)

        defer {
            Task {
                try? await dropDatabase(named: databaseName)
            }
        }

        try await withPostgresClient(database: databaseName) {
            client,
            database in
            let logger = Logger(label: "worker-tests")
            let migrations = DatabaseMigrations()

            _ = await PostgresJobQueue(
                client: client,
                migrations: migrations,
                configuration: .init(queueName: "worker-tests"),
                logger: logger
            )
            try await migrations.apply(
                client: client,
                groups: [.jobQueue],
                logger: logger,
                dryRun: false
            )

            try await database.withConnection { connection in
                try await connection.run(
                    query: #"DROP SCHEMA IF EXISTS swift_jobs CASCADE;"#
                ) { _ in }
                try await connection.run(
                    query: #"DROP SCHEMA public CASCADE;"#
                ) { _ in }
                try await connection.run(
                    query: #"CREATE SCHEMA public;"#
                ) { _ in }

                let state = try await connection.run(
                    query: #"""
                        SELECT
                            to_regclass('swift_jobs.jobs')::text AS jobs_table,
                            to_regclass('_hb_pg_migrations')::text AS migrations_table;
                        """#
                ) { sequence in
                    guard let row = try await sequence.collect().first else {
                        throw TestError.missingRows
                    }

                    return (
                        jobs: try row.decode(
                            column: "jobs_table",
                            as: String?.self
                        ),
                        migrations: try row.decode(
                            column: "migrations_table",
                            as: String?.self
                        )
                    )
                }

                #expect(state.jobs == nil)
                #expect(state.migrations == nil)
            }
        }
    }
}

private func uniqueDatabaseName() -> String {
    let raw = UUID().uuidString.lowercased()
        .replacingOccurrences(of: "-", with: "_")
    return "test_worker_\(raw)"
}

private func createDatabase(
    named name: String
) async throws {
    try await withPostgresClient(database: "postgres") { _, database in
        try await database.withConnection { connection in
            try await connection.run(
                query: #"""
                    DROP DATABASE IF EXISTS "\#(unescaped: name)";
                    """#
            ) { _ in }
            try await connection.run(
                query: #"""
                    CREATE DATABASE "\#(unescaped: name)";
                    """#
            ) { _ in }
        }
    }
}

private func dropDatabase(
    named name: String
) async throws {
    try await withPostgresClient(database: "postgres") { _, database in
        try await database.withConnection { connection in
            try await connection.run(
                query: #"""
                    DROP DATABASE IF EXISTS "\#(unescaped: name)";
                    """#
            ) { _ in }
        }
    }
}

private func withPostgresClient(
    database: String,
    _ body:
        @escaping @Sendable (PostgresClient, DatabaseClientPostgres)
        async throws -> Void
) async throws {
    let config = testSystemConfig(database: database).database
    var tlsConfig = TLSConfiguration.makeClientConfiguration()
    if FileManager.default.fileExists(atPath: config.rootCAPath) {
        let rootCert = try NIOSSLCertificate.fromPEMFile(config.rootCAPath)
        tlsConfig.trustRoots = .certificates(rootCert)
        tlsConfig.certificateVerification = .fullVerification
    }
    else {
        tlsConfig.certificateVerification = .none
    }

    let client = PostgresClient(
        configuration: .init(
            host: config.host,
            port: config.port,
            username: config.user,
            password: config.password,
            database: config.database,
            tls: .require(tlsConfig)
        ),
        backgroundLogger: Logger(label: "worker-tests")
    )
    let databaseClient = DatabaseClientPostgres(
        client: client,
        logger: Logger(label: "worker-tests")
    )

    let clientTask = Task {
        await client.run()
    }
    defer { clientTask.cancel() }

    try await Task.sleep(for: .milliseconds(100))
    try await body(client, databaseClient)
}

private func testSystemConfig(
    database: String
) -> SystemConfig {
    .init(
        logger: .init(level: .warning, label: "worker-tests"),
        database: .init(
            host: "127.0.0.1",
            port: 5432,
            user: "postgres",
            password: "postgres",
            database: database,
            rootCAPath: "/certs/does-not-exist.pem"
        )
    )
}

private enum TestError: Error {
    case missingRows
}
