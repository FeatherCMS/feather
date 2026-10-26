//
//  RolePermission+Repository.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import AuthModule
public import FeatherDomain

extension RolePermission {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func findBy(
                roleId: String,
                permissionId: String
            ) async throws -> Model?

            func insert(
                _ model: Model.New
            ) async throws -> Model

            func update(
                roleId: String,
                permissionId: String,
                _ model: Model.New
            ) async throws -> Model

            func delete(ids: [String]) async throws -> [String]
        }
    }
}
