//
//  InviationQueries.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AccountDomain

public protocol InvitationQueries: Sendable {

    func getBy(
        id: String
    ) async throws -> InvitationDetail

    func list(
        query: InvitationList.Query
    ) async throws -> InvitationList

    func count(
        query: InvitationList.Query
    ) async throws -> Int
}
