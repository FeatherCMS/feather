import AuthDomain
import AuthModule

//
//  MockMagicLinkRepository.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

actor MockMagicLinkRepository: MagicLink.Repository.Interface {
    private(set) var insertCallCount = 0
    private(set) var deleteCallCount = 0
    private(set) var consumeCallCount = 0
    private(set) var consumedToken: String?

    private let result: MagicLink.Model
    private let deleteResult: Bool
    private let consumeError: MagicLink.Model.Error?

    init(
        result: MagicLink.Model,
        deleteResult: Bool = false,
        consumeError: MagicLink.Model.Error? = nil
    ) {
        self.result = result
        self.deleteResult = deleteResult
        self.consumeError = consumeError
    }

    func findById(
        id: String
    ) async throws -> MagicLink.Model? {
        nil
    }

    func insert(
        _ model: MagicLink.Model.New
    ) async throws -> MagicLink.Model {
        insertCallCount += 1
        return result
    }

    func update(
        _ model: MagicLink.Model
    ) async throws -> MagicLink.Model {
        model
    }

    func consumeByToken(
        token: String
    ) async throws -> MagicLink.Model {
        consumeCallCount += 1
        consumedToken = token
        if let consumeError {
            throw consumeError
        }
        return result
    }

    func delete(
        ids: [String]
    ) async throws -> [String] {
        deleteCallCount += 1
        return deleteResult ? ids : []
    }
}
