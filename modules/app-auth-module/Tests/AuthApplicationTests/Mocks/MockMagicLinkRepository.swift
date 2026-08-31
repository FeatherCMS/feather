//
//  MockMagicLinkRepository.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain

actor MockMagicLinkRepository: MagicLinkRepository {
    private(set) var insertCallCount = 0
    private(set) var deleteCallCount = 0
    private(set) var consumeCallCount = 0
    private(set) var consumedToken: String?

    private let result: MagicLink
    private let deleteResult: Bool
    private let consumeError: MagicLink.Error?

    init(
        result: MagicLink,
        deleteResult: Bool = false,
        consumeError: MagicLink.Error? = nil
    ) {
        self.result = result
        self.deleteResult = deleteResult
        self.consumeError = consumeError
    }

    func findById(
        id: String
    ) async throws -> MagicLink? {
        nil
    }

    func insert(
        _ model: MagicLink.New
    ) async throws -> MagicLink {
        insertCallCount += 1
        return result
    }

    func update(
        _ model: MagicLink
    ) async throws -> MagicLink {
        return model
    }

    func consumeByToken(
        token: String
    ) async throws -> MagicLink {
        consumeCallCount += 1
        consumedToken = token
        if let consumeError {
            throw consumeError
        }
        return result
    }

    func delete(
        id: String
    ) async throws -> Bool {
        deleteCallCount += 1
        return deleteResult
    }
}
