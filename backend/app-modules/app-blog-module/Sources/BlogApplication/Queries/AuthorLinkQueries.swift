//
//  File.swift
//  app-redirect-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

public protocol AuthorLinkQueries: Sendable {

    func find(
        id: String
    ) async throws -> AuthorLinkDetail

    func list(
        authorId: String,
        query: AuthorLinkList.Query
    ) async throws -> AuthorLinkList

    func count(
        authorId: String,
        query: AuthorLinkList.Query
    ) async throws -> Int
}
