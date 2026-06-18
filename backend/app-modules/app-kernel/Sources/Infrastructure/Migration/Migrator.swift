//
//  Migrator.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 02. 20..
//

import Logging
import FeatherDatabase

public struct Migrator {

    public let migrations: [Migration]
    public let logger: Logger

    public init(
        migrations: [Migration],
        logger: Logger
    ) {
        self.migrations = migrations
        self.logger = logger
    }

    // TODO: abstraction for fetching & storing migrations
    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        logger.debug("Started new migrations.")

        try await connection.run(
            query: #"""
                CREATE TABLE IF NOT EXISTS _migrations (
                    id TEXT PRIMARY KEY,
                    created_at TIMESTAMPTZ NOT NULL
                );
                """#
        ) { _ in }

        let existingIds = try await connection.run(
            query: #"""
                SELECT id FROM _migrations;
                """#
        ) {
            try await $0.collect()
                .map { try $0.decode(column: "id", as: String.self) }
        }

        let migrationsToRun = migrations.filter {
            !existingIds.contains($0.id)
        }

        for migration in migrationsToRun {
            logger.trace(
                "Started migration.",
                metadata: [
                    "id": .string(migration.id)
                ]
            )

            do {
                try await migration.apply()
            }
            catch {
                logger.error("\(error)")
                throw error
            }

            try await connection.run(
                query: #"""
                    INSERT INTO _migrations (
                        id,
                        created_at
                    )
                    VALUES (
                        \#(migration.id),
                        NOW()
                    );
                    """#
            ) { _ in }

            logger.trace(
                "Finished migration.",
                metadata: [
                    "id": .string(migration.id)
                ]
            )
        }

        logger.debug("Finished new migrations.")
    }
}
