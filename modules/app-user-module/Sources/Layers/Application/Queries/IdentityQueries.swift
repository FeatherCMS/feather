//
//  IdentityQueries.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import UserDomain

public protocol IdentityQueries: Sendable {

    func list(
        query: IdentityList.Query
    ) async throws -> IdentityList

    func count(
        query: IdentityList.Query
    ) async throws -> Int

    func getBy(
        id: String
    ) async throws -> IdentityDetail

    func getRolesBy(
        identityId: String
    ) async throws -> [String]

    func getRoleIdsBy(
        identityId: String
    ) async throws -> [String]

    func getPermissionsBy(
        identityId: String
    ) async throws -> [String]

}
