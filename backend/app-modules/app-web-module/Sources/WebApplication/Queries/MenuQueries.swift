//
//  File.swift
//  app-redirect-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

public protocol MenuQueries: Sendable {

    func find(
        id: String
    ) async throws -> MenuDetail

    func list(
        query: MenuList.Query
    ) async throws -> MenuList

    func count(
        query: MenuList.Query
    ) async throws -> Int
}
