//
//  IdentityRepository.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

public protocol IdentityRepository: Repository {

    func findBy(
        id: String
    ) async throws -> Identity?

    func findRoot() async throws -> Identity?

    func findRolesBy(
        identityId: String
    ) async throws -> [String]

    func findRoleIdsBy(
        identityId: String
    ) async throws -> [String]

    func findPermissionsBy(
        identityId: String
    ) async throws -> [String]

    func insert(
        _ model: Identity.New
    ) async throws -> Identity

    func update(
        _ model: Identity
    ) async throws -> Identity

    func replaceRoleIds(
        identityId: String,
        roleIds: [String]
    ) async throws

    func delete(
        ids: [String]
    ) async throws -> [String]

}
