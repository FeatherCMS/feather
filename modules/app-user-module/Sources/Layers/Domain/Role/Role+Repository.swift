//
//  Role.Repository.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain
public import UserModule

extension Role {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func findBy(
                id: String
            ) async throws -> Role.Model?

            func findBy(
                name: String
            ) async throws -> Role.Model?

            func findBy(
                key: String
            ) async throws -> Role.Model?

            func insert(
                _ model: Role.Model.New
            ) async throws -> Role.Model

            func update(
                _ model: Role.Model
            ) async throws -> Role.Model

            func delete(
                ids: [String]
            ) async throws -> [String]
        }
    }
}
