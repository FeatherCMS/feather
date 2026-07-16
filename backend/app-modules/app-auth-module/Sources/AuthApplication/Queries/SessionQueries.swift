//
//  SessionQueries.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain

public protocol SessionQueries: Sendable {

    func find(
        id: String
    ) async throws -> SessionDetail

    func list(
        query: SessionList.Query
    ) async throws -> SessionList
}
