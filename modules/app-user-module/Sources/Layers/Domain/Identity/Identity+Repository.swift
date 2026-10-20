//
//  Identity.Repository.Interface.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain
public import UserModule

extension Identity {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func findBy(
                id: String
            ) async throws -> Identity.Model?

            func findRoot() async throws -> Identity.Model?

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
                _ model: Identity.Model.New
            ) async throws -> Identity.Model

            func update(
                _ model: Identity.Model
            ) async throws -> Identity.Model

            func replaceRoleIds(
                identityId: String,
                roleIds: [String]
            ) async throws

            func delete(
                ids: [String]
            ) async throws -> [String]

        }
    }
}
