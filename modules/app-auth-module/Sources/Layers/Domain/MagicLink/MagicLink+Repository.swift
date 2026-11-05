//
//  MagicLink+Repository.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import AuthModule
public import FeatherDomain

extension MagicLink {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func findById(
                id: String
            ) async throws -> Model?

            func insert(
                _ model: Model.New
            ) async throws -> Model

            func update(
                _ model: Model
            ) async throws -> Model

            func consumeByToken(
                token: String
            ) async throws -> Model

            func delete(
                ids: [String]
            ) async throws -> [String]
        }
    }
}
