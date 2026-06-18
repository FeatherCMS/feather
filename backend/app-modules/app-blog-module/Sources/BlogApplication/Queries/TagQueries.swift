//
//  File.swift
//  app-redirect-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

public protocol TagQueries: Sendable {

    func find(
        id: String
    ) async throws -> TagDetail

    func list(
        query: TagList.Query
    ) async throws -> TagList

    func count(
        query: TagList.Query
    ) async throws -> Int
}
