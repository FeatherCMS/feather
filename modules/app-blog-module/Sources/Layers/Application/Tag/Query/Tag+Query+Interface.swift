public import BlogModule

//
//  Tag.Query.Interface.swift
//  app-blog-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

extension Tag.Query {
    public protocol Interface: Sendable {

        func find(
            id: String
        ) async throws -> Tag.Detail.Output

        func list(
            query: Tag.Search.Input.Query
        ) async throws -> Tag.List.Output

        func count(
            query: Tag.Search.Input.Query
        ) async throws -> Int
    }
}
