//
//  RuleMockRepository.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

import RedirectDomain

actor RuleMockRepository: RedirectModule.Rule.Repository.Interface {

    private(set) var lastCreateInput: RedirectModule.Rule.Model.New?
    private(set) var createCallCount = 0
    private(set) var updateCallCount = 0
    private(set) var findCallCount = 0
    private(set) var deleteCallCount = 0
    private(set) var lastFindId: String?
    private(set) var lastFindSource: String?
    private(set) var lastDeleteId: String?

    private let result: Result<RedirectModule.Rule.Model, Error>
    private let findResult: RedirectModule.Rule.Model?
    private let deleteResult: Bool

    init(
        result: Result<RedirectModule.Rule.Model, Error>,
        findResult: RedirectModule.Rule.Model? = nil,
        deleteResult: Bool = false
    ) {
        self.result = result
        self.findResult = findResult
        self.deleteResult = deleteResult
    }

    func insert(
        _ model: RedirectModule.Rule.Model.New
    ) async throws -> RedirectModule.Rule.Model {
        createCallCount += 1
        lastCreateInput = model
        return try result.get()
    }

    func update(
        _ model: RedirectModule.Rule.Model
    ) async throws -> RedirectModule.Rule.Model {
        updateCallCount += 1
        return model
    }

    func find(
        id: String
    ) async throws -> RedirectModule.Rule.Model? {
        findCallCount += 1
        lastFindId = id
        return findResult
    }

    func find(
        source: String
    ) async throws -> RedirectModule.Rule.Model? {
        findCallCount += 1
        lastFindSource = source
        return findResult
    }

    func delete(
        ids: [String]
    ) async throws -> [String] {
        deleteCallCount += 1
        lastDeleteId = ids.first
        return deleteResult ? ids : []
    }
}
