//
//  InvitationRepository.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

public protocol InvitationRepository: Repository {

    func findBy(
        id: String
    ) async throws -> Invitation?

    func findBy(
        token: String
    ) async throws -> Invitation?

    func insert(
        _ model: Invitation.New
    ) async throws -> Invitation

    func update(
        _ model: Invitation
    ) async throws -> Invitation

    func delete(
        ids: [String]
    ) async throws -> [String]
}
