import AuthDomain
import AuthModule

//
//  MockRolePermissionRepository.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

actor MockRolePermissionRepository: RolePermission.Repository
        .Interface
{
    private(set) var insertCallCount = 0
    private(set) var deleteCallCount = 0

    private let result: RolePermission.Model
    private let deleteResult: Bool

    init(
        result: RolePermission.Model,
        deleteResult: Bool = false
    ) {
        self.result = result
        self.deleteResult = deleteResult
    }

    func findBy(
        roleId: String,
        permissionId: String
    ) async throws -> RolePermission.Model? {
        nil
    }

    func insert(
        _ model: RolePermission.Model.New
    ) async throws -> RolePermission.Model {
        insertCallCount += 1
        return result
    }

    func update(
        roleId: String,
        permissionId: String,
        _ model: RolePermission.Model.New
    ) async throws -> RolePermission.Model {
        result
    }

    func delete(ids: [String]) async throws -> [String] {
        deleteCallCount += 1
        return deleteResult ? ids : []
    }
}
