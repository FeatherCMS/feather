//
//  RoleQueries.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import UserDomain

public protocol RoleQueries: Sendable {

    func list(
        query: RoleList.Query
    ) async throws -> RoleList

    func count(
        query: RoleList.Query
    ) async throws -> Int

    func getBy(
        id: String
    ) async throws -> RoleDetail
}
