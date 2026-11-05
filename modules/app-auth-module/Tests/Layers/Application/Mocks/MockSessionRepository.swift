import AuthDomain
import AuthModule

//
//  MockSessionRepository.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

actor MockSessionRepository: Session.Repository.Interface {
    private(set) var findByTokenCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var deleteCallCount = 0

    private let tokenFindResult: Session.Model?
    private let deleteResult: Bool

    init(
        tokenFindResult: Session.Model? = nil,
        deleteResult: Bool = false
    ) {
        self.tokenFindResult = tokenFindResult
        self.deleteResult = deleteResult
    }

    func findBy(
        id: String
    ) async throws -> Session.Model? {
        nil
    }

    func findBy(
        token: String
    ) async throws -> Session.Model? {
        findByTokenCallCount += 1
        return tokenFindResult
    }

    func insert(
        _ model: Session.Model.New
    ) async throws -> Session.Model {
        fatalError("not needed in tests")
    }

    func update(
        _ model: Session.Model
    ) async throws -> Session.Model {
        updateCallCount += 1
        return model
    }

    func delete(
        ids: [String]
    ) async throws -> [String] {
        deleteCallCount += 1
        return deleteResult ? ids : []
    }
}
