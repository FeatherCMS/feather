public import BlogModule

//
//  AuthorLink.Query.Interface.swift
//  app-blog-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

extension AuthorLink.Query {
    public protocol Interface: Sendable {

        func find(
            id: String
        ) async throws -> AuthorLink.Detail.Output

        func list(
            authorId: String,
            query: AuthorLink.Search.Input.Query
        ) async throws -> AuthorLink.List.Output

        func count(
            authorId: String,
            query: AuthorLink.Search.Input.Query
        ) async throws -> Int
    }
}
