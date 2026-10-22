public import BlogModule

//
//  Post.Query.Interface.swift
//  app-blog-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

extension Post.Query {
    public protocol Interface: Sendable {

        func find(
            id: String
        ) async throws -> Post.Detail.Output

        func list(
            query: Post.Search.Input.Query
        ) async throws -> Post.List.Output

        func count(
            query: Post.Search.Input.Query
        ) async throws -> Int
    }
}
