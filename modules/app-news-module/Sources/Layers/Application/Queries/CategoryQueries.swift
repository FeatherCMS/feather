//
//  CategoryQueries.swift
//  app-news-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

public protocol CategoryQueries: Sendable {
    func find(
        id: String
    ) async throws -> CategoryDetail

    func list(
        query: CategoryList.Query
    ) async throws -> CategoryList

    func count(
        query: CategoryList.Query
    ) async throws -> Int
}
