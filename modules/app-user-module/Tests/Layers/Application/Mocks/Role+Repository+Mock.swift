//
//  MockRoleRepository.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import UserDomain
import UserModule

actor MockRoleRepository: Role.Repository.Interface {
    private(set) var createCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var findCallCount = 0
    private(set) var deleteCallCount = 0

    private let result: Role.Model
    private let findResult: Role.Model?
    private let deleteResult: [String]

    init(
        result: Role.Model,
        findResult: Role.Model? = nil,
        deleteResult: [String] = []
    ) {
        self.result = result
        self.findResult = findResult
        self.deleteResult = deleteResult
    }

    func findBy(
        id: String
    ) async throws -> Role.Model? {
        findCallCount += 1
        return findResult
    }

    func findBy(
        name: String
    ) async throws -> Role.Model? {
        findCallCount += 1
        return findResult
    }

    func findBy(
        key: String
    ) async throws -> Role.Model? {
        findCallCount += 1
        return findResult
    }

    func insert(
        _ model: Role.Model.New
    ) async throws -> Role.Model {
        createCallCount += 1
        return result
    }

    func update(
        _ model: Role.Model
    ) async throws -> Role.Model {
        updateCallCount += 1
        return model
    }

    func delete(
        ids: [String]
    ) async throws -> [String] {
        deleteCallCount += 1
        return deleteResult
    }
}
