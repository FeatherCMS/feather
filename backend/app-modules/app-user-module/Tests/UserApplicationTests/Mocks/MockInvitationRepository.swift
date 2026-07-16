//
//  MockInvitationRepository.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import UserDomain

actor MockInvitationRepository: InvitationRepository {
    private(set) var createCallCount = 0
    private(set) var insertedModel: Invitation.New?
    private(set) var deleteCallCount = 0

    private let result: Invitation
    private let findByTokenResult: Invitation?
    private let deleteResult: Bool

    init(
        result: Invitation,
        findByTokenResult: Invitation? = nil,
        deleteResult: Bool = false
    ) {
        self.result = result
        self.findByTokenResult = findByTokenResult
        self.deleteResult = deleteResult
    }

    func findBy(
        id: String
    ) async throws -> Invitation? {
        nil
    }

    func findBy(
        token: String
    ) async throws -> Invitation? {
        findByTokenResult
    }

    func insert(
        _ model: Invitation.New
    ) async throws -> Invitation {
        createCallCount += 1
        insertedModel = model
        return result
    }

    func update(
        _ model: Invitation
    ) async throws -> Invitation {
        model
    }

    func delete(
        id: String
    ) async throws -> Bool {
        deleteCallCount += 1
        return deleteResult
    }
}
