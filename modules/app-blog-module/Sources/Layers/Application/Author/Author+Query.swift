//
//  Author+Query.swift
//  app-blog-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

public import BlogModule

extension Author {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Author.Detail.Output
            func list() async throws -> Author.List.Output
            func list(query: Author.Search.Input.Query) async throws
                -> Author.Search.Output
        }
    }
}
