//
//  File.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

public protocol VariableQueries: Sendable {

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
