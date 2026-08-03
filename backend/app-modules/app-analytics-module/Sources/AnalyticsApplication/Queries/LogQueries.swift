//
//  LogQueries.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 06. 18.

public protocol LogQueries: Sendable {

    func find(
        id: String
    ) async throws -> LogDetail

    func overview(
        query: LogOverview.Query
    ) async throws -> LogOverview

    func list(
        query: LogList.Query
    ) async throws -> LogList

    func count(
        query: LogList.Query
    ) async throws -> Int
}
