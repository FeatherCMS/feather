//
//  Migration.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 02. 20.
//

import FeatherDatabase

public protocol Migration: Sendable {

    var id: String { get }

    func apply() async throws
    func revert() async throws
}

extension Migration {

    public var id: String {
        String(reflecting: type(of: self))
        //        String(describing: type(of: self))
    }
}

public protocol DatabaseMigration: Migration {
    var connection: any DatabaseConnection { get }

    func apply(
        on connection: any DatabaseConnection
    ) async throws

    func revert(
        on connection: any DatabaseConnection
    ) async throws
}

extension DatabaseMigration {

    public func apply() async throws {
        try await apply(on: connection)
    }

    public func revert() async throws {
        try await revert(on: connection)
    }

    public func revert(
        on connection: any DatabaseConnection
    ) async throws {}
}

public protocol DatabaseQueryMigration: DatabaseMigration {

    func buildApplyQuery() async throws -> DatabaseQuery

    func buildRevertQuery() async throws -> DatabaseQuery?
}

extension DatabaseQueryMigration {

    public func buildRevertQuery() async throws -> DatabaseQuery? { nil }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        try await connection.run(query: buildApplyQuery(), { _ in })
    }

    public func revert(
        on connection: any DatabaseConnection
    ) async throws {
        if let query = try await buildRevertQuery() {
            try await connection.run(query: query, { _ in })
        }
    }
}
