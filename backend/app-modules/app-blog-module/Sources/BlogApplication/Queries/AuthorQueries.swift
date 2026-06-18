//
//  File.swift
//  app-redirect-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

public protocol AuthorQueries: Sendable {

    func find(
        id: String
    ) async throws -> AuthorDetail

    func list(
        query: AuthorList.Query
    ) async throws -> AuthorList

    func count(
        query: AuthorList.Query
    ) async throws -> Int
}
