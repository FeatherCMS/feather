//
//  Identity+Repository.swift
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
            ) async throws -> Model?

            func findRoot() async throws -> Model?

            func findRoleIdsBy(
                identityId: String
            ) async throws -> [String]

            func insert(
                _ model: Model.New
            ) async throws -> Model

            func update(
                _ model: Model
            ) async throws -> Model

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
