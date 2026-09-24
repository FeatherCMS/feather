//
//  ArticleQueries.swift
//  app-news-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

public protocol ArticleQueries: Sendable {
    func find(
        id: String
    ) async throws -> ArticleDetail

    func categoryIDs(
        for articleIDs: [String]
    ) async throws -> [String: [String]]

    func list(
        query: ArticleList.Query
    ) async throws -> ArticleList

    func listPublic(
        query: ArticleList.Query,
        categoryID: String?
    ) async throws -> ArticleList

    func count(
        query: ArticleList.Query
    ) async throws -> Int

    func countPublic(
        query: ArticleList.Query,
        categoryID: String?
    ) async throws -> Int
}
