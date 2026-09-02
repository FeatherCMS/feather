//
//  AuthorLinkRepository.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

public protocol AuthorLinkRepository: Repository {

    func find(
        id: String
    ) async throws -> AuthorLink?

    func insert(
        _ model: AuthorLink.New
    ) async throws -> AuthorLink

    func update(
        _ model: AuthorLink
    ) async throws -> AuthorLink

    func delete(ids: [String]) async throws -> [String]
}
