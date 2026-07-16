//
//  AccountQueries.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import UserDomain

public protocol AccountQueries: Sendable {

    func list(
        query: AccountList.Query
    ) async throws -> AccountList

    func count(
        query: AccountList.Query
    ) async throws -> Int

    func getBy(
        id: String
    ) async throws -> AccountDetail

    func getRolesBy(
        accountId: String
    ) async throws -> [String]

    func getRoleIdsBy(
        accountId: String
    ) async throws -> [String]

    func getPermissionsBy(
        accountId: String
    ) async throws -> [String]

}
