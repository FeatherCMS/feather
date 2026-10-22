//
//  LogQueries.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import AnalyticsDomain

public protocol LogQueries: Sendable {

    func find(
        id: String
    ) async throws -> Log.Detail.Output

    func overview(
        query: Log.Overview.Input.Query
    ) async throws -> Log.Overview.Output

    func list(
        query: Log.List.Input.Query
    ) async throws -> Log.List.Output

    func count(
        query: Log.List.Input.Query
    ) async throws -> Int
}
