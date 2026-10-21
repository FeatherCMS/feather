//
//  Role.Repository.Interface.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import AuthModule
public import FeatherDomain

extension RolePermission.Repository {

    public protocol Interface: FeatherDomain.Repository {

        func findBy(
            roleId: String,
            permissionId: String
        ) async throws -> RolePermission.Model?

        func insert(
            _ model: RolePermission.Model.New
        ) async throws -> RolePermission.Model

        func update(
            roleId: String,
            permissionId: String,
            _ model: RolePermission.Model.New
        ) async throws -> RolePermission.Model

        func delete(ids: [String]) async throws -> [String]
    }

}
