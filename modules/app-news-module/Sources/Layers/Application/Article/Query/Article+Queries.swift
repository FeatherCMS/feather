//
//  ArticleQueries.swift
//  app-news-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

public import NewsDomain

public protocol ArticleQueries: Sendable {
    func find(
        id: String
    ) async throws -> Article.Detail.Output

    func categoryIDs(
        for articleIDs: [String]
    ) async throws -> [String: [String]]

    func resolve(
        ids: [String]
    ) async throws -> Article.List.Output

    func list(
        query: Article.List.Input.Query
    ) async throws -> Article.List.Output

    func listPublic(
        query: Article.List.Input.Query,
        categoryID: String?
    ) async throws -> Article.List.Output

    func listPublicRelated(
        categoryIDs: [String],
        excludingArticleID: String,
        limit: Int
    ) async throws -> Article.List.Output

    func count(
        query: Article.List.Input.Query
    ) async throws -> Int

    func countPublic(
        query: Article.List.Input.Query,
        categoryID: String?
    ) async throws -> Int
}
