//
//  SessionRepository.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Domain

public protocol SessionRepository: Repository {

    func findBy(
        id: String
    ) async throws -> Session?

    func findBy(
        token: String
    ) async throws -> Session?

    func insert(
        _ model: Session.New
    ) async throws -> Session

    func update(
        _ model: Session
    ) async throws -> Session

    func delete(
        id: String
    ) async throws -> Bool
}
