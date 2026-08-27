//
//  MockIdentityRepository.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 07. 16.

import UserDomain

actor MockIdentityRepository: IdentityRepository {
    private(set) var createCallCount = 0
    private(set) var insertedModel: Identity.New?
    private(set) var updateCallCount = 0
    private(set) var replaceRoleIdsCallCount = 0
    private(set) var replacedRoleIds: [String] = []
    private(set) var findByIdCallCount = 0
    private(set) var deleteCallCount = 0

    private let result: Identity
    private let findByIdResult: Identity?
    private let deleteResult: Bool

    init(
        result: Identity,
        findByIdResult: Identity? = nil,
        deleteResult: Bool = false
    ) {
        self.result = result
        self.findByIdResult = findByIdResult
        self.deleteResult = deleteResult
    }

    func findBy(
        id: String
    ) async throws -> Identity? {
        findByIdCallCount += 1
        return findByIdResult
    }

    func findRoot() async throws -> Identity? {
        findByIdResult
    }

    func findRolesBy(
        identityId: String
    ) async throws -> [String] {
        []
    }

    func findRoleIdsBy(
        identityId: String
    ) async throws -> [String] {
        []
    }

    func replaceRoleIds(
        identityId: String,
        roleIds: [String]
    ) async throws {
        replaceRoleIdsCallCount += 1
        replacedRoleIds = roleIds
    }

    func findPermissionsBy(
        identityId: String
    ) async throws -> [String] {
        []
    }

    func insert(
        _ model: Identity.New
    ) async throws -> Identity {
        createCallCount += 1
        insertedModel = model
        return result
    }

    func update(
        _ model: Identity
    ) async throws -> Identity {
        updateCallCount += 1
        return model
    }

    func delete(
        id: String
    ) async throws -> Bool {
        deleteCallCount += 1
        return deleteResult
    }
}
