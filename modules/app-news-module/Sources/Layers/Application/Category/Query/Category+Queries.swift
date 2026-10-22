//
//  CategoryQueries.swift
//  app-news-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

public import NewsDomain

public protocol CategoryQueries: Sendable {
    func find(
        id: String
    ) async throws -> Category.Detail.Output

    func find(
        ids: [String]
    ) async throws -> [Category.Detail.Output]

    func list(
        query: Category.List.Input.Query
    ) async throws -> Category.List.Output

    func count(
        query: Category.List.Input.Query
    ) async throws -> Int
}
