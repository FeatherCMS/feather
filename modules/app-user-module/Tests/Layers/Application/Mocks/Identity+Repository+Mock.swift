//
//  Identity+Repository+Mock.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 07. 16.

import UserDomain
import UserModule

actor MockIdentityRepository: Identity.Repository.Interface {
    private(set) var createCallCount = 0
    private(set) var insertedModel: Identity.Model.New?
    private(set) var updateCallCount = 0
    private(set) var replaceRoleIdsCallCount = 0
    private(set) var replacedRoleIds: [String] = []
    private(set) var findByIdCallCount = 0
    private(set) var deleteCallCount = 0
    private(set) var findRoleIdsCallCount = 0

    private let result: Identity.Model
    private let findByIdResult: Identity.Model?
    private let deleteResult: [String]
    private let roleIdsResult: [String]

    init(
        result: Identity.Model,
        findByIdResult: Identity.Model? = nil,
        deleteResult: [String] = [],
        roleIdsResult: [String] = []
    ) {
        self.result = result
        self.findByIdResult = findByIdResult
        self.deleteResult = deleteResult
        self.roleIdsResult = roleIdsResult
    }

    func findBy(
        id: String
    ) async throws -> Identity.Model? {
        findByIdCallCount += 1
        return findByIdResult
    }

    func findRoot() async throws -> Identity.Model? {
        findByIdResult
    }

    func findRoleIdsBy(
        identityId: String
    ) async throws -> [String] {
        findRoleIdsCallCount += 1
        return roleIdsResult
    }

    func replaceRoleIds(
        identityId: String,
        roleIds: [String]
    ) async throws {
        replaceRoleIdsCallCount += 1
        replacedRoleIds = roleIds
    }

    func insert(
        _ model: Identity.Model.New
    ) async throws -> Identity.Model {
        createCallCount += 1
        insertedModel = model
        return result
    }

    func update(
        _ model: Identity.Model
    ) async throws -> Identity.Model {
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
