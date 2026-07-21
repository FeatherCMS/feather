//
//  MagicLinkQueries.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain

public protocol MagicLinkQueries: Sendable {

    func find(
        id: String
    ) async throws -> MagicLinkDetail

    func list(
        query: MagicLinkList.Query
    ) async throws -> MagicLinkList

    func count(
        query: MagicLinkList.Query
    ) async throws -> Int
}
