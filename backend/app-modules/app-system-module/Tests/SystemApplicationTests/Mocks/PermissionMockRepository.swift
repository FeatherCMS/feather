//
//  File.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

import SystemDomain

actor PermissionMockRepository: PermissionRepository {

    private(set) var lastCreateInput: Permission.New?
    private(set) var createCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var findCallCount = 0
    private(set) var deleteCallCount = 0
    private(set) var lastFindId: String?
    private(set) var lastDeleteId: String?

    private let result: Result<Permission, Error>
    private let findResult: Permission?
    private let deleteResult: Bool

    init(
        result: Result<Permission, Error>,
        findResult: Permission? = nil,
        deleteResult: Bool = false
    ) {
        self.result = result
        self.findResult = findResult
        self.deleteResult = deleteResult
    }

    func insert(
        _ model: Permission.New
    ) async throws -> Permission {
        createCallCount += 1
        lastCreateInput = model
        return try result.get()
    }

    func update(
        _ model: Permission
    ) async throws -> Permission {
        updateCallCount += 1
        return model
    }

    func find(
        id: String
    ) async throws -> Permission? {
        findCallCount += 1
        lastFindId = id
        return findResult
    }

    func delete(
        id: String
    ) async throws -> Bool {
        deleteCallCount += 1
        lastDeleteId = id
        return deleteResult
    }
}
