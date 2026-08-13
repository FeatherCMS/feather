//
//  VariableQueries.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

import FeatherApplication
import FeatherContracts

public protocol VariableQueries: Sendable {

    func get(
        _ id: String
    ) async throws -> String?

    func find(
        id: String
    ) async throws -> VariableDetail

    func list(
        query: VariableList.Query
    ) async throws -> VariableList

    func count(
        query: VariableList.Query
    ) async throws -> Int
}

extension VariableQueries {

    public func get(
        _ id: String
    ) async throws -> String? {
        try await list(
            query: .init(
                page: .init(size: 1, number: 1),
                search: id
            )
        )
        .items
        .first { $0.id == id }?
        .value
    }
}
