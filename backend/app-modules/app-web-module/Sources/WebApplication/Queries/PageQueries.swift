//
//  File.swift
//  app-redirect-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

public protocol PageQueries: Sendable {

    func find(
        id: String
    ) async throws -> PageDetail

    func list(
        query: PageList.Query
    ) async throws -> PageList

    func count(
        query: PageList.Query
    ) async throws -> Int
}
