import AccountDomain
import AccountModule
import UserDomain

//
//  MockInvitationRepository.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

actor MockInvitationRepository: Invitation.Repository.Interface {
    private(set) var createCallCount = 0
    private(set) var insertedModel: Invitation.Model.New?
    private(set) var deleteCallCount = 0
    private(set) var updateCallCount = 0

    private let result: Invitation.Model
    private let findByTokenResult: Invitation.Model?
    private let deleteResult: Bool

    init(
        result: Invitation.Model,
        findByTokenResult: Invitation.Model? = nil,
        deleteResult: Bool = false
    ) {
        self.result = result
        self.findByTokenResult = findByTokenResult
        self.deleteResult = deleteResult
    }

    func findBy(
        id: String
    ) async throws -> Invitation.Model? {
        id == result.id ? result : nil
    }

    func findBy(
        token: String
    ) async throws -> Invitation.Model? {
        findByTokenResult
    }

    func insert(
        _ model: Invitation.Model.New
    ) async throws -> Invitation.Model {
        createCallCount += 1
        insertedModel = model
        return result
    }

    func update(
        _ model: Invitation.Model
    ) async throws -> Invitation.Model {
        updateCallCount += 1
        return model
    }

    func delete(
        ids: [String]
    ) async throws -> [String] {
        deleteCallCount += 1
        return deleteResult ? ids.filter { $0 == result.id } : []
    }
}
