//
//  File.swift
//  app-redirect-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

public protocol RuleQueries: Sendable {
    func find(
        source: String
    ) async throws -> RuleDetail?

    func find(
        id: String
    ) async throws -> RuleDetail

    func list(
        query: RuleList.Query
    ) async throws -> RuleList

    func count(
        query: RuleList.Query
    ) async throws -> Int
}
