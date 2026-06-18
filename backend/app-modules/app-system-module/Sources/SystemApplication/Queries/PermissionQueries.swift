//
//  File.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

public protocol PermissionQueries: Sendable {

    func find(
        id: String
    ) async throws -> PermissionDetail

    func list(
        query: PermissionList.Query
    ) async throws -> PermissionList

    func count(
        query: PermissionList.Query
    ) async throws -> Int
}
