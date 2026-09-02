//
//  PermissionRepository.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

public protocol PermissionRepository: Repository {

    func insert(
        _ model: Permission.New
    ) async throws -> Permission

    func update(
        _ model: Permission
    ) async throws -> Permission

    func find(
        id: String
    ) async throws -> Permission?

    func delete(
        ids: [String]
    ) async throws -> Bool
}
