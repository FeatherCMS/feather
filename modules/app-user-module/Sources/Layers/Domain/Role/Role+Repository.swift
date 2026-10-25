//
//  Role+Repository.swift
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
            ) async throws -> Model?

            func findBy(
                name: String
            ) async throws -> Model?

            func findBy(
                key: String
            ) async throws -> Model?

            func insert(
                _ model: Model.New
            ) async throws -> Model

            func update(
                _ model: Model
            ) async throws -> Model

            func delete(
                ids: [String]
            ) async throws -> [String]
        }
    }
}
