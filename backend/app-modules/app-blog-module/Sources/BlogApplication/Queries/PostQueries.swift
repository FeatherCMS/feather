//
//  File.swift
//  app-redirect-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

public protocol PostQueries: Sendable {

    func find(
        id: String
    ) async throws -> PostDetail

    func list(
        query: PostList.Query
    ) async throws -> PostList

    func count(
        query: PostList.Query
    ) async throws -> Int
}
