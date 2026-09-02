//
//  ArticleRepository.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

public protocol ArticleRepository: Repository {

    func find(
        id: String
    ) async throws -> Article?

    func insert(
        _ model: Article.New
    ) async throws -> Article

    func update(
        _ model: Article
    ) async throws -> Article

    func removeCategory(
        id: String
    ) async throws

    func delete(
        ids: [String]
    ) async throws -> Bool
}
