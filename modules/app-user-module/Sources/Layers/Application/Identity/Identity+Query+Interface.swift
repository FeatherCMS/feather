//
//  Identity.Query.Interface.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import UserModule

extension Identity.Query {
    public protocol Interface: Sendable {

        func search(
            query: Identity.Search.Input.Query
        ) async throws -> Identity.Search.Output

        func getBy(
            id: String
        ) async throws -> Identity.Detail.Output

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
}
