//
//  SessionRepository.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import AuthModule
public import FeatherDomain

extension Session.Repository {

    public protocol Interface: FeatherDomain.Repository {

        func findBy(
            id: String
        ) async throws -> Session.Model?

        func findBy(
            token: String
        ) async throws -> Session.Model?

        func insert(
            _ model: Session.Model.New
        ) async throws -> Session.Model

        func update(
            _ model: Session.Model
        ) async throws -> Session.Model

        func delete(
            ids: [String]
        ) async throws -> [String]
    }

}
