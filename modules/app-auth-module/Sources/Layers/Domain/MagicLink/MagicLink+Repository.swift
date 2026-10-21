//
//  MagicLinkRepository.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import AuthModule
public import FeatherDomain

extension MagicLink.Repository {

    public protocol Interface: FeatherDomain.Repository {

        func findById(
            id: String
        ) async throws -> MagicLink.Model?

        func insert(
            _ model: MagicLink.Model.New
        ) async throws -> MagicLink.Model

        func update(
            _ model: MagicLink.Model
        ) async throws -> MagicLink.Model

        func consumeByToken(
            token: String
        ) async throws -> MagicLink.Model

        func delete(
            ids: [String]
        ) async throws -> [String]
    }

}
