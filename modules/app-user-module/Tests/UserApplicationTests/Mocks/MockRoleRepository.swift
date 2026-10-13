//
//  MockRoleRepository.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import UserDomain

actor MockRoleRepository: RoleRepository {
    private(set) var createCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var findCallCount = 0
    private(set) var deleteCallCount = 0

    private let result: Role
    private let findResult: Role?
    private let deleteResult: [String]

    init(
        result: Role,
        findResult: Role? = nil,
        deleteResult: [String] = []
    ) {
        self.result = result
        self.findResult = findResult
        self.deleteResult = deleteResult
    }

    func findBy(
        id: String
    ) async throws -> Role? {
        findCallCount += 1
        return findResult
    }

    func findBy(
        name: String
    ) async throws -> Role? {
        findCallCount += 1
        return findResult
    }

    func insert(
        _ model: Role.New
    ) async throws -> Role {
        createCallCount += 1
        return result
    }

    func update(
        _ model: Role
    ) async throws -> Role {
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
