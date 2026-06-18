//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 04. 26..
//

import Application
import Environment
import FeatherDatabase
import FeatherHTTP
import FeatherHTTPHummingbirdTesting
import HummingbirdTesting
import Infrastructure
import Logging

@testable import Server

struct TestRunner {

    struct TestSystem {
        let name: String
        let config: ServerConfig
        let logger: Logger
        let databaseClient: TestDatabaseClient
    }

    let system: TestSystem

    init(
        name: String = #function
    ) async throws {

        let databaseName: String = Self.safeDatabaseName(name)

        let testConfig: ServerConfig = .test(database: databaseName)

        let logger = {
            var logger = Logger(label: testConfig.system.logger.label)
            logger.logLevel = testConfig.system.logger.level
            return logger
        }()

        let databaseClient = TestDatabaseClient(
            config: testConfig.system.database,
            logger: logger
        )

        self.system = .init(
            name: databaseName,
            config: testConfig,
            logger: logger,
            databaseClient: databaseClient
        )
    }

    private static func safeDatabaseName(
        _ input: String
    ) -> String {
        let prefix = "test_"
        var result = ""

        for c in input {
            switch c {
            case "a"..."z", "0"..."9", "_":
                result.append(c)
            case "A"..."Z":
                result.append(c.lowercased())
            default:
                continue
            }
        }

        // Ensure not empty
        if result.isEmpty {
            let chars = Array(
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            )
            return prefix + String((0..<16).map { _ in chars.randomElement()! })
        }

        // Ensure it doesn't start with a digit
        if let first = result.first, first >= "0" && first <= "9" {
            result = "_" + result
        }

        // Enforce Postgres identifier length (63 bytes ≈ 63 ASCII chars here)
        if result.count > (63 - prefix.count) {
            result = String(result.prefix(63))
        }

        return prefix + result
    }

    func buildTestDatabase() async throws {
        let config: ServerConfig = .test(database: "postgres")

        let builder = TestDatabaseBuilder(
            client: .init(
                config: config.system.database,
                logger: system.logger
            )
        )

        try await builder.buildTestDatabase(named: system.name)
    }

    func setupCustomDatabase(
        _ block: @escaping @Sendable (any DatabaseClient) async throws -> Void
    ) async throws {
        try await buildTestDatabase()
        try await system.databaseClient.execute { database in
            try await block(database)
        }
    }

    func setupMigratedDatabase(
        _ block:
            @escaping @Sendable (any DatabaseConnection) async throws -> Void =
            { _ in }
    ) async throws {
        try await buildTestDatabase()

        let logger = system.logger
        try await system.databaseClient.execute { database in
            try await database.withConnection { connection in
                let migrator = Migrator(
                    migrations: buildTestMigrations(connection: connection),
                    logger: logger
                )
                try await migrator.apply(on: connection)
                try await block(connection)
            }
        }
    }

    @discardableResult
    func run<Output>(
        request: some RequestRepresentable,
        _ block: @escaping @Sendable (ResponseContext) async throws -> Output
    ) async throws -> Output {
        let server = try await buildTestServer(
            config: system.config,
            client: system.databaseClient,
            logger: system.logger
        )
        let executor = HummingbirdTestingHTTPExecutor(
            app: server,
            testingSetup: .router
        )

        return try await executor.withOperation(
            request: request,
            response: block
        )
    }
}
