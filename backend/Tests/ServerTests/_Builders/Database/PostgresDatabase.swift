//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 04. 26..
//

import FeatherDatabase

struct PostgresDatabase: Sendable {
    let connection: any DatabaseConnection

    func create(
        name: String
    ) async throws {
        try await connection.run(
            query: #"""
                CREATE DATABASE "\#(unescaped: name)";
                """#
        ) { _ in }
    }

    func create(
        name: String,
        from template: String
    ) async throws {
        try await connection.run(
            query: #"""
                CREATE DATABASE "\#(unescaped: name)"
                TEMPLATE "\#(unescaped: template)";
                """#
        ) { _ in }
    }

    func exists(
        name: String
    ) async throws -> Bool {
        try await connection.run(
            query: #"""
                SELECT EXISTS (
                    SELECT 1
                    FROM pg_database
                    WHERE datname = \#(name)
                ) AS database_exists;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return false
            }
            return try row.decode(
                column: "database_exists",
                as: Bool.self
            )
        }
    }

    func drop(
        name: String
    ) async throws {
        try await connection.run(
            query: #"""
                DROP DATABASE IF EXISTS "\#(unescaped: name)";
                """#
        ) { _ in }
    }
}
