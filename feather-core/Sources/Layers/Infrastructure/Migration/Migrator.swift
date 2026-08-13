//
//  Migrator.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 02. 20.
//

import FeatherDatabase
import Logging

public struct Migrator {

    public let migrations: [Migration]

    public init(
        migrations: [Migration]
    ) {
        self.migrations = migrations
    }

    // TODO: abstraction for fetching & storing migrations
    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        Logger.current.debug("Started new migrations.")

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
            Logger.current.trace(
                "Started migration.",
                metadata: [
                    "id": .string(migration.id)
                ]
            )

            do {
                try await migration.apply()
            }
            catch {
                Logger.current.error("\(error)")
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

            Logger.current.trace(
                "Finished migration.",
                metadata: [
                    "id": .string(migration.id)
                ]
            )
        }

        Logger.current.debug("Finished new migrations.")
    }
}
